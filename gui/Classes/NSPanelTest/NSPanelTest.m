/*****************************************************************************
FILE:               NSPanelTest.m
LANGUAGE:           Objective-C
SYSTEM:             GNUstep
USER-INTERFACE:     None
DESCRIPTION

    This application is a test bed for the NSPanel functions.

AUTHORS
    <PJB> Pascal J. Bourguignon <pjb@imaginet.fr>
MODIFICATIONS
    2000-03-05 <PJB> Creation.
BUGS
LEGAL
    Written by:  Pascal J. Bourguignon <pjb@imaginet.fr>

    Copyright (C) 2000 Free Software Foundation, Inc.

    This  library is  free software;  you can  redistribute  it and/or
    modify it under the terms of the GNU Lesser General Public License
    as published by the Free  Software Foundation; either version 2 of
    the License, or (at your option) any later version.

    This library  is distributed in the  hope that it  will be useful,
    but  WITHOUT ANY WARRANTY;  without even  the implied  warranty of
    MERCHANTABILITY or FITNESS FOR  A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have  received a copy of the  GNU Lesser General Public
    License  along  with this  library;  if  not,  write to  the  Free
    Software  Foundation, Inc.,  59 Temple  Place, Suite  330, Boston,
    MA 02111-1307 USA
*****************************************************************************/
#import "NSPanelTest.h"
#include <stdlib.h>


////////////////////////////////////////////////////////////////////////

@interface PanelConstructor:NSObject
{
}

// This is an abstract class. Please use the subclasses.

    -(NSString*)panelName;

    -(id)getPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat;

    -(int)runPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat;

    -(int)runLocalizedPanelFromTable:(NSString*)table
                           withTitle:(NSString*)title
                              format:(NSString*)format
                       defaultButton:(NSString*)desfaux
                     alternateButton:(NSString*)alternate
                         otherButton:(NSString*)other
                       andWithObject:(id)forFormat;

@end //PanelConstructor;

////////////////////////////////////////////////////////////////////////


@implementation PanelConstructor

-(NSString*)panelName
{
  [self subclassResponsibility:_cmd];
  return nil;
}


-(id)getPanelTitled:(NSString*)title
	 withFormat:(NSString*)format
      defaultButton:(NSString*)desfaux
    alternateButton:(NSString*)alternate
	otherButton:(NSString*)other
      andWithObject:(id)forFormat
{
  [self subclassResponsibility:_cmd];
  return nil;
}//getPanelTitled:...;


-(int)runPanelTitled:(NSString*)title
	  withFormat:(NSString*)format
       defaultButton:(NSString*)desfaux
     alternateButton:(NSString*)alternate
	 otherButton:(NSString*)other
       andWithObject:(id)forFormat;
{
  [self subclassResponsibility:_cmd];
  return 0;
}//runPanelTitled:...;


-(int)runLocalizedPanelFromTable:(NSString*)table
		       withTitle:(NSString*)title
			  format:(NSString*)format
		   defaultButton:(NSString*)desfaux
		 alternateButton:(NSString*)alternate
		     otherButton:(NSString*)other
		   andWithObject:(id)forFormat
{
  [self subclassResponsibility:_cmd];
  return 0;
}//runLocalizedPanelTitled:...;


@end //PanelConstructor;

////////////////////////////////////////////////////////////////////////

@interface AlertPanelConstructor:PanelConstructor
{
}

/*
  RETURN:     the singleton instance of this class.
*/
+(id)instance;

// overwrites all the methods of its superclass.

@end //AlertPanelConstructor;

////////////////////////////////////////////////////////////////////////

@implementation AlertPanelConstructor

