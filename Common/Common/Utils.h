//
//  Utils.h
//  Server
//
//  Created by zjl on 2017/8/7.
//  Copyright © 2017年 zjlzjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Utils : NSObject


+ (void)initAlertControllerWithTitle:(NSString *)title msg:(NSString *)msg;


+ (UIViewController *)topViewController;


+ (NSString *)getIPAddress;
@end
