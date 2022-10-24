PKGDIR:=$(dir $(wildcard */Makefile))
KEEP:=3 # means 2

.PHONY: help build-all clean-all list-pkg space

help:
	@echo "build-all  build all package"
	@echo "clean-all  clean all package"
	@echo "list-pkg   list all package"

build-all:
	@for d in $(PKGDIR) ; \
	do \
		echo '' ; \
		echo "#=== $$d ===#" ; \
		(cd $$d; make) \
	done
	@echo ''
	@echo '#=== Summary: packages created on this last day ===#'
	@find . -name '*.zip' -a -mtime -1

clean-all:
	@for d in $(PKGDIR) ; \
	do \
		echo '' ; \
		echo "#=== $$d ===#" ; \
		(cd $$d; make clean) \
	done

list-pkg:
	@for d in $(PKGDIR) ; \
	do \
		(cd $$d ; \
		echo '' ; \
		echo "#=== $$d ===#" ; \
		unzip -t *.zip ; \
		) \
	done

space:
	@for d in $(PKGDIR) ; \
	do \
		(cd $$d ; \
		ls -t *.zip | tail -n +$(KEEP) | xargs -r rm -f ; \
		) \
	done
