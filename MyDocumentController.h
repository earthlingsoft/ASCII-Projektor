//
//  MyDocumentController.h
//  ASCII Projektor 2b
//
//  Created by  Sven on 23.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyDocumentController : NSDocumentController {

}

- (NSDocument *)transientDocumentToReplace;
- (void)replaceTransientDocument:(NSDocument *)transientDoc withDocument:(NSDocument *)doc display:(BOOL)displayDocument;


@end
