#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>

@interface buttonsController : NSObject
{
  NSWindow *win;
  NSTextView *theTextView;
}

@end

@implementation buttonsController
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSRect wf = {{100, 100}, {400, 400}};
  NSRect f = {{10, 10}, {380, 200}};
  NSPopUpButton *pushb;
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask
		      | NSMiniaturizableWindowMask | NSResizableWindowMask;

  win = [[NSWindow alloc] initWithContentRect:wf
				    styleMask:style
				      backing:NSBackingStoreRetained
					defer:NO];

  theTextView = [[NSTextView alloc] initWithFrame:[[win contentView] frame]];

  [theTextView setString:[NSString stringWithContentsOfFile:@"Readme.txt"]];

  [win setContentView:theTextView];
  [win makeKeyAndOrderFront:nil];
  [win makeFirstResponder:theTextView];
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
	[theApp setDelegate: [buttonsController new]];
	[theApp run];

  [pool release];

  return 0;
}
