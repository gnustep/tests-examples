
#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>

int
main(int argc, char **argv, char** env)
{
  id            pool = [NSAutoreleasePool new];
  NSApplication *app;

#ifndef NX_CURRENT_COMPILER_RELEASE
  initialize_gnustep_backend();
#endif
  
  app = [NSApplication sharedApplication];

  {
    NSMenu	*menu = [NSMenu new];

    [menu addItemWithTitle: @"Quit"
		    action: @selector(terminate:)
	     keyEquivalent: @"q"];
    [NSApp setMainMenu: menu];
  }

  [[NSFontManager sharedFontManager] orderFrontFontPanel:nil];

  [app run];
  
  [pool release];
  
  return 0;
}


