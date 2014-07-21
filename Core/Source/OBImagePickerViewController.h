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


NS_ENUM(NSInteger, OBImagePickerSelectionMode) {
	OBImagePickerMultipleSelectionMode = 0,
	OBImagePickerSingleSelectionMode
};


@interface OBImagePickerViewController : UINavigationController

- (instancetype)initWithLibrary:(id<OBAssetLibrary>)library selectionHandler:(OBAssetPickerSelectionHandlerBlock)selectionHandler errorHandler:(OBAssetPickerErrorHandlerBlock)errorHandler;

- (void)registerAssetCellClass:(Class)cellClass;

@property (nonatomic, assign) enum OBImagePickerSelectionMode selectionMode;

- (void)reloadData;

@end