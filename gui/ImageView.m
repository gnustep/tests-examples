/* 
   ImageView.m

   Simple subclass of NSView to display an NSImage.

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: June 1996
   
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
#include "ImageView.h"

@implementation ImageView

// Class methods

// Instance methods
- init
{
  return [self initWithFile: @""];
}

- initWithFile:(NSString *)str
{
  [super init];

  file_name = str;
  image = [NSImage imageNamed: file_name];
  [image setBackgroundColor: [NSColor whiteColor]];

  if (image)
    NSLog(@"Loaded image %s\n", [file_name cString]);
  else
    NSLog(@"Failed to load image %s\n", [file_name cString]);

  return self;
}

- (NSSize)imageSize
{
  return [image size];
}

- (void)drawRect:(NSRect)rect
{
  [image compositeToPoint: NSZeroPoint operation: NSCompositeCopy];
  NSLog(@"Image has been composited\n");
}

@end
