//
//  Mocha_AudioPlayer.m
//  Mocha
//
//  Created by Hoecheon Kim on 12. 6. 25..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "Mocha_AudioPlayer.h"

@implementation Mocha_AudioPlayer


@synthesize mediastr, pcount, volnum;


 
 

- (id)initWithOptions:(int)ptime  volumeval:(float)volval presource:(NSString*)presourecestr
{
    
    self.pcount = ptime;
    self.volnum = volval;
    self.mediastr = presourecestr;
 
    NSArray* dds = [presourecestr componentsSeparatedByString:@"."];
    NSLog(@"파일: %@ , 확장자: %@", [dds objectAtIndex:0],[dds objectAtIndex:1]);
    
    self = [self initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[dds objectAtIndex:0] ofType:[dds objectAtIndex:1] ]] error:NULL];
    
    [self setNumberOfLoops:ptime];
    self.volume =volval;
    
	if (!self)
		return nil;
    
         
	return self;
}
  



  
-(void)playMochaSound {
    //기존음원 재생유지 
    //UInt32 category = kAudioSessionCategory_AmbientSound;
    //AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    
    [self play]; 
}
-(void)stopMochaSound {
    [self stop];
    
}

// TODO Fadein Fadeout Effect 

@end
