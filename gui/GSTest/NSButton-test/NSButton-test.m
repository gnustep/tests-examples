/* NSButton-test.m: check continuous buttons

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

@interface NSButtonTest: NSObject <GSTest>
{
  NSWindow *win;
  NSTextView *text;
}
-(void) restart;
-(void) action: (id)sender;
@end

@implementation NSButtonTest: NSObject
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

  [vbox addSeparator];


  hbox = [GSHbox new];
  [hbox setDefaultMinXMargin: 5];
  [hbox setBorder: 0];

  button = [NSButton new];
  [button setFrame: NSMakeRect (0, 0, 64, 64)];
  [button setTitle: @"Click"];
  [button setAutoresizingMask: NSViewMaxXMargin];
  [button setTarget: self];
  [button setContinuous: YES];
  [button setAction: @selector (action:)];
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
  [win setTitle: @"Continuous button test"];

  [self restart];
  return self;
}

-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"Continuous button test"
				     filename: NO];
}

- (void) dealloc
{
  RELEASE (win);
  [super dealloc];
}

- (void) action: (id)sender
{
  [text replaceCharactersInRange: 
	  NSMakeRange ([[text textStorage] length], 0)
	withString: @"Action sent!\n"];
}
@end

