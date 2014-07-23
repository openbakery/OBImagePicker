//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBAssetPickerViewController.h"
#import "TestNavigationController.h"
#import "OBALAssetLibrary.h"
#import "OBAsset.h"
#import "OBDefaultAssetCollectionViewCell.h"
#import "UIBarButtonTestHelper.h"
#import "OBTestAssetCollectionViewCell.h"

#define HC_SHORTHAND
#import <OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>


@interface OBAssetPickerViewControllerTest : XCTestCase
@end

@implementation OBAssetPickerViewControllerTest {
	OBAssetPickerViewController *_viewController;
	UIWindow *_window;
	TestNavigationController *_navigationController;
	OBALAssetLibrary *_photoLibrary;

	NSMutableArray *_assets;
	
	NSBundle *_resourceBundle;
}

- (void)setUp {
	_window = [[UIWindow alloc] init];
	_viewController = [[OBAssetPickerViewController alloc] initWithCollection:nil];
	_navigationController = [[TestNavigationController alloc] initWithRootViewController:_viewController];
	_photoLibrary = mockProtocol(@protocol(OBAssetLibrary));
	_viewController.photoLibrary = _photoLibrary;
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_window.rootViewController = _navigationController;

	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"Asset" ofType:@"png"];

	_assets = [[NSMutableArray alloc] init];
	for (int i=0; i<20; i++) {

		OBAsset *asset = mock([OBAsset class]);
		BOOL isVideo = (i>9);
		[given(asset.isVideo) willReturnBool:isVideo];
		[given(asset.isPhoto) willReturnBool:!isVideo];

		[given(asset.thumbnailImage) willReturn:[UIImage imageWithContentsOfFile:path]];
		[_assets addObject:asset];
	}
	
	NSString *resourceBundlePath = [[NSBundle bundleForClass:[OBAssetPickerViewController class]] pathForResource:@"OBImagePicker" ofType:@"bundle"];
	_resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
}



- (void)makeVisible {
	[_window makeKeyAndVisible];
#ifdef __IPHONE_8_0
	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	}
#endif
}

- (void)testCollectionView {
	[self makeVisible];
	assertThat(_viewController.collectionView, is(notNilValue()));
	assertThat(_viewController.collectionView.dataSource, is(_viewController));
	assertThat(_viewController.collectionView.delegate, is(_viewController));
	assertThat(_viewController.collectionView.superview, is(_viewController.view));
	assertThatBool(_viewController.collectionView.scrollEnabled, is(@YES));
	assertThatBool(_viewController.collectionView.bounces, is(@YES));
	assertThatBool(_viewController.collectionView.alwaysBounceVertical, is(@YES));
	assertThatBool(_viewController.collectionView.userInteractionEnabled, is(@YES));
	assertThatBool(_viewController.collectionView.allowsMultipleSelection, is(@YES));
}


- (void)mockLibraryWithCollection:(NSArray *)collection {

	MKTArgumentCaptor *completionArgument = [[MKTArgumentCaptor alloc] init];

	[verify(_photoLibrary) fetchAssetsForCollection:anything() completion:[completionArgument capture]];

	OBAssetLibraryCompletionBlock completionBlock = [completionArgument value];
	if (completionBlock) {
		completionBlock(collection, nil);
	}

}

- (void)testNumberItemsInSection {
	[self makeVisible];
	[self mockLibraryWithCollection:_assets];
	NSInteger numberItems = [_viewController collectionView:_viewController.collectionView numberOfItemsInSection:0];
	assertThatInteger(numberItems, is(@20));
}

- (void)testCollectionViewCell {
	[self makeVisible];

	[self mockLibraryWithCollection:_assets];

	OBDefaultAssetCollectionViewCell *cell = (OBDefaultAssetCollectionViewCell*)[_viewController collectionView:_viewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	assertThat(cell, instanceOf([OBDefaultAssetCollectionViewCell class]));

	assertThat(cell.imageView, is(notNilValue()));

	assertThat(cell.imageView.image, is(notNilValue()));

}

- (void)testLayout {
	[self makeVisible];
	[self mockLibraryWithCollection:_assets];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		_viewController.view.frame = CGRectMake(0, 0, 540, 670); // simulator
	}

	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_viewController.collectionView.collectionViewLayout;
	assertThat(layout, is(notNilValue()));

	CGFloat scale = [UIScreen mainScreen].scale;
	assertThatFloat(layout.itemSize.width, is(@(157/scale)));
	assertThatFloat(layout.itemSize.height, is(@(157/scale)));

	CGFloat spacing = [_viewController collectionView:_viewController.collectionView layout:_viewController.collectionView.collectionViewLayout minimumInteritemSpacingForSectionAtIndex:0];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		assertThatFloat(spacing, is(@(4/scale)));
	} else {
		assertThatFloat(spacing, is(@(ceil(23/scale))));
	}

	CGFloat lineSpacing = [_viewController collectionView:_viewController.collectionView layout:_viewController.collectionView.collectionViewLayout minimumLineSpacingForSectionAtIndex:0];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		assertThatFloat(lineSpacing, is(@(4/scale)));
	} else {
		assertThatFloat(lineSpacing, is(@(ceil(23/scale))));
	}

}

