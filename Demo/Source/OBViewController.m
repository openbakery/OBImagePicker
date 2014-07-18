//
//  OBViewController.m
//  OBImagePicker
//
//  Created by Rene Pirringer on 17.07.14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//

#import "OBViewController.h"
#import "OBImagePickerViewController.h"
#import "OBALCollection.h"
#import "OBALAssetLibrary.h"
#import "OBAsset.h"

@interface OBViewController ()

@end

@implementation OBViewController


- (void)showPickerWithMode:(enum OBImagePickerSelectionMode)selectionMode {
	OBALAssetLibrary *library = [[OBALAssetLibrary alloc] initWithType:OBAssetLibraryTypeAll];

	__weak OBViewController *weakSelf = self;
	OBAssertPickerSelectionHandlerBlock selectionHandler = ^(NSArray *assets, OBImagePickerViewController *controller) {
	    if ([assets count]) {
		    OBAsset *firstAsset = [assets firstObject];
		    if (firstAsset.isPhoto) {
		      weakSelf.imageView.image = firstAsset.image;
		    }
	    }
	    [controller dismissViewControllerAnimated:YES completion:nil];

	};
	OBImagePickerViewController *imagePickerViewController = [[OBImagePickerViewController alloc] initWithLibrary:library selectionHandler:selectionHandler errorHandler:nil];
	imagePickerViewController.selectionMode = selectionMode;

	[self presentViewController:imagePickerViewController animated:YES completion:nil];
}

- (IBAction)showMultiSelectionPicker:(id)sender {

	[self showPickerWithMode:OBImagePickerMultipleSelectionMode];

}

- (IBAction)showSingleModePicker:(id)sender {
	[self showPickerWithMode:OBImagePickerSingleSelectionMode];
}

@end
