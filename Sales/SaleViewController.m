//
//  SaleViewController.m
//  Sales
//
//  Created by hanfeng on 2018/3/9.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import "SaleViewController.h"

@interface SaleViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_total;

@property(nonatomic,weak)UIDatePicker *myDatePicker;

@end

@implementation SaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tf_date.text = [self getCurrentTime];
    self.tf_date.textColor = [UIColor colorNamed:@"NavColor"];
    
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode =  UIDatePickerModeDate;
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    self.tf_date.inputView = picker;
    self.myDatePicker = picker;
}

- (void)setTotal:(NSString *)total{
    _total = total;
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        self.lbl_total.text = [NSString stringWithFormat:@"总金额：%@", total];
    });
}
- (IBAction)clickBtnTotal:(id)sender {
    
}

- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
