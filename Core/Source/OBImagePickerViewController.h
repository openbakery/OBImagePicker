//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>

@protocol OBAssetLibrary;

@class OBImagePickerViewController;

typedef void (^OBAssetPickerSelectionHandlerBlock)(NSArray *assets, OBImagePickerViewController *controller);
typedef void (^OBAssetPickerErrorHandlerBlock)(NSError *error, OBImagePickerViewController *controller);

/**
* Enum to specify the selection mode
*/
NS_ENUM(NSInteger, OBImagePickerSelectionMode) {
/**
* This this mode if multiple assets should be selected
*/
	OBImagePickerMultipleSelectionMode = 0,
/**
* This this mode when only one asset should be selected
*/
	OBImagePickerSingleSelectionMode
};

/**
* The OBImagePickerViewController is a image picker to replace the UIImagePickerViewController.
* This image picker supports multiple selection of assets.
*/
@interface OBImagePickerViewController : UINavigationController

- (instancetype)initWithLibrary:(id<OBAssetLibrary>)library selectionHandler:(OBAssetPickerSelectionHandlerBlock)selectionHandler errorHandler:(OBAssetPickerErrorHandlerBlock)errorHandler;

- (void)registerAssetCellClass:(Class)cellClass;

- (void)registerTableCellClass:(Class)cellClass;

/**
* Property to set the selection mode. Possible values are OBImagePickerMultipleSelectionMode or OBImagePickerSingleSelectionMode.
*/
@property (nonatomic, assign) enum OBImagePickerSelectionMode selectionMode;

/**
* Reloads the data for the image picker. If either the collection picker of asset picker is visible, then it gets reloaded immediately, otherwise the next time the view controller gets visible.
*/
- (void)reloadData;

@end