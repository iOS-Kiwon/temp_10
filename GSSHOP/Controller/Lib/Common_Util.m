//
//  Common_Util.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 13. 12. 26..
//  Copyright (c) 2013년 GS홈쇼핑. All rights reserved.
//

#import "Common_Util.h"
#import "AppDelegate.h"

#import "MyShopViewController.h"
#import "ResultWebViewController.h"
#import "LiveTalkViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import "ChangePWPopupView.h"
#import "ChangeTVPWPopupView.h"
#import <SystemConfiguration/SystemConfiguration.h>

static Common_Util *_instance = nil;        // Singleton 변수
@implementation Common_Util



// nami0342 - Singleton
+ (Common_Util *)sharedInstance
{
    @synchronized(self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
            _instance.m_dicLocalData = [[NSMutableDictionary alloc] init];
            
            [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(goBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(goBackground) name:UIApplicationWillTerminateNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(goBecameActive) name:UIApplicationWillEnterForegroundNotification object:nil];
            // Set timer for calcurate remain time.
            dispatch_async(dispatch_get_main_queue(), ^{
                _instance.m_timerAutosave = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(autoSave) userInfo:nil repeats:YES];
            });
        }
    }
    
    return _instance;
}


NSDate *START_TIME_FORCHECK;

+(void) saveExcuteTimeLog{
    
    START_TIME_FORCHECK = [NSDate date];
}


+(NSString*) writeExcuteTimeLog{
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:START_TIME_FORCHECK];
    NSLog(@"executionTime = %f", executionTime);
    return [NSString stringWithFormat:@"executionTime = %f", executionTime];
}

+(NSNumber*) writeExcuteTimeNSnumberLog{
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:START_TIME_FORCHECK];
    NSLog(@"executionTime = %f", executionTime);
    //   NSNumber *timeUsed = [NSNumber numberWithDouble:executionTime];
    NSNumber *timeUsed = [NSNumber numberWithInt:(int)(executionTime*1000)];
    return timeUsed;
}

