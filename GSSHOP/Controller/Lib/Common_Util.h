//
//  Common_Util.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 13. 12. 26..
//  Copyright (c) 2013년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLDefine.h"
#import "GSWKWebview.h"
#import <CommonCrypto/CommonDigest.h>

//NullCheckString
#define NCS(abc) ((abc != nil &&  ![abc isKindOfClass:[NSNull class]] && [abc isKindOfClass:[NSString class]] && ![abc isEqual:@"<null>"] && ![abc isEqual:@"(null)"])?abc:([abc isKindOfClass:[NSNumber class]]?[NSString stringWithFormat:@"%@", abc]:@""))
//NullCheckArray
#define NCA(array) ((array != nil && ![array isKindOfClass:[NSNull class]] && [array isKindOfClass:[NSArray class]] && [(NSArray *)array count] > 0 )?YES:NO)
//NullCheckObject
#define NCO(obj) ((obj != nil  && ![obj isKindOfClass:[NSNull class]]) ?YES:NO)
//NullCheckBool
#define NCB(bool) ((bool != nil && ![bool isKindOfClass:[NSNull class]] && [bool boolValue] ) ?bool:NO)

//iOS8 warning: Attempting to badge the application icon but haven't received permission from the user to badge the application
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


// Define for Keychain
#define GS_KEYCHAIN_ACCOUNT @"uuid"
#define GS_KEYCHAIN_SERVICE @"EKD8DV7B2P.gsshopAppFamily"






typedef enum{
    ButtonIndexClose = 0,      // 취소(닫기) 버튼 타입정보
    ButtonIndexOK,             // 다른 선택 버튼 타입정보 (예, 실행, 이동 등)
    ButtonIndexOther
}BTNINDEX;

typedef void (^AlertButonIndex)(BTNINDEX index);    // 버튼 이벤트 블럭을 가집니다.


@interface Common_Util : NSObject

@property (nonatomic, copy)       AlertButonIndex     alertBtnIndex;
@property (nonatomic, strong)   NSMutableDictionary     *m_dicLocalData;
@property (nonatomic, strong) NSTimer                   *m_timerAutosave;


+ (Common_Util *)sharedInstance;            // nami0342 - Singleton 함수
+(void) saveExcuteTimeLog;
+(NSString*) writeExcuteTimeLog;
+(NSNumber*) writeExcuteTimeNSnumberLog;

+ (BOOL) isWide4;
+ (BOOL) isRetinaScale;
//
+ (NSString *)commaStringFromDecimal:(int)decimal;
+ (NSString *)commonAPPJSresponse:(NSString*)tgstr eventName:(NSString*)namestr reqparam:(NSString*)reqpstr;

+ (BOOL)isThisValidNumberStr:(NSString*)tstr;
+ (BOOL)isThisValidWithZeroStr:(NSString*)tstr;
+ (BOOL)isthisAdultCerted;

+ (NSString *)currentLocaleStr;
+ (void) systemNofificationCenterOpen;
+ (NSString *) getIDMask : (NSString *) strInput;   // email - 앞 3자리, 그냥 뒤 3자리

+ (NSString *) getURLEndcodingCheck : (NSString *) strURL; // URL encoding 된 URL인지 판단해서 Decoding 해서 반환

+ (BOOL) isJailBreak;       // 탈옥 체크
+ (BOOL) isOriginalApp;     // 앱 위/변조 체크



+(void)setImageView:(UIImageView *)imgView withStrURL:(NSString *)imageURL;
+(void)setButtonImage:(UIButton *)btn strUrl:(NSString *)strUrl forState:(UIControlState)state;


// nami0342 - simple key-value store to local file.
+ (BOOL) setLocalData: (id) objValue forKey : (id) objKey;
+ (id) loadLocalData : (id) objKey;
- (BOOL) saveToLocalData;
- (BOOL) loadLocalDataFromDisk;

