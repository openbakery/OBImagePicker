//
//
// Created by Rene Pirringer.
//
// 
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "OBALCollection.h"


@implementation OBALCollection {

	ALAssetsGroup *_assetsGroup;
}

- (instancetype)initWithALAssetsGroup:(ALAssetsGroup *)assetsGroup {
	self = [super init];
	if (self) {
		_assetsGroup = assetsGroup;
	}
	return self;
}


- (NSString *)name {

	return [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
}

- (UIImage *)image {
	return [UIImage imageWithCGImage:[_assetsGroup posterImage]];
}

- (NSInteger)numberOfAssets {
	return _assetsGroup.numberOfAssets;
}


- (ALAssetsGroup *)assetsGroups {
	return _assetsGroup;
}
@end