//
//  Document.m
//  CopyImage
//
//  Created by Luis Palacios on 01/03/13.
//  Copyright (c) 2013 Luis Palacios. All rights reserved.
//

#import "Document.h"

@implementation Document
@synthesize imageView;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

// ---- añadidos

/** @brief Copiar el contenido de la vista en pantalla al pasteboard. 
 *
 *  LEEMOS del View y COPIAMOS (ESCRIBIMOS) en el Pasteboard.
 *
 There are three steps to writing to a pasteboard:
 
 Los pasos a realizar para hacer un copy son:
 Get a pasteboard
 Clear the pasteboard’s contents
 Write an array of objects to the pasteboard
 Objects you write to the pasteboard must adopt the NSPasteboardWriting Protocol Reference protocol. Several of the common Foundation and Application Kit classes implement the protocol including NSString, NSImage, NSURL, and NSColor. (If you want to write an instance of a custom class, either it must adopt the NSPasteboardWriting protocol or you can wrap it in an instance of an NSPasteboardItem—see “Custom Data.”) Since NSImage adopts the NSPasteboardWriting protocol, you can write an instance directly to a pasteboard.
 
 
 *  MUY recomendado este post: http://stackoverflow.com/questions/7243668/nspasteboard-and-simple-custom-data
 
 */
- (IBAction)copy:sender {
    
    NSImage *image = [imageView image]; // Incopora el protocolo NSPasteboardWriting.
    
    if (image != nil) {
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        
        // A partir de la versión 10.6 usamos el nuevo método.
        [pasteboard clearContents];
        
        // Creo un array con los objetos a los que voy a pedirles que escriban en el pasteboard.
        // Estos objetos DEBEN implementar el protocolo NSPasteboardWriting.
        // En este ejemplo estoy usando NSImage, que ya trae de serie el NSPasteboardWriting ;-)
        NSArray *copiedObjects = [NSArray arrayWithObject:image];
        
        // Le digo al pasteboard que señalize a los objetos del array que tienen que hacer
        // un copy (mandar datos al pasteboard, escribir en él)
        [pasteboard writeObjects:copiedObjects];
    }

}

/** @brief Pegar el contenido del pasteboard sobre la vista en pantalla.
 *
 *  Paste: LEEMOS desde el Pasteboard y PEGAMOS en el VIEW.
 *
 * Si el pasteboard tiene objetos que me interesan, le mando el mensaje readObjectsForClasses:options:
 * pasándole un array de clases. 
 *
 * Al recibir ese mensaje determinará "cual de los objetos que él contiene" puede ser "representado"
 * usando una de las clases que le he pasado. Me devolverá un array de los que mejor se adapten. 
 */
- (IBAction)paste:sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    
    // Array de "clases" que le paso al pasteboard que representan qué tipo de datos puedo leer.
    // En este caso solo le paso uno, el tipo de clase NSImage, así que si hay imágenes en el
    // pasteboard podré leerla del pasteboard y mostrarla en mi view
    NSArray *classArray = [NSArray arrayWithObject:[NSImage class]];
    NSDictionary *options = [NSDictionary dictionary];

    // Compruebo si lo que hay en el pasteboard es de tipo nsimage...
    BOOL ok = [pasteboard canReadObjectForClasses:classArray options:options];
    if (ok) {
        // A triunfado, le pido el array de los objetos que mejor se adaptan a lo que puedo leer
        // siendo en este caso solo NSImage
        NSArray *objectsToPaste = [pasteboard readObjectsForClasses:classArray options:options];
        
        // Recupero la primera imagen del array...
        NSImage *image = [objectsToPaste objectAtIndex:0];
        
        // Y la planto en el view.
        [imageView setImage:image];
    }
}

/** @brief Implemento la validación de cuando poder hacer un paste
 *
 *  Solo digo que SI puedo hacer un paste si lo que hay en el pasteboard es un NSImage
 *
 */
- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem {
    
    if ([anItem action] == @selector(paste:)) {
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        NSArray *classArray = [NSArray arrayWithObject:[NSImage class]];
        NSDictionary *options = [NSDictionary dictionary];
        return [pasteboard canReadObjectForClasses:classArray options:options];
    }
    return [super validateUserInterfaceItem:anItem];
}

@end
