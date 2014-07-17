//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBCollectionTableViewCell.h"


@implementation OBCollectionTableViewCell {

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	if (self) {

	}

	return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];

	self.imageView.frame = CGRectMake(9, 9, self.bounds.size.height-18, self.bounds.size.height-18);
	self.textLabel.frame = CGRectMake(96.0, 22.0, self.bounds.size.width-96.0-40.0, 22.0);
	self.detailTextLabel.frame = CGRectMake(96.0, 46.0, self.bounds.size.width-96.0-40.0, 18.0);

}


@end