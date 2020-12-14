//
//  Mocha_Util.h
//  Mocha
//
//
//  Created by Hoecheon Kim on 12. 5. 31..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#define kLOGIN_Success 1
#define kLOGIN_AutoLogin 2
#define kLOGIN_Fail 3

/**
 * @brief IOS App 개발중 필요로 하는 다양한 Utility 메서드 구현 객체
 * 날짜,시간,문자열,공백체크,문자/전화/지도관련 어플실행 탈옥여부,multitasking가능한 device인가,라운딩 이미지변환 포함.
 */
@interface Mocha_Util : NSObject {
    
}
//가로기준 세로비율 계산반환  가변높이영역 100%기준
+ (float)DPRateOriginVAL:(float)tval;

//전체 높이중 55%가 늘어나는 영역이라면 perc= 55
+ (float)DPRateVAL:(float)tval withPercent:(float)perc;

// 금액으로표시 numberFormat(3,000,000)

/**
 *  숫자 string (NSString)을 금액형태로 세자리수단위 컴마구성 후  받아 NSString 형태의 객체로 반환
 *
 *   @param price 문자포멧으로 변환할 숫자로 구성된 NSString 객체  (NSString)
 *   @return NSString
 *
 */

+ (NSString *) numberFormat:(NSString*)price;


// substring
/**
 *  문자 string (NSString)을 idx값 기준만큼 잘라 NSString 형태의 객체로 반환
 *
 *   @param str substring할 대상 NSString 객체  (NSString)
 *   @param idx 문자의 몇열 까지 자를지에대한 자릿수를 의미하는 NSInteger (NSInteger)
 *   @return NSString
 *
 *   @see substr:(NSString*)str startIndex:(NSUInteger)sidx endIndex:(NSUInteger)eidx
 */
+ (NSString *) substr:(NSString*)str index:(NSInteger)idx;
// substring
// substring
/**
 *  문자 string (NSString)을 sidx값~eidx값의 자릿수 기준만큼 잘라 NSString 형태의 객체로 반환
 *
 *   @param str substring할 대상 NSString 객체  (NSString)
 *   @param sidx 문자의 몇열 까지 자를지에대한 자릿수를 의미하는 NSInteger (NSInteger)
 *   @param eidx 문자의 몇열 까지 자를지에대한 자릿수를 의미하는 NSInteger (NSInteger)
 *   @return NSString
 *
 *   @see substr:(NSString*)str index:(NSInteger)idx
 */
+ (NSString *) substr:(NSString*)str startIndex:(NSUInteger)sidx endIndex:(NSUInteger)eidx;
// trim
/**
 *  문자열 str (NSString)을 받아 공백문자+개행문자를 제거한 후  NSString 형태의 객체로 반환
 *
 *   @param str trim할 대상 NSString 객체  (NSString)
 *   @return NSString
 *
 */
+ (NSString *) trim:(NSString*)str;
// explode
/**
 *  문자열 str (NSString)을 받아 공백문자를 제거한 후  NSArray 형태의 객체로 반환
 *  delimiter 문자로 대상문자열을 나누어 배열로 반환.
 *
 *   @param delimiter explode할 기준이 되는 NSString 객체  (NSString)
 *   @param str explode할 대상 NSString 객체  (NSString)
 *   @return NSString
 *
 */
+ (NSArray *) explode:(NSString*)delimiter string:(NSString*)str;



// strReplace
/**
 *  문자열 str (NSString)을 받아 str내에서 HTML태그 문자열을 제거한 후  NSString 형태의 객체로 반환
 *
 *
 *   @param search 대상문자열에서 찾을 문자열 NSString 객체  (NSString)
 *   @param replace search str을 바꿀 문자열 NSString 객체  (NSString)
 *   @param string 대상 문자열 NSString 객체  (NSString)
 *   @return NSString
 *
 */

+ (NSString *) strReplace:(NSString *)search replace:(NSString *)replace string:(NSString*)str;


// stringByStrippingHTML
/**
 *  문자열 str (NSString)을 받아 str내에서 HTML태그 문자열을 제거한 후  NSString 형태의 객체로 반환
 *
 *
 *   @param str html태그를 제거하기 위한 원시 문자열 NSString 객체  (NSString)
 *   @return NSString
 *
 */
+(NSString*)stringByStrippingHTML:(NSString*)stringHtml;


// strContain
/**
 *  문자열 str (NSString)을 받아 srcstring 에 tgstring이 존재하는지 여부 반환
 *
 *   @param srstr tgstring이 존재하는지 확인하기위한 원시 문자열 NSString 객체  (NSString)
 *   @param tgstring srstr에 존재하는지 확인하기위한 대상 문자열 NSString 객체  (NSString)
 *   @return BOOL
 *
 */
+ (BOOL)strContain:(NSString*)tgstring srcstring:(NSString *)srstr;

// 2010.03.10 포맷으로
/**
 *  Date 문자열 예를 들어 20100305 와 같은 8자리 str (NSString)을 받아 년월일을 구분할 단위문자 divStr을 기준으로 가공하여 NSString 형태의 객체로 반환
 *   ex) [Mocha_Util dateViewFormat:@"20120305" divStr:@"-"]; 수행후 리턴 결과값은 = 2012-03-05
 *
 *   @param divStr date문자열을 표현할 구분형식 NSString 객체  (NSString)
 *   @param dateStr 8자리 년월일 숫자로 구성된 대상 날짜 NSString 객체  (NSString)
 *   @return NSString
 *
 */
