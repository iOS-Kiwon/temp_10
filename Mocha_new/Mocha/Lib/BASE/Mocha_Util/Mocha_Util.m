//
//  Mocha_Util.m
//  Mocha
//
//
//  Created by Hoecheon Kim on 12. 5. 31..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "Mocha_Util.h"
#import "Mocha_Define.h"

@implementation Mocha_Util



//전체 높이중 55%가 늘어나는 영역이라면 55
+ (float)DPRateVAL:(float)tval withPercent:(float)perc {
    
    
    
    if(getLongerScreenLength == 480) {
        return tval;
    }
    else if(getLongerScreenLength == 568) {
        
        return tval;
        
        // nami0342 - iPhoneX 추가
    } else if(getLongerScreenLength == 667 || getLongerScreenLength == 812) {
        
        return   tval -  ((tval/100)*perc) +  (((tval/100)*perc) * 1.171875) ;
    }
    
    else if(getLongerScreenLength == 736 || getLongerScreenLength == 896) {
        
        return   tval -  ((tval/100)*perc) +  (((tval/100)*perc) * 1.29375) ;
    }
    
    else if(getLongerScreenLength == 1024) {
        
        return   tval -  ((tval/100)*perc) +  (((tval/100)*perc) * 2.4) ;
        
    }else {
        
        return tval;
    }
    
    
}


//가변높이영역 100%기준
+ (float)DPRateOriginVAL:(float)tval{
    
    
    
    if(getLongerScreenLength == 480) {
        return tval;
    }
    else if(getLongerScreenLength == 568) {
        
        return tval;
        
    } else if(getLongerScreenLength == 667 || getLongerScreenLength == 812) {
        
        return tval * 1.171875;
    }
    
    else if(getLongerScreenLength == 736 || getLongerScreenLength == 896) {
        
        return tval * 1.29375;
    }
    
    else if(getLongerScreenLength == 1024) {
        
        return tval * 2.4;
    }else {
        
        return tval;
    }
    
    
}




/*
 자료형변환 관련
 
 
 1. 한글NSString -> NSData 변환
 
 NSString* str = @"안녕hi";
 NSLog("%d", [str length] ); //4
 
 NSData* data = [str dataUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
 NSLog("%d", [data length] ); //6
 
 
 2.NSData -> 한글NSString 변환
 
 char* pszMsg = new char[ [data length]+1 ];
 memset(pszMsg,0,[data length]+1);
 
 [data getBytes:pszMsg length:[data length] ];
 NSString* str2 = [NSString stringWithCString:(char*)pszMsg
 encoding:0x80000000 + kCFStringEncodingDOSKorean];
 NSLog(@"%@",str2); // 정상
 
 
 3.NSNumber -> NSString
 NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
 NSNumber * num = [numberFormatter numberFromString:yourString];
 [numberFormatter release];
 
 
 
 4.  NSString -> char*
 char* psz = [nsstring객체 UTF8String];
 
 
 
 5. char* -> NSString
 NSString* str = [NSString stringWithFormat:@"%s", 문자열];
 //NSString *str = [[NSString alloc]initWithFormat:@"%s", 문자열];
 
 6. int -> NSString
 NSString *str = [NSString stringWithFormat:@"%d", 숫자];
 
 
 
 */




// 금액으로표시 price(3,000,000)

+ (NSString *) numberFormat:(NSString*)price {
    NSNumber *result = nil;
    NSString* ret = nil;
    
    @try {
        result = [NSNumber numberWithLongLong: [price longLongValue]];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setDecimalSeparator:@","];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        ret = [numberFormatter stringFromNumber:result];
        
    }
    @catch (NSException * e) {
        ret = @"0";
    }
    @finally {
        
    }
    
    return ret;
}


// substring
+ (NSString *) substr:(NSString*)str index:(NSInteger)idx {
    NSString *ret = nil;
    
    if (idx<0) {
        //처음부터 idx까지 반환
        ret = [str substringFromIndex:[str length]+idx];
    }
    else {
        //0~idx까지 문자열 반환
        ret = [str substringToIndex:idx];
    }
    
    return ret;
}

