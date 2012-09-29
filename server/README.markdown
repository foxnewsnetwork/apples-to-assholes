Apples-to-Assholes Server
=
The Apples to Asshole Server will provide the backend service to our Apples to Assholes game

Logistics
=
All files are written in coffescript, so use the cakefile to build it as necessary. The server source
files are in src and the spec files hold all the testing files (we will test with mocha)

Organization
=
Controllers will expose the socket.io API for all clients who connect to it, in addition it will interface
with the models who will in term deal with the database (abroad or local).

Notes
=
If you're either Andrew, Trevor, or me and are developing this thing, please note that you will need to
install nodejs to run the server. In addition, be sure run "sudo npm install" to get all the dependencies
off of the package.json file.

Also, if you wind up needing to get other packages from npm, be sure to update the package.json file to
reflect this, otherwise it will be very hard for the rest of us to keep track of what the dependencies are

To run tests, do a "make test" command. This will build all the tests from the spec file and dump into a app_spec.coffee
file in the current directory then run mocha on that file. The app_spec.coffee file is not deleted after the
tests to give you a chance to look through and inspect wherever the code may not be working. However, you should only
makes changes in the original files that live either in src/ or spec/ (since app_spec.coffee gets overriden each time you test)

Optional Development Tools
=
In case you're curious what I am using the dev this, I will list the tools I use:

1. OS : Linux Mint 12 i686
2. Text-Editor : gedit / sublime
3. Test-Browser : Chrome

In case you're not me, please also list the tools you are using so that the rest of us may improve our toolset		