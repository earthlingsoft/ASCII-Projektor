//
//  ComboBoxDataSources.m
//  ASCII Projektor 2b
//
//  Created by  Sven on 19.08.2007.
//  Copyright 2007-2015 earthlingsoft. All rights reserved.
//

#import "ComboBoxDataSources.h"


@implementation FilmPathComboBoxDataSource
- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	NSArray * a = [[NSUserDefaults standardUserDefaults] objectForKey:PATHARRAYKEY];
	if (a) {
		return [a count] + [DEFAULTFILMPATHS count];
	}
	else {
		return [DEFAULTFILMPATHS count];
	}
}


- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	NSArray * a = [[NSUserDefaults standardUserDefaults] objectForKey:PATHARRAYKEY];
	NSArray * myItems;
	if (a) {
		myItems = [a arrayByAddingObjectsFromArray:DEFAULTFILMPATHS];
	}
	else {
		myItems = DEFAULTFILMPATHS;
	}
	return [myItems objectAtIndex:index];
}
@end




@implementation TextureStringComboBoxDataSource
- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	NSArray * a = [[NSUserDefaults standardUserDefaults] objectForKey:TEXTURESTRINGARRAYKEY];
	if (a) {
		return [a count] + [DEFAULTTEXTURESTRINGS count];
	}
	else {
		return [DEFAULTTEXTURESTRINGS count];
	}
}


- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	NSArray * a = [[NSUserDefaults standardUserDefaults] objectForKey:TEXTURESTRINGARRAYKEY];
	NSArray * myItems;
	if (a) {
		myItems = [a arrayByAddingObjectsFromArray:DEFAULTTEXTURESTRINGS];
	}
	else {
		myItems = DEFAULTTEXTURESTRINGS;
	}
	return [myItems objectAtIndex:index];
}
@end




@implementation FontComboBoxDataSource
- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	NSArray * a = [[NSUserDefaults standardUserDefaults] objectForKey:FONTARRAYKEY];
	if (a) {
		return [a count] + [DEFAULTFONTS count];
	}
	else {
		return [DEFAULTFONTS count];
	}
}


- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	NSArray * a = [[NSUserDefaults standardUserDefaults] objectForKey:FONTARRAYKEY];
	NSArray * myItems;
	if (a) {
		myItems = [a arrayByAddingObjectsFromArray:DEFAULTFONTS];
	}
	else {
		myItems = DEFAULTFONTS;
	}
	return [myItems objectAtIndex:index];
}
@end