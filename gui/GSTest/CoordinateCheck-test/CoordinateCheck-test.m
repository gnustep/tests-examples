/* CoordinateCheck-test.m: checking coordinate sanity in other windows

   Copyright (C) 2001 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 2001
   
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
#include <GNUstepGUI/GSHbox.h>
#include <GNUstepGUI/GSVbox.h>
#include "../GSTestProtocol.h"

/* The checking categories */

@implementation NSView (CheckCoordinates)
- (NSString *) checkCoordinates
{
  NSRect rect1, rect2;

  rect1 = [self convertRect: _bounds  toView: nil];
  rect2 = [[self superview] convertRect: _frame  toView: nil];
  
  if (NSEqualRects (rect1, rect2) != YES)
    {
      NSMutableString *string;
      
      string = AUTORELEASE ([NSMutableString new]);
      [string appendFormat: @"%@: INVALID - \n", self];
      [string appendFormat: @"    bounds in window space are: `%@'\n", 
	      NSStringFromRect (rect1)];
      [string appendFormat: @"    frame in window space is: `%@'\n", 
	      NSStringFromRect (rect2)];
      return string;
    }
  else
    {
      return [NSString stringWithFormat: @"%@: Ok\n", self];
    } 
}

- (NSString *) recursivelyCheckCoordinates
{
  int i, count;
  NSMutableString *string;

  string = AUTORELEASE ([NSMutableString new]);
  
  [string appendString: [self checkCoordinates]];
  
  count = [[self subviews] count];

  for (i = 0; i < count; i++)
    {
      NSView *v;

      v = [[self subviews] objectAtIndex: i];
      [string appendString: [v recursivelyCheckCoordinates]];
    }

  return string;
}

@end

@interface NSView (CheckCoordinates)
- (NSString *) checkCoordinates;
@end

@implementation NSWindow (CheckCoordinates)
- (NSString *) checkCoordinates
{
  return [[self contentView] recursivelyCheckCoordinates];
}
@end

@interface NSWindow (CheckCoordinates)
- (NSString *) checkCoordinates;
@end

/* Now the test itself */

@interface CoordinateCheckTest: NSObject <GSTest>
{
  NSTextField *windowName;
  NSTextView *text;
  NSWindow *win;

  NSWindow *winToCheck;
}
-(void) restart;
-(void) check: (id)sender;
-(void) choose: (id)sender;
-(void) reset: (id)sender;
@end

@implementation CoordinateCheckTest: NSObject
{
  // for instance variables see above
}
-(id) init
{
  GSHbox *hbox;
  GSVbox *vbox;
  NSButton *button;
  NSScrollView *scrollView;
  NSRect winFrame;

  vbox = [GSVbox new];
  [vbox setDefaultMinYMargin: 5];
  [vbox setBorder: 5];

  scrollView = [[NSScrollView alloc] initWithFrame: 
				       NSMakeRect (0, 0, 300, 300)];
  [scrollView setHasHorizontalScroller: NO];
  [scrollView setHasVerticalScroller: YES]; 
  [scrollView setAutoresizingMask: NSViewHeightSizable | NSViewWidthSizable];

  text = [[NSText alloc] initWithFrame: [[scrollView contentView] frame]];
  [text setEditable: NO];
  [text setRichText: YES];
  [text setDelegate: self];
  [text setHorizontallyResizable: NO];
  [text setVerticallyResizable: YES];
  [text setMinSize: NSMakeSize (0, 0)];
  [text setMaxSize: NSMakeSize (1E7, 1E7)];
  [text setAutoresizingMask: NSViewHeightSizable | NSViewWidthSizable];
  [[text textContainer] setContainerSize: NSMakeSize ([text frame].size.width,
						      1e7)];
  [[text textContainer] setWidthTracksTextView: YES];
  [scrollView setDocumentView: text];
  RELEASE(text);

  [vbox addView: scrollView];
  RELEASE (scrollView);

  windowName = [NSTextField new];
  [windowName setEditable: NO];
  [windowName setSelectable: NO];
  [windowName setBezeled: NO];
  [windowName setDrawsBackground: NO];
  [windowName setAutoresizingMask: NSViewMaxXMargin];
  [windowName setStringValue: @"Window Title: (null)"];
  [windowName sizeToFit];
  [vbox addView: windowName  enablingYResizing: NO];
  RELEASE (windowName);

  [vbox addSeparator];


  hbox = [GSHbox new];
  [hbox setDefaultMinXMargin: 5];
  [hbox setBorder: 0];

  button = [NSButton new];
  [button setFrame: NSMakeRect (0, 0, 64, 64)];
  [button setTitle: @"Choose\nWindow"];
  [button setAutoresizingMask: NSViewMaxXMargin];
  [button setTarget: self];
  [button setAction: @selector (choose:)];
  [hbox addView: button];
  RELEASE (button);

  button = [NSButton new];
  [button setFrame: NSMakeRect (0, 0, 64, 64)];
  [button setTitle: @"Check\nWindow"];
  [button setAutoresizingMask: NSViewMaxXMargin];
  [button setTarget: self];
  [button setAction: @selector (check:)];
  [hbox addView: button];
  RELEASE (button);

  button = [NSButton new];
  [button setFrame: NSMakeRect (0, 0, 64, 64)];
  [button setTitle: @"Reset"];
  [button setAutoresizingMask: NSViewMaxXMargin];
  [button setTarget: self];
  [button setAction: @selector (reset:)];
  [hbox addView: button];
  RELEASE (button);

  [hbox setAutoresizingMask: NSViewNotSizable];

  [vbox addView: hbox  enablingYResizing: NO];
  RELEASE (hbox);

  [vbox setAutoresizingMask: NSViewHeightSizable | NSViewWidthSizable];
  
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
  [win setMinSize: [win frame].size];
  RELEASE (vbox);
  [win setTitle: @"Coordinate Check Test"];

  [text setString: @"To select the window to check -\npress `Choose Window' and then click\ninside the window you want to choose\n"];

  [self restart];
  return self;
}

-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"Coordinate Check Test"
				     filename: NO];
}

- (void) dealloc
{
  RELEASE (win);
  RELEASE (winToCheck);
  [super dealloc];
}

- (void) choose: (id)sender
{
  NSEvent *event;
  
  event = [NSApp nextEventMatchingMask: NSLeftMouseDownMask
		 untilDate: nil
		 inMode: NSEventTrackingRunLoopMode
		 dequeue: YES];
  
  ASSIGN (winToCheck, [event window]);
  [windowName setStringValue: [NSString stringWithFormat: @"Window Title: %@",
					[winToCheck title]]];
  [windowName sizeToFit];
}

- (void) check: (id)sender
{
  if (winToCheck == nil)
    {
      [text replaceCharactersInRange: 
	      NSMakeRange ([[text textStorage] length], 0)
	    withString: @"Please select a window first -\nby pressing `Choose Window'\nand then clicking inside the window\nyou want to select\n"];      
    }
  else
    {
      NSString *newCheck = [winToCheck checkCoordinates];

      [text replaceCharactersInRange: 
	      NSMakeRange ([[text textStorage] length], 0)
	 withString: [NSString stringWithFormat: @" - %@ -\n", 
			       [winToCheck title]]];

      [text replaceCharactersInRange: 
	      NSMakeRange ([[text textStorage] length], 0)
	 withString: newCheck];

      [text replaceCharactersInRange: 
	      NSMakeRange ([[text textStorage] length], 0)
	 withString: [NSString stringWithFormat: @"\n", 
			       [winToCheck title]]];
    }
}

- (void) reset: (id)sender
{
  [text setString: @""];
}


@end

