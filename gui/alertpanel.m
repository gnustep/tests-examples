/* 
   alertpanel.m

   Copyright (C) 1998 Free Software Foundation, Inc.

   Author:  Richard Frith-Macdonald <richard@brainstorm.co.uk>
   Date: December 1998
   
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

#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>
#import <AppKit/GMArchiver.h>

@interface myController : NSObject
{
}
@end

@implementation myController

- (void) buttonAction1: (id)sender
{
  NSLog (@"buttonAction1:");

  NSRunAlertPanel(@"A Title",
		@"Some message text",
		@"default",
		@"alternate",
		@"other");
}

- (void) buttonAction2: (id)sender
{
  NSLog (@"buttonAction2:");

  NSRunCriticalAlertPanel(@"A Title",
                @"Some message text",
                @"default",
                @"alternate",
                @"other");
}

- (void) buttonAction3: (id)sender
{
  NSLog (@"buttonAction3:");

  NSRunInformationalAlertPanel(@"A Title",
                @"Some message text",
                @"default",
                @"alternate",
                @"other");
}

- (void) buttonAction4: (id)sender
{
  NSPanel	*p;
  GMArchiver	*a;

  NSLog (@"buttonAction4:");

  p = NSGetAlertPanel(@"A Title",
                @"Some message text",
                @"default",
                @"alternate",
                @"other");
  a = [GMArchiver new];
  [a encodeRootObject: p withName: @"AlertPanel"];
  [a writeToFile: @"archivedPanel"];
  [a release];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSWindow	*win;
  NSRect	wf = {{100, 100}, {200, 200}};
  NSView	*v;
  NSRect	bf = {{10, 110}, {80, 80}};
  id		button;
  unsigned int	style = NSTitledWindowMask | NSClosableWindowMask              
		    | NSMiniaturizableWindowMask | NSResizableWindowMask;

  NSLog(@"Starting the application\n");

  win = [[NSWindow alloc] initWithContentRect: wf
				    styleMask: style
				      backing: NSBackingStoreRetained  
					defer: NO];

  [win setTitle: @"GNUstep Alert panel"];

  v = [win contentView];

  NSLog(@"Create the panel buttons\n");

  button = [[NSButton alloc] initWithFrame: bf];
  [button setTitle: @"Std Panel"];
  [button setTarget:self];
  [button setAction:@selector(buttonAction1:)];
  [v addSubview: button];
  [button release];

  bf.origin.x += 100;
  button = [[NSButton alloc] initWithFrame: bf];
  [button setTitle: @"Crit Panel"];
  [button setTarget:self];
  [button setAction:@selector(buttonAction2:)];
  [v addSubview: button];
  [button release];

  bf.origin.y -= 100;
  button = [[NSButton alloc] initWithFrame: bf];
  [button setTitle: @"Make archive"];
  [button setTarget:self];
  [button setAction:@selector(buttonAction4:)];
  [v addSubview: button];
  [button release];

  bf.origin.x -= 100;
  button = [[NSButton alloc] initWithFrame: bf];
  [button setTitle: @"Info Panel"];
  [button setTarget:self];
  [button setAction:@selector(buttonAction3:)];
  [v addSubview: button];
  [button release];

  [v display];
  [win orderFront: nil];
}

@end

int
main(int argc, char **argv, char** env)
{
  id		pool = [NSAutoreleasePool new];
  NSApplication *app;

#ifndef NX_CURRENT_COMPILER_RELEASE
  initialize_gnustep_backend();
#endif

  app = [NSApplication sharedApplication];

  [app setDelegate: [myController new]];  
  [app run];

  [pool release];

  return 0;
}
