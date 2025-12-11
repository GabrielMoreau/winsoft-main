# Do not change variable definition here
# Change in include main.mk sub-makefile.
PKGDIR:=$(dir $(wildcard */Makefile))
SHELL:=/bin/bash
PKGLEN:=$(shell echo $(PKGDIR) | sed -e 's/[[:space:]]/\n/g;' | wc --max-line-length)
# KEEP : Number of versions of the same package to keep
KEEP:=2
# TIMEWINDOW : Time window for taking into account the latest changes
TIMEWINDOW:=1.25

sinclude ../winsoft-conf/_common/main.mk

.PHONY: help build-all clean-all checksum-all last-checksum unrealized-updates list-pkg list-version list-md space version ocs-asifpushed
.ONESHELL:

help: ## show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n"} /^[a-zA-Z_-]+:.*?##/ { printf " \033[36mmake %-19s\033[0m #%s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

build-all: ## build all package except if `.no-auto-update` file
	@
	for pkgfolder in $(PKGDIR)
	do
		if [ -f "$${pkgfolder}/.no-auto-update" ] || grep -q "^$${pkgfolder}" ./_common/no-auto-update.conf ../winsoft-conf/_common/no-auto-update.conf 2> /dev/null
		then
			printf "#--- %-$(PKGLEN)s ---#\n" pass:$${pkgfolder%/}
			continue
		fi
		printf "#=== %-$(PKGLEN)s ===#\n" $${pkgfolder%/}
		(cd $${pkgfolder}; \
			make > .make.log; \
			[ $$(LANG=C find . -maxdepth 1 -name '*.zip' -a -mtime -$(TIMEWINDOW) -not -path '*/tmp/*' -print | wc -l) -gt 0 ] && cat .make.log; \
		)
	done
	echo ''
	echo '#===================================================================#'
	echo '#=== Summary: packages created since 12 hours ('$$(date '+%Y-%m-%d %H:%M')') ===#'
	LANG=C find . -maxdepth 2 -name '*.zip' -a -mtime -$(TIMEWINDOW) -not -path '*/tmp/*' -exec ls -ltr {} \+
	exit 0

clean-all: ## clean all package except if `.no-auto-update` file
	@
	for pkgfolder in $(PKGDIR)
	do
		echo ''
		if [ -f "$${pkgfolder}/.no-auto-update" ] || grep -q "^$${pkgfolder}" ./_common/no-auto-update.conf ../winsoft-conf/_common/no-auto-update.conf 2> /dev/null
		then
			printf "#--- %-$(PKGLEN)s ---#\n" pass:$${pkgfolder%/}
			continue
		fi
		printf "#=== %-$(PKGLEN)s ===#\n" $${pkgfolder%/}
		(cd $${pkgfolder}; make clean; rm -f .make.log)
	done
	exit 0

checksum-all: ## make all package checksum files except if `.no-auto-update` file
	@
	for pkgfolder in $(PKGDIR)
	do
		echo ''
		if [ -f "$${pkgfolder}/.no-auto-update" ] || grep -q "^$${pkgfolder}" ./_common/no-auto-update.conf ../winsoft-conf/_common/no-auto-update.conf 2> /dev/null
		then
			printf "#--- %-$(PKGLEN)s ---#\n" pass:$${pkgfolder%/}
			continue
		fi
		printf "#=== %-$(PKGLEN)s ===#\n" $${pkgfolder%/}
		(cd $${pkgfolder}; grep -q '^checksum:' Makefile && make checksum)
	done
	exit 0

last-checksum: ## make package checksum file if version have changed (TIMEWINDOW var)
	@
	while read -r pkgfolder
	do
		printf "#=== %-$(PKGLEN)s ===#\n" $${pkgfolder}
		(cd $${pkgfolder}; grep -q '^checksum:' Makefile && make checksum)
	done < <(LANG=C find . -maxdepth 2 -name '*.zip' -a -mtime -$(TIMEWINDOW) -not -path '*/tmp/*' -print | xargs -r dirname | xargs -r -n 1 basename | sort -u)
	exit 0

unrealized-updates: ## try to find packages that are not uptodate
	@
	while read -r pkgfolder
	do
		printf "#=== %-$(PKGLEN)s ===# " $${pkgfolder}
		RESULT=$$(cd $${pkgfolder}; grep -q '^check-unrealized:' Makefile && make check-unrealized)
		if [ -n "$${RESULT}" ] ; then echo "$${RESULT}"; else echo ''; fi
	done < <(LANG=C find . -maxdepth 2 -name '*.zip' -a -mtime -180 -not -path '*/tmp/*' -print | xargs -r dirname | xargs -r -n 1 basename | sort -u)
	echo '#===================================================================#'
	echo '#=== Summary: this check was performed on '$$(date '+%Y-%m-%d %H:%M')'       ===#'
	exit 0

list-pkg: ## list all package
	@
	for pkgfolder in $(PKGDIR)
	do
		(cd $${pkgfolder}; \
			echo ''; \
			printf "#=== %-$(PKGLEN)s ===#\n" $${pkgfolder%/}; \
			unzip -t *.zip; \
		)
	done
	exit 0

