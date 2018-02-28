//
//  Utils.m
//  Server
//
//  Created by zjl on 2017/8/7.
//  Copyright © 2017年 zjlzjl. All rights reserved.
//

#import "Utils.h"
//#import "AppDelegate.h"
@implementation Utils
#pragma mark - public method
+ (void)initAlertControllerWithTitle:(NSString *)title msg:(NSString *)msg {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:closeAction];
	[[self topViewController] presentViewController:alert animated:YES completion:nil];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[[self topViewController] dismissViewControllerAnimated:alert completion:nil];
	});
}


+ (UIViewController *)topViewController {
	UIViewController *resultVC;
	resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
	while (resultVC.presentedViewController) {
		resultVC = [self _topViewController:resultVC.presentedViewController];
	}
	return resultVC;
}
#pragma mark - private method



+ (UIViewController *)_topViewController:(UIViewController *)vc {
	if ([vc isKindOfClass:[UINavigationController class]]) {
		return [self _topViewController:[(UINavigationController *)vc topViewController]];
	} else if ([vc isKindOfClass:[UITabBarController class]]) {
		return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
	} else {
		return vc;
	}
	return nil;
}
@end
