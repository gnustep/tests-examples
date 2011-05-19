#
#   Copyright (C) 2001 Free Software Foundation, Inc.
#
#   Author:  Fred Kiefer <FredKiefer@gmx.de>
#   Date: 2001
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

# The applications to be compiled
TEST_APP_NAME = nscombobox nstabview nsimagecell popupbuttons testpb \
	nsprogressindicator matrix nsscroller nscursor buttons windows \
	fontpanel menu

nscombobox_OBJC_FILES = nscombobox.m
nstabview_OBJC_FILES = nstabview.m GSImageTabViewItem.m TestView.m
nstabview_RESOURCE_FILES = Smiley.tiff
nsimagecell_OBJC_FILES = nsimagecell.m
popupbuttons_OBJC_FILES = popupbuttons.m TestView.m
testpb_OBJC_FILES = testpb.m
nsprogressindicator_OBJC_FILES = nsprogressindicator.m
matrix_OBJC_FILES = matrix.m
nsscroller_OBJC_FILES = nsscroller.m
nscursor_OBJC_FILES = nscursor.m ColorView.m
buttons_OBJC_FILES = buttons.m
windows_OBJC_FILES = windows.m TestView.m
fontpanel_OBJC_FILES = fontpanel.m
menu_OBJC_FILES = menu.m

include $(GNUSTEP_MAKEFILES)/test-application.make
