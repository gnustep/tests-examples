/*
   nsbrowser.m
   
   Copyright (C) 1996 Free Software Foundation, Inc.
   
   Author: Scott Christley <scottc@net-community.com>
   Date: October 1997
   
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
#import <Foundation/NSFileManager.h>

//
// a NSBrowser delegate which passively creates the rows
//
@interface PassiveBrowserDelegate : NSObject
{
}

- (int)browser:(NSBrowser *)sender numberOfRowsInColumn:(int)column;
- (void)browser:(NSBrowser *)sender willDisplayCell:(id)cell
	  atRow:(int)row
	 column:(int)column;
- (NSString *)browser:(NSBrowser *)sender
	titleOfColumn:(int)column;

@end

@implementation PassiveBrowserDelegate

- (int)browser:(NSBrowser *)sender numberOfRowsInColumn:(int)column
{
  NSFileManager *fm = [NSFileManager defaultManager];
  NSArray *files = [fm directoryContentsAtPath: @"/"];

  return [files count];
}

- (void)browser:(NSBrowser *)sender willDisplayCell:(id)cell
	  atRow:(int)row
	 column:(int)column
{
  NSFileManager *fm = [NSFileManager defaultManager];
  NSArray *files = [fm directoryContentsAtPath: @"/"];
  int count = [files count];
  BOOL exists = NO, is_dir = NO;
  NSMutableString *s = [[[NSMutableString alloc] initWithCString: "/"]
			 autorelease];

  if (row >= count)
    return;

  [s appendString: [files objectAtIndex: row]];
  exists = [fm fileExistsAtPath: s isDirectory: &is_dir];

  if ((exists) && (is_dir))
    [cell setLeaf: NO];
  else
    [cell setLeaf: YES];

  [cell setStringValue: [files objectAtIndex: row]];
}

- (NSString *)browser:(NSBrowser *)sender
	titleOfColumn:(int)column
{
  if (column == 0)
    return @"Column 0";
  else if (column == 1)
    return @"Column 1";
  else if (column == 2)
    return @"Column 2";
  else
    return @"";
}

@end

//
// an NSBrowser delegate which actively creates the rows
//
@interface ActiveBrowserDelegate : NSObject
{
}

- (void)browser:(NSBrowser *)sender createRowsForColumn:(int)column
      inMatrix:(NSMatrix *)matrix;
- (void)browser:(NSBrowser *)sender willDisplayCell:(id)cell
	  atRow:(int)row
	 column:(int)column;

@end

@implementation ActiveBrowserDelegate

- (void)browser:(NSBrowser *)sender createRowsForColumn:(int)column
      								inMatrix:(NSMatrix *)matrix
{
  NSFileManager *fm = [NSFileManager defaultManager];
  NSString *ptc = [sender pathToColumn: column];
  NSArray *files = [fm directoryContentsAtPath: ptc];
  int i, count = [files count];

  if (count == 0)
    return;

  [matrix addColumn];

  for (i = 0; i < count; ++i)
    {
      id cell;
      BOOL exists = NO, is_dir = NO;
      NSMutableString *s = [[[NSMutableString alloc] initWithString: ptc]
			     autorelease];

      // First row is created when column is added
      if (i != 0)
		[matrix insertRow: i];

      cell = [matrix cellAtRow: i column: 0];

      [cell setStringValue: [files objectAtIndex: i]];

      [s appendString: @"/"];
      [s appendString: [files objectAtIndex: i]];
      exists = [fm fileExistsAtPath: s isDirectory: &is_dir];

      if ((exists) && (is_dir))
		[cell setLeaf: NO];
      else
		[cell setLeaf: YES];
    }
}

- (void)browser:(NSBrowser *)sender willDisplayCell:(id)cell
											atRow:(int)row
											column:(int)column
{}

- (BOOL)browser:(NSBrowser *)sender selectCellWithString:(NSString *)title
       											inColumn:(int)column;
{
//NSFileManager *fm = [NSFileManager defaultManager];
NSString *ptc = [sender pathToColumn: column];
NSMutableString *s = [[[NSMutableString alloc] initWithString:ptc]autorelease];

 fprintf(stderr, " browser:sender selectCellWithString: %s ", [title cString]);

	if(column > 0)
		[s appendString: @"/"];
	[s appendString:title];

fprintf(stderr, " source Path: %s ", [s cString]);

// fprintf(stderr, " destination Path: %s ", [d cString]);
//      if([fm movePath:s toPath:d handler:self])

}

// @interface NSObject (NSFileManagerHandler)
- (BOOL)fileManager:(NSFileManager*)fileManager
				shouldProceedAfterError:(NSDictionary*)errorDictionary
{  return YES;  }

- (void)fileManager:(NSFileManager*)fileManager
				willProcessPath:(NSString*)path
{}

@end

int
main(int argc, char **argv, char** env)
{
NSApplication *theApp;
NSWindow *window;
NSBrowser *browser;
NSRect winRect = {{100, 100}, {600, 600}};
NSRect browserRect = {{20, 20}, {500, 335}};
id pool = [NSAutoreleasePool new];
PassiveBrowserDelegate *pbd = [PassiveBrowserDelegate new];
ActiveBrowserDelegate *abd = [ActiveBrowserDelegate new];
unsigned int style = NSTitledWindowMask | NSClosableWindowMask				
					| NSMiniaturizableWindowMask | NSResizableWindowMask;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif

#ifndef NX_CURRENT_COMPILER_RELEASE
  initialize_gnustep_backend();
#endif

	theApp = [NSApplication sharedApplication];
	
	window = [[NSWindow alloc] initWithContentRect:winRect
								styleMask:style
								backing:NSBackingStoreRetained
								defer:NO];
	
	browser = [[NSBrowser alloc] initWithFrame: browserRect];
	[browser setTitle: @"Column 0" ofColumn: 0];
	[browser setDelegate: abd];
	[browser setMaxVisibleColumns: 3];
	[browser setAllowsMultipleSelection:NO];
	
	[[window contentView] addSubview: browser];
	
	[window setTitle:@"NSBrowser"];
	[window display];
	[window orderFront:nil];
	
	[theApp run];
	[pool release];

	return 0;
}
