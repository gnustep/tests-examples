#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>
#import <AppKit/NSTextStorage.h>

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

  NSLog(@"deleteCharacters.");
  [[theTextView textStorage] beginEditing];
  [[theTextView textStorage] deleteCharactersInRange:NSMakeRange(100,500)];
  [[theTextView textStorage] replaceCharactersInRange:NSMakeRange(0,3)
					   withString:@"eek"];
  [[theTextView textStorage] endEditing];
  [theTextView didChangeText];
  NSLog(@"deleteCharacters finished.");

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
  NSAttributedString *attributedString;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif
#ifndef NX_CURRENT_COMPILER_RELEASE
    initialize_gnustep_backend();
#endif
  attributedString = [[NSAttributedString alloc] initWithString:@"Hey!"];
  NSLog(@"%@", [attributedString string]);

  theApp = [NSApplication sharedApplication];
	[theApp setDelegate: [buttonsController new]];
	[theApp run];

  [pool release];

  return 0;
}
