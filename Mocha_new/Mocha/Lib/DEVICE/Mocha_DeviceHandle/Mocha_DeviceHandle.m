//
//  Mocha_DeviceHandle.m
//  Mocha
//
//  Created by Hoecheon Kim on 12. 6. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "Mocha_DeviceHandle.h"

 

@implementation Mocha_DeviceHandle
 

+ (void)Devicevibe:(int)ptime {
    //폰만 이 기능을 이용할 수 있도록 예외처리 필요. 팟/pad에서 작동시 리젝사유
    
    NSLog(@"접근 완료입니다.");
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    //진동모드 알림은 IOS5 에서는 체크할 수 없음.apple 에서 API삭제.
    if(CFStringGetLength(state) == 0)
    {
        //SILENT
        NSLog(@"울립니다.");
        for(int i=1; i<ptime; i++) {
             
            [Mocha_DeviceHandle performSelector:@selector(VibePhone) withObject:nil afterDelay:i *.3f];
          
            //[NSThread sleepForTimeInterval:2];
             
        }
        
    }
    else
    {
        //NOT SILENT
        NSLog(@"무음모드 아닙니다.");
        NSLog(@"울립니다.");
        for(int i=0; i<ptime; i++) {
           
            [Mocha_DeviceHandle performSelector:@selector(VibePhone) withObject:nil afterDelay:i *.3f];
            
            
        }
        
    }
    
}
+(void)VibePhone {
     
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
 

@end
