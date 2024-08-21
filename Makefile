.PHONY: format check phpstan phpmd phpsyntaxcheck precommit

precommit: check format

format:
	prettier -w $$(find -not -path "./.*" -not -path "./data/*" -not -name Makefile -not -name "*.conf" -type f)

check: phpsyntaxcheck phpmd phpstan

phpsyntaxcheck:
	php -l mqtt2prom/run

phpstan:
	phpstan analyse --level 9 mqtt2prom/run

phpmd:
	phpmd mqtt2prom/run ansi cleancode,codesize,controversial,design,naming,unusedcode