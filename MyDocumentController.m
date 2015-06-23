//
//  MyDocumentController.m
//  ASCII Projektor
//
//  Created by Sven on 23.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import "MyDocumentController.h"


/* Mostly nicked from TextEdit and slightly adapted */

@implementation MyDocumentController


- (void)awakeFromNib {
    transientDocumentLock = [[NSLock alloc] init];
    displayDocumentLock = [[NSLock alloc] init];
}



/*
	This method is overridden in order to support transient documents, i.e. the automatic closing of an automatically created untitled document, when a real document is opened.
*/
- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError **)outError {
    MyDocument *doc = [super openUntitledDocumentAndDisplay:displayDocument error:outError];
    
    if (!doc) return nil;
    
    if ([[self documents] count] == 1) {
        // Determine whether this document might be a transient one
        // Check if there is a current AppleEvent. If there is, check whether it is an open or reopen event. In that case, the document being created is transient.
        NSAppleEventDescriptor *evtDesc = [[NSAppleEventManager sharedAppleEventManager] currentAppleEvent];
        AEEventID evtID = [evtDesc eventID];
        
        if (evtDesc && (evtID == kAEReopenApplication || evtID == kAEOpenApplication) && [evtDesc eventClass] == kCoreEventClass) {
            [doc setTransient:YES];
        }
    }
    
    return doc;
}



- (MyDocument *)transientDocumentToReplace {
    NSArray *documents = [self documents];
    MyDocument *transientDoc = nil;
    return ([documents count] == 1 && [(transientDoc = [documents objectAtIndex:0]) isTransientAndCanBeReplaced]) ? transientDoc : nil;
}



- (void)displayDocument:(NSDocument *)doc {
    // Documents must be displayed on the main thread.
    if ([NSThread isMainThread]) {
        [doc makeWindowControllers];
        [doc showWindows];
    }
	else {
        [self performSelectorOnMainThread:_cmd withObject:doc waitUntilDone:YES];
    }
}



- (void)replaceTransientDocument:(NSArray *)documents {
    // Transient document must be replaced on the main thread, since it may undergo automatic display on the main thread.
    if ([NSThread isMainThread]) {
        NSDocument *transientDoc = [documents objectAtIndex:0], *doc = [documents objectAtIndex:1];
        NSArray *controllersToTransfer = [[transientDoc windowControllers] copy];
        NSEnumerator *controllerEnum = [controllersToTransfer objectEnumerator];
        NSWindowController *controller;
        
        while (controller = [controllerEnum nextObject]) {
            [doc addWindowController:controller];
            [transientDoc removeWindowController:controller];
        }
        [transientDoc close];
    }
	else {
        [self performSelectorOnMainThread:_cmd withObject:documents waitUntilDone:YES];
    }
}



/*
	When a document is opened, check to see whether there is a document that is already open, and whether it is transient. If so, transfer the document's window controllers and close the transient document. When +[Document canConcurrentlyReadDocumentsOfType:] return YES, this method may be invoked on multiple threads. Ensure that only one document replaces the transient document. The transient document must be replaced before any other documents are displayed for window cascading to work correctly. To guarantee this, defer all display operations until the transient document has been replaced.
*/
- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError {
	NSMutableArray * deferredDocuments;
	MyDocument *transientDoc = nil;
    
    [transientDocumentLock lock];
    transientDoc = [self transientDocumentToReplace];
    if (transientDoc) {
        // Once this document has claimed the transient document, cause -transientDocumentToReplace to return nil for all other documents.
        [transientDoc setTransient:NO];
        deferredDocuments = [[NSMutableArray alloc] init];
    }
    [transientDocumentLock unlock];
    
    // Don't make NSDocumentController display the NSDocument it creates. Instead, do it later manually to ensure that the transient document has been replaced first.
    MyDocument * doc = [super openDocumentWithContentsOfURL:absoluteURL display:NO error:outError];
    
    if (transientDoc) {
        if (doc) {
            [self replaceTransientDocument:[NSArray arrayWithObjects:transientDoc, doc, nil]];
            if (displayDocument) [self displayDocument:doc];
        }
        
        // Now that the transient document has been replaced, display all deferred documents.
        [displayDocumentLock lock];
        NSArray *documentsToDisplay = deferredDocuments;
        deferredDocuments = nil;
        [displayDocumentLock unlock];
        for (NSDocument *document in documentsToDisplay) [self displayDocument:document];
    }
	else if (doc && displayDocument) {
        [displayDocumentLock lock];
        if (deferredDocuments) {
            // Defer displaying this document, because the transient document has not yet been replaced.
            [deferredDocuments addObject:doc];
            [displayDocumentLock unlock];
        }
		else {
            // The transient document has been replaced, so display the document immediately.
            [displayDocumentLock unlock];
            [self displayDocument:doc];
        }
    }
    
    return doc;
}



/*
	When a second document is added, the first document's transient status is cleared. This happens when the user selects "New" when a transient document already exists.
*/
- (void)addDocument:(NSDocument *)newDoc {
    MyDocument *firstDoc;
    NSArray *documents = [self documents];
    if ([documents count] == 1 && (firstDoc = [documents objectAtIndex:0]) && [firstDoc isTransient]) {
        [firstDoc setTransient:NO];
    }
    [super addDocument:newDoc];
}

@end
