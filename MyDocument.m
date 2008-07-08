//
//  MyDocument.m
//  ASCII Projektor 2b
//
//  Created by  Sven on 19.08.07.
//  Copyright earthlingsoft 2007 . All rights reserved.
//

#import "MyDocument.h"
#define UDC [NSUserDefaultsController sharedUserDefaultsController]

@implementation MyDocument


#pragma mark SETUP

- (id)init
{
    self = [super init];
    if (self) {
		// set defaults for our values...
		[self setValue:[NSNumber numberWithInt:1] forKey:@"filmSource"];
		[self setValue:[DEFAULTFILMPATHS objectAtIndex:0] forKey:@"filmPath"];
		[self setValue:[DEFAULTTEXTURESTRINGS objectAtIndex:0] forKey:@"textureString"];
		[self setValue:[NSNumber numberWithBool:NO] forKey:@"invertTexture"];
		[self setValue:[DEFAULTFONTS objectAtIndex:0] forKey:@"textureFont"];
		[self setValue:[NSColor colorWithCalibratedRed:31.0/255.0 green:34.0/255.0 blue:36.0/255.0 alpha:1.0] forKey:@"backgroundColour"];
		[self setValue:[NSColor colorWithCalibratedRed:237.0/255.0 green:221.0/255.0 blue:193.0/255.0 alpha:1.0] forKey:@"textColour"];
		[self setValue:[NSNumber numberWithFloat:1.3] forKey:@"scale"];
		[self setValue:[NSNumber numberWithFloat:3.1] forKey:@"maximumScale"];
		[self setValue:[NSNumber numberWithFloat:15.0] forKey:@"fontSize"];
		[self setValue:[NSNumber numberWithInt:1] forKey:@"imageSource"];
		[self setValue:[NSNumber numberWithBool:YES] forKey:@"reflect"];
		[self setValue:[NSNumber numberWithInt:0] forKey:@"backgroundType"];
		[self setValue:[NSNumber numberWithFloat: 1.0] forKey: @"backgroundSaturation"];
		[self setValue:[NSNumber numberWithFloat: 1.0] forKey: @"backgroundContrast"];
		[self setValue:[NSNumber numberWithInt: 4] forKey:@"backgroundEffect"];
		[self setValue:[NSNumber numberWithFloat: 0.1] forKey: @"backgroundBlur"];
		[self setValue:[NSNumber numberWithFloat:1.0] forKey: @"gamma"];
		[self setValue:[NSNumber numberWithBool:NO] forKey: @"rotateTexture"];		
    }
    return self;
}


- (void) dealloc {
	[filmPath dealloc];
	[textureString dealloc];
	[textureFont dealloc];
	[backgroundColour dealloc];
	[textColour dealloc];
	[recordingPath dealloc];

	[super dealloc];
}




- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

/*
 - (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}
*/ 

-(void) awakeFromNib {
	// observe value changes
	NSEnumerator * myEnumerator = [DATAKEYS objectEnumerator];
	NSString * s;
	while ( s = [myEnumerator nextObject] ) {
		[self addObserver:self forKeyPath:s options:(NSKeyValueObservingOptionNew) context:nil];
		[self setPatchValueFromPreference:s];	
	}
	
	// register for drag and drop
	[filmPathComboBox registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType ,nil]];
}


#pragma mark READ AND WRITE

- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	NSEnumerator * keyEnumerator = [DATAKEYS objectEnumerator];
	NSString * s;
	id theObject;
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:[DATAKEYS count]];
	while (s = [keyEnumerator nextObject]) {
		theObject = [self valueForKey:s];
		if ([theObject isKindOfClass:[NSColor class]]) { // Archive NSColor objects
			theObject = [NSArchiver archivedDataWithRootObject:theObject];
		}
		[dict setObject:theObject forKey:s];
	}
	BOOL result = [dict writeToURL:absoluteURL atomically:NO];
	return result;
}


