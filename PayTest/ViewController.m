//
//  ViewController.m
//  PayTest
//
//  Created by 张炯 on 17/5/11.
//  Copyright © 2017年 张炯. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *AliPayButton;
@property (weak, nonatomic) IBOutlet UIButton *WeChatPayButton;
@property (weak, nonatomic) IBOutlet UIButton *UnionPayButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

//支付宝支付
- (IBAction)AliPayButtonAction:(id)sender {
    
    
    //向服务端发起请求获取orderMessage
    
    NSString *orderMessage = @"app_id=2015052600090779&biz_content=%7B%22timeout_express%22%3A%2230m%22%2C%22seller_id%22%3A%22%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.02%22%2C%22subject%22%3A%221%22%2C%22body%22%3A%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%22314VYGIAGG7ZOYY%22%7D&charset=utf-8&method=alipay.trade.app.pay&sign_type=RSA&timestamp=2016-08-15%2012%3A12%3A15&version=1.0&sign=MsbylYkCzlfYLy9PeRwUUIg9nZPeN9SfXPNavUCroGKR5Kqvx0nEnd3eRmKxJuthNUx4ERCXe552EV9PfwexqW%2B1wbKOdYtDIb4%2B7PL3Pc94RZL0zKaWcaY3tSL89%2FuAVUsQuFqEJdhIukuKygrXucvejOUgTCfoUdwTi7z%2BZzQ%3D";
    NSLog(@"--------------");
    
    
    [[SAPlatformPayManager sharePayManager] aliPayOrder:orderMessage scheme:@"com.zhangjiong.alipay.payTest.scheme" responseBlock:^(NSInteger responseCode, NSString *responseMsg) {
        NSLog(@"----%ld------%@-----",(long)responseCode,responseMsg);
    }];
}


//微信支付
- (IBAction)WeChatPayButtonAction:(id)sender {
    
    //向服务端发起请求获取参数信息等
    
    [[SAPlatformPayManager sharePayManager] WXPayWithAppId:@"wxb4ba3c02aa476ea1" partnerId:@"10000100" prepayId:@"1101000000140415649af9fc314aa427" package:@"Sign=WXPay" nonceStr:@"a462b76e7436e98e0ed6e13c64b4fd1c" timeStamp:@"1397527777" sign:@"582282D72DD2B03AD892830965F428CB16E7A256" respBlock:^(NSInteger responseCode, NSString *responseMsg) {
        NSLog(@"errCode = %zd,errStr = %@",responseCode,responseMsg);
    }];
    
}

//银联支付
- (IBAction)UnionPayButtonAction:(id)sender {
    //向服务端发起请求获取SerialNo
    
    [[SAPlatformPayManager sharePayManager] UPPayWithSerialNo:@"123467562583256" fromScheme:@"com.zhangjiong.payTest.UPPay.scheme" viewController:self responseBlock:^(NSInteger responseCode, NSString *responseMsg) {
        NSLog(@"errCode = %zd,errStr = %@",responseCode,responseMsg);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
