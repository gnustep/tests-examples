/* EncodingDecoding-test.m: Encoding/deconding windows demo/test

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
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include <AppKit/GSHbox.h>
#include <AppKit/GSVbox.h>
#include "../GSTestProtocol.h"

@interface EncodingDecodingTest: NSObject <GSTest>
{
  NSBrowser *browser;
  NSWindow *win;
}
-(void)restart;
// Reacting to button press
-(void)encode: (id)sender;
-(void)decode: (id)sender;
-(void)openWindow: (id)sender;
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
// Called from the app upon updating of windows
-(void) updateBrowser: (NSNotification *)aNotification;
@end

@implementation EncodingDecodingTest: NSObject
{
  // for instance variables see above
}
-(id) init
{
  GSVbox *vbox;
  GSVbox *vvbox;
  NSBox *box;
  NSButton *button;
  NSRect winFrame;
  
  vbox = [GSVbox new];
  [vbox setDefaultMinYMargin: 5];
  [vbox setBorder: 5];
  
  // Decoding 
  button = [NSButton new];
  [button setTitle: @"Decode from File..."];
  [button sizeToFit];
  [button setAutoresizingMask: NSViewMinXMargin | NSViewMaxXMargin];
  [button setTarget: self];
  [button setAction: @selector (decode:)];
  
  box = [NSBox new];
  [box setTitle: @"Decoding a Window"];
  [box setTitlePosition: NSAtTop];
  [box addSubview: button];
  [button release];
  [box sizeToFit];
  [box setAutoresizingMask: NSViewWidthSizable];
  
  [vbox addView: box];
  
  //Encoding 
  
  vvbox = [GSVbox new];
  [vvbox setDefaultMinYMargin: 5];
  
  button = [NSButton new];
  [button setTitle: @"Encode to File..."];
  [button sizeToFit];
  [button setAutoresizingMask: NSViewMinXMargin | NSViewMaxXMargin];
  [button setTarget: self];
  [button setAction: @selector (encode:)];
  [vvbox addView: button];
  [button release];
  
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
  [browser setDoubleAction: @selector(openWindow:)];
  [browser setTarget: self];
  // We want to be informed when the windows change, so that we can
  // update the selection list.  What we do is monitoring the windows
  // menu -- better than nothing and at least it should work.
  [[NSNotificationCenter defaultCenter] 
    addObserver: self 
    selector: @selector(updateBrowser:)
    name: NSMenuDidAddItemNotification
    object: (id)[[NSApplication sharedApplication] windowsMenu]];
  [[NSNotificationCenter defaultCenter] 
    addObserver: self 
    selector: @selector(updateBrowser:)
    name: NSMenuDidRemoveItemNotification
    object: (id)[[NSApplication sharedApplication] windowsMenu]];
  [[NSNotificationCenter defaultCenter] 
    addObserver: self 
    selector: @selector(updateBrowser:)
    name: NSMenuDidChangeItemNotification
    object: (id)[[NSApplication sharedApplication] windowsMenu]];
  
  [browser setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
  [vvbox addView: browser];
  [vvbox setAutoresizingMask: NSViewWidthSizable];
  
  box = [NSBox new];
  [box setTitle: @"Encoding a Window"];
  [box setTitlePosition: NSAtTop];
  [box addSubview: vvbox];
  [vvbox release];
  [box sizeToFit];
  [box setAutoresizingMask: NSViewWidthSizable];
  
  [vbox addView: box];
  
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
  [win setReleasedWhenClosed: NO];
  [win setContentView: vbox];
  [vbox release];
  [win setTitle: @"Encoding-Decoding Test"];
  
  [self restart];
  return self;
}
-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"Encoding-Decoding Test"
				     filename: NO];
}
-(void) dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver: self];
  RELEASE(win);
  [super dealloc];
}
-(void)encode: (id)sender
{
  NSSavePanel *s;
  NSWindow *w;
  int result;
  
  // Get at once the window 
  w = [[browser selectedCell] representedObject];

  if (!w || ![w isKindOfClass: [NSWindow class]])
    {
      NSRunCriticalAlertPanel (@"Error", 
			       @"You must choose a valid window", 
			       @"OK", nil, nil);
      return;
    }

  s = [NSSavePanel savePanel];
  result = [s runModal];
  
  if (result == NSOKButton)
    {
      BOOL result = NO;
      NSString *exception = nil;

      NS_DURING
	{
	  result = [NSArchiver archiveRootObject: w
			       toFile: [s filename]];
	}
      NS_HANDLER
	{
	  exception = [localException description];
	  result = NO;
	}
      NS_ENDHANDLER

	if (result == NO)
	  {
	    if (exception == nil)
	      {
		exception = @"UnknownProblem";
	      }

	    NSRunCriticalAlertPanel (@"Error", 
				     @"Error encoding to file %@:\n%@", 
				     @"OK", nil, nil, 
				     [s filename], exception);
	  }
    }
}

  
-(void)decode: (id)sender
{
  NSOpenPanel *o;
  id w = nil;
  int result;
  
  o = [NSOpenPanel openPanel];
  result = [o runModalForTypes: nil];
  
  if (result == NSOKButton)
    { 
      NSArray *f = [o filenames];
      int count = [f count];
      int i;
      BOOL error_panels = YES;
      NSString *file;

      for (i = 0; i < count; i++) 
	{
	  file = [f objectAtIndex: i];

	  NS_DURING
	    {
	      w = [NSUnarchiver unarchiveObjectWithFile: file];
	    }
	  NS_HANDLER
	    {
	      w = nil;
	    }
	  NS_ENDHANDLER

          if (w == nil)
	    {
	      if (error_panels)
		{
		  int p = NSRunCriticalAlertPanel (@"Error", 
						   @"Error decoding file %@", 
						   @"OK", @"OK to all", nil, 
						   [f objectAtIndex: i]);
		  if (p == NS_ALERTALTERNATE)
		    error_panels = NO;
		}
	    }
	  else 
	    {
	      if ([w isKindOfClass: [NSWindow class]])
		{
		  [w orderFront: self];
		  RETAIN (w);
		}
	      else
		{
		  if (error_panels)
		    {
		      int p = NSRunCriticalAlertPanel (@"Error", 
						       @"Object in file %@ is not a window", 
						       @"OK", @"OK to all", nil,
						       [f objectAtIndex: i]);
		      if (p == NS_ALERTALTERNATE)
			error_panels = NO;
		    } 
		}
	    }
	}
    }
}
-(void) openWindow: (id)sender
{
  id w;

  w = [[sender selectedCell] representedObject];
  [w orderFront: self];
}
-(NSString *)browser: (NSBrowser *)sender 
       titleOfColumn: (int)column
{
  if (column == 0)
    return @"Choose a Window to Encode";
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
  int j;
  NSBrowserCell *cell;
  NSArray *windows;
  NSWindow *w;

  windows = [[NSApplication sharedApplication] windows];
  count = [windows count];
  
  [matrix addColumn];
  j = 0;
  for (i = 0; i < count; i++)
    {
      w = [windows objectAtIndex: i];
      // In practice, we show all interesting test windows 
      // already started, both visible and out of screen
      // We do not manage our own window, 
      // because we don't want to get into release/retain/etc problems.
      if (![w isExcludedFromWindowsMenu] && (w != win))
	{
	  if (j > 0)
	    [matrix addRow];
	  
	  cell = [matrix cellAtRow: j
			 column: 0];
	  [cell setStringValue: [w title]];
	  // Warning: this retains w!  It should be safe in this case.
	  [cell setRepresentedObject: w];
	  [cell setLeaf: YES];
	  j++;
	}
    }
  if (j == 0)
    [matrix removeColumn: 0];
  
  //  [browser tile];
} 
- (void)browser: (NSBrowser *)sender 
willDisplayCell: (id)cell
	  atRow: (int)row 
	 column: (int)column
{
}
-(void) updateBrowser: (NSNotification *)aNotification
{
  [browser reloadColumn: 0];
}
@end
