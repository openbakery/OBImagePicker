#import "TestNavigationController.h"


@implementation TestNavigationController {

}


- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
	[super presentViewController:viewControllerToPresent animated:NO completion:completion];
}


- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
	[super setViewControllers:viewControllers animated:NO];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
	[super dismissViewControllerAnimated:NO completion:completion];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[super pushViewController:viewController animated:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	return [super popViewControllerAnimated:NO];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
	return [super popToViewController:viewController animated:NO];
}


- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
	return [super popToRootViewControllerAnimated:NO];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
	[super dismissModalViewControllerAnimated:NO];
}


@end