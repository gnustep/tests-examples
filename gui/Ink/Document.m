/* Document.m Subclass of NSDocument for Ink application

   Copyright (C) 2000 Free Software Foundation, Inc.

   Author:  Fred Kiefer <fredkiefer@gmx.de>
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
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
#include <AppKit/AppKit.h>
#include <AppKit/NSWindowController.h>
#include "Document.h"

@interface Document (Private)

- (NSWindow*) makeWindow;

@end

@implementation Document

- (id) init
{
  [super init];

  ts = [[NSMutableAttributedString alloc] init];
  return self;
}

- (void) dealloc
{
  RELEASE(ts);
  RELEASE(tv);
  RELEASE(pi);
}

- (NSData *)dataRepresentationOfType:(NSString *)aType 
{
  NSAttributedString *attr;

  if (tv != nil)
    attr = [tv textStorage];
  else
    attr = ts;

  if ([aType isEqualToString:@"rtf"])
    {
      return [attr RTFFromRange: NSMakeRange(0, [attr length]) documentAttributes: 
		       [[self printInfo] dictionary]]; 
    }
  else if ([aType isEqualToString:@"text"])
    {
      return [[attr string] dataUsingEncoding: [NSString defaultCStringEncoding]]; 
    }
  else
    {
      NSAssert(NO, ([NSString stringWithFormat: @"Unknown type %@", aType]));
      return nil;
    }
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType 
{
  NSAttributedString *attr;

  if ([aType isEqualToString:@"rtf"])
    {
      attr = [[NSAttributedString alloc] initWithRTF: data 
					 documentAttributes: NULL];
    }
  else if ([aType isEqualToString:@"text"])
    {
      attr = [[NSAttributedString alloc] 
		 initWithString: AUTORELEASE([[NSString alloc] initWithData: data
							       encoding: [NSString defaultCStringEncoding]])];
    }
  else
    {
      NSAssert(NO, ([NSString stringWithFormat: @"Unknown type %@", aType]));
      return NO;
    }

  if (tv != nil)
    [[tv textStorage] setAttributedString: attr];
  else 
    [ts setAttributedString: attr];

  RELEASE(attr);
  return YES;
}

- (void)makeWindowControllers
{
  NSWindowController *controller;
  NSWindow *win = [self makeWindow];
  
  controller = [[NSWindowController alloc] initWithWindow: win];
  [self addWindowController: controller];
  RELEASE(controller);

  // We have to do this our self, as there is currently no nib file
  [self awakeFromNib];
} 

- (void)printShowingPrintPanel:(BOOL)flag
{
  NSPrintOperation *po = [NSPrintOperation printOperationWithView: tv
					   printInfo: [self printInfo]];

  [po setShowPanels: flag];
  [po runOperation];
}

- (void) awakeFromNib
{
  [[tv textStorage] setAttributedString: ts];
  DESTROY(ts);
}

- (void)textDidChange:(NSNotification *)textObject 
{
  [self updateChangeCount: NSChangeDone];
}

@end

@implementation Document (Private)

- (NSWindow*)makeWindow
{
  NSWindow *window;
  NSScrollView* scrollView;
  NSTextView* textView;
  NSColor* backColor;
  NSRect scrollViewRect = {{0, 0}, {470, 400}};
  NSRect winRect = {{100, 100}, {470, 400}};
  NSRect textRect;
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask | 
      NSMiniaturizableWindowMask | NSResizableWindowMask;
  
  // This is expected to be retained, as it would normaly come from a nib file, where
  // the owner would retain it.
  window = [[NSWindow alloc] initWithContentRect: winRect
			     styleMask: style
			     backing: NSBackingStoreRetained
			     defer: NO];
   
  scrollView = [[NSScrollView alloc] initWithFrame: scrollViewRect];
  [scrollView setHasHorizontalScroller: NO];
  [scrollView setHasVerticalScroller: YES]; 
  [scrollView setAutoresizingMask: NSViewHeightSizable | NSViewWidthSizable];

  // Build up the text network
  textRect = [[scrollView contentView] frame];
  textView = [[NSTextView alloc] initWithFrame: textRect];
  backColor = [NSColor colorWithCalibratedWhite:0.85 alpha:1.0]; // off white
  [textView setBackgroundColor: backColor];					
  [textView setRichText: YES];
  [textView setUsesFontPanel: YES];
  [textView setDelegate: self];
  [textView setVerticallyResizable: YES];
  [[textView textContainer] setContainerSize: NSMakeSize(textRect.size.width, 1E99)];
  [[textView textContainer] setWidthTracksTextView: YES];
  ASSIGN(tv, textView);

  [scrollView setDocumentView: textView];
  [[window contentView] addSubview: scrollView];
  [window setDelegate: self];
  
  [window display];
  [window orderFront:nil];

  RELEASE(scrollView);
  RELEASE(textView);
  return window;
}

@end
