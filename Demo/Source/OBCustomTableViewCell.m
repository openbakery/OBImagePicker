//
//  OBCustomTableViewCell.m
//  OBImagePicker
//
//  Created by Stefan Gugarel on 23/07/14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//

#import "OBCustomTableViewCell.h"

@implementation OBCustomTableViewCell
{
	UIView *_testView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	if (self) {
		_testView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 10)];
		_testView.backgroundColor = [UIColor redColor];
		[self addSubview:_testView];
	}
	
	return self;
}

@end
