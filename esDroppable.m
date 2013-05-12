//
//  esDroppableQCView.m
//  ASCII Projektor 2b
//
//  Created by  Sven on 22.08.07.
//  Copyright 2007 earthlingsoft. All rights reserved.
//

#import "esDroppable.h"

@implementation esDroppableQCView

-(void) awakeFromNib {
	[self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
}


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
		NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		NSString * path = [files objectAtIndex:0];
		if ([path APWillAcceptPath]) {
			return NSDragOperationLink;
		}
    }
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard * pboard = [sender draggingPasteboard];
	
	if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		NSString * path = [files objectAtIndex:0];
		[document setValue:path forKey:@"filmPath"];
    }
    return YES;
}


@end




@implementation esDroppableComboBox
-(void) awakeFromNib {
	[self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
		NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		NSString * path = [files objectAtIndex:0];
		if ([path APWillAcceptPath]) {
			return NSDragOperationLink;
		}
    }
    return NSDragOperationNone;
}



- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	NSPasteboard * pb = [sender draggingPasteboard];
	NSArray *array = [[pb stringForType:NSFilenamesPboardType] propertyList];
	if (!array) return NO;
	
	NSString * filePath = [array objectAtIndex:0];
	
	[(NSObject*)[self delegate] setValue:filePath forKey:@"filmPath"];
	
	return YES;
}



@end


@implementation NSString (esUTICheck)

// Stolen and adapted/simplified from example in Apple QA 1518
// http://developer.apple.com/qa/qa2007/qa1518.html
- (BOOL) fileAtPathConformsToUTI:(NSString *) UTI {
	BOOL doesConform = NO;
    FSRef fileRef;
    Boolean isDirectory;
	
    if (FSPathMakeRef((const UInt8 *)[self fileSystemRepresentation], &fileRef, &isDirectory) == noErr)
    {
        // get the content type (UTI) of this file
        CFDictionaryRef values = NULL;
        CFStringRef attrs[1] = { kLSItemContentType };
        CFArrayRef attrNames = CFArrayCreate(NULL, (const void **)attrs, 1, NULL);
		
        if (LSCopyItemAttributes(&fileRef, kLSRolesViewer, attrNames, &values) == noErr)
        {
            if (values != NULL) {
                CFTypeRef theUTI = CFDictionaryGetValue(values, kLSItemContentType);
                if (theUTI != NULL) {
					if (UTTypeConformsTo(theUTI, (__bridge CFStringRef)UTI)) {
						doesConform = YES;
					}
				}
				CFRelease(values);
			}
		}
		CFRelease(attrNames);
	}
	return doesConform;
}



- (BOOL) APWillAcceptPath {
	if ([self fileAtPathConformsToUTI:@"public.movie"]) {
		if ([QTMovie canInitWithFile:self]) {
			NSError * theErr;
			QTMovie * theMovie = [QTMovie movieWithFile:self error:&theErr];
			if (theMovie) {
				//  NSNumber * hasDuration = [theMovie attributeForKey:QTMovieHasDurationAttribute]; // DOES NOT WORK!
				 // NSNumber * isLinear = [theMovie attributeForKey:QTMovieIsLinearAttribute]; // DOES NOT WORK!
				NSNumber * hasVideo = [theMovie attributeForKey:QTMovieHasVideoAttribute]; // DOESN'T REALLY HELP HERE; JUST PLAYING
				if([hasVideo boolValue]) {
					return YES;
				}
			}
		}
	}	
	return NO;
}



@end

