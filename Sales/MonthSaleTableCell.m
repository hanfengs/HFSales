//
//  MonthSaleTableCell.m
//  Sales
//
//  Created by hanfeng on 2018/3/14.
//  Copyright © 2018年 hanfeng. All rights reserved.
//

#import "MonthSaleTableCell.h"

@implementation MonthSaleModel

@end

@interface MonthSaleTableCell()

@property (weak, nonatomic) IBOutlet UILabel *lbl_day;
@property (weak, nonatomic) IBOutlet UILabel *lbl_total;

@end

@implementation MonthSaleTableCell


+ (MonthSaleTableCell *)createCellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"MonthSaleTableCell";
    MonthSaleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MonthSaleTableCell" owner:self options:nil] lastObject];
        if (@available(iOS 11.0, *)) {
            cell.backgroundColor = [UIColor colorNamed:@"BgColor"];
        } else {
            cell.backgroundColor = UIColorFromRGB(BgColor);
        }
    }
    return cell;
}


- (void)setModel:(MonthSaleModel *)model{
    _model = model;
    
    self.lbl_day.text = model.day;
    self.lbl_total.text = model.total;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (@available(iOS 11.0, *)) {
        self.lbl_day.textColor = [UIColor colorNamed:@"totalColor"];
        self.lbl_total.textColor = [UIColor colorNamed:@"totalColor"];
    } else {
        self.lbl_day.textColor = UIColorFromRGB(totalColor);
        self.lbl_total.textColor = UIColorFromRGB(totalColor);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
