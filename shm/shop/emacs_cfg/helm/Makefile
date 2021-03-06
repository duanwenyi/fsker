# makefile for helm.

# Author: Michael Markert.
# Copyright (C) 2011~2012, Michael Markert, all rights reserved.

## This file is NOT part of GNU Emacs
##
## License
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3, or (at your option)
## any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; see the file COPYING.  If not, write to
## the Free Software Foundation, Inc., 51 Franklin Street, Fifth
## Floor, Boston, MA 02110-1301, USA.

# Emacs invocation
EMACS_COMMAND   := emacs

# Use -q to have /usr/local/share/emacs/site-lisp and subdirs in load-path 
EMACS		:= $(EMACS_COMMAND) -q -batch

EVAL := $(EMACS) --eval

PKGDIR := .

# Additional emacs loadpath
LOADPATH	:= -L $(PKGDIR)
ELPA_DIR        =  $(HOME)/.emacs.d/elpa
ASYNC_ELPA_DIR  =  /icdev/emacs/helm/async

#ASYNC_ELPA_DIR  =  $(shell \
# 	test -d $(ELPA_DIR) && \
# 	find -L $(ELPA_DIR) -maxdepth 1 -regex '.*/async-[.0-9]*' 2> /dev/null | \
# 	sort | tail -n 1)

ifneq "$(ASYNC_ELPA_DIR)" ""
	LOADPATH += -L $(ASYNC_ELPA_DIR)
endif

# Files to compile
EL			:= $(sort $(wildcard helm*.el))

# Compiled files
ELC			:= $(EL:.el=.elc)


.PHONY: clean autoloads batch-compile

all: clean autoloads batch-compile

$(ELC): %.elc: %.el
	$(EMACS) $(LOADPATH) -f batch-byte-compile $<

# Compile needed files
compile: $(ELC)

# Compile all files at once
batch-compile:
	$(EMACS) $(LOADPATH) -f batch-byte-compile $(EL)

# Remove all generated files
clean:
	rm -f $(ELC)

# Make autoloads file
autoloads:
	$(EVAL) "(let ((generated-autoload-file (expand-file-name \"helm-autoloads.el\" \"$(PKGDIR)\")) \
(backup-inhibited t)) (update-directory-autoloads \"$(PKGDIR)\"))"
