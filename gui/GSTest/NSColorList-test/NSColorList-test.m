/* NSColorList-test.m: NSColorList class test

   Copyright (C) 2000 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 2000
   
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
#include <AppKit/GSHbox.h>
#include <AppKit/GSVbox.h>
#include "../GSTestProtocol.h"

static void 
create_test_color_list (void)
{
  if ([NSColorList colorListNamed: @"test"])
    return;
  else 
    {
      NSColorList *testList;
      
      NSRunAlertPanel (NULL, @"Creating a new test color list", 
		       @"OK", NULL, NULL);
      
      testList = AUTORELEASE ([[NSColorList alloc] initWithName: @"test"]);
      [testList setColor: [NSColor blackColor]
		forKey: @"Black"];
      [testList setColor: [NSColor redColor]
		forKey: @"Red"];
      [testList setColor: [NSColor yellowColor]
		forKey: @"Yellow"];
      [testList setColor: [NSColor blueColor]
		forKey: @"Blue"];
      [testList setColor: [NSColor orangeColor]
		forKey: @"Orange"];
      [testList setColor: [NSColor greenColor]
		forKey: @"Green"];
      [testList setColor: [NSColor grayColor]
		forKey: @"Gray"];
      [testList setColor: [NSColor brownColor]
		forKey: @"Brown"];
      // Test remove
      [testList setColor: [NSColor darkGrayColor]
		forKey: @"DarkGray"];
      [testList removeColorWithKey: @"DarkGray"];
      // Test Insert
      [testList insertColor: [NSColor whiteColor]
		key: @"White"
		atIndex: 0];
      // Test Implicit replace
      [testList setColor: [NSColor yellowColor]
		forKey: @"Purple"];
      [testList setColor: [NSColor purpleColor]
		forKey: @"Purple"];
      [testList writeToFile: nil];
    }
}

@interface NSColorListTest: NSObject <GSTest>
{
  NSBrowser *browser;
  NSWindow *win;
}
-(void)restart;
-(void)showColorList: (id)sender;
// Browser delegate methods
-(NSString *)browser: (NSBrowser *)sender 
       titleOfColumn: (int)column;
-(void)browser: (NSBrowser *)sender 
createRowsForColumn: (int)column
      inMatrix: (NSMatrix *)matrix;
-(void)browser: (NSBrowser *)sender 
willDisplayCell: (id)cell
	 atRow: (int)row 
	column: (int)column;
@end

@implementation NSColorListTest: NSObject
{
  // for instance variables see above
}
-(id) init
{
  GSVbox *vbox;
  NSRect winFrame;
  NSTextField *text;

  create_test_color_list ();
  
  vbox = [GSVbox new];
  [vbox setDefaultMinYMargin: 5];
  [vbox setBorder: 5];

  // Some help
  text = [NSTextField new];
  [text setEditable: NO];
  [text setBezeled: NO];
  [text setDrawsBackground: NO];
  [text setStringValue: @"DoubleClick on a list to display"];
  [text sizeToFit];
  [text setAutoresizingMask: (NSViewMinYMargin | NSViewMaxYMargin 
			      | NSViewMinXMargin | NSViewMaxXMargin)];
  [vbox addView: text];
  [text release];  
  
  // We use a browser with one column to get a selection list
  browser = [[NSBrowser alloc] initWithFrame: NSMakeRect (0, 0, 200, 200)];
  [browser setDelegate: self];
  [browser setMaxVisibleColumns: 1];
  [browser setAllowsMultipleSelection: NO];
  [browser setAllowsEmptySelection: NO];
  [browser setHasHorizontalScroller: NO];
  [browser setTitled: YES];
  [browser setTakesTitleFromPreviousColumn: NO];
  [browser setPath: @"/"];
  [browser setTarget: self];
  [browser setDoubleAction: @selector(showColorList:)];
  
  [vbox addView: browser];
  [browser release];

  // Window
  winFrame.size = [vbox frame].size;
  winFrame.origin = NSMakePoint (100, 100);
  
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  
  [win setContentView: vbox];
  [vbox release];
  [win setTitle: @"NSColorList Test"];
  
  [self restart];
  return self;
}
-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSColorList Test"
				     filename: NO];
}
-(void) dealloc
{
  [win release];
  [super dealloc];
}
-(void) showColorList: (id)sender
{
  NSColorList *cl;
  NSWindow *w;
  NSScrollView *scrollView;
  GSVbox *vbox;
  NSEnumerator *e;
  GSHbox *hbox;
  NSTextField *text;
  NSColorWell *color;
  NSString *name;

  cl = (NSColorList *)[[sender selectedCell] representedObject];

  vbox = [GSVbox new];
  [vbox setDefaultMinYMargin: 5];

  e = [[cl allKeys] objectEnumerator];
  
  while ((name = [e nextObject]))
    {
      hbox = [GSHbox new];
      [hbox setDefaultMinXMargin: 10];

      text = [NSTextField new];
      [text setEditable: NO];
      [text setBezeled: NO];
      [text setDrawsBackground: NO];
      [text setStringValue: name];
      [text sizeToFit];
      [text setAutoresizingMask: (NSViewMinYMargin | NSViewMaxYMargin)];
      [hbox addView: text];
      [text autorelease];

      color = [[NSColorWell alloc] initWithFrame: NSMakeRect (0, 0, 50, 50)];
      [color setColor: [cl colorWithKey: name]];
      [color setAutoresizingMask: NSViewMinXMargin];
      [hbox addView: color];
      [color autorelease];

      [hbox setAutoresizingMask: NSViewWidthSizable];
      [vbox addView: hbox];
    }

  scrollView = [[NSScrollView alloc] 
		 initWithFrame: NSMakeRect (0, 0, 150, 300)];
  [scrollView setDocumentView: vbox];
  [vbox autorelease];
  [scrollView setHasHorizontalScroller: NO];
  [scrollView setHasVerticalScroller: YES];
  [scrollView setBorderType: NSBezelBorder];
  [scrollView setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
  
  w = [[NSWindow alloc] initWithContentRect: NSMakeRect (100, 100, 150, 300)
			styleMask: (NSTitledWindowMask 
				    | NSClosableWindowMask 
				    | NSMiniaturizableWindowMask 
				    | NSResizableWindowMask)
			backing: NSBackingStoreBuffered
			defer: NO];
  
  [w setContentView: scrollView];
  [scrollView release];
  [w setTitle: [cl name]];
  [w setReleasedWhenClosed: YES];
  [w orderFront: self];
}
-(NSString *)browser: (NSBrowser *)sender 
       titleOfColumn: (int)column
{
  if (column == 0)
    return @"Available Color Lists";
  else 
    {
      NSLog (@"Bug: Asking title of column > 0!");
      return @"Bug: Column > 0!";
    }
}
-(void)browser: (NSBrowser *)sender 
createRowsForColumn: (int)column
      inMatrix: (NSMatrix *)matrix
{
  int i;
  int count;
  NSBrowserCell *cell;
  NSArray *colorLists;
  NSColorList *cl;

  colorLists = [NSColorList availableColorLists];
  count = [colorLists count];
  
  if (count)
    {
      [matrix addColumn];
      for (i = 0; i < count; i++)
	{
	  if (i > 0)
	    [matrix addRow];
	  cl = (NSColorList *)[colorLists objectAtIndex: i];
	  cell = [matrix cellAtRow: i
			 column: 0];
	  [cell setStringValue: [cl name]];
	  [cell setRepresentedObject: cl];
	  [cell setLeaf: YES];
	}
    }
} 
- (void)browser: (NSBrowser *)sender 
willDisplayCell: (id)cell
	  atRow: (int)row 
	 column: (int)column
{
}
@end

