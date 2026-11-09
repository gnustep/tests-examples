#import <AppKit/AppKit.h>

@interface PPController : NSObject
{
  NSInteger tool;
  CGFloat lineWidth;
  
  // Outlet
  id colorWell;
}

- (void) awakeFromNib;
- (id) colorWell;
- (void) setTool: (id)sender;
- (NSInteger) tool;
- (void) setLineWidth: (id)sender;
- (CGFloat) lineWidth;

@end
