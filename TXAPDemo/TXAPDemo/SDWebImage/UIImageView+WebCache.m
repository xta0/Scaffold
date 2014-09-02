/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "objc/runtime.h"

static char operationKey;

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil optimizationOption:TBImageOptimizationOptionAutomatic];
}

- (void)setImageWithURL:(NSURL *)url optimizationOption:(TBImageOptimizationOption)option
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil optimizationOption:option];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil optimizationOption:TBImageOptimizationOptionAutomatic];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder optimizationOption:(TBImageOptimizationOption)option
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil optimizationOption:option];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil optimizationOption:TBImageOptimizationOptionAutomatic];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options optimizationOption:(TBImageOptimizationOption)option
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil optimizationOption:option];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock optimizationOption:TBImageOptimizationOptionAutomatic];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock optimizationOption:(TBImageOptimizationOption)option
{
     [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock optimizationOption:option];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock optimizationOption:TBImageOptimizationOptionAutomatic];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock optimizationOption:(TBImageOptimizationOption)option
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock optimizationOption:option];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock optimizationOption:TBImageOptimizationOptionAutomatic];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock optimizationOption:(TBImageOptimizationOption)option
{
     [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock optimizationOption:option];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock {
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock optimizationOption:TBImageOptimizationOptionAutomatic];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock optimizationOption:(TBImageOptimizationOption)option
{
    [self cancelCurrentImageLoad];
    
    self.image = placeholder;
    
    BOOL usingWebp = ([url.absoluteString rangeOfString:@".webp"].length > 0);
    
    switch (option) {
        case TBImageOptimizationOptionUseOriginal:
            break;
        case TBImageOptimizationOptionUseWebp:
            if (!usingWebp)
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@_.webp", url.absoluteString]];
            break;
        case TBImageOptimizationOptionAutomatic:
            if (!usingWebp && [[SDWebImageManager sharedManager] isWebpModelOpen])
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@_.webp", url.absoluteString]];
            break;
        default:
            break;
    }
    
//    NSLog(@"SDWebImage: %@", url.absoluteString);
    
    if (url)
    {
        __weak UIImageView *wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             __strong UIImageView *sself = wself;
             if (!sself) return;
             if (image)
             {
                 sself.image = image;
                 [sself setNeedsLayout];
             }
             if (completedBlock && finished)
             {
                 completedBlock(image, error, cacheType);
             }
         }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)cancelCurrentImageLoad
{
    // Cancel in progress downloader from queue
    id<SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation)
    {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
