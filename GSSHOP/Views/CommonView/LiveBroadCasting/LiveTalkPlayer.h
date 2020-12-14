//
//  LiveTalkPlayer.h
//  GSSHOP
//
//  Created by gsshop on 2016. 1. 14..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "FXImageView.h"

@import BrightcovePlayerSDK;

@class LiveTalkPlayer;


typedef enum {
    TALKLIVEBRDTYPE          = 1,
    TALKVODBRDTYPE           = 2,
    TALKAUTOBRDTYPE           = 3
} TALKBRDTYPE;

typedef enum {
    TOPBTNSNSTYPE          = 1,
    TOPBTNSEARCHTYPE           = 2,
    TOPBTNCARTTYPE           = 3
} TOPBTNTYPE;


@protocol talkPlayerViewDelegate <NSObject>
@optional
-(void)playerViewZoomButtonClicked:(LiveTalkPlayer*)view;
-(void)playerFinishedPlayback:(LiveTalkPlayer*)view;
-(void)playerPortraitBack:(LiveTalkPlayer*)view;
-(void)playerTopHudButtonPressed:(TOPBTNTYPE)type;
-(void)notAgree3G;
@end

@interface LiveTalkPlayer : UIView <UIGestureRecognizerDelegate,Mocha_AlertDelegate>{
    
    BOOL isAgree3G;
}

@property (assign, nonatomic) TALKBRDTYPE brdtype;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (assign, nonatomic) id <talkPlayerViewDelegate> delegate;

@property (strong, nonatomic) NSURL *contentURL;
@property (strong, nonatomic) AVPlayer *moviePlayer;
@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) BOOL isStartedPlay;


//@property (nonatomic, strong) IBOutlet UIView *volumeController;
//@property (nonatomic, strong) IBOutlet UIView *brightnessController;


@property (retain, nonatomic) IBOutlet UIButton *playPauseButton;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *lcontPlayBtnCenterY;
@property (retain,nonatomic) IBOutlet UILabel *ModeVodPBTimelabel;

@property (retain, nonatomic) IBOutlet UIButton *zoomButton;
@property (retain, nonatomic) IBOutlet UIButton *muteButton;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint *lcontCloseBtnTrailing;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *lcontZoomBtnTrailing;

@property (retain,nonatomic) IBOutlet UIView *viewTap;
@property (retain,nonatomic) IBOutlet UIView *viewDimm;
@property (retain,nonatomic) IBOutlet UIView *playerHudBottom;
@property (retain,nonatomic) IBOutlet UIView *playerHudTop;
@property (retain,nonatomic) IBOutlet UILabel *top_title_label;
@property (retain,nonatomic) IBOutlet UIButton *top_BackBtn;

@property (retain,nonatomic) IBOutlet UIView *LivePlayerView;


@property (retain,nonatomic) IBOutlet FXImageView *thumbnail_image;

@property (nonatomic, retain) IBOutlet UIButton *btnCart;
@property (nonatomic, retain) IBOutlet UIButton *btnSearch;
@property (nonatomic, retain) IBOutlet UIButton *btnSNS;

@property (nonatomic, retain) IBOutlet UIView *viewEndBroadCast;

- (void)setupWithNframe:(CGRect)tframe contentURL:(NSURL*)url withTitle:(NSString*)title withthumImg:(NSString*)thumbimg;
-(void)play;
-(void)pause;
- (void) HudTryHidden;
-(void)zoomToSmallPlayer;

-(void)isShowTopButtons:(BOOL)isShow;

-(IBAction)zoomButtonPressed:(UIButton*)sender;
-(IBAction)playButtonAction:(UIButton*)sender;
-(IBAction)closeButtonAction:(UIButton*)sender;
-(IBAction)muteButtonAction:(UIButton*)sender;

-(IBAction)onBtnTopHudTouch:(id)sender;
-(IBAction)onBtnTopHud:(id)sender;

-(void)checkCartStatus;

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index;
-(void)endBroadCast;
- (void) DrawCartCountstr;
@end
