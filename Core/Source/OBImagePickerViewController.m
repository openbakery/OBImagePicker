//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBImagePickerViewController.h"
#import "OBCollectionPickerViewController.h"
#import "OBALAssetLibrary.h"
#import "OBAssetLibrary.h"
#import "OBAssetPickerViewController.h"


@implementation OBImagePickerViewController {

}

- (instancetype)initWithLibrary:(id<OBAssetLibrary>)library selectionHandler:(OBAssertPickerSelectionHandlerBlock)selectionHandler errorHandler:(OBAssertPickerErrorHandlerBlock)errorHandler {
	OBCollectionPickerViewController *collectionPickerViewController = [[OBCollectionPickerViewController alloc] initWithLibrary:library];
	collectionPickerViewController.selectionHandler = selectionHandler;
	collectionPickerViewController.errorHandler = errorHandler;

	self = [super initWithRootViewController:collectionPickerViewController];
	if (self) {
		self.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	return self;
}


- (void)reloadData {

	for (UIViewController *viewController in self.viewControllers) {
		if ([viewController isKindOfClass:[OBCollectionPickerViewController class]]) {
			[(OBCollectionPickerViewController *) viewController reloadData];
		}
		if ([viewController isKindOfClass:[OBAssetPickerViewController class]]) {
			[(OBAssetPickerViewController *) viewController reloadData];
		}
	}
}


@end