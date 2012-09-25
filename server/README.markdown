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
