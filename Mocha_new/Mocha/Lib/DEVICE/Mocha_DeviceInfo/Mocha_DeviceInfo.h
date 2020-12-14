//
//  Mocha_DeviceInfo.h
//  Mocha
//
//  Created by Hoecheon Kim on 12. 6. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//
 
#import "UIDevice-Hardware.h"


/**
 * @brief iOS 앱이 실행중인 디바이스 환경정보제공 Class
 * 기기종류, 기기고유값, 맥주소, 전화번호, 현재언어설정, OS버전, OS종류 등 정보 조회.
 */
@interface Mocha_DeviceInfo : NSObject 



/**
 *  Device 플랫폼 정보 반환 ex)x86_64...
 *
 *   @return NSString
 *
 */
+ (NSString *)getPlatform;

/**
 *  Device 지역정보 반환
 *
 *   @return NSString
 *
 */

+ (NSString *)getLocationinfo;

/**
 *  Device Locale 정보 반환
 *
 *   @return NSString
 *
 */
+ (NSString *)getLocaleinfo;

/**
 *  Device 운영체제 iOS 버전반환
 *
 *   @return float
 *
 */
+ (float) getiosversion;



/**
 *  Device 플랫폼 str 반환 
 *
 *   @return NSString
 *
 */
+ (NSString *) platform;

/**
 *  Device 하드웨어 모델 정보 반환
 *
 *   @return NSString
 *
 */
+ (NSString *) hwmodel;


/**
 *  Device 플랫폼 type str 반환
 *
 *   @return NSUInteger
 *
 */
+ (NSUInteger) platformType;

/**
 *  Device 플랫폼 str반환
 *
 *   @return NSString
 *
 */
+ (NSString *) platformString;

/**
 *  Device cpuFrequency반환
 *
 *   @return NSString
 *
 */
+ (NSUInteger) cpuFrequency;

/**
 *  Device busFrequency반환
 *
 *   @return NSString
 *
 */
+ (NSUInteger) busFrequency;

/**
 *  Device totalMemory 크기 반환
 *
 *   @return NSString
 *
 */
+ (NSUInteger) totalMemory;

/**
 *  Device 사용Memory 크기 반환
 *
 *   @return NSString
 *
 */
+ (NSUInteger) userMemory;

/**
 *  Device 전체 저장용량 반환
 *
 *   @return NSNumber
 *
 */
+ (NSNumber *) totalDiskSpace;

/**
 *  Device 가용 저장용량 반환
 *
 *   @return NSNumber
 *
 */
+ (NSNumber *) freeDiskSpace;

/**
 *  Device mac address반환
 *
 *   @return NSString
 *
 */
+ (NSString *) macaddress;





 
@end