+(id)instance
    {
        static id instance=nil;
        if(instance==nil){
            instance=[[self alloc]init];
        }
        return(instance);
    }//instance;


    -(NSString*)panelName
    {
        return(@"Alert Panel");
    }//panelName;


    -(id)getPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat
    {
        return(NSGetAlertPanel(title,format,desfaux,alternate,other,forFormat));
    }//getPanelTitled:...;


    -(int)runPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat;
    {
        return(NSRunAlertPanel(title,format,desfaux,alternate,other,forFormat));
    }//runPanelTitled:...;


    -(int)runLocalizedPanelFromTable:(NSString*)table
                           withTitle:(NSString*)title
                              format:(NSString*)format
                       defaultButton:(NSString*)desfaux
                     alternateButton:(NSString*)alternate
                         otherButton:(NSString*)other
                       andWithObject:(id)forFormat;
    {
#ifndef	STRICT_MACOS_X
        return(NSRunLocalizedAlertPanel(table,title,format,desfaux,alternate,
                                        other,forFormat));
#else
        return(NSRunAlertPanel(@"Unavailable Function",
                               @"The function NSRunLocalizedAlertPanel is not"
                               @"available on STRICT_MACOS_X hosts.\n"
                               @"%@",
                               @"OK",nil,nil,
                               @"Please use GNUstep instead of MacOSX to "
                               @"profit of all the advantages of a good "
                               @"OpenStep implementation."));
#endif
    }//runLocalizedPanelTitled:...;


@end //AlertPanelConstructor;

////////////////////////////////////////////////////////////////////////

@interface CriticalPanelConstructor:PanelConstructor
{
}

    +(id)instance;
        /*
            RETURN:     the singleton instance of this class.
        */

// overwrites all the methods of its superclass.

@end //CriticalPanelConstructor;

////////////////////////////////////////////////////////////////////////

@implementation CriticalPanelConstructor

    +(id)instance
    {
        static id instance=nil;
        if(instance==nil){
            instance=[[self alloc]init];
        }
        return(instance);
    }//instance;


    -(NSString*)panelName
    {
        return(@"Critical Panel");
    }//panelName;


    -(id)getPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat
    {
#ifndef	STRICT_OPENSTEP
        return(NSGetCriticalAlertPanel(title,format,desfaux,alternate,
                                       other,forFormat));
#else
        return(NSGetAlertPanel(@"Unavailable Function"
                               @"The function NSGetCriticalAlertPanel is not"
                               @"available on STRICT_OPENSTEP hosts.\n"
                               @"%@",
                               @"OK",nil,nil,
                               @"Please use GNUstep instead of MacOSX to "
                               @"profit of all the advantages of a true and "
                               @"untarnished OpenStep implementation."));
#endif
    }//getPanelTitled:...;


    -(int)runPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat;
    {
#ifndef	STRICT_OPENSTEP
        return(NSRunCriticalAlertPanel(title,format,desfaux,alternate,
                                       other,forFormat));
#else
        return(NSRunAlertPanel(@"Unavailable Function"
                               @"The function NSRunCriticalAlertPanel is not"
                               @"available on STRICT_OPENSTEP hosts.\n"
                               @"%@",
                               @"OK",nil,nil,
                               @"Please use GNUstep instead of MacOSX to "
                               @"profit of all the advantages of a true and "
                               @"untarnished OpenStep implementation."));
#endif
    }//getPanelTitled:...;


    -(int)runLocalizedPanelFromTable:(NSString*)table
                           withTitle:(NSString*)title
                              format:(NSString*)format
                       defaultButton:(NSString*)desfaux
                     alternateButton:(NSString*)alternate
                         otherButton:(NSString*)other
                       andWithObject:(id)forFormat;
    {
        // Not available for critical panels.
      return 0;
    }//runLocalizedPanelTitled:...;


@end //CriticalPanelConstructor;

////////////////////////////////////////////////////////////////////////


@interface InformationalPanelConstructor:PanelConstructor
{
}

    +(id)instance;
        /*
            RETURN:     the singleton instance of this class.
        */

// overwrites all the methods of its superclass.

@end //InformationalPanelConstructor;

