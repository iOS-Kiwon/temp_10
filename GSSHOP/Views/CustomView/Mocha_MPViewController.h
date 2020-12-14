//
//  Mocha_MPViewController.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 11. 22..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@import BrightcovePlayerSDK;

typedef enum  {
    PLAYSTREAM,
    PLAYDEALVOD,
    PLAYBASEVOD
} MochaPlayType;

@interface Mocha_MPViewController : UIViewController <BCOVPlaybackControllerDelegate,BCOVPlaybackSessionConsumer,UIGestureRecognizerDelegate>{

    MochaPlayType _mplayer_type;
    NSString *vodreqstr;
}

@property (nonatomic, strong) id target;
@property (nonatomic, strong) NSString *strGoProuctWiseLog;
@property (nonatomic, assign) BOOL isLandScapeOnly;
@property (nonatomic, assign) BOOL isMuteStart;

@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnMini;

@property (nonatomic, assign) NSTimeInterval timeStart;
@property (nonatomic, strong) NSString *strPrdImageURL;
@property (nonatomic, assign) BOOL isAutoStart;
@property (nonatomic, assign) UIImage *imgPoster;
@property (nonatomic, strong) NSString *strPosterUrl;

@property (nonatomic, assign) BOOL isFirstLiveLoad;

@property (nonatomic,strong) IBOutlet UIView *view3GAlert;
@property (nonatomic,strong) IBOutlet UIView *viewBtn3GAlertCancel;
@property (nonatomic,strong) IBOutlet UIView *viewBtn3GAlertConfirm;

@property (nonatomic,strong) NSString *strDealNo;
@property (nonatomic,strong) NSString *strVideoID;
@property (nonatomic,assign) BOOL isFinish;

- (id)initWithTargetid:(id)sender tgstr:(NSString*)urlstr;
- (void)viewWillEnterForeground;
- (void)playMovie:(NSURL *)movieFileURL;
- (void)playBrightCoveWithID:(NSString *)strVideoID;
- (void)catchNotiCloseEvent;


@end
