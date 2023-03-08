PKGDIR:=$(dir $(wildcard */Makefile))
KEEP:=3 # means 2

.PHONY: help build-all clean-all list-pkg space

help:
	@echo "* \`build-all\`  build all package except if \`.noauto\` file"
	@echo "* \`clean-all\`  clean all package except if \`.noauto\` file"
	@echo "* \`list-pkg\`   list all package"
	@echo "* \`space\`      clean old package"

build-all:
	@for d in $(PKGDIR) ; \
	do \
		echo '' ; \
		[ -f "$$d/.noauto" ] && { echo "#=== pass:$$d" ; continue ; } ; \
		echo "#=== $$d ===#" ; \
		(cd $$d; \
			make > .make.log 2>&1; \
			find . -name '*.zip' -a -mtime -1 -exec cat .make.log \; \
		) \
	done
	@echo ''
	@echo '#=== Summary: packages created on this last day ===#'
	@find . -name '*.zip' -a -mtime -1 -exec ls -ltr {} \+

clean-all:
	@for d in $(PKGDIR) ; \
	do \
		echo '' ; \
		[ -f "$$d/.noauto" ] && { echo "#=== pass:$$d" ; continue ; } ; \
		echo "#=== $$d ===#" ; \
		(cd $$d; make clean; rm -f .make.log) \
	done

list-pkg:
	@for d in $(PKGDIR) ; \
	do \
		(cd $$d; \
			echo ''; \
			echo "#=== $$d ===#"; \
			unzip -t *.zip; \
		) \
	done

space:
	@for d in $(PKGDIR) ; \
	do \
		(cd $$d; \
			ls -t *.zip | tail -n +$(KEEP) | xargs -r rm -f; \
			rm -f .make.log; \
		) \
	done
