//
//  Manager.m
//  PayTest
//
//  Created by 张炯 on 17/5/12.
//  Copyright © 2017年 张炯. All rights reserved.
//

#import "SAPlatformPayManager.h"

@interface SAPlatformPayManager()<WXApiDelegate>

@end

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
            if(manager.alipayResponseBlock)
            {
                manager.alipayResponseBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(manager.alipayResponseBlock)
            {
                manager.alipayResponseBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(manager.alipayResponseBlock)
            {
                manager.alipayResponseBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(manager.alipayResponseBlock)
            {
                manager.alipayResponseBlock(-99, @"未知错误");
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
       responseBlock:(SAPayManagerResponseBlock)block {
    
    self.alipayResponseBlock = block;
    
    __weak typeof(self) weakSelf = self;
    [[AlipaySDK defaultService] payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        
        NSNumber *code = resultDic[@"resultStatus"];
        
        //回调code
        if(code.integerValue==9000)
        {
            if(weakSelf.alipayResponseBlock)
            {
                weakSelf.alipayResponseBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(weakSelf.alipayResponseBlock)
            {
                weakSelf.alipayResponseBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(weakSelf.alipayResponseBlock)
            {
                weakSelf.alipayResponseBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(weakSelf.alipayResponseBlock)
            {
                weakSelf.alipayResponseBlock(-99, @"未知错误");
            }
        }
        
    }];
    
}




#pragma mark -------
#pragma mark -------  微信支付


+ (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}
+ (BOOL)WXPayRegisterAppWithAppId:(NSString *)appId description:(NSString *)description
{
    return [WXApi registerApp:appId];
}
+ (BOOL)WXPayHandleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[SAPlatformPayManager sharePayManager]];
}
- (void)WXPayWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign respBlock:(SAPayManagerResponseBlock)block
{     
    self.WXPayResponseBlock = block;
    
    if([WXApi isWXAppInstalled])
    {
        PayReq *req = [[PayReq alloc] init];
        req.openID = appId;
        req.partnerId = partnerId;
        req.prepayId = prepayId;
        req.package = package;
        req.nonceStr = nonceStr;
        req.timeStamp = (UInt32)timeStamp.integerValue;
        req.sign = sign;
        [WXApi sendReq:req];
    }
    else
    {
        if(self.WXPayResponseBlock)
        {
            self.WXPayResponseBlock(-3, @"未安装微信");
        }
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]])
    {
        switch (resp.errCode)
        {
            case 0:
            {
                if(self.WXPayResponseBlock)
                {
                    self.WXPayResponseBlock(0, @"支付成功");
                }
                
                NSLog(@"支付成功");
                break;
            }
            case -1:
            {
                if(self.WXPayResponseBlock)
                {
                    self.WXPayResponseBlock(-1, @"支付失败");
                }
                
                NSLog(@"支付失败");
                break;
            }
            case -2:
            {
                if(self.WXPayResponseBlock)
                {
                    self.WXPayResponseBlock(-2, @"支付取消");
                }
                
                NSLog(@"支付取消");
                break;
            }
                
            default:
            {
                if(self.WXPayResponseBlock)
                {
                    self.WXPayResponseBlock(-99, @"未知错误");
                }
            }
                break;
        }
    }
}




@end
