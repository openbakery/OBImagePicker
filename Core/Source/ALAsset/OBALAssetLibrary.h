//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import "OBAssetLibrary.h"

@class OBCollection;


NS_ENUM(NSInteger, OBAssetLibraryType) {
	OBAssetLibraryTypeAll,
	OBAssetLibraryTypePhoto,
	OBAssetLibraryTypeVideo
};

@interface OBALAssetLibrary : NSObject <OBAssetLibrary>

- (instancetype)initWithType:(enum OBAssetLibraryType)type;

@end