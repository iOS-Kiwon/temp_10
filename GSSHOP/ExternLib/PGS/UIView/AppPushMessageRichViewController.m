#import "AppPushMessageRichViewController.h"
#import "AppPushUtil.h"
#import "AppPushConstants.h"
@implementation AppPushMessageRichViewController
@synthesize delegate;
#pragma mark - cyclelife
- (void)dealloc {
    
    if(imageDownloader!=nil && !isDone) [imageDownloader cancel];
    
}
- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        
        isFirst = YES;
        dicMsg = [[NSMutableDictionary alloc] init];
        df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMddHHmmss"];
        
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageRichViewController viewDidLoad : %@", exception);
    }
}
#pragma mark - Inner Method
- (void)viewInitalization {
    @try {
        
        int version =  [[UIDevice currentDevice] systemVersion].intValue;
        
        ivBack = [[UIImageView alloc] init];
        if(version<6) {
            [ivBack setImage:[[UIImage imageNamed:@"PMS.bundle/image/pms_popup_bg.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:7.0f]];
        } else {
            [ivBack setImage:[[UIImage imageNamed:@"PMS.bundle/image/pms_popup_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.0f, 7.0f, 7.0f, 7.0f)                                                                                    resizingMode:UIImageResizingModeStretch]];
        }
        [ivBack setFrame:self.view.frame];
        [self.view addSubview:ivBack];
        
        ivUrl = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f,
                                                              3.0f,
                                                              self.view.frame.size.width - (4.0f*2),
                                                              self.view.frame.size.height- 9.0f)];
        [self.view addSubview:ivUrl];
        
        wvRich = [[WKWebView alloc] initWithFrame:CGRectMake(4.0f,
                                                             3.0f,
                                                             self.view.frame.size.width - (4.0f*2),
                                                             self.view.frame.size.height- 9.0f)];

        [wvRich setContentMode:UIViewContentModeScaleToFill];
        [wvRich setBackgroundColor:[UIColor whiteColor]];
        [wvRich setOpaque:NO];
        wvRich.navigationDelegate = self;
        [self.view addSubview:wvRich];
        
        
        /*
         
         ivClose = [[UIImageView alloc] init];
         [ivClose setBackgroundColor:[UIColor clearColor]];
         if(version<6) {
         [ivClose setImage:[[UIImage imageNamed:@"PMS.bundle/image/pms_popup_btn_bg.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:7.0f]];
         } else {
         [ivClose setImage:[[UIImage imageNamed:@"PMS.bundle/image/pms_popup_btn_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.0f, 7.0f, 7.0f, 7.0f)                                                                                    resizingMode:UIImageResizingModeStretch]];
         }
         [ivClose setFrame:CGRectMake(wvRich.frame.origin.x-1.0f, wvRich.frame.size.height - 33.f, wvRich.frame.size.width + 2.0f, 38.0f)];
         [self.view addSubview:ivClose];
         
         
         ivCloseX = [[UIImageView alloc] init];
         [ivCloseX setBackgroundColor:[UIColor clearColor]];
         [ivCloseX setImage:[UIImage imageNamed:@"PMS.bundle/image/pms_popup_btn_close.png"]];
         [ivCloseX setFrame:CGRectMake((int)(ivClose.center.x - 20.0f), (int)(ivClose.center.y - 7.0f), 12.0f, 12.0f)];
         [self.view addSubview:ivCloseX];
         
         lblClose = [[UILabel alloc] init];
         [lblClose setBackgroundColor:[UIColor clearColor]];
         [lblClose setText:GSSLocalizedString(@"common_txt_alert_btn_close")];
         [lblClose setFont:[UIFont systemFontOfSize:15.0f]];
         [lblClose setTextAlignment:NSTextAlignmentLeft];
         [lblClose setTextColor:AMAIL_RGB(255,255,255)];
         [lblClose setFrame:CGRectMake((int)(ivClose.center.x - 4.0f), (int)(ivClose.center.y - (21.0f/2)), 30.0f, 21.0f)];
         [self.view addSubview:lblClose];
         
         
         btnBack = [[UIButton alloc] init];
         [btnBack setBackgroundColor:[UIColor clearColor]];
         [btnBack addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
         [btnBack setFrame:CGRectMake(wvRich.frame.origin.x, wvRich.frame.size.height - 35.f, wvRich.frame.size.width, 38.0f)];
         [self.view addSubview:btnBack];
         */
        
        
        
        btnLink = [[UIButton alloc] init];
        [btnLink setBackgroundColor:[UIColor clearColor]];
        [btnLink addTarget:self action:@selector(pressLink) forControlEvents:UIControlEventTouchUpInside];
        [btnLink setFrame:CGRectMake(wvRich.frame.origin.x, wvRich.frame.origin.y, wvRich.frame.size.width, wvRich.frame.size.height  )];
        [self.view addSubview:btnLink];
        
        
        btnBack = [[UIButton alloc] init];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        [btnBack addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
        [btnBack setFrame:CGRectMake(wvRich.frame.origin.x+150, 0, 50, 50.0f)];
        [self.view addSubview:btnBack];
        
        
        
        actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [actView setHidesWhenStopped:YES];
        
        [actView setFrame:CGRectMake((int)((self.view.frame.size.width - actView.frame.size.width)/2),
                                     (int)(((self.view.frame.size.height - ivClose.frame.size.height) - actView.frame.size.height)/2),
                                     actView.frame.size.width, actView.frame.size.height)];
        
        [self.view addSubview:actView];
        
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageRichViewController viewInitalization : %@", exception);
    }
}

- (void)resetData {
    @try {
        isFirst = NO;
        [wvRich loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        [ivUrl setImage:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageRichViewController resetData : %@", exception);
    }
}

- (void)setViewFrame:(CGRect)argRect {
    @try {
        
        [ivBack setFrame:argRect];
        
        [ivUrl setFrame:CGRectMake(4.0f,
                                   3.0f,
                                   ivBack.frame.size.width - (4.0f*2),
                                   ivBack.frame.size.height- 9.0f)];
        
        [wvRich setFrame:CGRectMake(4.0f,
                                    3.0f,
                                    ivBack.frame.size.width - (4.0f*2),
                                    ivBack.frame.size.height- 9.0f)];
        /*
         [ivClose setFrame:CGRectMake(wvRich.frame.origin.x-2.0f, wvRich.frame.size.height - 32.f, wvRich.frame.size.width + 4.0f, 38.0f)];
         
         [ivCloseX setFrame:CGRectMake((int)(ivClose.center.x - 20.0f), (int)(ivClose.center.y - 7.0f), 12.0f, 12.0f)];
         
         [lblClose setFrame:CGRectMake((int)(ivClose.center.x - 4.0f), (int)(ivClose.center.y - (21.0f/2)), 30.0f, 21.0f)];
         */
        [btnBack setFrame:CGRectMake(wvRich.frame.size.width-80, 0, 84, 50.0f)];
        
        [btnLink setFrame:CGRectMake(wvRich.frame.origin.x, wvRich.frame.origin.y, wvRich.frame.size.width, wvRich.frame.size.height  )];
        
        [actView setFrame:CGRectMake((int)((self.view.frame.size.width - actView.frame.size.width)/2),
                                     (int)(((self.view.frame.size.height  ) - actView.frame.size.height)/2),
                                     actView.frame.size.width, actView.frame.size.height)];
        
        [self.view bringSubviewToFront:btnBack];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageRichViewController setViewFrame : %@", exception);
    }
}

- (void)setMsgDic:(NSDictionary *)argDic {
    @try {
        isFirst = YES;
        [dicMsg setDictionary:argDic];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageRichViewController setMsgDic : %@", exception);
    }
}

- (BOOL)isImageUrl:(NSString * )argURL {
    BOOL isImageUrl = NO;
    @try {
        
        NSArray *arrSeparate = [argURL componentsSeparatedByString:@"."];
        if(arrSeparate!=nil && [arrSeparate count]>1) {
            NSArray *arrImageExtention = [NSArray arrayWithObjects:AMAIL_URL_IMAGE_TYPE, nil];
            NSString *fileExtention = [[arrSeparate objectAtIndex:([arrSeparate count]-1)] lowercaseString];
            
            if([arrImageExtention containsObject:fileExtention]) {
                isImageUrl = YES;
            }
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageRichViewController isImageUrl : %@", exception);
    }
    @finally {
        return isImageUrl;
    }
}

- (void)loadRichView {
    @try {
        
        if([MSG_TYPE_HTML isEqualToString:[dicMsg valueForKey:AMAIL_MSG_MSG_TYPE]]) {
            //MSG가 HTML 소스로 구성된 경우
            [ivUrl setHidden:YES];
            [wvRich setHidden:NO];
            [btnLink setHidden:YES];
            [wvRich loadHTMLString:[dicMsg valueForKey:AMAIL_MSG_MSG] baseURL:nil];
        } else if([MSG_TYPE_URL isEqualToString:[dicMsg valueForKey:AMAIL_MSG_MSG_TYPE]]){
            //본 URL기능은 구현및 테스트만 진행되었음. 실제 본 기능이 사용되지는 않음 -0-;
            //MSG가 URL인 된경우
            if([self isImageUrl:[dicMsg valueForKey:AMAIL_MSG_MSG]]) {
                //MSG의 URL이 이미지경로인 경우(png,jpg,gif)
                [ivUrl setHidden:NO];
                [wvRich setHidden:YES];
                [btnLink setHidden:NO];
                
                [actView setHidden:NO];
                [actView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
                [actView startAnimating];
                imageDownloader = [AmailWebImageDownloader downloaderWithURL:[NSURL URLWithString:[dicMsg valueForKey:AMAIL_MSG_MSG]]
                                                                    delegate:self];
            } else {
                //MSG의 URL이 일반 HTML
                [ivUrl setHidden:YES];
                [wvRich setHidden:NO];
                [btnLink setHidden:YES];
                
                [actView setHidden:NO];
                [actView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
                [actView startAnimating];
                
                [wvRich loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dicMsg valueForKey:AMAIL_MSG_MSG]]]];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageRichViewController loadMsgView : %@", exception);
    }
}

- (void)pressBack {
    @try {
        [delegate pressCloseView:dicMsg];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageRichViewController pressBack : %@", exception);
    }
}

- (void)pressLink {
    @try {
        [delegate pressLink:dicMsg];
        [delegate pressCloseView:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageRichViewController pressLink : %@", exception);
    }
}

#pragma mark - WKUIDelegate, WKNavigationDelegate

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
        
    if(isFirst) {
        
        isFirst = NO;
        [webView evaluateJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content','width=%d;',false);",(int)webView.frame.size.width]
                  completionHandler:nil];
        CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
        
        
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            
            [actView stopAnimating];
            [actView setHidden:YES];
            
        }
                         completion:^(BOOL finished) {
            
            
            __block NSString *clientHeight = nil;
            __block NSString *clientWidth = nil;
            
            [webView evaluateJavaScript:@"(function() { \
             return document.body.clientHeight; \
             }) ()" completionHandler:^(id result, NSError *error) {
                //
                if (error == nil) {
                    if (result != nil) {
                        clientHeight = [NSString stringWithFormat:@"%@", result];
                        
                        [webView evaluateJavaScript:@"(function() { \
                         return document.body.clientWidth; \
                         }) ()" completionHandler:^(id result, NSError *error) {
                            if (error == nil) {
                                if (result != nil) {
                                    clientWidth = [NSString stringWithFormat:@"%@", result];
                                    
                                    int webWidth = [clientWidth intValue];
                                    int webHeight = [clientHeight intValue];
                                    
                                    int toBeHeight = (int)((wvRich.frame.size.width * webHeight)/webWidth);
                                    if(toBeHeight<fittingSize.height) toBeHeight = fittingSize.height;
                                    
                                    if(toBeHeight>400) toBeHeight = 400.0f;
                                    if(toBeHeight<150) toBeHeight = 150.0f;
                                    
                                    
                                    [delegate setRichSize:CGSizeMake(wvRich.frame.size.width + (4.0f*2), toBeHeight + 9.0f)];
                                }
                            } else {
                                NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
                            }
                        }];
                    }
                } else {
                    NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
                }
            }];
            
            
            [self.view bringSubviewToFront:btnBack];
            
            
            //PMS Link 활성화 처리
            [webView evaluateJavaScript:@"replacePMSLink();" completionHandler:nil];
            
        }];
    }
}

-(void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if(navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        
        NSString *strRequestUrl = [delegate clickLink:navigationAction.request];
        if(strRequestUrl!=nil) {
            //Click 적용 후 appLink전달
            [dicMsg removeObjectForKey:AMAIL_MSG_APP_LINK];
            [dicMsg setValue:strRequestUrl forKey:AMAIL_MSG_APP_LINK];
        } else {
            //일반 appLink전달
            NSString *strURL = [[navigationAction.request URL] relativeString];
            [dicMsg removeObjectForKey:AMAIL_MSG_APP_LINK];
            [dicMsg setValue:strURL forKey:AMAIL_MSG_APP_LINK];
        }
        
        [delegate pressLink:dicMsg];
        [delegate pressCloseView:nil];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - AmailWebImageDownloaderDelegate

- (void)amailImageDownloader:(AmailWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image {
    
    isDone = YES;
    isFirst = NO;
    
    [actView stopAnimating];
    [actView setHidden:YES];
    
    [ivUrl setImage:image];
    
    float height = (image.size.height * ivUrl.frame.size.width) / image.size.width;
    
    //[ivUrl setFrame:CGRectMake(ivUrl.frame.origin.x, ivUrl.frame.origin.y, ivUrl.frame.size.width, height)];
    
    [delegate setRichSize:CGSizeMake(ivUrl.frame.size.width + (4.0f*2), height + 9.0f)];
    
    
}


@end