- (NSDictionary *)fileAttributesToWriteToFile:(NSString *)fullDocumentPath ofType:(NSString *)documentTypeName saveOperation:(NSSaveOperationType)saveOperationType
{
	NSMutableDictionary *myDict= [NSMutableDictionary dictionaryWithDictionary:[super fileAttributesToWriteToFile:fullDocumentPath ofType:documentTypeName saveOperation:saveOperationType]];
	
	[myDict setObject:[NSNumber numberWithLong:'esAP'] forKey:NSFileHFSCreatorCode];
	[myDict setObject:[NSNumber numberWithLong:'esAP'] forKey:NSFileHFSTypeCode];
	
	return myDict;
}


- (BOOL)readFromURL:(NSURL *)aURL ofType:(NSString *)docType error:(NSError **)outError  {
	if ([docType isEqualToString:ASCIIPROJEKTORFILETYPE]) {
		// we've got our own file, so parse it
		NSDictionary * dict = [NSDictionary dictionaryWithContentsOfURL:aURL];
		if (!dict) return NO;
		NSEnumerator * keyEnumerator = [DATAKEYS objectEnumerator];
		NSString * s;
		id obj;
		while (s = [keyEnumerator nextObject]) {
			obj = [dict objectForKey:s];
			if (obj) {
				if ([obj isKindOfClass: [NSData class]]) { // unarchive NSColor objects
					obj = [NSUnarchiver unarchiveObjectWithData: obj];
				}
				[self setValue:obj forKey:s];
			}
		}
		[self updateChangeCount:NSChangeCleared];
		return YES;
	}
	else if ([docType isEqualToString:FILMFILETYPE]) {
		// a film file was dropped, try to open it
		if (![aURL isFileURL]) return NO;
		// NSLog([NSString stringWithFormat:@"%i" , [QTMovie canInitWithURL:aURL]]);
		[self setValue:[aURL path] forKey:@"filmPath"];
		[self updateChangeCount:NSChangeReadOtherContents];
		return YES;
	}
	return NO;
}


#pragma mark VARIABLES

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self setPatchValueFromPreference:keyPath];
	[self updateChangeCount: NSChangeDone];
	
	// make sure ComboBox lists get updated
	if ([keyPath isEqualToString:@"filmPath"]) {
		[self updateDefaultsForKey:@"filmPath" withDefaultsArrayKey:PATHARRAYKEY defaultArray:DEFAULTFILMPATHS];
		[self setValue:[NSNumber numberWithInt:1] forKey:@"filmSource"]; // switch to film mode
	}
	if ([keyPath isEqualToString:@"filmSource"]) {
		int newSource = [[self valueForKey:@"filmSource"] intValue];
		if (newSource == 0) { // camera
			 [self updateScaleForSize:NSMakeSize(640.0, 480.0)]; // assume this size for camera
		}
		else if (newSource == 1 ) {
			NSError * theErr;
			QTMovie * theMovie = [QTMovie movieWithFile:[self valueForKey:@"filmPath"] error:&theErr];
			NSSize movieSize = [[theMovie attributeForKey:QTMovieNaturalSizeAttribute] sizeValue];
			[self updateScaleForSize:movieSize];			
		}
	}
	else if ([keyPath isEqualToString:@"textureString"]) {
		[self updateDefaultsForKey:@"textureString" withDefaultsArrayKey:TEXTURESTRINGARRAYKEY defaultArray:DEFAULTTEXTURESTRINGS];
	}
	else if ([keyPath isEqualToString:@"textureFont"]) {
		[self updateDefaultsForKey:@"textureFont" withDefaultsArrayKey:FONTARRAYKEY defaultArray:DEFAULTFONTS];
	}
}


- (void) updateScaleForSize:(NSSize) size {
/*
 float newMaximumScale = 2047.0 / MAX(size.width, size.height);
	NSNumber * newMaximumScaleNumber = [NSNumber numberWithFloat: newMaximumScale];
	// [self setValue:newMaximumScaleNumber forKey:@"maximumScale"];
	if (scale > newMaximumScale) {
		// [self setValue:newMaximumScaleNumber forKey:@"scale"];
	}			
 */
}




