.PHONY: format lint test coverage clean

# run "make VERSION=x.y.z" to specify version
VERSION=git-$(shell git rev-parse --short HEAD)
FILENAME=mirin-template-$(VERSION)

$(FILENAME).zip: lint test
	mkdir -p build
	cp -r Song.ogg Song.sm conf.lua lua src build
	sed 's/$$VERSION/'"$(VERSION)"'/' build/src/main.xml -i
	zip "$(FILENAME)".zip build -r
	rm build -rf

format:
	stylua src

lint:
	stylua -c src
	luacheck src

test:
	busted

coverage:
	busted --coverage --suppress-pending || true
	luacov
	awk 't&&(--l<0){print}/Summary/{t=1;l=1}/Total/{print "##[set-output name=coverage;]" int($$NF)}' luacov.report.out
	rm luacov.report.out
	rm luacov.stats.out

clean:
	# from the default target
	rm -rf build
	rm -rf $(FILENAME).zip
	# from coverage
	rm -rf luacov.report.out
	rm -rf luacov.stats.out