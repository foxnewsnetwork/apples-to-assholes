mocha.setup "bdd"
$("document").ready ->
	mocha.globals(['apples_to_assholes']).run()
# document ready