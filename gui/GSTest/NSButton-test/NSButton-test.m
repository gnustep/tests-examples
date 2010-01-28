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
  GSVbox *vbox;
}
-(void) restart;
-(void) action: (id)sender;
@end

@implementation NSButtonTest: NSObject


- (NSButton *) addButtonWithLabel: (NSString *)label
{
  NSButton *button = [NSButton new];
  [button setFrame: NSMakeRect (0, 0, 200, 32)];
  [button setTitle: label];
  [button setAutoresizingMask: NSViewMaxXMargin];
  [button setTarget: self];
  [button setContinuous: YES];
  [button setAction: @selector (action:)];
  [vbox addView: button];
  return [button autorelease];
}



- (NSButton *) addButtonWithLabel: (NSString *)label bezel: (NSBezelStyle)bezel
{
  NSButton *button = [self addButtonWithLabel: label];
  [button setBezelStyle: bezel];
  return button;
}



-(id) init
{
  NSScrollView *scrollView;
  NSRect winFrame;

  vbox = [GSVbox new];
  [vbox setDefaultMinYMargin: 1];
  [vbox setBorder: 5];

  scrollView = [[NSScrollView alloc] initWithFrame: 
				       NSMakeRect (0, 0, 300, 100)];
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

  [self addButtonWithLabel: @"NSButton"];
  [self addButtonWithLabel: @"NSRoundedBezelStyle" bezel: NSRoundedBezelStyle];
  [self addButtonWithLabel: @"NSRegularSquareBezelStyle" bezel: NSRegularSquareBezelStyle];
  [self addButtonWithLabel: @"NSThickSquareBezelStyle" bezel: NSThickSquareBezelStyle];
  [self addButtonWithLabel: @"NSThickerSquareBezelStyle" bezel: NSThickerSquareBezelStyle];
  [self addButtonWithLabel: @"NSDisclosureBezelStyle" bezel: NSDisclosureBezelStyle];
  [self addButtonWithLabel: @"NSShadowlessSquareBezelStyle" bezel: NSShadowlessSquareBezelStyle];
  [self addButtonWithLabel: @"NSCircularBezelStyle" bezel: NSCircularBezelStyle];
  [self addButtonWithLabel: @"NSTexturedSquareBezelStyle" bezel: NSTexturedSquareBezelStyle];
  [self addButtonWithLabel: @"NSHelpButtonBezelStyle" bezel: NSHelpButtonBezelStyle];
  [self addButtonWithLabel: @"NSSmallSquareBezelStyle" bezel: NSSmallSquareBezelStyle];
  [self addButtonWithLabel: @"NSTexturedRoundedBezelStyle" bezel: NSTexturedRoundedBezelStyle];
  [self addButtonWithLabel: @"NSRoundRectBezelStyle" bezel: NSRoundRectBezelStyle];
  [self addButtonWithLabel: @"NSRecessedBezelStyle" bezel: NSRecessedBezelStyle];
  [self addButtonWithLabel: @"NSRoundedDisclosureBezelStyle" bezel: NSRoundedDisclosureBezelStyle];

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
  RELEASE (vbox);
  [super dealloc];
}

- (void) action: (id)sender
{
  [text replaceCharactersInRange: 
	  NSMakeRange ([[text textStorage] length], 0)
	withString: [NSString stringWithFormat: @"Action sent from %@!\n", sender]];
}

@end

