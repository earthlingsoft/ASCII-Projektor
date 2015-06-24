//
//  AppDelegate.h
//  ASCII Projektor 2b
//
//  Created by Sven on 19.08.2007.
//  Copyright 2007-2015 earthlingsoft. All rights reserved.
//

@import Cocoa;


@interface AppDelegate : NSObject {
}

- (IBAction) copyASCIIMoviePlayerPath:(id) sender;
- (IBAction) showWebpage:(id)sender;
- (IBAction) showWebsite:(id)sender;
- (IBAction) showReadme:(id)sender;
- (IBAction) showVersionHistory:(id)sender;
- (IBAction) sendEMail:(id)sender;
- (IBAction) pay:(id)sender;
- (NSString*) myVersionString;

@end
