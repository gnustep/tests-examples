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

#include <AppKit/AppKit.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSProcessInfo.h>

int
write_image (NSImage *image)
{
  NSBitmapImageRep *rep;
  NSData *data;

  rep = (NSBitmapImageRep *)[image bestRepresentationForDevice: nil];
  if (rep == nil || [[rep class] isEqual: [NSBitmapImageRep class]] == NO)
    {
      NSLog(@"no rep or invalid rep");
      return -1;
    }

  data = [image TIFFRepresentationUsingCompression: NSTIFFCompressionJPEG
	   factor: 128];
  if (data == nil)
    {
      NSLog(@"error making tiff rep");
      return -1;
    }
  [data writeToFile: @"bogus.tiff" atomically: NO];
  return 0;
}

@interface MyController : NSObject
{
  NSWindow *mwin;
  NSImageView   *mview;
}

- (void) applicationWillFinishLaunching: (NSNotification *)not;
- readImage: (NSString *)file;
- openImage: sender;
- copyImage: sender;
@end

@implementation MyController

- openImage: sender
{
  NSOpenPanel *openPanel;
  int result;
  
  openPanel = [NSOpenPanel openPanel];
  result = [openPanel runModalForDirectory: nil
                      file: nil
                      types: [NSImage imageUnfilteredFileTypes]];
  if (result == NSOKButton)
    {
      NSEnumerator *e = [[openPanel filenames] objectEnumerator];
      NSString *file;

      while ((file = (NSString *)[e nextObject]))
        {
	  [self readImage: file];
	}
    }
  return self;
}

- readImage: (NSString *)file
{
  int style;
  NSImage *image;
  NSWindow *win;
  NSRect wf0 = {{200, 200}, {300, 300}};

  mview = [[NSImageView alloc] initWithFrame: wf0];
  if (mview == nil)
    return nil;
  image = [[NSImage alloc] initWithContentsOfFile: file ];
  [mview setImage: image];

  style = NSTitledWindowMask | NSClosableWindowMask
    | NSMiniaturizableWindowMask | NSResizableWindowMask;
  win = [[NSWindow alloc] initWithContentRect: wf0
			  styleMask: style
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setContentView: mview];
  [win setTitle:@"Image View"];
  [win orderFrontRegardless];
  return self;
}

- copyImage: sender
{
  NSRect wf0;
  NSImage *image;
  NSBitmapImageRep *rep;
  NSLog(@"copy image");
  if (mwin == nil)
    {
      NSImageView *v2;
      NSRect wf1 = {{300, 300}, {100, 100}};
      int style;
      style = NSTitledWindowMask | NSClosableWindowMask
	| NSMiniaturizableWindowMask | NSResizableWindowMask;
      mwin = [[NSWindow alloc] initWithContentRect: wf1
			      styleMask: style
			      backing: NSBackingStoreBuffered
			      defer: NO];
      v2 = [[NSImageView alloc] initWithFrame: wf1];
      [mwin setContentView: v2];
      [mwin setTitle:@"Image Destination"];
    }
  [mwin orderFront: sender];

  wf0 = NSMakeRect((200.0*rand()/RAND_MAX),(200.0*rand()/RAND_MAX),100,100);
  NSLog(@"Lock on %@ in rect %@", mview, NSStringFromRect(wf0));
  [mview lockFocus];
  PSsetgray(0);
  PSmoveto(20,20);
  PSlineto(100,100);
  rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect: wf0];
  [mview  unlockFocus];
  image = [[NSImage alloc] initWithSize: wf0.size];
  [image addRepresentation: rep];
  [[mwin contentView] setImage: image];
  [mwin flushWindow];
  [[mview window] flushWindow];
  
  return self;
}

- (void) applicationWillFinishLaunching: (NSNotification *)not
{
  NSMenu	*menu = [NSMenu new];


  [menu addItemWithTitle: @"Open"
	action: @selector(openImage:)
	keyEquivalent: @"o"];
  [menu addItemWithTitle: @"Copy Image"
	action: @selector(copyImage:)
	keyEquivalent: @""];
  [menu addItemWithTitle: @"Quit"
	action: @selector(terminate:)
	keyEquivalent: @"q"];
  [NSApp setMainMenu: menu];
}
@end

int
main(int argc, char **argv, char** env)
{
  MyController *controller;
  id pool;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif
  pool = [NSAutoreleasePool new];

  [NSApplication sharedApplication];
  controller = [MyController new];
  [NSApp setDelegate: controller];

  [NSApp run];
  [pool release];
  return 0;
}
