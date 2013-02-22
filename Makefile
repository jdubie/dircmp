t: test

compile: clean build

build:
	mkdir -p lib
	./node_modules/.bin/coffee \
		-c -o lib src

clean:
	rm -rf lib

# Runs coffee-script directly
test:
	@NODE_PATH=. \
		./node_modules/.bin/mocha \
			--compilers coffee:coffee-script \
			test


.PHONY: test
