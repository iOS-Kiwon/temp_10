//
//  GSWKWebview.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 10. 19..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "GSWKWebview.h"
#import "AppDelegate.h"
#import "LiveTalkViewController.h"
#import "SNSManager.h"
#import "URLParser.h"

@implementation GSWKWebview

static BOOL diagStat = NO;

@synthesize noTab;


- (nullable WKNavigation *)goBack {
    
    [self cleanCacheWithCompletionHandler:^{
        [super goBack];
    }];

    return nil;
}

//히스토리 백 할경우 onload 호출을 못하는 문제가 있어 캐시를 날리고 처음부터 시작하도록 처리함.
- (void)cleanCacheWithCompletionHandler:(void (^)(void))completionHandler {
    
    if ([WKWebsiteDataStore class]) {
        NSSet *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache]];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:completionHandler];
        
    }
    else {
        completionHandler();
    }

}

- (nullable WKNavigation *)reload {
    self.isloginInfo = [ApplicationDelegate islogin];
    return [super reload];
}


-(void) awakeFromNib {
    //IBOutret으로 생성된
    [super awakeFromNib];
    //바운스 제거
    [(UIScrollView *)[[self subviews] lastObject] setBounces:NO];
    //NSLog(@"gesturearr1= %@", self.gestureRecognizers );
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleLongPress:)];
    
    longPress.minimumPressDuration = 1;
    longPress.allowableMovement = 15.0f;
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
    
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    // Disable 3D touch
    self.allowsLinkPreview = NO;
    
}

-(id)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration{
    
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        if (strUserAgent == nil) {
            strUserAgent = [ApplicationDelegate getCustomUserAgent];
        }
        self.customUserAgent = strUserAgent;
        //바운스 제거
        [(UIScrollView *)[[self subviews] lastObject] setBounces:NO];
        // IBOutlet으로 생성되어지지 않은 코드를 통한 init initwithFrame 호출한경우 초기화
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(handleLongPress:)];
        
        longPress.minimumPressDuration = 1;
        longPress.allowableMovement = 15.0f;
        longPress.delegate = self;
        [self addGestureRecognizer:longPress];
        
        
        //딜, 단품 floating 처리
        self.lastFrame = CGRectZero;
        self.lastTabBarFrame = CGRectZero;
        
        //wkwebview iOS 9 에서 decelerationRate 조절버그있음
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        
        //내가 로그인전에 만들어진건가?
        self.isloginInfo = [ApplicationDelegate islogin];
        
        // Disable 3D touch
        self.allowsLinkPreview = NO;
    }
    
    return self;
}



- (NSString *)requestStringChecker:(NSString *)strRequested{

    NSString *requestString1 = [strRequested copy];
    //20181214 parksegun 파라메터내 인코딩되지 않은 http:// 혹은 https://가 있을경우. UrlParser가 오동작 할수 있기에 대응코드 추가
    NSString *separatedString = @"=http:";
    NSArray *ar = [requestString1 componentsSeparatedByString:separatedString];
    if(ar == nil || ar.count <= 1) {
        separatedString = @"=https:";
        ar = [requestString1 componentsSeparatedByString:separatedString];
    }
    
    if(ar != nil && ar.count > 1) {
        // nami0342 - 해당 URL이 앱 url scheme이면 pass 처리 (lottecard 관련 버그 수정)
        NSArray *appURLScheme = [requestString1 componentsSeparatedByString:@"://"];
        if([appURLScheme count] > 1)
        {
            if([Common_Util hasURLSchemes:NCS(appURLScheme[0])] == NO)
            {
                NSRange range = [requestString1 rangeOfString:separatedString];
                NSString *tempReqString = [requestString1 substringFromIndex:range.location+1];
                NSString *orginStr = [requestString1 substringToIndex:range.location+1];
                requestString1 = [NSString stringWithFormat:@"%@%@",orginStr,[tempReqString urlEncodedString]  ];
            }
        }
    }
    
    return requestString1;

}

