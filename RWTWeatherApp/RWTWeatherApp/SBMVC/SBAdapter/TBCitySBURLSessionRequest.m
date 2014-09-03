//
//  TBCitySBURLSessionRequest.m
//  iCoupon
//
//  Created by moxin.xt on 14-9-3.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBURLSessionRequest.h"

@interface TBCitySBURLSessionRequest()
{
    NSString* _url;
    NSMutableDictionary* _dict;
}
@end

@implementation TBCitySBURLSessionRequest

@synthesize useCache = _useCache;
@synthesize useAuth = _useAuth;
@synthesize usePost = _usePost;
@synthesize showLogin = _showLogin;
@synthesize apiCacheTimeOutSeconds = _apiCacheTimeOutSeconds;
@synthesize delegate = _delegate;
@synthesize responseObject = _responseObject;
@synthesize responseString = _responseString;

- (void)dealloc {
    [self cancel];
}


- (void)addParams:(NSDictionary* )aParams forKey:(NSString*)key
{
    [_dict addEntriesFromDictionary:aParams];
    
}

- (void)addBodyData:(NSDictionary *)aData forKey:(NSString *)key
{
}
- (void)initRequestWithBaseURL:(NSString *)url
{
    _url = url;
    _dict = [NSMutableDictionary new];
    
    //todo..
}
- (void)load
{
    
    if ([self.delegate respondsToSelector:@selector(requestDidStartLoad:)]) {
        [self.delegate requestDidStartLoad:self];
    }
    
 
}
- (void)cancel
{
    
}


@end
