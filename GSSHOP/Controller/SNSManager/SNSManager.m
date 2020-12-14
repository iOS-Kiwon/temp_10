//
//  SNSManager.m
//  GSSHOP
//
//  Created by gsshop on 2016. 1. 19..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SNSManager.h"
//for KAKAOstory
#import "StoryLinkHelper.h"
#import <KakaoLink/KakaoLink.h>
#import <KakaoMessageTemplate/KakaoMessageTemplate.h>

@implementation SNSManager

//NHN 밴드,네이버앱,카페앱 3종은 아래URL참고
//https://developers.band.us/developers/ko/docs/share
//http://developer.naver.com/wiki/pages/UrlScheme
//http://developer.naver.com/wiki/pages/CafeUrlScheme


@synthesize linkurl, imageurl,textstring,imageSize;
@synthesize target;

+ (id)snsPostingWithUrl:(NSString*)url text:(NSString*)ttext imageUrl:(NSString*)timgurl imageSize:(CGSize)size {
    SNSManager *snsman = [[SNSManager alloc] init] ;
    snsman.linkurl = url;
    snsman.imageurl = timgurl;
    snsman.textstring = ttext;
    snsman.imageSize = size;
    return snsman;
}

-(void)NSNSPosting:(TYPEOFSNS)snstype {
    UIImage *dimg = nil;
    if(self.imageurl != nil) {
        NSURL *imgUrl = [NSURL URLWithString:self.imageurl];
        dimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
        self.imageSize = dimg.size;
    }
    [self shareSCWithIndex:snstype
                      text:self.textstring
                     image:dimg
                    imageURLString:self.imageurl
                    url:[NSURL URLWithString:self.linkurl]];
    
}


- (void) shareSCWithIndex:(NSInteger)buttonIndex text:(NSString *)text image:(UIImage *)image imageURLString:(NSString *)imgurl url:(NSURL *)url {
    if (buttonIndex==TYPE_SMSMESSAGE) {
        // 문자 메세지
        [self shareMessageWithText:text image:image url:url];
    } else if (buttonIndex==TYPE_KAKAOTALK) {
        // 카카오톡

        if ([[KLKTalkLinkCenter sharedCenter] isAvailable]) {
            // 카카오톡 공유
            [self kakaoWithText:text image:image imageURLString:imgurl url:url];
        } else {
            // 카카오톡 설치
            [self openInstallKakaoAlert];
        }
    }
    else if (buttonIndex==TYPE_KAKAOSTORY) {
        
        if ([StoryLinkHelper canOpenStoryLink]) {
            [self kakaoStoryWithText:text image:image imageURLString:imgurl url:url];
        }else {
            // 카카오스토리 설치
            [self openInstallKakaoStoryAlert];
        }
        
    }
    else if (buttonIndex==TYPE_FACEBOOK)
    {
        // 페이스북
        [self shareWithSCServiceType:SLServiceTypeFacebook Text:text image:image url:url];
    }
    else if (buttonIndex==TYPE_TWITTER)
    {
        // 트위터
        [self shareWithSCServiceType:SLServiceTypeTwitter Text:text image:image url:url];
    }
    else if (buttonIndex==TYPE_LINE) {
        NSString *textString = [NSString stringWithFormat:@"%@\n%@",text , url];
        NSString *LINEUrlString = [NSString stringWithFormat:@"line://msg/text/%@", [textString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        BOOL isOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:LINEUrlString]];
        if(!isOpen) {
            NSLog(@"라인설치 안됨");
            //라인 메신저가 설치 되어 있지 않다면 외부 브라우저료? 내부 브라우저료? -> 앱스토어로 이동
            NSString *LINEWebUrlString = @"https://itunes.apple.com/kr/app/lain-line/id443904275?mt=8";
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:LINEWebUrlString]];
        
        }
        else {
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:LINEUrlString]];
        }
        
    }
    else if (buttonIndex == TYPE_SHARE) {
        
        if(![UIActivity class]) {
            // UIActivity supported in iOS6
            // show error dialog
            return;
        }
        NSArray* actItems = [NSArray arrayWithObjects:
                             [NSString stringWithFormat:@"%@\n",text], url, nil];
        UIActivityViewController *activityView = [[UIActivityViewController alloc]
                                                   initWithActivityItems:actItems
                                                   applicationActivities:nil]
                                                  ;
        activityView.excludedActivityTypes = @[];
        
        //20160725 parksegun iPad 대응 (popover 설정이 필요함)
        if( [activityView respondsToSelector:@selector(popoverPresentationController)] ) {
            activityView.popoverPresentationController.sourceView = ApplicationDelegate.window;
            // 위치를 중앙으로..(버튼위로)
            activityView.popoverPresentationController.sourceRect = CGRectMake(ApplicationDelegate.window.frame.size.width/2, (ApplicationDelegate.window.frame.size.height/7)*4-20, 0, 0);
        }
        
        [ApplicationDelegate.window.rootViewController presentViewController:activityView
                           animated:YES
                         completion:nil];
        
        
        
    }
    else if(buttonIndex==TYPE_URLCOPY)
    {
        [[UIPasteboard generalPasteboard] setString:url.absoluteString ];
        // 토스트 띄움
        [Mocha_ToastMessage toastWithDuration:2.0 andText:GSSLocalizedString(@"Copied_text") inView: ApplicationDelegate.window];
        
        
    }
    
    
}


