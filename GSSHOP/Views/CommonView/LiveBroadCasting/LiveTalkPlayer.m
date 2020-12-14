//
//  LiveTalkPlayer.m
//  GSSHOP
//
//  Created by gsshop on 2016. 1. 14..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "LiveTalkPlayer.h"
#import "AppDelegate.h"

#define SENSUTIVITY_FACTOR 300

//cart badge tag
#define kCARTBADGECOUNTERVIEWTAG 333

@implementation LiveTalkPlayer {
    id playbackObserver;
    BOOL viewIsShowing;
    BOOL isFullScreenMode;
    BOOL VolumeTouch;
    BOOL BrigthTouch;
    float m_Volume_Position;
    float m_Bright_Position;
    UIPanGestureRecognizer *pan;
    UITapGestureRecognizer *tap;
    
    BOOL isWifiAutoPlay;
}

@synthesize LivePlayerView, playerHudTop, playerHudBottom, brdtype;
@synthesize btnCart;
@synthesize btnSearch;
@synthesize btnSNS;

- (void)awakeFromNib
{
    [super awakeFromNib];
 
    isFullScreenMode = NO;
    playerHudTop.hidden = NO;
    self.ModeVodPBTimelabel.hidden = YES;
//    self.volumeController.alpha = 0.0;
//    self.brightnessController.alpha = 0.0;
    self.isStartedPlay = NO;
    self.muteButton.selected = ([@"Y" isEqualToString:[DataManager sharedManager].strGlobalSoundForWebPrd])?true:false;
}

- (void)setupWithNframe:(CGRect)tframe contentURL:(NSURL*)url withTitle:(NSString*)title withthumImg:(NSString*)thumbimg {

    isFullScreenMode = NO;
    playerHudTop.hidden = NO;
    self.ModeVodPBTimelabel.hidden = YES;
//    self.volumeController.alpha = 0.0;
//    self.brightnessController.alpha = 0.0;
    
    
    if([Mocha_Util strContain:@".m3u8" srcstring:[url absoluteString]]  ) {
        
        self.brdtype = TALKLIVEBRDTYPE;
    }
    else {
        self.brdtype = TALKVODBRDTYPE;
    }
    
    self.contentURL = url;
    [self setFrame:tframe];
    
    
    if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
        [self setUpNalBangMovie];
        isWifiAutoPlay = YES;
    }
    
//    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"livetalk_btn_stop"] forState:UIControlStateSelected];
//    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"livetalk_btn_play"] forState:UIControlStateNormal];
    [self.playPauseButton setTintColor:[UIColor clearColor]];
    self.playPauseButton.layer.opacity = 1;
    NSLog(@"머언 %@",self.contentURL);
    [[playerHudTop viewWithTag:kCARTBADGECOUNTERVIEWTAG] removeFromSuperview ];
    [self performSelectorOnMainThread:@selector(DrawCartCountstr) withObject:nil waitUntilDone:NO];
    self.thumbnail_image.hidden = NO;
    if(self.thumbnail_image.image == nil && [NCS(thumbimg) length] > 5) {
        [self.thumbnail_image setImageWithContentsOfURL:[NSURL URLWithString:thumbimg  ]];
    }
    
}

