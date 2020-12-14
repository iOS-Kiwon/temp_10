#import <Foundation/Foundation.h>
#import "AmailWebImageDownloaderDelegate.h"
#import "AmailWebImageCompat.h"
extern NSString *const AmailWebImageDownloadStartNotification;
extern NSString *const AmailWebImageDownloadStopNotification;
@interface AmailWebImageDownloader : NSObject
{
    @private
    NSURL *url;
    NSURLConnection *connection;
    NSMutableData *imageData;
    id userInfo;
    BOOL lowPriority;
}
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) id<AmailWebImageDownloaderDelegate> delegate;
@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) id userInfo;
@property (nonatomic, readwrite) BOOL lowPriority;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<AmailWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo lowPriority:(BOOL)lowPriority;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<AmailWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<AmailWebImageDownloaderDelegate>)delegate;
- (void)start;
- (void)cancel;
// This method is now no-op and is deprecated
+ (void)setMaxConcurrentDownloads:(NSUInteger)max __attribute__((deprecated));
@end