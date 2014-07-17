//
//
// Created by Rene Pirringer.
//
// 
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "OBALAssetLibrary.h"
#import "OBCollection.h"
#import "OBALCollection.h"
#import "OBALAsset.h"


@implementation OBALAssetLibrary {

	ALAssetsLibrary *_assetsLibrary;
	OBAssetLibraryType _type;
}

- (instancetype)initWithType:(OBAssetLibraryType)type {
	self = [super init];
	if (self) {
		_assetsLibrary = [[ALAssetsLibrary alloc] init];
		_type = type;
	}
	return self;
}

-	(void)fetchCollections:(OBAssetLibraryCompletionBlock)completion {

	NSUInteger groupTypes = ALAssetsGroupAll;

	__block NSMutableArray *resultArray = [[NSMutableArray alloc] init];
	ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
		if (group) {
			[resultArray addObject:[[OBALCollection alloc] initWithALAssetsGroup:group]];
			//[assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
			if (_type == OBAssetLibraryTypePhoto) {
					[group setAssetsFilter:[ALAssetsFilter allPhotos]];
			} else if (_type == OBAssetLibraryTypeVideo) {
				[group setAssetsFilter:[ALAssetsFilter allVideos]];
			}


		} else {
			// if nil we are done, so call the completion
			if (completion) {
				completion(resultArray, nil);
			}

		}
	};

	ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
	  if (completion) {
		  completion(nil, error);
	  }
	};

	[_assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];

}


- (void)fetchPhotosForCollection:(OBCollection *)collection completion:(OBAssetLibraryCompletionBlock)completion {


	if ([collection isKindOfClass:[OBALCollection class]]) {

		ALAssetsGroup *assetsGroup = [((OBALCollection *)collection) assetsGroups];


		NSMutableArray *results = [[NSMutableArray alloc] init];
		[assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
			if (index == NSNotFound) {
				if (completion) {
					completion(results, nil);
				}
				return;
			}
			OBALAsset *asset = [[OBALAsset alloc] initWithAsset:result];
			[results addObject:asset];

		}];

		if (completion) {
			completion(results, nil);
		}

	}


}
@end