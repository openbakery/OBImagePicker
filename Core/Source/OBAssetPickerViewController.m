//
//
// Created by Rene Pirringer.
//
// 
//


#import <MacTypes.h>
#import "OBAssetPickerViewController.h"
#import "OBALAssetLibrary.h"
#import "OBCollection.h"
#import "OBAssetCollectionViewCell.h"
#import "OBAsset.h"


@interface OBAssetPickerViewController ()
@property(nonatomic, strong) NSArray* photos;
@property(nonatomic, assign) CGSize assetSize;
@end



@implementation OBAssetPickerViewController {
	NSString *collectionCellIdentifier;
	UIBarButtonItem *_doneButton;
	NSMutableArray *_selectedAssets;
	BOOL _reloadOnViewWillAppear;
	enum OBImagePickerSelectionMode _selectionMode;
}

- (instancetype)initWithCollection:(OBCollection *)collection {
	self = [super init];
	if (self) {
		_collection = collection;
		self.assetSize = CGSizeZero;
		_selectedAssets = [[NSMutableArray alloc] init];
		_reloadOnViewWillAppear = YES;
	}
	return self;
}


- (void)loadView {
	[super loadView];
	collectionCellIdentifier = @"CollectionCellIdentifier";

	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

	self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.collectionView.allowsMultipleSelection = YES;
	[self.collectionView registerClass:[OBAssetCollectionViewCell class] forCellWithReuseIdentifier:collectionCellIdentifier];


	[self.view addSubview:self.collectionView];
	self.collectionView.backgroundColor = [UIColor whiteColor];
	self.collectionView.alwaysBounceVertical = YES;
	self.collectionView.contentInset = UIEdgeInsetsMake(9.0f, 0, 0, 0);


	[self updateContentAfterInteraction];


}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([self.navigationController isKindOfClass:[OBImagePickerViewController class]]) {
		OBImagePickerViewController *imagePickerViewController = (OBImagePickerViewController *)self.navigationController;
		_selectionMode = imagePickerViewController.selectionMode;
	}

	if (_selectionMode == OBImagePickerMultipleSelectionMode) {
		_doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
		self.navigationItem.rightBarButtonItem = _doneButton;
		_doneButton.enabled = NO;
	}

	if (_reloadOnViewWillAppear) {
		[self reloadData];
	}

}

- (void)reloadData {

	if (self.navigationController.topViewController != self) {
		// if this view controller is not visible, reload it when it next gets visible
		_reloadOnViewWillAppear = YES;
		return;
	}


	__weak OBAssetPickerViewController *weakSelf = self;
	[self.photoLibrary fetchPhotosForCollection:self.collection completion:^(NSArray *result, NSError *error) {
	    if (result) {
		    weakSelf.photos = result;
		    if ([weakSelf.photos count]) {
			    OBAsset *asset = [weakSelf.photos objectAtIndex:0];
			    CGSize imageSize = asset.thumbnailImage.size;
			    CGFloat scale = [UIScreen mainScreen].scale;
			    weakSelf.assetSize = CGSizeMake(imageSize.width / scale, imageSize.height / scale);

			    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) weakSelf.collectionView.collectionViewLayout;
			    layout.itemSize = weakSelf.assetSize;

			    [self.collectionView reloadData];
		    }
	    } else {
		    [weakSelf handleError:error];
	    }
	}];
}

- (void)handleError:(NSError *)error {
	if (self.errorHandler) {
		self.errorHandler(error, (OBImagePickerViewController *)self.navigationController);
	} else {
		NSLog(@"Error: %@", [error localizedDescription]);
	}
}


- (CGFloat)spacingForCollectionView:(UICollectionView *)collectionView {
	if (self.assetSize.width == 0) {
		return 10.0f;
	}
	NSInteger numberItems = collectionView.bounds.size.width / self.assetSize.width;
	return ceilf((collectionView.bounds.size.width - self.assetSize.width*numberItems)/numberItems);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return [self spacingForCollectionView:collectionView];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return [self spacingForCollectionView:collectionView];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	OBAssetCollectionViewCell *cell = (OBAssetCollectionViewCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
	OBAsset *asset = [self assetAtIndexPath:indexPath];
	cell.asset = asset;
	[cell setSelected:[_selectedAssets containsObject:asset]];
	return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	OBAsset *asset = [self assetAtIndexPath:indexPath];
	if (_selectionMode == OBImagePickerSingleSelectionMode) {
		if (self.selectionHandler) {
			self.selectionHandler(@[asset], (OBImagePickerViewController *)self.navigationController);
		}
		return;
	}


	if (![_selectedAssets containsObject:asset]) {
		[_selectedAssets addObject:asset];
	}
	[self updateContentAfterInteraction];
}



- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	OBAsset *asset = [self assetAtIndexPath:indexPath];
	[_selectedAssets removeObject:asset];
	[self updateContentAfterInteraction];
}


- (void)updateContentAfterInteraction {

	NSInteger count = [_selectedAssets count];

	if (count == 1) {
		OBAsset *asset = [_selectedAssets firstObject];
		if (asset.isVideo) {
			[self.navigationItem setTitle:NSLocalizedStringFromTable(@"ASSET_PICKER_TITLE_SINGLE_VIDEO_SELECTION", @"OBAssetPicker", @"")];
		} else {
			[self.navigationItem setTitle:NSLocalizedStringFromTable(@"ASSET_PICKER_TITLE_SINGLE_PHOTO_SELECTION", @"OBAssetPicker", @"")];
		}
	} else if ([_selectedAssets count] > 1) {

		NSString *templateString = nil;
		if ([self allAssertsAreOfSameTypeIn:_selectedAssets]) {
			OBAsset *asset = [_selectedAssets firstObject];
			if (asset.isVideo) {
				templateString = NSLocalizedStringFromTable(@"ASSET_PICKER_TITLE_MULTIPLE_VIDEOS_SELECTION", @"OBAssetPicker", @"");
			} else {
				templateString = NSLocalizedStringFromTable(@"ASSET_PICKER_TITLE_MULTIPLE_PHOTOS_SELECTION", @"OBAssetPicker", @"");
			}
		} else {
			templateString = NSLocalizedStringFromTable(@"ASSET_PICKER_TITLE_MULTIPLE_ITEMS_SELECTION", @"OBAssetPicker", @"");
		}

		NSString *titleString = [NSString stringWithFormat:templateString, [@(count) stringValue]];
		[self.navigationItem setTitle:titleString];
	} else {
		[self.navigationItem setTitle:NSLocalizedStringFromTable(@"ASSET_PICKER_TITLE", @"OBAssetPicker", @"")];
	}

	_doneButton.enabled = count > 0;

}

- (BOOL)allAssertsAreOfSameTypeIn:(NSArray *)assets {
	if ([assets count] < 2) {
		return YES;
	}
	OBAsset *first = [assets firstObject];
	for (OBAsset *asset in assets) {
		if (asset.isPhoto != first.isPhoto) {
			return NO;
		}
	}
	return YES;
}


- (OBAsset *)assetAtIndexPath:(NSIndexPath *)indexPath {
	return [self.photos objectAtIndex:indexPath.row];;

}

- (void)doneButtonPressed:(id)sender {
	if (self.selectionHandler) {
		self.selectionHandler(_selectedAssets, (OBImagePickerViewController *)self.navigationController);
	}
}

@end