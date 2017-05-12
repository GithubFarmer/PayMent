//
//  AppDelegate.m
//  PayTest
//
//  Created by 张炯 on 17/5/11.
//  Copyright © 2017年 张炯. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
   
}


/*********   支付相关   **********/

//iOS9之前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([url.scheme hasPrefix:@"wx"])//微信
    {
        //return [SAPlatformPayManager wechatHandleOpenURL:url];
    }
    else if([url.scheme hasPrefix:@"UnionPay"])//银联
    {
        //return [SAPlatformPayManager unionHandleOpenURL:url];
    }
    else if([url.scheme hasPrefix:@"safepay"])//支付宝
    {
        return [SAPlatformPayManager alipayHandleOpenURL:url];
    }
    
    return YES;
}

//iOS9之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if([url.scheme hasPrefix:@"wx"])//微信
    {
        //return [SAPlatformPayManager wechatHandleOpenURL:url];
    }
    else if([url.scheme hasPrefix:@"UnionPay"])//银联
    {
        //return [SAPlatformPayManager unionHandleOpenURL:url];
    }
    else if([url.scheme hasPrefix:@"safepay"])//支付宝
    {
        return [SAPlatformPayManager alipayHandleOpenURL:url];
    }
    
    return YES;
}


@end
