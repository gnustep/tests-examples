#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "FractalWindow.h"
#import "FractalView.h"

@interface Controller : NSObject

-(void)applicationDidFinishLaunching: (NSNotification *)aNotification;

-(void)startNewFractalWindow: (id)sender;

@end

