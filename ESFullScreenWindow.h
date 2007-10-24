//
//  ESFullScreenWindow.h
//  ASCII Projektor 2b
//
//  Created by  Sven on 14.09.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ESFullScreenWindow : NSWindow {
	id owner;
}

- (void) mouseDown:(NSEvent *)theEvent;
- (void) keyDown:(NSEvent *)theEvent;
- (void) stopFullScreen; 
@end
