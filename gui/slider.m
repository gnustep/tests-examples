/*
   slider.m

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author: Ovidiu Predescu <ovidiu@net-community.com>
   Date: September 1997
   
   This file is part of the GNUstep GUI X/RAW Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02111, USA.
*/

#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>

@interface MyObject : NSObject
@end

@implementation MyObject
- (void)action:sender
{
  NSLog (@"slider value = %f", [sender floatValue]);
}
@end

int
main(int argc, char **argv, char** env)
{
  NSApplication *theApp;
  NSWindow* window;
  NSSlider* slider1;
  NSSlider* slider2;
  NSRect sliderRect1 = {{10, 10}, {250, 18}};
  NSRect sliderRect2 = {{10, 40}, {18, 200}};
  NSRect winRect = {{100, 100}, {380, 350}};
  NSAutoreleasePool* pool;
  id target;
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask				
					| NSMiniaturizableWindowMask | NSResizableWindowMask;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif

  pool = [NSAutoreleasePool new];

#ifndef NX_CURRENT_COMPILER_RELEASE
  initialize_gnustep_backend();
#endif

  theApp = [NSApplication sharedApplication];

#if 0
  window = [[NSWindow alloc]
	      initWithContentRect:winRect
	      styleMask:style
	      backing:NSBackingStoreNonretained
	      defer:NO];
#else
  window = [[NSWindow alloc] init];
#endif

  [window setFrame:winRect display:YES];

  target = [[MyObject new] autorelease];

  slider1 = [[NSSlider alloc] initWithFrame:sliderRect1];
  [slider1 setMinValue:100];
  [slider1 setMaxValue:1000];
  [slider1 setContinuous:YES];
  [slider1 setTarget:target];
  [slider1 setAction:@selector(action:)];
  [[window contentView] addSubview:slider1];

  slider2 = [[NSSlider alloc] initWithFrame:sliderRect2];
  [slider2 setMinValue:100];
  [slider2 setMaxValue:1000];
  [slider2 setContinuous:NO];
  [slider2 setTarget:target];
  [slider2 setAction:@selector(action:)];
  [[window contentView] addSubview:slider2];

  [window orderFront:nil];

  [theApp run];
  [pool release];
  return 0;
}