////////////////////////////////////////////////////////////////////////

@implementation InformationalPanelConstructor

    +(id)instance
    {
        static id instance=nil;
        if(instance==nil){
            instance=[[self alloc]init];
        }
        return(instance);
    }//instance;


    -(NSString*)panelName
    {
        return(@"Informational Panel");
    }//panelName;


    -(id)getPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat
    {
#ifndef	STRICT_OPENSTEP
        return(NSGetInformationalAlertPanel(title,format,desfaux,alternate,
                                       other,forFormat));
#else
        return(NSGetAlertPanel(@"Unavailable Function"
                               @"The function NSGetInformationalAlertPanel is "
                               @"not available on STRICT_OPENSTEP hosts.\n"
                               @"%@",
                               @"OK",nil,nil,
                               @"Please use GNUstep instead of MacOSX to "
                               @"profit of all the advantages of a true and "
                               @"untarnished OpenStep implementation."));
#endif
    }//getPanelTitled:...;


    -(int)runPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat;
    {
#ifndef	STRICT_OPENSTEP
        return(NSRunInformationalAlertPanel(title,format,desfaux,alternate,
                                       other,forFormat));
#else
        return(NSRunAlertPanel(@"Unavailable Function"
                               @"The function NSRunInformationalAlertPanel is "
                               @"not available on STRICT_OPENSTEP hosts.\n"
                               @"%@",
                               @"OK",nil,nil,
                               @"Please use GNUstep instead of MacOSX to "
                               @"profit of all the advantages of a true and "
                               @"untarnished OpenStep implementation."));
#endif
    }//getPanelTitled:...;


    -(int)runLocalizedPanelFromTable:(NSString*)table
                           withTitle:(NSString*)title
                              format:(NSString*)format
                       defaultButton:(NSString*)desfaux
                     alternateButton:(NSString*)alternate
                         otherButton:(NSString*)other
                       andWithObject:(id)forFormat;
    {
        // Not available for informational panels.
      return 0;
    }//runLocalizedPanelTitled:...;


@end //InformationalPanelConstructor;

////////////////////////////////////////////////////////////////////////

@interface RandomPanelConstructor:PanelConstructor
{
}

// This is an abstract class. Please use the subclasses.

    -(id)getPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat;

    -(int)runPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat;

    -(int)runLocalizedPanelFromTable:(NSString*)table
                           withTitle:(NSString*)title
                              format:(NSString*)format
                       defaultButton:(NSString*)desfaux
                     alternateButton:(NSString*)alternate
                         otherButton:(NSString*)other
                       andWithObject:(id)forFormat;

@end //RandomPanelConstructor;

////////////////////////////////////////////////////////////////////////


@implementation RandomPanelConstructor

    static PanelConstructor* choice[3];

    +(void)initialize
    {
        choice[0]=[[AlertPanelConstructor instance]retain];
        choice[1]=[[CriticalPanelConstructor instance]retain];
        choice[2]=[[InformationalPanelConstructor instance]retain];
    }//initialize;


    +(id)instance
    {
        static id instance=nil;
        if(instance==nil){
            instance=[[self alloc]init];
        }
        return(instance);
    }//instance;


    -(int)random
    {
        return(rand()%3);
    }//random;


    -(NSString*)panelName
    {
        return(@"Either Alert, Critical or Informational");
    }//panelName;


    -(id)getPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat
    {
        return([choice[[self random]] getPanelTitled:title
                      withFormat:format
                      defaultButton:desfaux
                      alternateButton:alternate
                      otherButton:other
                      andWithObject:forFormat]);
    }//getPanelTitled:...;


    -(int)runPanelTitled:(NSString*)title
             withFormat:(NSString*)format
          defaultButton:(NSString*)desfaux
        alternateButton:(NSString*)alternate
            otherButton:(NSString*)other
          andWithObject:(id)forFormat;
    {
        return([choice[[self random]] runPanelTitled:title
                      withFormat:format
                      defaultButton:desfaux
                      alternateButton:alternate
                      otherButton:other
                      andWithObject:forFormat]);
    }//runPanelTitled:...;


    -(int)runLocalizedPanelFromTable:(NSString*)table
                           withTitle:(NSString*)title
                              format:(NSString*)format
                       defaultButton:(NSString*)desfaux
                     alternateButton:(NSString*)alternate
                         otherButton:(NSString*)other
                       andWithObject:(id)forFormat
    {
        return([choice[[self random]] runLocalizedPanelFromTable:table
                      withTitle:title
                      format:format
                      defaultButton:desfaux
                      alternateButton:alternate
                      otherButton:other
                      andWithObject:forFormat]);
    }//runLocalizedPanelTitled:...;