- (BOOL)isGSWKDecisionAllowURLString:(NSString *)requestString andNavigationAction:(WKNavigationAction *)navigationAction withTarget:(id)target{
    
    
    BOOL isDecisionAllow = YES;
    
    NSString *requestString1 = [self requestStringChecker:requestString];
    
    // nami0342 - Main Tab 이동 기능 추가.
    if (isDecisionAllow == YES && [Mocha_Util strContain:@".gsshop.com/index.gs" srcstring:requestString1]) {
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        if ([parser valueForVariable:@"tabId"] != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self moveMainTabOnWebView:parser];
            });
            isDecisionAllow = NO;
        }
    }
    
    if (isDecisionAllow == YES && [requestString1 rangeOfString:@"/mygsshop/myshopInfo.gs"].location != NSNotFound  && (navigationAction.navigationType != WKNavigationTypeBackForward)) {
        
        NSString *strLoadedUrl = NCS(self.currentDocumentURL);
        NSLog(@"strLoadedUrlstrLoadedUrlstrLoadedUrl = %@",strLoadedUrl);
        
        NSString *strMyShopCheckUrl = nil;
        
        if ([requestString1 length] > 0 &&  [[requestString1 componentsSeparatedByString:@"?"] count] > 0) {
            strMyShopCheckUrl = [[requestString1 componentsSeparatedByString:@"?"] objectAtIndex:0];
        }
        else {
            strMyShopCheckUrl = requestString1;
        }
        
        NSLog(@"strMyShopCheckUrlstrMyShopCheckUrl = %@",strMyShopCheckUrl);
        
        // 마이샵 링크가 들어올경우
        if ([strLoadedUrl length] >0 && [strLoadedUrl hasPrefix:@"http"] &&[strMyShopCheckUrl length] > 0 && [strMyShopCheckUrl rangeOfString:@"/mygsshop/myshopInfo.gs"].location != NSNotFound ) {
            
            UINavigationController * navigationController = ApplicationDelegate.mainNVC;
            MyShopViewController *myShopWebView = nil;
            BOOL isFindMyShop = NO;
            for (NSInteger i=0; i<[navigationController.viewControllers count]; i++) {
                if ([[navigationController.viewControllers objectAtIndex:i] isKindOfClass:[MyShopViewController class]]) {
                    myShopWebView = [navigationController.viewControllers objectAtIndex:i];
                    isFindMyShop = YES;
                }
            }
            
            if (isFindMyShop == YES && [myShopWebView isEqual:[DataManager sharedManager].lastSideViewController] == NO) {
                [DataManager sharedManager].lastSideViewController = nil;
            }
            
            NSArray *arrParam = [requestString1 componentsSeparatedByString:@"/mygsshop/myshopInfo.gs"];
            
            if ([arrParam count] > 1 && [NCS([arrParam objectAtIndex:1]) length] > 0) {
                ApplicationDelegate.URLSchemeString = requestString1;
            }
            
            if (myShopWebView !=nil) {
                //[myShopWebView firstProc];
                 [myShopWebView resetWebviewForLoad: [NSURLRequest requestWithURL:[NSURL URLWithString:requestString1]]];
                
                [navigationController popToViewController:myShopWebView animated:YES];
                
                
            }
            else {
                myShopWebView = [[MyShopViewController alloc] initWithNibName:@"MyShopViewController" bundle:nil];
                [myShopWebView firstProc];
                [navigationController pushViewControllerMoveInFromBottom:myShopWebView];
            }
            isDecisionAllow = NO;
        }
        
    }
    
    //없는경우 띄우기
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"appjs:"]) {
        NSString *jsonString = [[[requestString1 componentsSeparatedByString:@"appjs:"] lastObject] stringByRemovingPercentEncoding];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        //data parameter is nil 크래쉬 방어
        if (jsonData != nil) {
            NSError *error;
            id parameters = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if (!error) {
                NSDictionary*dd = [[NSDictionary alloc] initWithDictionary:parameters];
                NSString* procnstr = [NSString stringWithFormat:@"%@('%@');",[dd objectForKey:@"callback"], [Common_Util commonAPPJSresponse:NCS([dd objectForKey:@"actkey"]) eventName:[dd objectForKey:@"eventName"] reqparam:[dd objectForKey:@"reqparam"] ] ];
                //콜백이 있을떄만
                if([NCS([dd objectForKey:@"callback"]) length] > 0) {
                    if (target != nil && [target respondsToSelector:@selector(callJscriptMethod:)]) {
                        [target callJscriptMethod: procnstr];
                    }
                }
            }
        }
        
        
        
        isDecisionAllow = NO;
    }
    
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"about:blank"]) {
        //공백페이지
        isDecisionAllow = NO;
    }
    
    //iOS7 대응
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"gsshopmobile://"]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1] ];
        isDecisionAllow = NO;
    }
    
    //PMS call protocol
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movemessage"]) {
        [ApplicationDelegate pressShowPMSLISTBOX];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://eventrecv"]) {
        NSString* tstring = [Mocha_Util strReplace:@"toapp://eventrecv?" replace:@"" string:requestString1];
        NSURL *evtURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&devId=%@",tstring,DEVICEUUID]];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:evtURL];
        [self loadRequest:requestObj];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://address?"]) {
        //선물하기용 연락처 호출
        if ([requestString componentsSeparatedByString:@"="].count > 1) {
            self.strAddressJavaScript = [requestString stringByReplacingOccurrencesOfString:@"toapp://address?" withString:@""];
            [self callContactViewController];
        }
        
        isDecisionAllow = NO;
    }
    
    
    //트위터 외부링크
    if (isDecisionAllow == YES && ([[requestString1 lowercaseString] hasPrefix:@"http://twitter.com/"] || [[requestString1 lowercaseString] hasPrefix:@"https://twitter.com/"])) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    // start 2012.12.20 외부 safari 웹브라우저로 띄우기 start
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://browser"]) {
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"browser?"];
        NSString *toquery = [livetv lastObject];
        
        if([toquery length] == NO) {
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
        else {
            //http:// 가 있을경우 http//로 들어옴 http링크의경우만 수정, url schema 호출의경우 http 영향없음.
            //toquery = [Mocha_Util strReplace:@"//" replace:@"://" string:toquery];
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[NSString stringWithFormat:@"%@",toquery]]];
        }
        isDecisionAllow = NO;
    }
    // end 2012.12.20 외부 safari 웹브라우저로 띄우기 end
    
    
    
    
    // start 2012.10.23 외부 safari 웹브라우저로 띄우기 start   (http 및 url schema대응)
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toweb://"]) {
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"toweb://"];
        NSString *toquery = [livetv lastObject];
        
        if( [toquery length] == NO) {
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
        else {
            //http:// 가 있을경우 http//로 들어옴 http링크의경우만 수정, url schema 호출의경우 http 영향없음.
            toquery = [Mocha_Util strReplace:@"//" replace:@"://" string:toquery];
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[NSString stringWithFormat:@"%@",toquery]]];
        }
        isDecisionAllow = NO;
    }
    // end 2012.02.20 내장 웹브라우저로 띄우기 end
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"ispmobile://"]) {
        //isp 결제 주소
        NSURL *appUrl = [NSURL URLWithString:requestString1];
        BOOL isInstalled =[[UIApplication sharedApplication] openURL_GS:appUrl];
        if(isInstalled) {
            
        }
        else {
            NSURL *videoURL = [NSURL URLWithString:GSISPFAILBACKURL];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL];
            [self loadRequest:requestObj];
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:GSISPDOWNURL]];
        }
        //웹뷰 외 사용시 return 처리해야 함
        isDecisionAllow = NO;
    }
    
    // start 2012.02.09 신한안심클릭 추가 start
    //------------------------------------------------------------------------------
    if(isDecisionAllow == YES && [requestString1 isEqualToString:SHINHANDOWNURL] == YES) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:SHINHANAPPNAME]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    //------------------------------------------------------------------------------
    // end 2012.02.09 신한안심클릭 추가 end
    
    // start 2013.09.10 신한Mobile 앱 다운로드 url start
    //------------------------------------------------------------------------------
    if (isDecisionAllow == YES && [requestString1 isEqualToString:SHINHANMAPPDOWNURL] == YES ) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    if (isDecisionAllow == YES &&  [requestString1 hasPrefix:SHINHANAPPCARDAPPNAME]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    //------------------------------------------------------------------------------
    // end 2013.09.10 신한Mobile 앱 다운로드 url end
    
    //start 2012.06.25 현대 안심 클릭 url start
    //------------------------------------------------------------------------------
    if(isDecisionAllow == YES && [requestString1 isEqualToString:HYUNDAIDOWNURL] == YES) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:HYUNDAIAPPNAME]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    //------------------------------------------------------------------------------
    //end 2012.06.25 현대 안심 클릭 url end
    
    //start 2014.11.20 롯데카드 결제앱2종 url start
    //------------------------------------------------------------------------------
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:LOTTEMOBILECARDAPPNAME]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:LOTTEAPPCARDAPPNAME]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    //------------------------------------------------------------------------------
    //end 2014.11.20 롯데카드 결제앱2종 url end
    
    
    
    
    
    //start 2015.09.25 PAYNOW url start
    
    if(isDecisionAllow == YES && [requestString1 isEqualToString:PAYNOWDOWNURL] == YES) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:PAYNOWAPPNAME]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    //end 2015.09.25 PAYNOW url end
    
    
    
    
    //start 2015.04.06 KB모바일앱카드 -- request URL이 null이 들어오는 경우 문제심각함 수정 by shawn
    //------------------------------------------------------------------------------
    
    NSString *kbstylereqstr = [requestString1 stringByRemovingPercentEncoding];
    if(isDecisionAllow == YES && [kbstylereqstr hasPrefix:KBAPPCARDAPPNAME]) {
        
        NSString *str =  [NSString stringWithFormat:@"%@&callback=%@", kbstylereqstr, [@"gsshopmobile" urlEncodedString] ];
        
        NSURL *appUrl = [NSURL URLWithString:str];
        BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:appUrl];
        if(isInstalled) {
            //설치된 kbappcard 앱 실행완료.
            [[UIApplication sharedApplication] openURL_GS:appUrl];
        }
        else {
            //미설치시 download URL로 이동.
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:KBMAPPDOWNURL]];
        }
        isDecisionAllow = NO;
    }
    //------------------------------------------------------------------------------
    //end 2015.04.06 KB모바일앱카드 url end
    
    
    if(isDecisionAllow == YES && [requestString1 isEqualToString:[NSString stringWithFormat:@"%@/",SERVERURI]]) {
        [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"gsshopmobile://home"] afterDelay:0.5];
        isDecisionAllow =  NO;
    }
    
    if(isDecisionAllow == YES && (([requestString1 hasPrefix:[NSString stringWithFormat:@"%@",GSMAINURL]]) ||([requestString1 hasPrefix:[NSString stringWithFormat:@"%@/index.gs",SERVERURI]]) )) {
        [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"gsshopmobile://home"] afterDelay:0.5];
        isDecisionAllow =  NO;
    }
    //S대응
    if(isDecisionAllow == YES && [requestString1 isEqualToString:[NSString stringWithFormat:@"%@/",SERVERURI_HTTPS]]) {
        [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"gsshopmobile://home"] afterDelay:0.5];
        isDecisionAllow =  NO;
    }
    
    //PC용 URL이 올경우 대비
    if(isDecisionAllow == YES &&  ([requestString1 isEqualToString:@"http://www.gsshop.com/"] || [requestString1 isEqualToString:@"https://www.gsshop.com/"])) {
        [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"gsshopmobile://home"] afterDelay:0.5];
        isDecisionAllow =  NO;
    }
    
    //SM/TM에서 M 용 정보가 올경우 대비
    if(isDecisionAllow == YES && [Mocha_Util strContain:@".gsshop.com/index.gs" srcstring:requestString1]) {
        [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"gsshopmobile://home"] afterDelay:0.5];
        isDecisionAllow =  NO;
    }
    
    
    // -- start -- 2012.04.03 전화 이메일 실행 안되는 현상 수정. -- start --
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"tel:"]) {
        NSString* tstring = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:requestString1];
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:tstring] ];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"mailto:"]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        //웹뷰 외 사용시 return 처리해야 함
        isDecisionAllow = NO;
    }
    // -- end -- 2012.04.03 전화 이메일 실행 안되는 현상 수정. -- end --
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://sms?msg="]) {
        NSString *tostr = [Mocha_Util strReplace:@"toapp://sms?msg=" replace:@"" string:requestString1];
        if([MFMessageComposeViewController canSendText]) {
            //메시지가 전송이 가능한 상태인지 확인. 가능한 경우이면
            {
                MFMessageComposeViewController *smsModal = [[MFMessageComposeViewController alloc] init];
                smsModal.messageComposeDelegate = self;
                smsModal.body = [tostr urlDecodedString];
                [ApplicationDelegate.window.rootViewController presentViewController:smsModal animated:YES completion:nil];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [ApplicationDelegate.gactivityIndicator stopAnimating];
            isDecisionAllow = NO;
        }
    }
    
    //toapp 자동로그인 처리
    //http://postit.gsshop.com/pages/viewpage.action?pageId=17495592
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://toautologin"]) {
        
        if ([Mocha_Util strContain:@"auto=N" srcstring:requestString1]) {
            
        }else{
            [DataManager sharedManager].loginYN = @"Y";
            ApplicationDelegate.islogin = YES;
        }

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[WKManager sharedManager] copyToSharedCookieAll:^(BOOL isSuccess) {
                NSLog(@"kkkkkk : %@", isSuccess?@"Y":@"N");
                if ([Mocha_Util strContain:@"auto=N" srcstring:requestString1]) {
                    [ApplicationDelegate autoLoginProcess:NO];
                }else{
                    [ApplicationDelegate autoLoginProcess:YES];
                }
            }];
        });
        
        isDecisionAllow = NO;
    }
    
    //toapp snslogin 처리
    //http://postit.gsshop.com/pages/viewpage.action?pageId=28639283
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://snslogin"]) {
        
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        NSString *strSNSType = NCS([parser valueForVariable:@"snsType"]);
        NSString *strClearYN = NCS([parser valueForVariable:@"clearYn"]);
        
        if ([strSNSType isEqualToString:@"NA"]) {
            
            if (_thirdPartyLoginConn == nil) {
                _thirdPartyLoginConn = [NaverThirdPartyLoginConnection getSharedInstance];
                _thirdPartyLoginConn.delegate = self;
            }
            
            if ([strClearYN isEqualToString:@"Y"]) {
                [self resetToken];
            }
            [self onBtnWebViewNaverLogin];
            
        }else if ([strSNSType isEqualToString:@"KA"]) {
            
            if ([strClearYN isEqualToString:@"Y"]) {
                [[KOSession sharedSession] close];
            }
            
            [self onBtnWebViewKakaoLogin];
            
        }
        
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES &&
       [requestString1 hasPrefix:@"toapp://"] == NO &&
       [requestString1 hasPrefix:@"http"] == NO &&
       [requestString1 hasPrefix:@"file://"] == NO
       ) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:requestString1]]) {
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1] ];
        }
        
        isDecisionAllow = NO;
    }
    
    
    return isDecisionAllow;
}

