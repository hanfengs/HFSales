//
//  MonthSaleViewController.h
//  Sales
//
//  Created by hanfeng on 2018/3/13.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^calculateMonthTotal)(NSString *);

@interface MonthSaleViewController : UIViewController

@property (nonatomic, strong) NSArray *monthArr;
@property (nonatomic, assign) BOOL allTotal;

@property (nonatomic, copy) calculateMonthTotal block_calculate;

@end
