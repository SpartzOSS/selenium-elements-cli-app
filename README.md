selenium-elements-cli-app
=========================

Small Ruby command line app for finding and working with Selenium/Appium elements

I made this small CLI app to help me evaluate (CSS | xPath) paths I was using before inputting them into something
more substantial.  With this program you can evaluate selectors without having issues with exceptions being thrown.  The app will
keep driver alive until you are done using it.

Once an element or multiple elements have been found, the CLI app will tell you how many it has found and then you can
run operations against each element.

Installation:
- Run 'gem install bundler'
- cd into directory of selenium-elements-cli-app
- Run 'bundle install'

Troubleshooting:
- Make sure to have Selenium Java/Appium set in PATH
- Close console in browser before trying to access/use an element in the CLI app, will error out if console is open in the browser the driver is trying to use

Appium Server:
- You will need to start your own Appium server on the default port 4723
- Preferably you should use the GUI app provided at http://appium.io/
- This will allow you to use the inspector which shows the individual elements and paths

Usage:
- Run 'ruby main.rb'
- At any time (exit, quit) input will cause the driver to quit and the CLI app to quit
- App will ask whether you want a Selenium Browser or Appium driver
- Once you have selected either you will have to choose which browser (Chrome, ...) or which device platform (Android, iOS)
- For apps, you will have to enter the full app path
- In browsers you can manually navigate to a page you would like
- Then when you are ready, you will see output for a "New Element Check"
- Input either xPath or CSS as your path selector type
- Then input the element path
- It will either error out or you will see a certain number of elements selected
- Then you can run commands against the element object such as (text, location, size) and it will awesome print the results
- Input "next" when you want to try another element(s)
- Repeat until you are done

Element Command Usage:

You can enter in methods available on the Element object by typing in those methods, ie. click, attribute('href'), text
Very simple implementation: ap eval("element.#{evaluation_input}"), if that helps make some sense of it