list-version: ## list all version package except if `.no-auto-update` file
	@
	for pkgfolder in $(PKGDIR)
	do
		if [ -f "$${pkgfolder}/.no-auto-update" ] || grep -q "^$${pkgfolder}" ./_common/no-auto-update.conf ../winsoft-conf/_common/no-auto-update.conf 2> /dev/null
		then
			continue
		fi
		printf "%25s %s\n" "$${pkgfolder%/}" $$(cd $${pkgfolder}; make version | grep '^VERSION:' | awk '{print $$2}')
	done
	exit 0

list-md: ## list all package in markdown format
	@
	echo '## List of '$$( (git ls-files | grep '^[[:alpha:][:digit:]-]*/README.md'; grep -l '^Uninstall-.*.zip:' */Makefile) | wc -l)' packages'
	echo ''
	echo ' |   | Software | Detail | &#127968; |   |'
	echo ' | - | -------- | ------ | --------- | - |'
	index=0
	for pkg in $$(git ls-files | grep '^[[:alpha:][:digit:]-]*/README.md' | grep -v '\\$$' | xargs -I {} sh -c "(head -1 '{}' ; dirname '{}') | paste -sd '#'"  | sort | cut -f 3 -d '#' | grep -v -- '-uninstall')
	do
		index=$$((index + 1))
		sindex=$$(printf '%03i' $${index})
		lic=$$(grep -q 'open-source' $${pkg}/README.md && echo '[🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software")' || echo '[©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software")')
		url=$$(grep '* Website : ' $${pkg}/README.md | cut -f 4 -d ' ')
		head -1 $${pkg}/README.md | perl -p -e "s{^#\s(.*)\s-\s(.*)}{ | $${sindex} | [\\1]($${pkg}/README.md) | \\2 | [&#127968;]($${url}) | $${lic} |};" | sed -e 's/\[&#127968;\]()//;'
	done | sort | grep -Ev '\([[:alpha:]][[:alpha:]]*\)\]\('
	echo ''
	echo '### Uninstall packages'
	echo ''
	echo ' |   | Uninstall | Detail | &#127968; |   |'
	echo ' | - | -------- | ------ | --------- | - |'
	index=0
	for pkg in $$( (git ls-files | grep '^[[:alpha:][:digit:]-]*/README.md' | xargs -r grep -l '^#[[:space:]].*(.*)[[:space:]]-' | xargs -r dirname | grep -v '/' | grep 'uninstall'; grep -l '^Uninstall-.*.zip:' */Makefile | xargs -r dirname) | xargs -I {} sh -c "(head -1 '{}/README.md' ; echo '{}') | paste -sd '#'" | sort | cut -f 3 -d '#')
	do
		index=$$((index + 1))
		sindex=$$(printf '%03i' $${index})
		lic=$$(grep -q 'open-source' $${pkg}/README.md && echo '[🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software")' || echo '[©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software")')
		url=$$(grep '* Website : ' $${pkg}/README.md | cut -f 4 -d ' ')
		head -1 $${pkg}/README.md |perl -p -e "s{^#\s(.*)\s-\s(.*)}{ | $${sindex} | [\\1]($${pkg}/README.md) | \\2 | [&#127968;]($${url}) | $${lic} |}; s/(\w)\]\(/\\1 (Uninstall)](/;" | sed -e 's/\[&#127968;\]()//;'
	done | sort
	echo ''
	echo '### Action packages'
	echo ''
	echo ' |   | Action | Detail | &#127968; |   |'
	echo ' | - | -------- | ------ | --------- | - |'
	index=0
	for pkg in $$( (git ls-files | grep '^[[:alpha:][:digit:]-]*/README.md' | xargs -r grep -l '^#[[:space:]].*(.*)[[:space:]]-' | xargs -r dirname | grep -v '/' | grep -v 'uninstall') | xargs -I {} sh -c "(head -1 '{}/README.md' ; echo '{}') | paste -sd '#'" | sort | cut -f 3 -d '#')
	do
		index=$$((index + 1))
		sindex=$$(printf '%03i' $${index})
		lic=$$(grep -q 'open-source' $${pkg}/README.md && echo '[🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software")' || echo '[©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software")')
		url=$$(grep '* Website : ' $${pkg}/README.md | cut -f 4 -d ' ')
		head -1 $${pkg}/README.md | perl -p -e "s{^#\s(.*)\s-\s(.*)}{ | $${sindex} | [\\1]($${pkg}/README.md) | \\2 | [&#127968;]($${url}) | $${lic} |}; s/(\w)\]\(/\\1 (Uninstall)](/;" | sed -e 's/\[&#127968;\]()//;'
	done | sort
	echo ''
	echo '### List of '$$( (dirname $$(git ls-files | grep '^_obsolete/[[:alpha:][:digit:]-]*/README.md'; grep -l '^Uninstall-.*.zip:' _obsolete/*/Makefile)) | sort -u | wc -l)' obsolete packages'
	echo ''
	echo ' |   | Software | Detail | Date |'
	echo ' | - | -------- | ------ | ---- |'
	index=0
	for pkg in $$(git ls-files | grep '^_obsolete/[[:alpha:][:digit:]-]*/README.md' | grep -v '\\$$' | xargs -I {} sh -c "(head -1 '{}' ; dirname '{}') | paste -sd '#'"  | sort | cut -f 3 -d '#' | grep -v -- '-uninstall')
	do
		index=$$((index + 1))
		sindex=$$(printf '%03i' $${index})
		obsolete=$$(grep '* Obsolete : ' $${pkg}/README.md | cut -f 4 -d ' ')
		head -1 $${pkg}/README.md | perl -p -e "s{^#\s(.*)\s-\s(.*)}{ | $${sindex} | [\\1]($${pkg}/README.md) | \\2 | $${obsolete} |};"
	done | sort | grep -Ev '\([[:alpha:]][[:alpha:]]*\)\]\('
	exit 0

space: ## clean (remove) old package to get disk space (KEEP var)
	@
	for pkgfolder in $(PKGDIR)
	do
		(cd $${pkgfolder}; \
			ls -t *.zip 2>/dev/null | grep -v 'Uninstall' | tail -n +$$(($(KEEP) + 1)) | xargs -r rm -vf; \
			ls -t *.zip 2>/dev/null | grep    'Uninstall' | tail -n +$$(($(KEEP) + 1)) | xargs -r rm -vf; \
		)
	done
	exit 0

version: ## get all package version except if `.no-auto-update` file
	@
	for pkgfolder in $(PKGDIR)
	do
		echo ''
		if [ -f "$${pkgfolder}/.no-auto-update" ] || grep -q "^$${pkgfolder}" ./_common/no-auto-update.conf ../winsoft-conf/_common/no-auto-update.conf 2> /dev/null
		then
			printf "#--- %-$(PKGLEN)s ---#\n" pass:$${pkgfolder%/}
			continue
		fi
		printf "#=== %-$(PKGLEN)s ===#\n" $${pkgfolder%/}
		(cd $${pkgfolder}; make version) | grep -v '^make'
	done
	exit 0

ocs-push: ## push last packages (see target last-checksum) on your OCS server except if `.no-ocs-pkgpush` file (TIMEWINDOW var)
	@
	while read -r pkgfolder
	do
		if [ -f "$${pkgfolder}/.no-ocs-pkgpush" ] || grep -q "^$${pkgfolder}" ./_common/no-ocs-pkgpush.conf ../winsoft-conf/_common/no-ocs-pkgpush.conf 2> /dev/null
		then
			printf "#--- %-$(PKGLEN)s ---#\n" pass:$${pkgfolder%/}
			continue
		fi
		printf "#=== %-$(PKGLEN)s ===#\n" $${pkgfolder}
		(cd $${pkgfolder}; make ocs-push)
	done < <(LANG=C find . -maxdepth 2 -name '*.zip' -a -mtime -$(TIMEWINDOW) -not -path '*/tmp/*' -print | xargs -r dirname | xargs -r -n 1 basename | sort -u)
	exit 0

ocs-push-all: ## push all packages that have not yet been pushed, unless the `.no-ocs-pkgpush` file exists.
	@
	while read -r pkgfolder
	do
		if [ -f "$${pkgfolder}/.no-ocs-pkgpush" ] || grep -q "^$${pkgfolder}" ./_common/no-ocs-pkgpush.conf ../winsoft-conf/_common/no-ocs-pkgpush.conf 2> /dev/null
		then
			printf "#--- %-$(PKGLEN)s ---#\n" pass:$${pkgfolder%/}
			continue
		fi
		printf "#=== %-$(PKGLEN)s ===#\n" $${pkgfolder}
		(cd $${pkgfolder}; make ocs-push)
	done < <(LANG=C find . -maxdepth 2 -name '*.zip' -a -not -path '*/tmp/*' -print | xargs -r dirname | xargs -r -n 1 basename | sort -u)
	exit 0

ocs-pretend-pushed: ## act as if all packages have already been downloaded to the OCS server
	@
	for pkgfolder in $$(ls -1d *)
	do
		[ -d "$${pkgfolder}" ] || continue
		if [ -f "$${pkgfolder}/.no-ocs-pkgpush" ] || grep -q "^$${pkgfolder}" ./_common/no-ocs-pkgpush.conf ../winsoft-conf/_common/no-ocs-pkgpush.conf 2> /dev/null
		then
			continue
		fi
		(cd "$${pkgfolder}"
			for z in $$(ls -1 *.zip 2> /dev/null)
			do
				grep -q "$$z" "tmp/ocs-pkgpush.txt" 2> /dev/null || { mkdir -p "tmp" ; echo "$$z" >> "tmp/ocs-pkgpush.txt" ; }
			done
		)
	done
	exit 0
