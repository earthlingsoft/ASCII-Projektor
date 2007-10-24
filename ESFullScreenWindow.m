//
//  ESFullScreenWindow.m
//  ASCII Projektor 2b
//
//  Created by  Sven on 14.09.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import "ESFullScreenWindow.h"
#import "MyDocument.h"

@implementation ESFullScreenWindow

- (BOOL)canBecomeKeyWindow
{
	// NSLog(@"ESFullSCreenWindow canBecomeKeyWindow");
	return YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
	[self stopFullScreen];
}

- (void)keyDown:(NSEvent *)theEvent {
	[self stopFullScreen];
}

-(void) stopFullScreen {
	// NSLog(@"ESFullScreenWindow stopFullScreen");
	[(MyDocument*)owner fullScreenStop:	self];
}

@end
