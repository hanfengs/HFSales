//
//  ViewController.m
//  Sales
//
//  Created by hanfeng on 2018/3/7.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import "ViewController.h"
#import "PPNetworkHelper.h"
#import "DLTabedSlideView.h"
#import "SaleViewController.h"

#define TxtUser @"1000000006"
#define TxtPassword @"111111"

#define random 100
#define KStatusBarHeight 64
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, DLTabedSlideViewDelegate>

@property (nonatomic, copy) NSString *VIEWSTATE;
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy)NSString *VIEWSTATE3;
@property (nonatomic, copy)NSString *PREVIOUSPAGE3;

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, assign) BOOL is_open;
@property (nonatomic, strong) UITableView *shopTableView;

@property (strong, nonatomic) DLTabedSlideView *tabedSlideView;
@end

@implementation ViewController{
    NSArray *shopArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorNamed:@"NavColor"]];
    self.view.backgroundColor = [UIColor colorNamed:@"BgColor"];
    
    shopArr = @[@"0000 永旺（北京)", @"1001 国际商城店", @"1002 朝北大悦城店", @"1003 天津泰达店",@"1004 天津中北店", @"1005 天津梅江店", @"1006 丰台店",@"1007 河北燕郊店", @"1008 天津天河城店", @"1009 天津津南店",@"1995 国际商城店(外仓2)", @"1996 北京永旺低温物流中心", @"1997 国际商城店(外仓)",@"1998 虚拟店铺", @"1999 北京永旺物流中心"];
    
//    [self loadSignIn];
//    [self postSignIn];
    
    [self setupNavTitle];
    [self setupSubVC];
}

#pragma mark- subVC

- (void)setupSubVC{
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabItemNormalColor = [UIColor blackColor];
    self.tabedSlideView.tabItemSelectedColor = [UIColor redColor];//[UIColor colorWithRed:0.833 green:0.052 blue:0.130 alpha:1.000];
    self.tabedSlideView.tabbarTrackColor = [UIColor redColor];//[UIColor colorWithRed:0.833 green:0.052 blue:0.130 alpha:1.000];
    //    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@"mask_navbar"];
    self.tabedSlideView.tabbarBottomSpacing = 0;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"按日查询" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"按月查询" image:nil selectedImage:nil];
    
    self.tabedSlideView.tabbarItems = @[item1, item2];
    [self.tabedSlideView buildTabbar];
    
    self.tabedSlideView.selectedIndex = 0;
}

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 2;
}

- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:{
            SaleViewController *ctrl = [[SaleViewController alloc] init];
//                        ctrl.view.backgroundColor = [UIColor redColor];
            return ctrl;
        }
        case 1:{
            SaleViewController *ctrl = [[SaleViewController alloc] init];
//                        ctrl.view.backgroundColor = [UIColor greenColor];
            return ctrl;
        }
        default:
            return nil;
    }
}

- (DLTabedSlideView *)tabedSlideView{
    if (_tabedSlideView == nil) {
        _tabedSlideView = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, KStatusBarHeight, kMainScreenWidth, KMainScreenHeight - 64)];
        _tabedSlideView.delegate = self;
        [self.view addSubview:_tabedSlideView];
    }
    return _tabedSlideView;
}

#pragma mark- Nav
- (void)setupNavTitle{
    
    UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    [titleBtn setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn setTitle:@"0000 永旺（北京)" forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    titleBtn.imageView.contentMode = UIViewContentModeCenter;
    titleBtn.imageView.clipsToBounds = NO;
    [titleBtn addTarget:self action:@selector(clickbtn_titleView) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleButton = titleBtn;
    self.navigationItem.titleView = titleBtn;
}

- (void)clickbtn_titleView{
    self.is_open = !self.is_open;
}

- (void)setIs_open:(BOOL)is_open{
    _is_open = is_open;
    
    if (is_open == YES) {
        self.titleButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.view addSubview:self.shopTableView];
  
    }else{
        self.titleButton.imageView.transform = CGAffineTransformIdentity;
        [self.shopTableView removeFromSuperview];
    }
}

#pragma mark- tableview
- (UITableView *)shopTableView{
    if (_shopTableView == nil) {
        
        _shopTableView = [[UITableView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 240) / 2, 64, 240, 400) style:UITableViewStylePlain];
        _shopTableView.delegate = self;
        _shopTableView.dataSource = self;
        _shopTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _shopTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return shopArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopTableView"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = shopArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.is_open = !self.is_open;
    
    NSString *title = shopArr[indexPath.row];
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    
#warning TODO
}
#pragma mark- 网络
- (void)loadSignIn{
    
    NSURL *url = [NSURL URLWithString:@"http://www.aeonweb.cn/AeonABJ/SignIn.aspx"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSArray *arr = [string componentsSeparatedByString:@"value=\""];
        if (arr.count > 0) {
            NSArray *arr1 = [arr.lastObject componentsSeparatedByString:@"\" />"];
            if (arr1.count > 0) {
                NSString *string = arr1.firstObject;
                NSLog(@"%@", string);
                self.VIEWSTATE = string;
            }
        }
        
    }] resume];
    
}

