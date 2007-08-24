//
//  AppDelegate.m
//  ASCII Projektor 2b
//
//  Created by  Sven on 19.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate
- (IBAction) showWebpage:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://earthlingsoft.net/ASCII%20Projektor/"]];
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

/*
- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
	NSArray * documents = [NSApp orderedDocuments];
	NSError * err;
	NSURL * documentURL = [NSURL fileURLWithPath:filename];
	NSString * documentType = [[NSDocumentController sharedDocumentController] typeForContentsOfURL:documentURL error:&err];
	
	if ([documents count] != 0) {
		// there is an open document ...
		NSDocument * firstDocument = [documents objectAtIndex:0];
		if (![firstDocument isDocumentEdited]) {
			//... which is unedited
			// thus replace it with the newly opened one
			if (!documentType) return NO;						
			else return [firstDocument revertToContentsOfURL:documentURL ofType:documentType error:&err];
		}
	}
	// otherwise just open normally
	return ([[MyDocument alloc] initWithContentsOfURL:documentURL ofType:documentType error:&err] != nil);
}
*/



#pragma mark UTILITY

- (NSString*) myVersionString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}



@end
