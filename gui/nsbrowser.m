/*
   nsbrowser.m
   
   Copyright (C) 1996 Free Software Foundation, Inc.
   
   Author: Scott Christley <scottc@net-community.com>
   Date: October 1997
   
   Author: Franck Wolff <wolff@cybercable.fr>
   Date: November 1999
   
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


#if 0

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

#endif

//
// a NSWindow delegate which resize the browser
//
@interface WindowDelegate : NSObject
{
  NSWindow *_w;
  NSBrowser *_b;
}
- (void)initMembersWith: (NSWindow *)w and: (NSBrowser *)b;
- (void)windowDidResize:(NSNotification *)aNotification;
- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)proposedFrameSize;
@end

@implementation WindowDelegate
- (void)initMembersWith: (NSWindow *)w and: (NSBrowser *)b
{
  _w = w;
  _b = b;
}
- (void)windowDidResize:(NSNotification *)aNotification
{
  NSRect rect = [_w frame];

  rect.origin.x = rect.origin.y = 10;
  rect.size.width -= 20;
  rect.size.height -= 150;

  [_b setFrame: rect];
  [[_w contentView] setNeedsDisplay: YES];
}
- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)proposedFrameSize
{
  // Doesn't work. Why ????
  printf("windowWillResize: %s\n", [NSStringFromSize(proposedFrameSize) cString]);
  return proposedFrameSize;
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
	                            column:(int)column;
{
}

- (BOOL)browser:(NSBrowser *)sender selectCellWithString:(NSString *)title
       											inColumn:(int)column;
{
/*
  //NSFileManager *fm = [NSFileManager defaultManager];
  NSString *ptc = [sender pathToColumn: column];
  NSMutableString *s = [[[NSMutableString alloc] initWithString:ptc]autorelease];

  fprintf(stderr, " browser:sender selectCellWithString: %s ", [title cString]);

  if(column > 0)
    [s appendString: @"/"];
  [s appendString:title];

  fprintf(stderr, " source Path: %s ", [s cString]);

  fprintf(stderr, " destination Path: %s ", [d cString]);

  //if([fm movePath:s toPath:d handler:self])
*/
  return YES;
}

- (BOOL)fileManager:(NSFileManager*)fileManager
				shouldProceedAfterError:(NSDictionary*)errorDictionary
{
  return YES;
}

- (void)fileManager:(NSFileManager*)fileManager
				willProcessPath:(NSString*)path
{
}

@end

typedef enum {
  Tag_nothing,
  Tag_moreColumns,
  Tag_lessColumns,
  Tag_setTitled,
  Tag_setHasHScroller
} TMenuItemTag;

@interface browserController : NSObject
{
  NSBrowser *browser;
}
@end

@implementation browserController

- (void)menuAction:menuItem
{
  //NSLog (@"method \"menuAction\" invoked with tag: %d\n", [menuItem tag]);
  switch ([menuItem tag])
    {
      case Tag_nothing:
      	break;
      case Tag_moreColumns:
      	[browser setMaxVisibleColumns: [browser maxVisibleColumns] + 1];
      	break;
      case Tag_lessColumns:
      	[browser setMaxVisibleColumns: [browser maxVisibleColumns] - 1];
      	break;
      case Tag_setTitled:
      	[menuItem setState: [menuItem state] ? NSOffState : NSOnState];
      	[browser setTitled: ([menuItem state] == NSOnState)];
      	break;
      case Tag_setHasHScroller:
      	[menuItem setState: [menuItem state] ? NSOffState : NSOnState];
      	[browser setHasHorizontalScroller: ([menuItem state] == NSOnState)];
      	break;
      default:
      	break;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSWindow *win;
  ActiveBrowserDelegate * abd;
  WindowDelegate *wd;
  NSRect wf = {{100, 100}, {600, 500}};
  NSRect bf = {{10, 10}, {580, 350}};
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask
		      | NSMiniaturizableWindowMask | NSResizableWindowMask;

  //NSLog(@"Starting the application\n");
  win = [[NSWindow alloc] initWithContentRect:wf
				    styleMask:style
				      backing:NSBackingStoreRetained
					defer:NO];

  //NSLog(@"Making the active browser delegate\n");
  abd = [ActiveBrowserDelegate new];

  //NSLog(@"Making the browser\n");
  browser = [[NSBrowser alloc] initWithFrame: bf];
  [browser setDelegate: abd];
  [browser setMaxVisibleColumns: 3];
  [browser setAllowsMultipleSelection:NO];

  //NSLog(@"Making the window delegate\n");
  wd = [WindowDelegate new];
  [wd initMembersWith: win and: browser];

  //NSLog(@"Setting the window subviews\n");
  
  [win setDelegate: wd];
  [[win contentView] addSubview: browser];

  //NSLog(@"Making the application menu\n");
  {
    NSMenu *menu, *columns, *options;
    NSMenuItem *menuItem;
    SEL ma = @selector(menuAction:);

    //NSLog(@"Making the main menu\n");
    menu = [NSMenu new];
    {
      [[menu addItemWithTitle: @"Columns" action: ma keyEquivalent: @""]
	setTag: Tag_nothing];
      [[menu addItemWithTitle: @"Options" action: ma keyEquivalent: @""]
	setTag: Tag_nothing];
      [[menu addItemWithTitle: @"Quit" action: @selector(terminate:)
                                       keyEquivalent: @"q"]
	setTag: Tag_nothing];
    }

    //NSLog(@"Making the sub menu \"Columns\"\n");
    columns = [NSMenu new];
    [menu setSubmenu: columns forItem: [menu itemWithTitle: @"Columns"]];
    {
      [[columns addItemWithTitle: @"More" action: ma keyEquivalent: @"+"]
	setTag: Tag_moreColumns];
      [[columns addItemWithTitle: @"Less" action: ma keyEquivalent: @"-"]
	setTag: Tag_lessColumns];
    }
    
    //NSLog(@"Making the sub menu \"Options\"\n");
    options = [NSMenu new];
    [menu setSubmenu: options forItem: [menu itemWithTitle:@"Options"]];
    {
      menuItem = [[NSMenuItem alloc] initWithTitle: @"Titled" action: ma
				     keyEquivalent: @""];
      [menuItem setState: NSOnState];
      [menuItem setTag: Tag_setTitled];
      [options addItem: menuItem];

      menuItem = [[NSMenuItem alloc] initWithTitle: @"Horizontal scroller"
                                     action: ma keyEquivalent: @""];
      [menuItem setState: NSOnState];
      [menuItem setTag: Tag_setHasHScroller];
      [options addItem: menuItem];
    }
    
    [menu update];

    [NSApp setMainMenu: menu];    
  }

  //NSLog(@"Displaying\n");
  [win setTitle:@"NSBrowser Test (try to resize window !)"];
  [[win contentView] display];
  [win orderFront:nil];
}

@end

int
main(int argc, char **argv, char** env)
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
  [theApp setDelegate: [browserController new]];
  [theApp run];

  [pool release];

  return 0;
}
