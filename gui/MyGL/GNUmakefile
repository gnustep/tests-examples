include $(GNUSTEP_MAKEFILES)/common.make

PACKAGE_NAME = MyGL
VERSION = 0.0.1
APP_NAME = MyGL
MyGL_MAIN_MODEL_FILE=MyGL.gorm
MyGL_APPLICATION_ICON=MyGL.tiff

MyGL_OBJC_FILES = main.m AppController.m
MyGL_RESOURCE_FILES = MyGL.gorm MyGL.tiff


ifeq ($(GNUSTEP_TARGET_OS), mingw32)
ADDITIONAL_TOOL_LIBS += -lopengl32 -lglu32 -lm
else
ADDITIONAL_TOOL_LIBS += -lGL -lGLU -lm
endif

include $(GNUSTEP_MAKEFILES)/application.make
