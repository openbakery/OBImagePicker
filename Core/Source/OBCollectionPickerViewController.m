//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBCollectionPickerViewController.h"
#import "OBALAssetLibrary.h"
#import "OBCollection.h"
#import "OBCollectionTableViewCell.h"
#import "OBAssetPickerViewController.h"

@interface OBImagePickerViewController(private)
- (Class)registeredTableViewCellClass;
@end

@interface OBCollectionPickerViewController ()
@property(nonatomic, strong) NSArray* collections;
@end

@implementation OBCollectionPickerViewController {

	NSString *collectionCellIdentifier;
	id<OBAssetLibrary> _photoLibrary;
	BOOL _reloadOnViewWillAppear;
}

- (instancetype)initWithLibrary:(id <OBAssetLibrary>)library {
	self = [super init];
	if (self) {
		_photoLibrary = library;
		_reloadOnViewWillAppear = YES;
	}
	return self;

}

- (void)loadView {
	[super loadView];

	collectionCellIdentifier = @"CollectionCellIdentifier";

	self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];
	
	// register custom table view class
	if ([self.navigationController isKindOfClass:[OBImagePickerViewController class]]) {
		OBImagePickerViewController *imagePickerViewController = (OBImagePickerViewController *)self.navigationController;
		[self.tableView registerClass:[imagePickerViewController registeredTableViewCellClass] forCellReuseIdentifier:collectionCellIdentifier];
	} else {
		[self.tableView registerClass:[OBCollectionTableViewCell class] forCellReuseIdentifier:collectionCellIdentifier];
	}

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
	self.navigationItem.leftBarButtonItem = cancelButton;

	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}



- (void)cancelButtonPressed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	// deselect previous selected row
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
	
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

	__weak OBCollectionPickerViewController *weakSelf = self;

	[_photoLibrary fetchCollections:^(NSArray *result, NSError *error) {
	    if (result) {
		    weakSelf.collections = result;
		    [self.tableView reloadData];
	    } else {
		    [weakSelf handleError:error];
	    }
	    _reloadOnViewWillAppear = NO;
	}];
}

- (void)handleError:(NSError *)error {
	if (self.errorHandler) {
		self.errorHandler(error, (OBImagePickerViewController *)self.navigationController);
	} else {
		NSLog(@"Error: %@", [error localizedDescription]);
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.collections count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionCellIdentifier];
	if (indexPath.section > 0) {
		return cell;
	}

	OBCollection *photoCollection = (OBCollection *) [_collections objectAtIndex:indexPath.row];
	cell.textLabel.text = photoCollection.name;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.imageView.image = photoCollection.image;
	cell.detailTextLabel.text = [@(photoCollection.numberOfAssets) stringValue];
	return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	OBCollection *photoCollection = (OBCollection *) [_collections objectAtIndex:indexPath.row];

	OBAssetPickerViewController *photoPickerViewController = [[OBAssetPickerViewController alloc] initWithCollection:photoCollection];
	photoPickerViewController.photoLibrary = _photoLibrary;
	photoPickerViewController.selectionHandler = self.selectionHandler;
	photoPickerViewController.errorHandler = self.errorHandler;
	[self.navigationController pushViewController:photoPickerViewController animated:YES];

}


@end