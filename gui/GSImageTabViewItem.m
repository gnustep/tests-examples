#include "GSImageTabViewItem.h"

@implementation GSImageTabViewItem
- (void)setImage:(NSImage *)image
{
  ASSIGN(item_image, image);
}

- (NSImage *)image;
{
  return item_image;
}

- (NSSize)sizeOfLabel:(BOOL)shouldTruncateLabel;
{
  NSSize rSize;
  NSSize iSize;

  rSize.height = 12;

  iSize = [[self image] size];

  iSize.width += 2;

  if (shouldTruncateLabel) {
    // what is the algo to truncate?
    rSize.width = iSize.width + [[item_tabview font] widthOfString:item_label];
    return rSize;
  } else {
    rSize.width = iSize.width + [[item_tabview font] widthOfString:item_label];
    return rSize;  
  }
  return NSZeroSize;
}

- (void)drawLabel:(BOOL)shouldTruncateLabel
           inRect:(NSRect)tabRect
{
  NSGraphicsContext     *ctxt = GSCurrentContext();
  NSRect lRect;
  NSRect fRect;

  item_rect = tabRect;
 
  DPSgsave(ctxt); 

  fRect = tabRect;
  
  if (item_state == NSSelectedTab) {
    fRect.origin.y -= 1;
    fRect.size.height += 1;
    [[NSColor lightGrayColor] set];
    NSRectFill(fRect);
  } else if (item_state == NSBackgroundTab) {
    [[NSColor lightGrayColor] set];
    NSRectFill(fRect);
  } else {
    [[NSColor lightGrayColor] set];
    NSRectFill(fRect);
  }
 
  lRect = tabRect;
  lRect.origin.y += 3;
  [[item_tabview font] set];

  [[self image] compositeToPoint:NSMakePoint(lRect.origin.x,
    lRect.origin.y - 3) operation: NSCompositeCopy];

  lRect.origin.x += [[self image] size].width + 2;
  
  DPSsetgray(ctxt, 0);
  DPSmoveto(ctxt, lRect.origin.x, lRect.origin.y);
  DPSshow(ctxt, [item_label cString]);

  DPSgrestore(ctxt);  
}
@end
