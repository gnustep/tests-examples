/* 
   nsbox.m

   Simple application to test NSBox class.

   Copyright (C) 1997 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: October 1997
   
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



@interface MyView : NSView
@end
@implementation MyView

- (void)drawRect:(NSRect)rect
{
  [[NSColor redColor] set];
  NSRectFill(bounds);
}

@end

@interface Controller : NSObject
{
@private
  NSBox *the_box;
}

- (void)cycleTitle;

@end

@implementation Controller

- (void)cycleTitle
{
  NSTitlePosition pos = [the_box titlePosition];

  NSLog(@"Position at: %d\n", pos);
  if (pos == NSNoTitle) pos = NSAboveTop;
  else if (pos == NSAboveTop) pos = NSAtTop;
  else if (pos == NSAtTop) pos = NSBelowTop;
  else if (pos == NSBelowTop) pos = NSAboveBottom;
  else if (pos == NSAboveBottom) pos = NSAtBottom;
  else if (pos == NSAtBottom) pos = NSBelowBottom;
  else if (pos == NSBelowBottom) pos = NSNoTitle;

  NSLog(@"Setting to position: %d\n", pos);
  [the_box setTitlePosition: pos];
  [the_box display];
}

- (void)cycleBorder
{
  NSBorderType bt = [the_box borderType];

  if (bt == NSNoBorder) bt = NSLineBorder;
  else if (bt == NSLineBorder) bt = NSBezelBorder;
  else if (bt == NSBezelBorder) bt = NSGrooveBorder;
  else if (bt == NSGrooveBorder) bt = NSNoBorder;

  [the_box setBorderType: bt];
  [the_box display];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
NSWindow *win;
NSRect wf0 = {{100, 100}, {300, 150}};
NSView *v;
NSButton *b0, *b1;
NSRect bf0 = {{161, 91}, {80, 20}};
NSRect bf1 = {{161, 51}, {80, 20}};
NSBox *aBox;
NSRect boxf = {{10, 10}, {130, 130}};
Controller *theControl = [[NSApplication sharedApplication] delegate];
MyView *myView;

  win = [[NSWindow alloc] init];
  v = [win contentView];

  aBox = [[NSBox alloc] initWithFrame: boxf];
  [aBox setTitle: @"Push the Button"];
  [aBox setTitlePosition: NSNoTitle];
  [v addSubview: aBox];

  theControl->the_box = aBox;

  myView = [[MyView alloc] initWithFrame: boxf];
  [aBox setContentView: myView];

  // Button to change the title position
  b0 = [[NSButton alloc] initWithFrame: bf0];
  [b0 setTarget: theControl];
  [b0 setAction: @selector(cycleTitle)];
  [b0 setTitle: @"Cycle Title"];
  [v addSubview: b0];

  // Button to change the border type
  b1 = [[NSButton alloc] initWithFrame: bf1];
  [b1 setTarget: theControl];
  [b1 setAction: @selector(cycleBorder)];
  [b1 setTitle: @"Cycle Border"];
  [v addSubview: b1];

  [win setFrame: wf0 display: YES];
  [win setTitle:@"GNUstep NSBox"];
  [win orderFront:nil];
}

@end


int
main(int argc, char** argv, char** env)
{
id pool = [NSAutoreleasePool new];
NSApplication *theApp;

#if LIB_FOUNDATION_LIBRARY
    [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif
#ifndef NX_CURRENT_COMPILER_RELEASE
    initialize_gnustep_backend();
#endif

  theApp = [NSApplication sharedApplication];
  [theApp setDelegate: [Controller new]];	
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
