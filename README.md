selenium-elements-cli-app
=========================

Small Ruby command line app for finding and working with Selenium/Appium elements

I made this small CLI app to help me evaluate (CSS|xPath) paths I was using before inputting them into something
more substantial.  With this program you can evaluate paths without having issues with exceptions being thrown.

Once an element or mutliple elements have been found, the CLI app will tell you how many it has found and then you can
run operations against each element.

Installation:
- Run 'gem install bundler'
- cd into directory of selenium-elements-cli-app
- Run 'bundle install'

Troubleshooting:
- Make sure to have Selenium Java/Appium set in PATH
- Close console in browser before trying to access/use an element, will error out if console is open in the browser the driver is trying to use
