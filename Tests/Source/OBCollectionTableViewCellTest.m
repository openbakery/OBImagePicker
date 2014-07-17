//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBCollectionTableViewCell.h"

#define HC_SHORTHAND
#import <OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface OBCollectionTableViewCellTest : XCTestCase
@end

@implementation OBCollectionTableViewCellTest {
	OBCollectionTableViewCell *_cell;
}

- (void)setUp {
	_cell = [[OBCollectionTableViewCell alloc] init];
	_cell.frame = CGRectMake(0, 0, 320, 86);
}

- (void)testImageViewSize {
	[_cell layoutSubviews];
	assertThatFloat(_cell.imageView.frame.origin.x, is(@9.0));
	assertThatFloat(_cell.imageView.frame.origin.y, is(@9.0));
	assertThatFloat(_cell.imageView.frame.size.width, is(@68));
	assertThatFloat(_cell.imageView.frame.size.height, is(@68));

}

- (void)testTextLabel {
	[_cell layoutSubviews];

	CGFloat x = 96.0;
	CGFloat y = 22.0;

	assertThatFloat(_cell.textLabel.frame.origin.x, is(@(x)));
	assertThatFloat(_cell.textLabel.frame.origin.y, is(@(y)));
	assertThatFloat(_cell.textLabel.frame.size.width, is(@(320-x-40.0)));
	assertThatFloat(_cell.textLabel.frame.size.height, is(@(22.0)));


}

- (void)testDetailTextLabel {
	[_cell layoutSubviews];

	CGFloat x = 96.0;
	CGFloat y = 46.0;

	assertThatFloat(_cell.detailTextLabel.frame.origin.x, is(@(x)));
	assertThatFloat(_cell.detailTextLabel.frame.origin.y, is(@(y)));
	assertThatFloat(_cell.detailTextLabel.frame.size.width, is(@(320-x-40.0)));
	assertThatFloat(_cell.detailTextLabel.frame.size.height, is(@(18.0)));


}



@end