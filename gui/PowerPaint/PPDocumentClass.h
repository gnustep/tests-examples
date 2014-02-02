#import <AppKit/NSDocument.h>

@interface PPDocumentClass : NSDocument
{
  NSBitmapImageRep *rep;
  
  // Outlet
  id view;
}

@end
