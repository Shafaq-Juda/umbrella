line_width = 35

puts "=" * line_width
pp "Will you need an umbrella today?"
puts "=" * line_width

pp "Where are you located?"

user_location = gets.chomp.gsub(" ", "%20")

pp "Checking the weather at " + user_location + "...."


maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

require "http"

resp = HTTP.get(maps_url)

raw_response = resp.to_s

require "json"

parsed_response = JSON.parse(raw_response)

results = parsed_response.fetch("results")

first_result = results.at(0)
geo = first_result.fetch("geometry")

# Take the lat/lng
loc = geo.fetch("location")
lat = loc.fetch("lat")
lng = loc.fetch("lng")

pp "Your coordinates are " + lat.to_s + ", " + lng.to_s + "."

# Assemble the correct URL for the pirate weather API
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_key +"/" + lat.to_s+ "," + lng.to_s

# Get it, parse it and dig out the correct temperature

require "http"

resp2 = HTTP.get(weather_url)

raw_response2 = resp2.to_s

require "json"

parsed_response2 = JSON.parse(raw_response2)
# ppparsed_response2.keys 
 
currently = parsed_response2.fetch("currently")
current_temp = currently.fetch("temperature")

pp "It is currently " + current_temp.to_s + " F."

hourly = parsed_response2.fetch("hourly")

data = hourly.fetch("data")

# pp data.class #it is an array
next_hour_weather = data.at(0)
next_hour = next_hour_weather.fetch("summary")
pp "Next Hour would be: " + next_hour

if next_hour == "Clear"
  pp "You probably won't need an umbrella!"
elsif next_hour == "Cloudy"
  pp "You probably won't need an umbrella!"
elsif next_hour == "Partly Cloudy"
  pp "You probably won't need an umbrella!"  
elsif next_hour == "Rain"
  pp "You might want to carry an umbrella!"  
end
