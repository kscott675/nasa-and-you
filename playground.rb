require 'date'

date_object = Date.new(2022, 5, 15)
  month = date_object.strftime('%b %d')  # Full month name


puts "Month: #{month}"
