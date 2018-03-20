//
//  SaleViewController.m
//  Sales
//
//  Created by hanfeng on 2018/3/9.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import "SaleViewController.h"
#import "DetailViewController.h"

@interface SaleViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_total;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property(nonatomic,weak) UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *btn_detail;

@end

@implementation SaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn_detail.hidden = YES;
    
    NSDate *yesterday = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]];
    
    self.tf_date.text = [self getCurrentTime:yesterday];
    if (@available(iOS 11.0, *)) {
        self.tf_date.textColor = [UIColor colorNamed:@"NavColor"];
        self.btn.backgroundColor = [UIColor colorNamed:@"NavColor"];
    } else {
        // Fallback on earlier versions
        self.tf_date.textColor = UIColorFromRGB(NavColor);
        self.btn.backgroundColor = UIColorFromRGB(NavColor);
    }
    
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode =  UIDatePickerModeDate;
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    [picker addTarget:self action:@selector(DatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.tf_date.inputView = picker;
    self.myDatePicker = picker;
    
    [self setCurrentDate:yesterday];
}

- (void)DatePickerValueChanged:(UIDatePicker *)sender{
    
    NSComparisonResult result = [sender.date compare:[NSDate date]];
    if (result != NSOrderedDescending) {
        self.tf_date.text = [self getCurrentTime:sender.date];
        
        [self setCurrentDate:sender.date];
    }
}

- (void)setCurrentDate:(NSDate *)date{
    
    NSString *dateStr1 = [self getCurrentTime:date];
    NSString *dateStr2 = [dateStr1 stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    if ([self.delegate respondsToSelector:@selector(changeDateValues:)]) {
        [self.delegate changeDateValues:dateStr2];
    }
}

- (void)setTotal:(NSString *)total{
    _total = total;
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        self.lbl_total.text = [NSString stringWithFormat:@"总金额：%@", total];
        
        if (![total isEqualToString:@"..."]) {
            self.btn.userInteractionEnabled = YES;
            [self.btn setTitle:@"计算该日销售总金额" forState:UIControlStateNormal];
            
            self.btn_detail.hidden = NO;
//            [self.btn_detail setTitle:@"详情" forState:UIControlStateNormal];
        }
    });
}
- (IBAction)clickBtnTotal:(id)sender {
    
    self.btn.userInteractionEnabled = NO;
    [self.btn setTitle:@"计算中..." forState:UIControlStateNormal];
    self.btn_detail.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(calculateTotal)]) {
        [self.delegate calculateTotal];
    }
}
- (IBAction)clickBtnDetail:(id)sender {
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)getCurrentTime:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