+ (BOOL) isWide4{
    if ( [[UIScreen mainScreen] respondsToSelector:@selector(scale)] ){
        NSLog(@"scale : %f",[[UIScreen mainScreen] scale]);
        NSLog(@"vbounds: %@", NSStringFromCGSize([[UIScreen mainScreen] bounds].size));
        
        //if ( [[UIScreen mainScreen] applicationFrame].size.height >= 548 ) {
        if([[UIScreen mainScreen] bounds].size.height >= 568.0 ) {
            // 4.0inch
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}



+ (BOOL) isRetinaScale {
    if ( [[UIScreen mainScreen] respondsToSelector:@selector(scale)] ){
        NSLog(@"scale : %f",[[UIScreen mainScreen] scale]);
        
        if ( [[UIScreen mainScreen] scale] >= 2 ) {
            // 4.0inch
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
    
}

+ (NSString *)commaStringFromDecimal:(int)decimal
{
    int q = decimal;
    if(q==0){
        return [NSString stringWithFormat:@"%d",0];
    }else if( q < 0){
        return @"";
    }
    else {
        
        NSString *result;
        
        while (q > 0)
        {
            int r = q % 1000;
            q = q / 1000;
            
            result = [NSString stringWithFormat:((q > 0) ? @"%03d%@" : @"%d%@"), r, (result ? [NSString stringWithFormat:@",%@", result] : @"")];
        }
        
        return result;
    }
}

//20170901 parksegun eventName 파라메터 추가
+ (NSString *)commonAPPJSresponse:(NSString*)tgstr eventName:(NSString*)namestr reqparam:(NSString*)reqpstr {
    
    NSLog(@"appjsresponse : %@, %@", tgstr, reqpstr);
    //회원가입
    //measureMATRegistration
    //set 3종 customerNO age gender
    //measureAction
    //장바구니
    //measureMATAddToCart
    //구매
    //measureMATPurchase
    //MAT SDK3종
    if([tgstr isEqualToString:@"measureMATRegistration"]){
        [ApplicationDelegate MobileAppTrackerSendLogMemberRegistration:(NSDictionary*)reqpstr];
        return @"NOTHING";
    }
    
    if([tgstr isEqualToString:@"measureMATAddToCart"]){
//        [ApplicationDelegate MobileAppTrackerSendLogCartAndPurchase:@"add_to_cart" withDic:(NSDictionary*)reqpstr];
        return @"NOTHING";
    }

    if([tgstr isEqualToString:@"measureMATPurchase"]){
//        [ApplicationDelegate MobileAppTrackerSendLogCartAndPurchase:@"purchase" withDic:(NSDictionary*)reqpstr];
        return @"NOTHING";
    }

    // FB DPA - 상품보기 view
    if([tgstr isEqualToString:@"measureFBViewContent"]){
        //[ApplicationDelegate MobileAppTrackerSendLogView:(NSDictionary*)reqpstr];
        return @"NOTHING";
    }
    
    //GTM 이벤트로깅용
    if([tgstr isEqualToString:@"measureGTMEvent"]){
        NSDictionary* dics = [NSDictionary dictionaryWithDictionary:(NSDictionary*)reqpstr];
        //   NSLog(@"  %@",dics);
        // <a href="javascript:sendObjectMessage({actkey: 'measureGTMEvent', reqparam: {category:'7519969', action:'3', label:'42'}  ,  callback: ''});">
        [ApplicationDelegate  GTMsendLog:[dics objectForKey:@"category"]  withAction:[dics objectForKey:@"   "] withLabel:[dics objectForKey:@"label"]];
        
        return @"NOTHING";
    }
    
    
    
    // { id: 'T12345', affiliation: 'Online Store',  revenue: '35.43',  tax:'4.90',  shipping: '5.99', coupon: 'SUMMER_SALE'}
    
    
    // [{ name : 'Triblend Android T-Shirt',id: '12345',price: '15.25',brand: 'Google', category: 'Apparel',        variant: 'Gray',        quantity: 1,        coupon:  '' }, { name: 'Donut Friday Scented T-Shirt',        id: '67890',        price: '33.75',        brand: 'Google',        category: 'Apparel',        variant: 'Black',        quantity: 1 }    ]
    
    
    //GTM 구매 이벤트 로깅용
    if([tgstr isEqualToString:@"measureGTMPurchase"]){
        NSDictionary* dics = [NSDictionary dictionaryWithDictionary:(NSDictionary*)reqpstr];
        
        // <a href="javascript:sendObjectMessage({actkey: 'measureGTMPurchase', reqparam: {action:' {"id":"T12340","affiliation":"Online Store","revenue":35000,"tax":"0","shipping":"0","coupon":"SUMMER_SALE"}', products:'[{"name":"Triblend Android T-Shirt","id":"12345","price":"15000","brand":"Google","category":"Apparel","variant":"Gray","quantity":1,"coupon":""},{"name":"Donut Friday Scented T-Shirt","id":"67890","price":"20000","brand":"Google","category":"Apparel","variant":"Black","quantity":1}]'}  ,  callback: ''});">
        
        //NSLog(@"  %@",dics);
        
        if (NCO(dics)){
            
            if (NCO([dics objectForKey:@"action"]) == NO || [[dics objectForKey:@"action"] isKindOfClass:[NSDictionary class]] == NO) {
                return @"NOTHING";
            }
            
            if (NCA([dics objectForKey:@"products"]) == NO) {
                return @"NOTHING";
            }
            
            NSArray *arrProducts = [dics objectForKey:@"products"];
            
            if ([arrProducts count] > 0 && [[arrProducts objectAtIndex:0] isKindOfClass:[NSDictionary class]] == YES) {
                [ApplicationDelegate  GTMsendPurchaseLog:[dics objectForKey:@"action"]  withProducts:arrProducts];
            }
        }
        return @"NOTHING";
    }
    
    
    //-(void)GTMsendPurchaseLog:(NSString*)Action withLabel:(NSString*)Products
    
    
    
    
    //바로구매 네이티브 영역 장바구니 리프레쉬
    if([tgstr isEqualToString:@"refreshCart"]){
        
        UINavigationController * navigationController = ApplicationDelegate.mainNVC;
        
        NSLog(@"[navigationController.viewControllers lastObject] = %@",[navigationController.viewControllers lastObject]);
        
        if ([[navigationController.viewControllers lastObject] isKindOfClass:[Home_Main_ViewController class]]) {
            Home_Main_ViewController *VC = (Home_Main_ViewController *)[navigationController.viewControllers lastObject];
            
            if ( [VC respondsToSelector:@selector(DrawCartCountstr)] && ApplicationDelegate.islogin){
                //[VC DrawCartCountstr];
                [[WKManager sharedManager] copyToSharedCookieName:WKCOOKIE_NAME_CART OnCompletion:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [VC DrawCartCountstr];
                    }
                }];
                
                
            }
            
        }else if ([[navigationController.viewControllers lastObject] isKindOfClass:[ResultWebViewController class]]) {
            ResultWebViewController *VC = (ResultWebViewController *)[navigationController.viewControllers lastObject];
            [VC callJscriptMethod:@"refreshBasketCnt();"];
        }else if ([[navigationController.viewControllers lastObject] isKindOfClass:[MyShopViewController class]]) {
            MyShopViewController *VC = (MyShopViewController *)[navigationController.viewControllers lastObject];
            [VC callJscriptMethod:@"refreshBasketCnt();"];
            
        }else if ([[navigationController.viewControllers lastObject] isKindOfClass:[LiveTalkViewController class]]) {
            LiveTalkViewController *VC = (LiveTalkViewController *)[navigationController.viewControllers lastObject];
            //라이브톡 장바구니 리프레쉬
            if ( [VC respondsToSelector:@selector(DrawCartCountstr)] && ApplicationDelegate.islogin){
                //[VC DrawCartCountstr];
                [[WKManager sharedManager] copyToSharedCookieName:WKCOOKIE_NAME_CART OnCompletion:^(BOOL isSuccess) {
                    if (isSuccess) {
                        [VC DrawCartCountstr];
                    }
                }];
            }
        }
        
        
        
        return @"NOTHING";
    }
    
    
    if([tgstr isEqualToString:@"isInstalledApp"]){
        
        NSURL *appUrl = [NSURL URLWithString:reqpstr];
        BOOL isInstalled =[[UIApplication sharedApplication] canOpenURL:appUrl];
        if(isInstalled)
        {
            return @"YES";
            
        }else {
            return @"NO";
        }
        
    }
    
    
    
    
    
    
    /*
     if([tgstr isEqualToString:@"isPushApproved"]){
     
     //시뮬레이터 테스트를 위해
     #if TARGET_IPHONE_SIMULATOR
     return @"YES";
     #else
     if([Mocha_Util ispushalertoptionenable])
     {
     return @"YES";
     
     }else {
     return @"NO";
     }
     #endif
     
     }
     */
    
    
    if([tgstr isEqualToString:@"isGSPushApproved"]){
        
        //로그인여부는 서버사이드에서 체크하고 로그인 가정하에 아래와같은 설정값만 반환
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *tempNotiFlag = [userDefaults valueForKey:GS_PUSH_RECEIVE];
        
        
        if(tempNotiFlag==nil && [tempNotiFlag isEqualToString:@"N"]) {
            
            //마이설정으로 연결하기 위한 팝업을 띄음
            [ApplicationDelegate showPushCheckAlert:@"MYSETPUSH"];
            return @"NO";
        }
        else if([tempNotiFlag isEqualToString:@"Y"]){
            
            return @"YES";
        }
        else {
            
            //마이설정으로 연결하기 위한 팝업을 띄음
            [ApplicationDelegate showPushCheckAlert:@"MYSETPUSH"];
            return @"NO";
        }
        
        
        
    }
    
    if([tgstr isEqualToString:@"getDeviceUUID"]){
        
        return DEVICEUUID;
        
    }
    
    if([tgstr isEqualToString:@"getAppVersion"]){
        
        return CURRENTAPPVERSION;
        
    }
    
    
    
    
    if([tgstr isEqualToString:@"login_interface"]){
        NSLog(@"login_interface: %@", reqpstr);
        
        ////탭바제거
        
        BOOL tgproc= [ApplicationDelegate appjsProcLogin:(NSDictionary*)reqpstr];
        
        if(tgproc==YES){
            return @"Y";
        }else {
            return @"N";
        }
        
        
        
    }
    
    if([tgstr isEqualToString:@"logout_interface"]){
        ////탭바제거
        
        NSLog(@"logout_interface: %@", reqpstr);
        
        BOOL tgproc= [ApplicationDelegate appjsProcLogout:(NSDictionary*)reqpstr];
        
        if(tgproc==YES){
            return @"Y";
        }else {
            return @"N";
        }
        
    }
    
    //20160325 parksegun 이벤트에서 푸시 설정을 체크해서 팝업을 노출함. //여기는 뷰가 아니라.. 동작하지 않는다.뷰에 발라야 하는데...
    if([tgstr isEqualToString:@"isPushApproved"])//isPushApproved
    {
        //시스템 설정이 N이면? 알림 팝업을 띄우고... YES를 반환(선택임)
        if([Mocha_Util ispushalertoptionenable])
        {
            return @"YES";
            
        }
        else
        {
            [ApplicationDelegate showPushCheckAlert:@"SYSSETPUSH"];
            
            return @"NO";
        }
        
    }
    
    //20190214 parksegun WK 웹뷰 적용으로 인해 스크립트 호출 부분이 비동기 형태로 변경되서 얼럿창 없이 처리되는 부분이 필요함.
    if([tgstr isEqualToString:@"isPushStatus"]) {
        //시스템 설정이 N이면? 알림 팝업을 띄우고... YES를 반환(선택임)
        if([Mocha_Util ispushalertoptionenable]) {
            return @"YES";
        }
        else {
            return @"NO";
        }
    }
    
    //20190214 parksegun WK 웹뷰 적용으로 인해 스크립트 호출 부분이 비동기 형태로 변경되서 얼럿창 없이 처리되는 부분이 필요함.
    if([tgstr isEqualToString:@"isGSPushStatus"]) {
        //로그인여부는 서버사이드에서 체크하고 로그인 가정하에 아래와같은 설정값만 반환
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *tempNotiFlag = [userDefaults valueForKey:GS_PUSH_RECEIVE];
        if(tempNotiFlag==nil && [tempNotiFlag isEqualToString:@"N"]) {
            return @"NO";
        }
        else if([tempNotiFlag isEqualToString:@"Y"]) {
            return @"YES";
        }
        else {
            return @"NO";
        }
    }
    
    
    // nami0342 - AID 리턴
    if([tgstr isEqualToString:@"getAdvertisingId"]){
        
        NSLog(@"getAdvertisingId: %@", reqpstr);
        NSUUID *uuidAID = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        
        NSString *strAID = [uuidAID UUIDString];
        if(strAID != nil && [strAID length] > 0)
            return  strAID;
        else
            return @"";
    }
    
    
    
    //20160527 parksegun 클립보드 복사
    if([tgstr isEqualToString:@"sendClipData"]){
        
        NSLog(@"sendClipData reqpstr: %@",reqpstr);
        [[UIPasteboard generalPasteboard] setString:reqpstr];
        // 토스트 띄움
        [Toast show:GSSLocalizedString(@"Copied_text")];
        return @"true";
        
    }
    
    //20200908 parksegun 클립보드 복사 + 타이틀
    if([tgstr isEqualToString:@"sendClipDataTitle"]){
        
        NSLog(@"sendClipDataTitle reqpstr: %@",reqpstr);
        NSDictionary* dics = [NSDictionary dictionaryWithDictionary:(NSDictionary*)reqpstr];
        
        if( NCO(dics) ) {
            NSString *cUrl = NCS([dics objectForKey:@"url"]);
            NSString *cTitle = NCS([dics objectForKey:@"title"]);
            if( cUrl.length <= 0 ) {
                return @"false";
            }
            
            [[UIPasteboard generalPasteboard] setString:cUrl];
            
            if( cTitle.length > 0) {
                // 토스트 띄움
                NSString *message = cTitle;
                [Toast show:message];
                return @"true";
            }
            else {
                // 토스트 띄움
                [Toast show:GSSLocalizedString(@"Copied_text")];
                return @"true";
            }
        }
        else {
            return @"false";
        }
    }
    
    
    //20161021 narava 최근본상품 저장
    if([tgstr isEqualToString:@"lastPrdUpdate"]){
        
        NSLog(@"lastPrdUpdate reqpstr: %@",reqpstr);
        //[ApplicationDelegate checkCookieLastPrd];
        [[WKManager sharedManager] copyToSharedCookieName:WKCOOKIE_NAME_LASTPRDID OnCompletion:^(BOOL isSuccess) {
            
        }];
        
        return @"true";
        
    }
    
    //20170901 parksegun AMP 이벤트 전달
    if([tgstr isEqualToString:@"sendAMPEventProperties"]) {
        NSDictionary* dics = [NSDictionary dictionaryWithDictionary:(NSDictionary*)reqpstr];
        if( NCO(dics) && NCS(namestr) ) {
            [ApplicationDelegate setAmplitudeEventWithProperties:namestr properties:dics];
        }
        else {
            return @"false";
        }
        return @"true";
    }
    
    if([tgstr isEqualToString:@"sendAMPEvent"]) {
        if( NCS(namestr) ) {
            [ApplicationDelegate setAmplitudeEvent:namestr];
        }
        else {
            return @"false";
        }
        return @"true";
    }
    
    //20180305 parksegun appboy 이벤트 전달
    if([tgstr isEqualToString:@"sendAppboyEventProperties"]) {
        NSDictionary* dics = [NSDictionary dictionaryWithDictionary:(NSDictionary*)reqpstr];
        if( NCO(dics) && NCS(namestr) ) {
            [ApplicationDelegate setAppBoyEventWithProperties:namestr properties:dics];
        }
        else {
            return @"false";
        }
        return @"true";
    }
    
    if([tgstr isEqualToString:@"sendAppboyEvent"]) {
        if( NCS(namestr) ) {
            [ApplicationDelegate setAppBoyEvent:namestr];
        }
        else {
            return @"false";
        }
        return @"true";
    }
    
    
    return @"NOTHING";
}



+ (BOOL)isThisValidNumberStr:(NSString*)tstr
{
    
    //nil체크
    if (nil == tstr)
        return NO;
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:tstr options:0 range:NSMakeRange(0, tstr.length)];
    
    //정말 number로만 구성되어있나
    if(numberOfMatches == tstr.length){
        
        //숫자라도 0보다 커야만 YES!
        if([tstr intValue] > 0) return YES;
        else return NO;
        
    }else {
        return NO;
    }
    
    
}



+ (BOOL)isThisValidWithZeroStr:(NSString*)tstr
{
    
    //nil체크
    if (nil == tstr)
        return NO;
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:tstr options:0 range:NSMakeRange(0, tstr.length)];
    
    //정말 number로만 구성되어있나
    if(numberOfMatches == tstr.length){
        
        //숫자라도 0보다 커야만 YES!
        if([tstr intValue] >= 0) return YES;
        else return NO;
        
    }else {
        return NO;
    }
    
    
}


