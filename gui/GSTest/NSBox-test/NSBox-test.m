/* NSBox-test.m: NSBox class demo/test

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
#include "../GSTestProtocol.h"

@interface NSBoxTest: NSObject <GSTest>
{
  NSWindow *win;
  NSBox *box;
}
-(void) restart;
-(void) setNSNoBorder: (id)sender;
-(void) setNSLineBorder: (id)sender;
-(void) setNSBezelBorder: (id)sender;
-(void) setNSGrooveBorder: (id)sender;
-(void) setNSNoTitle: (id)sender;
-(void) setNSAboveTop: (id)sender;
-(void) setNSAtTop: (id)sender;
-(void) setNSBelowTop: (id)sender;
-(void) setNSAboveBottom: (id)sender;
-(void) setNSAtBottom: (id)sender;
-(void) setNSBelowBottom: (id)sender;
@end

@implementation NSBoxTest: NSObject
{
  // for instance variables see above
}
-(id) init 
{
  GSHbox *hbox;
  NSMatrix *borderMatrix;
  NSMatrix *titleMatrix;
  NSButtonCell *cell;
  NSTextField *boxContents;
  NSRect winFrame;
  NSBox *tmp_box;

  boxContents = [NSTextField new];
  [boxContents setDrawsBackground: YES];
  [boxContents setBackgroundColor: [NSColor redColor]];
  [boxContents setEditable: NO];
  [boxContents setSelectable: NO];
  [boxContents setBezeled: NO];
  [boxContents setBordered: YES];
  [boxContents setAlignment: NSCenterTextAlignment];
  [boxContents setStringValue: @"Box Contents"];
  [boxContents setFrameSize: NSMakeSize (140, 140)];
  [boxContents setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
  
  box = [NSBox new];
  [box setTitle: @"Box Title"];
  [box setTitlePosition: NSAtTop];
  [box setBorderType: NSGrooveBorder];
  [box addSubview: boxContents];
  [boxContents release];
  [box sizeToFit];
  [box setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
  
  cell = [[NSButtonCell alloc] init];
  [cell setButtonType: NSRadioButton];
  [cell setBordered: NO];
  [cell setImagePosition: NSImageLeft]; 
  
  borderMatrix = [[NSMatrix alloc] initWithFrame: NSZeroRect
				   mode: NSRadioModeMatrix
				   prototype: cell
				   numberOfRows: 4
				   numberOfColumns: 1];   
  
  titleMatrix = [[NSMatrix alloc] initWithFrame: NSZeroRect
				  mode: NSRadioModeMatrix
				  prototype: cell
				  numberOfRows: 7
				  numberOfColumns: 1];   
  
  [borderMatrix setIntercellSpacing: NSMakeSize (0, 4) ];
  [borderMatrix setTarget: self];
  [borderMatrix setAutosizesCells: NO];
  
  cell = [borderMatrix cellAtRow: 0 column: 0];
  [cell setTitle: @"NSNoBorder"];
  [cell setAction: @selector (setNSNoBorder:)];	
  
  cell = [borderMatrix cellAtRow: 1 column: 0];
  [cell setTitle: @"NSLineBorder"];
  [cell setAction: @selector (setNSLineBorder:)];	
  
  cell = [borderMatrix cellAtRow: 2 column: 0];
  [cell setTitle: @"NSBezelBorder"];
  [cell setAction: @selector (setNSBezelBorder:)];	
  
  cell = [borderMatrix cellAtRow: 3 column: 0];
  [cell setTitle: @"NSGrooveBorder"];
  [cell setAction: @selector (setNSGrooveBorder:)];
  
  [borderMatrix selectCellAtRow: 3 column: 0];
  [borderMatrix setAutoresizingMask: (NSViewMinXMargin | NSViewMaxXMargin)];
  [borderMatrix sizeToFit];
  
  [titleMatrix setIntercellSpacing: NSMakeSize (0, 4) ];
  [titleMatrix setTarget: self];
  cell = [titleMatrix cellAtRow: 0 column: 0];
  [cell setTitle: @"NSNoTitle"];
  [cell setAction: @selector (setNSNoTitle:)];
  
  cell = [titleMatrix cellAtRow: 1 column: 0];
  [cell setTitle: @"NSAboveTop"];
  [cell setAction: @selector (setNSAboveTop:)];
  
  cell = [titleMatrix cellAtRow: 2 column: 0];
  [cell setTitle: @"NSAtTop"];
  [cell setAction: @selector (setNSAtTop:)];
  
  cell = [titleMatrix cellAtRow: 3 column: 0];
  [cell setTitle: @"NSBelowTop"];
  [cell setAction: @selector (setNSBelowTop:)];	
  
  cell = [titleMatrix cellAtRow: 4 column: 0];
  [cell setTitle: @"NSAboveBottom"];
  [cell setAction: @selector (setNSAboveBottom:)];	
  
  cell = [titleMatrix cellAtRow: 5 column: 0];
  [cell setTitle: @"NSAtBottom"];
  [cell setAction: @selector (setNSAtBottom:)];
  
  cell = [titleMatrix cellAtRow: 6 column: 0];
  [cell setTitle: @"NSBelowBottom"];
  [cell setAction: @selector (setNSBelowBottom:)];	
  
  [titleMatrix selectCellAtRow: 2 column: 0];
  [titleMatrix setAutoresizingMask: (NSViewMinXMargin | NSViewMaxXMargin)];
  [titleMatrix sizeToFit];
  
  hbox = [GSHbox new];
  [hbox setDefaultMinXMargin: 10];
  [hbox setBorder: 10];
  [hbox addView: box];
  [box release];

  tmp_box = [NSBox new];
  [tmp_box setTitle: @"setBorderType:"];
  [tmp_box setTitlePosition: NSAtTop];
  [tmp_box setBorderType: NSGrooveBorder];
  [tmp_box addSubview: borderMatrix];
  [borderMatrix release];
  [tmp_box sizeToFit];
  [tmp_box setAutoresizingMask: (NSViewMinYMargin | NSViewWidthSizable)];
  [hbox addView: tmp_box];
  [tmp_box release];

  tmp_box = [NSBox new];
  [tmp_box setTitle: @"setTitlePosition:"];
  [tmp_box setTitlePosition: NSAtTop];
  [tmp_box setBorderType: NSGrooveBorder];
  [tmp_box addSubview: titleMatrix];
  [titleMatrix release];
  [tmp_box sizeToFit];
  [tmp_box setAutoresizingMask: (NSViewMinYMargin | NSViewWidthSizable)];
  [hbox addView: tmp_box];
  [tmp_box release];
  [hbox setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  winFrame.size = [hbox frame].size;
  winFrame.origin = NSMakePoint (100, 100);

  // Now we can make the window of the exact size 
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: YES];
  [win setTitle:@"NSBox Test"];
  [win setReleasedWhenClosed: NO];
  [win setContentView: hbox];
  [hbox release];
  [win setMinSize: winFrame.size];
  [self restart];
  return self;
}
- (void) dealloc
{
  RELEASE(win);
  [super dealloc];
}
- (void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSBox Test"
				     filename: NO];
}
-(void) setNSNoBorder: (id)sender
{
  [box setBorderType: NSNoBorder];
}
-(void) setNSLineBorder: (id)sender
{
  [box setBorderType: NSLineBorder];
}
-(void) setNSBezelBorder: (id)sender
{
  [box setBorderType: NSBezelBorder];
}
-(void) setNSGrooveBorder: (id)sender
{
  [box setBorderType: NSGrooveBorder];
}
-(void) setNSNoTitle: (id)sender
{
  [box setTitlePosition: NSNoTitle];
}
-(void) setNSAboveTop: (id)sender
{
  [box setTitlePosition: NSAboveTop];
}
-(void) setNSAtTop: (id)sender
{
  [box setTitlePosition: NSAtTop];
}
-(void) setNSBelowTop: (id)sender
{
  [box setTitlePosition: NSBelowTop];
}
-(void) setNSAboveBottom: (id)sender
{
  [box setTitlePosition: NSAboveBottom];
}
-(void) setNSAtBottom: (id)sender
{
  [box setTitlePosition: NSAtBottom];
}
-(void) setNSBelowBottom: (id)sender
{
  [box setTitlePosition: NSBelowBottom];
}
@end

