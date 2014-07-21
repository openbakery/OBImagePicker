//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBCustomAssetCollectionViewCell.h"


@implementation OBCustomAssetCollectionViewCell {

}


- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];

	CALayer *layer = self.imageView.layer;

	if (selected) {
		layer.borderWidth = 5.0f;
		layer.borderColor = [UIColor redColor].CGColor;
	} else {
		layer.borderWidth = 0;
	}

}


@end