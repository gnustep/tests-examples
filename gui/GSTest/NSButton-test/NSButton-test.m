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


- (NSTextField *) addLabel: (NSString *)label to: (id)box
{
  NSTextField *labelView = [NSTextField new];
  [labelView setStringValue: label];
  [labelView setFrame: NSMakeRect (0, 0, 250, 16)];
  [labelView setEditable: NO];
  [labelView setSelectable: NO];
  [labelView setBezeled: NO];
  [labelView setDrawsBackground: NO];
  [box addView: labelView];
  return [labelView autorelease];
}

- (NSButton *) addButtonWithLabel: (NSString *)label to: (id)box
{
  NSButton *button = [NSButton new];
  [button setFrame: NSMakeRect (0, 0, 200, 32)];
  [button setTitle: label];
  [button setAutoresizingMask: NSViewMaxXMargin];
  [button setTarget: self];
  [button setContinuous: YES];
  [button setAction: @selector (action:)];
  [button setToolTip: label];
  [box addView: button];
  return [button autorelease];
}

- (NSButton *) addButtonWithLabel: (NSString *)label bezel: (NSBezelStyle)bezel to: (id)box
{
  NSButton *button = [self addButtonWithLabel: label to: box];
  [button setBezelStyle: bezel];
  return button;
}

- (NSSegmentedControl *) addSegmentedControlWithLabel: (NSString *)label style: (NSSegmentStyle)style to: (id)box
{
  NSSegmentedControl *segmented = [NSSegmentedControl new];
  [segmented setFrame: NSMakeRect (0, 0, 200, 32)];
  [segmented setAutoresizingMask: NSViewMaxXMargin];
  [segmented setSegmentCount: 3];
  [segmented setSegmentStyle: style];

  [segmented setLabel: @"First" forSegment: 0];
  [segmented setLabel: @"Second" forSegment: 1];
  [segmented setLabel: @"Third" forSegment: 2];

  [segmented setTarget: self];
  [segmented setAction: @selector (action:)];

  [segmented setToolTip: label];

  [box addView: segmented];

  [self addLabel: label to: box];
  
  return [segmented autorelease];
}

- (NSComboBox *) addComboBoxWithLabel: (NSString *)label buttonBordered: (BOOL)button to: (id)box
{
  NSComboBox *combo = [NSComboBox new];
  [combo setFrame: NSMakeRect (0, 0, 200, 32)];
  [combo setAutoresizingMask: NSViewMaxXMargin];
  [combo setButtonBordered: button];

  [combo addItemWithObjectValue: @"First"];
  [combo addItemWithObjectValue: @"Second"];
  [combo addItemWithObjectValue: @"Third"];

  [combo setTarget: self];
  [combo setAction: @selector (action:)];

  [combo setToolTip: label];
 
  [box addView: combo];
  [self addLabel: label to: box];

  return [combo autorelease];
}

- (NSPopUpButton *) addPopUpButtonWithLabel: (NSString *)label pullsDown:(BOOL)pullsDown to: (id)box andItems:(NSArray *)items;
{
  NSUInteger i;
  NSPopUpButton *button = [NSPopUpButton new];
  
  [button setFrame: NSMakeRect (0, 0, 200, 32)];
  [button setPullsDown: pullsDown];
  [button setAutoresizingMask: NSViewMaxXMargin];

  for (i = 0; i < [items count]; i++)
    [button addItemWithTitle: [items objectAtIndex:i]];

  [button setTarget: self];
  [button setAction: @selector (action:)];

  [button setToolTip: label];

  [box addView: button];

  [self addLabel: label to: box];

  return [button autorelease];
}


- (NSPopUpButton *) addPopUpButtonWithLabel: (NSString *)label pullsDown:(BOOL)pullsDown to: (id)box
{
  NSMutableArray *arr;
  NSPopUpButton *button;

  arr = [NSMutableArray arrayWithCapacity:3];

  [arr addObject: @"First"];
  [arr addObject: @"Second"];
  [arr addObject: @"Third"];

  button = [self addPopUpButtonWithLabel: label pullsDown:pullsDown to:box andItems:arr];

  return button;
}

- (NSPopUpButton *) addPopUpButtonWithLabel: (NSString *)label pullsDown:(BOOL)pullsDown bezel:(NSBezelStyle)bezel to: (id)box
{
  NSPopUpButton *button = [self addPopUpButtonWithLabel: label pullsDown: pullsDown to: box];
  [button setBezelStyle: bezel];
  return button;
}

- (NSPopUpButton *) addPopUpButtonWithLabel: (NSString *)label pullsDown:(BOOL)pullsDown to: (id)box withItemCount:(NSUInteger)itemNum
{
  NSMutableArray *arr;
  NSPopUpButton *button;
  NSUInteger c;

  arr = [NSMutableArray arrayWithCapacity:itemNum];

  for (c = 0; c < itemNum; c++)
    {
      NSString *str;
      str = [NSString stringWithFormat:@"Item N. %lu", (unsigned long)c];
      [arr addObject: str];
    }

  button = [self addPopUpButtonWithLabel: label pullsDown:pullsDown to:box andItems:arr];

  return button;
}




