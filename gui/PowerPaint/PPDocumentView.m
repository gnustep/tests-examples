#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "PPController.h"
#import "PPDocumentClass.h"
#import "PPDocumentView.h"

@implementation PPDocumentView

- (void) awakeFromNib
{
  lastFrame = nil;
  selection = NO;
}

/*- (BOOL) acceptsFirstResponder
{
  return YES;
}*/

- (BOOL) acceptsFirstMouse: (NSEvent *)theEvent
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
  ASSIGN(lastFrame, data);
  
  [[document undoManager] registerUndoWithTarget: self
                                                        selector: @selector(setContent:)
                                                          object: [self currentContent]];
  [self setNeedsDisplay: YES];
}

- (NSBitmapImageRep *) currentContent
{
  NSBitmapImageRep *bitmap;
  
  bitmap = [self bitmapImageRepForCachingDisplayInRect: [self frame]];
  
  return bitmap;
}

/*- (void) mouseDown: (NSEvent *)theEvent
{
  BOOL click = YES;
  NSEvent *event;
  NSBitmapImageRep *bitmap = [self currentContent];
  
  [[document undoManager] registerUndoWithTarget: self
                                                        selector: @selector(setContent:)
                                                          object: bitmap];
  ASSIGN(lastFrame, bitmap);
  
  locA = [self convertPoint: [theEvent locationInWindow] fromView: nil];

  while (click)
    {
      event = [[self window] nextEventMatchingMask:
                        NSLeftMouseUpMask | NSLeftMouseDraggedMask];
                        
      switch ([event type])
        {
        case NSLeftMouseDragged:
          {
            locB = [self convertPoint: [event locationInWindow] fromView: nil];
            NSSize size = NSMakeSize(locB.x - locA.x, locB.y - locA.y);
            selectedRect.origin = locA;
            selectedRect.size = size;
            selection = YES;
            
            if ([[NSApp delegate] tool] == 0)
              {
                [self setNeedsDisplayInRect: NSMakeRect(locB.x - 2, locB.y - 2, 4, 4)];
              }
            else
              {
                [self setNeedsDisplay: YES];
              }
          }
          break;
        case NSLeftMouseUp:
          {
            click = NO;
            selection = NO;
          }
          break;
        }
    }
}*/

- (void) mouseDown: (NSEvent *)theEvent
{
  NSBitmapImageRep *bitmap = [self currentContent];
  
  [[document undoManager] registerUndoWithTarget: self
                                                        selector: @selector(setContent:)
                                                          object: bitmap];
  ASSIGN(lastFrame, bitmap);
  
  locA = [self convertPoint: [theEvent locationInWindow] fromView: nil];
  selectedRect.origin = locA;
  selection = YES;
  
  switch ([[NSApp delegate] tool])
    {
    case 0:
      [[document undoManager] setActionName: @"Trazo"];
      break;
    case 1:
      [[document undoManager] setActionName: @"Linea"];
      break;
    case 2:
      [[document undoManager] setActionName: @"Circulo"];
      break;
    case 3:
      [[document undoManager] setActionName: @"Rectangulo"];
      break;
    }
}

- (void) mouseDragged: (NSEvent *)theEvent
{
  locB = [self convertPoint: [theEvent locationInWindow] fromView: nil];
  NSSize size = NSMakeSize(locB.x - locA.x, locB.y - locA.y);
  selectedRect.size = size;
      
  if ([[NSApp delegate] tool] == 0)
    {
      [self setNeedsDisplayInRect: NSMakeRect(locB.x - 2, locB.y - 2, 4, 4)];
    }
  else
    {
      [self setNeedsDisplay: YES];
    }
}

- (void) mouseUp: (NSEvent*)theEvent
{
  ASSIGN(lastFrame, [self currentContent]);
  selection = NO;
}

- (void) drawRect: (NSRect)rect
{
  if (lastFrame != nil)
    {
      [lastFrame drawInRect: [self frame]];
    }
  else
    {
      [[NSColor whiteColor] set];
      [[NSBezierPath bezierPathWithRect: rect] fill];
    }
  
  if (selection)
    {
      NSBezierPath *path;
      [[[[NSApp delegate] colorWell] color] set];

      switch ([[NSApp delegate] tool])
        {
        case 0:
          {
            path = [NSBezierPath bezierPathWithRect: NSMakeRect(locB.x - 2, locB.y - 2, 4, 4)];
            [path fill];
          }
          break;
        case 1:
          {
            path = [NSBezierPath bezierPath];
            [path moveToPoint: locA];
            [path lineToPoint: locB];
            [path setLineWidth: 2];
            [path stroke];
          }
          break;
        case 2:
          {
            path = [NSBezierPath bezierPathWithOvalInRect: selectedRect];
            [path fill];
          }
          break;
        case 3:
          {
            path = [NSBezierPath bezierPathWithRect: selectedRect];
            [path fill];
          }
          break;
        }
    }
}

- (void) dealloc
{
  [lastFrame release];
  [super dealloc];
}

@end
