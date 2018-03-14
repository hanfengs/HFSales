//
//  MonthSaleTableCell.h
//  Sales
//
//  Created by hanfeng on 2018/3/14.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthSaleModel : NSObject

@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *total;

@end

@interface MonthSaleTableCell : UITableViewCell

@property (nonatomic, strong) MonthSaleModel *model;

+ (MonthSaleTableCell *)createCellWithTableView:(UITableView *)tableView;
@end
