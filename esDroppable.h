//
//  esDroppableQCView.h
//  ASCII Projektor 2b
//
//  Created by Sven on 22.08.2007.
//  Copyright 2007-2015 earthlingsoft. All rights reserved.
//

@import Cocoa;
@import Quartz;
#import "MyDocument.h"


@interface esDroppableQCView : QCView {
	IBOutlet MyDocument * document;
}
@end


@interface esDroppableComboBox : NSComboBox {	
}
@end


@interface NSString (esUTICheck) 
@property (readonly, nonatomic) BOOL pathHasVideo;
@end