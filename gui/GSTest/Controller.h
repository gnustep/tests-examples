#include <AppKit/AppKit.h>
#include "GSTestProtocol.h"

@interface Controller : NSObject
{
  NSMutableArray *tests;
  NSMutableArray *loadedTests;
  NSMutableArray *loadedTestTags;
}

- (void) startListedTest: (id) sender;
- (void) startUnlistedTest: (id) sender;
- (id) loadAndStartTestWithBundlePath: (NSString *)fullPath;
- (void) _findBundles;

@end

