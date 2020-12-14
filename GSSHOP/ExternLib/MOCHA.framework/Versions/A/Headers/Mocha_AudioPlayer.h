//
//  Mocha_AudioPlayer.h
//  Mocha
//
//  Created by Hoecheon Kim on 12. 6. 25..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <AVFoundation/AVFoundation.h>
#else
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

#endif



/**
 * @brief 배경음 재생 관리 Class
 * AVAudioPlayer 객체 overiding하여 재생횟수 및 볼륨, 재생음원을 받아 음원 재생 수행
 */
@interface Mocha_AudioPlayer : AVAudioPlayer  {
    int _pcount;
    float _volnum;
    NSString* _mediastr;
    
}
@property(nonatomic) int pcount;
@property(nonatomic) float volnum;
@property(nonatomic, strong) NSString *mediastr;




/**
 *  @property에 정의된 볼륨,재생횟수,재생할음원경로를 받아 음원플레이어 객체 초기화.
 *
 *   @param ptime 지정된 int값만큼 재생횟수지정 (int)
 *   @param volval 지정된 float값만큼 볼륨세팅 (float)
 *   @param presource 재생할 음원파일의 경로및 음원파일명 (NSString)
 *   @return id
 *
 */

- (id)initWithOptions:(int)ptime  volumeval:(float)volval presource:(NSString*)presourecestr;
/**
 *  세팅된 self (AvAudioPlayer) 음원재생기능을 play
 *
 *   @return void
 *
 */
-(void)playMochaSound;
/**
 *  세팅된 self (AvAudioPlayer) 음원재생기능을 정지
 *
 *   @return void
 *
 */
-(void)stopMochaSound;
@end