- (void)setUpNalBangMovie{
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.contentURL];
    self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
    [self.moviePlayer seekToTime:kCMTimeZero];
    [self.LivePlayerView.layer addSublayer:self.playerLayer];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;

    if (isFullScreenMode == NO) {
        [self setFrame:CGRectMake(0, STATUSBAR_HEIGHT, APPFULLWIDTH, [Common_Util DPRateOriginVAL:180])];
    }
        
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    
    if ([@"Y" isEqualToString:[DataManager sharedManager].strGlobal3GAgree ] || isWifiAutoPlay == YES) {
        [self playButtonAction:nil];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.LivePlayerView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.playerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

-(void)setupPlayer {
    self.backgroundColor = [UIColor blackColor];
    viewIsShowing =  NO;
    [self.layer setMasksToBounds:YES];
    self.ModeVodPBTimelabel.hidden = YES;
    [self performSelector:@selector(HudTryHidden) withObject:nil afterDelay:2.0f inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
}


- (void) HudTryHidden {
    if (self.isPlaying) {
        [self showHud:YES];
    }
}


- (void) DrawCartCountstr {
    
    NSString* cartstr = [CooKieDBManager getCartCountstr];
    CustomBadge *topcartbadge = (CustomBadge *)[playerHudTop viewWithTag:kCARTBADGECOUNTERVIEWTAG];
    if (topcartbadge != nil) {
        [topcartbadge removeFromSuperview];
        topcartbadge = nil;
    }
    
    if( cartstr == nil || [cartstr isEqualToString:@"0"]) {
        
    }
    else {
        NSLog(@"cartstrcartstr = %@",cartstr);
        if( [cartstr intValue] > 99) {
            cartstr = @"99";
        }
        CustomBadge *topcartbadge = [CustomBadge customBadgeWithString: cartstr];
        topcartbadge.tag = kCARTBADGECOUNTERVIEWTAG;
        topcartbadge.alpha = 1.0f;
        topcartbadge.badgeLabel.font = [UIFont boldSystemFontOfSize:12];
        topcartbadge.translatesAutoresizingMaskIntoConstraints = NO;
        [playerHudTop addSubview:topcartbadge];
        
        [playerHudTop addConstraint:[NSLayoutConstraint constraintWithItem:topcartbadge
                                                         attribute:NSLayoutAttributeTrailingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:playerHudTop
                                                         attribute:NSLayoutAttributeTrailingMargin
                                                        multiplier:1
                                                          constant:-6
                                     ]];
        [playerHudTop addConstraint:[NSLayoutConstraint constraintWithItem:topcartbadge
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:playerHudTop
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:4
                                     ]];

        [playerHudTop addConstraint:[NSLayoutConstraint constraintWithItem:topcartbadge
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:topcartbadge.frame.size.width
                                     ]
         ];

        
        [playerHudTop addConstraint:[NSLayoutConstraint constraintWithItem:topcartbadge
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1
                                                                  constant:topcartbadge.frame.size.height
                                     ]
         ];
        
        [playerHudTop layoutIfNeeded];
    }
}


- (void)checkCartStatus {
    [self DrawCartCountstr];
}


- (void)zoomToSmallPlayer {
    self.closeButton.hidden = YES;
    self.zoomButton.selected = NO;
    self.lcontZoomBtnTrailing.constant = 0.0;
    self.lcontCloseBtnTrailing.constant = 0.0;
    //[self setFrame:CGRectMake(0, STATUSBAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [Common_Util DPRateOriginVAL:180]) ];
    
    [self setFrame:CGRectMake(0.0, STATUSBAR_HEIGHT, APPFULLWIDTH, (180.0/320.0) * APPFULLWIDTH) ];
    
    
    playerHudTop.hidden = YES;
    playerHudBottom.hidden = YES;
    isFullScreenMode = NO;
    [self.delegate playerViewZoomButtonClicked:self];
}

//Tophud 뒤로가기 버튼전용
- (IBAction)zoomTopButtonPressed:(id)sender {
    if (!isFullScreenMode) {
        [self.delegate playerPortraitBack:self];
        return;
    }
    
    self.zoomButton.selected = NO;
    [self setFrame:CGRectMake(0.0, STATUSBAR_HEIGHT, APPFULLWIDTH, (180.0/320.0) * APPFULLWIDTH) ];
    playerHudTop.hidden = YES;
    isFullScreenMode = NO;
    [self.delegate playerViewZoomButtonClicked:self];
}


-(IBAction)zoomButtonPressed:(UIButton*)sender {
    //세로
    if(sender.selected == YES) {
        self.lcontZoomBtnTrailing.constant = 0.0;
        self.lcontCloseBtnTrailing.constant = 0.0;
        self.closeButton.hidden = YES;
        sender.selected = !sender.selected;
        [self setFrame:CGRectMake(0.0, STATUSBAR_HEIGHT, APPFULLWIDTH, (180.0/320.0) * APPFULLWIDTH) ];
        playerHudTop.hidden = YES;
        isFullScreenMode = NO;
        
    }
    else {
        //가로
        if(IS_IPHONE_X_SERISE){
            self.lcontZoomBtnTrailing.constant = 89.0;
            self.lcontCloseBtnTrailing.constant = 89.0;
        }
        self.closeButton.hidden = NO;
        sender.selected = !sender.selected;
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
        }];
        playerHudTop.hidden = NO;
        isFullScreenMode = YES;
        
    }
    [self.delegate playerViewZoomButtonClicked:self];
}


-(IBAction)onBtnTopHudTouch:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HudTryHidden) object:nil];
}