- (void)testSelectedCell {

	[self makeVisible];
	[self mockLibraryWithCollection:_assets];

	OBDefaultAssetCollectionViewCell *cell = (OBDefaultAssetCollectionViewCell*)[_viewController collectionView:_viewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

	[cell setSelected:YES];

	assertThat(cell.subviews, hasCountOf(2));

}

- (void)testDoneButton {
	[self makeVisible];
	[self mockLibraryWithCollection:_assets];

	UIBarButtonItem *doneButton = _viewController.navigationItem.rightBarButtonItem;
	assertThatBool(doneButton.enabled, is(@NO));

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[_viewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];
	assertThatBool(doneButton.enabled, is(@YES));


	[_viewController.collectionView deselectItemAtIndexPath:indexPath animated:NO];
	[_viewController collectionView:_viewController.collectionView didDeselectItemAtIndexPath:indexPath];
	assertThatBool(doneButton.enabled, is(@NO));
}

- (void)testTitle {
	[self makeVisible];
	[self mockLibraryWithCollection:_assets];

	assertThat(_viewController.navigationItem.title, is(NSLocalizedStringFromTableInBundle(@"ASSET_PICKER_TITLE", @"OBAssetPicker", _resourceBundle, @"")));

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[_viewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];

	assertThat(_viewController.navigationItem.title, is(NSLocalizedStringFromTableInBundle(@"ASSET_PICKER_TITLE_SINGLE_PHOTO_SELECTION", @"OBAssetPicker", _resourceBundle, @"")));

	// select second item
	indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
	[_viewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];

	NSString *expectedString = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"ASSET_PICKER_TITLE_MULTIPLE_PHOTOS_SELECTION", @"OBAssetPicker", _resourceBundle, @""), @"2"];
	assertThat(_viewController.navigationItem.title, is(expectedString));

}


- (void)testTitleVideo {
	[self makeVisible];
	[self mockLibraryWithCollection:_assets];

	assertThat(_viewController.navigationItem.title, is(NSLocalizedStringFromTableInBundle(@"ASSET_PICKER_TITLE", @"OBAssetPicker", _resourceBundle, @"")));

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
	[_viewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];

	assertThat(_viewController.navigationItem.title, is(NSLocalizedStringFromTableInBundle(@"ASSET_PICKER_TITLE_SINGLE_VIDEO_SELECTION", @"OBAssetPicker", _resourceBundle, @"")));

	// select second video
	indexPath = [NSIndexPath indexPathForRow:11 inSection:0];
	[_viewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];

	NSString *expectedString = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"ASSET_PICKER_TITLE_MULTIPLE_VIDEOS_SELECTION", @"OBAssetPicker", _resourceBundle, @""), @"2"];
	assertThat(_viewController.navigationItem.title, is(expectedString));


	// select third item, that is a photo
	indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[_viewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];

	expectedString = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"ASSET_PICKER_TITLE_MULTIPLE_ITEMS_SELECTION", @"OBAssetPicker", _resourceBundle, @""), @"3"];
	assertThat(_viewController.navigationItem.title, is(expectedString));


}


- (void)testDonePressed {
	[self makeVisible];
	[self mockLibraryWithCollection:_assets];

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[_viewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];


	__block BOOL completionExecuted = NO;
	__block NSArray *selectedAssets = nil;
	_viewController.selectionHandler = ^(NSArray *assets, OBImagePickerViewController *controller) {
		completionExecuted = YES;
		selectedAssets = assets;
	};

	[UIBarButtonTestHelper performBarButtonAction:_viewController.navigationItem.rightBarButtonItem];

	assertThatBool(completionExecuted, is(@YES));
	assertThat(selectedAssets, hasCountOf(1));
	assertThat([selectedAssets firstObject], is(instanceOf([OBAsset class])));
}

- (void)testNoAssets {
	[self makeVisible];
	[self mockLibraryWithCollection:@[]];

	NSInteger numberItems = [_viewController collectionView:_viewController.collectionView numberOfItemsInSection:0];
	assertThatInteger(numberItems, is(@0));
}


