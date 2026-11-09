#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "PPController.h"
#import "PPDocumentClass.h"
#import "PPDocumentView.h"

enum
{
  PPToolBrush = 0,
  PPToolLine = 1,
  PPToolFilledOval = 2,
  PPToolFilledRectangle = 3,
  PPToolEraser = 4,
  PPToolBucket = 5,
  PPToolEyedropper = 6,
  PPToolRectangle = 7,
  PPToolOval = 8
};

@interface PPDocumentView (Private)
- (NSRect) normalizedRectFromPoint: (NSPoint)a toPoint: (NSPoint)b;
- (NSColor *) activeColor;
- (CGFloat) activeLineWidth;
- (void) drawCurrentSelection;
- (void) commitDisplayedContent;
- (NSPoint) bitmapPointForViewPoint: (NSPoint)point inBitmap: (NSBitmapImageRep *)bitmap;
- (void) pickColorAtPoint: (NSPoint)point;
- (void) fillAtPoint: (NSPoint)point;
- (BOOL) color: (NSColor *)a isEqualToColor: (NSColor *)b;
- (void) clearCanvas: (id)sender;
- (void) invertColors: (id)sender;
@end

@implementation PPDocumentView

- (void) awakeFromNib
{
  lastFrame = nil;
  selection = NO;
  drawing = NO;
}

- (BOOL) acceptsFirstMouse: (NSEvent *)theEvent
{
  return YES;
}

- (BOOL) acceptsFirstResponder
{
  return YES;
}

- (void) setFile: (NSBitmapImageRep *)image
{
  ASSIGN(lastFrame, image);
  [self setNeedsDisplay: YES];
}

- (void) setContent: (NSBitmapImageRep *)data
{
  NSBitmapImageRep *undoBitmap;

  undoBitmap = [self currentContent];
  ASSIGN(lastFrame, data);
  
  [[document undoManager] registerUndoWithTarget: self
                                        selector: @selector(setContent:)
                                          object: undoBitmap];
  [self setNeedsDisplay: YES];
}

- (NSBitmapImageRep *) currentContent
{
  NSBitmapImageRep *bitmap;
  
  bitmap = [self bitmapImageRepForCachingDisplayInRect: [self bounds]];
  [self cacheDisplayInRect: [self bounds] toBitmapImageRep: bitmap];
  
  return bitmap;
}

- (NSRect) normalizedRectFromPoint: (NSPoint)a toPoint: (NSPoint)b
{
  return NSMakeRect(MIN(a.x, b.x),
                    MIN(a.y, b.y),
                    fabs(b.x - a.x),
                    fabs(b.y - a.y));
}

