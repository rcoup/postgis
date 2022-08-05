EXTDIR=$(DESTDIR)$(datadir)/$(datamoduledir)

TAG_UPGRADE=$(EXTENSION)--TO--ANY.sql

install: install-upgrade-paths

install-upgrade-paths: tag-as-any
	tpl='$(EXTENSION)--ANY--$(EXTVERSION).sql'; \
	$(INSTALL_DATA) sql/$${tpl} "$(EXTDIR)/$${tpl}"; \
	$(INSTALL_DATA) "sql/$(TAG_UPGRADE)" "$(EXTDIR)/$(TAG_UPGRADE)"; \
	ln -fs "$(TAG_UPGRADE)" $(EXTDIR)/$(EXTENSION)--$(EXTVERSION)--ANY.sql; \
	for OLD_VERSION in $(UPGRADEABLE_VERSIONS); do \
    : TODO: delegate this to an admin script; \
	  ln -fs "$(TAG_UPGRADE)" $(EXTDIR)/$(EXTENSION)--$${OLD_VERSION}--ANY.sql; \
	done

tag-as-any: sql/$(TAG_UPGRADE)

sql/$(TAG_UPGRADE): $(MAKEFILE_LIST) | sql
	echo '-- Just tag extension $(EXTENSION) version as "ANY"' > $@
	echo '-- Installed by $(EXTENSION) $(EXTVERSION)' >> $@
	echo '-- Built on $(shell date)' >> $@

uninstall: uninstall-upgrade-paths

INSTALLED_UPGRADE_SCRIPTS = \
	$(wildcard $(EXTDIR)/$(EXTENSION)--*--$(EXTVERSION).sql \
	$(wildcard $(EXTDIR)/$(EXTENSION)--*--ANY.sql \
	$(NULL)

uninstall-upgrade-paths:
	rm -f $(INSTALLED_UPGRADE_SCRIPTS)
