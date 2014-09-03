// RWTWeatherListModel.m 
// iCoupon 
//created by moxin.xt on 2014-09-03 23:48:15 +0800. 
// Copyright (c) @taobao. All rights reserved.
// 

#import "RWTWeatherListModel.h"
#import "RWTWeatherListItem.h"

@implementation RWTWeatherListModel

- (NSDictionary* )dataParams{

    //todo:   

    return nil; 

}
- (NSDictionary* )mtopParams{

   //todo:    

    return nil; 

}
- (NSString* )methodName{

    return @"http://www.raywenderlich.com/demos/weather_sample/weather.php?format=json"; 

}
- (BOOL)useAuth{

     return NO; 

}
- (NSInteger)pageSize{

     return 0; 

}
- (NSArray*)parseResponse:(id)JSON error:(NSError *__autoreleasing *)error{

    NSMutableArray* ret = [NSMutableArray new];
    
    for (NSDictionary* dict in JSON[@"data"][@"weather"]) {
        
        RWTWeatherListItem* item = [RWTWeatherListItem new];
        item.itemHeight = 80;
        [item autoKVCBinding:dict];
        [ret addObject:item];
    }
    return ret;

}
@end

