//
//  MyDocument.h
//  ASCII Projektor 2b
//
//  Created by Sven on 19.08.2007.
//  Copyright earthlingsoft 2007-2015. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import Quartz;
#import "ComboBoxDataSources.h"

#define ASCIIPROJEKTION_UTI @"net.earthlingsoft.asciiprojektor2.document"

#define DATAKEYS [NSArray arrayWithObjects:@"textureString", @"invertTexture", @"textureFont", @"backgroundColour", @"textColour", @"scale",  @"filmPath", @"fontSize", @"filmSource", @"reflect", @"backgroundEffect", @"backgroundContrast", @"backgroundSaturation", @"backgroundType", @"backgroundBlur", @"gamma", @"rotateTexture",  nil]


@interface MyDocument : NSDocument <NSWindowDelegate> {
	int filmSource;
	NSString * filmPath;
	NSString * textureString;
	BOOL invertTexture;
	NSString * textureFont;
	NSColor * backgroundColour;
	NSColor * textColour;
	float scale;
	float maximumScale;
	float fontSize;
	int imageSource;
	BOOL reflect;
	int backgroundType;
	float backgroundSaturation;
	float backgroundContrast;
	int backgroundEffect;
	float backgroundBlur;
	float gamma;
	BOOL rotateTexture;
	
	IBOutlet QCView * qcView;
	IBOutlet NSComboBox * filmPathComboBox;

    BOOL transient; // Untitled document automatically opened and never modified
}

- (void) setPatchValueFromPreference:(NSString*) preferenceKey;
- (void) updateDefaultsForKey:(NSString*) valueKey withDefaultsArrayKey:(NSString *) defaultsKey defaultArray: (NSArray*) defaultArray;
- (void) updateScaleForSize:(NSSize) size;


/* Transient documents */
- (BOOL)isTransient;
- (void)setTransient:(BOOL)flag;
- (BOOL)isTransientAndCanBeReplaced;


@end
