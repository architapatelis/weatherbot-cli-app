# CLI Controller

class Weatherbot::CLI


  def call
    puts "
           __   __  ___           ___   __   __   __
          |  | |  ||   |         |   | |  | |  |_|  |
          |  |_|  ||   |         |   | |__| |       |
          |       ||   |         |   |      |       |
          |       ||   |  ___    |   |      |       |
          |   _   ||   | |_  |   |   |      | ||_|| |
          |__| |__||___|   |_|   |___|      |_|   |_|
           _     _  _______  _______  _______  __   __  _______  ______    _______  _______  _______  __
          | | _ | ||       ||   _   ||       ||  | |  ||       ||    _ |  |  _    ||       ||       ||  |
          | || || ||    ___||  |_|  ||_     _||  |_|  ||    ___||   | ||  | |_|   ||   _   ||_     _||  |
          |       ||   |___ |       |  |   |  |       ||   |___ |   |_||_ |       ||  | |  |  |   |  |  |
          |       ||    ___||       |  |   |  |       ||    ___||    __  ||  _   | |  |_|  |  |   |  |__|
          |   _   ||   |___ |   _   |  |   |  |   _   ||   |___ |   |  | || |_|   ||       |  |   |   __
          |__| |__||_______||__| |__|  |___|  |__| |__||_______||___|  |_||_______||_______|  |___|  |__|

          "
    sleep(1)

    intro
    menu
  end

  def intro
    puts "\n\nI'm a command line interface Ruby gem that gives you current and forecast weather for any location in the world!\n\n"
  end

  def menu
    input = nil

    while input != "exit"

      puts "\n-------------------------------\n"
      puts "\nPlease enter a specific location in the format: <location>, <country> to check the current weather conditions for that location. You can also search by <location>, <state/region>, <country> to find the correct specific location.
      \nType 'map' to open the most relevant result in your OS default browser.
      \nType 'list' to see a list of previous locations.
      \n*NOTE: This will open your web browser to the most likely location coordinates in Google Maps.*
      \nYou can also type 'forecast' to display the 3 day forecast of the most recent search. To quit, type 'exit'.\n"
      puts "\n-------------------------------\n"

      input = gets.chomp.downcase

      # Check if user wants to exit
      if input === "exit"
        puts "\n\n\nSee you again soon!\n\n\n"
        exit
      end
      # Check if user wants to enter invalid input before location
      if input === "forecast" || input === "map"
        puts "\n\n\nYou need to input a location first!\n\n\n"
        menu
      end

      # Display current weather
      weather = Weatherbot::API.current_weather(input)



      display_weather(weather)

      new_input = gets.chomp.downcase

      # Check for specific input commands
      if new_input === "exit"
        puts "\n\n\nSee you again soon!\n\n\n"
        exit
      end
      # Display forecast or location map
      if new_input === "forecast"
        Weatherbot::API.forecast(input)
        menu
      elsif new_input === "list"
        display_previous
      elsif new_input === "map"
        Weatherbot::API.open_link
        menu
      else
        input = nil
        menu
      end

      end

  end

  def display_weather(weather)
    puts "\n\nReport Time:      #{weather.report_time}"
    puts "Location:         #{weather.location_name}, #{weather.country}"
    puts "Coordinates:      #{weather.coordinates}"
    puts "Google Maps:      #{weather.google_maps}"
    puts "\nTemperature:      #{weather.temp_avg}ºF / #{weather.temp_celsius}ºC"
    puts "Condition:        #{weather.condition.capitalize}"
    puts "Cloudiness:       #{weather.cloudiness}%"
    puts "\nHumidity:         #{weather.humidity}%"
    puts "Wind Speed:       #{weather.wind_speed} mph"
    puts "Wind Direction:   #{weather.wind_direction}"
    puts "\nSunrise:          #{weather.sunrise}"
    puts "Sunset:           #{weather.sunset}"
  end

  def display_previous
    Weatherbot::API.locations.map { |entry| puts entry.location_name }
  end


end
