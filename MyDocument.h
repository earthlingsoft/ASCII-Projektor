//
//  MyDocument.h
//  ASCII Projektor 2b
//
//  Created by  Sven on 19.08.07.
//  Copyright earthlingsoft 2007 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <QuartzComposer/QCView.h>
#import <QTKit/QTMovie.h>
#import "ComboBoxDataSources.h"

#define ASCIIPROJEKTORFILETYPE @"ASCII Projektion"
#define FILMFILETYPE @"Film"

#define DATAKEYS [NSArray arrayWithObjects:@"textureString", @"invertTexture", @"textureFont", @"backgroundColour", @"textColour", @"scale",  @"filmPath", @"fontSize", @"filmSource", @"reflect", @"backgroundEffect", @"backgroundContrast", @"backgroundSaturation", @"backgroundType", @"backgroundBlur", @"gamma", @"rotateTexture",  nil]


@interface MyDocument : NSDocument <NSWindowDelegate>
{
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
	
	IBOutlet QCView * myPatchController; // unfortunate name!!
	IBOutlet NSComboBox * filmPathComboBox;
}

- (void) setPatchValueFromPreference:(NSString*) preferenceKey;
- (void) updateDefaultsForKey:(NSString*) valueKey withDefaultsArrayKey:(NSString *) defaultsKey defaultArray: (NSArray*) defaultArray;
- (void) updateScaleForSize:(NSSize) size;


@end
