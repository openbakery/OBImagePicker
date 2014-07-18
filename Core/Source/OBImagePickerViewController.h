//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>

@protocol OBAssetLibrary;

@class OBImagePickerViewController;

typedef void (^OBAssertPickerSelectionHandlerBlock)(NSArray *assets, OBImagePickerViewController *controller);
typedef void (^OBAssertPickerErrorHandlerBlock)(NSError *error, OBImagePickerViewController *controller);


NS_ENUM(NSInteger, OBImagePickerSelectionMode) {
	OBImagePickerMultipleSelectionMode = 0,
	OBImagePickerSingleSelectionMode
};


@interface OBImagePickerViewController : UINavigationController

- (instancetype)initWithLibrary:(id<OBAssetLibrary>)library selectionHandler:(OBAssertPickerSelectionHandlerBlock)selectionHandler errorHandler:(OBAssertPickerErrorHandlerBlock)errorHandler;

- (void)registerAssetCellClass:(Class)cellClass;

@property (nonatomic, assign) enum OBImagePickerSelectionMode selectionMode;

- (void)reloadData;

@end