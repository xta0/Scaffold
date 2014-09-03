//
//  TBCitySBTableViewCell.m
//  iCoupon
//
//  Created by Jason Wong on 14-1-8.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBTableViewCell.h"


@implementation TBCitySBTableViewCell

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public methods

+ (CGFloat)tableView:(UITableView*)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath*)indexPath
{
    return 44;
}

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
    
    _item = nil;
    _delegate = nil;
}


@end
