//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import "OBImagePickerViewController.h"

@class OBALAssetLibrary;
@class CoreService;


@interface OBCollectionPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;


@property(nonatomic, copy) OBAssetPickerSelectionHandlerBlock selectionHandler;
@property(nonatomic, copy) OBAssetPickerErrorHandlerBlock errorHandler;

- (void)handleError:(NSError *)error;

- (id)initWithLibrary:(id <OBAssetLibrary>)library;

- (void)reloadData;

@end