@end //RandomPanelConstructor;

////////////////////////////////////////////////////////////////////////

@implementation NSPanelTest


-(id)init
{
  self=[super init];
  if(self!=nil){
    constructor=[AlertPanelConstructor instance];
  }
  return(self);
}//init;


-(void)dealloc
{
  [super dealloc];
}//dealloc;


-(void)applicationWillFinishLaunching:(NSNotification*)notification
{
  [NSApp setMainMenu:[self makeMenu]];
}//applicationDidFinishLaunching:;


// tests:

-testHighMessagePanel:sender
{
  NSMutableString* message=[NSMutableString stringWithFormat:
					      @"Let's see how many lines can be shown on this screen...\n"];
  int i;
  int result;

  for(i=0;i<100;i++){
    [message appendFormat:@"Line %d\n",i];
  }
  result=[constructor runPanelTitled:@"Testing Height"
		      withFormat:message
		      defaultButton:@"Yes"
		      alternateButton:@"No"
		      otherButton:@"May be"
		      andWithObject:nil];
  NSLog(@"Testing Height NSRunAlertPanel returned %d\n",result);
  return(self);
}//testHighMessagePanel:;


-testLargeMessagePanel:sender
{
  NSMutableString* message=[NSMutableString stringWithFormat:
					      @"A long line: "];
  int i;
  int result;

  message=[NSMutableString stringWithFormat:@"Hello"];
  for(i=0;i<100;i++){
    [message appendFormat:@", number %d",i];
  }
  result=[constructor runPanelTitled:@"Testing Width"
		      withFormat:message
		      defaultButton:@"Yes"
		      alternateButton:@"No"
		      otherButton:@"May be"
		      andWithObject:nil];
  NSLog(@"Testing Width  NSRunAlertPanel returned %d\n",result);
  return(self);
}//testLargeMessagePanel:;


-testSmallPanel:sender
{
  int result;
  result=[constructor runPanelTitled:@"Testing Small"
		      withFormat:@"Small?"
		      defaultButton:@"Yes"
		      alternateButton:@"No"
		      otherButton:@"May be"
		      andWithObject:nil];
  NSLog(@"Testing Small  NSRunAlertPanel returned %d\n",result);
  return self;
}//testSmalPanel:;


-testLargeTitlePanel:sender
{
  int result;
  result=[constructor runPanelTitled:@"Testing with a very, very, very long title, that should go well over one screen width, even on very, very, very large screens, and this is just to see what would happen in such a case."
		      withFormat:@"Large enough?"
		      defaultButton:@"Yes"
		      alternateButton:@"No"
		      otherButton:@"May be"
		      andWithObject:nil];
  NSLog(@"Testing Large Title  NSRunAlertPanel returned %d\n",result);
  return self;
}//testLargeTitlePanel:;



