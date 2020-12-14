//
//  AVPlayerPlayView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 4. 18..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "AVPlayerPlayView.h"

@implementation AVPlayerPlayView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer*)player
{
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer*)player
{
    [(AVPlayerLayer*)[self layer] setPlayer:player];
}

- (void)setVideoFillMode:(NSString *)fillMode
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
    playerLayer.videoGravity = fillMode;
}

@end
