//
//  TBCitySBTableViewDataSource.m
//  iCoupon
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBTableViewDataSource.h"
#import "TBCitySBTableViewDelegate.h"
#import "TBCitySBTableViewController.h"
#import "TBCitySBTableViewCell.h"
#import "TBCitySBTableViewItem.h"
#import "TBCitySBTableViewLoadingCell.h"
#import "TBCitySBTableViewErrorCell.h"
#import "TBCitySBTableViewCustomizedCell.h"
#import "TBCitySBListModel.h"



@interface TBCitySBTableViewDataSource()
{
    //CFMutableDictionaryRef _modelMap;
    NSMutableDictionary* _itemsForSectionInternal;
    NSMutableDictionary* _totalCountForSectionInternal;
    
}

@end

@implementation TBCitySBTableViewDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSDictionary*)itemsForSection
{
    return [_itemsForSectionInternal copy];
}

- (NSDictionary*)totalCountForSection
{
    return [_totalCountForSectionInternal copy];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    
    if (self) {
        _itemsForSectionInternal      = [NSMutableDictionary new];
        _totalCountForSectionInternal = [NSMutableDictionary new];
    }
    return self;
}
- (void)dealloc
{
    _controller = nil;
    [_itemsForSectionInternal removeAllObjects];
    _itemsForSectionInternal = nil;
    
    [_totalCountForSectionInternal removeAllObjects];
    _totalCountForSectionInternal = nil;
    NSLog(@"[%@]--->dealloc",self.class);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (void)setItems:(NSArray*)items ForSection:(NSInteger)n
{
    if(n>=0) {
        if (![items isKindOfClass:[NSMutableArray class]]) {
            [_itemsForSectionInternal setObject:[NSMutableArray arrayWithArray:items] forKey:@(n)];
        }
        else {
            [_itemsForSectionInternal setObject:items forKey:@(n)];
        }
    }
}

- (BOOL)removeObject:(id)object ForSection:(NSInteger)n {
    if (n >= 0 && n < _itemsForSectionInternal.count) {
        NSMutableArray *array = [_itemsForSectionInternal objectForKey:@(n)];
        for (id anyobject in array) {
            if (anyobject == object) {
                [array removeObject:anyobject];
                return YES;
            }
        }
    }
    return NO;
}

- (NSArray *)getItems:(int)section {
    if (section < [_itemsForSectionInternal count]) {
        return _itemsForSectionInternal[@(section)];
    }
    return nil;
}

- (void)removeItemsForSection:(NSInteger)n
{
    if (n>=0) {
        [_itemsForSectionInternal removeObjectForKey:@(n)];
    }
}
- (void)removeAllItems
{
    [_itemsForSectionInternal removeAllObjects];
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableView's dataSource

//子类重载
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* items = _itemsForSectionInternal[@(section)];
    return items.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.controller tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //拿到当前的item
    TBCitySBTableViewItem *item = [self itemForCellAtIndexPath:indexPath];
    //拿到当前cell的类型
    Class cellClass = [self cellClassForItem:item AtIndex:indexPath];
    //拿到name
    NSString* identifier = NSStringFromClass(cellClass);
    //创建cell
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //绑定cell和item
    if ([cell isKindOfClass:[TBCitySBTableViewCell class]])
    {
        TBCitySBTableViewCell* customCell = (TBCitySBTableViewCell*)cell;
        customCell.indexPath = indexPath;
        customCell.delegate  = (id<TBCitySBTableViewCellDelegate>)tableView.delegate;
        
        if (item)
        {
            //为cell,item绑定index
            item.indexPath = indexPath;
            [(TBCitySBTableViewCell *)cell setItem:item];
        }
        else
        {
            //moxin:
            /**
             *  @dicussion:
             *  
             *  These codes are never supposed to be executed.
             *  If it does, it probably means something goes wrong.
             *  For some unpredictable error we display an empty cell with 44 pixel height
             */
            
            TBCitySBTableViewItem* item = [TBCitySBTableViewItem new];
            item.itemType = kItem_Normal;
            item.itemHeight = 44;
            item.indexPath = indexPath;
            [(TBCitySBTableViewCell *)cell setItem:item];
        }
    }
    
    
    
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private

- (UITableViewCell*)tableView:(UITableView *)tableView initCellAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

// item for index
- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray* items = _itemsForSectionInternal[@(indexPath.section)];
    
    TBCitySBTableViewItem* item = nil;
    
    if (indexPath.row < items.count) {
        
        item = items[indexPath.row];
    }
    else
    {
        item = [TBCitySBTableViewItem new];
    }
    return item;
    
}
// cell for index
- (Class)cellClassForItem:(TBCitySBTableViewItem*)item AtIndex:(NSIndexPath *)indexPath
{
    if (item.itemType == kItem_Normal) {
        return [TBCitySBTableViewCell class];
    }
    else if (item.itemType == kItem_Loading) {
        return [TBCitySBTableViewLoadingCell class];
    }
    else if (item.itemType == kItem_Error)
    {
        return [TBCitySBTableViewErrorCell class];
    }
    else if (item.itemType == kItem_Customize)
    {
        return [TBCitySBTableViewCustomizedCell class];
    }
    else
        return [TBCitySBTableViewCell class];
}
// bind model
- (void)tableViewControllerDidLoadModel:(TBCitySBListModel*)model ForSection:(NSInteger)section
{
    
    // set totoal count
    [_totalCountForSectionInternal setObject:@(model.itemList.totalCount) forKey:@(section)];
    
    // set data
    NSMutableArray* items = [model.itemList.array mutableCopy];
    [self setItems:items ForSection:section];
    
}



@end
