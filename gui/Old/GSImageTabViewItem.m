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
  NSSize rSize = [super sizeOfLabel: shouldTruncateLabel];
  NSSize iSize = [[self image] size];

  return NSMakeSize(rSize.width + iSize.width + 2, 
		    MAX(rSize.height, iSize.height));
}

- (void)drawLabel:(BOOL)shouldTruncateLabel
           inRect:(NSRect)tabRect
{
  NSGraphicsContext     *ctxt = GSCurrentContext();
  NSRect lRect;
  NSRect fRect;

  _rect = tabRect;
 
  DPSgsave(ctxt); 

  fRect = tabRect;
  
  if (_state == NSSelectedTab) {
    fRect.origin.y -= 1;
    fRect.size.height += 1;
    [[NSColor lightGrayColor] set];
    NSRectFill(fRect);
  } else if (_state == NSBackgroundTab) {
    [[NSColor lightGrayColor] set];
    NSRectFill(fRect);
  } else {
    [[NSColor lightGrayColor] set];
    NSRectFill(fRect);
  }
 
  lRect = tabRect;
  lRect.origin.y += 3;
  [[_tabview font] set];

  [[self image] compositeToPoint: NSMakePoint(lRect.origin.x,
					      lRect.origin.y) 
		operation: NSCompositeSourceOver];

  lRect.origin.x += [[self image] size].width + 2;
  
  DPSsetgray(ctxt, 0);
  DPSmoveto(ctxt, lRect.origin.x, lRect.origin.y);
  DPSshow(ctxt, [_label cString]);

  DPSgrestore(ctxt);  
}
@end
