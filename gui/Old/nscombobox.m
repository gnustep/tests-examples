/*
   nscombobox.m

   Copyright (C) 1999 Free Software Foundation, Inc.

   Author: Gerrit van Dyk <gerritvd@decillion.net>
   Date: September 1999
   
   This file is part of the GNUstep GUI Library.

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
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include <Foundation/NSAutoreleasePool.h>
#include <AppKit/AppKit.h>

@interface MyObject : NSObject
{
   NSComboBox	*sourceCombo,*staticCombo;
   NSArray	*sourceArray;
}

- (id)initWithSourceCombo:(NSComboBox *)aSource
	      staticCombo:(NSComboBox *)aStatic;

@end

int
main(int argc, char **argv, char** env)
{
  NSApplication *theApp;
  NSWindow* window;
  NSComboBox	*sourceCombo,*staticCombo;
  NSMenu	*menu;
  MyObject	*trigger;
  NSRect winRect = {{100, 100}, {300, 150}};
  NSRect sourceComboRect = {{40,60},{150,20}};
  NSRect staticComboRect = {{40,90},{200,20}};
  NSAutoreleasePool* pool;
  id target;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif

  pool = [NSAutoreleasePool new];

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

  sourceCombo = [[[NSComboBox alloc] initWithFrame:sourceComboRect]
		   autorelease];
  staticCombo = [[[NSComboBox alloc] initWithFrame:staticComboRect]
		   autorelease];
  [[window contentView] addSubview:sourceCombo];
  [[window contentView] addSubview:staticCombo];
  trigger = [[MyObject alloc] initWithSourceCombo:sourceCombo
			      staticCombo:staticCombo];

  menu = [NSMenu new];
  [menu addItemWithTitle:@"Quit the Test" action: @selector(terminate:)
	keyEquivalent: @"q"];

  [theApp setMainMenu:menu];
  [menu setTitle:@"Test"];
  [menu update];
  [menu display];
  
  [window orderFrontRegardless];

  [theApp run];
  [trigger release];
  [pool release];
  return 0;
}

@implementation MyObject : NSObject

- (id)initWithSourceCombo:(NSComboBox *)aSource
	      staticCombo:(NSComboBox *)aStatic
{
   self = [self init];
   sourceCombo = [aSource retain];
   staticCombo = [aStatic retain];
   [sourceCombo setUsesDataSource:YES];
   [sourceCombo setDataSource:self];
   sourceArray = [[NSArray arrayWithObjects:
			      @"One",@"Two",@"Three",@"Four",@"Five",
			   @"Six",@"Seven",@"Eight",@"Nine",@"Ten",
			   @"Eleven",@"Twelve",@"Thirteen",nil] retain];
   [staticCombo addItemsWithObjectValues:
		   [NSArray arrayWithObjects:@"Dog",@"Cat",@"Beast",nil]];
   return self;
}

- (void)dealloc
{
   [sourceCombo release];
   [staticCombo release];
   [sourceArray release];
   [super dealloc];
}

- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
   return [sourceArray count];
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index
{
   return [sourceArray objectAtIndex:index];
}

- (unsigned int)comboBox:(NSComboBox *)aComboBox
indexOfItemWithStringValue:(NSString *)string
{
   return [sourceArray indexOfObject:string];
}

@end
