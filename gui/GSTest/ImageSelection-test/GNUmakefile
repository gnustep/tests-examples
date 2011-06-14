#   GNUmakefile
#
#   Copyright (C) 1999 Free Software Foundation, Inc.
#
#   Author:  Nicola Pero <n.pero@mi.flashnet.it>
#   Date: 1999
#   
#   This file is part of GNUstep.
#   
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#   
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#   
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. */
include $(GNUSTEP_MAKEFILES)/common.make

OBJCFLAGS += -Wall

#
# We are creating a bundle
#
BUNDLE_NAME = ImageSelection-test
BUNDLE_INSTALL_DIR = $(GNUSTEP_LIBRARY)/ApplicationSupport/GSTest
$(BUNDLE_NAME)_OBJC_FILES = $(wildcard *.m)
$(BUNDLE_NAME)_PRINCIPAL_CLASS = ImageSelectionTest
$(BUNDLE_NAME)_RESOURCE_FILES = $(wildcard *.tiff) $(wildcard *.icns) $(wildcard *.png)
-include GNUmakefile.preamble

-include GNUmakefile.local

include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.postamble

