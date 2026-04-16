# Use Rails cache (Redis in production, memory in development/test)
Rack::Attack.cache.store = Rails.cache

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

    # Cache token existence briefly to avoid a DB lookup on every request
    token_exists = Rails.cache.fetch("api-token-exists:#{token}", expires_in: 5.minutes) do
      User.exists?(api_token: token)
    end
    discriminator = "api-bearer-fail:#{req.ip}"

    # Mark as failed attempt if token doesn't exist
    unless token_exists
      # Track this failed attempt
      Rack::Attack::Fail2Ban.filter(discriminator, maxretry: 10, findtime: 10.minutes, bantime: 1.hour) do
        true # count this as a failed attempt
      end
    end
  end
end