//- (void)webViewReload
//{
//    [self reload];
//}

// nami0342 - Main tab 이동 처리
- (void) moveMainTabOnWebView : (URLParser *) parser {

    NSArray *arrPopVC =  [ApplicationDelegate.HMV.navigationController popToRootViewControllerAnimated:NO];
    for (UIViewController *vc in arrPopVC) {
        NSLog(@"vcvcvcvc = %@",vc);
        if ([vc isKindOfClass:[ResultWebViewController class]]) {
            ResultWebViewController *rvc = (ResultWebViewController *)vc;
            [rvc removeAllObject];
        }
    }
    
    if ([parser valueForVariable:@"tabId"] != nil) {
        
        ApplicationDelegate.HMV.tabIdByTabId = [parser valueForVariable:@"tabId"];
        
        
        NSMutableString *strParam = [[NSMutableString alloc] initWithString:@""];
        if([parser valueForVariable:@"lseq"] != nil) {
            //2019.06.24 회의때 lseq 처리는 웹뷰에서 넘어온 값만 처리하도록 합의 임매니저님 컨펌
            //lseq 가 있을경우 매장탭 와이즈로그 호출시 추가해서 보내기위함
            [strParam appendString:@"&lseq="];
            [strParam appendString:[parser valueForVariable:@"lseq"]];
        }
        
        if([parser valueForVariable:@"media"] != nil) {
            [strParam appendString:@"&media="];
            [strParam appendString:[parser valueForVariable:@"media"]];
        }
        
        ApplicationDelegate.HMV.tabIdByAddParam = [NSString stringWithFormat:@"%@",strParam];
        
        if([parser valueForVariable:@"broadType"] != nil) {
            //편성표 전용 값
            ApplicationDelegate.HMV.tabIdBysubCategoryName = [parser valueForVariable:@"broadType"];
        }
        //20190402 parksegun JBP 하위 매장이동
        if([parser valueForVariable:@"groupCd"] != nil) {
            [ApplicationDelegate setGroupCode:[parser valueForVariable:@"groupCd"]];
        }
        
        [ApplicationDelegate.HMV sectionChangeWithTargetShopNumber:[parser valueForVariable:@"tabId"]];
    }
    
    if ([parser valueForVariable:@"openUrl"] != nil) {
        [ApplicationDelegate.HMV goWebView:[[parser valueForVariable:@"openUrl"] urlDecodedString]];
    }
    
    if ([parser valueForVariable:@"mseq"] != nil) {
        NSString *strSeq = [NSString stringWithFormat:@"?mseq=%@",[parser valueForVariable:@"mseq"]];
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(strSeq)];
    }
    
    
}



- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"");
    
    if([message isEqualToString:@"showLiveTalkInputBox_Y"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LIVETALK_HIDDEN_CHAT_OBSERVER_Y object:nil];
        completionHandler();
        return;
    }
    
    else if([message isEqualToString:@"showLiveTalkInputBox_N"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LIVETALK_HIDDEN_CHAT_OBSERVER_N object:nil];
        completionHandler();
        return;
    }
    
    
    
    if([message isEqualToString:@"showNalTalkInputBox_Y"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NALBANGHIDDENCHATOBSERVERY object:nil];
        completionHandler();
        return;
    }
    
    else if([message isEqualToString:@"showNalTalkInputBox_N"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NALBANGHIDDENCHATOBSERVERN object:nil];
        completionHandler();
        return;
    }
    
    else if([message isEqualToString:@"loadingOn"]){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [ApplicationDelegate.gactivityIndicator startAnimating];
        completionHandler();
        return;
    }
    else if([message isEqualToString:@"loadingOff"]){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [ApplicationDelegate.gactivityIndicator stopAnimating];
        completionHandler();
        
        return;
    }
    
    
    [self resignFirstResponderAction:self];
    
    //AppDelegate 외에 self.view에 addSubview 가능
    Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:message maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"),   nil]];
    malert.tag=1111;
    [ApplicationDelegate.window addSubview:malert];
    
    //버튼 누르기전까지 지연. = 웹뷰에서 텍스트필드로 javascript onfocus가 가는경우 키보드가 올라와 알럿뷰를 가리게되는경우를 위해 flow holding ==> confirm만 해당
    while (malert.hidden == NO && malert.superview != nil)
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001f]];
    
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    NSLog(@"");
    
    [self resignFirstResponderAction:self];
    
    
    //AppDelegate 외에 self.view에 addSubview 가능
    Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:message maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"), GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
    malert.tag=2222;
    [ApplicationDelegate.window addSubview:malert];
    
    while (malert.hidden == NO && malert.superview != nil)
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001f]];
    
    
    //return diagStat;
    
    NSLog(@"diagStatdiagStat = %d",(int)diagStat);
    completionHandler(diagStat);
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
    
}

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    NSLog(@"");
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

