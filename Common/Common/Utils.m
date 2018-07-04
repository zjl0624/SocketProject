//
//  Utils.m
//  Server
//
//  Created by zjl on 2017/8/7.
//  Copyright © 2017年 zjlzjl. All rights reserved.
//
#import <ifaddrs.h>
#import <arpa/inet.h>
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

// 获取设备IP地址
+(NSString *)getIPAddress {
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	// 检索当前接口,在成功时,返回0
	success = getifaddrs(&interfaces);
	if (success == 0) {
		// 循环链表的接口
		temp_addr = interfaces;
		while(temp_addr != NULL) {
			if(temp_addr->ifa_addr->sa_family == AF_INET) {
				// 检查接口是否en0 wifi连接在iPhone上
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
					// 得到NSString从C字符串
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			temp_addr = temp_addr->ifa_next;
		}
	}
	// 释放内存
	freeifaddrs(interfaces);
	return address;
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
