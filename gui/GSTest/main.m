/* main.m: Main Body of GNUstep Gui demo suite

   Copyright (C) 1999, 2000 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 1999, 2000
   
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
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "GSTestProtocol.h"
#include "testList.h"
#include "MemoryPanel.h"

#define GSTEST_VERSION @"0.8"
#define GSTEST_FULLID @"CVS $Date$"

// If you want to add a test, please refer to testList.h 

@interface Controller: NSObject
{
  NSString *bundlesPath;
}
-(void) runInfoPanel: (id) sender;
-(void) startListedTest: (id) sender;
-(void) startUnlistedTest: (id) sender;
-(void) restartTest: (id) testObject;
-(id) loadAndStartTestWithBundlePath: (NSString *)fullPath;
@end

@implementation Controller
{
  // See above for instance variables
}

-(id) init 
{
  [super init];
  // The test bundles are one directory up
  bundlesPath = [[[[NSBundle mainBundle] bundlePath] 
		   stringByDeletingLastPathComponent] retain];
  return self;
}

-(void) runInfoPanel: (id) sender
{
  NSMutableDictionary *d;

  d = AUTORELEASE ([NSMutableDictionary new]);
  [d setObject: @"GSTest" forKey: @"ApplicationName"];
  [d setObject: @"GNUstep GUI Demo/Test Suite" 
     forKey: @"ApplicationDescription"];
  [d setObject: GSTEST_VERSION forKey: @"ApplicationRelease"];
  [d setObject: GSTEST_FULLID forKey: @"FullVersionID"];
  [d setObject: [NSArray arrayWithObject: 
			   @"Nicola Pero <n.pero@mi.flashnet.it>"]
     forKey: @"Authors"];
  //  [d setObject: @"See http://www.gnustep.org" forKey: @"URL"];
  [d setObject: @"Copyright (C) 1999, 2000, 2001 Free Software Foundation, Inc."
     forKey: @"Copyright"];
  [d setObject: @"Released under the GNU General Public License 2.0"
     forKey: @"CopyrightDescription"];
  
  [NSApp orderFrontStandardInfoPanelWithOptions:d];
}

-(void) dealloc
{
  RELEASE(bundlesPath);
  [super dealloc];
}

-(void) restartTest: (id) testObject
{
  if ([testObject conformsToProtocol: @protocol(GSTest)])
    [(<GSTest>)testObject restart];
  else // ! conform to protocl:
    NSRunAlertPanel (NULL, @"The object doesn't conform to GSTest protocol", 
		     @"OK", NULL, NULL);
}

-(id) loadAndStartTestWithBundlePath: (NSString *)fullPath
{
  NSBundle *bundle;
  Class principalClass;
  
  // Load the bundle
  bundle = [NSBundle bundleWithPath: fullPath]; 
  if (bundle) // Bundle was succesfully loaded
    {
      // Load the principal class of the bundle 
      principalClass = [bundle principalClass];
      if (principalClass) // succesfully loaded 
	return [principalClass new];
      else // !principalClass
	{
	  NSRunAlertPanel (NULL, @"Could not load principal class", 
			   @"OK", NULL, NULL);
	  return nil;
	}
    }
  else // !bundle
    {
      NSRunAlertPanel (NULL, @"Could not load Bundle", 
		       @"OK", NULL, NULL);
      return nil;
    }
} 

-(void) startListedTest: (id) sender
{
  int i;

  i = [sender tag];
  if (testState[i].isStarted) 
    {
      [self restartTest: testState[i].principalClassInstance];
      return;
    }
  else // !testState[i].isStarted
    {
      NSString *bundlePath;
      
      // Determine which Bundle to load.  Bundles are as in 
      // bundlesPath/NSScrollView-test/NSScrollView-test.bundle
      bundlePath = [[[bundlesPath stringByAppendingPathComponent: 
				    testList[i].bundleName] 
		      stringByAppendingPathComponent: testList[i].bundleName]
		     stringByAppendingPathExtension: @"bundle"];
      testState[i].principalClassInstance 
	= [self loadAndStartTestWithBundlePath: bundlePath];
      if (testState[i].principalClassInstance)
	testState[i].isStarted = YES;
    }
}
-(void) startUnlistedTest: (id) sender
{
  NSOpenPanel *openPanel;
  int result;

  openPanel = [NSOpenPanel openPanel];
  [openPanel setTitle: @"Select Bundle"];
  [openPanel setPrompt: @"Bundle:"];
  [openPanel setTreatsFilePackagesAsDirectories: NO];
  result = [openPanel runModalForDirectory: nil
		      file: nil
		      types: [NSArray arrayWithObject: @"bundle"]];
  if (result == NSOKButton)
    {
      NSEnumerator *e = [[openPanel filenames] objectEnumerator];
      NSString *file;
      
      while ((file = (NSString *)[e nextObject]))
	{
	  [self loadAndStartTestWithBundlePath: file];
	}
    }
}
@end

int main (void)
{ 
   NSAutoreleasePool *pool;
   NSApplication *app;
   NSMenu *mainMenu;
   NSMenu *infoMenu;
   NSMenu *testMenu;
   NSMenu *windowsMenu;
   NSMenuItem *menuItem;
   Controller *appController;
   int i;

   pool = [NSAutoreleasePool new];

   app = [NSApplication sharedApplication];
   // Main Menu 
   mainMenu = AUTORELEASE ([[NSMenu alloc] initWithTitle: @"GNUstep Test"]);
   // Info SubMenu
   menuItem = [mainMenu addItemWithTitle: @"Info" 
			action: NULL 
			keyEquivalent: @""];
   infoMenu = AUTORELEASE ([NSMenu new]);
   [mainMenu setSubmenu: infoMenu forItem: menuItem];
   [infoMenu addItemWithTitle: @"Info Panel..." 
	     action: @selector (runInfoPanel:) 
	     keyEquivalent: @""];
   [infoMenu addMemoryPanelSubmenu];
   [infoMenu addItemWithTitle: @"Help..." 
	     action: @selector (orderFrontHelpPanel:)
	     keyEquivalent: @"?"];
   // Test SubMenu
   menuItem = [mainMenu addItemWithTitle:@"Tests" 
			action: NULL 
			keyEquivalent:@""];
   testMenu = AUTORELEASE ([NSMenu new]);
   [mainMenu setSubmenu: testMenu forItem: menuItem];
   menuItem = [testMenu addItemWithTitle: @"Test Not in the List..." 
			action: @selector (startUnlistedTest:)
			keyEquivalent: @""];
   for (i = 0; i < TEST_NUMBER; i++)
     {
       menuItem = [testMenu addItemWithTitle: testList[i].menuName
			    action: @selector (startListedTest:)
			    keyEquivalent: @""];
       [menuItem setTag: i]; 
       testState[i].isStarted = NO;
     }
   // Windows SubMenu
   menuItem = [mainMenu addItemWithTitle:@"Windows" 
			action: NULL 
			keyEquivalent:@""];
   windowsMenu = AUTORELEASE ([NSMenu new]);
   [mainMenu setSubmenu: windowsMenu forItem: menuItem];
   // Hide MenuItem
   [mainMenu addItemWithTitle: @"Hide" 
	     action: @selector (hide:)
	     keyEquivalent: @"h"];	
   // Quit MenuItem
   [mainMenu addItemWithTitle: @"Quit" 
	     action: @selector (terminate:)
	     keyEquivalent: @"q"];	
   // 
   [app setMainMenu: mainMenu];
   [app setWindowsMenu: windowsMenu];
   [mainMenu display];
   appController = [Controller new];
   [app setDelegate: appController];

   RELEASE (pool);
   pool = [NSAutoreleasePool new];
   [app run];
   RELEASE (appController); 
   RELEASE (pool);
   return 0;
}