- (IBAction)onBtnTopHud:(id)sender {
    TOPBTNTYPE type = 0;
    if (sender == btnCart) {
        type = TOPBTNCARTTYPE;
    }
    else if (sender == btnSearch) {
        type = TOPBTNSEARCHTYPE;
    }
    else if (sender == btnSNS) {
        //20160215 parksegun 공유버튼 누를때만 처리
        ////탭바제거
        [ApplicationDelegate wiseAPPLogRequest: WISELOGCOMMONURL(@"?mseq=409211")];
        type = TOPBTNSNSTYPE;
    }
    [self.delegate playerTopHudButtonPressed:type];
    [self performSelector:@selector(HudTryHidden) withObject:nil afterDelay:2.0f inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
}

-(void)playerFinishedPlaying:(NSNotification*) notification {
    
    if( brdtype == TALKVODBRDTYPE ) {
        self.ModeVodPBTimelabel.hidden = NO;
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             [self showHud:NO];
                         }
                         completion:^(BOOL finished){
                             self.thumbnail_image.hidden = NO;
                             [self.moviePlayer pause];
                             [self.moviePlayer seekToTime:kCMTimeZero];
//                             [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"livetalk_btn_replay"] forState:UIControlStateNormal];
                             
                             [self.playPauseButton setSelected:NO];
                             self.isPlaying = NO;
                             
                             if(isFullScreenMode == YES) {
                                 [self zoomToSmallPlayer];
                             }
                         }];
    }
}


-(void) showHud:(BOOL)show {
    __weak __typeof(self) weakself = self;
    
    //2017/11/06 심야라이브 종료시 상단헤도 노출되도록 변경 요청
    //VOD 종료상태 새로고침상태에서는 HUDBottom 노출하지 않음
    //if(self.ModeVodPBTimelabel.hidden == NO) {
    if(self.viewEndBroadCast.hidden == NO) {
        
        self.viewDimm.hidden = NO;
        
        CGRect frame = self.playerHudBottom.frame;
        frame.origin.y = self.bounds.size.height;
        
        CGRect frametop = self.playerHudTop.frame;
        frametop.origin.y = 0;
        
        weakself.playerHudBottom.frame = frame;
        
        weakself.playerHudBottom.hidden = YES;
        weakself.playerHudTop.frame = frametop;
        
        weakself.playPauseButton.layer.opacity = 1;
        viewIsShowing = show;
        playerHudTop.hidden = NO;
        
        return;
    }

    
    if(show) {
        playerHudTop.hidden = NO;
        playerHudBottom.hidden = NO;
        
        self.lcontPlayBtnCenterY.constant = - 10.0;
        [self layoutIfNeeded];
        
        self.ModeVodPBTimelabel.hidden = YES;

        CGRect frame = self.playerHudBottom.frame;
        frame.origin.y = self.bounds.size.height;
        
        CGRect frametop = self.playerHudTop.frame;
        frametop.origin.y = 0-self.playerHudTop.frame.size.height;;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.playerHudBottom.frame = frame;
            
            weakself.playerHudTop.frame = frametop;
            
            weakself.playPauseButton.layer.opacity = 0;
            viewIsShowing = show;
            self.viewDimm.hidden = YES;
            self.closeButton.hidden = YES;
        }];
    }
    else {
        
        if (self.isStartedPlay) {
            self.ModeVodPBTimelabel.hidden = NO;
            self.ModeVodPBTimelabel.alpha = 0.0;
            
        }
        self.viewDimm.hidden = NO;
        playerHudBottom.hidden = NO;
        CGRect frame = self.playerHudBottom.frame;
        frame.origin.y = self.bounds.size.height-self.playerHudBottom.frame.size.height;
        
        CGRect frametop = self.playerHudTop.frame;
        frametop.origin.y = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.playerHudBottom.frame = frame;
            
            weakself.playerHudTop.frame = frametop;
            weakself.playPauseButton.layer.opacity = 1;
            self.ModeVodPBTimelabel.alpha = 1.0;
            viewIsShowing = show;

            if (isFullScreenMode) {
                self.closeButton.hidden = NO;
            }
        }];
        
        [self performSelector:@selector(HudTryHidden) withObject:nil afterDelay:2.0f inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
    }
}

-(NSString*)getStringFromCMTime:(CMTime)time {
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}

-(IBAction)muteButtonAction:(UIButton*)sender
{
    if (sender.isSelected) {
        [self.moviePlayer setMuted:YES];
        [DataManager sharedManager].strGlobalSoundForWebPrd = @"N";
        [sender setSelected:NO];
    } else {
        [self.moviePlayer setMuted:NO];
        [DataManager sharedManager].strGlobalSoundForWebPrd = @"Y";
        [sender setSelected:YES];
    }
}

