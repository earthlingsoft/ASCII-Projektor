//
//  MyDocumentController.h
//  ASCII Projektor
//
//  Created by Sven on 23.08.2007.
//  Copyright 2007-2015 earthlingsoft. All rights reserved.
//

@import Cocoa;
#import "MyDocument.h"


@interface MyDocumentController : NSDocumentController {
	NSLock *transientDocumentLock;
	NSLock *displayDocumentLock;
}

- (MyDocument *)transientDocumentToReplace;
- (void)displayDocument:(NSDocument *)doc;
- (void)replaceTransientDocument:(NSArray *)documents;

@end
