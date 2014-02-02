include $(GNUSTEP_MAKEFILES)/common.make

#
# Application
#
VERSION = 0.1
PACKAGE_NAME = PowerPaint
APP_NAME = PowerPaint
PowerPaint_APPLICATION_ICON = 
PowerPaint_MAIN_MODEL_FILE = PowerPaint.gorm


#
# Resource files
#
PowerPaint_RESOURCE_FILES = \
PowerPaint.gorm \
Document.gorm


#
# Header files
#
PowerPaint_HEADER_FILES = \
PPController.h \
PPDocumentClass.h \
PPDocumentView.h \
PPToolsPanel.h


#
# Class files
#
PowerPaint_OBJC_FILES = \
PPController.m \
PPDocumentClass.m \
PPDocumentView.m \
PPToolsPanel.m


#
# Other sources
#
PowerPaint_OBJC_FILES += \
PPMain.m


#
# Makefiles
#
-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/application.make
-include GNUmakefile.postamble
