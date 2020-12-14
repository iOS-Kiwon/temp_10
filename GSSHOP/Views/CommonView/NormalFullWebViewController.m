//
//  NormalFullWebViewController.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 2015. 1. 9..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "NormalFullWebViewController.h"
#import "AppDelegate.h"

@interface NormalFullWebViewController ()
@end

@implementation NormalFullWebViewController
@synthesize urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUrlString:(NSString *)url {
    self = [super init];
    if(self != nil) {
        NSLog(@" set url: %@",url);
        self.urlString = url;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"wview dealloc");
    wview.UIDelegate = nil;
    wview.navigationDelegate = nil;
    wview = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    NSURL *videoURL = [NSURL URLWithString:self.urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
    
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    config.processPool = [[WKManager sharedManager] getGSWKPool];
    config.allowsInlineMediaPlayback = YES;
    
    wview = [[WKWebView alloc] initWithFrame:CGRectMake(0,STATUSBAR_HEIGHT,APPFULLWIDTH,APPFULLHEIGHT-STATUSBAR_HEIGHT)];
    wview.navigationDelegate = self;
    
//    [wview setScalesPageToFit:TRUE];
//    wview.delegate = self;
//    wview.dataDetectorTypes = UIDataDetectorTypeNone;
    
    
    [wview setBackgroundColor:[UIColor whiteColor]];
    [wview setOpaque:NO];
    [self.view addSubview:wview];
    [wview loadRequest:requestObj];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:NO];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    [super viewWillAppear:NO];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
}

- (void)showPopup {
   //점검중 안내 개선
    UIButton *reLoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(APPFULLWIDTH - 100 - 20, APPFULLHEIGHT - 50 - STATUSBAR_HEIGHT, 100, 50)];
    [self.view addSubview:reLoadBtn];
    [reLoadBtn setTitle:@"재시작" forState:UIControlStateNormal];
    [reLoadBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [reLoadBtn setBackgroundColor:[Mocha_Util getColor:@"BED730"]];
    
    reLoadBtn.layer.borderWidth = 1.0;
    reLoadBtn.layer.cornerRadius = 2.0;
    reLoadBtn.layer.shouldRasterize = YES;
    reLoadBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    reLoadBtn.layer.borderColor = [Mocha_Util getColor:@"B4CC2E"].CGColor;
    [reLoadBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    
    [reLoadBtn addTarget:self action:@selector(reLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:reLoadBtn];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *requestString1 = navigationAction.request.URL.absoluteString ;
    
    BOOL isDecisionAllow = YES;
    
    if([requestString1 hasPrefix:@"toapp://back"]) {//폼에서 버튼을 눌렀을대 string의 가장 처음에 있는 문자열이 일치하는지를 알려주는 메소드
        NSArray *comp = [requestString1 componentsSeparatedByString:@"//"];
        NSString *query1 = [comp lastObject];
        if([query1 isEqualToString:@"back"]) {
            if([wview canGoBack]) {
                [wview goBack];
            } 
            else {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [ApplicationDelegate.gactivityIndicator stopAnimating];
            }
        }
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"tel:"]) {
        NSString* tstring = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:requestString1];
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:tstring] ];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow){
        NSLog(@"");
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        NSLog(@"");
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *arrResponseCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@""]];
    NSHTTPCookieStorage *sharedCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [sharedCookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *arrSharedCookie = [sharedCookies cookies];
    
    
    for (NSHTTPCookie *cookie in arrResponseCookies) {
        
        //if (cookie !=nil && ([cookie.name isEqualToString:@"lastprdid"] || [cookie.name isEqualToString:@"search"])) {
        if (cookie !=nil && ([cookie.name length] > 0)) {
            
            for (NSHTTPCookie *deleteCookie in arrSharedCookie) {
                if ([[deleteCookie domain] isEqualToString:[cookie domain]] && [[deleteCookie name] isEqualToString:[cookie name]]) {
                    //NSLog(@"WKNavigationResponse delete Cookie = %@",deleteCookie);
                    [sharedCookies deleteCookie:deleteCookie];
                }
            }
            
            //NSLog(@"setttttt cookie = %@",cookie);
            
            [sharedCookies setCookie:cookie];
            
//            if ([cookie.name isEqualToString:@"lastprdid"]) {
//                [ApplicationDelegate checkCookieLastPrd];
//            }
        }
        
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //중요 웹뷰 네비게이션 및 속도 체크중. - IOS5 버전이하 cangback 꼬이는 문제로 사용않함
    //animationwithDuration 을 runloop free상태에서 사용하는 이유 -thread관리 - 제외시 앱다운유발가능.
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                     }
                     completion:^(BOOL finished){
                         [ApplicationDelegate.gactivityIndicator startAnimating];
                     }];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    //캡슐화 - 공통 처리 를 위해 상위클래스 불러줌 - 로딩 완료후 롱프레스 userinteraction  이벤트 발생시 자바스크립트 실행 복사 버튼 웹킷 기능 제어
    //이부분은 앱 꺼져있을때 Push를 받아 최초 접근시 appdelegate loadingDone을 위한.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"errorerror = %@",error);
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}

- (IBAction)reLoadAction:(id)sender {

        [ApplicationDelegate performSelector:@selector(callProcess) withObject:nil afterDelay:0.2];
        [self dismissViewControllerAnimated:NO completion:nil];

}

@end

