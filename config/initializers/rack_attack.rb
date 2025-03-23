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