-(id) init
{
  NSScrollView *scrollView;
  NSRect winFrame;
  GSVbox *vbox, *column;
  GSHbox *hbox;
  NSButton *button;

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

  hbox = [GSHbox new];
  [hbox setDefaultMinXMargin: 5];
 
  column = [GSVbox new];
  [column setDefaultMinYMargin: 2];
 
  [self addButtonWithLabel: @"NSButton" to: column];
  [self addButtonWithLabel: @"NSRoundedBezelStyle" bezel: NSRoundedBezelStyle to: column];
  [self addButtonWithLabel: @"NSRegularSquareBezelStyle" bezel: NSRegularSquareBezelStyle to: column];
  [self addButtonWithLabel: @"NSThickSquareBezelStyle" bezel: NSThickSquareBezelStyle to: column];
  [self addButtonWithLabel: @"NSThickerSquareBezelStyle" bezel: NSThickerSquareBezelStyle to: column];
  [self addButtonWithLabel: @"NSDisclosureBezelStyle" bezel: NSDisclosureBezelStyle to: column];
  [self addButtonWithLabel: @"NSShadowlessSquareBezelStyle" bezel: NSShadowlessSquareBezelStyle to: column];
  [self addButtonWithLabel: @"NSCircularBezelStyle" bezel: NSCircularBezelStyle to: column];
  [self addButtonWithLabel: @"NSTexturedSquareBezelStyle" bezel: NSTexturedSquareBezelStyle to: column];
  [self addButtonWithLabel: @"NSHelpButtonBezelStyle" bezel: NSHelpButtonBezelStyle to: column];
  [self addButtonWithLabel: @"NSSmallSquareBezelStyle" bezel: NSSmallSquareBezelStyle to: column];
  [self addButtonWithLabel: @"NSTexturedRoundedBezelStyle" bezel: NSTexturedRoundedBezelStyle to: column];
  [self addButtonWithLabel: @"NSRoundRectBezelStyle" bezel: NSRoundRectBezelStyle to: column];
  [self addButtonWithLabel: @"NSRecessedBezelStyle" bezel: NSRecessedBezelStyle to: column];
  [self addButtonWithLabel: @"NSRoundedDisclosureBezelStyle" bezel: NSRoundedDisclosureBezelStyle to: column];

  [hbox addView: column];  
  RELEASE(column);

  column = [GSVbox new];
  [column setDefaultMinYMargin: 2];
 
  [self addSegmentedControlWithLabel: @"NSSegmentStyleAutomatic" style: NSSegmentStyleAutomatic to: column];
  [self addSegmentedControlWithLabel: @"NSSegmentStyleRounded" style: NSSegmentStyleRounded to: column];
  [self addSegmentedControlWithLabel: @"NSSegmentStyleTexturedRounded" style: NSSegmentStyleTexturedRounded to: column];
  [self addSegmentedControlWithLabel: @"NSSegmentStyleRoundRect" style: NSSegmentStyleRoundRect to: column];
  [self addSegmentedControlWithLabel: @"NSSegmentStyleTexturedSquare" style: NSSegmentStyleTexturedSquare to: column];
  [self addSegmentedControlWithLabel: @"NSSegmentStyleCapsule" style: NSSegmentStyleCapsule to: column];
  [self addSegmentedControlWithLabel: @"NSSegmentStyleSmallSquare" style: NSSegmentStyleSmallSquare to: column];

  [column addSeparator];

  button = [self addButtonWithLabel: @"Disabled Button" to: column];
  [button setEnabled: NO];

  button = [self addButtonWithLabel: @"PushOnPushOff Button" to: column];
  [button setButtonType: NSPushOnPushOffButton];

  button = [self addButtonWithLabel: @"Disabled PushOnPushOff Button" to: column];
  [button setButtonType: NSPushOnPushOffButton];
  [button setState: NSOnState];
  [button setEnabled: NO];

  [hbox addView: column];  
  RELEASE(column);

  column = [GSVbox new];
  [column setDefaultMinYMargin: 2];

  [self addPopUpButtonWithLabel: @"NSPopUpButton" pullsDown:NO to: column]; 
  [self addPopUpButtonWithLabel: @"NSPopUpButton pullsDown" pullsDown:YES to: column]; 
  [self addPopUpButtonWithLabel: @"NSPopUpButton NSRoundedBezelStyle" pullsDown:NO bezel: NSRoundedBezelStyle to: column];
  [self addPopUpButtonWithLabel: @"NSPopUpButton 500 items" pullsDown:NO to: column withItemCount:500]; 
  [self addPopUpButtonWithLabel: @"NSPopUpButton 100 items" pullsDown:NO to: column withItemCount:100]; 

  [hbox addView: column];  
  RELEASE(column);

  column = [GSVbox new];
  [column setDefaultMinYMargin: 2];
 
  [self addComboBoxWithLabel: @"NSComboBox" buttonBordered: NO to: column];
  [self addComboBoxWithLabel: @"NSComboBox buttonBordered" buttonBordered: YES to: column];

  [hbox addView: column];
  RELEASE(column);

  [vbox addView: hbox];
  RELEASE(hbox);

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
  [super dealloc];
}

- (void) action: (id)sender
{
  [text replaceCharactersInRange: 
	  NSMakeRange ([[text textStorage] length], 0)
	withString: [NSString stringWithFormat: @"Action sent from %@!\n", sender]];
}

@end

