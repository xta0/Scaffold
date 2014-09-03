//
//  TBCitySBTableViewModel.m
//  iCoupon
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBListModel.h"
#import <objc/runtime.h>



@interface TBCitySBListModel ()

@property (nonatomic, assign) TBCitySBItemListLoadType loadType;

@end

@implementation TBCitySBListModel
@synthesize hasMore             = _hasMore;
@synthesize currentPageIndex    = _currentPageIndex;

- (id)init {
    if (self = [super init]) {
        self.pageSize = 20; // 默认
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////
//SBMVC 1.1 : 修改返回值为BOOL
- (BOOL)parse:(id)JSON {
    NSError *error = nil;
    
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        [self requestDidFailWithError:[NSError errorWithDomain:TBCitySBMVCErrorDomain code:kParseJSONError userInfo:@{NSLocalizedDescriptionKey:@"JSON类型错误"}]];
        return NO;
    }
    else
    {
        NSArray *list = [self parseResponse:JSON error:&error];
        if (error) {
            [self requestDidFailWithError:error];
        } else {
            [self.itemList addObjectsFromArray:list];
        }
        
        if (self.pageMode == TBCitySBModelPageDefault) {
            _hasMore = list.count > 0;
        }
        
        else if (self.pageMode == TBCitySBModelPageReturnCount) {
            _hasMore = list.count == self.pageSize;
        }
        
        else {
            _hasMore =  self.pageSize * self.currentPageIndex >= self.totalCount;
        }
        return YES;
    }
    

}

- (void)reload
{
    self.currentPageIndex = 0;
    [super reload];
}

- (void)loadMore {
    if (_hasMore) {
        self.currentPageIndex += 1;
        [super loadMore];
    }
}
//SBMVC => 1.1
- (BOOL)prepareForload
{
    //[super prepareForload]:
    
    Class superCls = [self class];
    while (superCls != [TBCitySBModel class]) {
        superCls = class_getSuperclass(superCls);
    }

    IMP superMethod = class_getMethodImplementation(superCls, @selector(prepareForload));
    BOOL ret = ((BOOL(*)(id,SEL,...))superMethod)(self,@selector(prepareForload),nil);
    
    
    //清空currentPageIndex状态
    if (!ret)
        return NO;
    else
    {
        self.currentPageIndex = 0;
        return YES;
    }

}

@end
