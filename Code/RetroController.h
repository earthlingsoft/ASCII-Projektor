//
//  RetroController.h
//  ASCII Projektor 2b
//
//  Created by Sven on 26.08.2007.
//  Copyright 2007-2015 earthlingsoft. All rights reserved.
//

@import Cocoa;
@import AVKit;
#import "esDroppable.h"


@interface RetroController : NSObject {
	IBOutlet AVPlayerView * playerView;
	IBOutlet NSTextField * pathField;
	IBOutlet NSWindow * retroWindow;
}

- (IBAction) playInTerminal:(id)sender;

@end
