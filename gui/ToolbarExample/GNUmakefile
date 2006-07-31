include $(GNUSTEP_MAKEFILES)/common.make

PACKAGE_NAME = ToolbarExample
APP_NAME = ToolbarExample
ToolbarExample_APPLICATION_ICON =
ToolbarExample_MAIN_MODEL_FILE = ToolbarExample.gorm

ToolbarExample_RESOURCE_FILES= \
ToolbarExample.gorm \
DocumentWindow.gorm \
SecondWindow.gorm \
ToolbarExampleInfo.plist \
Images/SecondImage.tiff \
Images/RecyclerFull.tiff \
Images/FileIcon_Directory.tiff

ToolbarExample_HEADER_FILES= \
Controller.h \
DocumentOwner.h \
SecondWindowOwner.h \
ButtonWithValidation.h

ToolbarExample_OBJC_FILES= \
main.m \
Controller.m \
DocumentOwner.m \
SecondWindowOwner.m \
ButtonWithValidation.m

-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/application.make
-include GNUmakefile.postamble
