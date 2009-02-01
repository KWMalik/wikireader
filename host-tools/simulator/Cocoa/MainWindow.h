//
//  MainWindow.h
//  CocoaSimulator
//
//  Created by Daniel on 11.12.08.
//  Copyright 2008 caiaq. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WikiDisplay.h"

@interface MainWindow : NSWindow {
	IBOutlet WikiDisplay *imageView;
	NSCondition *condition;
	NSBitmapImageRep *imageRep;
	NSTimer *refreshTimer;
	unsigned char *frameBuffer;
}

- (void) refreshDisplay;
- (void) clear;
- (void) setPixel: (UInt32) val atX: (UInt32) x atY: (UInt32) y;
- (NSCondition *) getCondition;
- (NSImageView *) imageView;
- (IBAction) buttonPressed: (id) sender;

@end
