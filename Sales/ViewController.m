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
#import "MonthSaleViewController.h"
#import "MonthSaleTableCell.h"
#import "Ono.h"

#define TxtUser @"1000000006"
#define TxtPassword @"111111"

#define random 100
#define KStatusBarHeight 64
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, DLTabedSlideViewDelegate, SaleViewControllerDelegate>

@property (nonatomic, copy) NSString *VIEWSTATE;
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *VIEWSTATE3;
@property (nonatomic, copy) NSString *PREVIOUSPAGE3;

@property (nonatomic, assign) NSString *total;//一日销售额
@property (nonatomic, strong) NSMutableArray *monthTotalArrM;//月销售额数组

@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, assign) BOOL is_open;
@property (nonatomic, strong) UITableView *shopTableView;

@property (strong, nonatomic) DLTabedSlideView *tabedSlideView;
@property (nonatomic, strong) SaleViewController *dayVC;
@property (nonatomic, strong) MonthSaleViewController *monthVC;

@end

@implementation ViewController{
    NSArray *shopArr;
    NSDictionary *_param;
    NSString *_selectedDateStr;
    NSString *_currentShopCode;
    dispatch_semaphore_t _semaphore;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self KPSetBackgroundColor:[UIColor colorNamed:@"NavColor"]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:17]}];

    self.view.backgroundColor = [UIColor colorNamed:@"BgColor"];
    _currentShopCode = @"1006";
    
    shopArr = @[@"0000 永旺（北京)", @"1001 国际商城店", @"1002 朝北大悦城店", @"1003 天津泰达店",@"1004 天津中北店", @"1005 天津梅江店", @"1006 丰台店",@"1007 河北燕郊店", @"1008 天津天河城店", @"1009 天津津南店",@"1995 国际商城店(外仓2)", @"1996 北京永旺低温物流中心", @"1997 国际商城店(外仓)",@"1998 虚拟店铺", @"1999 北京永旺物流中心"];
    
    [self loadSignIn];
    
    [self setupNavTitle];
    [self setupSubVC];
}

#pragma mark- subVC
- (void)setupSubVC{
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabItemNormalColor = [UIColor blackColor];
    self.tabedSlideView.tabItemSelectedColor = [UIColor colorNamed:@"totalColor"];//[UIColor colorWithRed:0.833 green:0.052 blue:0.130 alpha:1.000];
    self.tabedSlideView.tabbarTrackColor = [UIColor colorNamed:@"totalColor"];//[UIColor colorWithRed:0.833 green:0.052 blue:0.130 alpha:1.000];
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
            ctrl.delegate = self;
            self.dayVC = ctrl;
            return ctrl;
        }
        case 1:{
            MonthSaleViewController *ctrl = [[MonthSaleViewController alloc] init];
            self.monthVC = ctrl;
            
            ctrl.block_calculate = ^(NSString *monthStr) {
                
                self.monthTotalArrM = nil;
                self.monthVC.allTotal = NO;
                
                //传递按钮点击事件，主线程；所以开子线程
                dispatch_async(dispatch_queue_create(0, 0), ^{
                    self.monthTotalArrM = nil;
                    NSArray *arr = [self dateArrWithMonth:monthStr];
                    _semaphore = dispatch_semaphore_create(0);
                    for (NSInteger i = 0; i < arr.count; i++) {
                        NSString *obj = arr[i];
                        [self postSales2:obj With:YES];
                        NSLog(@"noRequest-%ld",(long)i);
                        if (i == (arr.count - 1)) {
                            //月销售累加的总金额
                            [self allMonthTotal];
                            
                        }
                    }
                });
            };
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
    [titleBtn setTitle:@"1006 丰台店" forState:UIControlStateNormal];
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
    
    _currentShopCode = [title substringToIndex:4];
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
//                NSLog(@"%@", string);
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
//                NSLog(@"%@", string);
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
        _param = [self paramFormSales1:string];
        
    }] resume];
}

