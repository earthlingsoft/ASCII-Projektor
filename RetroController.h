//
//  RetroController.h
//  ASCII Projektor 2b
//
//  Created by  Sven on 26.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import "esDroppable.h"

@interface RetroController : NSObject {
	IBOutlet QTMovieView * movieView;
	IBOutlet NSTextField * pathField;
	IBOutlet NSWindow * retroWindow;
//	NSString * retroFilmPath;
}

- (IBAction) playInTerminal:(id)sender;

@end
