#   GNUmakefile: main makefile for GNUstep GUI Demo Suite
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
# Each test is a bundle subproject, in its own dir
#
SUBPROJECTS = \
  KeyboardInput-test \
  NSBox-test \
  NSColorWell-test \
  NSScrollView-test \
  NSSlider-test \
  NSSplitView-test 

#
# MAIN APP
#
APP_NAME = GSTest

GSTest_HEADERS = \
	infoPanel.h \
        testList.h \
        testProtocol.h 

GSTest_OBJC_FILES = \
        main.m \
	infoPanel.m

-include GNUmakefile.preamble

-include GNUmakefile.local

include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/application.make
include $(GNUSTEP_MAKEFILES)/bundle.make

-include GNUmakefile.postamble


