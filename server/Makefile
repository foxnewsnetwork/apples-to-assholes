test: build_tests
	@mocha \
		--compilers coffee:coffee-script \
		--reporter spec \
		*.coffee

build_tests:
	@cake tests

app_production.js: app_production.coffee
	coffee --compile $<

app_production.coffee:
	cake build

.PHONY: test build_tests