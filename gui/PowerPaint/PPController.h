#import <AppKit/AppKit.h>

@interface PPController : NSObject
{
  NSInteger tool;
  
  // Outlet
  id colorWell;
}

- (void) awakeFromNib;
- (id) colorWell;
- (void) setTool: (id)sender;
- (NSInteger) tool;

@end