//javascript 함수호출
-(void)callJscriptMethod:(NSString *)mthd {
    
    
    [self evaluateJavaScript:mthd completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"callJscriptMethod mthd = %@",mthd);
        NSLog(@"callJscriptMethod WKresult = %@",result);
        NSLog(@"callJscriptMethod WKerror = %@",error);
        
    }];
}

#pragma mark MochaAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 380) {
        switch (index) {
            case 1:
                NSLog(@"설정");
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                break;
            default:
                break;
        }
        
    }else if(alert.tag == 2222) {
        switch (index) {
            case 0:
                diagStat = NO;
                NSLog(@"취소 클릭");
                break;
            case 1:
                diagStat = YES;
                NSLog(@"확인 클릭");
                
                break;
            default:
                break;
        }
    } else if (alert.tag == 1111) {
        if (self.viewHeader != nil) {
            ResultWebViewController *vc = (ResultWebViewController *)self.parentViewController;
            [vc.webPrdNaviBarView setDimViewWithIsShow:NO];
        }
    }
    
    
    
}

-(BOOL)resignFirstResponderAction:(UIView *)view{
    if (view.isFirstResponder){
        [view resignFirstResponder];
        return YES;
    }
    
    for (UIView *subView in view.subviews) {
        if ([self resignFirstResponderAction:subView]){
            return YES;
        }
    }
    return NO;
}


