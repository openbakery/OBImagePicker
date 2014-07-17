
#import "UIBarButtonTestHelper.h"


@implementation UIBarButtonTestHelper {

}


+ (void)performBarButtonAction:(UIBarButtonItem *)button; {
	SEL selector = button.action;
	NSMethodSignature *methodSignature = [[button.target class] instanceMethodSignatureForSelector:selector];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
	[invocation setSelector:selector];
	[invocation setTarget:button.target];
	[invocation invoke];
}


@end