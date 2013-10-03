/* NSSlider-test.m: NSSlider class demo/test

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
#include <GNUstepGUI/GSHbox.h>
#include <GNUstepGUI/GSTable.h>
#include <GNUstepGUI/GSVbox.h>
#include "../GSTestProtocol.h"

@interface NSSliderTest: NSObject <GSTest>
{
  NSWindow *win;
  NSSlider *hSlider;
  NSSlider *vSlider;
  NSTextField *hNumber;
  NSTextField *vNumber;
}
-(void) restart;
-(void) hContinuousChanged: (id) sender;
-(void) vContinuousChanged: (id) sender;
@end

@implementation NSSliderTest: NSObject
{
  // for instance variables see above
}
-(id) init
{
  NSBox *vSliderBox;
  NSBox *hSliderBox;
  GSVbox *vSliderVbox;
  GSVbox *hSliderVbox;
  GSTable *table;
  GSVbox *vboxOne;
  NSButton *hButton1;
  NSButton *hButton2;
  NSButton *vButton1;
  NSButton *vButton2;

  NSTextField *hLabel;
  NSTextField *vLabel;
  GSHbox *hLabelBox;
  GSHbox *vLabelBox;
  NSRect winFrame;
  NSSlider *circSlider;

  // Vertical Slider Box
  vButton1 = [NSButton new];
  [vButton1 setButtonType: NSSwitchButton];
  [vButton1 setBordered: NO];
  [vButton1 setTitle: @"Disabled"];
  [vButton1 setAlternateTitle: @"Enabled"];
  [vButton1 sizeToFit];
  [vButton1 setTarget: self];
  [vButton1 setAction: @selector (vEnabledChanged:)];
  [vButton1 setState: YES];
  [vButton1 setAutoresizingMask: NSViewMaxXMargin];

  vButton2 = [NSButton new];
  [vButton2 setButtonType: NSSwitchButton];
  [vButton2 setBordered: NO];
  [vButton2 setTitle: @"Not Continuous"];
  [vButton2 setAlternateTitle: @"Continuous"];
  [vButton2 sizeToFit];
  [vButton2 setTarget: self];
  [vButton2 setAction: @selector (vContinuousChanged:)];
  [vButton2 setState: NO];
  [vButton2 setAutoresizingMask: NSViewMaxXMargin];
  
  vLabel = [NSTextField new];
  [vLabel setSelectable: NO];
  [vLabel setEnabled: NO];
  [vLabel setBezeled: NO];
  [vLabel setBordered: NO];
  [vLabel setDrawsBackground: NO];
  [vLabel setStringValue: @"Value: "];
  [vLabel sizeToFit];
  
  vNumber = [NSTextField new];
  [vNumber setSelectable: NO];
  [vNumber setEnabled: NO];
  [vNumber setBezeled: NO];
  [vNumber setBordered: NO];
  [vNumber setDrawsBackground: NO];
  [vNumber setFloatValue: 500.0];
  [vNumber sizeToFit];
  
  vLabelBox = [GSHbox new];
  [vLabelBox addView: vLabel
	     enablingXResizing: NO];
  [vLabel release];
  [vLabelBox addView: vNumber];
  [vNumber release];
  [vLabelBox setAutoresizingMask: NSViewMaxXMargin];
  
  vSliderVbox = [GSVbox new];
  [vSliderVbox setDefaultMinYMargin: 5];
  [vSliderVbox addView: vButton1];
  [vButton1 release];
  [vSliderVbox addView: vButton2];
  [vButton2 release];
  [vSliderVbox addView: vLabelBox];
  [vLabelBox release];
  [vSliderVbox setAutoresizingMask: (NSViewMinXMargin | NSViewMaxXMargin 
				     | NSViewMinYMargin)];

  vSliderBox = [NSBox new];
  [vSliderBox setTitle: @"Vertical Slider"];
  [vSliderBox setTitlePosition: NSAtTop];
  [vSliderBox setBorderType: NSGrooveBorder];
  [vSliderBox addSubview: vSliderVbox];
  [vSliderVbox release];
  [vSliderBox sizeToFit];
  [vSliderBox setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
  
  // Horizontal Slider Box
  hButton1 = [NSButton new];
  [hButton1 setButtonType: NSSwitchButton];
  [hButton1 setBordered: NO];
  [hButton1 setTitle: @"Disabled"];
  [hButton1 setAlternateTitle: @"Enabled"];
  [hButton1 sizeToFit];
  [hButton1 setTarget: self];
  [hButton1 setAction: @selector (hEnabledChanged:)];
  [hButton1 setState: YES];
  [hButton1 setAutoresizingMask: NSViewMaxXMargin];

  hButton2 = [NSButton new];
  [hButton2 setButtonType: NSSwitchButton];
  [hButton2 setBordered: NO];
  [hButton2 setTitle: @"Not Continuous"];
  [hButton2 setAlternateTitle: @"Continuous"];
  [hButton2 sizeToFit];
  [hButton2 setTarget: self];
  [hButton2 setAction: @selector (hContinuousChanged:)];
  [hButton2 setState: NO];
  [hButton2 setAutoresizingMask: NSViewMaxXMargin];
  
  hLabel = [NSTextField new];
  [hLabel setSelectable: NO];
  [hLabel setEnabled: NO];
  [hLabel setBezeled: NO];
  [hLabel setBordered: NO];
  [hLabel setDrawsBackground: NO];
  [hLabel setStringValue: @"Value: "];
  [hLabel sizeToFit];
  
  hNumber = [NSTextField new];
  [hNumber setSelectable: NO];
  [hNumber setEnabled: NO];
  [hNumber setBordered: NO];
  [hNumber setBezeled: NO];
  [hNumber setDrawsBackground: NO];
  [hNumber setFloatValue: 500.0];
  [hNumber sizeToFit];
  
  hLabelBox = [GSHbox new];
  [hLabelBox addView: hLabel
	     enablingXResizing: NO];
  [hLabel release];
  [hLabelBox addView: hNumber];
  [hNumber release];
  [hLabelBox setAutoresizingMask: NSViewMaxXMargin];

  hSliderVbox = [GSVbox new];
  [hSliderVbox setDefaultMinYMargin: 5];
  [hSliderVbox addView: hButton1];
  [hButton1 release];
  [hSliderVbox addView: hButton2];
  [hButton2 release];
  [hSliderVbox addView: hLabelBox];
  [hLabelBox release];  
  [hSliderVbox setAutoresizingMask: (NSViewMinXMargin | NSViewMaxXMargin 
				     | NSViewMinYMargin)];

  hSliderBox = [NSBox new];
  [hSliderBox setTitle: @"Horizontal Slider"];
  [hSliderBox setTitlePosition: NSAtTop];
  [hSliderBox setBorderType: NSGrooveBorder];
  [hSliderBox addSubview: hSliderVbox];
  [hSliderVbox release];
  [hSliderBox sizeToFit];
  [hSliderBox setAutoresizingMask: (NSViewHeightSizable | NSViewWidthSizable)];
  
  vboxOne = [GSVbox new];
  [vboxOne setDefaultMinYMargin: 10];
  [vboxOne addView: hSliderBox];
  [hSliderBox release];
  [vboxOne addView: vSliderBox];
  [vSliderBox release];
  [vboxOne setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
  
  // The sliders themselves
  hSlider = [[NSSlider alloc] initWithFrame: NSMakeRect (0, 0, 200, 14)];
  //  [hSlider setFrame: NSMakeRect (0, 0, 200, [hSlider knobThickness])];
  [hSlider setAutoresizingMask: (NSViewWidthSizable)];
  [hSlider setTitle: @"Slider Title"];
  [hSlider setMinValue: 0];
  [hSlider setMaxValue: 1000];
  [hSlider setFloatValue: 500];
  [hSlider setAction: @selector (takeFloatValueFrom:)];
  [hSlider setTarget: hNumber];
  [hSlider setContinuous: NO];
  
  vSlider = [[NSSlider alloc] initWithFrame: NSMakeRect (0, 0, 14, 200)];
  //  [vSlider setFrame: NSMakeRect (0, 0, [vSlider knobThickness], 200)];
  [vSlider setAutoresizingMask: (NSViewHeightSizable)];
  //  [vSlider setTitle: @"Number"];
  [vSlider setMinValue: 0];
  [vSlider setMaxValue: 1000];
  [vSlider setFloatValue: 500];
  [vSlider setAction: @selector (takeFloatValueFrom:)];
  [vSlider setTarget: vNumber];
  [vSlider setContinuous: NO];
  
  table = [GSTable new];
  [table putView: vSlider
	 atRow: 1
	 column:0
	 withMinXMargin: 10
	 maxXMargin: 5
	 minYMargin: 5
	 maxYMargin: 10];
  [table putView: vboxOne
	 atRow: 1
	 column: 1
	 withMinXMargin: 5
	 maxXMargin: 10 
	 minYMargin: 5
	 maxYMargin: 10];
  [table putView: hSlider
	 atRow: 0
	 column: 1
	 withMinXMargin: 5
	 maxXMargin: 10
	 minYMargin: 10
	 maxYMargin: 5];
  [table setYResizingEnabled: NO
	 forRow: 0];
  [table setXResizingEnabled: NO
	 forColumn: 0];
  [table setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  circSlider = [[NSSlider alloc] initWithFrame: NSMakeRect(100,100,32,32)];
  [[circSlider cell] setSliderType: NSCircularSlider];
  [table putView: circSlider
	 atRow: 0
	 column:0
	 withMinXMargin: 0
	 maxXMargin: 0
	 minYMargin: 0
	 maxYMargin: 0];

  [circSlider release];


  
  winFrame.size = [table frame].size;
  winFrame.origin = NSMakePoint (150, 150);
  
  // The Window
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask
				      | NSResizableWindowMask)	
			  backing: NSBackingStoreBuffered
			  defer: YES];
  [win setTitle: @"NSSlider Test"];
  [win setReleasedWhenClosed: NO];
  [win setContentView: table];
  [win setMinSize: [NSWindow frameRectForContentRect: winFrame
			     styleMask: [win styleMask]].size];
  [self restart];
  return self;
}
-(void) dealloc
{
  RELEASE(win);
  [super dealloc];
}
-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSSlider Test"
				     filename: NO];
}
-(void) hContinuousChanged: (id) sender
{ 
  [hSlider setContinuous: [sender state]];
}
-(void) vContinuousChanged: (id) sender
{ 
  [vSlider setContinuous: [sender state]];
}
-(void) hEnabledChanged: (id) sender
{ 
  [hSlider setEnabled: [sender state]];
}
-(void) vEnabledChanged: (id) sender
{ 
  [vSlider setEnabled: [sender state]];
}
@end