- (NSColor *) activeColor
{
  if ([[NSApp delegate] tool] == PPToolEraser)
    {
      return [NSColor whiteColor];
    }

  return [[[[NSApp delegate] colorWell] color]
            colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
}

- (CGFloat) activeLineWidth
{
  CGFloat width;

  width = [[NSApp delegate] lineWidth];
  if (width < 1.0)
    {
      width = 1.0;
    }

  return width;
}

- (void) drawCurrentSelection
{
  NSBezierPath *path;
  NSInteger tool;
  CGFloat lineWidth;

  if (!selection)
    {
      return;
    }

  tool = [[NSApp delegate] tool];
  lineWidth = [self activeLineWidth];
  [[self activeColor] set];

  switch (tool)
    {
    case PPToolBrush:
    case PPToolEraser:
      if (NSEqualPoints(locA, locB))
        {
          path = [NSBezierPath bezierPathWithOvalInRect:
                    NSMakeRect(locA.x - lineWidth / 2.0,
                               locA.y - lineWidth / 2.0,
                               lineWidth,
                               lineWidth)];
          [path fill];
        }
      else
        {
          path = [NSBezierPath bezierPath];
          [path moveToPoint: locA];
          [path lineToPoint: locB];
          [path setLineWidth: lineWidth];
          [path setLineCapStyle: NSRoundLineCapStyle];
          [path stroke];
        }
      break;

    case PPToolLine:
      path = [NSBezierPath bezierPath];
      [path moveToPoint: locA];
      [path lineToPoint: locB];
      [path setLineWidth: lineWidth];
      [path setLineCapStyle: NSRoundLineCapStyle];
      [path stroke];
      break;

    case PPToolFilledOval:
      [[NSBezierPath bezierPathWithOvalInRect: selectedRect] fill];
      break;

    case PPToolFilledRectangle:
      [[NSBezierPath bezierPathWithRect: selectedRect] fill];
      break;

    case PPToolRectangle:
      path = [NSBezierPath bezierPathWithRect: selectedRect];
      [path setLineWidth: lineWidth];
      [path stroke];
      break;

    case PPToolOval:
      path = [NSBezierPath bezierPathWithOvalInRect: selectedRect];
      [path setLineWidth: lineWidth];
      [path stroke];
      break;
    }
}

- (void) commitDisplayedContent
{
  [self setNeedsDisplay: YES];
  [self displayIfNeeded];
  ASSIGN(lastFrame, [self currentContent]);
}

- (NSPoint) bitmapPointForViewPoint: (NSPoint)point inBitmap: (NSBitmapImageRep *)bitmap
{
  NSRect bounds;
  CGFloat x;
  CGFloat y;

  bounds = [self bounds];
  x = (point.x - bounds.origin.x) / bounds.size.width * [bitmap pixelsWide];
  y = (NSMaxY(bounds) - point.y) / bounds.size.height * [bitmap pixelsHigh];

  x = floor(MAX(0, MIN([bitmap pixelsWide] - 1, x)));
  y = floor(MAX(0, MIN([bitmap pixelsHigh] - 1, y)));

  return NSMakePoint(x, y);
}

- (void) pickColorAtPoint: (NSPoint)point
{
  NSBitmapImageRep *bitmap;
  NSPoint bitmapPoint;
  NSColor *color;

  bitmap = [self currentContent];
  bitmapPoint = [self bitmapPointForViewPoint: point inBitmap: bitmap];
  color = [bitmap colorAtX: bitmapPoint.x y: bitmapPoint.y];
  if (color != nil)
    {
      [[[NSApp delegate] colorWell] setColor: color];
    }
}

- (BOOL) color: (NSColor *)a isEqualToColor: (NSColor *)b
{
  CGFloat ar, ag, ab, aa;
  CGFloat br, bg, bb, ba;

  a = [a colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  b = [b colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
  if (a == nil || b == nil)
    {
      return NO;
    }

  [a getRed: &ar green: &ag blue: &ab alpha: &aa];
  [b getRed: &br green: &bg blue: &bb alpha: &ba];

  return fabs(ar - br) < 0.01
    && fabs(ag - bg) < 0.01
    && fabs(ab - bb) < 0.01
    && fabs(aa - ba) < 0.01;
}

- (void) fillAtPoint: (NSPoint)point
{
  NSBitmapImageRep *bitmap;
  NSPoint bitmapPoint;
  NSColor *sourceColor;
  NSColor *targetColor;
  NSMutableArray *queue;
  NSInteger width;
  NSInteger height;

  bitmap = [self currentContent];
  bitmapPoint = [self bitmapPointForViewPoint: point inBitmap: bitmap];
  width = [bitmap pixelsWide];
  height = [bitmap pixelsHigh];
  sourceColor = [bitmap colorAtX: bitmapPoint.x y: bitmapPoint.y];
  targetColor = [self activeColor];

  if ([self color: sourceColor isEqualToColor: targetColor])
    {
      return;
    }

  queue = [NSMutableArray arrayWithObject:
             [NSValue valueWithPoint: bitmapPoint]];

  while ([queue count] > 0)
    {
      NSPoint p;
      NSColor *currentColor;

      p = [[queue lastObject] pointValue];
      [queue removeLastObject];

      if (p.x < 0 || p.y < 0 || p.x >= width || p.y >= height)
        {
          continue;
        }

      currentColor = [bitmap colorAtX: p.x y: p.y];
      if (![self color: currentColor isEqualToColor: sourceColor])
        {
          continue;
        }

      [bitmap setColor: targetColor atX: p.x y: p.y];

      [queue addObject: [NSValue valueWithPoint: NSMakePoint(p.x + 1, p.y)]];
      [queue addObject: [NSValue valueWithPoint: NSMakePoint(p.x - 1, p.y)]];
      [queue addObject: [NSValue valueWithPoint: NSMakePoint(p.x, p.y + 1)]];
      [queue addObject: [NSValue valueWithPoint: NSMakePoint(p.x, p.y - 1)]];
    }

  ASSIGN(lastFrame, bitmap);
  [self setNeedsDisplay: YES];
}

- (void) clearCanvas: (id)sender
{
  [[document undoManager] registerUndoWithTarget: self
                                        selector: @selector(setContent:)
                                          object: [self currentContent]];
  [[document undoManager] setActionName: @"Clear Canvas"];
  RELEASE(lastFrame);
  lastFrame = nil;
  selection = NO;
  drawing = NO;
  [self setNeedsDisplay: YES];
}

- (void) invertColors: (id)sender
{
  NSBitmapImageRep *bitmap;
  NSInteger x;
  NSInteger y;
  NSInteger width;
  NSInteger height;

  bitmap = [self currentContent];
  [[document undoManager] registerUndoWithTarget: self
                                        selector: @selector(setContent:)
                                          object: bitmap];
  [[document undoManager] setActionName: @"Invert Colors"];

  bitmap = [self currentContent];
  width = [bitmap pixelsWide];
  height = [bitmap pixelsHigh];

  for (y = 0; y < height; y++)
    {
      for (x = 0; x < width; x++)
        {
          NSColor *color;
          CGFloat red;
          CGFloat green;
          CGFloat blue;
          CGFloat alpha;

          color = [[bitmap colorAtX: x y: y]
                    colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
          if (color == nil)
            {
              continue;
            }

          [color getRed: &red green: &green blue: &blue alpha: &alpha];
          [bitmap setColor: [NSColor colorWithCalibratedRed: 1.0 - red
                                                       green: 1.0 - green
                                                        blue: 1.0 - blue
                                                       alpha: alpha]
                       atX: x
                         y: y];
        }
    }

  ASSIGN(lastFrame, bitmap);
  selection = NO;
  drawing = NO;
  [self setNeedsDisplay: YES];
}

- (void) mouseDown: (NSEvent *)theEvent
{
  NSInteger tool;
  NSBitmapImageRep *bitmap;

  [[self window] makeFirstResponder: self];

  locA = [self convertPoint: [theEvent locationInWindow] fromView: nil];
  locB = locA;
  selectedRect = NSZeroRect;
  selection = YES;
  drawing = YES;
  tool = [[NSApp delegate] tool];

  if (tool != PPToolEyedropper)
    {
      bitmap = [self currentContent];
      [[document undoManager] registerUndoWithTarget: self
                                            selector: @selector(setContent:)
                                              object: bitmap];
    }

  switch (tool)
    {
    case PPToolBrush:
      [[document undoManager] setActionName: @"Brush"];
      break;
    case PPToolLine:
      [[document undoManager] setActionName: @"Line"];
      break;
    case PPToolFilledOval:
      [[document undoManager] setActionName: @"Filled Oval"];
      break;
    case PPToolFilledRectangle:
      [[document undoManager] setActionName: @"Filled Rectangle"];
      break;
    case PPToolEraser:
      [[document undoManager] setActionName: @"Eraser"];
      break;
    case PPToolBucket:
      [[document undoManager] setActionName: @"Paint Bucket"];
      [self fillAtPoint: locA];
      selection = NO;
      drawing = NO;
      break;
    case PPToolEyedropper:
      [self pickColorAtPoint: locA];
      selection = NO;
      drawing = NO;
      break;
    case PPToolRectangle:
      [[document undoManager] setActionName: @"Rectangle Outline"];
      break;
    case PPToolOval:
      [[document undoManager] setActionName: @"Oval Outline"];
      break;
    }
}

- (void) mouseDragged: (NSEvent *)theEvent
{
  NSInteger tool;

  if (!drawing)
    {
      return;
    }

  tool = [[NSApp delegate] tool];
  locB = [self convertPoint: [theEvent locationInWindow] fromView: nil];
  selectedRect = [self normalizedRectFromPoint: locA toPoint: locB];

  if (tool == PPToolBrush || tool == PPToolEraser)
    {
      [self commitDisplayedContent];
      locA = locB;
      selectedRect = NSZeroRect;
    }
  else
    {
      [self setNeedsDisplay: YES];
    }
}

- (void) mouseUp: (NSEvent*)theEvent
{
  NSInteger tool;

  if (!drawing)
    {
      return;
    }

  tool = [[NSApp delegate] tool];
  locB = [self convertPoint: [theEvent locationInWindow] fromView: nil];
  selectedRect = [self normalizedRectFromPoint: locA toPoint: locB];

  if (tool != PPToolBucket && tool != PPToolEyedropper)
    {
      [self commitDisplayedContent];
    }

  selection = NO;
  drawing = NO;
  [self setNeedsDisplay: YES];
}

- (void) drawRect: (NSRect)rect
{
  if (lastFrame != nil)
    {
      [lastFrame drawInRect: [self bounds]];
    }
  else
    {
      [[NSColor whiteColor] set];
      [[NSBezierPath bezierPathWithRect: [self bounds]] fill];
    }
  
  [self drawCurrentSelection];
}

- (void) dealloc
{
  [lastFrame release];
  [super dealloc];
}

@end
