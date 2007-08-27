//
//  RetroController.m
//  ASCII Projektor 2b
//
//  Created by  Sven on 26.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import "RetroController.h"


@implementation RetroController

- (void) awakeFromNib {
	//  
	[retroWindow registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.retroFilmPath" options:(NSKeyValueObservingOptionNew) context:nil];
	[movieView unregisterDraggedTypes];
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	// we're only observing the filmPath 
	NSError * theErr;
	QTMovie * theMovie = [QTMovie movieWithFile:[[NSUserDefaultsController sharedUserDefaultsController] valueForKeyPath:keyPath] error:&theErr];
	[movieView setMovie:theMovie];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
		NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		NSString * path = [files objectAtIndex:0];
		if ([path APWillAcceptPath]) {
			return NSDragOperationLink;
		}
    }
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
	
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
	
	if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		NSString * path = [files objectAtIndex:0];
		[[NSUserDefaultsController sharedUserDefaultsController] setValue:path forKeyPath:@"values.retroFilmPath"];
    }
    return YES;
}


- (IBAction) playInTerminal:(id)sender {
	NSString * toolpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ASCIIMoviePlayer"];
	int width = [[[NSUserDefaultsController sharedUserDefaultsController] valueForKeyPath:@"values.retroColumnCount"] intValue];
	int height = (width * 3 / 4 * 0.4) + 1;
	NSString * exitstring = ( [[[NSUserDefaultsController sharedUserDefaultsController] valueForKeyPath:@"values.retroCloseTerminalWhenFinished"] boolValue] ? @"; exit" : @"");
	
	NSString * theCommand = [NSString stringWithFormat:@"'%@' %i '%@'%@", toolpath, width, [[NSUserDefaultsController sharedUserDefaultsController] valueForKeyPath:@"values.retroFilmPath"], exitstring];
	
	NSData * d = [[NSUserDefaultsController sharedUserDefaultsController] valueForKeyPath:@"values.retroBackgroundColour"];
	NSColor * c = [[NSUnarchiver unarchiveObjectWithData:d] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	float r,g,b,a;
	[c getRed:&r green:&g blue:&b alpha:&a];
	unsigned short rs, gs, bs, as;
	rs = r * 65535;
	gs = g * 65535;
	bs = g * 65535;
	as = a * 65535;
	NSString * backgroundColourString = [NSString stringWithFormat: @"{%i, %i, %i, %i}", rs,  gs, bs, as];
	d = [[NSUserDefaultsController sharedUserDefaultsController] valueForKeyPath:@"values.retroColour"];
	c = [[NSUnarchiver unarchiveObjectWithData:d] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[c getRed:&r green:&g blue:&b alpha:&a];
	rs = r * 65535;
	gs = g * 65535;
	bs = g * 65535;
	as = a * 65535;
	NSString * foregroundColourString = [NSString stringWithFormat: @"{%i, %i, %i, %i}", rs, gs, bs, as];
		
	NSString * rawScript = [NSString stringWithFormat:@"\n tell application \"Terminal\"\n set theCommand to \"%@\"\n   activate\n	do script with command theCommand\n  tell window 1\n	set frontmost to true\n  set custom title to \".-:* ASCII Projektor *:-. \"\n  set position to {30, 30}\n  set number of columns to %i\n  set (number of rows) to %i\n  set background color to %@\n  set normal text color to %@\n  end tell\n  end tell", theCommand, width, height, backgroundColourString, foregroundColourString];
	
	NSLog (rawScript);
	
	NSAppleScript * theScript = [[[NSAppleScript alloc] initWithSource:rawScript] autorelease];
	NSDictionary * theError;
	[theScript executeAndReturnError:&theError];
}



@end
