require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "date"

nasa_api_key = ENV["NASA_API_KEY"]

get("/") do
  redirect "/birthday"
end

get("/birthday") do
  erb(:birthday_new)
end

post("/birthday/results") do
  nasa_url = nil
  year, month, day = params[:birthday].split('-').map(&:to_i)
  @birthday = Date.new(year, month, day)
  if @birthday.year < 1996
    # Update the year to 1996
    birthday = Date.new(1996, @birthday.month, @birthday.day)
    nasa_url = "https://api.nasa.gov/planetary/apod?date=#{birthday}&api_key=#{nasa_api_key}"
  else
    nasa_url = "https://api.nasa.gov/planetary/apod?date=#{@birthday}&api_key=#{nasa_api_key}"
  end
  nasa_raw = HTTP.get(nasa_url)
  nasa_parsed = JSON.parse(nasa_raw)
  @image = nasa_parsed.dig("url")
  @whole_message = nasa_parsed.dig("explanation").split(/(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?)\s/)
  @general_message = @whole_message.first(2).join(' ')
  @whole_message = @whole_message[2..-1].join('')

  erb(:birthday_results)
end