- (void)testPhotoCell {

	[self makeVisible];
	[self mockLibraryWithCollection:_assets];

	OBDefaultAssetCollectionViewCell *cell = (OBDefaultAssetCollectionViewCell*)[_viewController collectionView:_viewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];

	UIView *gradientView = [cell valueForKey:@"_gradientView"];
	assertThat(gradientView, is(notNilValue()));

	[cell setSelected:YES];

	assertThat(cell.subviews, hasCountOf(3));

}

- (void)testSelectSameItemTwice {
	[self makeVisible];
	[self mockLibraryWithCollection:_assets];

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[_viewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];

	__block NSArray *selectedAssets = nil;
	_viewController.selectionHandler = ^(NSArray *assets, OBImagePickerViewController *controller) {
		selectedAssets = assets;
	};

	[UIBarButtonTestHelper performBarButtonAction:_viewController.navigationItem.rightBarButtonItem];
	assertThat(selectedAssets, hasCountOf(1));

}

- (void)testSetSelectedItem {
	[self makeVisible];
	[self mockLibraryWithCollection:_assets];

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[_viewController.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];

	OBDefaultAssetCollectionViewCell *cell = (OBDefaultAssetCollectionViewCell*)[_viewController collectionView:_viewController.collectionView cellForItemAtIndexPath:indexPath];
	assertThatBool(cell.selected, is(@YES));

}


- (void)testHandleError {
	[self makeVisible];

	NSError *error = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];

	__block NSError *givenError = nil;
	_viewController.errorHandler = ^(NSError *error, OBImagePickerViewController *controller) {
			givenError = error;
	};

	MKTArgumentCaptor *completionArgument = [[MKTArgumentCaptor alloc] init];
	[verify(_photoLibrary) fetchAssetsForCollection:anything() completion:[completionArgument capture]];
	OBAssetLibraryCompletionBlock completionBlock = [completionArgument value];
	if (completionBlock) {
		completionBlock(nil, error);
	}

	assertThat(givenError, is(error));
}


- (void)testReloadOnViewWillAppear {
	[self makeVisible];
	[verify(_photoLibrary) fetchAssetsForCollection:anything() completion:anything()];

	UIViewController *dummyViewController = [[UIViewController alloc] init];
	[_navigationController pushViewController:dummyViewController animated:NO];
	assertThat(_navigationController.topViewController, is(dummyViewController));

	_photoLibrary = mockProtocol(@protocol(OBAssetLibrary));
	[_viewController setValue:_photoLibrary forKey:@"_photoLibrary"];
	[_viewController reloadData];
	[verifyCount(_photoLibrary, never()) fetchAssetsForCollection:anything() completion:anything()];


	[_navigationController popViewControllerAnimated:NO];
	assertThat(_navigationController.topViewController, is(_viewController));

	_photoLibrary = mockProtocol(@protocol(OBAssetLibrary));
	[_viewController setValue:_photoLibrary forKey:@"_photoLibrary"];
	[_viewController viewWillAppear:NO];

	[verify(_photoLibrary) fetchAssetsForCollection:anything() completion:anything()];


}


- (void)testSingleSelection_DoneButtonHidden {
	_navigationController.selectionMode = OBImagePickerSingleSelectionMode;
	[self makeVisible];

	assertThat(_viewController.navigationItem.rightBarButtonItem, is(nilValue()));

}


- (void)testSingleSelection_SelectAsset {
	_navigationController.selectionMode = OBImagePickerSingleSelectionMode;
	[self makeVisible];
	[self mockLibraryWithCollection:_assets];


	__block BOOL completionExecuted = NO;
	__block NSArray *selectedAssets = nil;
	_viewController.selectionHandler = ^(NSArray *assets, OBImagePickerViewController *controller) {
		completionExecuted = YES;
		selectedAssets = assets;
	};

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[_viewController collectionView:_viewController.collectionView didSelectItemAtIndexPath:indexPath];


	assertThatBool(completionExecuted, is(@YES));
	assertThat(selectedAssets, hasCountOf(1));
	assertThat([selectedAssets firstObject], is(instanceOf([OBAsset class])));
}


- (void)testCustomAssetCell {
	[_navigationController registerAssetCellClass:[OBTestAssetCollectionViewCell class]];


	[self makeVisible];
	[self mockLibraryWithCollection:_assets];

	OBDefaultAssetCollectionViewCell *cell = (OBDefaultAssetCollectionViewCell*)[_viewController collectionView:_viewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
	assertThat(cell, is(instanceOf([OBTestAssetCollectionViewCell class])));

}

@end