#include <Foundation/NSObject.h>
#include <AppKit/AppKit.h>

#define APP_NAME @"GNUstep"

/*
 * Initialise and go!
 */

int main(int argc, const char *argv[]) 
{
  [NSObject enableDoubleReleaseCheck: YES];
  return NSApplicationMain (argc, argv);
}