- (NSDictionary *)paramFormSales1:(NSString *)str{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    
    NSArray *arr1 = [str componentsSeparatedByString:@"Sales1.aspx?GUID="];
    if (arr1.count > 0) {
        NSArray *arr = [arr1.lastObject componentsSeparatedByString:@"\" id="];
        if (arr.count > 0) {
            NSString *string = arr.firstObject;
            [dictM setValue:string forKey:@"GUID"];
        }
    }
    
    NSArray *arr2 = [str componentsSeparatedByString:@"__VIEWSTATE\" value=\""];
    if (arr2.count > 0) {
        NSArray *arr = [arr2.lastObject componentsSeparatedByString:@"\" />"];
        if (arr.count > 0) {
            NSString *string = arr.firstObject;
            [dictM setValue:string forKey:@"__VIEWSTATE"];
        }
    }
    
    NSArray *arr3 = [str componentsSeparatedByString:@"__PREVIOUSPAGE\" value=\""];
    if (arr3.count > 0) {
        NSArray *arr = [arr3.lastObject componentsSeparatedByString:@"\" />"];
        if (arr.count > 0) {
            NSString *string = arr.firstObject;
            [dictM setValue:string forKey:@"__PREVIOUSPAGE"];
        }
    }
    
    NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *cookieDict = [NSHTTPCookie requestHeaderFieldsWithCookies:cookiesArray];
    NSString *cookie = [cookieDict objectForKey:@"Cookie"];
    
    NSArray *arr4 = [cookie componentsSeparatedByString:@"ASP.NET_SessionId="];
    if (arr4.count > 0) {
        NSString *string = arr4.lastObject;
        [dictM setValue:string forKey:@"sessionId"];
    }
    
    return dictM.copy;
}

//_param拿到所有参数，可以获取销售数据了sales2
- (void)postSales2:(NSString *)dateStr With:(BOOL)isMonth{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.aeonweb.cn/AeonABJ/Pages/Sales2.aspx?GUID=%@", _param[@"GUID"]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *paraStr = [NSString stringWithFormat:@"__EVENTTARGET=""&__EVENTARGUMENT=""&__VIEWSTATE=%@&__PREVIOUSPAGE=%@&ShopList1$ddlShopList=%@&Txt_OrderDate1=%@&Txt_OrderDate2=%@&Txt_ITCO1=""&Txt_ITCO2=""&btnSearch=查询(SEARCH)", _param[@"__VIEWSTATE"], _param[@"__PREVIOUSPAGE"], _currentShopCode, dateStr, dateStr];
    
    NSString *para1 = [paraStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //[para4 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *para2 = [para1 stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    NSString *para3 = [para2 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *para4 = [para3 stringByReplacingOccurrencesOfString:@"(" withString:@"%28"];
    NSString *para5 = [para4 stringByReplacingOccurrencesOfString:@")" withString:@"%29"];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [para5 dataUsingEncoding:NSUTF8StringEncoding];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRange range = [string rangeOfString:@"<title>"];//匹配得到的下标

        NSMutableString* str =[[NSMutableString alloc]initWithString:string];
        [str insertString:@"<meta charset=\"utf-8\">" atIndex:range.location];

        NSString *contentFileName=[[NSString alloc] initWithFormat:@"detail.html"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *mypath = [documentsDirectory stringByAppendingPathComponent:contentFileName];
//        NSLog(@"===%@", mypath);
        [str writeToFile:mypath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        if (isMonth) {//月销售额
            MonthSaleModel *model = [[MonthSaleModel alloc] init];
            model.day = dateStr;
            model.total = [self html:data];
           
            NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.monthTotalArrM];
            [arrM addObject:model];
            self.monthTotalArrM = arrM;
            dispatch_semaphore_signal(_semaphore);
            NSLog(@"===X==%@", [NSThread currentThread]);
            
        }else{//日销售额
            self.total = [self html:data];
        }        
    }] resume];
    
    if (isMonth) {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    }
}

#pragma mark- 计算金额
- (void)setMonthTotalArrM:(NSMutableArray *)monthTotalArrM{
    _monthTotalArrM = monthTotalArrM;
    
    self.monthVC.monthArr = monthTotalArrM;
}

