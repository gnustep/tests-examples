/* NSWindow-test.m: test that fills/strokes line up on the desired
   pixel boundaries.

   Copyright (C) 2011 Free Software Foundation, Inc.

   Author:  Eric Wasylishen <ewasylishen@gmail.com>
   Date: 2011
   
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
#include "../GSTestProtocol.h"

@interface NSWindowTest : NSObject <GSTest>
{
  NSWindow *testWindow;
  NSPanel *panel;
  NSTextView *tv;
}
- (void) restart;
- (void) setupTextView;
@end


static void AddLabel(NSString *text, NSRect frame, NSView *dest)
{
  NSTextField *labelView = [[NSTextField alloc] initWithFrame: frame];
  [labelView setStringValue: text];
  [labelView setEditable: NO];
  [labelView setSelectable: NO];
  [labelView setBezeled: NO];
  [labelView setFont: [NSFont labelFontOfSize: 10]];
  [dest addSubview: labelView];
  [labelView release];
}

static NSButton *AddButton(NSString *label, NSRect frame, NSView *dest, id target, SEL action)
{
  NSButton *button = [NSButton new];
  [button setFrame: frame];
  [button setTitle: label];
  [button setTarget: target];
  if (action)
    [button setAction: action];
  [button setContinuous: YES];
  [button setToolTip: label];
  [dest addSubview: button];
  return [button autorelease];
}

@implementation NSWindowTest

-(id) init
{
  testWindow = [[NSWindow alloc] initWithContentRect: NSMakeRect(0,0,200, 200)
					   styleMask: (NSTitledWindowMask 
						       | NSClosableWindowMask 
						       | NSMiniaturizableWindowMask 
						       | NSResizableWindowMask)
					     backing: NSBackingStoreBuffered
					       defer: NO];
  [testWindow setReleasedWhenClosed: NO];
  [testWindow setTitle: @"Test Window"];

  AddButton(@"Open Sheet", NSMakeRect(0,0,100,50), [testWindow contentView], self, @selector(openSheet:));
  AddButton(@"nothing", NSMakeRect(110,0,50,50), [testWindow contentView], self, (SEL)0);

  panel = [[NSPanel alloc] initWithContentRect: NSMakeRect(0,0,200, 400)
					   styleMask: (NSTitledWindowMask 
						       | NSUtilityWindowMask
						       | NSClosableWindowMask 
						       | NSResizableWindowMask)
					     backing: NSBackingStoreBuffered
					       defer: NO];
  [panel setReleasedWhenClosed: NO];
  [panel setTitle: @"NSWindow Test"];

  [self setupTextView];

  [testWindow setDelegate: self];

  [self restart];
  return self;
}

- (void) openSheet: (id)sender
{
  NSLog(@"Opening sheet...");

  NSBeginAlertSheet(@"My title", @"default button", @"alt button", @"other button",
    testWindow, self, (SEL)0, (SEL)0, NULL, @"Here is a sheet...");
}

- (void) setupTextView
{
  NSScrollView *sv = [[[NSScrollView alloc] initWithFrame: [[panel contentView] bounds]] autorelease];
  [sv setBorderType: NSNoBorder];
  [sv setHasVerticalScroller: YES];
  [sv setHasHorizontalScroller: NO];
  [sv setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

  tv = [[NSTextView alloc] initWithFrame:
			     NSMakeRect(0, 0,
					[sv contentSize].width, 
					[sv contentSize].height)];
  [tv setMinSize: NSMakeSize(0.0, [sv contentSize].height)];
  [tv setMaxSize: NSMakeSize(FLT_MAX, FLT_MAX)];
  [tv setVerticallyResizable:YES];
  [tv setHorizontallyResizable:NO];
  [tv setAutoresizingMask:NSViewWidthSizable];
  
  [[tv textContainer]
            setContainerSize:NSMakeSize([sv contentSize].width, FLT_MAX)];
  [[tv textContainer] setWidthTracksTextView:YES];

  [sv setDocumentView: tv];

  [[panel contentView] addSubview: sv];
}

-(void) restart
{
  [testWindow orderFront: nil]; 
  [panel orderFront: nil];
}

- (void) dealloc
{
  RELEASE (testWindow);
  RELEASE (panel);
  [super dealloc];
}

- (void) log: (NSString*)message
{
  NSLog(@" logging");

  if ([[tv string] length] > 10000)
    {
      [[[tv textStorage] mutableString] deleteCharactersInRange: NSMakeRange(0, [[tv string] length] - 10000)];
    }

  [[[tv textStorage] mutableString] appendString: 
		      [NSString stringWithFormat: @"%@\n", message]];
  NSLog(@"done appending");

  [tv scrollRangeToVisible: NSMakeRange([[tv string] length], 0)];
  NSLog(@"done scrolling. len %d", (int)[[tv string] length]);
}

/** NSWindowDelegate */

- (BOOL) windowShouldClose: (id)sender
{
  [self log: @"windowShouldClose"];
  return YES;
}
- (void) windowWillBeginSheet: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowWillBeginSheet %@", aNotification]];
}
- (void) windowDidEndSheet: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidEndSheet %@", aNotification]];
}
- (BOOL) windowShouldZoom: (NSWindow*)sender
                  toFrame: (NSRect)aFrame
{
  [self log: [NSString stringWithFormat: @"windowShouldZoom:toFrame: %@", NSStringFromRect(aFrame)]];
  return YES;
}
/*
- (NSUndoManager*) windowWillReturnUndoManager: (NSWindow*)sender
{
}
- (NSRect) windowWillUseStandardFrame: (NSWindow*)sender
                         defaultFrame: (NSRect)aFrame;
- (NSRect) window: (NSWindow *)window 
willPositionSheet: (NSWindow *)sheet
        usingRect: (NSRect)rect;
- (NSWindow *) attachedSheet;
*/
- (NSSize) windowWillResize: (NSWindow*)sender
		     toSize: (NSSize)frameSize
{
  [self log: [NSString stringWithFormat: @"windowWillReize:toSize: %@", NSStringFromSize(frameSize)]];
  return frameSize;
}
/*
- (id) windowWillReturnFieldEditor: (NSWindow*)sender
			  toObject: (id)client;
*/
- (void) windowDidBecomeKey: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidBecomeKey %@", aNotification]];
}
- (void) windowDidBecomeMain: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidBecomeMain %@", aNotification]];
}
- (void) windowDidChangeScreen: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidChangeScreen %@", aNotification]];
}
- (void) windowDidChangeScreenProfile: (NSNotification *)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidChangeScreenProfile %@", aNotification]];
}
- (void) windowDidDeminiaturize: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidDeminiaturize %@", aNotification]];
}
- (void) windowDidExpose: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidExpose %@", aNotification]];
}
- (void) windowDidMiniaturize: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidMiniaturize %@", aNotification]];
}
- (void) windowDidMove: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidMove. frame: %@ %@", 
		       NSStringFromRect([testWindow frame]), aNotification]];
}
- (void) windowDidResignKey: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidResignKey %@", aNotification]];
}
- (void) windowDidResignMain: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidResignMain %@", aNotification]];
}
- (void) windowDidResize: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidResize %@", aNotification]];
}
/*
- (void) windowDidUpdate: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowDidUpdate %@", aNotification]];
}
*/
- (void) windowWillClose: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowWillClose %@", aNotification]];
}
- (void) windowWillMiniaturize: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowWillMiniaturize %@", aNotification]];
}
- (void) windowWillMove: (NSNotification*)aNotification
{
  [self log: [NSString stringWithFormat: @"windowWillMove %@", aNotification]];
}

@end

