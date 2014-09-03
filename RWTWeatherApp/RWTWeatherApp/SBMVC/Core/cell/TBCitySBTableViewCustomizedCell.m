//
//  TBCitySBTableViewCustomizedCell.m
//  iCoupon
//
//  Created by moxin.xt on 14-1-16.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBTableViewCustomizedCell.h"
#import "TBCitySBCustomizedTableViewItem.h"
@implementation TBCitySBTableViewCustomizedCell
{
    UILabel* _label;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _label = [[UILabel alloc]initWithFrame:self.contentView.bounds];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor grayColor];
        _label.font = [UIFont systemFontOfSize:16.0f];
        _label.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_label];
        
    }
    return self;
}

- (void)setItem:(TBCitySBCustomizedTableViewItem *)item
{
    [super setItem:item];
    
    if (item) {
        _label.text = item.text;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
