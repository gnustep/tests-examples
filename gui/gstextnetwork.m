#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>
#import <AppKit/NSTextStorage.h>

@interface buttonsController : NSObject
{
  NSWindow *win;
  NSTextView *theTextView;
  NSScrollView *theScrollView;
}

@end

@implementation buttonsController
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSRect wf = {{100, 100}, {400, 400}};
  NSRect f = {{10, 10}, {380, 200}};
  NSPopUpButton *pushb;
  NSView *aView;
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask
		      | NSMiniaturizableWindowMask | NSResizableWindowMask;

  win = [[NSWindow alloc] initWithContentRect:wf
				    styleMask:style
				      backing:NSBackingStoreRetained
					defer:NO];

  theScrollView = [[NSScrollView alloc] initWithFrame:[[win contentView] frame]];

  [theScrollView setBorderType:NSNoBorder];
  [theScrollView setHasVerticalScroller:YES];
  [theScrollView setHasHorizontalScroller:NO];
  [theScrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

  theTextView = [[NSTextView alloc]
initWithFrame:NSMakeRect(0,0,[theScrollView contentSize].width,
1e7)];
  [theTextView setMinSize:NSMakeSize(0.0, [theScrollView
contentSize].height)];
  [theTextView setMaxSize:NSMakeSize(1e7, 1e7)];
  [theTextView setVerticallyResizable:YES];
  [theTextView setHorizontallyResizable:NO];
  [theTextView setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
  [theTextView setBackgroundColor:[NSColor whiteColor]];

  [[theTextView textContainer]
    setContainerSize:NSMakeSize([theScrollView contentSize].width, 1e7)];
//  [[theTextView textContainer] setWidthTracksTextView:YES];

  [theTextView setString:[NSString stringWithContentsOfFile:@"Readme.txt"]];

  [theScrollView setDocumentView:theTextView];
  [win setContentView:theScrollView];
  [win makeKeyAndOrderFront:nil];
  [win makeFirstResponder:theTextView];
  [win display];
}

@end

int
main(int argc, char **argv, char** env)
{
  id pool = [NSAutoreleasePool new];
  NSApplication *theApp;
  NSAttributedString *attributedString;
  NSString *funString = @"SomethingNothing";
  NSScanner *scanner;
  unsigned int sL;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif
#ifndef NX_CURRENT_COMPILER_RELEASE
    initialize_gnustep_backend();
#endif

  scanner = [[NSScanner alloc] initWithString:funString];
  [scanner scanUpToString:[NSText newlineString] intoString:NULL];
  sL = [scanner scanLocation];

  NSLog(@"%d", sL + 2);

  attributedString = [[NSAttributedString alloc] initWithString:@"Hey!"];
  NSLog(@"%@", [attributedString string]);

  theApp = [NSApplication sharedApplication];
	[theApp setDelegate: [buttonsController new]];
	[theApp run];

  [pool release];

  return 0;
}