+ (NSString*) dateViewFormat:(NSString*)dateStr divStr:(NSString*)divStr;

// int to string convert
/**
 *   int - NSString 형변환
 *
 *
 *   @param intValue  NSString 으로 변환한 NSInteger 객체  (NSInteger)
 *   @return NSString
 *
 */
+ (NSString*) intToString:(NSInteger)intValue;



//UTF-8 에 조합형 뷁과 같은 문자를 ?문자 처리
/**
 *   NSString 문자열에 UTF-8 인코딩으로 지원하지 않는 문자셋 - 예를들어 뷁 과같은문자 - 를 ? 문자로 치환
 *
 *
 *   @param strToCheck  NSString 으로 변환할 대상문자열 (NSString)
 *   @return NSString
 *
 */
+(NSString *)eucKRtoqchar:(NSString *)strToCheck;

//push alert 설정이 가능상태인지 return
/**
 *   iOS 기기의 global option 설정에 APNS 수신이 가능한지 여부 return -push알럿창기준- 가능상태 = YES
 *
 *
 *   @return BOOL
 *
 */

+(BOOL)ispushalertoptionenable;

// iphone 여부
/**
 *   app이 실행되고 있는 Device가 Iphone인가에 대한 결과값 BOOL 리턴
 *   iPad, ipod 구분 필요시 사용
 *
 *   @return BOOL
 *
 */
+ (BOOL) isIPhone;
// 문자/전화/지도관련 어플 실행
/**
 *  문자/전화/외부어플 호출 실행
 *
 *
 *   @param protocol SMS,CALL등 URLScheme protocol string  (NSString)
 *   @param param 호출에 사용될 URL string  (NSString)
 *   @return BOOL(호출 실행성공 여부 YES or NO)
 *
 */
+ (void) systemAppRun:(NSString*)protocol param:(NSString*)param;
// 공백값인가
/**
 *   NSString str 의 공백 확인 결과 BOOL 리턴
 *   textField 및 입력 control의 공백 문자 체크 필요시 사용
 *
 *   @return BOOL(공백 YES or NO)
 *
 */
+ (BOOL) isEmpty:(NSString*)str;

// hex Color값 -> UIColor리턴
/**
 *    hex Color값 -> UIColor리턴
 *
 *
 *   @param hexColor UIColor값으로 변환할 대상 HEX Color 문자열  (NSString)
 *   @return UIColor
 *
 */
+ (UIColor *) getColor: (NSString *) hexColor;
/**
 *  입력한 날짜의 date 스트링을 시간을 포함할지 여부인  BOOL값 ishour를 바탕으로
 *  날짜 포멧을 결정하여 NSString 형태로 date string 가공하여 반환
 *
 *   @param date 날짜 포멧 변경할 date string  (NSString)
 *   @param hour 시간 단위를 포함한 결과값을 리턴할지에대한 BOOL  (BOOL)
 *   @return NSString
 *
 */
+ (NSString *) getDate:(NSString *)date hour:(BOOL)ishour;
//doxygen 분석제외
/// @cond UTIL_Detour
+ (NSString *)getCurrentDate:(BOOL)ishour;
+ (NSString *) getDateforInfo:(NSString *)date;
+ (NSString *) getDateLeft:(NSString *)date;
+ (BOOL) isEndDate:(NSString *)date;
+ (NSMutableString *) getXmlParameter:(NSMutableDictionary *)parameter;
+ (NSMutableString*) getCardNoParser:(NSString*)cardno;
+ (NSDate *) date:(NSDate *)fromDate byAddingMonth:(int)monthOffset;
+ (NSDate *) date:(NSDate *)fromDate byAddingDay:(int)dayOffset;
+ (NSDate *) date:(NSDate *)fromDate byAddingYear:(int)yearOffset;
///@endcond

//탈옥여부체크
/**
 *   App 구동 Device의 환경이 탈옥을 했는지 여부 체크 결과값 반환
 *   @return BOOL
 *
 */
+(BOOL) isthisCydia;

//멀티태스킹 가능여부
/**
 *   App 구동 Device의 환경이 멀티태스킹 가능여부 체크 결과값 반환
 *   IOS 버전기반 체크
 *   @return BOOL
 *
 */
+ (BOOL)isMultitaskingOS;
//앱실행상태확인
/**
 *   App 구동 상태 체크 - 포그라운드상태인가에 대한 BOOL값 리턴
 *   UIApplicationState 체크
 *   @return BOOL
 *
 */
+ (BOOL)isForeground;

//라운드/gloss이미지 반환(마스크이미지 리소스 참조필요)
/**
 *  사각형의 UIImage를 받아 모서리 Radius 조정 - 둥근 모서리 이미지 변환후 UIImage 반환
 *  라운드/gloss이미지 반환(마스크이미지 리소스 참조필요)
 *
 *   @param image 모서리를 둥글게-아이폰메인 아이콘들과 같은 효과를 넣을 대상 UIImage  (UIImage)
 *   @return UIImage
 *
 */
+ (UIImage*)glossImageForImage:(UIImage*)image;



//SNS키 묶음 반환
/**
 *  SNS관련 키 get 을 위한 메서드
 *
 *
 *   @param keyname value에 매칭되는 SNS key이름
 *   @return NSString
 *
 */
+ (NSString*)getSnsKey:(NSString*)keyname;
@end
