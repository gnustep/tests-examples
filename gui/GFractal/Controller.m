
#import "Controller.h"

@implementation Controller

-(id) init
{
  return self;
}

-(void) dealloc
{
  [super dealloc];
}

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification;
{
  [self startNewFractalWindow: nil];
}

- (void)startNewFractalWindow: (id)sender
{
  int tag;
  tag = (sender==nil ? DEFAULT_TYPE:[sender tag]);
  
  [[FractalWindow alloc] initWithType:tag];
}

@end

