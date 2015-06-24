//
//  esDroppableQCView.m
//  ASCII Projektor 2b
//
//  Created by Sven on 22.08.2007.
//  Copyright 2007-2015 earthlingsoft. All rights reserved.
//

@import ApplicationServices;
@import AVFoundation;
#import "esDroppable.h"


@implementation esDroppableQCView

-(void) awakeFromNib {
	[self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
}


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
	NSString * path = [self.class pathForDraggingInfo:sender];
	if (path.pathHasVideo) {
		return NSDragOperationLink;
	}
    return NSDragOperationNone;
}


- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	NSString * path = [self.class pathForDraggingInfo:sender];
	if (path != nil) {
		[document setValue:path forKey:@"filmPath"];
		return YES;
	}
	return NO;
}


+ (NSString *) pathForDraggingInfo:(id<NSDraggingInfo>)draggingInfo {
	NSPasteboard * pboard = [draggingInfo draggingPasteboard];

	if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
		NSArray * files = [pboard propertyListForType:NSFilenamesPboardType];
		if (files.count > 0) {
			return [files objectAtIndex:0];
		}
	}
	return nil;
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
		if (path.pathHasVideo) {
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

- (BOOL) pathHasVideo {
	if ([self fileAtPathConformsToUTI:@"public.movie"]) {
		AVAsset * asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:self]];
		if (asset.playable && [asset tracksWithMediaCharacteristic:AVMediaCharacteristicVisual]) {
			return YES;
		}
	}
	return NO;
}


// Stolen and adapted/simplified from example in Apple QA 1518
// http://developer.apple.com/qa/qa2007/qa1518.html and newer deprecation notes.
- (BOOL) fileAtPathConformsToUTI:(NSString *) UTI {
	NSError * error;
	NSDictionary * resourceValues = [[NSURL fileURLWithPath:self] resourceValuesForKeys:@[NSURLTypeIdentifierKey] error:&error];
	NSString * fileUTI = resourceValues[NSURLTypeIdentifierKey];
	if (fileUTI != nil) {
		if (UTTypeConformsTo((__bridge CFStringRef)fileUTI, (__bridge CFStringRef)UTI)) {
			return YES;
		}
	}
	return NO;
}

@end

