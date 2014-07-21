//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBImagePickerViewController.h"
#import "OBCollectionPickerViewController.h"
#import "OBALAssetLibrary.h"

#define HC_SHORTHAND
#import <OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>


@interface OBImagePickerViewControllerTest : XCTestCase
@end

@implementation OBImagePickerViewControllerTest {
	OBImagePickerViewController *_viewController;
}


- (void)setUp {
}


- (void)testCollectionSelection {
	id<OBAssetLibrary> library = mockProtocol(@protocol(OBAssetLibrary));
	_viewController = [[OBImagePickerViewController alloc] initWithLibrary:library selectionHandler:nil errorHandler:nil];

	assertThat(_viewController.viewControllers, hasCountOf(1));

	OBCollectionPickerViewController *collectionPickerViewController = _viewController.viewControllers[0];
	assertThat(collectionPickerViewController, is(instanceOf([OBCollectionPickerViewController class])));

	id<OBAssetLibrary> photoLibrary = [collectionPickerViewController valueForKey:@"_photoLibrary"];
	assertThat(photoLibrary, is(notNilValue()));

}

- (void)testSelectionHandlerBlock {
	__block BOOL blockExecuted = NO;
	OBAssetPickerSelectionHandlerBlock selectionHandler = ^(NSArray *assets, OBImagePickerViewController *controller) {
	    blockExecuted = YES;
	};

	id<OBAssetLibrary> library = mockProtocol(@protocol(OBAssetLibrary));
	_viewController = [[OBImagePickerViewController alloc] initWithLibrary:library selectionHandler:selectionHandler errorHandler:nil];


	OBCollectionPickerViewController *collectionPickerViewController = _viewController.viewControllers[0];
	if (collectionPickerViewController.selectionHandler) {
		collectionPickerViewController.selectionHandler(nil, nil);
	}

	assertThatBool(blockExecuted, is(@YES));
}

- (void)testErrorHandlerBlock {
	__block BOOL blockExecuted = NO;
	OBAssetPickerErrorHandlerBlock errorHandlerBlock = ^(NSError *error, OBImagePickerViewController *controller) {
	    blockExecuted = YES;
	};

	id<OBAssetLibrary> library = mockProtocol(@protocol(OBAssetLibrary));
	_viewController = [[OBImagePickerViewController alloc] initWithLibrary:library selectionHandler:nil errorHandler:errorHandlerBlock];


	OBCollectionPickerViewController *collectionPickerViewController = _viewController.viewControllers[0];
	if (collectionPickerViewController.errorHandler) {
		collectionPickerViewController.errorHandler(nil, nil);
	}

	assertThatBool(blockExecuted, is(@YES));
}


- (void)testReloadImmediately {

	id<OBAssetLibrary> library = mockProtocol(@protocol(OBAssetLibrary));
	_viewController = [[OBImagePickerViewController alloc] initWithLibrary:library selectionHandler:nil errorHandler:nil];


	[_viewController reloadData];

	// on the top view controller that is a OBCollectionPickerViewController the reload should be executed immediately that is a fetchCollections
	[verify(library) fetchCollections:anything()];

}


@end