/* 
 * Resolver.m created by phr on 2000-10-10 18:37:59 +0000
 *
 * Project HostAddress
 *
 * Created with ProjectCenter - http://www.projectcenter.ch
 *
 * $Id$
 */

#import "Resolver.h"

@implementation Resolver

- (id)init
{
  if ((self = [super init])) {
    [self createUI];
  }
  return self;
}

- (void)dealloc
{
  RELEASE(window);

  [super dealloc];
}

- (void)makeKeyAndOrderFront
{
  if (![window isVisible]) {
    [window center];
  }

  [window makeKeyAndOrderFront:self];
}

- (void)resolveHost
{
  NSString *name = [hostField stringValue];
  NSHost *host = [NSHost hostWithName:name];

  if (host) {
    [addressField setStringValue:[host address]];
  }
  else {
    [addressField setStringValue:@"Address could not be resolved!"];
  }
}

- (void)resolveAddress
{
  NSString *addr = [addressField stringValue];
  NSHost *host = [NSHost hostWithAddress:addr];

  if (host) {
    [hostField setStringValue:[host name]];
  }
  else {
    [hostField setStringValue:@"Host could not be resolved!"];
  }
}

@end

@implementation Resolver (UIBuilder)

- (void)createUI
{
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask | 
    NSMiniaturizableWindowMask;
  NSView *_c_view;
  NSRect _w_frame;
  NSBox *view;
  NSTextField *tf;

  _w_frame = NSMakeRect(100,100,480,224);
  window = [[NSWindow alloc] initWithContentRect:_w_frame
			     styleMask:style
			     backing:NSBackingStoreBuffered
			     defer:NO];
  [window setDelegate:self];
  [window setTitle:@"Address and Host Resolver"];
  [window setMinSize:NSMakeSize(480,224)];
  [window setReleasedWhenClosed:NO];
  _c_view = [window contentView];

  view = AUTORELEASE([[NSBox alloc] init]);
  [view setTitle:@"Host Resolving"];
  [view setFrame:NSMakeRect(16,120,448,96)];
  [_c_view addSubview:view];

  tf = [[NSTextField alloc] initWithFrame:NSMakeRect(16,32,48,21)];
  [tf setStringValue:@"Host:"];
  [tf setAlignment: NSRightTextAlignment];
  [tf setBordered: NO];
  [tf setEditable: NO];
  [tf setBezeled: NO];
  [tf setDrawsBackground:NO];
  [view addSubview:tf];
  AUTORELEASE(tf);

  hostField = [[NSTextField alloc] initWithFrame:NSMakeRect(72,32,360,21)];
  [hostField setAlignment: NSLeftTextAlignment];
  [hostField setBordered: NO];
  [hostField setEditable: YES];
  [hostField setBezeled: YES];
  [hostField setDrawsBackground: YES];
  [view addSubview:hostField];
  AUTORELEASE(hostField);

  hostButton = [[NSButton alloc] initWithFrame:NSMakeRect(328,4,104,22)];
  [hostButton setTitle:@"Resolve Host"];
  [hostButton setTarget:self];
  [hostButton setAction:@selector(resolveHost)];
  [view addSubview:hostButton];
  AUTORELEASE(hostButton);

  view = AUTORELEASE([[NSBox alloc] init]);
  [view setTitle:@"Address Resolving"];
  [view setFrame:NSMakeRect(16,16,448,96)];
  //[view setFrameFromContentFrame:NSMakeRect(16,16,448,96)];
  [_c_view addSubview:view];

  tf = [[NSTextField alloc] initWithFrame:NSMakeRect(16,32,48,21)];
  [tf setStringValue:@"IP:"];
  [tf setAlignment: NSRightTextAlignment];
  [tf setBordered: NO];
  [tf setEditable: NO];
  [tf setBezeled: NO];
  [tf setDrawsBackground:NO];
  [view addSubview:tf];
  AUTORELEASE(tf);

  addressField = [[NSTextField alloc] initWithFrame:NSMakeRect(72,32,360,21)];
  [addressField setAlignment: NSLeftTextAlignment];
  [addressField setBordered: NO];
  [addressField setEditable: YES];
  [addressField setBezeled: YES];
  [addressField setDrawsBackground: YES];
  [view addSubview:addressField];
  AUTORELEASE(addressField);

  addressButton = [[NSButton alloc] initWithFrame:NSMakeRect(328,4,104,22)];
  [addressButton setTitle:@"Resolve Address"];
  [addressButton setTarget:self];
  [addressButton setAction:@selector(resolveAddress)];
  [view addSubview:addressButton];
  AUTORELEASE(addressButton);
}

@end









