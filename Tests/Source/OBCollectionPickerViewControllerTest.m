//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBCollectionPickerViewController.h"
#import "TestNavigationController.h"
#import "OBALAssetLibrary.h"
#import "OBCollection.h"
#import "UIBarButtonTestHelper.h"
#import "OBAssetPickerViewController.h"

#define HC_SHORTHAND
#import <OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface OBCollectionPickerViewController(Private)
@end

@implementation OBCollectionPickerViewController(Private)
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
	[super dismissViewControllerAnimated:NO completion:completion];
}

@end

@interface OBCollectionPickerViewControllerTest : XCTestCase
@end

@implementation OBCollectionPickerViewControllerTest {
	OBCollectionPickerViewController *_viewController;
	UIWindow *_window;
	TestNavigationController *_navigationController;
	OBALAssetLibrary *_photoLibrary;
}

- (void)setUp {
	_window = [[UIWindow alloc] init];
	_photoLibrary = mock([OBALAssetLibrary class]);
	_viewController = [[OBCollectionPickerViewController alloc] initWithLibrary:_photoLibrary];
	_navigationController = [[TestNavigationController alloc] initWithRootViewController:_viewController];
	_window.rootViewController = _navigationController;
}

- (void)testTableView {
	[_window makeKeyAndVisible];
	assertThat(_viewController.tableView, is(notNilValue()));
	assertThat(_viewController.tableView.dataSource, is(_viewController));
	assertThat(_viewController.tableView.delegate, is(_viewController));

	assertThat(_viewController.tableView.superview, is(_viewController.view));

	assertThatInteger(_viewController.tableView.separatorStyle, is(@(UITableViewCellSeparatorStyleNone)));

}

- (void)mockLibraryWithCollection:(NSArray *)collection {

	MKTArgumentCaptor *completionArgument = [[MKTArgumentCaptor alloc] init];
	[verify(_photoLibrary) fetchCollections:[completionArgument capture]];

	OBAssetLibraryCompletionBlock completionBlock = [completionArgument value];
	if (completionBlock) {
		completionBlock(collection, nil);
	}

}

- (void)testNumberItemsInSection {
	[_window makeKeyAndVisible];

	OBCollection *photoCollection = [[OBCollection alloc] initWithName:@"Camera Roll" image:nil numberOfAssets:10];
	[self mockLibraryWithCollection:@[photoCollection]];
	NSInteger numberItems = [_viewController tableView:_viewController.tableView numberOfRowsInSection:0];
	assertThatInteger(numberItems, is(@1));
}

- (void)testTableViewCell {
	[_window makeKeyAndVisible];

	OBCollection *photoCollection = [[OBCollection alloc] initWithName:@"Camera Roll" image:[[UIImage alloc] init] numberOfAssets:10];
	[self mockLibraryWithCollection:@[photoCollection]];

	UITableViewCell *cell = [_viewController tableView:_viewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

	assertThat(cell, is(notNilValue()));
	assertThat(cell.textLabel.text, is(equalTo(@"Camera Roll")));

	assertThatInteger(cell.accessoryType, is(@(UITableViewCellAccessoryDisclosureIndicator)));

	assertThat(cell.imageView.image, is(notNilValue()));
	assertThat(cell.detailTextLabel.text, is(@"10"));

}

- (void)testReloadTableViewOnGroupResult {
	[_window makeKeyAndVisible];

	UITableView *tableView = mock([UITableView class]);
	_viewController.tableView = tableView;

	OBCollection *photoCollection = [[OBCollection alloc] initWithName:@"Camera Roll" image:nil numberOfAssets:10];
	[self mockLibraryWithCollection:@[photoCollection]];

	[verify(tableView) reloadData];

}


- (void)testCloseButtonItem {
	[_window makeKeyAndVisible];
	UIBarButtonItem *closeButton = _viewController.navigationItem.leftBarButtonItem;
	assertThat(closeButton, is(notNilValue()));
}

- (void)testCloseButtonPressed {
	_viewController = [[OBCollectionPickerViewController alloc] init];

	UIViewController *rootViewController = [[UIViewController alloc] init];
	_navigationController = [[TestNavigationController alloc] initWithRootViewController:rootViewController];
	_window = [[UIWindow alloc] init];
	_window.rootViewController = _navigationController;

	[_window makeKeyAndVisible];

	[rootViewController.navigationController presentViewController:_viewController animated:NO completion:nil];

	UIBarButtonItem *closeButton = _viewController.navigationItem.leftBarButtonItem;
	[UIBarButtonTestHelper performBarButtonAction:closeButton];
	assertThat(_navigationController.visibleViewController, is(rootViewController));
}


- (void)testSelectCell {
	[_window makeKeyAndVisible];

	OBCollection *photoCollection = [[OBCollection alloc] initWithName:@"Camera Roll" image:[[UIImage alloc] init] numberOfAssets:10];
	[self mockLibraryWithCollection:@[photoCollection]];
	OBAssetPickerSelectionHandlerBlock selectionHandler = ^(NSArray *result, OBImagePickerViewController *controller) {};
	OBAssetPickerErrorHandlerBlock errorHandler = ^(NSError *error, OBImagePickerViewController *controller) {};
	_viewController.selectionHandler = selectionHandler;
	_viewController.errorHandler = errorHandler;

	[_viewController tableView:_viewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];



	OBAssetPickerViewController *photoPickerViewController = (OBAssetPickerViewController *)_navigationController.topViewController;

	assertThat(photoPickerViewController, is(instanceOf([OBAssetPickerViewController class])));

	assertThat(photoPickerViewController.photoLibrary, is(notNilValue()));

	assertThat(photoPickerViewController.selectionHandler, is(selectionHandler));
	assertThat(photoPickerViewController.errorHandler, is(errorHandler));

}


- (void)testHandleError {
	[_window makeKeyAndVisible];

	NSError *error = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];

	MKTArgumentCaptor *completionArgument = [[MKTArgumentCaptor alloc] init];
	[verify(_photoLibrary) fetchCollections:[completionArgument capture]];


	__block NSError *givenError = nil;
	_viewController.errorHandler = ^(NSError *error, OBImagePickerViewController *controller) {
			givenError = error;
	};

	OBAssetLibraryCompletionBlock completionBlock = [completionArgument value];
	if (completionBlock) {
		completionBlock(nil, error);
	}


	assertThat(givenError, is(error));

}

- (void)testReloadOnViewWillAppear {
	[_window makeKeyAndVisible];
	[verify(_photoLibrary) fetchCollections:anything()];

	UIViewController *dummyViewController = [[UIViewController alloc] init];
	[_navigationController pushViewController:dummyViewController animated:NO];
	assertThat(_navigationController.topViewController, is(dummyViewController));

	_photoLibrary = mockProtocol(@protocol(OBAssetLibrary));
	[_viewController setValue:_photoLibrary forKey:@"_photoLibrary"];
	[_viewController reloadData];
	[verifyCount(_photoLibrary, never()) fetchCollections:anything()];


	[_navigationController popViewControllerAnimated:NO];
	assertThat(_navigationController.topViewController, is(_viewController));

	_photoLibrary = mockProtocol(@protocol(OBAssetLibrary));
	[_viewController setValue:_photoLibrary forKey:@"_photoLibrary"];
	[_viewController viewWillAppear:NO];

	[verify(_photoLibrary) fetchCollections:anything()];


}

@end