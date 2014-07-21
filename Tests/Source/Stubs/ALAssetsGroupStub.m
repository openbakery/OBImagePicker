//
//
// Created by Rene Pirringer.
//
// 
//


#import "ALAssetsGroupStub.h"


@implementation ALAssetsGroupStub {

}



- (id)valueForProperty:(NSString *)property {

	if (property == ALAssetsGroupPropertyName) {
		return self.propertyName;
	}
	if (property == ALAssetsGroupPropertyType) {
		return self.propertyType;
	}
	if (property == ALAssetsGroupPropertyPersistentID) {
		return self.propertyPersistentID;
	}
	if (property == ALAssetsGroupPropertyURL) {
		return self.propertyURL;
	}
	return nil;

}

- (CGImageRef)posterImage {
	return self.image.CGImage;
}



@end