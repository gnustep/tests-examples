#import "PPController.h"

@implementation PPController

- (void) addMenuItemWithTitle: (NSString *)title
                       action: (SEL)action
                          key: (NSString *)key
                          tag: (NSInteger)tag
                       toMenu: (NSMenu *)menu
{
  NSMenuItem *item;

  item = (NSMenuItem *)[menu addItemWithTitle: title
                                       action: action
                                keyEquivalent: key];
  [item setTarget: self];
  [item setTag: tag];
}

- (void) addResponderMenuItemWithTitle: (NSString *)title
                                action: (SEL)action
                                 toMenu: (NSMenu *)menu
{
  [menu addItemWithTitle: title
                  action: action
           keyEquivalent: @""];
}

- (NSInteger) paintMenuInsertionIndexInMenu: (NSMenu *)menu
{
  NSInteger index;

  index = [menu indexOfItemWithTarget: NSApp
                            andAction: @selector(terminate:)];
  if (index == -1)
    {
      index = [menu indexOfItemWithTitle: @"Quit"];
    }
  if (index == -1)
    {
      index = [menu numberOfItems];
    }

  return index;
}

- (NSMenuItem *) addTopLevelMenuWithTitle: (NSString *)title
                                   toMenu: (NSMenu *)menu
{
  NSInteger index;

  index = [self paintMenuInsertionIndexInMenu: menu];
  return (NSMenuItem *)[menu insertItemWithTitle: title
                                         action: NULL
                                  keyEquivalent: @""
                                        atIndex: index];
}

- (void) installPaintMenus
{
  NSMenu *mainMenu;
  NSMenu *toolsMenu;
  NSMenu *widthMenu;
  NSMenu *imageMenu;
  NSMenuItem *toolsItem;
  NSMenuItem *widthItem;
  NSMenuItem *imageItem;

  mainMenu = [NSApp mainMenu];
  if (mainMenu == nil)
    {
      return;
    }

  if ([mainMenu itemWithTitle: @"Tools"] != nil)
    {
      return;
    }

  toolsMenu = [[NSMenu alloc] initWithTitle: @"Tools"];
  toolsItem = [self addTopLevelMenuWithTitle: @"Tools"
                                      toMenu: mainMenu];
  [mainMenu setSubmenu: toolsMenu forItem: toolsItem];
  [toolsMenu release];

  [self addMenuItemWithTitle: @"Brush"
                      action: @selector(setTool:)
                         key: @""
                         tag: 0
                      toMenu: toolsMenu];
  [self addMenuItemWithTitle: @"Line"
                      action: @selector(setTool:)
                         key: @""
                         tag: 1
                      toMenu: toolsMenu];
  [self addMenuItemWithTitle: @"Filled Oval"
                      action: @selector(setTool:)
                         key: @""
                         tag: 2
                      toMenu: toolsMenu];
  [self addMenuItemWithTitle: @"Filled Rectangle"
                      action: @selector(setTool:)
                         key: @""
                         tag: 3
                      toMenu: toolsMenu];
  [self addMenuItemWithTitle: @"Eraser"
                      action: @selector(setTool:)
                         key: @""
                         tag: 4
                      toMenu: toolsMenu];
  [self addMenuItemWithTitle: @"Paint Bucket"
                      action: @selector(setTool:)
                         key: @""
                         tag: 5
                      toMenu: toolsMenu];
  [self addMenuItemWithTitle: @"Eyedropper"
                      action: @selector(setTool:)
                         key: @""
                         tag: 6
                      toMenu: toolsMenu];
  [toolsMenu addItem: [NSMenuItem separatorItem]];
  [self addMenuItemWithTitle: @"Rectangle Outline"
                      action: @selector(setTool:)
                         key: @""
                         tag: 7
                      toMenu: toolsMenu];
  [self addMenuItemWithTitle: @"Oval Outline"
                      action: @selector(setTool:)
                         key: @""
                         tag: 8
                      toMenu: toolsMenu];

  widthMenu = [[NSMenu alloc] initWithTitle: @"Line Width"];
  widthItem = [self addTopLevelMenuWithTitle: @"Line Width"
                                      toMenu: mainMenu];
  [mainMenu setSubmenu: widthMenu forItem: widthItem];
  [widthMenu release];

  [self addMenuItemWithTitle: @"1 px"
                      action: @selector(setLineWidth:)
                         key: @""
                         tag: 1
                      toMenu: widthMenu];
  [self addMenuItemWithTitle: @"2 px"
                      action: @selector(setLineWidth:)
                         key: @""
                         tag: 2
                      toMenu: widthMenu];
  [self addMenuItemWithTitle: @"4 px"
                      action: @selector(setLineWidth:)
                         key: @""
                         tag: 4
                      toMenu: widthMenu];
  [self addMenuItemWithTitle: @"8 px"
                      action: @selector(setLineWidth:)
                         key: @""
                         tag: 8
                      toMenu: widthMenu];
  [self addMenuItemWithTitle: @"16 px"
                      action: @selector(setLineWidth:)
                         key: @""
                         tag: 16
                      toMenu: widthMenu];

  imageMenu = [[NSMenu alloc] initWithTitle: @"Image"];
  imageItem = [self addTopLevelMenuWithTitle: @"Image"
                                      toMenu: mainMenu];
  [mainMenu setSubmenu: imageMenu forItem: imageItem];
  [imageMenu release];

  [self addResponderMenuItemWithTitle: @"Clear Canvas"
                               action: @selector(clearCanvas:)
                               toMenu: imageMenu];
  [self addResponderMenuItemWithTitle: @"Invert Colors"
                               action: @selector(invertColors:)
                               toMenu: imageMenu];
}

- (void) awakeFromNib
{
  /* Por defecto se selecciona la
     herramienta de trazos. */
  tool = 0;
  lineWidth = 2.0;
  [self installPaintMenus];
}

/* Se retorna el outlet que conecta con
   la paleta de colores. */
- (id) colorWell
{
  return colorWell;
}

/* Metodos Accessor para establecer/obtener la 
   herramienta seleccionada por el usuario. */
- (void) setTool: (id)sender
{  
  tool = [sender tag];
}

- (NSInteger) tool
{
  return tool;
}

- (void) setLineWidth: (id)sender
{
  lineWidth = (CGFloat)[sender tag];
}

- (CGFloat) lineWidth
{
  return lineWidth;
}

@end
