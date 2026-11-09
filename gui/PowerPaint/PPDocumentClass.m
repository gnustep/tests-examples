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

- (NSArray *) writableTypes
{
  return [NSArray arrayWithObjects: @"jpg", @"jpeg", @"png", @"tiff", @"tif", @"gif", @"bmp", nil];
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
  NSString *extension;
  NSBitmapImageFileType bitmapType;
  NSData *file;

  extension = [[fileName pathExtension] lowercaseString];
  bitmapType = NSJPEGFileType;

  if ([extension isEqualToString: @"png"])
    {
      bitmapType = NSPNGFileType;
    }
  else if ([extension isEqualToString: @"tiff"]
           || [extension isEqualToString: @"tif"])
    {
      bitmapType = NSTIFFFileType;
    }
  else if ([extension isEqualToString: @"gif"])
    {
      bitmapType = NSGIFFileType;
    }
  else if ([extension isEqualToString: @"bmp"])
    {
      bitmapType = NSBMPFileType;
    }

  file = [[view currentContent] representationUsingType: bitmapType
                                            properties: nil];
                                                                      
  return [file writeToFile: fileName atomically: YES];
}

- (void) windowControllerDidLoadNib: (NSWindowController *)windowController
{
  [view setFile: [rep autorelease]];
}

@end