+ (BOOL)isthisAdultCerted{
    
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        
        if([cookie.name isEqualToString:@"adult"]
           ){
            if([cookie.value isEqualToString:@"true"] || [cookie.value isEqualToString:@"temp"]){
                return YES;
            }
        }else {
            
        }
        
        // NSLog(@"COOOKIE1 GSShop cookies  ================== %@ === %@", cookie.name,cookie.value );
    }
    return NO;
    
    
}


+ (NSString *)currentLocaleStr {
    
    
    //========================================== 지역 설정 값 =====================================
    //NSLocale *locale = [NSLocale currentLocale];
    //NSString* conCode = [locale objectForKey:NSLocaleCountryCode];
    //NSString* conName = [locale displayNameForKey:NSLocaleCountryCode value:conCode];
    
    // 국가 리전 코드 값은
    //http://lifehack.kr/90095666575
    //========================================== 언어 설정 값 =====================================
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *localestr;
    
    if( languages == nil && [languages count] <= 0) {
        localestr = @"KR";
        
    }else{
        
        NSString* currentLanguage = [languages objectAtIndex:0];
        
        
        //언어 설정 우선
        if([currentLanguage hasPrefix:@"zh"])
        {
            //중국어 간체 simplefied
            //zh-Hans-US (simplefied-간체)
            //zh-Hant-US (traditional)
            
            if([currentLanguage hasPrefix:@"zh-Hans"]){
                
                localestr = @"CH";
            }else {
                // 홍콩,번체는 KR취급
                localestr = @"KR";
            }
            
            
        }
        else if([currentLanguage hasPrefix:@"en"])
        {
            //영문
            //en-US en-AU
            localestr = @"EN";
            
        }
        
        else
        {
            //한글 기본
            //ko-KR
            localestr = @"KR";
            
        }
        
        NSLog(@"showlocale= %@",  [NSString stringWithFormat:@"랭귀지 선택 \n 앱랭귀지: %@ \n ",currentLanguage]);
        
    }
    
    
    
    return localestr;
}

//20160310 parksegun 시스템 노티센터 열기
+ (void) systemNofificationCenterOpen
{
    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


+ (NSString *) getIDMask:(NSString *)strInput
{
    ///////
    // nami0342 - User ID masking
    NSString *strUserId = strInput;
    NSString *strMaskedUserId;
    
    if(strUserId != nil)
    {
        NSArray *arEmail = [strUserId componentsSeparatedByString:@"@"];
        NSRange range;
        
        if([arEmail count] > 1)
        {   // Email ID - @앞에서 3자리 ***  / 단, 3자리 이하는 무조건 *** 로
            NSString *strEmailId = [arEmail objectAtIndex:0];
            
            if([strEmailId length] > 3)
            {
                range.length = 3;
                range.location = [strEmailId length] - 3;
            }
            else 
            {
                range.location = 0;
                range.length = [strEmailId length];
            }
        }
        else
        {   // Non Email ID - 뒤에서 3자리 / 단, 3자리 이하는 무조건 *** 로
            if([strUserId length] > 3)
            {
                range.location = [strUserId length] - 3;
                range.length = 3;
            }
            else
            {
                range.location = 0;
                range.length = [strUserId length];
            }
        }
        
        strMaskedUserId = [strUserId stringByReplacingCharactersInRange:range withString:@"***"];
    }
    
    return strMaskedUserId;
}


// nami0342 - URL 인코딩된 특정 문자를 찾아서 그 문자가 있으면 디코딩 해서 응답
+ (NSString *) getURLEndcodingCheck : (NSString *) strURL
{
    
    NSString *strReturn = @"";
    
    
    if ([[strURL lowercaseString] rangeOfString:@"%2f"].location != NSNotFound)       // '/'  << 이걸 찾는다.
    {
        strReturn = [strURL stringByRemovingPercentEncoding];
    }
    else if ([[strURL lowercaseString] rangeOfString:@"%3a"].location != NSNotFound )  // ':'  << 이걸 찾는다.
    {
        strReturn = [strURL stringByRemovingPercentEncoding];
    }
    else
    {
        strReturn = [NSString stringWithString:strURL];
    }
    
    return strReturn;
}


// nami0342 - 탈옥 체크
+ (BOOL) isJailBreak
{
    NSString *cydiaPath = @"/Applications/Cydia.app";           // Cydia 다운로드용 앱 체크
    NSString *aptPath = @"/private/var/lib/apt/";               // Private 함수 접근 상태 체크
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        return YES;
    }
    
    if ([FileUtil fileExistsAtPath:aptPath] == YES) {
        return YES;
    }
    
    return NO;
}


