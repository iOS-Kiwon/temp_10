//
//  Mocha_DeviceHandle.h
//  Mocha
//
//  Created by Hoecheon Kim on 12. 6. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>
/**
 * @brief 디바이스 진동관리 Class
 * 디바이스의 음원재생가능상태 및 진동상태와 상관없이 진동기능관련하여 진동 횟수 조절기능 제공
 */
@interface Mocha_DeviceHandle : NSObject {
     
} 

 

/**
 *  핸드폰의 진동기능을 지정된 횟수만큼 재생 (void), 진동1회=1초가량.
 *
 *   @param ptime 지정된 int값만큼 진동기능 작동 (int)
 *   @return void
 *
 */

+ (void)Devicevibe:(int)ptime ;


/**
 *  핸드폰의 기본 진동기능 1회 수행
 *
 *   @return void
 *
 */

+ (void)VibePhone;




@end
