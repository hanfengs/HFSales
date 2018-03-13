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

@property(nonatomic,weak) UIDatePicker *myDatePicker;

@end

@implementation SaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tf_date.text = [self getCurrentTime:[NSDate date]];
    self.tf_date.textColor = [UIColor colorNamed:@"NavColor"];
    
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode =  UIDatePickerModeDate;
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    [picker addTarget:self action:@selector(DatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.tf_date.inputView = picker;
    self.myDatePicker = picker;
    
    [self setCurrentDate:[NSDate date]];
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
    });
}
- (IBAction)clickBtnTotal:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(calculateTotal)]) {
        [self.delegate calculateTotal];
    }
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
