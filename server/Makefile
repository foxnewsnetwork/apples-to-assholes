MODELS=card channel
COLLECTIONS=cards channels
ROUTERS=game

TEXT=_spec
EXT=coffee

TDIR=spec
ODIR=lib
DIR=src

DEPS= $(DIR)/app.$(EXT) $(DIR)/initializer.$(EXT) $(patsubst %, $(DIR)/models/%.$(EXT), $(MODELS)) $(patsubst %, $(DIR)/collections/%.$(EXT), $(COLLECTIONS)) $(patsubst %, $(DIR)/routers/%.$(EXT), $(ROUTERS))
TDEPS= $(patsubst %, $(TDIR)/models/%$(TEXT).$(EXT), $(MODELS)) $(patsubst %, $(TDIR)/collections/%$(TEXT).$(EXT), $(COLLECTIONS)) $(patsubst %, $(TDIR)/routers/%$(TEXT).$(EXT), $(ROUTERS))

.PHONY: test build_tests

development: app_production.js
	@echo "This is just an alias for app_production.js"

test: build_tests
	@mocha \
		--compilers coffee:coffee-script \
		--reporter spec \
		lib/app_spec.coffee

build_tests:
	@cake tests

%.js: $(ODIR)/%.coffee
	coffee -co . $(ODIR)

$(ODIR)/%.js: $(ODIR)/%.coffee
	coffee -co $(ODIR) $(ODIR)

$(ODIR)/app_production.coffee: $(DEPS)
	cake build

$(ODIR)/app_spec.coffee: $(DEPS) $(TDEPS)
	cake tests