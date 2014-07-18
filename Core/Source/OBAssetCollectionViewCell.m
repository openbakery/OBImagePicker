//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBDefaultAssetCollectionViewCell.h"
#import "OBAssetCollectionViewCell.h"
#import "OBAsset.h"


@implementation OBAssetCollectionViewCell {

}
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.imageView = [[UIImageView alloc] init];
		[self.contentView addSubview:self.imageView];
	}

	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.imageView.frame = self.contentView.frame;
}


- (void)setAsset:(OBAsset *)asset {
	_asset = asset;
	self.imageView.image = self.asset.thumbnailImage;
}


@end