//
//  MonthSaleViewController.m
//  Sales
//
//  Created by hanfeng on 2018/3/13.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import "MonthSaleViewController.h"
#import "QFDatePickerView.h"
#import "MonthSaleTableCell.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MonthSaleViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *tf_month;
@property (weak, nonatomic) IBOutlet UILabel *lbl_month;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MonthSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lbl_month.text = [self getCurrentTime:[NSDate date]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMonthPicker:)];
    self.lbl_month.userInteractionEnabled = YES;
    [self.lbl_month addGestureRecognizer:tap];
    
    MonthSaleModel *model = [[MonthSaleModel alloc] init];
    model.day = @"2018-03-12";
    model.total = @"10000元";
    
//    self.arr = nil;//@[model];
  //@[@"0000", @"1001", @"1002", @"1003",@"1004", @"1005", @"1006",@"1007 ", @"1008", @"1009",@"1995", @"1996", @"1997",@"1998", @"1999"];
    
    [self.view addSubview:self.tableView];
}

- (void)setMonthArr:(NSArray *)monthArr{
    _monthArr = monthArr;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
        if (self.allTotal) {
            self.btn.userInteractionEnabled = YES;
            [self.btn setTitle:@"计算该月销售总金额" forState:UIControlStateNormal];
        }
    });
}

#pragma mark-

- (UITableView *)tableView{
    if (_tableView == nil) {
        
        CGFloat y = CGRectGetMaxY(self.btn.frame);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, kMainScreenWidth, KMainScreenHeight - y - 64 - 40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.rowHeight = 30;
        
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.monthArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MonthSaleTableCell *cell = [MonthSaleTableCell createCellWithTableView:tableView];
    cell.model = self.monthArr[indexPath.row];
    return cell;
}

#pragma mark-
-(void)handleMonthPicker:(UITapGestureRecognizer *)sender{
    
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {

        if (![str isEqualToString:@"至今"]) {
            self.lbl_month.text = str;
        }
    }];
    [datePickerView show];
}

- (NSString *)getCurrentTime:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:date];
    return [dateTime substringToIndex:7];
}

- (IBAction)clickBtn:(id)sender {
    
    self.monthArr = nil;
    self.allTotal = NO;
    self.btn.userInteractionEnabled = NO;
    [self.btn setTitle:@"计算中..." forState:UIControlStateNormal];
    
    if (self.block_calculate) {
        
        NSString *thisMonth = [self getCurrentTime:[NSDate date]];
        if ([self.lbl_month.text isEqualToString:thisMonth]) {//本月
            self.block_calculate(nil);
        }else{//之前的月
            self.block_calculate(self.lbl_month.text);
        }
    }
}

@end