// nami0342 - 앱 위/변조 체크 - 수정 필요
+ (BOOL) isOriginalApp
{
    //    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //    NSString *path = [NSString stringWithFormat:@"%@/Info.plist", bundlePath];
    //    NSString *path2 = [NSString stringWithFormat:@"%@/GSSHOP-APPSTORE", bundlePath];
    //    NSString *strPkg = [NSString stringWithFormat:@"%@%@", @"Pkg", @"Info"];
    //    NSDate* infoModifiedDate = [[[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:YES] fileModificationDate];
    //    NSDate* infoModifiedDate2 = [[[NSFileManager defaultManager] fileAttributesAtPath:path2 traverseLink:YES] fileModificationDate];
    //    NSDate* pkgInfoModifiedDate = [[[NSFileManager defaultManager] fileAttributesAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:strPkg] traverseLink:YES] fileModificationDate];
    //
    //    NSLog(@"infoModifiedDate : %@", infoModifiedDate);
    //    NSLog(@"infoModifiedDate2 : %@", infoModifiedDate2);
    //    NSLog(@"pkgInfoModifiedDate : %@", pkgInfoModifiedDate);
    //
    //
    //    if(fabs([infoModifiedDate timeIntervalSinceReferenceDate] - [pkgInfoModifiedDate timeIntervalSinceReferenceDate]) > 600) {
    //        return NO;
    //    }
    //    if(fabs([infoModifiedDate2 timeIntervalSinceReferenceDate] - [pkgInfoModifiedDate timeIntervalSinceReferenceDate]) > 600) {
    //#if DEBUG
    //        return YES;
    //#else
    //        return NO;
    //#endif
    //    }
    
    return YES;
}




+(void)setImageView:(UIImageView *)imgView withStrURL:(NSString *)imageURL{
    
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache)
                {
                    imgView.image = fetchedImage;
                }
                else
                {
                    imgView.alpha = 0;
                    imgView.image = fetchedImage;
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             
                                             imgView.alpha = 1;
                                             
                                         }
                                         completion:^(BOOL finished) {
                                             
                                         }];
                    });
                }
                
            });
        }
    }];
}


+(void)setButtonImage:(UIButton *)btn strUrl:(NSString *)strUrl forState:(UIControlState)state{
    
    [ImageDownManager blockImageDownWithURL:strUrl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [strUrl isEqualToString:strInputURL]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache) {
                    
                    NSLog(@"Data from cache Image");
                    [btn setImage:fetchedImage forState:state];
                    
                } else {
                    
                    
                    btn.alpha = 0;
                    
                    [btn setImage:fetchedImage forState:state];
                    
                    // nami0342 - main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             
                                             btn.alpha = 1;
                                             
                                         }
                                         completion:^(BOOL finished) {
                                             
                                         }];
                    });
                    
                }
            });
            
        }
    }];
    
}







// Set a data to local file.
+ (BOOL) setLocalData: (id) objValue forKey : (id) objKey{
    
    // Check a data in the memory.
    if(objKey == nil)
        return NO;
    
    @synchronized ([Common_Util sharedInstance].m_dicLocalData)
    {
        if(objValue == nil)
        {
            [[Common_Util sharedInstance].m_dicLocalData removeObjectForKey:objKey];
        }
        else
        {
            [[Common_Util sharedInstance].m_dicLocalData setValue:objValue forKey:objKey];
        }
        
        // Save to the local file.
        return YES;
    }
}


// Get a string value from local file.
+ (id) loadLocalData : (id) objKey{
    
    
    if(objKey == nil)
        return nil;
    
    
    @synchronized ([Common_Util sharedInstance].m_dicLocalData)
    {
        return [[Common_Util sharedInstance].m_dicLocalData objectForKey:objKey];
    }
}


- (BOOL) loadLocalDataFromDisk
{
    @synchronized ([Common_Util sharedInstance].m_dicLocalData)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = NCA(paths)?[paths objectAtIndex:0]:@"";
        NSString *strSavePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"gsshopsetting.local"];
        
        // Store a data to the local file with file replace.
        NSData *dLoad = [[NSData alloc] initWithContentsOfFile:strSavePath];
        
        if(dLoad == nil)
        {
            return NO;
        }
        
        [Common_Util sharedInstance].m_dicLocalData = (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:dLoad];
        NSLog(@"%@",[Common_Util sharedInstance].m_dicLocalData );
        return YES;
    }
}


- (BOOL) saveToLocalData{
    
    
    @synchronized (self.m_dicLocalData)
    {
        BOOL isReturn = NO;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = NCA(paths)?[paths objectAtIndex:0]:@"";
        NSString *strSavePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"gsshopsetting.local"];
        
        // Store a data to the local file with file replace.
        NSData *dSave = [NSKeyedArchiver archivedDataWithRootObject:self.m_dicLocalData];
        isReturn = [dSave writeToFile:strSavePath atomically:YES];
        return  isReturn;
    }
    
}

// Background / App 정상 종료 시 메모리를 디스크로 저장
- (void) goBackground
{
    [self saveToLocalData];
}

// App Foreground로 이동 시 디스크에서 메모리로 적재
- (void) goBecameActive
{
    [self loadLocalDataFromDisk];
}

// Timer로 1분에 한 번씩, 메모리를 디스크로 적재.
+ (void) autoSave
{
    [_instance saveToLocalData];
}


// GET APPLE ID
+ (NSString *) getAppleADID
{
    NSUUID *uuidAID = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    
    NSString *strAID = [uuidAID UUIDString];
    if(strAID != nil && [strAID length] > 0)
        return  strAID;
    else
        return @"";
}


//
+ (NSString *) createUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = ( NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}



+ (NSString *) getKeychainUUID
{
    NSString *strReturn;
    
    strReturn = [[Common_Util sharedInstance] getUUIDWithService:GS_KEYCHAIN_SERVICE acount:GS_KEYCHAIN_ACCOUNT];
    
    return NCS(strReturn);
}


