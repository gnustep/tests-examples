/* 
   nsimage.m

   Simple application to test NSImage classes.

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: August 1996
   
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

#import <AppKit/AppKit.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSProcessInfo.h>
#include "ImageView.h"

int
main(int argc, char **argv, char** env)
{
    NSWindow *win;
    ImageView *v;
    NSApplication *theApp;
    NSRect wf0 = {{200, 200}, {300, 300}};
    NSArray* args;
    int style;
    id pool;

    if (argc == 1)
      {
	printf("usage: nsimage filename\n");
	exit(1);
      }

#if LIB_FOUNDATION_LIBRARY
    [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif
    pool = [NSAutoreleasePool new];

    args = [[NSProcessInfo processInfo] arguments];

    theApp = [NSApplication sharedApplication];
    v = [[ImageView alloc] initWithFile: [args objectAtIndex:1]];
    if (v == nil)
      return 0;
    wf0.size = [v imageSize];

    NSLog(@"Create a window\n");
    style = NSTitledWindowMask | NSClosableWindowMask
      | NSMiniaturizableWindowMask | NSResizableWindowMask;
    win = [[NSWindow alloc] initWithContentRect: wf0
                  styleMask: style
                    backing: NSBackingStoreBuffered
                      defer: NO];
    [win setContentView: v];
    [win setTitle:@"GNUstep GUI X/RAW Image View"];
    [win orderFrontRegardless];

  {
    NSMenu	*menu = [NSMenu new];

    [menu addItemWithTitle: @"Quit"
		    action: @selector(terminate:)
	     keyEquivalent: @"q"];
    [NSApp setMainMenu: menu];
  }

    NSLog(@"Run application\n");
    [theApp run];

    [pool release];

    return 0;
}
