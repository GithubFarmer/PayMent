//
//  Manager.h
//  PayTest
//
//  Created by 张炯 on 17/5/12.
//  Copyright © 2017年 张炯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

typedef void(^SAPayManagerResponseBlock)(NSInteger responseCode, NSString *responseMsg);

@interface SAPlatformPayManager : NSObject


/**
 
 重要说明
 privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
 
 */



/**
 实例化一个支付管理对象

 @return 支付管理对象
 */
+ (SAPlatformPayManager *)sharePayManager;





/***************支付宝*****************/

/*
 支付宝支付结果回调
 */
@property (nonatomic, strong)SAPayManagerResponseBlock alipayResponseBlock;

/*
 处理支付宝通过URL启动App时传递回来的数据
 */
+ (BOOL)alipayHandleOpenURL:(NSURL *)url;

/*
 发起支付宝支付
 */
- (void)aliPayOrder:(NSString *)order
             scheme:(NSString *)scheme
          responseBlock:(SAPayManagerResponseBlock)block;




/***************微信*******************/





@end
