/* testList.h: List of Implemented Tests 

   Copyright (C) 1999 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 1999
   
   This file is part of GNUstep.
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. */

//
// If you want to write a new test, read this. 
//

//
// Each test is stored in a bundle.
// A bundle is a bunch of resources (executable stuff too) 
// which can be dinamically loaded at run-time. 
//

//
// When the user selects a test from the menu for the first time, 
// the main program looks for the corresponding bundle, and 
// loads the "principal Class" of that bundle.  (which class is the 
// principal class is specified in the GNUmakefile for that bundle). 
// An instance of this principal Class is allocated and initialized. 
// This should run the test, usually creating windows, gui objects, etc. 
//
// Afterwards, each time the user selects the test again, 
// the main program sends a "-restart" message to this instance of the 
// principal class.  The expected behaviour is that -restart should 
// bring all the windows to front.  If the test wants, it may also reset 
// values to defaults or whatever. 
// 
// Releasing of tests after use would be easy to implement, but not really 
// useful, so not implemented by now.
//
 
//
// This file contains the list of currently implemented test. 
// 

// Number of tests in the list
#define TEST_NUMBER 13
struct 
{
  NSString *menuName;      // Name shown on the menu
  NSString *bundleName;    // Name of the bundle (without the extension .bundle)  
} 
testList[TEST_NUMBER] = 
{
  // Add your tests in this list, and update TEST_NUMBER above.
  {@"Composite", @"Composite-test"},
  {@"GSHbox", @"GSHbox-test"},
  {@"Keyboard Input", @"KeyboardInput-test"},
  {@"NSBox", @"NSBox-test"},
  {@"NSColorList", @"NSColorList-test"},
  {@"NSColorWell", @"NSColorWell-test"},
  {@"NSForm", @"NSForm-test"},
  {@"NSSavePanel", @"NSSavePanel-test"},
  {@"NSScrollView", @"NSScrollView-test"},
  {@"NSSlider", @"NSSlider-test"},
  {@"NSSplitView", @"NSSplitView-test"},
  {@"NSTableView", @"NSTableView-test"},
  {@"StringDrawing", @"StringDrawing-test"}
};

struct 
{
  BOOL isStarted;             // YES after the test is started
  id principalClassInstance;  // this is to send "restart" messages to it
}
testState[TEST_NUMBER];