- (void)allMonthTotal{
    
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.monthTotalArrM];
    
    MonthSaleModel *model = [[MonthSaleModel alloc] init];
    model.day = @"总金额：";
    model.total = [self monthAllTotal:self.monthTotalArrM];
    
    [arrM addObject:model];
    
    self.monthVC.allTotal = YES;
    self.monthTotalArrM = arrM;
}

- (NSString *)monthAllTotal:(NSArray *)arr{
    
    NSDecimalNumber *sum = [[NSDecimalNumber alloc] initWithString:@"0"];
    for (MonthSaleModel *obj in arr) {
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:obj.total];
        sum = [sum decimalNumberByAdding:dn];
    }
    return [NSString stringWithFormat:@"%@元", sum];
}

#pragma mark- html解析
//日销售额
- (NSString *)html:(NSData *)data{

    NSError *error;
    ONOXMLDocument *document = [ONOXMLDocument HTMLDocumentWithData:data error:&error];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    NSString *xpath = @"//body/form/table/tr";
    [document enumerateElementsWithXPath:xpath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        
//        NSLog(@"%@: %@===%@", element.tag, element.attributes, [element stringValue]);
        
        NSArray *arr = element.children;
        ONOXMLElement *celement = arr[5];
        
        NSString *cost = [celement stringValue];
        if (![cost isEqualToString:@"金额"]) {
            [arrM addObject:[celement stringValue]];
        }
    }];
    
    NSDecimalNumber *sum = [[NSDecimalNumber alloc] initWithString:@"0"];
    for (NSInteger i = 0; i < arrM.count; i++) {
        
        NSString *costStr = arrM[i];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:costStr];
        sum = [sum decimalNumberByAdding:dn];
    }
    return [NSString stringWithFormat:@"%@元", sum];
}

- (void)setTotal:(NSString *)total{
    _total = total;    
    self.dayVC.total = total;
}

#pragma mark- 代理方法

- (void)changeDateValues:(NSString *)dateStr{
    
    _selectedDateStr = dateStr;
}
- (void)calculateTotal{
    
    self.total = @"...";
    [self postSales2:_selectedDateStr With:NO];
}

#pragma mark-


// yearMonth为空是本月，不为空是之前的月
- (NSArray *)dateArrWithMonth:(NSString *)yearMonth{
    
    NSUInteger count = 0;
    NSMutableArray *arrM = [NSMutableArray array];
    if (yearMonth) {
        NSString *year = [yearMonth substringToIndex:4];
        NSString *month = [yearMonth substringFromIndex:yearMonth.length - 2];
        count = [self NSStringIntTeger:month.integerValue andYear:year.integerValue];
        for (NSInteger i = 1; i <= count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@/%@/%02ld", year, month, (long)i];
            [arrM addObject:str];
        }
    }else{
        NSString *current = [self getCurrentTime];
        
        NSString *year = [current substringToIndex:4];
        NSString *month = [current substringWithRange:NSMakeRange(5, 2)];
        NSString *day =  [current substringFromIndex:current.length - 2];
        count = day.integerValue - 1;
        for (NSInteger i = 1; i <= count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@/%@/%02ld", year, month, (long)i];
            [arrM addObject:str];
        }
    }
    return arrM.copy;
}
- (NSInteger)NSStringIntTeger:(NSInteger)teger andYear:(NSInteger)year{
    
    NSInteger dayCount;
    switch (teger) {
        case 1:
            dayCount = 31;
            break;
        case 2:
            if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
                dayCount = 29;
            }else{
                dayCount = 28;
            }
            break;
        case 3:
            dayCount = 31;
            break;
        case 4:
            dayCount = 30;
            break;
        case 5:
            dayCount = 31;
            break;
        case 6:
            dayCount = 30;
            break;
        case 7:
            dayCount = 31;
            break;
        case 8:
            dayCount = 31;
            break;
        case 9:
            dayCount = 30;
            break;
        case 10:
            dayCount = 31;
            break;
        case 11:
            dayCount = 30;
            break;
        default:
            dayCount = 31;
            break;
    }
    return dayCount;
}

- (NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

#pragma mark- nav

- (void)KPSetBackgroundColor:(UIColor *)color{
    
    UIImage *img = [self createImageWithColor:color size:CGSizeMake(1, 1)];

    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
}

-(UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
