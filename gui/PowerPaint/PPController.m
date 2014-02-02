#import "PPController.h"

@implementation PPController

- (void) awakeFromNib
{
  /* Por defecto se selecciona la
     herramienta de trazos. */
  tool = 0;
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

@end
