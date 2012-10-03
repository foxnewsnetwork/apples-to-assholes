Apples-to-Assholes Client
=
The client-side code will all be written in coffee. Once live, be sure to point your vhost's public folder
to this directory as node will NOT be used to serve any static assets. We will extensively use backbone

Organization
=
Models : contains all the models that will require database communication and state sharing
Routers : backbone routers route stuff around
Views : renders cards and exposes UIs
Misc : contains the sync files and other such miscellanious additions

Events
=
This thing is event driven. Event options determine how far they travel. The options they take are as follows:
	range: "client" / "server"
	echo: callback / target / "global" / "galatic"
	data: your json