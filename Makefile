WATCH_FILES= find . -type f -not -path '*/\.*' | grep -i '.*[.]py$$' 2> /dev/null
PY_FILES= find . -type f -not -path '*/\.*' -and -not -path '*/settings\/*' -and -not -path '*/migrations\/*' | grep -i '.*[.]py$$'
SHELL := /bin/bash


entr_warn:
	@echo "----------------------------------------------------------"
	@echo "     ! File watching functionality non-operational !      "
	@echo "                                                          "
	@echo "Install entr(1) to automatically run tasks on file change."
	@echo "See http://entrproject.org/                               "
	@echo "----------------------------------------------------------"

flake8:
	poetry run flake8 test_app

watch_flake8:
	if command -v entr > /dev/null; then ${WATCH_FILES} | entr -c $(MAKE) flake8; else $(MAKE) flake8 entr_warn; fi

test:
	poetry run py.test $(test)

watch_test:
	if command -v entr > /dev/null; then ${WATCH_FILES} | entr -c $(MAKE) test; else $(MAKE) test entr_warn; fi

black:
	poetry run black `${PY_FILES}` --skip-string-normalization

isort:
	poetry run isort `${PY_FILES}`

format_markdown:
	prettier --parser=markdown -w *.md