- (void) updateDefaultsForKey:(NSString*) valueKey withDefaultsArrayKey:(NSString *) defaultsKey defaultArray: (NSArray*) defaultArray {
	NSString * newValue = [self valueForKey:valueKey];
	if (![defaultArray containsObject: newValue]) {
		NSArray * a = [[NSUserDefaults standardUserDefaults] objectForKey:defaultsKey];
		if (a) {
			NSMutableArray * b = [[a mutableCopy] autorelease];
			[b removeObject:newValue];
			[b insertObject:newValue atIndex:0];
			if ([b count] > 10) {
				[b removeLastObject];
			}
			a = b;
		}
		else {
			a = [NSArray arrayWithObject:newValue];
		}
		[[NSUserDefaults standardUserDefaults] setObject:a forKey:defaultsKey];
	}	
}


- (void) setPatchValueFromPreference:(NSString*) preferenceKey {
	id myObject = [self valueForKey:preferenceKey];
	// Un-archive colours
	if ([myObject isKindOfClass: [NSData class]]) {
		myObject = [NSUnarchiver unarchiveObjectWithData: myObject];
	}
	[myPatchController setValue:myObject forInputKey:preferenceKey];	
}






#pragma mark DELEGATE Methods

- (BOOL)windowShouldZoom:(NSWindow *)sender toFrame:(NSRect)newFrame
{
	[self startFullScreen];
	return NO;
}

- (BOOL)control:(NSControl *)control isValidObject:(id)object {
	return YES;
}





#pragma mark FULLSCREEN

- (void) startFullScreen  {
	
	// Get the screen information.
    NSScreen* mainScreen = [NSScreen mainScreen];
    NSDictionary* screenInfo = [mainScreen deviceDescription];
    NSNumber* screenID = [screenInfo objectForKey:@"NSScreenNumber"];
	
    // Capture the screen.
    CGDirectDisplayID displayID = (CGDirectDisplayID)[screenID longValue];
    CGDisplayErr err =  CGDisplayCapture(displayID);
    if (err == CGDisplayNoErr)
    {
        // Create the full-screen window if it doesn’t already  exist.
        if (!mScreenWindow)
        {
            // Create the full-screen window.
            NSRect winRect = [mainScreen frame];
            mScreenWindow = [[ESFullScreenWindow alloc] initWithContentRect:winRect
														styleMask:NSBorderlessWindowMask
														  backing:NSBackingStoreBuffered
															defer:NO
														   screen:[NSScreen mainScreen]];
			
            // Establish the window attributes.
            [mScreenWindow setReleasedWhenClosed:NO];
            [mScreenWindow setDisplaysWhenScreenProfileChanges:YES];
        }
        [mScreenWindow setDelegate:self];
		[mScreenWindow setValue:self forKey:@"owner"];
			
        [mScreenWindow setContentView:myPatchController];
		 [myPatchController setEventForwardingMask:0];
        [myPatchController setNeedsDisplay:YES];
		
        // Make the screen window the current document window.
		[displayWindow retain]; // make sure we don't lose the window when it's not held by the WindowController
        NSWindowController* winController = [[self windowControllers] objectAtIndex:0];
        [winController setWindow:mScreenWindow];
		
        // The window has to be above the level of the shield window.
        int32_t     shieldLevel = CGShieldingWindowLevel();
        [mScreenWindow setLevel:shieldLevel];
		
        // Show the window.
        [mScreenWindow makeKeyAndOrderFront:nil];
		[mScreenWindow makeFirstResponder:mScreenWindow];
		[NSCursor hide];
		// NSLog (@"%i", [mScreenWindow ignoresMouseEvents]);
		// NSLog(@"%i", [mScreenWindow isKeyWindow]);
		// NSLog([[mScreenWindow firstResponder] description]);
		// NSLog(@"%i", [myPatchController eventForwardingMask]);	
	}
}	


- (void) stopFullScreen
{
	// NSLog(@"stopFullScreen");
	[mScreenWindow orderOut:self];
	NSWindowController* winController = [[self windowControllers] objectAtIndex:0];
	[winController setWindow:displayWindow];
	[displayWindow setContentView:myPatchController];
	[NSCursor unhide];
	[displayWindow release]; // undo our extra retain on the window now that it's held by the WindowController again
	
	// Release the display(s)
	if (CGDisplayRelease( kCGDirectMainDisplay ) != kCGErrorSuccess) {
		NSLog( @"Couldn't release the display(s)!" );
		// Note: if you display an error dialog here, make sure you set
		// its window level to the same one as the shield window level,
		// or the user won't see anything.
	}
}


@end