// substring
+ (NSString *) substr:(NSString*)str startIndex:(NSUInteger)sidx endIndex:(NSUInteger)eidx {
    NSRange strRange = {sidx,eidx};
    NSString *ret = [str substringWithRange:strRange];
    
    return ret;
}

// trim
+ (NSString *) trim:(NSString*)str {
    NSString *ret = [str stringByTrimmingCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    [ret stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return ret;
}

// explode
+ (NSArray *) explode:(NSString*)delimiter string:(NSString*)str {
    NSArray *ret = [str componentsSeparatedByString:delimiter];
    
    return ret;
}
// stringByStrippingHTML
+(NSString*)stringByStrippingHTML:(NSString*)stringHtml
{
    NSRange r;
    while ((r = [stringHtml rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        stringHtml = [stringHtml stringByReplacingCharactersInRange:r withString:@""];
    return stringHtml;
}
// strReplace
+ (NSString *) strReplace:(NSString *)search replace:(NSString *)replace string:(NSString*)str {
    NSString *ret = [str stringByReplacingOccurrencesOfString:search withString:replace];
    
    return ret;
}


+ (BOOL)strContain:(NSString*)tgstring srcstring:(NSString *)srstr
{
    NSLog(@"---------");
    NSString *str = srstr;
    NSRange range = [str rangeOfString:tgstring];
    if(range.location == NSNotFound) //없음
    {
        
        return NO;
    }
    else{
        
        return YES;
    }
    
}


// 2010.03.10 포맷으로
+ (NSString*) dateViewFormat:(NSString*)dateStr divStr:(NSString*)divStr {
    NSString* ret = @"";
    if (dateStr.length>0) {
        ret = [[NSString alloc] initWithFormat:@"%@%@%@%@%@"
               , [Mocha_Util substr:dateStr startIndex:0 endIndex:4], divStr
               , [Mocha_Util substr:dateStr startIndex:4 endIndex:2], divStr
               , [Mocha_Util substr:dateStr startIndex:6 endIndex:2]];
    }else {
        ret = @"";
    }
    
    return ret;
}


// int to string convert
+ (NSString*) intToString:(NSInteger)intValue{
    NSString* ret = [NSString stringWithFormat:@"%d", (int)intValue];
    return ret;
}



//UTF-8 에 완성형 뷁과 같은 문자를 ?문자 처리
+(NSString *)eucKRtoqchar:(NSString *)strToCheck{
    
    NSStringEncoding EUCKR = -2147481280;
    NSMutableString *strEuckrCheck = [[NSMutableString alloc] initWithString:@""];
    
    for (int i = 0; i<[strToCheck length]; i++) {
        NSData *dataEuckr = [[strToCheck substringWithRange:NSMakeRange(i, 1)] dataUsingEncoding:EUCKR];
        
        if (dataEuckr == nil) {
            [strEuckrCheck appendString:@"?"];
        }else{
            [strEuckrCheck appendString:[strToCheck substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    
    return strEuckrCheck;
}

/*

//push alert 설정이 가능상태인지 return
+(BOOL)ispushalertoptionenable {
    
    //iOS8 이상
    if(([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)){
        
        
        if([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
            return  YES;
        }else {
            return NO;
        }
        //상세
        // UIUserNotificationSettings notificationTypes= [[UIApplication sharedApplication] currentUserNotificationSettings];
    }
    
    else {
        
        //푸시 수신
        BOOL enable = YES;
        
        UIRemoteNotificationType notificationTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        if (notificationTypes == UIRemoteNotificationTypeNone) {
            //완전차단 notificationTypes = 0
            NSLog(@"[1번] %lu",(unsigned long)notificationTypes);
            enable = NO;
            // Do what ever you need to here when notifications are disabled
        } else if (notificationTypes == UIRemoteNotificationTypeBadge) {
            //뱃지만표현 notificationTypes =1
            NSLog(@"[2번] %lu", (unsigned long)notificationTypes);
            enable = NO;
            // Badge only
        } else if (notificationTypes == UIRemoteNotificationTypeAlert) {
            //알럿만 표현 notificationTypes =4 이경우 앱꺼져있을경우 알럿 표현되지 않음 설정상태 = 모두꺼짐,알림상태꺼짐, 알림스타일만 없음이아닌 배너또는 알림 온 설정시 4가됨
            NSLog(@"[3번] %lu",(unsigned long)notificationTypes);                // 이값만 걸리면 푸시를 받을 수 있습니다.
            // Alert only
        } else if (notificationTypes == UIRemoteNotificationTypeSound) {
            //사운드만 표현 notificationTypes =2 알러창 없이 사운드재생만됨. 기기사운드설정과 관련없음, 앱이켜있는경우 알럿창 표출가능
            NSLog(@"[4번] %lu",(unsigned long)notificationTypes);
            enable = NO;
            // Sound only
        }else if (notificationTypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)) {
            NSLog(@"[5번] %lu",(unsigned long)notificationTypes);
            // Badge & Alert
        } else if (notificationTypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)) {
            NSLog(@"[6번] %lu",(unsigned long)notificationTypes);
            enable = NO;
            // Badge & Sound
        } else if (notificationTypes == (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)) {
            NSLog(@"[7번] %lu",(unsigned long)notificationTypes);
            // Alert & Sound
        } else if (notificationTypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)) {
            NSLog(@"[8번] %lu",(unsigned long)notificationTypes);
            // Badge, Alert & Sound
        }
        
        return enable;
    }
    
    
}
*/

//iOS9 대응 변경 v.4.6.3
+ (BOOL)ispushalertoptionenable {
    
    /*
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
        UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
        return (types & UIUserNotificationTypeAlert);
    }
    else {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        return (types & UIRemoteNotificationTypeAlert);
    }
    */
    //두번째 대응 쿠팡style
    NSString *iOSversion = [[UIDevice currentDevice] systemVersion];
    NSString *prefix = [[iOSversion componentsSeparatedByString:@"."] firstObject];
    float versionVal = [prefix floatValue];
    
    
    if (versionVal >= 8)
    {
        //NSLog(@"%@", [[UIApplication sharedApplication]  currentUserNotificationSettings]);
        //The output of this log shows that the app is registered for PUSH so should receive them
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
            
            return YES;
            
        }
        
    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (types != UIRemoteNotificationTypeNone){
            return YES;
        }
        
    }
    
    
    return NO;
}

// iphone 여부
+ (BOOL) isIPhone {
    NSString* model = [[UIDevice currentDevice] model];
    
    NSRange range = [model rangeOfString:@"iPhone"];
    
    if (range.length>0) {
        return YES;
    }
    else {
        return NO;
    }
}

// 문자/전화/지도관련 어플 실행
+ (void) systemAppRun:(NSString*)protocol param:(NSString*)param {
    NSString* paramStr = [NSString stringWithFormat:@"%@:%@", protocol, param];
    NSString* url = [[NSString stringWithString:paramStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

// 공백값인가
+ (BOOL) isEmpty:(NSString*)str {
    if ([@"" isEqualToString:str]) {
        return YES;
    }
    else {
        return NO;
    }
}


// hex Color값 -> UIColor리턴
+ (UIColor *) getColor: (NSString *) hexColor
{
    // 2017.07.23
    if([hexColor length] != 6)
        return [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    red = red & 0xFF;
    green = green & 0xFF;
    blue = blue & 0xFF;
    
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

+ (NSString *)getCurrentDate:(BOOL)ishour {
    //formatter 릭예약
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    if(ishour){
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSString *dateString = [formatter stringFromDate:today];
    return dateString;
    
    
}

+ (NSString *) getDate:(NSString *)date hour:(BOOL)ishour{
    // NSLog(@"날짜계산 시작");
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    if(ishour){
        [dateformat setDateFormat:@"yyyy-MM-dd aa h:mm"];
    }
    else
        [dateformat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    NSString *result = [dateformat stringFromDate:newDate];
    return result;
    
}

+ (NSString *) getDateforInfo:(NSString *)date{
    // NSLog(@"날짜계산 시작");
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yy/MM/dd"];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    NSString *result = [dateformat stringFromDate:newDate];
    return result;
    
}

+ (NSString *) getDateLeft:(NSString *)date{
    //NSLog(@"날짜계산 시작2");
    double left = [date doubleValue] - [[NSDate date] timeIntervalSince1970];
    int hour = left/3600;
    int minite = (left-(hour*3600))/60;
    int second = (left-(hour*3600)-(minite*60));
    
    NSString *callTemp = [NSString stringWithFormat:@"%03d:%02d:%02d", hour, minite, second];
    
    return callTemp;
}

+ (BOOL) isEndDate:(NSString *)date{
    double left = [date doubleValue] - [[NSDate date] timeIntervalSince1970];
    if(left >= 0){
        return NO;
    }
    else{
        return YES;
    }
    
}


+ (NSMutableString *) getXmlParameter:(NSMutableDictionary *)parameter{
    NSMutableString *bodyString = [NSMutableString stringWithCapacity:1024];
    
    int bodyParamCount = (int)[parameter count];
    if(bodyParamCount > 0) {
        NSArray *keys = [parameter allKeys];
        NSArray *values = [parameter allValues];
        for(int i=0; i<bodyParamCount; i++) {
            //for(int i=bodyParamCount-1; i>0; i--) {
            //NSString *encodingValue = [[values objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:_HM_EUCKREncoding];
            NSString *encodingValue = [values objectAtIndex:i];
            if(encodingValue != nil) {
                //if(i != 0)
                [bodyString appendString:@"&"];
                [bodyString appendString:[keys objectAtIndex:i]];
                [bodyString appendString:@"="];
                [bodyString appendString:encodingValue];
            }
        }
    }
    return bodyString;
}

+ (NSMutableString*) getCardNoParser:(NSString*)cardno{
    NSMutableString *newNumber = [[NSMutableString alloc] init];
    NSInteger numberLength = [cardno length];
    if(numberLength <= 4)
        [newNumber appendString:[cardno substringWithRange:NSMakeRange(0, numberLength)]];
    else if(numberLength <= 8){
        NSMutableString *star = [[NSMutableString alloc] init];
        for(int i = 1;i <= numberLength - 4;i++)
            [star appendString:@"*"];
        [newNumber appendFormat:@"%@ - %@",
         [cardno substringWithRange:NSMakeRange(0, 4)],
         star];
    }
    else if(numberLength <= 12){
        NSMutableString *star = [[NSMutableString alloc] init];
        for(int i = 1;i <= numberLength - 8;i++)
            [star appendString:@"*"];
        [newNumber appendFormat:@"%@ - %@ - %@",
         [cardno substringWithRange:NSMakeRange(0, 4)],
         @"****",
         star];
    }
    else
        [newNumber appendFormat:@"%@ - %@ - %@ - %@",
         [cardno substringWithRange:NSMakeRange(0, 4)],
         @"****",
         @"****",
         [cardno substringWithRange:NSMakeRange(12, numberLength - 12)]];
    return newNumber;
}

+ (NSDate *) date:(NSDate *)fromDate byAddingMonth:(int)monthOffset {
    NSDateComponents *month = [[NSDateComponents alloc] init];
    
    [month setMonth:monthOffset];
    
    NSDate *monthStartDateWithOffset = [[NSCalendar currentCalendar] dateByAddingComponents:month
                                                                                     toDate:fromDate
                                                                                    options:0];
    
    return monthStartDateWithOffset;
}

+ (NSDate *) date:(NSDate *)fromDate byAddingDay:(int)dayOffset {
    NSDateComponents *day = [[NSDateComponents alloc] init];
    
    [day setDay:dayOffset];
    
    NSDate *dayStartDateWithOffset = [[NSCalendar currentCalendar] dateByAddingComponents:day
                                                                                   toDate:fromDate
                                                                                  options:0];
    
    return dayStartDateWithOffset;
}

+ (NSDate *) date:(NSDate *)fromDate byAddingYear:(int)yearOffset {
    NSDateComponents *year = [[NSDateComponents alloc] init];
    
    [year setYear:yearOffset];
    
    NSDate *yearStartDateWithOffset = [[NSCalendar currentCalendar] dateByAddingComponents:year
                                                                                    toDate:fromDate
                                                                                   options:0];
    
    return yearStartDateWithOffset;
}




+(BOOL) isthisCydia {
    NSString *filePath = @"/Applications/Cydia.app";
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        // 탈옥했음!
        NSLog(@"Cydia Existed. JailBroken #2");
        return YES;
    }else{
        NSLog(@"Normal");
        return NO;
    }
    
}



+ (BOOL)isMultitaskingOS
{
    BOOL bgSupport = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
        bgSupport=[UIDevice currentDevice].multitaskingSupported;
    
    return bgSupport;
}

+ (BOOL)isForeground
{
    if (![self isMultitaskingOS])
        return YES;
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    //return (state == UIApplicationStateActive || state == UIApplicationStateInactive);
    return (state == UIApplicationStateActive);
}







+ (UIImage*)glossImageForImage:(UIImage*)image {
    static UIImage *overlayImage = nil;
    static UIImage *overlayMask = nil;
    if (nil == overlayImage) {
        overlayImage = [UIImage imageNamed:@"IconOverlay"];
        overlayMask = [UIImage imageNamed:@"IconMask"];
    }
    
    // Create a new CGImage from the new object, and merge our overlay image onto it
    UIGraphicsBeginImageContextWithOptions(overlayImage.size,
                                           NO,
                                           [[UIScreen mainScreen] scale]);
    
    // Draw our new image and the icon overlay to the context
    [image drawAtPoint:CGPointZero];
    
    
    [overlayImage drawAtPoint:CGPointZero];
    [overlayMask drawAtPoint:CGPointZero];
    
    
    // Retrieve the merged image, and destroy our drawing context
    UIImage *mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Return the resulting image
    return mergedImage;
}
+ (NSString*)getSnsKey:(NSString*)keyname {
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"SNSKeyPack"] objectForKey:keyname];
}



/*쿠키 관련
 - (void) dumpCookies:(NSString *)msgOrNil {
 NSMutableString *cookieDescs    = [[[NSMutableString alloc] init] autorelease];
 NSHTTPCookie *cookie;
 NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
 for (cookie in [cookieJar cookies]) {
 [cookieDescs appendString:[self cookieDescription:cookie]];
 }
 NSLog(@"------ [Cookie Dump: %@] ---------\n%@", msgOrNil, cookieDescs);
 NSLog(@"----------------------------------");
 }
 
 - (NSString *) cookieDescription:(NSHTTPCookie *)cookie {
 
 NSMutableString *cDesc      = [[[NSMutableString alloc] init] autorelease];
 [cDesc appendString:@"[NSHTTPCookie]\n"];
 [cDesc appendFormat:@"  name            = %@\n",            [[cookie name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
 [cDesc appendFormat:@"  value           = %@\n",            [[cookie value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
 [cDesc appendFormat:@"  domain          = %@\n",            [cookie domain]];
 [cDesc appendFormat:@"  path            = %@\n",            [cookie path]];
 [cDesc appendFormat:@"  expiresDate     = %@\n",            [cookie expiresDate]];
 [cDesc appendFormat:@"  sessionOnly     = %d\n",            [cookie isSessionOnly]];
 [cDesc appendFormat:@"  secure          = %d\n",            [cookie isSecure]];
 [cDesc appendFormat:@"  comment         = %@\n",            [cookie comment]];
 [cDesc appendFormat:@"  commentURL      = %@\n",            [cookie commentURL]];
 [cDesc appendFormat:@"  version         = %@\n",            [cookie version]];
 
 //  [cDesc appendFormat:@"  portList        = %@\n",            [cookie portList]];
 //  [cDesc appendFormat:@"  properties      = %@\n",            [cookie properties]];
 
 return cDesc;
 }
 */
@end
