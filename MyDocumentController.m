//
//  MyDocumentController.m
//  ASCII Projektor 2b
//
//  Created by  Sven on 23.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import "MyDocumentController.h"


/* Mostly nicked from TextEdit and slightly adapted */

@implementation MyDocumentController
- (NSDocument *)transientDocumentToReplace {
    NSArray *documents = [self documents];
    NSDocument *transientDoc = nil;
	int openDocuments = [documents count];
	if(openDocuments == 1) {
		NSDocument * theDoc = [documents objectAtIndex:0];
		if (![theDoc isDocumentEdited]) {
			return theDoc;
		}
	}
	return nil;
}

- (void)replaceTransientDocument:(NSDocument *)transientDoc withDocument:(NSDocument *)doc display:(BOOL)displayDocument {
    NSArray *controllersToTransfer = [[transientDoc windowControllers] copy];
    NSEnumerator *controllerEnum = [controllersToTransfer objectEnumerator];
    NSWindowController *controller;
    
    [controllersToTransfer makeObjectsPerformSelector:@selector(retain)];
    
    while (controller = [controllerEnum nextObject]) {
		[doc addWindowController:controller];
		[transientDoc removeWindowController:controller];
    }
    [transientDoc close];
    
    [controllersToTransfer makeObjectsPerformSelector:@selector(release)];
    [controllersToTransfer release];
    
    if (displayDocument) {
		[doc makeWindowControllers];
		[doc showWindows];
    }
}

/* When a document is opened, check to see whether there is a document that is already open, and whether it is transient. If so, transfer the document's window controllers and close the transient document. 
 */
- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError {
    NSDocument *transientDoc = [self transientDocumentToReplace];
	NSDocument *doc = nil;

	if (transientDoc) {
		[transientDoc setFileURL:absoluteURL];
		[transientDoc readFromURL:absoluteURL ofType:[[NSDocumentController sharedDocumentController] typeForContentsOfURL:absoluteURL error:outError] error:outError];
		doc = transientDoc;
	}
	if (!doc) { // do this if there is no document to replace OR if replacing failed
		doc = [super openDocumentWithContentsOfURL:absoluteURL display:(displayDocument && !transientDoc) error:outError];
    }
    if (!doc) return nil;
    
    //if (transientDoc != nil) [self replaceTransientDocument:transientDoc withDocument:doc display:YES];
    
    return doc;
}


@end
