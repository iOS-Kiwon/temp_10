#import "AmailWebImageCompat.h"
@class AmailWebImageDownloader;
@protocol AmailWebImageDownloaderDelegate <NSObject>
@optional
- (void)amailImageDownloaderDidFinish:(AmailWebImageDownloader *)downloader;
- (void)amailImageDownloaderStart:(AmailWebImageDownloader *)downloader 
                 expectedImageSize:(NSNumber *)argSize;
- (void)amailImageDownloading:(AmailWebImageDownloader *)downloader 
                didReceiveData:(NSData *)argData; 
- (void)amailImageDownloader:(AmailWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image;
- (void)amailImageDownloader:(AmailWebImageDownloader *)downloader didFailWithError:(NSError *)error;
@end