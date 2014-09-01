//
//  TBCitySBTableViewDelegate.m
//  iCoupon
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBTableViewDelegate.h"
#import "TBCitySBTableViewDataSource.h"
#import "TBCitySBTableViewCell.h"
#import "TBCitySBTableViewItem.h"
#import "TBCitySBTableViewController.h"
#import "TBCitySBListModel.h"

@interface TBCitySBTableViewDelegate()<TBCitySBTableViewCellDelegate>

@end

@implementation TBCitySBTableViewDelegate


////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
    
    _controller = nil;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - uitableView delegate

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Class cls;
    
    if ([tableView.dataSource isKindOfClass:[TBCitySBTableViewDataSource class]]) {
        
        TBCitySBTableViewDataSource* dataSource = (TBCitySBTableViewDataSource*)tableView.dataSource;
        
        TBCitySBTableViewItem* item = [dataSource itemForCellAtIndexPath:indexPath];
        
        if (item.itemHeight > 0) {
            return item.itemHeight;
        }
        else
        {
            cls = [dataSource cellClassForItem:item AtIndex:indexPath];
            
            if ([cls isSubclassOfClass:[TBCitySBTableViewCell class]]) {
                
                return [cls tableView:tableView variantRowHeightForItem:item AtIndex:indexPath];
            }
            else
                return 44;
        }
    }
    else
        return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == self.controller.keyModel.sectionNumber)
    {
        TBCitySBTableViewDataSource* dataSource = (TBCitySBTableViewDataSource*)tableView.dataSource;
        NSArray* items = dataSource.itemsForSection[@(indexPath.section)];
        if (indexPath.row  == items.count - 1 )
            [self.controller loadMore];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.controller tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBCitySBTableViewController* controller = (TBCitySBTableViewController*)self.controller;
    
    if (controller.editing == NO || !indexPath)
        return UITableViewCellEditingStyleNone;
    
    else
		return UITableViewCellEditingStyleDelete;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - scrollview's delegate


- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    [self.controller scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    _bScrolling = NO;
    [self.controller scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.controller scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _bScrolling = YES;
    [self.controller scrollViewWillBeginDragging:scrollView];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableview delegate

- (void)onCellComponentClickedAtIndex:(NSIndexPath *)indexPath Bundle:(NSDictionary *)extra
{
    if(extra == nil)
        return [self.controller tableView:self.controller.tableView didSelectRowAtIndexPath:indexPath];
    
    else
    {
        return [self.controller tableView:self.controller.tableView didSelectRowAtIndexPath:indexPath component:extra];
    }
}


@end
