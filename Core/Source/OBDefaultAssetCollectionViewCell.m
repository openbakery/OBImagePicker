//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBDefaultAssetCollectionViewCell.h"
#import "OBAsset.h"
#import "OBGradientView.h"


@implementation OBDefaultAssetCollectionViewCell {
	UIView *_highlighedView;
	OBGradientView *_gradientView;
	UILabel *_durationLabel;
}


- (void)showVideoIndicatorWithDuration:(NSString *)text {
	if (!_gradientView) {
		CGRect frame = CGRectMake(0, self.frame.size.height - 18.0, self.frame.size.width, 18.0);
		UIColor *startColor = [UIColor colorWithWhite:0.0 alpha:0.0];
		UIColor *endColor = [UIColor colorWithWhite:0.0 alpha:0.8];
		_gradientView = [[OBGradientView alloc] initWithFrame:frame startColor:startColor endColor:endColor];

		// get the resource bundle
		NSString *resourceBundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"OBImagePicker" ofType:@"bundle"];
		NSBundle *resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
		NSAssert(resourceBundle, @"Unable to find OBImagePicker resource bundle");
		
		NSString *imagePath = [resourceBundle pathForResource:@"OBVideoIcon" ofType:@"png"];
		UIImage *iconImage = [UIImage imageWithContentsOfFile:imagePath];
		NSAssert(iconImage, @"Unable to find video placeholder image");
		UIImageView *icon = [[UIImageView alloc] initWithImage:iconImage];

		icon.frame = CGRectMake(5, _gradientView.frame.size.height - 5 - iconImage.size.height, iconImage.size.width, iconImage.size.height);
		[_gradientView addSubview:icon];

		_durationLabel = [[UILabel alloc] init];

		CGFloat x = icon.frame.origin.x + icon.frame.size.width;
		_durationLabel.frame = CGRectMake(x, icon.frame.origin.y - 1, _gradientView.frame.size.width - x - 5, icon.frame.size.height + 2);
		[_gradientView addSubview:_durationLabel];
		_durationLabel.textAlignment = NSTextAlignmentRight;
		_durationLabel.textColor = [UIColor whiteColor];
		_durationLabel.font = [UIFont systemFontOfSize:12.0f];
	}
	if (_gradientView.superview != self) {
		[self addSubview:_gradientView];
	}
	_durationLabel.text = text;

}

- (void)setAsset:(OBAsset *)asset {
	[super setAsset:asset];

	if (self.asset.isVideo) {
		NSInteger duration = self.asset.duration;
		int minutes = (int)(duration / 60);
		int seconds = duration % 60;
		NSString *time = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
		[self showVideoIndicatorWithDuration:time];
	} else {
		[_gradientView removeFromSuperview];
	}
}


- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if(selected && !_highlighedView) {
		_highlighedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		_highlighedView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];

		// get the resource bundle
		NSString *resourceBundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"OBImagePicker" ofType:@"bundle"];
		NSBundle *resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
		NSAssert(resourceBundle, @"Unable to find OBImagePicker resource bundle");
		
		NSString *imagePath = [resourceBundle pathForResource:@"OBAssertCheckedImage" ofType:@"png"];
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
		NSAssert(image, @"Unable to find checked image");
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = CGRectOffset(imageView.frame, _highlighedView.frame.size.width-imageView.frame.size.width, _highlighedView.frame.size.height-imageView.frame.size.height);
		[_highlighedView addSubview:imageView];

		[self addSubview:_highlighedView];
	}
	_highlighedView.hidden = !selected;
}


@end