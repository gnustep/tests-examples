/* screen_main -- GNUstep test program to ensure correct function of
                  the NSScreen class.

   Copyright (C) 2000 Free Software Foundation, Inc.

   Written by: Gregory John Casamento
   Date: May 2000
   
   This file is part of GNUstep

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.
   
   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
   */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

int main (int argc, const char *argv[])
{
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  NSApplication *anApplication = nil;
  NSArray *screenArray = nil;               
  NSEnumerator *screenEnumerator = nil;
  NSScreen *aScreen = nil;
  NSWindowDepth *depths = NULL;
  BOOL exactMatch = NO;
  
#ifdef GNUSTEP
  initialize_gnustep_backend();
#endif
  
  // insert your code here
  anApplication = [NSApplication sharedApplication];
  screenArray = [NSScreen screens];
  screenEnumerator = [screenArray objectEnumerator];
  
  // Loop through all of the screens
  puts("*************** List of all screens connected to the computer"); 
  while((aScreen = [screenEnumerator nextObject]))
    {
      NSDictionary *deviceDescription = [aScreen deviceDescription];
      NSValue *deviceSize = [deviceDescription objectForKey: NSDeviceSize],
	*deviceResolution = [deviceDescription 
			      objectForKey: NSDeviceResolution];
      NSSize screenSize, screenResolution;
      
      screenSize = [deviceSize sizeValue];
      screenResolution = [deviceResolution sizeValue];
      puts("**** Device description ****");
      printf("%s\n",[[deviceDescription description] cString]);
      puts("**** Size and Resolution information ****");
      printf("Screen size is %f x %f\n", 
	     screenSize.width, screenSize.height );
      printf("Screen size in DPI is %f x %f\n", 
	     screenResolution.width, screenResolution.height );
    }
  
  puts("\n**** Various other tests ****");
  printf("Components = %d\n", 
	 NSNumberOfColorComponents(NSCalibratedRGBColorSpace));
  printf("NSBestDepth(NSCalibratedRGBColorSpace,8,32,YES,&exactMatch) = %d\n",
	 NSBestDepth(NSCalibratedRGBColorSpace, 8, 32, YES, &exactMatch));
  printf("exactMatch = %d\n\n", exactMatch);
  
  puts("************* Available window depths...");
  depths = (NSWindowDepth *)NSAvailableWindowDepths();
  if( depths != NULL )
    {
      int index = 0;
      for( index = 0; depths[index] != 0; index++ )
	{
	  printf("depths[%d]=%d\n",index,depths[index]);
	  printf("bits per sample = %d\n",
		 NSBitsPerSampleFromDepth(depths[index]));
	  printf("bits per pixel = %d\n",
		 NSBitsPerPixelFromDepth(depths[index]));
	  printf("color space = %s\n",
		 [NSColorSpaceFromDepth(depths[index]) cString]);
	}
    }
  
  puts("\n************** Supported window depths...");
  depths = [[NSScreen mainScreen] supportedWindowDepths];
  if( depths != NULL )
    {
      int index = 0;
      for( index = 0; depths[index] != 0; index++ )
	{
	  printf("depths[%d]=%d\n",index,depths[index]);
	  printf("bits per sample = %d\n",
		 NSBitsPerSampleFromDepth(depths[index]));
	  printf("bits per pixel = %d\n",
		 NSBitsPerPixelFromDepth(depths[index]));
	  printf("color space = %s\n",
		 [NSColorSpaceFromDepth(depths[index]) cString]);
	}
    }
  
  [pool release];
  exit(0);       // insure the process exit status is 0
  return 0;      // ...and make main fit the ANSI spec.
}