-testGettingPanel:sender
{
  int result;
  NSPanel* panel;
  panel=[constructor getPanelTitled:@"Getting a panel"
		     withFormat:@"This panel was built with \n"
		     @"NSGetAlertPanel."
		     defaultButton:@"Yes"
		     alternateButton:@"No"
		     otherButton:@"May be"
		     andWithObject:nil];
  if(panel!=nil){
    result=[[NSApplication sharedApplication]runModalForWindow:panel];
    NSLog(@"Testing NSGetAlertPanel, runModalForWindow returned %d\n",result);
    if([panel isVisible]){
      [panel close];
    }
    NSReleaseAlertPanel(panel);
  }
  return self;
}//testGettingPanel:;


-testLocalizedPanel:sender
{
  int result;
  result=[constructor runLocalizedPanelFromTable:@"Test"
		      withTitle:@"Testing Localized"
		      format:@"This message should be read in French."
		      defaultButton:@"Yes"
		      alternateButton:@"No"
		      otherButton:@"May be"
		      andWithObject:nil];
  NSLog(@"Testing NSRunLocalizedAlertPanel returned %d\n",result);
  return self;
}//testLocalizedPanel:;


-testMultilineBtnPanel:sender
{
  int result;
  result=[constructor runPanelTitled:@"Testing With Multiline Buttons"
		      withFormat:@"Two lines of message\n"
		      @"and four lines of button."
		      defaultButton:@"Yes!\nOui !\nJa !\n¡ Si !"
		      alternateButton:@"No"
		      otherButton:@"May be"
		      andWithObject:nil];
  NSLog(@"Testing multiline buttons NSRunAlertPanel returned %d\n",
	result);
  return self;
}//testMultilineBtnPanel:;


-testTitleLessPanel:sender
{
  int result;
  result=[constructor runPanelTitled:nil
		      withFormat:@"This panel should be titleless,\n"
		      @"or not, depending on its kind:"
		      @"%@."
		      defaultButton:@"Yes"
		      alternateButton:@"No"
		      otherButton:@"May be"
		      andWithObject:[constructor panelName]];
  NSLog(@"Testing titleless NSRunAlertPanel returned %d\n",result);
  return self;
}//testTitleLessPanel;



-testMissingBtnRunPanel:sender
{
  int buttons;
  for(buttons=0;buttons<8;buttons++){
    int result=[constructor runPanelTitled:@"Testing NSRunModalPanel With Missing Buttons"
			    withFormat:@"When no button is available,\n"
			    @"you should be able to close the\n"
			    @"panel with the escape key.\n"
			    @"(%@/7)"
			    defaultButton:((buttons&1)?@"Yes":nil)
			    alternateButton:((buttons&2)?@"No":nil)
			    otherButton:((buttons&4)?@"May Be":nil)
			    andWithObject:[NSNumber numberWithInt:buttons]];
    NSLog(@"Testing buttons (%d/7) NSRunAlertPanel returned %d\n",buttons,result);
  }
  return self;
}//testMissingButtonRunPanel:;


-testMissingBtnGetPanel:sender
{
  int buttons;
  for(buttons=0;buttons<8;buttons++){
    NSPanel* panel=[constructor 
		     getPanelTitled:@"Testing NSGetModalPanel With Missing Buttons"
		     withFormat:@"When no button is available,\n"
		     @"you should be able to close the\n"
		     @"panel with the escape key.\n"
		     @"(%@/7)"
		     defaultButton:((buttons&1)?@"Yes":nil)
		     alternateButton:((buttons&2)?@"No":nil)
		     otherButton:((buttons&4)?@"May Be":nil)
                     andWithObject:[NSNumber numberWithInt:buttons]];
    if(panel!=nil){
      int  result=[[NSApplication sharedApplication]
		    runModalForWindow:panel];
      NSLog(@"Testing buttons (%d/7) NSGetAlertPanel, runModalForWindow returned %d\n",buttons,result);
      if([panel isVisible]){
	[panel close];
      }
      NSReleaseAlertPanel(panel);
    }
  }
  return self;
}//testMissingBtnGetPanel:;