- (NSString *) getUUIDWithService : (NSString *) strServiceName  acount: (NSString *) strAccount
{
    NSString *strUUID;
    
    if(strServiceName == nil || [NCS(strServiceName) length] == 0)
    {
        strServiceName = GS_KEYCHAIN_SERVICE;
    }
    
    
    if(strAccount == nil || [NCS(strAccount) length] == 0)
    {
        strAccount = GS_KEYCHAIN_ACCOUNT;
    }
    
    
    // Find keychain in the keycahin storage.
    NSData *dResult = [self checkKeychainWith:strServiceName account:strAccount];
    
    if(NCO(dResult) == NO)
    {
        /*
         // Apple AD id로 변경 필요
         NSUUID *uuidAID = [[ASIdentifierManager sharedManager] advertisingIdentifier];
         
         NSString *strAID = [uuidAID UUIDString];
         if(strAID != nil && [strAID length] > 0)
         return  strAID;
         else
         return @"";
         */
        // Create a new keychain for service.
        CFUUIDRef uuidObj = CFUUIDCreate(nil);
        NSString *newUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
        CFRelease(uuidObj);
        
        
        
        // Set key dictionary for Quering.
        NSMutableDictionary *dicQuery = [[NSMutableDictionary alloc] init];
        [dicQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [dicQuery setObject:strServiceName forKey:(__bridge id)kSecAttrService];
        [dicQuery setObject:[strAccount dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecAttrAccount];
        [dicQuery setObject:[newUUID dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
        [dicQuery setObject:(id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
        
        CFTypeRef result = NULL;
        OSStatus status;
        status = SecItemAdd((__bridge CFDictionaryRef)dicQuery, &result);
        
        if(status != noErr)
        {
            // Fail to set password to service chain.
            NSLog(@"KKKKKKKKKKK = Fail to set password");
            strUUID = newUUID;
        }
        else
        {
            strUUID = newUUID;
            NSLog(@"KKKKKKKKKKK = Success to set password : %@", strUUID);
        }
    }
    else
    {
        // 검색해서 찾았으니 저장된 UUID 리턴
        strUUID = [[NSString alloc] initWithData:dResult encoding:NSUTF8StringEncoding];
        NSLog(@"KKKKKKKKKKK = Success to load UUID : %@", strUUID);
    }
    
    
    return strUUID;
}


- (NSData *) checkKeychainWith : (NSString *) strServiceName account : (NSString *) strAccount
{
    NSData *dReturn = nil;
    
    // Set key dictionary for Quering.
    NSMutableDictionary *dicQuery = [[NSMutableDictionary alloc] init];
    [dicQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [dicQuery setObject:strServiceName forKey:(__bridge id)kSecAttrService];
    [dicQuery setObject:strAccount forKey:(__bridge id)kSecAttrAccount];
    
    [dicQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [dicQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFTypeRef result = NULL;
    OSStatus status;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)dicQuery, &result);
    
    if(status != noErr)
    {
        // 일시적인 에러면 어카지?
    }
    else
    {
        dReturn = (__bridge_transfer NSData *)result;
    }
    
    return dReturn;
}

+ (void)checkPassWordChangeAlertShowWithUrl:(NSString *)strUrl andUserKey:(NSString *)userKey{
    
    NSString *strSHA256UserKey = [Common_Util getSHA256:userKey];
    
    if(LL(strSHA256UserKey) == nil) {
        
        ChangePWPopupView  *viewChangePw = [[[NSBundle mainBundle] loadNibNamed:@"ChangePWPopupView" owner:self options:nil] firstObject];
        viewChangePw.strChangeUrl = strUrl;
        viewChangePw.strUserKey = userKey;
        [ApplicationDelegate.window addSubview:viewChangePw];
        
        return;
    }
    
    NSDate * today = [NSDate date];
    NSDate * dayBefore30 = (NSDate *)(LL(strSHA256UserKey));
    
    NSLog(@"todaytoday = %@",today);
    NSLog(@"dayBefore30 = %@",dayBefore30);
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags = NSCalendarUnitDay;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:dayBefore30
                                                  toDate:today options:0];
    
    NSInteger days = [components day];
    NSLog(@"days = %ld",(long)days);
    if(days >= 30){
        // 다시보지 않음 설정 30일
        ChangePWPopupView  *viewChangePw = [[[NSBundle mainBundle] loadNibNamed:@"ChangePWPopupView" owner:self options:nil] firstObject];
        viewChangePw.strChangeUrl = strUrl;
        viewChangePw.strUserKey = userKey;
        [ApplicationDelegate.window addSubview:viewChangePw];
        
    }
    
}


+ (BOOL)ShowRecommendPushAgreePopup{
    
    if(LL(PROMOTIONPOPUP_PUSHAGREE_NO7DAY) == nil) {
        
        return YES;
    }
    
    NSDate * today = [NSDate date];
    NSDate * dayBefore7 = (NSDate *)(LL(PROMOTIONPOPUP_PUSHAGREE_NO7DAY));
    
    NSLog(@"todaytoday = %@",today);
    NSLog(@"dayBefore7 = %@",dayBefore7);
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags = NSCalendarUnitDay;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:dayBefore7
                                                  toDate:today options:0];
    
    NSInteger days = [components day];
    NSLog(@"days = %ld",(long)days);
    
    if(days >= 7){
        return YES;
    }else{
        return NO;
    }
    
}

+ (BOOL)ShowPersonalPopupWithCloseDate:(NSDate *)dateClose{
    
    NSDate * today = [NSDate date];
    
    NSLog(@"todaytoday = %@",today);
    NSLog(@"dateClose = %@",dateClose);
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags = NSCalendarUnitDay;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:dateClose
                                                  toDate:today options:0];
    
    NSInteger days = [components day];
    NSLog(@"ShowPersonalPopupWithCloseDatedays = %ld",(long)days);
    
    if(days > 0){
        return YES;
    }else{
        return NO;
    }
    
}

// 29cm용 강재개행 코드치환 메서드
+ (NSString *)forcedLineFeedfor29CM:(NSString *)str {
    return [NCS(str) stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
}

// 29cm용 라인스페이스 적용
+ (NSAttributedString *)attLineSpace:(NSString*)str space:(CGFloat) value {
    NSMutableAttributedString* attrString = [[NSMutableAttributedString  alloc] initWithString:str];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:value];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, attrString.length)];
    return attrString;
}

+ (NSString *) makeUrlWithParam:(NSString *)url parameter:(NSString*)param {
    if([NCS(param) length] > 0 ) {
        if([NCS(url) rangeOfString:@"?"].location == NSNotFound ) {
            return [NSString stringWithFormat:@"%@?%@",NCS(url),NCS(param)];
        }
        else {
            return [NSString stringWithFormat:@"%@&%@",NCS(url),NCS(param)];
        }
    }
    else {
        return NCS(url);
    }
}

+ (void)checkTVUserPassWordChangeAlertShowWithUrl:(NSString *)strUrl andUserKey:(NSString *)userKey {
    NSString *strSHA256UserKey = [Common_Util getSHA256:userKey];
    if(LL(strSHA256UserKey) == nil) {
        ChangeTVPWPopupView  *viewChangePw = [[[NSBundle mainBundle] loadNibNamed:@"ChangeTVPWPopupView" owner:self options:nil] firstObject];
        viewChangePw.strChangeUrl = strUrl;
        viewChangePw.strUserKey = userKey;
        [ApplicationDelegate.window addSubview:viewChangePw];
        return;
    }
    
    NSDate * today = [NSDate date];
    NSDate * dayBefore180 = (NSDate *)(LL(strSHA256UserKey));
    
    NSLog(@"todaytoday = %@",today);
    NSLog(@"dayBefore30 = %@",dayBefore180);
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:dayBefore180
                                                  toDate:today options:0];
    NSInteger days = [components day];
    NSLog(@"days = %ld",(long)days);
    
    if(days >= 30){
        ChangePWPopupView  *viewChangePw = [[[NSBundle mainBundle] loadNibNamed:@"ChangeTVPWPopupView" owner:self options:nil] firstObject];
        viewChangePw.strChangeUrl = strUrl;
        viewChangePw.strUserKey = userKey;
        [ApplicationDelegate.window addSubview:viewChangePw];
    }
}

//이미지 비율에 따라 비율에 맞는 높이를 반환한다.
+ (CGFloat)imageRatioForHeight:(CGSize)size fullWidthSize:(CGFloat)fullWidth {
    if(size.width != 0 || size.height != 0) {
        CGFloat fwidth = fullWidth > 0 ? fullWidth : APPFULLWIDTH;
        return round((size.height/size.width) * fwidth);
    }
    else {
        return 0;
    }
}

+ (BOOL) isAllDigits:(NSString *)str
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [str rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound && str.length > 0;
}


//엄마가 부탁해 이미지 합성
+ (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    
    CGSize size = CGSizeMake(firstImage.size.width,firstImage.size.height);
    UIGraphicsBeginImageContext(size);
    
    CGPoint pointImg1 = CGPointMake(0,0);
    [firstImage drawAtPoint:pointImg1];
    
    [secondImage drawInRect:CGRectMake(0.0, 0.0, firstImage.size.width, firstImage.size.height)];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

//웹뷰 빈화면노출 처리 체크
+ (BOOL)checkBlankWebView:(GSWKWebview*) wview urlUse:(BOOL) curUrlUse {
    //20160311 parksegun back이던, 화면 쓸어넘기기로 뒤로가기 했을경우 흰색화면(addBasketForward.gs)이 나오는 현상(비로그인시 주문할때 로그인창 다녀오고 나서 생김) 해결
    // 상담신청 바로구매시 주문서?로 바로 이동됨. 이때 비로그인시 toapp처리를 통해 로그인창이 호출되는데 로그인을 하지 않고 back하면 하얀 화면이 나옴(blank, wview.request.URL.absoluteString 이 "") 그래서 로그인 화면에서 하위 웹뷰에
    // 특정 URL을 호출하지 않는다면 닫도록 처리 특정 URL을 호출하는 여부 체크는 curUrlUse를 통해 체크.
    // /member/mobileCertLogin.gs => 휴대폰 로그인 부분.. 백화현상
    // /member/tvLoginTry.gs ==> TV번호로그인 백화현상
    // curUrlUse이 처음 호출될때는 문제 없이 통과 되고 다시 뒤로 돌아 올때는 닫기 호출.... (toapp://back인지, 사용자 뒤로가기인지 체크가 필요한데.. 알수 없다.)
    return (wview != nil  &&
            ([Mocha_Util strContain:@"/member/tvLoginTry.gs" srcstring:NCS(wview.URL.absoluteString)] ||
             [Mocha_Util strContain:@"/member/mobileCertLogin.gs" srcstring:NCS(wview.URL.absoluteString)] ||
             [Mocha_Util strContain:@"addBasketForward.gs?" srcstring:NCS(wview.URL.absoluteString)] ||
             [Mocha_Util strContain:@"about:blank" srcstring:NCS(wview.URL.absoluteString)] ||
             wview.URL.absoluteString == nil ||
             [wview.URL.absoluteString isKindOfClass:[NSNull class]] )
            &&  curUrlUse == NO);
    
}


// App scheme가 plist에 등록되어 있는지 체크
+ (BOOL) hasURLSchemes :(NSString *)scheme
{
    if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"LSApplicationQueriesSchemes"])
    {
        NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LSApplicationQueriesSchemes"];
        
        for(NSString *strScheme in urlTypes)
        {
            if([strScheme isEqualToString:scheme] == YES)
            {
                return YES;
            }
        }
    }
    return NO;
}