#pragma mark - 메시지
- (void) shareMessageWithText:(NSString *)text image:(UIImage *)image url:(NSURL *)url {
    if(![MFMessageComposeViewController canSendText]) {
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"Do_not_send_support_messages_text") maintitle:@" " delegate:nil buttonTitle:[NSArray arrayWithObjects:@"OK", nil]];
        [ApplicationDelegate.window addSubview:malert];
        return;
    }
    else
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText]) {
            controller.body = [NSString stringWithFormat:@"%@\n%@", text, url.absoluteString];

            controller.messageComposeDelegate =  ApplicationDelegate.HMV;//(MainViewController*)ApplicationDelegate.window.rootViewController;

            [ApplicationDelegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
            //messageComposeViewController require protocol method 를 Home_Main_ViewController 에 구현
        }
    }
    
}



#pragma mark - 카카오톡
- (void) kakaoWithText:(NSString *)text image:(UIImage *)image imageURLString:(NSString *)imgurl url:(NSURL *)url {
    // 카카오톡
    
    NSLog(@"url.absoluteString = %@",url.absoluteString);
    
    KMTTemplate *template = [KMTFeedTemplate feedTemplateWithBuilderBlock:^(KMTFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {
        
        // 콘텐츠
        feedTemplateBuilder.content = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = text;
            //contentBuilder.desc = @"아메리카노, 빵, 케익";
            contentBuilder.imageURL = [NSURL URLWithString:imgurl];
            
            NSInteger w = 200, h = 200; //카톡 V2 대응용 이미지 사이즈
            
            if(self.imageSize.width > 200.0 && self.imageSize.height > 200.0){
                
                w = self.imageSize.width;
                h = self.imageSize.height;
            }
            
            contentBuilder.imageWidth = [NSNumber numberWithInteger:w];
            contentBuilder.imageHeight = [NSNumber numberWithInteger:h];
            
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = url;
            }];
        }];

        // 버튼
        [feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"웹으로 보기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = url;
                linkBuilder.webURL = url;
            }];
        }]];
        [feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"앱으로 보기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = url;
                linkBuilder.webURL = url;
                linkBuilder.iosExecutionParams = [NSString stringWithFormat:@"url=gsshopmobile://home?%@",NCS(url.absoluteString)];
                linkBuilder.androidExecutionParams = [NSString stringWithFormat:@"url=gsshopmobile://home?%@",[(NCS(url.absoluteString)) urlEncodedString]];
            }];
        }]];
    }];
    
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        // 성공
        
    } failure:^(NSError * _Nonnull error) {
        // 에러
        
    }];

}

- (void) openInstallKakaoAlert {
    id delegateTarget = (self.target!=nil)?self.target:self;
    Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"KakaoTalk_is_not_installed_text")
                                                    maintitle:GSSLocalizedString(@"Do_you_want_to_install_KakaoTalk_text")
                                                     delegate:delegateTarget
                                                  buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"), GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
    malert.tag = 141;
    [ApplicationDelegate.window addSubview:malert];
    
   
}


