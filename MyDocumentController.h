//
//  MyDocumentController.h
//  ASCII Projektor
//
//  Created by Sven on 23.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyDocument.h"

@interface MyDocumentController : NSDocumentController {
	NSLock *transientDocumentLock;
	NSLock *displayDocumentLock;
}

- (MyDocument *)transientDocumentToReplace;
- (void)displayDocument:(NSDocument *)doc;
- (void)replaceTransientDocument:(NSArray *)documents;


@end
