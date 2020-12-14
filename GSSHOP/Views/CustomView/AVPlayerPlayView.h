//
//  AVPlayerPlayView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 4. 18..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/* PlayerItem keys */
#define kStatusKey         @"status"
#define kCurrentItemKey    @"currentItem"

@class AVPlayer;

@interface AVPlayerPlayView : UIView

@property (nonatomic, strong) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;

@end
