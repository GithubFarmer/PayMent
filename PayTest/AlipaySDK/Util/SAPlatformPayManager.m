//
//  Manager.m
//  PayTest
//
//  Created by 张炯 on 17/5/12.
//  Copyright © 2017年 张炯. All rights reserved.
//

#import "SAPlatformPayManager.h"

@implementation SAPlatformPayManager

+ (SAPlatformPayManager *)sharePayManager {
    static SAPlatformPayManager *payManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payManager = [[SAPlatformPayManager alloc] init];
    });
    return payManager;
}

#pragma mark -------
#pragma mark -------  支付宝支付

+ (BOOL)alipayHandleOpenURL:(NSURL *)url {

    // 支付跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        SAPlatformPayManager *manager = [SAPlatformPayManager sharePayManager];
        NSNumber *code = resultDic[@"resultStatus"];
        
        if(code.integerValue==9000)
        {
            if(manager.alipayResponeBlock)
            {
                manager.alipayResponeBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(manager.alipayResponeBlock)
            {
                manager.alipayResponeBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(manager.alipayResponeBlock)
            {
                manager.alipayResponeBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(manager.alipayResponeBlock)
            {
                manager.alipayResponeBlock(-99, @"未知错误");
            }
        }
        
    }];
    
    // 授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
    }];

    
    return YES;
}

- (void)aliPayOrder:(NSString *)order
             scheme:(NSString *)scheme
       responeBlock:(SAPayManagerResponeBlock)block {
    
    self.alipayResponeBlock = block;
    
    __weak typeof(self) weakSelf = self;
    [[AlipaySDK defaultService] payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        
        NSNumber *code = resultDic[@"resultStatus"];
        
        //回调code
        if(code.integerValue==9000)
        {
            if(weakSelf.alipayResponeBlock)
            {
                weakSelf.alipayResponeBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(weakSelf.alipayResponeBlock)
            {
                weakSelf.alipayResponeBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(weakSelf.alipayResponeBlock)
            {
                weakSelf.alipayResponeBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(weakSelf.alipayResponeBlock)
            {
                weakSelf.alipayResponeBlock(-99, @"未知错误");
            }
        }
        
    }];
    
    
}

@end
