//
//  AppDelegate.h
//  ASCII Projektor 2b
//
//  Created by  Sven on 19.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyDocument.h"

@interface AppDelegate : NSObject {
}
- (IBAction) showWebpage:(id)sender;
- (IBAction) showReadme:(id)sender;
- (IBAction) showVersionHistory:(id)sender;
- (IBAction) sendEMail:(id)sender;
- (IBAction) pay:(id)sender;
- (NSString*) myVersionString;

@end
