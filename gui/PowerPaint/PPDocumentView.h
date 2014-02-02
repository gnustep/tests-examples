#import <AppKit/NSView.h>

@class PPDocumentClass;

@interface PPDocumentView : NSView
{
  BOOL selection;
  NSPoint locA, locB;
  NSRect selectedRect;
  NSBitmapImageRep *lastFrame;
  
  // Outler
  PPDocumentClass *document;
}

- (void) setFile: (NSBitmapImageRep *)image;
- (void) setContent: (NSBitmapImageRep *)data;
- (NSBitmapImageRep *) currentContent;

@end