#selenium-elements-cli-app
require 'awesome_print'
require 'colorize'
require 'selenium-webdriver'
require 'appium_lib'

puts "\nUse this CLI app to make sure your xpath|css elements exist".colorize(:cyan)
puts "Type exit|quit when you want to exit".colorize(:red)

exit_regex = Regexp.new(/^(?:quit|exit)\s*$/i)
css_regex = Regexp.new(/^(?:css)\s*$/i)
xpath_regex = Regexp.new(/^(?:xpath)\s*$/i)
next_regex = Regexp.new(/^(?:next)\s*$/i)

input_correct = false

until input_correct
  puts "-------------------------------------------------------------".colorize(:light_green)
  puts "Which Selenium driver would you like to use (Browser|Appium)?".colorize(:blue)

  driver_type_input = gets
  driver_type_input = driver_type_input.gsub(/\s*$/, '').downcase

  if driver_type_input.match(exit_regex)
    exit
  end

  case driver_type_input
    when 'browser'
      platform_input_correct = false
      until platform_input_correct
        puts 'Please input which browser you would like to use (Chrome, Firefox, Opera, Safari, IE)?'.colorize(:blue)
        platform_input = gets
        platform_input = platform_input.gsub(/\s*$/, '').downcase

        if platform_input.match(exit_regex)
          exit
        end


        case platform_input
          when 'chrome'
            platform_name = :chrome
          when 'firefox'
            platform_name = :firefox
          when 'opera'
            platform_name = :opera
          when 'safari'
            platform_name = :safari
          when 'ie'
            platform_name = :ie
          else
            puts "Didn't understand command, type (Chrome, Firefox, Opera, Safari, IE)".colorize(:red)
            next
        end

        break
      end

      #Break out of input loop
      break

    when 'appium'
      platform_input_correct = false
      until platform_input_correct
        puts "Which Appium platform would you like to use (Android|Ios)?".colorize(:blue)
        platform_input = gets
        platform_input = platform_input.gsub(/\s*$/, '').downcase

        if platform_input.match(exit_regex)
          exit
        end

        case platform_input
          when 'android'
            platform_name = :android
          when 'ios'
            platform_name = :ios
          else
            puts "Didn't understand command, type (Android|IOS)".colorize(:red)
            next
        end

        break
      end

      app_input_correct = false
      until app_input_correct
        puts "What is the path of the app you would like to use?".colorize(:blue)
        app_path_input = gets
        app_path_input = app_path_input.gsub(/\s*$/, '').downcase

        if app_path_input.match(exit_regex)
          exit
        end

        if not File.exists?(app_path_input)
          puts "File #{app_path_input} doesn't exist, please try again".colorize(:red)
          next
        end

        input_correct = true
        break
      end
    else
      puts "Didn't understand command, type (Browser|Appium)".colorize(:red)
      next
  end
end

case driver_type_input
  when 'browser'
    driver = Selenium::WebDriver.for platform_name
  when 'appium'
    appium_options = {caps: {platformName: platform_name, app: app_path_input}, appium_lib: {wait: 5}}
    driver = Appium::Driver.new(appium_options).start_driver
  else
    puts 'Did not understand driver type input, exiting'.colorize(:red)
    exit
end

begin
  #Start App
  breaking_loop = false

  until breaking_loop
    element_selector = nil

    puts "-----------------------------------------------------------".colorize(:light_green)
    puts 'New Element Check: '.colorize(:magenta)
    puts "-----------------------------------------------------------".colorize(:light_green)
    puts 'Which selector would you like to use (xpath|css)?'.colorize(:blue)
    input = gets

    if input.match(css_regex)
      element_selector = :css
    elsif input.match(xpath_regex)
      element_selector = :xpath
    elsif input.match(exit_regex)
      break
    else
      puts "Didn't understand the input, input (xpath|css).".colorize(:red)
      next
    end

    puts 'What path would you like to use?'.colorize(:blue)
    input = gets

    if input.match(exit_regex)
      break
    end

    element_path = input.chomp

    puts "-----------------------------------------------------------".colorize(:light_green)
    puts "Running inputted selector and path".colorize(:magenta)
    puts "-----------------------------------------------------------".colorize(:light_green)


    begin
      possible_elements = driver.find_elements(element_selector, element_path)

      if possible_elements.length == 0
        puts 'No elements found!'.colorize(:red)
        next
      end

      puts 'Element(s) Found!'.colorize(:green)
      puts "Number of elements found: #{possible_elements.length}".colorize(:cyan)
      puts 'Input (next) to try another element or (exit|quit) if you want to quit.'.colorize(:blue)
      #puts '-----------------------------------------------------------'.colorize(:light_green)

      breaking_elements_loop = false

      until breaking_elements_loop
        puts '-----------------------------------------------------------'.colorize(:light_green)
        puts "Type in code you would like to evaluate against the element object! (next) to select another element".colorize(:cyan)
        input = gets

        if input.match(exit_regex)
          breaking_loop = true
          break
        elsif input.match(next_regex)
          break
        end

        evaluation_input = input.gsub(/\s*$/, '')

        puts "Evaluating and awesome printing the return!".colorize(:green)
        code_string = "Running code: ".colorize(:green)
        puts code_string + "element.#{evaluation_input}".colorize(:red)
        puts '-----------------------------------------------------------'.colorize(:light_green)

        i = 1
        possible_elements.each_with_index { |element|
          puts "Element #{i} (#{evaluation_input}):".colorize(:light_magenta)

          begin
            ap eval("element.#{evaluation_input}")
          rescue Exception => e
            puts "\Evaluation did not work, awesome printing error thrown".colorize(:red)
            ap e
          end

          i = i + 1
        }
      end

    rescue Exception => e
      puts 'Unable to select element, error thrown'.colorize(:red)
      ap e
    end
  end
ensure
  driver.quit
end
