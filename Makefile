MKDIR ?= mkdir -p
CAT ?= cat
RM_R ?= $(RM) -r
RMDIR ?= rmdir -p --ignore-fail-on-non-empty

TEMPLATES_SRCS = $(shell find templ -type f -printf '%P\n')

TEMPLATES = $(addprefix out/,$(TEMPLATES_SRCS))

INSTALL_TEMPLATES = $(addprefix $(DESTDIR)/,$(TEMPLATES_SRCS))

UNINSTALL_FILES = $(addprefix __uninstall_file__, $(INSTALL_TEMPLATES))

a:
	@echo $(INSTALL_TEMPLATES)

all: templates

templates: $(TEMPLATES)

$(TEMPLATES): out/%: templ/%
	@ $(MKDIR) $(@D)
	$(CAT) $< > $@

install: $(INSTALL_TEMPLATES)

$(INSTALL_TEMPLATES): $(DESTDIR)/%: out/%
	@ $(MKDIR) $(@D)
	$(CAT) $< > $@

uninstall: $(UNINSTALL_FILES)

$(UNINSTALL_FILES): __uninstall_file__%:
	@ $(RM) -v $*
	@ if [ -d $(dir $*) ]; then $(RMDIR) -v $(dir $*); fi

clean:
	$(RM_R) out

.PHONY: all templates install uninstall clean
