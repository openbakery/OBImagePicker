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
#import "OBAssetCollectionViewCell.h"
#import "OBCollectionTableViewCell.h"
#import "OBDefaultAssetCollectionViewCell.h"


@implementation OBImagePickerViewController {

	Class _registeredAssetCellClass;
	
	Class _registeredTableViewCellClass;
}

- (instancetype)initWithLibrary:(id<OBAssetLibrary>)library selectionHandler:(OBAssetPickerSelectionHandlerBlock)selectionHandler errorHandler:(OBAssetPickerErrorHandlerBlock)errorHandler {
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

- (void)registerAssetCellClass:(Class)cellClass {
	NSAssert([cellClass isSubclassOfClass:[OBAssetCollectionViewCell class]], @"Cell class must derive from OBAssetCollectionViewCell");
	_registeredAssetCellClass = cellClass;
}

- (void)registerTableCellClass:(Class)cellClass {
	NSAssert([cellClass isSubclassOfClass:[OBCollectionTableViewCell class]], @"Cell class must derive from OBCollectionTableViewCell");
	_registeredTableViewCellClass = cellClass;
}

- (Class)registeredAssetCellClass {
	if (_registeredAssetCellClass) {
		return _registeredAssetCellClass;
	}
	return [OBDefaultAssetCollectionViewCell class];
}

- (Class)registeredTableViewCellClass {
	if (_registeredTableViewCellClass) {
		return _registeredTableViewCellClass;
	}
	return [OBCollectionTableViewCell class];
}

@end