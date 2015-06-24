//
//  ComboBoxDataSources.h
//  ASCII Projektor 2b
//
//  Created by  Sven on 19.08.2007.
//  Copyright 2007-2015 earthlingsoft. All rights reserved.
//

@import Cocoa;


#define DEFAULTFILMPATHS [NSArray arrayWithObjects: @"/System/Library/Compositions/Rollercoaster.mov", nil]
#define PATHARRAYKEY @"filmPaths"
@interface FilmPathComboBoxDataSource : NSObject {
}
@end


#define DEFAULTTEXTURESTRINGS [NSArray arrayWithObjects: NSLocalizedString(@"textureString1", @"textureString1"), NSLocalizedString(@"textureString2", @"textureString2"), NSLocalizedString(@"textureString3", @"textureString3"), NSLocalizedString(@"textureString4", @"textureString4"), NSLocalizedString(@"textureString5", @"textureString5"), nil]
#define TEXTURESTRINGARRAYKEY @"textureStrings"
@interface TextureStringComboBoxDataSource : NSObject {
}
@end 


#define DEFAULTFONTS [NSArray arrayWithObjects: @"Monaco", @"Courier", @"Hiragino Mincho Pro", nil]
#define FONTARRAYKEY @"fonts"
@interface FontComboBoxDataSource : NSObject {
}
@end