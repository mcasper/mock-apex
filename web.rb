require "sinatra"
require "pry"

configure do
  set :bind, "0.0.0.0"
end

VALID_LEVELS = [
  "debug",
  "info",
  "notice",
  "warning",
  "error",
  "critical",
  "alert",
  "emergency",
]

def validate_level(level)
  halt 400 if !VALID_LEVELS.include?(level)
end

def validate_keys(data, keys_to_types)
  keys_to_types.each do |key, type|
    if !data.has_key?(key)
      halt 400
    end

    if !data[key].is_a?(type)
      halt 400
    end
  end
end

before "/*" do
  auth = env["HTTP_AUTHORIZATION"]
  if auth != "Bearer #{ENV["MOCK_API_TOKEN"]}"
    halt 401
  end
end

post "/add_events" do
  data = JSON.parse(request.body.read)
  puts data
  validate_keys(data, {"project_id" => String, "events" => Array})

  data.fetch("events").each do |event|
    validate_keys(event, {"message" => String, "level" => String})
    validate_level(event.fetch("level"))
  end

  ""
end
