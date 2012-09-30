MODELS=game card 
COLLECTIONS=rooms
MISC=sync

TEXT=_spec
EXT=coffee

TDIR=spec
ODIR=lib
DIR=src
 
DEPS= $(patsubst %, $(DIR)/models/%.$(EXT), $(MODELS)) $(patsubst %, $(DIR)/collections/%.$(EXT), $(COLLECTIONS)) $(patsubst %, $(DIR)/misc/%.$(EXT), $(MISC))
TDEPS= $(patsubst %, $(TDIR)/models/%$(TEXT).$(EXT), $(MODELS)) $(patsubst %, $(TDIR)/collections/%$(TEXT).$(EXT), $(COLLECTIONS)) $(patsubst %, $(TDIR)/misc/%$(TEXT).$(EXT), $(MISC))

.PHONY: development production test

production: $(ODIR)/app.js
	cat $< | uglifyjs -o app.min.js

development: $(ODIR)/app.js
	"This is just an alias for app.js"

test: $(ODIR)/app_spec.js
	@echo "=== Open test.html in your favorite browser to run tests! ==="

$(ODIR)/%.js: $(ODIR)/%.coffee
	coffee -co lib/ lib/

$(ODIR)/app.coffee: $(DEPS)
	cake build

$(ODIR)/app_spec.coffee: $(DEPS) $(TDEPS)
	cake tests