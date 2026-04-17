# Use Rails cache (Redis in production, memory in development/test)
Rack::Attack.cache.store = Rails.cache

# Constants for API token validation
API_TOKEN_LENGTH = 24 # has_secure_token and migration both generate 24-char tokens

# Helper: validate token format and check if valid (with secure caching)
def self.valid_api_token?(token)
  # Pre-check: token must be present and exactly 24 characters
  return false if token.blank? || token.length != API_TOKEN_LENGTH

  # Generate SHA256 digest for cache key (never store raw token in cache)
  token_digest = Digest::SHA256.hexdigest(token)
  cache_key = "api-token-valid:#{token_digest}"

  # Only cache positive lookups (valid tokens) for 5 minutes
  # Invalid tokens are NOT cached to prevent Redis pollution from brute-force attempts
  cached_result = Rails.cache.read(cache_key)
  return cached_result if cached_result == true

  # Check database
  token_valid = User.exists?(api_token: token)

  # Cache only if valid
  Rails.cache.write(cache_key, true, expires_in: 5.minutes) if token_valid

  token_valid
end

# Always allow requests from localhost
# (blocklist & throttles are skipped)
Rack::Attack.safelist("allow from localhost") do |req|
  # Requests are allowed if the return value is truthy
  %w[127.0.0.1 ::1].include?(req.ip)
end

# Block requests from specific IPs
Rack::Attack.throttle("limit logins per email", limit: 6, period: 60) do |req|
  req.ip if req.path.include?("users") && !req.get?
end

# Throttle API bearer token requests per IP (prevents brute force scanning)
Rack::Attack.throttle("api/bearer/ip", limit: 60, period: 1.minute) do |req|
  if req.path.match?(%r{^/home}) && req.get_header("HTTP_AUTHORIZATION")&.start_with?("Bearer ")
    req.ip
  end
end

# Fail2Ban: block IPs that provide invalid bearer tokens
# After 10 invalid attempts in 10 minutes, ban for 1 hour
Rack::Attack.blocklist("api/fail2ban") do |req|
  # Only evaluate if bearer token is provided
  if req.path.match?(%r{^/home}) && req.get_header("HTTP_AUTHORIZATION")&.start_with?("Bearer ")
    # Extract the token
    token = req.get_header("HTTP_AUTHORIZATION").sub(/^Bearer /, "")

    # Check if token is valid (with secure caching)
    token_valid = Rack::Attack.valid_api_token?(token)

    # Track failed attempts by IP
    discriminator = "api-bearer-fail:#{req.ip}"

    # Fail2Ban filter: count this as a failure if token is invalid
    Rack::Attack::Fail2Ban.filter(discriminator, maxretry: 10, findtime: 10.minutes, bantime: 1.hour) do
      !token_valid # true = count as failed attempt
    end
  end
end
