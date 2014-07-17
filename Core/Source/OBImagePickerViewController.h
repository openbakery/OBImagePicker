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


typedef enum {
	OBImagePickerMultipleSelectionMode = 0,
	OBImagePickerSingleSelectionMode
} OBImagePickerSelectionMode;


@interface OBImagePickerViewController : UINavigationController

- (instancetype)initWithLibrary:(id<OBAssetLibrary>)library selectionHandler:(OBAssertPickerSelectionHandlerBlock)selectionHandler errorHandler:(OBAssertPickerErrorHandlerBlock)errorHandler;

@property (nonatomic, assign) OBImagePickerSelectionMode *selectionMode;

- (void)reloadData;

@end