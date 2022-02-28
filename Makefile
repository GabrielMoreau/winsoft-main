PKGDIR = $(dir $(wildcard */Makefile))

.PHONY: help build-all clean-all list-pkg

help:
	@echo "build-all  build all package"
	@echo "clean-all  clean all package"
	@echo "list-pkg   list all package"

build-all:
	@for d in $(PKGDIR) ; \
	do \
		(cd $$d; make) \
	done

clean-all:
	@for d in $(PKGDIR) ; \
	do \
		(cd $$d; make clean) \
	done

list-pkg:
	@for d in $(PKGDIR) ; \
	do \
		(cd $$d ; \
		echo "#=== $$d ===#" ; \
		unzip -t *.zip ; \
		) \
	done
