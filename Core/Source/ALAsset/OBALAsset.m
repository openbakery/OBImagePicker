//
//
// Created by Rene Pirringer.
//
// 
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "OBALAsset.h"


@implementation OBALAsset {
	ALAsset *_asset;
	NSString *_identifier;
}
- (id)initWithAsset:(ALAsset *)asset {
	self = [super init];
	if (self) {
		_asset = asset;
	}
	return self;
}

- (NSString *)identifier {
	if (!_identifier) {
		NSDictionary *dictionary = [_asset valueForProperty:ALAssetPropertyURLs];
		_identifier = [[[dictionary allValues] firstObject] description];
	}
	return _identifier;
}


- (UIImage *)thumbnailImage {
	return [UIImage imageWithCGImage:_asset.thumbnail];
}

- (UIImage *)image {
	ALAssetRepresentation *assetRepresentation = [_asset defaultRepresentation];

	CGImageRef imageRef = [assetRepresentation fullScreenImage];
	return [UIImage imageWithCGImage:imageRef
	                           scale:[UIScreen mainScreen].scale
			                 orientation:(UIImageOrientation) assetRepresentation.orientation];
}


- (BOOL)isVideo {
	return [_asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo;
}

- (BOOL)isPhoto {
	return [_asset valueForProperty:ALAssetPropertyType] == ALAssetTypePhoto;
}

- (NSInteger)duration {
	if (self.isVideo) {
		NSNumber *duration = [_asset valueForProperty:ALAssetPropertyDuration];
		return [duration integerValue];
	}
	return 0;
}


- (NSString *)pathExtension {
	return [[_asset.defaultRepresentation.filename pathExtension] lowercaseString];
}


- (void)saveToFile:(NSString *)path error:(NSError **)error {
	ALAssetRepresentation *assetRepresentation = _asset.defaultRepresentation;

	[[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
	NSFileHandle *_fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];

	long long offset = 0;
	uint8_t dataBuffer[4096];
	NSError *internalError;
	do {
		NSUInteger readByteLength = [assetRepresentation getBytes:dataBuffer fromOffset:offset length:sizeof(dataBuffer) error:&internalError];
		if (internalError != nil) {
			if (error != NULL) {
				*error = internalError;
			}
			return;
		}
		offset += readByteLength;

		[_fileHandle writeData:[NSData dataWithBytes:dataBuffer length:readByteLength]];
	}
	while (offset < assetRepresentation.size);
	[_fileHandle closeFile];
}

@end