//
//  TBCitySBModel.m
//  iCoupon
//
//  Created by Jason Wong on 13-12-31.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "TBCitySBModel.h"
#import "TBCitySBRequest.h"


@interface TBCitySBModel () <TBCitySBRequestDelegate>

@property(nonatomic,copy) TBCitySBModelCallback requestCallback;
@property (nonatomic, strong) id<TBCitySBRequest> request;

@end

@implementation TBCitySBModel
@synthesize itemList = _itemList;


////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)dealloc {
   
    [self cancel];
    
    _requestCallback = nil;
    [_itemList removeAllObjects];
    _itemList = nil;
    _delegate = nil;
    NSLog(@"[%@]--->dealloc", self.class);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (TBCitySBItemList *)itemList {
    if (!_itemList) {
        _itemList = [TBCitySBItemList array];
    }
    
    return _itemList;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public


/**
 请求数据
 */
- (void)load {

    //SBMVC 1.1 : 将load的判断条件抽象
    if ([self prepareForload]) {
        
        [self.itemList reset];
        [self loadInternal];
    }

  
}
/**
 * model的请求操作，回调使用block
 *
 * v：SBMVC=>1.1
 */
- (void)loadWithCompletion:(TBCitySBModelCallback)aCallback
{
    if (aCallback) {
        self.requestCallback = aCallback;
    }
    
    [self load];

}
/**
 重新加载数据
 */
- (void)reload {
    
    [self reset];
    [self load];
}
/**
 *  model重新请求，回调使用block
 *
 *  @param aCallback
 */
- (void)reloadWithCompletion:(TBCitySBModelCallback)aCallback
{
    if (aCallback) {
        self.requestCallback = aCallback;
    }
    
    [self reload];

}

/**
 翻页加载
 */
- (void)loadMore {

    [self loadInternal];
     
}
/**
 取消
 */
- (void)cancel {
    if (self.request) {
        [self.request cancel];
        self.request = nil;
    }
    _state = TBCitySBModelStateReady;
}
/**
 清空数据
 */
- (void)reset {
    [self cancel];
    [self.itemList reset];
}



- (void)loadInternal {
    //0, nil error
    _error = nil;
    
    //1, check params
    NSDictionary *dataParams = [self dataParams];
    NSDictionary *mtopParams = [self mtopParams];

    
    //2, create request
    //SBMVC => 1.1
    NSString* clz = @"";
    if (self.requestType == TBCitySBModelMTOP) {
        clz = @"TBCitySBMTOPRequest";
    }
    else if (self.requestType == TBCitySBModelAFNetworking)
    {
        clz = @"TBCitySBAFRequest";
    }
    else if (self.requestType == TBCitySBModelCustom)
    {
        clz = [self customRequestClassName];
        
        if (!clz ||clz.length == 0) {
            clz = @"TBCitySBRequest";
        }
    }
    else
        clz = @"TBCitySBRequest";

    self.request = [NSClassFromString(clz) new];
    self.request.useAuth     = [self useAuth];
    self.request.useCache    = [self useCache];
    self.request.showLogin   = [self needManualLogin];
    self.request.delegate    = self;
    self.request.usePost     = [self isPost];
    self.request.apiCacheTimeOutSeconds = [self apiCacheTimeOutSeconds];
    
    
    //3, init request
    [self.request initRequestWithBaseURL:[self methodName]];
    
    //4, add request data
    [self.request addParams:dataParams forKey:@"data"];
    [self.request addParams:mtopParams forKey:@"business"];
    
    
    //SBMVC => 1.2:add post body data
    if ([self isPost]) {
        [self.request addBodyData:[self bodyData] forKey:@"file"];
    }
 
    
    //5, start loading
    [self.request load];

    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - request callback

- (void)requestDidStartLoad:(id<TBCitySBRequest>)request {

    _state = TBCitySBModelStateLoading;
    if ([self.delegate respondsToSelector:@selector(modelDidStart:)]) {
        [self.delegate modelDidStart:self];
    }
}

- (void)requestDidFinish:(id)JSON {
    
    //SBMVC 1.1 : state从ready 改为 finished
    //_state = TBCitySBModelStateReady;
    _state = TBCitySBModelStateFinished;
    
    /**
     *  SBMVC 1.2:返回原始的responseOBj和string
     */
    _responseObject = self.request.responseObject;
    _responseString = self.request.responseString;
    
    
    
    
    //SBMVC 1.1 : @discuss:解析在主线程
    BOOL ret = [self parse:JSON];
    
    if (ret) {
        
        if ([self.delegate respondsToSelector:@selector(modelDidFinish:)]) {
            [self.delegate modelDidFinish:self];
        }
        
        //SBMVC =>1.1
        if (self.requestCallback) {
            self.requestCallback(self,nil);
            self.requestCallback = nil;

        }
    }

}

- (void)requestDidFailWithError:(NSError *)error {
    _state = TBCitySBModelStateError;
    _error = error;
    
    /**
     *  SBMVC 1.2:返回原始的responseOBj和string
     */
    _responseObject = self.request.responseObject;
    _responseString = self.request.responseString;
    
    
    
    if ([self.delegate respondsToSelector:@selector(modelDidFail:withError:)]) {
        [self.delegate modelDidFail:self withError:error];
    }
    //SBMVC 1.1
    if (self.requestCallback) {
        self.requestCallback(self,error);
        self.requestCallback = nil;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private

//SBMVC => 1.1 : 返回值修改为BOOL
- (BOOL)parse:(id)JSON {
   
    NSError *error = nil;
    
    NSArray *list = [self parseResponse:JSON error:&error];
    if (error) {
        
        [self requestDidFailWithError:error];
        return NO;
        
    } else {
        [self.itemList addObjectsFromArray:list];
        return YES;
    }
}


- (BOOL)isLoading {
    return self.state == TBCitySBModelStateLoading;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private hooks

//SBMVC => 1.1 
- (BOOL)prepareForload
{

    NSString *method = [self methodName];
    
    if (!method || method.length == 0) {
        [self requestDidFailWithError:[NSError errorWithDomain:TBCitySBMVCErrorDomain code:kMethodNameError userInfo:@{NSLocalizedDescriptionKey:@"缺少方法名"}]];
        return NO;
    }
    else
    {
        if (self.state == TBCitySBModelStateLoading) {
            [self cancel];
        }
        return YES;
    }

}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - !!子类重载!!

- (NSDictionary *)dataParams {
    return nil;
}

- (NSDictionary *)mtopParams {
    return nil;
}

- (NSString *)methodName {
    return nil;
}

- (NSArray *)parseResponse:(id)JSON error:(NSError *__autoreleasing *)error {
    return nil;
}

- (BOOL)useAuth {
    return NO;
}

- (BOOL)useCache {
    return NO;
}

- (BOOL)needManualLogin {
    return YES;
}

- (BOOL)isPost
{
    return NO;
}

- (NSDictionary*)bodyData
{
    return nil;
}

- (NSTimeInterval)apiCacheTimeOutSeconds {
    return 0;
}

- (NSString* )customRequestClassName
{
    return @"TBCitySBRequest";
}
@end
