MODELS=card player room vote
COLLECTIONS=cards players rooms votes
VIEWS=card player flash room timer
ROUTERS=game
MISC=sync

TEXT=_spec
EXT=coffee

TDIR=spec
ODIR=lib
DIR=src
 
DEPS= $(patsubst %, $(DIR)/models/%.$(EXT), $(MODELS)) $(patsubst %, $(DIR)/collections/%.$(EXT), $(COLLECTIONS)) $(patsubst %, $(DIR)/routers/%.$(EXT), $(ROUTERS)) $(patsubst %, $(DIR)/misc/%.$(EXT), $(MISC)) $(patsubst %, $(DIR)/views/%.$(EXT), $(VIEWS))
TDEPS= $(patsubst %, $(TDIR)/models/%$(TEXT).$(EXT), $(MODELS)) $(patsubst %, $(TDIR)/collections/%$(TEXT).$(EXT), $(COLLECTIONS)) $(patsubst %, $(TDIR)/routers/%$(TEXT).$(EXT), $(ROUTERS)) $(patsubst %, $(TDIR)/misc/%$(TEXT).$(EXT), $(MISC))

.PHONY: development production test

production: $(ODIR)/app.js
	cat $< | uglifyjs -o app.min.js

development: $(ODIR)/app_production.js
	@echo "This is just an alias for app_production.js"

test: $(ODIR)/app_spec.js
	@echo "=== Open test.html in your favorite browser to run tests! ==="

$(ODIR)/%.js: $(ODIR)/%.coffee
	coffee -co lib/ lib/

$(ODIR)/app_production.coffee: $(DEPS)
	cake build

$(ODIR)/app_spec.coffee: $(DEPS) $(TDEPS)
	cake tests