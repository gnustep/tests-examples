/* 
 * Resolver.h created by phr on 2000-10-10 18:38:00 +0000
 *
 * Project HostAddress
 *
 * Created with ProjectCenter - http://www.projectcenter.ch
 *
 * $Id$
 */

#import <AppKit/AppKit.h>

@interface Resolver : NSObject
{
  NSWindow *window;

  NSTextField *addressField;
  NSTextField *hostField;

  id hostButton;
  id addressButton;
}

- (id)init;
- (void)dealloc;

- (void)resolveHost;
- (void)resolveAddress;

- (void)makeKeyAndOrderFront;

@end

@interface Resolver (UIBuilder)

- (void)createUI;

@end
