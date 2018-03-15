//
//  DetailViewController.m
//  Sales
//
//  Created by hanfeng on 2018/3/15.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import "DetailViewController.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface DetailViewController ()<UIWebViewDelegate>
@property (copy, nonatomic) UIWebView *webView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/4, 0, kMainScreenWidth/2, 64)];
    label.text = @"销售详情";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    [self.view addSubview:self.webView];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"detail" ofType:@"html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    NSString *contentFileName=[[NSString alloc] initWithFormat:@"detail.html"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *mypath = [documentsDirectory stringByAppendingPathComponent:contentFileName];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:mypath encoding:NSUTF8StringEncoding error:nil];
    
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:mypath]];
}

- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, KMainScreenHeight - 64)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}
@end
