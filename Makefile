all: node_modules elm-app.js

node_modules:
	yarn

elm-app.js: node_modules
	npx elm make Main.elm \
		--output=elm-app.js \
		--optimize

.PHONY: run
run: node_modules elm-app.js
	node main.js

.PHONY: clean
clean:
	rm -rf node_modules elm-stuff elm-app.js
