//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import "OBImagePickerViewController.h"

@class OBALAssetLibrary;
@class OBCollection;


@interface OBAssetPickerViewController : UIViewController  <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) OBALAssetLibrary *photoLibrary;

@property(nonatomic, strong) OBCollection *collection;

@property(nonatomic, strong) OBAssetPickerSelectionHandlerBlock selectionHandler;
@property(nonatomic, strong) OBAssetPickerErrorHandlerBlock errorHandler;

- (instancetype)initWithCollection:(OBCollection *)collection;

- (void)reloadData;

- (void)handleError:(NSError *)error;
@end