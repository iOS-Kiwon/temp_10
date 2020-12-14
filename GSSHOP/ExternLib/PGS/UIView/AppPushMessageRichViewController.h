#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "AppPushDatabase.h"
#import "AmailWebImageDownloader.h"
#import "AmailWebImageDownloaderDelegate.h"
@protocol AppPushMessageRichDelegate<NSObject>

- (void)setRichSize:(CGSize)argSize;
- (void)pressLink:(NSDictionary *)argDic;
- (void)pressCloseView:(NSDictionary *)argDic;
- (NSString *)clickLink:(NSURLRequest *)argRequest;

@end
@interface AppPushMessageRichViewController : UIViewController <AmailWebImageDownloaderDelegate, WKNavigationDelegate> {
    
    NSMutableDictionary                     *dicMsg;

    UIImageView                             *ivBack;
    UIImageView                             *ivClose;
    UIImageView                             *ivCloseX;
    UILabel                                 *lblClose;
    UIButton                                *btnLink;
    UIButton                                *btnBack;
    WKWebView                               *wvRich;
//    id<AppPushMessageRichDelegate>          delegate;
    NSDateFormatter                         *df;
    UIActivityIndicatorView                 *actView;
    
    BOOL                                    isFirst;
    int                                     webViewLoad;
    
    UIImageView                             *ivUrl;
    AmailWebImageDownloader                 *imageDownloader;
    BOOL                                    isDone;
    
}
@property (nonatomic, assign) id<AppPushMessageRichDelegate> delegate;
- (void)viewInitalization;
- (void)resetData;
- (void)setViewFrame:(CGRect)argRect;
- (void)loadRichView;
- (void)setMsgDic:(NSDictionary *)argDic;
@end
