//
//  TBCitySBItemList.m
//  iCoupon
//
//  Created by Jason Wong on 14-1-2.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBItemList.h"

@implementation TBCitySBItemList
@synthesize array = _array;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSMutableArray

+ (id)array {
    return [[TBCitySBItemList alloc] init];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Get

- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    
    return _array;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (void)reset {
    self.currentPage = 0;
    self.totalCount = 0;
    self.havNextPage = NO;
    [self removeAllObjects];
}

- (void)resetForLoadType:(TBCitySBItemListLoadType)loadType {
    if (loadType == TBCitySBItemListLoadTypeRefresh) {
        self.currentPage = 0;
        self.totalCount = 0;
        self.havNextPage = NO;
    } else {
        [self reset];
    }
}

- (BOOL)hasMore {
    return self.currentPage * self.pageSize < self.totalCount;
}


- (NSUInteger)count {
    return self.array.count;
}

- (id)objectAtIndex:(NSUInteger)index{
    return  [self.array objectAtIndex:index];
}

- (void)addObject:(id)anObject{
    [self.array addObject:anObject];
}

- (void)addObjectsFromArray:(NSArray *)otherArray{
    [self.array addObjectsFromArray:otherArray];
}

- (void)removeAllObjects{
    [self.array removeAllObjects];
}

- (void)removeObject:(id)anObject{
    [self.array  removeObject:anObject];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state objects:buffer count:len];
}

@end
