//
//  TBCitySBViewController.m
//  iCoupon
//
//  Created by Jason Wong on 14-1-2.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBViewController.h"
#import "TBCitySBModel.h"



@interface TBCitySBViewController ()
{
    //SBMVC => 1.1 Internal status of viewcontroller
    enum ModelStatus{bEmpty,bLoading,bModel,bError} _status;
    
    //SBMVC => 1.1 Internal state of viewcontroller
    struct InternalState { enum ModelStatus status; char* key;}_state __unused;
}



@end

@implementation TBCitySBViewController

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (NSDictionary*)modelDictionary
{
    return [_modelDictInternal copy];
}


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self = [self init];
   
  
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        _modelDictInternal = [NSMutableDictionary new];
        _status = bEmpty;
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    

}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];

}

-(void)dealloc {
    
    SBLog(@"[%@]-->dealloc",self.class);
    [_modelDictInternal removeAllObjects];
    _modelDictInternal    = nil;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public

- (void)registerModel:(TBCitySBModel *)model{
    model.delegate = self;
    [_modelDictInternal setObject:model forKey:model.key];
}

- (void)unRegisterModel:(TBCitySBModel *)model{
    
    [_modelDictInternal removeObjectForKey:model.key];

   
}

- (void)load {
   
    if ([self prepareForLoad]) {
        //load model
        
        //解决遍历dictionary的时候，调用方调用unregister方法
        [_modelDictInternal  enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            TBCitySBModel *model = (TBCitySBModel*)obj;
            
            //to the next runloop
            dispatch_async(dispatch_get_main_queue(), ^{
                [model load];
            });
        }];
   
    }
}

- (void)loadMore {}

- (void)reload {

    //load model
    //解决遍历dictionary的时候，调用方调用unregister方法
    [_modelDictInternal  enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        TBCitySBModel *model = (TBCitySBModel*)obj;
       
        //to the next runloop
        dispatch_async(dispatch_get_main_queue(), ^{
            [model reload];
        });
    }];
}


////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBCitySBModelDelegate

- (void)modelDidStart:(TBCitySBModel *)model {
    
    _status = bLoading;
      SBLog(@"[%@]-->{status : loading}",self.class);
    [self showLoading:model];
}

- (void)modelDidFinish:(TBCitySBModel *)model {
 
     [self didLoadModel:model];
    
    //SBMVC 1.1 => 修改了showEmpty逻辑
    if ([self canShowModel:model])
    {
        _status = bModel;
          SBLog(@"[%@]-->{status : model}",self.class);
        [self showModel:model];
    }
    else
    {
        if (_status != bModel
            && _status != bError
            && _status != bEmpty) {
            
            _status = bEmpty;
            SBLog(@"[%@]-->{status : empty}",self.class);
            [self showEmpty:model];
        }
        else
        {
            //noop;
              SBLog(@"[%@]-->{status : invalid}",self.class);
        }
    }
}

- (void)modelDidFail:(TBCitySBModel *)model withError:(NSError *)error {

    _status = bError;
      SBLog(@"[%@]-->{status : error}",self.class);
    [self showError:error withModel:model];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - private

- (BOOL)prepareForLoad {
    return YES;
}

- (BOOL)prepareForReload {
    return YES;
}

- (BOOL)prepareForLoadMore {
    return YES;
}




@end

////////////////////////////////////////////////////////////////////////
@implementation TBCitySBViewController(Subclassing)

- (void)didLoadModel:(TBCitySBModel*)model{
}

- (BOOL)canShowModel:(TBCitySBModel*)model
{
    if ([_modelDictInternal.allKeys containsObject:model.key]) {
        return YES;
    }
    else
        return NO;
    
}

- (void)showModel:(TBCitySBModel *)model{
   
#if __buildForMTOP__
    [self.statusHandler removeStatusViewFromView:self.view];
#endif
}



- (void)showEmpty:(TBCitySBModel *)model {

#if __buildForMTOP__
    [self.statusHandler removeStatusViewFromView:self.view];
#endif
}


- (void)showLoading:(TBCitySBModel*)model{
    
#if __buildForMTOP__
    [self.statusHandler removeStatusViewFromView:self.view];

#endif
    
}

- (void)showError:(NSError *)error withModel:(TBCitySBModel*)model{
    
#if __buildForMTOP__
    [self.statusHandler removeStatusViewFromView:self.view];
#endif
}

@end

@implementation TBCitySBViewController(MemoryWarning)

- (BOOL)shouldHandleMemoryWarning
{
    return YES;
}

@end