-(IBAction)playButtonAction:(UIButton*)sender
{
    if (self.isPlaying) {
        
        [self pause];
        //버튼 pause상태 클릭시에도 hud 사라지게~ 한다면 풀자
        
        [sender setSelected:NO];
    } else {
        
        //20160215 parksegun 플레이버튼 누를때만 처리
        ////탭바제거
        [ApplicationDelegate wiseAPPLogRequest: WISELOGCOMMONURL(@"?mseq=408802")];
        
        if(  brdtype == TALKVODBRDTYPE  ) {
            self.ModeVodPBTimelabel.hidden = YES;
            [self showHud:NO];
        }
        
        [self play];
        [sender setSelected:YES];
    }
}

-(IBAction)closeButtonAction:(UIButton*)sender{
    if (isFullScreenMode) {
        [self zoomToSmallPlayer];
    }
    
}

-(void)play
{
    
    if ([@"Y" isEqualToString:[DataManager sharedManager].strGlobal3GAgree ] == NO) {
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWWAN) {
            
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 888;
            [ApplicationDelegate.window addSubview:malert];
            
            return;
        }

    }
    
    

    if(tap == nil){
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(Tap:)];
        [self.viewTap addGestureRecognizer:tap];
        tap.delegate = self;
    }

    
    if (self.brdtype == TALKLIVEBRDTYPE) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        if(self.moviePlayer != nil) {
            self.moviePlayer = nil;
        }
        if(self.playerLayer != nil) {
            [self.playerLayer removeFromSuperlayer];
            self.playerLayer = nil;
        }
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.contentURL];
        self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
        [self.moviePlayer seekToTime:kCMTimeZero];
        [self.LivePlayerView.layer addSublayer:self.playerLayer];
        [self.playerLayer setFrame:CGRectMake(0, 0, self.LivePlayerView.frame.size.width, self.LivePlayerView.frame.size.height)];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        
        self.moviePlayer.muted = ([@"Y" isEqualToString:[DataManager sharedManager].strGlobalSoundForWebPrd])?false:true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    }
    
    [self.moviePlayer play];
    
    self.isStartedPlay = YES;
    self.isPlaying = YES;
    
    [self.playPauseButton setSelected:YES];
    
    [self setupPlayer];
    
    self.thumbnail_image.hidden = YES;
    
}

-(void)pause
{
    [self.moviePlayer pause];
    self.isPlaying = NO;
    [self.playPauseButton setSelected:NO];
    
    
    [self showHud:NO];
}

-(void)endBroadCast{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         [self showHud:NO];
        
    }completion:^(BOOL finished){
        self.thumbnail_image.hidden = NO;
        [self.moviePlayer pause];
        [self.moviePlayer seekToTime:kCMTimeZero];

        self.playPauseButton.hidden = YES;

        self.isPlaying = NO;
        self.viewEndBroadCast.hidden = NO;
        self.viewDimm.hidden = NO;

        self.playerHudBottom.hidden = YES;
        self.ModeVodPBTimelabel.hidden = YES;

        if(isFullScreenMode == YES){
         [self zoomToSmallPlayer];
        }
        
    }];
}

-(void)dealloc
{
    
    [self.moviePlayer removeTimeObserver:playbackObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



//라이브톡에만 추가된 장바구니 공유하기 버튼들 가로모드일때 숨기기
-(void)isShowTopButtons:(BOOL)isShow{

    btnCart.hidden = !isShow;
    btnSearch.hidden = !isShow;
    btnSNS.hidden = !isShow;
    
    self.top_title_label.hidden = !isShow;
    self.top_BackBtn.hidden = !isShow;

    playerHudTop.hidden = !isShow;
    
    CustomBadge *topcartbadge = (CustomBadge *)[playerHudTop viewWithTag:kCARTBADGECOUNTERVIEWTAG];
    
    if (topcartbadge !=nil) {
        topcartbadge.hidden = !isShow;
    }
    

}

//탭 제스쳐 인식으로변경
- (void)Tap:(UITapGestureRecognizer *)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HudTryHidden) object:nil];
    [self showHud:!viewIsShowing];
}

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 888) {
        if (index == 1) {
            //isAgree3G = YES;
            
            [DataManager sharedManager].strGlobal3GAgree = @"Y";
            [self setUpNalBangMovie];
            isWifiAutoPlay = YES;
        }else{
            [self.playPauseButton setSelected:NO];
            
        }
        
    }
}

@end

