#import <AppKit/AppKit.h>
#import "PPDocumentView.h"
#import "PPDocumentClass.h"

@implementation PPDocumentClass

- (id) init
{
  self = [super init];
  
  if (self)
    {
      rep = nil;
    }
  
  return self;
}

- (NSString *) windowNibName
{
  return @"Document";
}

- (BOOL) readFromFile: (NSString *)fileName ofType: (NSString *)fileType
{
  NSData *data = [NSData dataWithContentsOfFile: fileName];
  rep = [[NSBitmapImageRep imageRepWithData: data] retain];
  
  if (rep != nil)
    {
      return YES;
    }
  else
    {
      return NO;
    }
}

- (BOOL) writeToFile: (NSString *)fileName ofType: (NSString *)fileType
{
  NSData *file = [[view currentContent] representationUsingType: NSJPEGFileType
                                                                      properties: nil];
                                                                      
  return [file writeToFile: fileName atomically: YES];
}

- (void) windowControllerDidLoadNib: (NSWindowController *)windowController
{
  [view setFile: [rep autorelease]];
}

@end