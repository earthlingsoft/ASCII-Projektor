//
//  MyDocument.m
//  ASCII Projektor 2b
//
//  Created by Sven on 19.08.2007.
//  Copyright earthlingsoft 2007-2015. All rights reserved.
//

#import "MyDocument.h"
@import AVFoundation;
#import "esDroppable.h"

#define UDC [NSUserDefaultsController sharedUserDefaultsController]

@implementation MyDocument


#pragma mark SETUP

- (id)init {
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



- (NSString *) windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}



- (void) awakeFromNib {
	// set up QCView
	[qcView loadCompositionFromFile:[[NSBundle mainBundle] pathForResource:@"TileFilter" ofType:@"qtz"]];
	[qcView startRendering];
	
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



#pragma mark READ AND WRITE / transient documents

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


- (NSDictionary *)fileAttributesToWriteToFile:(NSString *)fullDocumentPath ofType:(NSString *)documentTypeName saveOperation:(NSSaveOperationType)saveOperationType {
	NSMutableDictionary *myDict= [NSMutableDictionary dictionaryWithDictionary:[super fileAttributesToWriteToFile:fullDocumentPath ofType:documentTypeName saveOperation:saveOperationType]];
	
	[myDict setObject:[NSNumber numberWithLong:'esAP'] forKey:NSFileHFSCreatorCode];
	[myDict setObject:[NSNumber numberWithLong:'esAP'] forKey:NSFileHFSTypeCode];
	
	return myDict;
}


- (BOOL)readFromURL:(NSURL *)URL ofType:(NSString *)docType error:(NSError **)outError  {
	if (![URL isFileURL]) {
		return NO;
	}
	NSString * path = [URL path];
	
	if ([path fileAtPathConformsToUTI:ASCIIPROJEKTION_UTI]) {
		// we've got our own file, so parse it
		NSDictionary * dict = [NSDictionary dictionaryWithContentsOfURL:URL];
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
	else if (path.pathHasVideo) {
		// a film file was dropped, try to open it
		[self setValue:path forKey:@"filmPath"];
		[self updateChangeCount:NSChangeReadOtherContents];
		return YES;
	}
	return NO;
}



/*
	A transient document is an untitled document that was opened automatically. If a real document is opened before the transient document is edited, the real document should replace the transient. If a transient document is edited, it ceases to be transient.
*/
- (BOOL)isTransient {
    return transient;
}


- (void)setTransient:(BOOL)flag {
    transient = flag;
}



/*
	We can't replace transient document that have sheets on them.
*/
- (BOOL)isTransientAndCanBeReplaced {
    if (![self isTransient]) return NO;
    for (NSWindowController *controller in [self windowControllers]) if ([[controller window] attachedSheet]) return NO;
    return YES;
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
			AVAsset * asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:[self valueForKey:@"filmPath"]]];
			NSArray * videoTracks = [asset tracksWithMediaCharacteristic:AVMediaCharacteristicVisual];
			if (videoTracks.count > 0) {
				AVAssetTrack * videoTrack = videoTracks[0];
				NSSize movieSize = NSSizeFromCGSize(videoTrack.naturalSize);
				[self updateScaleForSize:movieSize];
			}
		}
	}
	else if ([keyPath isEqualToString:@"textureString"]) {
		[self updateDefaultsForKey:@"textureString" withDefaultsArrayKey:TEXTURESTRINGARRAYKEY defaultArray:DEFAULTTEXTURESTRINGS];
	}
	else if ([keyPath isEqualToString:@"textureFont"]) {
		[self updateDefaultsForKey:@"textureFont" withDefaultsArrayKey:FONTARRAYKEY defaultArray:DEFAULTFONTS];
	}
}

- (void) updateScaleForSize:(NSSize)size {
	
}


- (void) updateDefaultsForKey:(NSString*) valueKey withDefaultsArrayKey:(NSString *) defaultsKey defaultArray: (NSArray*) defaultArray {
	NSString * newValue = [self valueForKey:valueKey];
	if (![defaultArray containsObject: newValue]) {
		NSArray * a = [[NSUserDefaults standardUserDefaults] objectForKey:defaultsKey];
		if (a) {
			NSMutableArray * b = [a mutableCopy];
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
	[qcView setValue:myObject forInputKey:preferenceKey];
}



#pragma mark DELEGATE Methods

- (BOOL)control:(NSControl *)control isValidObject:(id)object {
	return YES;
}



@end
