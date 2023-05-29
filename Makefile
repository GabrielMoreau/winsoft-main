PKGDIR:=$(dir $(wildcard */Makefile))
KEEP:=3 # means 2

.PHONY: help build-all clean-all list-pkg space
.ONESHELL:

help:
	@
	echo "* \`build-all\`  build all package except if \`.noauto\` file"
	echo "* \`clean-all\`  clean all package except if \`.noauto\` file"
	echo "* \`list-pkg\`   list all package"
	echo "* \`space\`      clean old package"
	echo "* \`version\`    get all package version"

build-all:
	@
	for d in $(PKGDIR)
	do
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./common/noauto.conf ../winsoft-conf/common/noauto.conf 2> /dev/null
		then
			echo "#=== pass:$$d"
			continue
		fi
		echo "#=== $$d ===#"
		(cd $$d; \
			make > .make.log 2>&1; \
			find . -maxdepth 1 -name '*.zip' -a -mtime -1 -not -path '*/tmp/*' -exec cat .make.log \; \
		)
	done
	echo ''
	echo '#=== Summary: packages created on this last day ===#'
	find . -maxdepth 2 -name '*.zip' -a -mtime -1 -not -path '*/tmp/*' -exec ls -ltr {} \+

clean-all:
	@
	for d in $(PKGDIR)
	do
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./common/noauto.conf ../winsoft-conf/common/noauto.conf 2> /dev/null
		then
			echo "#=== pass:$$d"
			continue
		fi
		echo "#=== $$d ===#"
		(cd $$d; make clean; rm -f .make.log)
	done

checksum-all:
	@
	for d in $(PKGDIR)
	do
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./common/noauto.conf ../winsoft-conf/common/noauto.conf 2> /dev/null
		then
			echo "#=== pass:$$d"
			continue
		fi
		echo "#=== $$d ===#"
		(cd $$d; grep -q '^checksum:' Makefile && make checksum)
	done

list-pkg:
	@
	for d in $(PKGDIR)
	do
		(cd $$d; \
			echo ''; \
			echo "#=== $$d ===#"; \
			unzip -t *.zip; \
		)
	done

space:
	@
	for d in $(PKGDIR)
	do
		(cd $$d; \
			ls -t *.zip | tail -n +$(KEEP) | xargs -r rm -f; \
			rm -f .make.log; \
		)
	done

version:
	@
	for d in $(PKGDIR)
	do
		echo ''
		if [ -f "$$d/.noauto" ] || grep -q "^$$d" ./common/noauto.conf ../winsoft-conf/common/noauto.conf 2> /dev/null
		then
			echo "#=== pass:$$d"
			continue
		fi
		echo "#=== $$d ===#"
		(cd $$d; make version) | grep -v '^make'
	done
