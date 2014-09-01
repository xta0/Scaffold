//
//  TBCitySBItemList.h
//  iCoupon
//
//  Created by Jason Wong on 14-1-2.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, TBCitySBItemListLoadType) {
    TBCitySBItemListLoadTypeDefault,
    TBCitySBItemListLoadTypeLoadMore,
    TBCitySBItemListLoadTypeRefresh
};

@protocol TBCitySBMockedNSMutableArray <NSObject>

+ (id)array;

@optional
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (void)addObject:(id)anObject;
- (void)addObjectsFromArray:(NSArray *)otherArray;
- (void)removeAllObjects;
- (void)removeObject:(id)anObject;

@end

@interface TBCitySBItemList : NSObject <TBCitySBMockedNSMutableArray, NSFastEnumeration>

@property (nonatomic, readonly) NSMutableArray  *array;
@property (nonatomic, assign) NSUInteger        currentPage;
@property (nonatomic, assign) long              totalCount;
@property (nonatomic, assign) NSUInteger        pageSize;
@property (nonatomic, assign) BOOL              havNextPage;

/**
 *  重置所有，包括清空array
 */
- (void)reset;

/**
 *  重置，传入加载类型。例如传出Refresh，那么重置，但不清空array，否则reset所有
 *
 *  @param loadType TBCitySBItemListLoadType
 */
- (void)resetForLoadType:(TBCitySBItemListLoadType)loadType;
- (BOOL)hasMore;

@end