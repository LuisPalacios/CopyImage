//
//
// This project is based on the Apple Tutorial at:
// Pasteboard Programming guide -> Getting Started with Pasteboards 
// http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/PasteboardGuide106/Introduction/Introduction.html
//
//
//  Document.h
//  CopyImage
//
//  Created by Luis Palacios on 01/03/13.
//  Copyright (c) 2013 Luis Palacios. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument
{
    NSImageView *imageView;
}

@property (nonatomic, retain) IBOutlet NSImageView *imageView;
- (IBAction)copy:sender;
- (IBAction)paste:sender;

@end