#pragma mark - 카카오스토리
- (void) kakaoStoryWithText:(NSString *)text image:(UIImage *)image imageURLString:(NSString *)imgurl url:(NSURL *)url {
    
    NSBundle *bundle = [NSBundle mainBundle];
    ScrapInfo *scrapInfo = [[ScrapInfo alloc] init];
    scrapInfo.title = text;
    //scrapInfo.desc = text;
    if(imgurl != nil){
    scrapInfo.imageURLs = @[imgurl];
    }
    scrapInfo.type = ScrapTypeVideo;
    
    NSString *tstr = [StoryLinkHelper makeStoryLinkWithPostingText:[url absoluteString]
                                                       appBundleID:[bundle bundleIdentifier]
                                                        appVersion:@"GSSHOP"
                                                           appName:[bundle objectForInfoDictionaryKey:@"CFBundleName"]
                                                         scrapInfo:scrapInfo];
    
    
    [StoryLinkHelper openStoryLinkWithURLString:tstr];
    
    
}

- (void) openInstallKakaoStoryAlert {
    
    id delegateTarget = (self.target!=nil)?self.target:self;
    Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"KakaoStory_is_not_installed_text")
                                                    maintitle:GSSLocalizedString(@"Do_you_want_to_install_KakaoStory_text")
                                                     delegate:delegateTarget
                                                  buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"), GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
    malert.tag = 142;
    [ApplicationDelegate.window addSubview:malert];
}


#pragma mark - Alert View Delegate
// 주의:// 동작하지 않음. 해당 오브젝트가 dealloc되어 호출되지 않습니다.
- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index {
    if (alert.tag==141) {
        if (index==0) {
            // cancel
        }
        else {
            // 카카오톡 링크로 이동
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/id362057947"]];
        }
    }
    else if (alert.tag==142) {
        if (index==0) {
            // cancel
        }
        else {
            // 카카오스토리 링크로 이동
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/id486244601"]];
        }
    }
    
    
}


#pragma mark - 페이스북 트위터
- (void) shareWithSCServiceType:(NSString *)serviceType Text:(NSString *)text image:(UIImage *)image url:(NSURL *)url {
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        
        if (url)
            [mySLComposerSheet addURL:url];
        
        if (image)
            [mySLComposerSheet addImage:image];
        
        if (text)
            [mySLComposerSheet setInitialText:text];


        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONSNSSHARECLOSE object:nil userInfo:nil];
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONSNSSHARECLOSE object:nil userInfo:nil];
                    break;
                    
                default:
                    break;
            }
        }];
        
        [ApplicationDelegate.window.rootViewController presentViewController:mySLComposerSheet animated:YES completion:nil];
    } else {
        
        if(serviceType == SLServiceTypeFacebook){
            //facebook 수동연동구현
            NSString *tstr= [NSString stringWithFormat:@"http://facebook.com/sharer.php?t=%@&u=%@",[text urlEncodedString],[[url absoluteString] urlEncodedString] ];
            
            NSLog(@"티스특 %@",  [tstr urlDecodedString]);
            //http://facebook.com/sharer.php?t=오늘의 딜! [우미골드/쥬얼뱅크] 순금 골드바/순금 주얼리&u=http://www.gsshop.com/deal/deal.gs?dealNo=19027632&utm_source=facebook&utm_medium=sns&utm_campaign=sharefb
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:tstr]];
            
        }else if(serviceType == SLServiceTypeTwitter){
           
            NSString *tstr= [NSString stringWithFormat:@"http://twitter.com/share?text=%@&url=%@",[text urlEncodedString],[[url absoluteString] urlEncodedString] ];
            
            NSLog(@"티스특 %@",  [tstr urlDecodedString]);
            //http://facebook.com/sharer.php?t=오늘의 딜! [우미골드/쥬얼뱅크] 순금 골드바/순금 주얼리&u=http://www.gsshop.com/deal/deal.gs?dealNo=19027632&utm_source=facebook&utm_medium=sns&utm_campaign=sharefb
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:tstr]];
        }
        
        
    }
}

-(void)dealloc{

    NSLog(@"");
}



@end