//전체 높이중 55%가 늘어나는 영역이라면 55
+ (float)DPRateVAL:(float)tval withPercent:(float)perc {
    if (isIpad) {
        CGFloat rato = APPFULLWIDTH / 320.0;
        return   tval -  ((tval/100)*perc) +  (((tval/100)*perc) * rato);
    } else {
        // 아이폰인 경우,
        // 아이폰 320 대비 비율값 리턴
        // ex) 375 * 667(아이폰6) -> 375 / 320 = 1.171875
    
        if(getLongerScreenLength == 480) {
            return tval;
        }
        else if(getLongerScreenLength == 568) {
            
            return tval;
            
            // nami0342 - iPhoneX 추가
        } else if(getLongerScreenLength == 667 || getLongerScreenLength == 812) {
            
            return   tval -  ((tval/100)*perc) +  (((tval/100)*perc) * 1.171875) ;
        }
        
        else if(getLongerScreenLength == 736 || getLongerScreenLength == 896) { // Kiwon : XR, Xs MAX 런치이미지 원복 19.06.10
            
            return   tval -  ((tval/100)*perc) +  (((tval/100)*perc) * 1.29375) ;
        }
        
        else if(getLongerScreenLength == 1024) {
            
            return   tval -  ((tval/100)*perc) +  (((tval/100)*perc) * 2.4);
            
        }else {
            
            return tval;
        }
    
    }
}


//가변높이영역 100%기준
+ (float)DPRateOriginVAL:(float)tval{
    if (isIpad) {
        CGFloat rato = APPFULLWIDTH / 320.0;
        return   tval * rato;
        
    } else {
        // 아이폰인 경우,
        // 아이폰 320 대비 비율값 리턴
        // ex) 375 * 667(아이폰6) -> 375 / 320 = 1.171875
        
        if(getLongerScreenLength == 480) {
            return tval;
        }
        else if(getLongerScreenLength == 568) {
            
            return tval;
            
        } else if(getLongerScreenLength == 667 || getLongerScreenLength == 812) {
            
            return tval * 1.171875;
        }
        
        else if(getLongerScreenLength == 736 || getLongerScreenLength == 896) { // Kiwon : XR, Xs MAX 런치이미지 원복 19.06.10
            
            return tval * 1.29375;
        }
        
        else if(getLongerScreenLength == 1024) {
            
            return tval * 2.4;
        }else {
            
            return tval;
        }
        
    }
}

//이미지 업로드시 600리사이즈
+ (UIImage *)imageResizeForGSUpload:(UIImage *)imageToUpload{
    
    
    float widthLimit = PHOTOUPLOADWIDTHLIMIT;
    NSLog(@"widthLimit = %f",widthLimit);
    
    
    float actualHeight = imageToUpload.size.height;
    float actualWidth = imageToUpload.size.width;
    
    
    UIImage *img;
    if (imageToUpload.size.width > widthLimit) {
        
        float imgRatio = widthLimit / actualWidth;
        actualHeight = imgRatio * actualHeight;
        actualWidth = widthLimit;
        
        CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        [imageToUpload drawInRect:rect];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        img = imageToUpload;
    }
    
    return img;
}


