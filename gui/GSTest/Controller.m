#include "Controller.h"

NSComparisonResult nameSort(id path1, id path2, void *context);

@implementation Controller


-(void) dealloc
{
  RELEASE(tests);
  RELEASE(loadedTests);
  [super dealloc];
}

-(id) init
{ 
  [super init];
  
  loadedTests = [[NSMutableArray alloc] init];
  tests = [[NSMutableArray alloc] init];
  [self _findBundles];

  return self;
}

- (void) awakeFromNib
{
  id <NSMenuItem> menuItem;
  NSMenu *testMenu = [[[NSApp mainMenu] itemWithTag: 42] submenu];
  NSString *name;
  int i;
  
  for (i = 0; i < [tests count]; i++)
    {
      name = [[[tests objectAtIndex: i] lastPathComponent]
       stringByDeletingPathExtension]; 
      menuItem = [testMenu addItemWithTitle: name
        action: @selector (startListedTest:)
        keyEquivalent: @""];
      [menuItem setTag: i];
   }  

#ifdef __MINGW__
  NSWindow *w = [[NSWindow alloc] initWithContentRect: NSMakeRect(400,400,300,200)
					    styleMask: NSTitledWindowMask
					      backing: NSBackingStoreBuffered
						defer: NO];
  [w setTitle: @"GSTest"];
  [w makeKeyAndOrderFront: nil];
#endif
}

-(id) loadAndStartTestWithBundlePath: (NSString *)fullPath
{
  NSBundle *bundle;
  Class principalClass;

  // Load the bundle
  bundle = [NSBundle bundleWithPath: fullPath];

  if (bundle) // Bundle was succesfully loaded
    {
      // Load the principal class of the bundle
      principalClass = [bundle principalClass];
      if (principalClass) // succesfully loaded
        {
          return AUTORELEASE ([principalClass new]);
        }
      else // !principalClass
        {
          NSRunAlertPanel (NULL, @"Could not load principal class",
                           @"OK", NULL, NULL);
          return nil;
        }
    }
  else // !bundle
    {
      NSRunAlertPanel (NULL, @"Could not load Bundle",
                       @"OK", NULL, NULL);
      return nil;
    }
}

-(void) startListedTest: (id) sender
{
  NSString *bundlePath;
  int i;

  i = [sender tag];
  if ( [[loadedTests objectAtIndex: i] conformsToProtocol: @protocol(GSTest)])
    {
      [(id<GSTest>)[loadedTests objectAtIndex: i] restart];
      return;
    }
  else // not started yet
    { 
      bundlePath = [tests objectAtIndex: i];
      [loadedTests replaceObjectAtIndex: i 
        withObject: [self loadAndStartTestWithBundlePath: bundlePath]];
    }
}

-(void) startUnlistedTest: (id) sender
{
  NSOpenPanel *openPanel;
  int result;

  openPanel = [NSOpenPanel openPanel];
  [openPanel setTitle: @"Select Bundle"];
  [openPanel setPrompt: @"Bundle:"];
  [openPanel setTreatsFilePackagesAsDirectories: NO];
  result = [openPanel runModalForDirectory: nil
                      file: nil
                      types: [NSArray arrayWithObject: @"bundle"]];
  if (result == NSOKButton)
    {
      NSEnumerator *e = [[openPanel filenames] objectEnumerator];
      NSString *file;

      while ((file = (NSString *)[e nextObject]))
        {
          id test = [self loadAndStartTestWithBundlePath: file];
          [loadedTests addObject: test];
        }
    }
}

-(void) _findBundles
{
  NSMutableArray *bundlePaths;
  NSArray *stdPaths;
  NSEnumerator *enm;
  NSString *path;
  int i = 0;
  int k = 0;

  // The test bundles could be in a few places
  bundlePaths = [NSMutableArray arrayWithCapacity: 1];
  [bundlePaths addObject: [[[NSBundle mainBundle] bundlePath]
    stringByDeletingLastPathComponent]];
  stdPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
    NSUserDomainMask | NSLocalDomainMask | NSSystemDomainMask, YES);
  enm = [stdPaths objectEnumerator];
  while( (path = [enm nextObject]) )
    {
      [bundlePaths addObject: 
        [[path stringByAppendingPathComponent: @"ApplicationSupport"]
        stringByAppendingPathComponent: @"GSTest"]];
    }

  // stow away the bundle paths  
  for( i=0; i < [bundlePaths count]; i++ )
    {
      if( [[NSFileManager defaultManager] fileExistsAtPath: 
        [bundlePaths objectAtIndex: i]] )
        {  
          enm = [[NSFileManager defaultManager] enumeratorAtPath: 
            [bundlePaths objectAtIndex: i]];
          while( (path = [enm nextObject]) )
            {
              path = [[bundlePaths objectAtIndex: i] 
                stringByAppendingPathComponent: path];
              if( [[path pathExtension] isEqualToString: @"bundle"] &&
                ![tests containsObject: path] )
                {
                  [tests addObject: path];
                  [loadedTests insertObject: @"X" atIndex: k];
                  k++;  
                }
            }
        }
    }
    
  // alphabatize them so they're easy to find
  [tests sortUsingFunction: nameSort context: nil];
}

NSComparisonResult nameSort(id path1, id path2, void *context)
{
  return [[path1 lastPathComponent] compare: [path2 lastPathComponent]];
}

@end
