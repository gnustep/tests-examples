#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "FractalView.h"

@interface FractalWindow : NSObject
{
  id delegate;
  NSWindow *window;
  FractalView *view;
}

+ (NSString *) typeToString:(FTYPE)ft;
+ (NSString *) schemeToString:(CSCHEME)cs;

- (id)initWithType:(FTYPE)ft;


- (id)delegate;
- (void)setDelegate:(id)aDelegate;

- (id)window;

-(void)saveAs:(id)sender;

-(void)resolution:(id)sender;
-(void)colorScheme:(id)sender;
-(void)zoomOp:(id)sender;

@end

