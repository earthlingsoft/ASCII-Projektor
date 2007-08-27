//
//  AppDelegate.m
//  ASCII Projektor 2b
//
//  Created by  Sven on 19.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate



+ (void) initialize {
	[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:[NSDictionary dictionaryWithObjectsAndKeys:
		@"/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/TransitionSection.bundle/Contents/Resources/intro.mov", @"retroFilmPath",
		[NSNumber numberWithInt:120], @"retroColumnCount",
		[NSArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:203.0/255.0 green:238.0/255.0 blue:173.0/255.0 alpha:0.0]], @"retroColour",
		[NSArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.90]], @"retroBackgroundColour",
		[NSNumber numberWithBool:NO], @"retroCloseTerminalWhenFinished", 
		nil]];	
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
}


- (IBAction) copyASCIIMoviePlayerPath:(id) sender {
	NSString * toolpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ASCIIMoviePlayer"];
	NSPasteboard * pb = [NSPasteboard generalPasteboard];
	[pb declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
	[pb setString:toolpath forType:NSStringPboardType];
	[pb setPropertyList:[NSArray arrayWithObject:toolpath] forType:NSFilenamesPboardType];
}

- (IBAction) showWebpage:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://earthlingsoft.net/ASCII%20Projektor/"]];
}

- (IBAction) showWebsite:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://earthlingsoft.net/"]];
}


- (IBAction) showReadme:(id)sender
{
	[[NSWorkspace sharedWorkspace] openFile:[[NSBundle mainBundle] pathForResource:@"Readme" ofType:@"rtf"]];
}

- (IBAction) showVersionHistory:(id)sender
{
	[[NSWorkspace sharedWorkspace] openFile:[[NSBundle mainBundle] pathForResource:@"Version History" ofType:@"rtf"]];
}

- (IBAction) sendEMail:(id)sender {
	NSString * theURL = [NSString stringWithFormat:@"mailto:earthlingsoft%%40earthlingsoft.net?subjectASCII%%20Projektor%%20%@", [self myVersionString]];
	NSURL * myURL = [NSURL URLWithString:theURL];
	[[NSWorkspace sharedWorkspace] openURL:myURL];
}

- (IBAction) pay:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"https://www.paypal.com/xclick/business=earthlingsoft%40earthlingsoft.net&item_name=ASCII%20Projektor&no_shipping=1&cn=Comments&tax=0&currency_code=EUR&amount=5.00"]];
}


#pragma mark UTILITY

- (NSString*) myVersionString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}



@end