-testAll:sender
{
  [self testHighMessagePanel:sender];
  [self testLargeMessagePanel:sender];
  [self testSmallPanel:sender];
  [self testLargeTitlePanel:sender];
  [self testGettingPanel:sender];
  [self testLocalizedPanel:sender];
  [self testMultilineBtnPanel:sender];
  [self testTitleLessPanel:sender];
  [self testMissingBtnRunPanel:sender];
  [self testMissingBtnGetPanel:sender];
  return(self);
}//testAll:;


// actions:


-showInformations:sender
{
  [[NSApplication sharedApplication] orderFrontStandardInfoPanel: self];
  return(self);
}//showInformations:;


-useAlertPanels:sender
{
  constructor=[AlertPanelConstructor instance];
  return(self);
}//useAlertPanels:;


-useCriticalPanels:sender
{
  constructor=[CriticalPanelConstructor instance];
  return(self);
}//useCriticalPanels:;


-useInformationalPanels:sender
{
  constructor=[InformationalPanelConstructor instance];
  return(self);
}//useInformationalPanels:;


-useRandomPanels:sender
{
  constructor=[RandomPanelConstructor instance];
  return(self);
}//useRandomPanels:;


@end // NSPanelTest;

////////////////////////////////////////////////////////////////////////

@implementation NSPanelTest(Protected)
  
-(NSMenu*)makeMenu
{
  id item;
  NSMenu*     menu;
  NSMenu*     subm;

#define makeitem(menu,tit,sel,key)					\
  item=[menu addItemWithTitle:tit action:@selector(sel)			\
	     keyEquivalent:key]; [item setEnabled:YES]; [item setTarget:self]

  menu=[[NSMenu alloc] initWithTitle:[[self class]description]];
  makeitem(menu,@"Informations",           showInformations:,       @"i");
        
  subm=[[NSMenu alloc] initWithTitle:@"Panel Kind"];
  makeitem(subm,@"Use Alert Panels",        useAlertPanels:,        @"");
  makeitem(subm,@"Use Critical Panels",     useCriticalPanels:,     @"");
  makeitem(subm,@"Use Informational Panels",useInformationalPanels:,@"");
  makeitem(subm,@"Use Random Panels",       useRandomPanels:,       @"");
  makeitem(menu,@"Panel Kind",              submenuAction:,         @"");
  [menu setSubmenu:subm forItem:item];

  subm=[[NSMenu alloc] initWithTitle:@"Tests"];
  makeitem(subm,@"All",                     testAll:,              @"0");
  makeitem(subm,@"High Message",            testHighMessagePanel:, @"1");
  makeitem(subm,@"Large Message",           testLargeMessagePanel:,@"2");
  makeitem(subm,@"Small Message",           testSmallPanel:,       @"3");
  makeitem(subm,@"Large Title",             testLargeTitlePanel:,  @"4");
  makeitem(subm,@"NSGetAlertPanel",         testGettingPanel:,     @"5");
  makeitem(subm,@"NSRunLocalizedAlertPanel",testLocalizedPanel:,   @"6");
  makeitem(subm,@"Multiline Buttons",       testMultilineBtnPanel:,@"7");
  makeitem(subm,@"Without Title",           testTitleLessPanel:,   @"8");
  makeitem(subm,@"Missing Buttons (Run)", testMissingBtnRunPanel:, @"9");
  makeitem(subm,@"Missing Buttons (Get)", testMissingBtnGetPanel:, @"a");
  makeitem(menu,@"Tests",                   submenuAction:,        @"");
  [menu setSubmenu:subm forItem:item];

  makeitem(menu,@"Hide",                     hide:,                 @"h");
  makeitem(menu,@"Quit",                     terminate:,            @"q");

  [menu sizeToFit];
  return(menu);
}//makeMenu;




@end // NSPanelTest(Protected).


/*** NSPanelTest.m                    -- 2000-03-10 13:11:30 -- PJB ***/
