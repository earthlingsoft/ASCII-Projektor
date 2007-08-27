//
//  esDroppableQCView.h
//  ASCII Projektor 2b
//
//  Created by  Sven on 22.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzComposer/QCView.h>
#import <QTKit/QTKit.h>
#import "ApplicationServices/ApplicationServices.h"
#import "MyDocument.h"


@interface esDroppableQCView : QCView {
	IBOutlet MyDocument * document;
}
@end


@interface esDroppableComboBox : NSComboBox {	
}
@end


@interface NSString (esUTICheck) 
- (BOOL) fileAtPathConformsToUTI:(NSString *) UTI;
- (BOOL) APWillAcceptPath;
@end