- (void)setScrollViewBackgroundColor:(UIColor *)color {
    
    for (UIView *subview in [self subviews])    {
        
        if ([subview isKindOfClass:[UIScrollView class]]) {
            /* 배경색 지정 */
            subview.backgroundColor = color;
            
            for (UIView *shadowView in [subview subviews])  {
                
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    /* 그라데이션 숨기기 */
                    shadowView.hidden = YES;
                }
            }
        }
    }
}


#pragma mark - SMSMessage

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
        {
            NSLog(@"Result: sent");
        }
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    
    
    
    [ApplicationDelegate.window.rootViewController  dismissViewControllerAnimated:YES completion:nil];
    
    
}


// 웹뷰 제스쳐 적용할려면 return YES로 하셔야 합니다.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
// 웹뷰 롱프레스 이벤트
- (void)handleLongPress:(UIGestureRecognizer *)recognizer {
    if ([recognizer state] == UIGestureRecognizerStateBegan ) {
        // 웹뷰에 탭&홀드된 위치 기억
        CGPoint tapLocation = [recognizer locationInView:[recognizer view]];
        [self contextualMenuAction:tapLocation];
    }
}


// 현재 포인트 위치에서 웹페이지에 있는 컨트롤 검색
- (void)contextualMenuAction:(CGPoint)tapLocation {
    
    //[self stringByEvaluatingJavaScriptFromString:JSSELECTPATH];
    // get the Tags at the touch location
    __block NSString *tags = nil;
    __block NSString *tagsSRC = nil;
    
    [self evaluateJavaScript:JSSELECTPATH completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    
        [self evaluateJavaScript:[NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%li,%li);",(long)tapLocation.x,(long)tapLocation.y] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            
            tags = NCS(result);
            
            [self evaluateJavaScript:[NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%li,%li);",(long)tapLocation.x,(long)tapLocation.y] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                
                tagsSRC = NCS(result);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController *csheet = [UIAlertController
                                                 alertControllerWithTitle:nil
                                                 message:nil
                                                 preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *ok = [UIAlertAction
                                         actionWithTitle:@"Save Image"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             //Do some thing here
                                             [csheet dismissViewControllerAnimated:YES completion:nil];
                                             // 쓰레드로 이미지 받기
                                             NSOperationQueue *queue = [NSOperationQueue new];
                                             NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveImageURL:) object:selectedImageURL];
                                             [queue addOperation:operation];
                                             
                                         }];
                    UIAlertAction *cancel = [UIAlertAction
                                             actionWithTitle:@"Cancel"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 [csheet dismissViewControllerAnimated:YES completion:nil];
                                                 NSLog(@"Cancel");
                                             }];
                    
                    
                    
                    // If an image was touched, add image-related buttons.
                    if ([tags rangeOfString:@"IMG,"].location != NSNotFound) {
                        selectedImageURL = tagsSRC;
                        [csheet addAction:ok];
                        [csheet addAction:cancel];
                        
                        if(self.parentViewController != nil) {
                            if( [csheet respondsToSelector:@selector(popoverPresentationController)] ) {
                                csheet.popoverPresentationController.sourceView = self.parentViewController.view;
                                // 위치를 중앙으로..(버튼위로)
                                csheet.popoverPresentationController.sourceRect = CGRectMake(self.parentViewController.view.frame.size.width/2, (self.parentViewController.view.frame.size.height/7)*4-20, 0, 0);
                            }
                            [self.parentViewController presentViewController:csheet animated:YES completion:nil];
                        }
                    }
                });
                
                
            }];
            
            
        }];
        
    }];
    
    
    
    
}


// URL에 있는 경로의 이미지를 앨범에 저장
- (void)saveImageURL:(NSString*)url {
    [self performSelectorOnMainThread:@selector(showStartSaveAlert) withObject:nil waitUntilDone:YES];
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]], nil, nil, nil);
    [self performSelectorOnMainThread:@selector(showFinishedSaveAlert) withObject:nil waitUntilDone:YES];
}

