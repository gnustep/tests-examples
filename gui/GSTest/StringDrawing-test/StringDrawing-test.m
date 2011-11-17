/* StringDrawing-test.m: Display an ASCII file in a scrollview

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
#include <GNUstepGUI/GSVbox.h>
#include "../GSTestProtocol.h"

/* 
 * This test is included to show to people how
 * they can simply and reliably display simple texts to the user in their
 * GNUstep progs using the current (0.6.5) GNUstep libraries -- waiting for 
 * the full NSText* classes.
 *
 * Simply, you create your NSString (with newlines inside it if you want)
 * and then ask the string to draw itself where you want, 
 * with -drawInRect:WithAttributes:
 * You can easily pass attributes, such as color, font, etc.
 *
 */

/*
 * A trivial view showing an attributed string.
 */
@interface TrivialTextView: NSView
{
  NSAttributedString *attr;
}
-(void) setAttributedString: (NSAttributedString *)s;
-(void) sizeToFit;
@end

@implementation TrivialTextView
-(void) dealloc
{
  TEST_RELEASE (attr);
  [super dealloc];
}
-(void) setAttributedString: (NSAttributedString *)s
{
  ASSIGN (attr, s);
}
-(void) sizeToFit
{
  if (attr)
    [self setFrameSize: [attr size]];
  else
    [self setFrameSize: NSZeroSize];
}
-(void) drawRect: (NSRect)rect
{
  if (attr) 
    [attr drawInRect: [self bounds]];
}
@end

/*
 * Now the real test
 */
@interface StringDrawingTest: NSObject <GSTest>
{
  TrivialTextView *text;
  NSWindow *win;
}
-(void) restart;
@end

@implementation StringDrawingTest: NSObject
{
  // for instance variables see above
}
-(id) init 
{
  GSVbox *vbox;
  NSButton *button;
  NSScrollView *scrollView;

  text = [TrivialTextView new];

  /* Minimum size we want it to have */
  scrollView = [[NSScrollView alloc] 
		 initWithFrame: NSMakeRect (0, 0, 60, 60)];
  [scrollView setDocumentView: text];
  [text release];
  [scrollView setHasHorizontalScroller: YES];
  [scrollView setHasVerticalScroller: YES];
  [scrollView setBorderType: NSBezelBorder];
  [scrollView setAutoresizingMask: (NSViewWidthSizable 
				    | NSViewHeightSizable)];

  button = [NSButton new];
  [button setTitle: @"Choose Text File To Display..."];
  [button sizeToFit];
  [button setAutoresizingMask: NSViewMinXMargin];
  [button setTarget: self];
  [button setAction: @selector (chooseTextFile:)];

  vbox = [GSVbox new];
  [vbox setBorder: 5];
  [vbox setDefaultMinYMargin: 5];
  [vbox addView: button
	enablingYResizing: NO];
  [vbox addView: scrollView];
  [vbox setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
  
  win = [[NSWindow alloc] initWithContentRect: NSMakeRect (100, 100, 500, 250)
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setReleasedWhenClosed: NO];  
  [win setContentView: vbox];
  [vbox release];
  [win setTitle: @"StringDrawing Test"];
  
  [self restart];
  return self;
}
- (void) dealloc
{
  // NB: text is automatically released releasing win, 
  // since it is a subview of win.
  RELEASE(win);
  [super dealloc];
}
- (void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"StringDrawing Test"
				     filename: NO];
}
-(void) chooseTextFile: (id) sender 
{
  NSOpenPanel *openPanel;
  int result;

  openPanel = [NSOpenPanel openPanel];
  [openPanel setTitle: @"Open Text File"];
  [openPanel setTreatsFilePackagesAsDirectories: YES];
  [openPanel setAllowsMultipleSelection: NO];
  
  result = [openPanel runModalForDirectory: NSHomeDirectory ()
		      file: nil
		      types: nil];

  if (result == NSOKButton)
    {
      NSString *string;
      NSDictionary *dict;
      NSAttributedString *attr;

      string = [NSString stringWithContentsOfFile: [openPanel filename]];
      dict =  [NSDictionary dictionaryWithObjectsAndKeys:
			      [NSFont systemFontOfSize: 0], 
			    NSFontAttributeName,
			    [NSColor textColor], 
			    NSForegroundColorAttributeName,
			    nil];
      
      attr = [[[NSAttributedString alloc] initWithString:  string
					  attributes: dict] autorelease];
      [text setAttributedString: attr];
      [text sizeToFit];
      /* It is a bit exagerated to redisplay all the window but anyway. */
      [win display];
    }
}
@end

