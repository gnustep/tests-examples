/* Transparency-test.m: test transparency

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

static void AddLabel(NSString *text, NSRect frame, NSView *dest)
{
  NSTextField *labelView = [[NSTextField alloc] initWithFrame: frame];
  [labelView setStringValue: text];
  [labelView setEditable: NO];
  [labelView setSelectable: NO];
  [labelView setBezeled: NO];
  [labelView setFont: [NSFont labelFontOfSize: 10]];
  [labelView setDrawsBackground: NO];
  [dest addSubview: labelView];
  [labelView release];
}

@interface TransparencyTest : NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

@interface TransparencyTestView : NSView
{
}

- (void) changeColor: (id)sender;
- (void) windowOpacity: (id)sender;
- (void) ignoreMouse: (id)sender;
  
@end

@implementation TransparencyTestView

- (id)initWithFrame: (NSRect)frame
{
  self = [super initWithFrame: frame];
  
  if (self != nil)
    {
      AddLabel(@"Ignore mouse events", NSMakeRect(0, 380, 150, 20), self);
      {
        NSButton *ignoreMouse = [[NSButton alloc] initWithFrame: NSMakeRect(200, 380, 80, 20)];

        [ignoreMouse setButtonType: NSToggleButton];
        [ignoreMouse setTitle: @"Ignore mouse events"];
	[ignoreMouse setKeyEquivalent: @"i"];
	[ignoreMouse setKeyEquivalentModifierMask: NSCommandKeyMask];
	[ignoreMouse setTarget: self];
	[ignoreMouse setAction: @selector(ignoreMouse:)];
        [self addSubview: ignoreMouse];
        RELEASE(ignoreMouse);
      }

      AddLabel(@"On X11, for the window opacity setting or the window background color alpha value to have any effect, you must be running a window manager with compositing enabled.", NSMakeRect(0, 310, 400, 50), self);

      AddLabel(@"Window opacity (including title bar):", NSMakeRect(0, 260, 200, 50), self);
      {
	NSSlider *slider = [[[NSSlider alloc] initWithFrame: NSMakeRect(200, 275, 200, 20)] autorelease];
	[slider setMinValue: 0.0];
	[slider setMaxValue: 1.0];
	[slider setFloatValue: 1.0];
	[slider setTarget: self];
	[slider setAction: @selector(windowOpacity:)];
	[slider setContinuous: YES];
	[self addSubview: slider];
      }
 
      AddLabel(@"Window background color (please verify that adjusting the opacity works):", 
	       NSMakeRect(0, 210, 200, 50), self);
      {
	NSColor *defaultColor;
	NSColorWell *well = [[[NSColorWell alloc] initWithFrame: NSMakeRect(200, 220, 30, 30)] autorelease];
	
	// Convert the window background to NSCalibratedRGBColorSpace
	// so it is possible to change the alpha component
	defaultColor = [[NSColor windowBackgroundColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	if (defaultColor != nil)
	  {
	    [well setColor: defaultColor];
	  }

	[well setTarget: self];
	[well setAction: @selector(changeColor:)];
	[self addSubview: well];
	[[NSColorPanel sharedColorPanel] setShowsAlpha: YES];
      }

      AddLabel(@"GNUstep logo:", NSMakeRect(0,10,200,200), self);
      {
	NSImageView *logo = [[[NSImageView alloc] initWithFrame: NSMakeRect(200, 10, 200, 200)] autorelease];
	[logo setImage: [NSImage imageNamed: @"LogoGNUstep"]];
	[logo setImageFrameStyle: NSImageFrameGrayBezel];
	[self addSubview: logo];
      }
    }
  return self;
}

- (void) changeColor: (id)sender
{
  NSColor *color = [sender color];
  
  NSLog(@"Set background color to: %@", color);

  [[self window] setBackgroundColor: color];
}

- (void) windowOpacity: (id)sender
{  
  NSLog(@"Set window opacity to %f", (float)[sender floatValue]);
  [[self window] setAlphaValue: [sender floatValue]];
}

- (void) ignoreMouse: (id)sender
{  
  NSLog(@"Set ignore mouse to %f", [sender state]);
  [[self window] setIgnoresMouseEvents: [sender state]];
}

@end

@implementation TransparencyTest : NSObject

-(id) init
{
  NSView *content;
  content = [[TransparencyTestView alloc] initWithFrame: NSMakeRect(0,0,380,430)];

  // Create the window
  win = [[NSWindow alloc] initWithContentRect: [content frame]
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setReleasedWhenClosed: NO];
  [win setContentView: content];
  [win setMinSize: [win frame].size];
  [win setTitle: @"Transparency Test"];
  [self restart];
  return self;
}

-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: [win title]
				     filename: NO];
}

- (void) dealloc
{
  RELEASE (win);
  [super dealloc];
}

@end
