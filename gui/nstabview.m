#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>
#import <AppKit/NSTabView.h>
#include "TestView.h"
#include "GSImageTabViewItem.h"

@interface appController : NSObject
{
  int tabNum;
  NSTabView *tabView;
}
- (void) addTab: (id)sender;
- (void) removeTab: (id)sender;
@end

@interface myTabViewDelegate : NSObject
{
}
- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)TabView;
@end

@implementation appController
- (BOOL)validateMenuItem:(NSMenuItem*)aMenuItem;
{
  NSString      *title = [aMenuItem title];

  if ([title isEqual: @"Remove tab"])
    {
      if (tabNum == 0)
        return NO;
    }

  return YES;
}

- (void) addTab: (id)sender
{
  NSView *view;
  NSTextField *label;
  NSTabViewItem *item;

  tabNum++;

  view = [[NSView alloc] initWithFrame:[tabView contentRect]];
  [view setAutoresizingMask: (NSViewWidthSizable
                               | NSViewHeightSizable)];

  label = [[NSTextField alloc] initWithFrame:[view frame]];
  [label setEditable: NO];
  [label setSelectable: NO];
  [label setBezeled: NO];
  [label setBordered: NO];
  [label setBackgroundColor: [NSColor lightGrayColor]];  
  [label setAlignment: NSCenterTextAlignment];
  [label setStringValue: [NSString stringWithFormat:@"Test View #%d", tabNum]];

  [view addSubview: label];

  item = [[NSTabViewItem alloc] initWithIdentifier: @"Urph"];
  [item setLabel: [NSString stringWithFormat:@"Test #%d", tabNum]];
  [item setView:view];
  
  [tabView addTabViewItem: item];  

  [tabView selectTabViewItem: item];
//  [tabView setNeedsDisplay: YES];
}

- (void) removeTab: (id)sender
{
  int index = [tabView numberOfTabViewItems] - 1;
  [tabView removeTabViewItem: [tabView tabViewItemAtIndex: index]];

  [tabView selectTabViewItemAtIndex: index - 1];

//  [tabView setNeedsDisplay: YES];

  tabNum--;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSWindow *window;
  NSTabViewItem *item;
  NSRect winRect = {{100, 100}, {300, 300}};
  NSRect tabViewRect = {{10, 10}, {280, 280}};
  NSView *view;
  NSTextField *label;

  tabNum = 0;

  window = [[NSWindow alloc] initWithContentRect: winRect
                          styleMask: (NSTitledWindowMask
                                      | NSClosableWindowMask
                                      | NSMiniaturizableWindowMask
                                      | NSResizableWindowMask)
                          backing: NSBackingStoreBuffered
                          defer: NO];

  tabView = [[NSTabView alloc] initWithFrame: tabViewRect];
  [tabView setDelegate: [myTabViewDelegate new]];
  [tabView setAutoresizingMask: (NSViewWidthSizable
                               | NSViewHeightSizable)];
  [tabView setAutoresizesSubviews: YES];
  [[window contentView] addSubview: tabView];

  view = [[NSView alloc] initWithFrame:[tabView contentRect]];
  [view setAutoresizingMask: (NSViewWidthSizable
                               | NSViewHeightSizable)];

  label = [[NSTextField alloc] initWithFrame:[view frame]];
  [label setEditable: NO];
  [label setSelectable: NO];
  [label setBezeled: NO];
  [label setBordered: NO];
  [label setBackgroundColor: [NSColor redColor]];  
  [label setAlignment: NSCenterTextAlignment];
  [label setStringValue: @"Do you swing, baby?"];

  [view addSubview: label];

  item = [[NSTabViewItem alloc] initWithIdentifier: @"Urph"];
  [item setLabel: @"Natalie"];
  [item setView:view];
  
  [tabView addTabViewItem: item];

  [window setTitle:@"NSTabView"];
  [window orderFrontRegardless];

  [[NSApp mainMenu] addItemWithTitle: @"Add tab"
                              action: @selector(addTab:)
             	       keyEquivalent: @"a"];
  [[NSApp mainMenu] addItemWithTitle: @"Remove tab"
                              action: @selector(removeTab:)
             	       keyEquivalent: @"r"];

}
@end

@implementation myTabViewDelegate
- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
  NSLog(@"shouldSelectTabViewItem: %@", [tabViewItem label]);

  /*
   * This is a test to see if the delegate is doing its job.
   */

//  if ([[tabViewItem label] isEqual:@"Natalie"])
//    return NO;

  return YES;
}

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
  NSLog(@"willSelectTabViewItem: %@", [tabViewItem label]);
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
  NSLog(@"didSelectTabViewItem: %@", [tabViewItem label]);
}

- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)TabView
{
  NSLog(@"tabViewDidChangeNumberOfTabViewItems: %d", [TabView numberOfTabViewItems]);
}
@end

int
main(int argc, char **argv, char** env)
{
  id pool = [NSAutoreleasePool new];
  NSApplication *app;

  app = [NSApplication sharedApplication];

  [app setDelegate: [appController new]];

  {
    NSMenu	*menu = [NSMenu new];

    [menu addItemWithTitle: @"Quit"
		    action: @selector(terminate:)
	     keyEquivalent: @"q"];
    [NSApp setMainMenu: menu];
  }

  [app run];

  [pool release];

  return 0;
}