// js스크립트 처리 iOSScript 핸들러
+ (NSString *) wkScriptAction:(WKScriptMessage *)message delegate:(id)target {
    
    NSString *strReturn = @"";
    
    if([message.name isEqualToString:@"iOSScript"] == YES) {
        NSDictionary *dicTemp;
        
        if(message.body != nil) {
            if([message.body isKindOfClass:[NSDictionary class]] == YES) {
                dicTemp = message.body;
            }
            else {
                NSString *strTemp = [message.body stringByRemovingPercentEncoding];
                dicTemp = [strTemp JSONtoValue];
            }
        }
        
        
        if(NCO(dicTemp) == YES) {
            // Get event key
            NSString *strActkey = [dicTemp objectForKey:@"actkey"];
            NSString *strEventname = [dicTemp objectForKey:@"eventName"];
            NSDictionary *dicValue = [dicTemp objectForKey:@"reqparam"];
            NSString *strCallback = [dicTemp objectForKey:@"callback"];
            
            if([@"sendAMPEventProperties" isEqualToString:strActkey] == YES) {
                // nami0342 - Send Amplitude event with properties
                if( NCO(dicValue) && [NCS(strEventname) length] > 0 ) {
                    [ApplicationDelegate setAmplitudeEventWithProperties:strEventname properties:dicValue];
                }
            }
            else if([@"sendAMPEvent" isEqualToString:strActkey] == YES) {
                // nami0342 - Send Amplitude event without properties
                if( [NCS(strEventname) length] > 0 ) {
                    [ApplicationDelegate setAmplitudeEvent:strEventname];
                }
            }
            else if([@"isWifiDataConfirm" isEqualToString:strActkey] == YES) {
                /*
                 web->app 퍼미션 요청 브릿지
                 181 이상에서만 호출됨
                 *
                 wifi 여부를 반환
                 단. 모바일 데이터가 이미 동의가 되어 있는 wifi 켜져 있지 않더라도, true 반환
                 *
                 @param confirmFlag
                 "Y"
                 데이터 동의도 봐주세요
                 ex) wifi X 동의 O = true
                 @return
                 true : wifi O || 동의 O
                 false : wifi X || 동의 X ===> 불분명할때,
                 
                 wifi O || 동의 X = true
                 
                 */
                
                
                if([[DataManager sharedManager].strGlobal3GAgree isEqualToString:@"Y"] ) {
                    //콜백이 있을떄만
                    if( [NCS(strCallback) length] > 0 ) {
                        [target callJscriptMethod:[NSString stringWithFormat:@"%@('%@')",strCallback,@"true"] ];
                        return strReturn; //strReturn 값은 의미 없음 여기서 끊어야해서 추가
                    }
                }
                else {
                    if([NetworkManager.shared currentReachabilityStatus] == NetworkReachabilityStatusViaWiFi) {
                        //콜백이 있을떄만
                        if( [NCS(strCallback) length] > 0 ) {
                            [target callJscriptMethod:[NSString stringWithFormat:@"%@('%@')",strCallback,@"true"] ];
                            return strReturn; //strReturn 값은 의미 없음 여기서 끊어야해서 추가
                        }
                    }
                    else {
                        //콜백이 있을떄만
                        if( [NCS(strCallback) length] > 0 ) {
                            [target callJscriptMethod:[NSString stringWithFormat:@"%@('%@')",strCallback,@"false"] ];
                            return strReturn; //strReturn 값은 의미 없음 여기서 끊어야해서 추가
                        }
                    }
                }
                
            }//else if
            else if([@"isDataConfirm" isEqualToString:strActkey] == YES) {
                NSString *rValue = @"false"; //true, false
                if([[DataManager sharedManager].strGlobal3GAgree isEqualToString:@"Y"]) {
                    rValue = @"true";
                }
                //콜백이 있을떄만
                if( [NCS(strCallback) length] > 0 ) {
                    [target callJscriptMethod:[NSString stringWithFormat:@"%@('%@')",strCallback,rValue] ];
                }
            }//else if
            
        }else{
            //1. 들어온 값이 딕셔너리가 아니다
            //2. 스트링을 들어온 값을 딕셔너리 전환을 했는데 안된다 (key,value 전환 안됨)
            //3. 따라서 body 가 그냥 스트링이다
            
            NSString *strTemp = NCS([message.body stringByRemovingPercentEncoding]);
            
            if ([strTemp length] > 0 && [@"layerOpen" isEqualToString:strTemp]) {
                strReturn = @"layerOpen";
            }else if ([strTemp length] > 0 && [@"layerClose" isEqualToString:strTemp]) {
                strReturn = @"layerClose";
            } else {
                return strTemp;
            }
        }
    }
    
    return strReturn;
}

- (NSString *) connectedToNetwork {
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        NSLog(@"error");
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    
    
    if (isReachable && !needsConnection && !nonWiFi) {
        // Wifi 연결상태
        return @"Wifi Connected";
    } else if(isReachable && !needsConnection && nonWiFi){
        // 셀룰러 연결상태 (3G / 4G LTE 등)
        return @"3G/LTE Connected";
    } else {
        // 네트워크 미연결 상태
        return @"Disconnected";
    }
}


// 코너 라운드 설정
+ (void) cornerRadius:(UIView *) view byRoundingCorners:(UIRectCorner)corners cornerSize:(CGFloat) size {
    UIBezierPath *maskPath_go = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners  cornerRadii:CGSizeMake(size, size)];
    CAShapeLayer *maskLayer_go = [CAShapeLayer layer];
    maskLayer_go.frame = view.bounds;
    maskLayer_go.path = maskPath_go.CGPath;
    view.layer.mask = maskLayer_go;
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(NSAttributedString *)attributedBenefitString:(NSDictionary *)dicRow widthLimit:(CGFloat)widthLimit lineLimit:(NSInteger)intLineLimit {
    return [Common_Util attributedBenefitString:dicRow widthLimit:widthLimit lineLimit:intLineLimit fontSize:13.0];
}

