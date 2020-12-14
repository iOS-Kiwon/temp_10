#import "AmailWebImageCompat.h"
@class AmailImageCache;
@protocol AmailImageCacheDelegate <NSObject>
@optional
- (void)imageCache:(AmailImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info;
- (void)imageCache:(AmailImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info;
@end