// 이미지 다운 완료 처리
- (void)showFinishedSaveAlert {
    
}

// 이미지 저장시 보여줄 Alertc창
- (void)showStartSaveAlert{
    
}



#pragma mark - SNS Login Kakao

-(void)javaScriptSNSLoginIsSuccess:(BOOL)isSuccess withType:(NSString *)strType AToken:(NSString *)strAccessToken RToken:(NSString *)strRefreshToken{
    
    NSString *strSuccess = @"FAIL";
    if (isSuccess == YES) {
        strSuccess = @"SUCC";
    }
    
    NSString* strJs = [NSString stringWithFormat:@"javascript:memberAction(\"%@\",\"%@\",\"%@\",\"%@\")",strSuccess,strAccessToken,strRefreshToken,strType];
    
    NSLog(@"strJs = %@",strJs);
    
    [self callJscriptMethod:strJs];
    
}

-(void)onBtnWebViewKakaoLogin{
    
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        if ([[KOSession sharedSession] isOpen]) {
            NSLog(@"kakao Login Succeeded.");
            
            [self javaScriptSNSLoginIsSuccess:YES withType:@"KA" AToken:[KOSession sharedSession].token.accessToken RToken:[KOSession sharedSession].token.refreshToken];
            
        }else{
            NSLog(@"kakao Login Failed. %@",error);
            
            if (error.code != 2) { //취소가 아닌경우에만 호출
                [self javaScriptSNSLoginIsSuccess:NO withType:@"KA" AToken:@"" RToken:@""];
            }
            
        }
    }];
    
}


- (void)onBtnWebViewNaverLogin{
    
    // NaverThirdPartyLoginConnection의 인스턴스에 인증을 요청합니다.
    [_thirdPartyLoginConn requestThirdPartyLogin];
}

- (void)requestAccessTokenWithRefreshToken
{
    [_thirdPartyLoginConn requestAccessTokenWithRefreshToken];
}

- (void)resetToken
{
    [_thirdPartyLoginConn resetToken];
}

- (void)requestDeleteToken
{
    [_thirdPartyLoginConn requestDeleteToken];
}

#pragma mark - Naver auth deleagate

- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailWithError:(NSError *)error {
    NSLog(@"%s=[%@]", __FUNCTION__, error);
    
    [self javaScriptSNSLoginIsSuccess:NO withType:@"NA" AToken:_thirdPartyLoginConn.accessToken RToken:_thirdPartyLoginConn.refreshToken];
    
}

- (void)oauth20ConnectionDidFinishRequestACTokenWithAuthCode {
    
    NSLog(@"%@",[NSString stringWithFormat:@"OAuth Success!\n\nAccess Token - %@\n\nAccess Token Expire Date- %@\n\nRefresh Token - %@", _thirdPartyLoginConn.accessToken, _thirdPartyLoginConn.accessTokenExpireDate, _thirdPartyLoginConn.refreshToken])
    
    [self javaScriptSNSLoginIsSuccess:YES withType:@"NA" AToken:_thirdPartyLoginConn.accessToken RToken:_thirdPartyLoginConn.refreshToken];
}

- (void)oauth20ConnectionDidFinishRequestACTokenWithRefreshToken {
    
    NSLog(@"%@",[NSString stringWithFormat:@"Refresh Success!\n\nAccess Token - %@\n\nAccess sToken ExpireDate- %@", _thirdPartyLoginConn.accessToken, _thirdPartyLoginConn.accessTokenExpireDate ]);
    
    [self javaScriptSNSLoginIsSuccess:YES withType:@"NA" AToken:_thirdPartyLoginConn.accessToken RToken:_thirdPartyLoginConn.refreshToken];
    
}
- (void)oauth20ConnectionDidFinishDeleteToken {
    NSLog(@"로그아웃 완료");
}

#pragma mark - HeaderNavtive

//-(void)addHeaderView:(UIView *)viewHeader withFrame:(CGRect)frame{
- (void)addHeaderViewWithResult:(NSDictionary *)dicResult andNavigationDelegate:(id)aDelegate andFrame:(CGRect)frame{
    
    if (self.viewHeader == nil) {
        self.viewHeader = [[[NSBundle mainBundle] loadNibNamed:@"WebPrdView" owner:self options:nil] firstObject];
        NSLog(@"처음 붙힘 있음!!!!");
    }else{
        NSLog(@"이미 있음!!!!");
        
    }
    self.viewHeader.aTarget = aDelegate;
    self.viewHeader.autoresizingMask = UIViewAutoresizingNone;
    self.viewHeader.hidden = NO;
    self.viewHeader.frame = frame;
#if DEBUG
//    NSDictionary *dic = [ApiDummy.shard getDummyDataWithType:DummyTypeWebPrd];
//    [self.viewHeader setDataInfo: dic];
//    [self.viewHeader setCellInfoNDrawData:dicResult];
    [self.viewHeader setDataInfo: dicResult];
#else
    [self.viewHeader setDataInfo: dicResult];
#endif

    self.isViewHeaderFirstResponder = YES;
    [self.scrollView insertSubview:self.viewHeader atIndex:0];
}

