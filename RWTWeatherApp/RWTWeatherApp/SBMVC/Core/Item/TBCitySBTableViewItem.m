//
//  TBCitySBTableViewItem.m
//  iCoupon
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBTableViewItem.h"

@implementation TBCitySBTableViewItem

- (NSMutableArray*) imageUrlArray
{
    if(!_imageUrlArray)
        _imageUrlArray = [[NSMutableArray alloc]init];
    
    return _imageUrlArray;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.indexPath     forKey:@"indexPath"];
    [aCoder encodeObject:@(self.itemHeight) forKey:@"itemHeight"];
    [aCoder encodeObject:self.imgUrl          forKey:@"imgUrl"];
    [aCoder encodeObject:self.imageUrlArray   forKey:@"imageUrlArray"];
    [aCoder encodeObject:self.image           forKey:@"image"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(self)
    {
        self.indexPath = [aDecoder decodeObjectForKey:@"indexPath"];
        self.itemHeight = ((NSNumber*)[aDecoder decodeObjectForKey:@"itemHeight"]).floatValue;
        self.imgUrl             = [aDecoder decodeObjectForKey:@"imgUrl"];
        self.imageUrlArray      = [aDecoder decodeObjectForKey:@"imageUrlArray"];
        self.image              = [aDecoder decodeObjectForKey:@"image"];
        
        
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
}

@end
