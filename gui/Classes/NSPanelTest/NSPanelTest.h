/*****************************************************************************
FILE:               NSPanelTest.h
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

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>



@interface NSPanelTest : NSObject
{
    id      constructor;
}

    -(id)init;
    -(void)applicationWillFinishLaunching:(NSNotification*)notification;

// actions:

    -testHighMessagePanel:sender;
    -testLargeMessagePanel:sender;
    -testSmallPanel:sender;
    -testLargeTitlePanel:sender;
    -testGettingPanel:sender;
    -testLocalizedPanel:sender;
    -testMultilineBtnPanel:sender;
    -testTitleLessPanel:sender;
    -testMissingBtnRunPanel:sender;
    -testMissingBtnGetPanel:sender;
    -testAll:sender;
    -useAlertPanels:sender;
    -useCriticalPanels:sender;
    -useInformationalPanels:sender;
    -useRandomPanels:sender;


@end // NSPanelTest;


@interface NSPanelTest(Protected)
  
	-(NSMenu*)makeMenu;

@end // NSPanelTest(Protected).
/*** NSPanelTest.h                    -- 2000-03-10 13:11:30 -- PJB ***/
