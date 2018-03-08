//
//  ViewController.m
//  Sales
//
//  Created by hanfeng on 2018/3/7.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import "ViewController.h"
#import "PPNetworkHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *url = @"http://www.aeonweb.cn/AeonABJ/SignIn.aspx";
//    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
//        //请求成功
//        NSLog(@"%@",responseObject);
//    } failure:^(NSError *error) {
//        //请求失败
//    }];
    
    [self loadXML];
}

- (void)loadXML{
    
    NSURL *url = [NSURL URLWithString:@"http://www.aeonweb.cn/AeonABJ/SignIn.aspx"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
        
    }] resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
