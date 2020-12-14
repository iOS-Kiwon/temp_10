#import "AmailWebImageDownloader.h"
#ifdef ENABLE_AMAILWEBIMAGE_DECODER
#import "AmailWebImageDecoder.h"
@interface AmailWebImageDownloader (ImageDecoder) <AmailWebImageDecoderDelegate>
@end
#endif
NSString *const AmailWebImageDownloadStartNotification = @"AmailWebImageDownloadStartNotification";
NSString *const AmailWebImageDownloadStopNotification = @"AmailWebImageDownloadStopNotification";
@interface AmailWebImageDownloader ()
@property (nonatomic, retain) NSURLConnection *connection;
@end
@implementation AmailWebImageDownloader
@synthesize url, delegate, connection, imageData, userInfo, lowPriority;
#pragma mark Public Methods
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<AmailWebImageDownloaderDelegate>)delegate
{
    return [self downloaderWithURL:url delegate:delegate userInfo:nil];
}
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<AmailWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo
{
    return [self downloaderWithURL:url delegate:delegate userInfo:userInfo lowPriority:NO];
}
//20140512 by shawn
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<AmailWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo lowPriority:(BOOL)lowPriority
{
    // Bind SDNetworkActivityIndicator if available (download it here: http://github.com/rs/SDNetworkActivityIndicator )
    // To use it, just add #import "SDNetworkActivityIndicator.h" in addition to the AmailWebImage import
    if (NSClassFromString(@"AmailNetworkActivityIndicator"))
    {
        id activityIndicator = [NSClassFromString(@"AmailNetworkActivityIndicator") performSelector:NSSelectorFromString(@"sharedActivityIndicator")];
        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"startActivity")
                                                     name:AmailWebImageDownloadStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"stopActivity")
                                                     name:AmailWebImageDownloadStopNotification object:nil];
    }
    AmailWebImageDownloader *downloader = [[AmailWebImageDownloader alloc] init] ;
    downloader.url = url;
    downloader.delegate = delegate;
    downloader.userInfo = userInfo;
    downloader.lowPriority = lowPriority;
    [downloader performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
    return downloader;
}
+ (void)setMaxConcurrentDownloads:(NSUInteger)max
{
    // NOOP
}
- (void)start
{
    // In order to prevent from potential duplicate caching (NSURLCache + AmailImageCache) we disable the cache for image requests
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO] ;
    // If not in low priority mode, ensure we aren't blocked by UI manipulations (default runloop mode for NSURLConnection is NSEventTrackingRunLoopMode)
    if (!lowPriority)
    {
        [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    [connection start];
    if (connection)
    {
        self.imageData = [NSMutableData data];
        [[NSNotificationCenter defaultCenter] postNotificationName:AmailWebImageDownloadStartNotification object:nil];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(amailImageDownloader:didFailWithError:)])
        {
            [delegate performSelector:@selector(amailImageDownloader:didFailWithError:) withObject:self withObject:nil];
        }
    }
}
- (void)cancel
{
    @try {
        if (connection)
        {
            [connection cancel];
            connection = nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AmailWebImageDownloader cancel : %@", exception);   
    }
    @finally {
        [[NSNotificationCenter defaultCenter] postNotificationName:AmailWebImageDownloadStopNotification object:nil];
    }
    
}
#pragma mark NSURLConnection (delegate)
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if([delegate respondsToSelector:@selector(amailImageDownloaderStart:expectedImageSize:)]) {
        [delegate performSelector:@selector(amailImageDownloaderStart:expectedImageSize:) 
                       withObject:self 
                       withObject:[NSNumber numberWithLongLong:[response expectedContentLength]]];
    }
}
- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
    [imageData appendData:data];
    if(delegate!=nil && [delegate respondsToSelector:@selector(amailImageDownloading:didReceiveData:)]) {
        [delegate performSelector:@selector(amailImageDownloading:didReceiveData:) 
                       withObject:self 
                       withObject:data];
    }
}
#pragma GCC diagnostic ignored "-Wundeclared-selector"
- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    self.connection = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:AmailWebImageDownloadStopNotification object:nil];
    if ([delegate respondsToSelector:@selector(amailImageDownloaderDidFinish:)])
    {
        [delegate performSelector:@selector(amailImageDownloaderDidFinish:) withObject:self];
    }
    if ([delegate respondsToSelector:@selector(amailImageDownloader:didFinishWithImage:)])
    {
        UIImage *image = [[UIImage alloc] initWithData:imageData];
#ifdef ENABLE_AMAILWEBIMAGE_DECODER
        [[AmailWebImageDecoder sharedImageDecoder] decodeImage:image withDelegate:self userInfo:nil];
#else
        [delegate performSelector:@selector(amailImageDownloader:didFinishWithImage:) withObject:self withObject:image];
#endif
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AmailWebImageDownloadStopNotification object:nil];
    if ([delegate respondsToSelector:@selector(amailImageDownloader:didFailWithError:)])
    {
        [delegate performSelector:@selector(amailImageDownloader:didFailWithError:) withObject:self withObject:error];
    }
    self.connection = nil;
    self.imageData = nil;
}
#pragma mark AmailWebImageDecoderDelegate
#ifdef ENABLE_AMAILWEBIMAGE_DECODER
- (void)imageDecoder:(AmailWebImageDecoder *)decoder didFinishDecodingImage:(UIImage *)image userInfo:(NSDictionary *)userInfo
{
    [delegate performSelector:@selector(amailImageDownloader:didFinishWithImage:) withObject:self withObject:image];
}
#endif
#pragma mark NSObject
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
