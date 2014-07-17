//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import "OBAssetLibrary.h"

@class OBCollection;


typedef enum {
	OBAssetLibraryTypeAll,
	OBAssetLibraryTypePhoto,
	OBAssetLibraryTypeVideo
} OBAssetLibraryType;

@interface OBALAssetLibrary : NSObject <OBAssetLibrary>

- (instancetype)initWithType:(OBAssetLibraryType)type;

@end