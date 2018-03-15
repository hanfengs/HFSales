//
//  SaleViewController.h
//  Sales
//
//  Created by hanfeng on 2018/3/9.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaleViewControllerDelegate<NSObject>

- (void)changeDateValues:(NSString *)dateStr;
- (void)calculateTotal;
@end

@interface SaleViewController : UIViewController

@property (nonatomic, copy) NSString *total;

@property (nonatomic, weak) id<SaleViewControllerDelegate> delegate;

@end
