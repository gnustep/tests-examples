/* 
   nsscroller.m

   Simple application to test NSScroller class.

   Copyright (C) 1997 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: February 1997
   
   This file is part of the GNUstep GUI X/RAW Backend.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; see the file COPYING.LIB.
   If not, write to the Free Software Foundation,
   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/ 

#include <Foundation/NSAutoreleasePool.h>
#include <AppKit/AppKit.h>

@interface MyObject : NSObject
@end

@implementation MyObject

- (void)scrollerAction: (id)sender
{
  float	pos = [sender floatValue];
  float	knob = [sender knobProportion];

  switch ([sender hitPart])
    {
    case NSScrollerKnob:
      NSLog (@"NSScrollerKnob");
      NSLog (@"scroller value = %f", pos);
      break;
    case NSScrollerKnobSlot:
      NSLog (@"NSScrollerKnobSlot");
      break;
    case NSScrollerDecrementLine:
      NSLog (@"NSScrollerDecrementLine");
      [sender setFloatValue: pos - 0.05 knobProportion: knob];
      break;
    case NSScrollerDecrementPage:
      NSLog (@"NSScrollerDecrementPage");
      [sender setFloatValue: pos - 0.2 knobProportion: knob];
      break;
    case NSScrollerIncrementLine:
      NSLog (@"NSScrollerIncrementLine");
      [sender setFloatValue: pos + 0.05 knobProportion: knob];
      break;
    case NSScrollerIncrementPage:
      NSLog (@"NSScrollerIncrementPage");
      [sender setFloatValue: pos + 0.2 knobProportion: knob];
      break;
    case NSScrollerNoPart:
      NSLog (@"NSScrollerNoPart");
      break;
    }
}

@end

int
main(int argc, char **argv, char** env)
{
  NSApplication *theApp;
  NSWindow *window;
  NSRect winRect = {{100, 400}, {300, 200}};
  NSRect wf0 = {{0, 0}, {300, 300}};
  NSView *v;
  NSScroller *s0, *s1, *s2, *s3, *s4, *s5;
  NSRect sf0 = {{10, 10}, {150, 20}};
  NSRect sf1 = {{10, 40}, {150, 20}};
  NSRect sf2 = {{10, 70}, {150, 20}};
  NSRect sf3 = {{10, 100}, {20, 150}};
  NSRect sf4 = {{40, 100}, {20, 150}};
  NSRect sf5 = {{70, 100}, {20, 150}};
  id object;
  id pool;
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask
		    | NSMiniaturizableWindowMask | NSResizableWindowMask;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments: argv count: argc environment: env];
#endif

  pool = [NSAutoreleasePool new];

  theApp = [NSApplication sharedApplication];
  object = [[MyObject new] autorelease];

#if 0
  window = [[NSWindow alloc] initWithContentRect: winRect
				       styleMask: style
					 backing: NSBackingStoreNonretained
					   defer: NO];
#else
  window = [[NSWindow alloc] init];
#endif

  v = [window contentView];
	
  s0 = [[NSScroller alloc] initWithFrame: sf0];
  [s0 setArrowsPosition: NSScrollerArrowsMaxEnd];
  [s0 setEnabled: YES];
  [s0 setTarget: object];
  [s0 setAction: @selector(scrollerAction:)];
  [v addSubview: s0];
	
  s1 = [[NSScroller alloc] initWithFrame: sf1];
  [s1 setArrowsPosition: NSScrollerArrowsMinEnd];
  [s1 setEnabled: YES];
  [s1 setTarget: object];
  [s1 setAction: @selector(scrollerAction:)];
  [v addSubview: s1];
	
  s2 = [[NSScroller alloc] initWithFrame: sf2];
  [s2 setArrowsPosition: NSScrollerArrowsNone];
  [s2 setEnabled: YES];
  [s2 setTarget: object];
  [s2 setAction: @selector(scrollerAction:)];
  [v addSubview: s2];
	
  s3 = [[NSScroller alloc] initWithFrame: sf3];
  [s3 setArrowsPosition: NSScrollerArrowsMaxEnd];
  [s3 setEnabled: YES];
  [s3 setFloatValue: 0.5 knobProportion: 0.4];
  [s3 setTarget: object];
  [s3 setAction: @selector(scrollerAction:)];
  [v addSubview: s3];
	
  s4 = [[NSScroller alloc] initWithFrame: sf4];
  [s4 setArrowsPosition: NSScrollerArrowsMinEnd];
  [s4 setEnabled: YES];
  [s4 setTarget: object];
  [s4 setAction: @selector(scrollerAction:)];
  [v addSubview: s4];
	
  s5 = [[NSScroller alloc] initWithFrame: sf5];
  [s5 setArrowsPosition: NSScrollerArrowsNone];
  [s5 setEnabled: YES];
  [s5 setTarget: object];
  [s5 setAction: @selector(scrollerAction:)];
  [v addSubview: s5];
	
  [window setFrame: wf0 display: YES];
  [window setTitle: @"GNUstep NSScroller"];
  [window orderFrontRegardless];
	
  {
    NSMenu	*menu = [NSMenu new];

    [menu addItemWithTitle: @"Quit"
		    action: @selector(terminate:)
	     keyEquivalent: @"q"];
    [NSApp setMainMenu: menu];
  }

  [theApp run];
      
  [pool release];
	
  return 0;
}
