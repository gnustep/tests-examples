#
ifeq ($(GNUSTEP_SYSTEM_ROOT),)
  GNUSTEP_SYSTEM_ROOT = $(TOPLEV)
endif

GNUSTEP_INSTALLATION_DIR = $(GNUSTEP_SYSTEM_ROOT)

GNUSTEP_MAKEFILES = $(GNUSTEP_SYSTEM_ROOT)/Makefiles

include $(GNUSTEP_SYSTEM_ROOT)/Makefiles/common.make
-include Makefile.preamble

APP_NAME=NSPanelTest
NSPanelTest_PRINCIPAL_CLASS=NSPanelTest
NSPanelTest_APPLICATION_ICON=icon.tiff
NSPanelTest_RESOURCE_FILES=$(NSPanelTest_APPLICATION_ICON) Test.strings 
NSPanelTest_RESOURCE_DIRS=
NSPanelTest_OBJC_FILES=\
	NSPanelTest.m \
	NSPanelTest_main.m
#NSPanelTest_TOOL_LIBS= -lgnustep-db -lFoundationExt

ADDITIONAL_LDFLAGS =  #-lefence
ADDITIONAL_INCLUDE_DIRS = 

include $(GNUSTEP_MAKEFILES)/application.make

-include Makefile.postamble

#END#