- (void)hideHeaderView{
    
    if (self.viewHeader != nil) {
        self.viewHeader.hidden = YES;
        [self.viewHeader viewDidDisappear];
        self.viewHeader = nil;
    }
    
    self.isViewHeaderFirstResponder = NO;
    
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    UIView *viewHitTest = [super hitTest:point withEvent:event];
    
    if (self.isViewHeaderFirstResponder) {
        CGRect rectToCheck = [self.scrollView convertRect:self.viewHeader.bounds toView:self.scrollView.superview];
        
        if (CGRectContainsPoint(rectToCheck, point)) {
            //if ([self isTransparent:[self convertPoint:point toView:viewHitTest]])
            if ([self isTransparent:point])
            {
                CGPoint pointConvert = [self.viewHeader convertPoint:point fromView:self.scrollView.superview];
                return [self.viewHeader hitTest:pointConvert withEvent:event];
            }else{
                return viewHitTest;
            }
        }else{
            return viewHitTest;
        }
    }else{
        return viewHitTest;
    }
}

- (BOOL) isTransparent:(CGPoint)point
{
    UIView *viewContents = nil;//(UIView *)[self.scrollView.subviews objectAtIndex:1];
    Class classWKContents = NSClassFromString(@"WKContentView");
    for (id subview in self.scrollView.subviews) {
        if ([subview isKindOfClass:classWKContents]) {
            viewContents = subview;
            break;
        }
    }
    
    if (viewContents == nil && [[self.scrollView.subviews objectAtIndex:0] isKindOfClass:[WebPrdView class]] == NO ) {
        viewContents = [self.scrollView.subviews objectAtIndex:0];
    }
    
    CGRect rectToCheck = [self.scrollView convertRect:viewContents.bounds toView:self.scrollView.superview];

    unsigned char pixel[4] = {0};

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y + rectToCheck.origin.y );
    UIGraphicsPushContext(context);
    
    NSLog(@"rectToCheck ={%f,%f} %@ ",point.x, point.y, NSStringFromCGRect(rectToCheck));
    [viewContents.layer renderInContext:context];
    
    UIGraphicsPopContext();
     if(context == NULL){
         NSLog(@"Context not created!");
     }
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
//    NSLog(@"pixel[0]/255.0 = %02X",pixel[0])
//    NSLog(@"pixel[1]/255.0 = %02X",pixel[1])
//    NSLog(@"pixel[2]/255.0 = %02X",pixel[2])
//    NSLog(@"pixel[3]/255.0 = %02X",pixel[3])
    
    return (pixel[0]/255.0 == 0) &&(pixel[1]/255.0 == 0) &&(pixel[2]/255.0 == 0) &&(pixel[3]/255.0 == 0) ;
}




-(void)callContactViewController{
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (granted) {
                CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
                contactPicker.delegate = self;
                contactPicker.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
                contactPicker.modalPresentationStyle =UIModalPresentationOverFullScreen;
                [ApplicationDelegate.window.rootViewController presentViewController:contactPicker animated:YES completion:nil];
                
            }else{
             
                Mocha_Alert* lalert = [[Mocha_Alert alloc] initWithTitle:
                GSSLocalizedString(@"msg_require_contact")   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:@"허용 안 함",@"설정", nil]];
                lalert.tag = 380;
                [ApplicationDelegate.window addSubview:lalert];
            }
        });
        
    }];
    
    
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    NSLog(@"");
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    NSLog(@"contact =%@",contact);
    NSMutableString *strName = [[NSMutableString alloc] initWithString:@""];
    [strName appendString:NCS(contact.familyName)];
    [strName appendString:NCS(contact.givenName)];
    
    NSArray *arrPhoneNumbers = contact.phoneNumbers;
    NSString *strPhoneNumber = @"0";
    if (arrPhoneNumbers.count > 0) {
        CNLabeledValue *phoneLbl = (CNLabeledValue *)[arrPhoneNumbers objectAtIndex:0];
        CNPhoneNumber *phoneNumber = (CNPhoneNumber *)phoneLbl.value;
        strPhoneNumber = phoneNumber.stringValue;
    }
    
    if (strName.length > 0 && strPhoneNumber.length > 0) {
        
        NSArray *arrParam = [self.strAddressJavaScript componentsSeparatedByString:@"="];
        if (arrParam.count > 1 && [NCS([arrParam objectAtIndex:0]) isEqualToString:@"func2"] ) {
            NSString *strJavaSc = [NSString stringWithFormat:@"%@('%@','%@')",NCS([arrParam objectAtIndex:1]),strName,strPhoneNumber];
            [self callJscriptMethod:strJavaSc];
        }
    }

}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    NSLog(@"contactProperty =%@",contactProperty);
}

@end

