//
//
// Created by Rene Pirringer.
//
// 
//


#import <AssetsLibrary/AssetsLibrary.h>
#import "OBALAssetLibrary.h"
#import "ALAssetsGroupStub.h"
#import "OBCollection.h"
#import "OBALCollection.h"

#define HC_SHORTHAND
#import <OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>


@interface OBAssetLibraryTest : XCTestCase
@end

@implementation OBAssetLibraryTest {
	OBALAssetLibrary *_assetLibrary;
	ALAssetsLibrary *_alAssetsLibrary;
}


- (void)setUp {
	_assetLibrary = [[OBALAssetLibrary alloc] init];
	_alAssetsLibrary = mock([ALAssetsLibrary class]);
	[_assetLibrary setValue:_alAssetsLibrary forKey:@"_assetsLibrary"];
}

- (void)mockEnumerateGroupsWithTypes{
	MKTArgumentCaptor *blockArgument = [[MKTArgumentCaptor alloc] init];

	[verify(_alAssetsLibrary) enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:[blockArgument capture] failureBlock:anything()];

	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *imagePath = [bundle pathForResource:@"Asset" ofType:@"png"];
	UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

	ALAssetsLibraryGroupsEnumerationResultsBlock block = [blockArgument value];
	if (block) {
		ALAssetsGroupStub *assetGroup = [[ALAssetsGroupStub alloc] init];
		assetGroup.propertyName = @"Camera Roll";
		assetGroup.image = image;
		block(assetGroup, nil);
		block(nil, nil);
	}
}



- (void)testFetchCollections {

	__block NSArray *collections = nil;
	[_assetLibrary fetchCollections:^(NSArray *result, NSError *error) {
	   if (result) {
		   collections = result;
	   }
	}];

	[self mockEnumerateGroupsWithTypes];

	assertThat(collections, is(notNilValue()));

	assertThat(collections, hasCountOf(1));

	OBALCollection *collection = [collections firstObject];
	assertThat(collection.name, is(@"Camera Roll"));
	assertThat(collection.image, is(instanceOf([UIImage class])));

	assertThat(collection.name, is(@"Camera Roll"));

	ALAssetsGroupStub *assetGroup = (ALAssetsGroupStub *)collection.assetsGroups;
	assertThat(assetGroup.assetsFilter, is(nilValue()));


}


- (void)testFetchPhotos {

	ALAssetsGroup *assetsGroup = mock([ALAssetsGroup class]);


	OBALCollection *collection = [[OBALCollection alloc] initWithALAssetsGroup:assetsGroup];
	__block NSArray *assets = nil;

	[_assetLibrary fetchAssetsForCollection:collection completion:^(NSArray *result, NSError *error) {
	    if (result) {
		    assets = result;
	    }
	}];

	MKTArgumentCaptor *enumerateArgument = [[MKTArgumentCaptor alloc] init];
	[verify(assetsGroup) enumerateAssetsUsingBlock:[enumerateArgument capture]];
	ALAssetsGroupEnumerationResultsBlock enumerationResultsBlock = [enumerateArgument value];

	if (enumerationResultsBlock) {
		for (int i = 0; i < 10; i++) {
			ALAsset *asset = [[ALAsset alloc] init];
			enumerationResultsBlock(asset, i, nil);
		}
	}

	assertThat(assets, hasCountOf(10));

}


- (void)testFetchCollectionsWithOnlyPhotos {
	_assetLibrary = [[OBALAssetLibrary alloc] initWithType:OBAssetLibraryTypePhoto];
	_alAssetsLibrary = mock([ALAssetsLibrary class]);
	[_assetLibrary setValue:_alAssetsLibrary forKey:@"_assetsLibrary"];

	__block NSArray *collections = nil;
	[_assetLibrary fetchCollections:^(NSArray *result, NSError *error) {
	   if (result) {
		   collections = result;
	   }
	}];

	[self mockEnumerateGroupsWithTypes];

	assertThat(collections, is(notNilValue()));

	assertThat(collections, hasCountOf(1));

	OBALCollection *collection = [collections firstObject];

	ALAssetsGroupStub *assetGroup = (ALAssetsGroupStub *)collection.assetsGroups;
	assertThat(assetGroup.assetsFilter, is(notNilValue()));
	// cannot test if the proper filter was selected because, (ALAssetsFilter *)allPhotos creates new instances, and the equals is not implemented by apple

}


@end