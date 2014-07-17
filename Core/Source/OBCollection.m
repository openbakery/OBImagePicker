//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBCollection.h"


@implementation OBCollection {
	NSString *_name;
	UIImage *_image;
	NSInteger _numberOfAssets;
}

- (instancetype)initWithName:(NSString *)name image:(UIImage *)image numberOfAssets:(NSInteger)numberOfAssets {
	self = [super init];
	if (self) {
		_name = name;
		_image = image;
		_numberOfAssets = numberOfAssets;
	}
	return self;
}


- (NSString *)name {
	return _name;
}

- (UIImage *)image {
	return _image;
}

- (NSInteger)numberOfAssets {
	return _numberOfAssets;
}


@end