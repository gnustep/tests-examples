#include <AppKit/AppKit.h>
#include <AppKit/NSTabViewItem.h>

@interface GSImageTabViewItem : NSTabViewItem
{
  NSImage *item_image;
}
- (void)setImage:(NSImage *)image;
- (NSImage *)image;
- (NSSize)sizeOfLabel:(BOOL)shouldTruncateLabel;
- (void)drawLabel:(BOOL)shouldTruncateLabel
           inRect:(NSRect)tabRect;
@end