// Get Apple AD ID
+ (NSString *) getAppleADID;

// Create UUID
+ (NSString *) createUUID;
+ (NSString *) getKeychainUUID;
- (NSString *) getUUIDWithService : (NSString *) strServiceName  acount: (NSString *) strAccount;
- (NSData *) checkKeychainWith : (NSString *) strServiceName account : (NSString *) strAccount;

// 비밀번호 90일 변경체크
+ (void)checkPassWordChangeAlertShowWithUrl:(NSString *)strUrl andUserKey:(NSString *)userKey;
// TV회원 로그인 번호 변경 체크 (180일)
+ (void)checkTVUserPassWordChangeAlertShowWithUrl:(NSString *)strUrl andUserKey:(NSString *)userKey;

//푸시 수신권유팝업
+ (BOOL)ShowRecommendPushAgreePopup;

//매장 개인화 팝업 닫기버튼 날자와 오늘날자 비교 (하루 기준)
+ (BOOL)ShowPersonalPopupWithCloseDate:(NSDate *)dateClose;
    
// 29cm용 강재개행 코드치환 메서드
+ (NSString *)forcedLineFeedfor29CM:(NSString *)str;
// 29cm용 라인스페이스 적용
+ (NSAttributedString *)attLineSpace:(NSString*)str space:(CGFloat) value;
//url과 param 데이터를 안전하게 합처 준다. A?C
+ (NSString *) makeUrlWithParam:(NSString *)url parameter:(NSString*)param;
//이미지 비율에 따라 비율에 맞는 높이를 반환한다.
+ (CGFloat)imageRatioForHeight:(CGSize)size fullWidthSize:(CGFloat)fullWidth;
//해당 스트링이 모두 넘버형인지 판단
+ (BOOL) isAllDigits:(NSString *)str;
//엄마가 부탁해 이미지 합성
+ (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;
//웹뷰 빈화면노출 처리 체크
+ (BOOL)checkBlankWebView:(GSWKWebview*) wview urlUse:(BOOL) curUrlUse;

+ (BOOL) hasURLSchemes :(NSString *)scheme;                     // App scheme가 plist에 등록되어 있는지 체크

//
//가로기준 세로비율 계산반환  가변높이영역 100%기준
+ (float)DPRateOriginVAL:(float)tval;

//전체 높이중 55%가 늘어나는 영역이라면 perc= 55
+ (float)DPRateVAL:(float)tval withPercent:(float)perc;

//이미지 업로드시 600리사이즈
+ (UIImage *)imageResizeForGSUpload:(UIImage *)imageToUpload;


+ (NSString *) wkScriptAction:(WKScriptMessage *)message delegate:(id)target;

//네트워크 연결 상태 확인
- (NSString *) connectedToNetwork;

+ (void) cornerRadius:(UIView *) view byRoundingCorners:(UIRectCorner)corners cornerSize:(CGFloat) size;
+ (UIImage *)imageWithColor:(UIColor *)color ;

//UI개편 NSAttributedString 메이커
+(NSAttributedString *)attributedBenefitString:(NSDictionary *)dicRow widthLimit:(CGFloat)widthLimit lineLimit:(NSInteger)intLineLimit;
+(NSAttributedString *)attributedBenefitString:(NSDictionary *)dicRow widthLimit:(CGFloat)widthLimit lineLimit:(NSInteger)intLineLimit fontSize:(CGFloat)fontSize ;
+(NSAttributedString *)attributedProductTitle:(NSDictionary *)dicRow titleKey:(NSString *)strTitleKey;
+(NSAttributedString *)attributedReview:(NSDictionary *)dicRow isWidth320Cut:(BOOL)isWidth320Cut;

//상품이미지 prdid파싱 공통로직용
+(NSString *)productImageUrlWithPrdid:(NSString *)strPrdId withType:(NSString *)strType;

// SHA256
+(NSString *) getSHA256 : (NSString *) input;
@end