- (void)setVIEWSTATE:(NSString *)VIEWSTATE{
    _VIEWSTATE = VIEWSTATE;
    
    [self postSignIn];
}

- (void)postSignIn{
    
    NSURL *url = [NSURL URLWithString:@"http://www.aeonweb.cn/AeonABJ/SignIn.aspx"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *x = [NSString stringWithFormat:@"%u", arc4random_uniform(random)];
    NSString *y = [NSString stringWithFormat:@"%u", arc4random_uniform(random)];
    
    NSString *paraStr = [NSString stringWithFormat:@"__VIEWSTATE=%@&TxtUser=%@&TxtPassword=%@&btnLogin.x=%@&btnLogin.y=%@", self.VIEWSTATE, TxtUser, TxtPassword, x, y];
    
    NSString *para1 = [paraStr stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    NSString *para2 = [para1 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
//    NSData *data = [paraStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *param = [data base64Encoding]; // base64格式的字符串
    
//    NSString *para = @"__VIEWSTATE=%2FwEPDwUKLTQ0MDE5NTAzOA9kFgICAw9kFgICAQ8PFgIeBFRleHQFLeawuOaXuu%2B8iOWMl%2BS6rO%2B8ieS%2Bm%2BW6lOWVhuS%2FoeaBr%2BS6pOa1geezu%2Be7n2RkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYBBQhidG5Mb2dpbm38j8VD5qxO%2FTVgUufwEVrz%2BkMD&TxtUser=1000000006&TxtPassword=111111&btnLogin.x=58&btnLogin.y=14";
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [para2 dataUsingEncoding:NSUTF8StringEncoding];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSArray *arr = [string componentsSeparatedByString:@"ShowNotify.aspx?GUID="];
        if (arr.count > 0) {
            NSArray *arr1 = [arr.lastObject componentsSeparatedByString:@"\" id="];
            if (arr1.count > 0) {
                NSString *string = arr1.firstObject;
                NSLog(@"%@", string);
                self.GUID = string;
            }
        }
        
    }] resume];
}

- (void)setGUID:(NSString *)GUID{
    _GUID = GUID;
    
    [self getSales1];
}

- (void)getSales1{
    
    //http://www.aeonweb.cn/AeonABJ/Pages/Sales1.aspx?GUID=593013090318
    NSString *url = [NSString stringWithFormat:@"http://www.aeonweb.cn/AeonABJ/Pages/Sales1.aspx?GUID=%@",self.GUID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", string);
        
        
        
    }] resume];

}

#pragma mark- 测试
//框架会自动反序列化，而这里无法不是接口，从网页XML中提取
- (void)postSignIn2{
    
    NSString *url = @"http://www.aeonweb.cn/AeonABJ/SignIn.aspx";
    
    NSString *x = [NSString stringWithFormat:@"%u", arc4random_uniform(random)];
    NSString *y = [NSString stringWithFormat:@"%u", arc4random_uniform(random)];
    
    NSString *para = [NSString stringWithFormat:@"__VIEWSTATE=%@&TxtUser=%@&TxtPassword=%@&btnLogin.x=%@&btnLogin.y=%@", self.VIEWSTATE, TxtUser, TxtPassword, x, y];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.VIEWSTATE, @"__VIEWSTATE",
                           TxtUser, @"TxtUser",
                           TxtPassword, @"TxtPassword",
                           x, @"btnLogin.x",
                           y, @"btnLogin.y",
                           nil];
    
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        
        //        NSRange range = [string rangeOfString:@"value=\"/"];
        //        if (range.location != NSNotFound) {
        //            NSString *__VIEWSTATE = [string substringWithRange:range];
        //            NSLog(@"%@", __VIEWSTATE);
        //        }
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
