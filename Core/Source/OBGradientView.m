//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBGradientView.h"


@implementation OBGradientView {

	UIColor *_startColor;
	UIColor *_endColor;
}

- (id)initWithFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		_startColor = startColor;
		_endColor = endColor;
		[self setupGradientLayer];
	}

	return self;
}

- (void)setupGradientLayer {
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.bounds;

	NSArray *colors = @[
		(id) _startColor.CGColor,
		(id) _endColor.CGColor,
	];

	gradient.colors = colors;
	[self.layer insertSublayer:gradient atIndex:0];
}



@end