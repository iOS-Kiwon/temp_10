//
//  Mocha_Define.h
//  Mocha
//
//  Created by Hoecheon Kim on 12. 6. 29..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

/** @page MochaDefine 
 * 
 * @section Mocha_Define.h 설정값
 * - framework내에서 사용할 모든 메크로변수, 환경변수를 설정합니다.
 * - 적용프로젝트에 MOCHA.framework 추가후 DB버전,DBName, SNS Key값, App데이터 저장경로설정 필요.
 *
 */

#import <Foundation/Foundation.h>
#import "Mocha_Util.h"
 
  
//화면 px 정의


#define APPFULLWIDTH [[UIScreen mainScreen] bounds].size.width
#define APPFULLHEIGHT [[UIScreen mainScreen] bounds].size.height

//ipad여부 BOOL
#define isIpad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// 7.0 and above BOOL if(IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()) {
#define IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
// 8.0 and above BOOL if(IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()) {
#define IS_DEVICE_RUNNING_IOS_8_AND_ABOVE()  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#define getLongerScreenLength    (int)MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)


// DB
#define kDataBaseName               @"Mocha_GSSHOP.db"
// DB 업그레이드 처리를 위한 현재 최신 버전 정보 - for App Version Upgrade되면서 바뀌는 DB table 구조처리를 위한...
#define DB_VERSION                          1


//Mocha_SSKeychain UUID 생성관련
// nami0342 - gsshop app 에 신규 모듈 추가
//#define kSSKeychainValidDomain      @"EKD8DV7B2P.gsshopAppFamily"



// Facebook 관련 Facebook framework 3.2 이상 사용시 Info.plist 에 FacebookAppID 111981848987329 키&value 추가 -1정의 및 URLscheme type추가
//#define kFacebookAppId              @"411745752200370"
#define kFacebookAccessTokenKey     @"FBAccessTokenKey"
#define kFacebookExpirationDateKey  @"FBExpirationDateKey"




// Twitter 관련 - 2정의
#define kTwitterOAuthData           @"MochaTwitterOAuthData"
#define kOAuthConsumerKey           [Mocha_Util getSnsKey:@"kOAuthConsumerKey"]
#define kOAuthConsumerSecret        [Mocha_Util getSnsKey:@"kOAuthConsumerSecret"]




// Me2day 관련 - 1 정의
#define kMe2BaseURL                 @"http://me2day.net/api"
#define kGetAuthURLFormat           kMe2BaseURL @"/get_auth_url.json"
#define kGetAuthTokenURLFormat      kMe2BaseURL @"/get_full_auth_token.json?token=%@"
#define kCreatePostURLFormat        kMe2BaseURL @"/create_post/%@.json"
#define kDeletePostURLFormat        kMe2BaseURL @"/delete_post/%@.json"
#define kAuthFieldName              @"Authorization"
#define kAppKeyFieldName            @"me2_application_key"
#define km2dayAppKey                [Mocha_Util getSnsKey:@"km2dayAppKey"]
//@"4e19bc31dfeb694da5b8b8f3138d63ec"

// Yozm 관련 - 3 정의
#define kYozmBaseURL                @"https://apis.daum.net"
#define kYozmRequestTokenURL        kYozmBaseURL @"/oauth/requestToken"
#define kYozmAuthorizeURL           kYozmBaseURL @"/oauth/authorize"
#define kYozmAccessTokenURL         kYozmBaseURL @"/oauth/accessToken"
#define kYozmConsumerKey            [Mocha_Util getSnsKey:@"kYozmConsumerKey"]
#define kYozmConsumerSecret         [Mocha_Util getSnsKey:@"kYozmConsumerSecret"]
#define kYozmCallBackURL            [Mocha_Util getSnsKey:@"kYozmCallBackURL"]

//#define kYozmConsumerKey            @"ab4fdefb-8ace-4098-ad50-bd5c5dfbebf4"
//#define kYozmConsumerSecret         @"hmw2Z_Z8XtcET_.tKIwzlNgrKJgKJCf.lKrvg6Si.fKWsjKXRvK67w00"
//#define kYozmCallBackURL          @"http://mditto.gsshop.com/ditto/index.gs"
//#define kYozmCallBackURL            @"oob"

//KVO SNS postingcount observer naming
#define kKVOSNSPostingCount         @"kKVOSNSPostingCount"
#define kKVOSNSDeletingCount        @"kKVOSNSDeletingCount"
//sns type define
typedef enum {
    SNS_TYPE_ALL,
    SNS_TYPE_TWITTER,
    SNS_TYPE_FACEBOOK,
    SNS_TYPE_ME2DAY,
    SNS_TYPE_YOZM
} SnsType;

//token naming define
//#define TOKEN_TWITTER @"TOKEN_TWITTER"
//#define TOKEN_ME2DAY @"TOKEN_ME2DAY"
//#define TOKEN_YOZM @"TOKEN_YOZM"
 

//#define SNS_TWITTER_LOGIN   1
//#define SNS_TWITTER_LOGOUT  2
//#define SNS_FACEBOOK_LOGIN  3
//#define SNS_FACEBOOK_LOGOUT 4
//#define SNS_ME2DAY_LOGIN   5
//#define SNS_ME2DAY_LOGOUT  6
//#define SNS_YOZM_LOGIN  7
//#define SNS_YOZM_LOGOUT  8



//신뢰할 수 있는 https 서버 도메인 (기재한 도메인에 대해서는 인증서문제 있더라도 통신 정상, 기재한 도메인이 아닌 https서버의인증서문제시 통신 불능)

#define kTrustGSHttpsServer1         @"gsshop.com"
/*
#define kTrustGSHttpsServer1         @"m.gsshop.com"
#define kTrustGSHttpsServer2         @"sm.gsshop.com"
#define kTrustGSHttpsServer3         @"sm13.gsshop.com"
#define kTrustGSHttpsServer4         @"tm13.gsshop.com"
#define kTrustGSHttpsServer5         @"dm13.gsshop.com"
 */

//IOS5 이후 Icloud서비스 떄문에 Documents 디렉토리가 Icloud로 동기화 백업됨
//이에 백업불필요한 데이터 앱 내장 자료 대부분은 CacheDirectory 를 활용권고. 리젝사항 - Apple
//기존 GSHOP sqlite 디비파일 경로를 Cache폴더로이동함.
#define HOME_DIR					NSHomeDirectory()
#define HOME_TMP_DIR				[HOME_DIR stringByAppendingPathComponent:@"tmp"]
#define DOCS_DIR					[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define OLDDOCS_DIR					[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]







//retina관련 @2x 대신 -hd 파일네이밍 사용시
//#define CC_RETINA_DISPLAY_FILENAME_SUFFIX @"-hd"


//retina Webview 사용시 retina 확인 javascript 예제
//var iPhone4 = false;
//if(window.devicePixelRatio && window.devicePixelRatio == 2) { iPhone4 = true; }