+(NSAttributedString *)attributedBenefitString:(NSDictionary *)dicRow widthLimit:(CGFloat)widthLimit lineLimit:(NSInteger)intLineLimit fontSize:(CGFloat)fontSize {
    
    NSMutableAttributedString *strReturn = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSInteger lineCount = 1;
    
    //- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(nullable NSStringDrawingContext *)context NS_AVAILABLE(10_11, 6_0);
    
    // TV상품 | 3%적립 ・ 3회사은품 ・ 무료배송 ・ 무이자 ・ 행사상품 ・ 전단상품 ・ 1+1상품
    //@"TV상품",
    
    // Show Message
    NSDictionary *nomalTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                                    NSForegroundColorAttributeName : [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.2] , NSParagraphStyleAttributeName:paragraphStyle
                                    };
    NSDictionary *dotTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.3] , NSParagraphStyleAttributeName:paragraphStyle
                                  };
    
    
    NSString *strSource = nil;
    
    if (NCO([dicRow objectForKey:@"source"]) && [NCS([[dicRow objectForKey:@"source"] objectForKey:@"text"]) length] >0 ) {
        
        NSString *strBold = [NCS([[dicRow objectForKey:@"source"] objectForKey:@"styleType"]) lowercaseString];
        UIFont *font = [@"bold" isEqualToString:strBold]?[UIFont systemFontOfSize:fontSize weight:UIFontWeightBold]:[UIFont systemFontOfSize:fontSize];
        UIColor *color = [UIColor getColor:NCS([[dicRow objectForKey:@"source"] objectForKey:@"type"]) alpha:1.0 defaultColor:[UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.64]];
        NSDictionary *attrText = @{NSFontAttributeName : font,
                                   NSForegroundColorAttributeName : color,
                                   NSParagraphStyleAttributeName:paragraphStyle
                                   };
        
        strSource = NCS([[dicRow objectForKey:@"source"] objectForKey:@"text"]);
        NSAttributedString *strTV = [[NSAttributedString alloc] initWithString:strSource attributes:attrText];
        [strReturn appendAttributedString:strTV];
    }
    
    
    
    
    if (NCA([dicRow objectForKey:@"allBenefit"])) {
        NSArray *arr = [dicRow objectForKey:@"allBenefit"];
        
        //        NSMutableArray *arr = [[NSMutableArray alloc] init];
        //        [arr addObjectsFromArray:[dicRow objectForKey:@"allBenefit"]];
        //        [arr addObjectsFromArray:[dicRow objectForKey:@"allBenefit"]];
        
        
        //[[NSArray alloc] initWithObjects:@"3%적립",@"3회사은품",@"무료배송",@"무이자",@"행사상품",@"전단상품",@"1+1상품", nil];
        for (NSInteger i=0; i<[arr count]; i++) {
            
            NSString *strBene = NCS([[arr objectAtIndex:i] objectForKey:@"text"]);
            if(strBene.length <= 0) {
                continue;
            }
            
            NSMutableAttributedString *strWidthChecker = [[NSMutableAttributedString alloc] initWithAttributedString:[strReturn copy]];
            
            NSAttributedString *strSeparator = nil;
            NSAttributedString *strBenefit = nil;
            
            
            if (i==0 && strSource !=nil) {
                strSeparator = [[NSAttributedString alloc] initWithString:@" | " attributes:nomalTextAttr];
            }else{
                if (strReturn.length > 0) {
                    strSeparator = [[NSAttributedString alloc] initWithString:@" ・ " attributes:dotTextAttr];
                }else{
                    strSeparator = [[NSAttributedString alloc] initWithString:@"" attributes:nomalTextAttr];
                }
                
            }
            
            [strWidthChecker appendAttributedString:strSeparator];
            
            
            NSString *strBold = [NCS([[arr objectAtIndex:i] objectForKey:@"styleType"]) lowercaseString];
            UIFont *font = [@"bold" isEqualToString:strBold]?[UIFont systemFontOfSize:fontSize weight:UIFontWeightBold]:[UIFont systemFontOfSize:fontSize];
            UIColor *color = [UIColor getColor:NCS([[arr objectAtIndex:i] objectForKey:@"type"]) alpha:1.0 defaultColor:[UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.48]];
            NSDictionary *attrText = @{NSFontAttributeName : font,
                                       NSForegroundColorAttributeName : color, NSParagraphStyleAttributeName:paragraphStyle
                                       };
            
            strBenefit = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",strBene] attributes:attrText];
            [strWidthChecker appendAttributedString:strBenefit];
            
            
            
            CGRect rectTest = [strWidthChecker boundingRectWithSize:CGSizeMake(APPFULLWIDTH, 300.0) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            //        NSLog(@"NSStringFromCGRect(rectTest) = %@",NSStringFromCGRect(rectTest));
            //
            //        NSLog(@"widthLimit = %f",widthLimit);
            //        NSLog(@"rectTest.size.width = %f",rectTest.size.width);
            
            
            if (rectTest.size.width <= widthLimit) {
                [strReturn appendAttributedString:strSeparator];
                [strReturn appendAttributedString:strBenefit];
            }else{
                
                if (intLineLimit > 0 && intLineLimit == lineCount) {
                    break;
                }
                
                [strReturn appendAttributedString:[[NSAttributedString alloc] initWithString:@"\r\n" attributes:nomalTextAttr]];
                [strReturn appendAttributedString:strBenefit];
                
                lineCount ++;
            }
            
            
        }
    }
    
    
    
    
    //NSAttributedString *strAttrPGM = [[NSAttributedString alloc] initWithString:strPgmName attributes:nomalTextAttr];
    
    
    
    //[strReturn appendAttributedString:strAttrPGM];
    
    //NSLog(@"strReturn = %@",strReturn);
    if (strReturn.length <= 0 ) {
        return strReturn;
    }
    
    
    NSInteger strLength = [strReturn length];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:3];
    [strReturn addAttribute:NSParagraphStyleAttributeName
                      value:style
                      range:NSMakeRange(0, strLength)];
    
    
    return strReturn;
}

+(NSAttributedString *)attributedProductTitle:(NSDictionary *)dicRow titleKey:(NSString *)strTitleKey{
    
    NSMutableAttributedString *strReturn = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *nomalTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                    NSForegroundColorAttributeName : [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0] , NSParagraphStyleAttributeName:paragraphStyle
                                    };
    
    NSDictionary *boldTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0 weight:UIFontWeightHeavy], NSForegroundColorAttributeName :  [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0], NSParagraphStyleAttributeName:paragraphStyle
                                   };
    if ([NCS([dicRow objectForKey:@"brandNm"]) length] > 0) {
        NSAttributedString *strBrand = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",NCS([dicRow objectForKey:@"brandNm"])] attributes:boldTextAttr];
        [strReturn appendAttributedString:strBrand];
    }
    
    if ([NCS([dicRow objectForKey:strTitleKey]) length] > 0) {
        NSAttributedString *strProductTitle = [[NSAttributedString alloc] initWithString:NCS([dicRow objectForKey:strTitleKey]) attributes:nomalTextAttr];
        [strReturn appendAttributedString:strProductTitle];
    }
    
    NSInteger strLength = [strReturn length];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    [strReturn addAttribute:NSParagraphStyleAttributeName
                      value:style
                      range:NSMakeRange(0, strLength)];
    
    return strReturn;
}

+(NSAttributedString *)attributedReview:(NSDictionary *)dicRow isWidth320Cut:(BOOL)isWidth320Cut{
    
    NSMutableAttributedString *strReturn = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *nomalTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName : [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.48] , NSParagraphStyleAttributeName:paragraphStyle
                                    };
    
    NSDictionary *boldTextAttr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0],
                                   NSForegroundColorAttributeName :  [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.64], NSParagraphStyleAttributeName:paragraphStyle
                                   };
    BOOL is320Cut = NO;
    
    if (isWidth320Cut == YES && APPFULLWIDTH <= 320.0) {
        is320Cut = YES;
    }
    
    
    if ([NCS([dicRow objectForKey:@"addTextLeft"]) length] > 0) {
        NSAttributedString *strLeft = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",NCS([dicRow objectForKey:@"addTextLeft"])] attributes:boldTextAttr];
        [strReturn appendAttributedString:strLeft];
    }
    
    if (is320Cut == NO && [NCS([dicRow objectForKey:@"addTextRight"]) length] > 0) {
        NSAttributedString *strRight = [[NSAttributedString alloc] initWithString:
                                        [NSString stringWithFormat:@" %@",NCS([dicRow objectForKey:@"addTextRight"])] attributes:nomalTextAttr];
        [strReturn appendAttributedString:strRight];
    }
    
    return strReturn;
}


+(NSString *)productImageUrlWithPrdid:(NSString *)strPrdId withType:(NSString *)strType{

    NSString *strPrdImageUrl = nil;
    
    if([strPrdId length] == 8 || [strPrdId length] == 11)
    {
        strPrdImageUrl = [NSString stringWithFormat:@"http://%@/image/%@/%@/%@/%@_%@.jpg",SERVERIMAGEDOMAIN,[strPrdId substringWithRange:NSMakeRange(0, 2)],[strPrdId substringWithRange:NSMakeRange(2, 2)],[strPrdId substringWithRange:NSMakeRange(4, 2)], strPrdId,strType];
    }else {
        strPrdImageUrl = [NSString stringWithFormat:@"http://%@/image/%@/%@/%@_%@.jpg",SERVERIMAGEDOMAIN,[strPrdId substringWithRange:NSMakeRange(0, 2)],[strPrdId substringWithRange:NSMakeRange(2, 2)],strPrdId,strType];
    }
    
    return strPrdImageUrl;
}


#pragma mark
// nami0342 - SHA256
+(NSString *) getSHA256 : (NSString *) input
{
    const char* str = [input cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char strConvert[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), strConvert);
    
    // 헥사 변신하면 32 -> 64자 됨. 복호화 안할꺼니 > < + 관련 필터 불필요
    NSMutableString *strResult = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [strResult appendFormat:@"%02x",strConvert[i]];
    }
    
    NSLog(@"str sha256 Result ====================%@",strResult);

    return strResult;
}

@end
