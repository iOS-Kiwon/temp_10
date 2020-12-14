//
//  ViewController.m
//  CustomControls
//
//  Copyright © 2017 Brightcove, Inc. All rights reserved.
//

#import "Mocha_MPViewController.h"
#import "AppDelegate.h"
#import "AVPlayerPlayView.h"

static void *AVPlayerCurrentItemObservationContext = &AVPlayerCurrentItemObservationContext;
static void *AVPlayerStatusObservationContext = &AVPlayerStatusObservationContext;

@interface Mocha_MPViewController () <BCOVPlaybackControllerDelegate , BCOVPUIPlayerViewDelegate>

@property (nonatomic, strong) UIButton *btnGoProduct;
@property (nonatomic, strong) IBOutlet UIView *viewGoProduct;
@property (nonatomic, strong) IBOutlet UIView *viewGoProductThumb;
@property (nonatomic, strong) IBOutlet UIImageView *imgProduct;
@property (nonatomic, strong) BCOVPlaybackService *BCPlaybackService;
@property (nonatomic, strong) id<BCOVPlaybackController> BCPlaybackController;
@property (nonatomic, strong) BCOVPUIPlayerView *BCPlayerView;
@property (nonatomic, weak) IBOutlet UIView *videoContainer;
@property (nonatomic, weak) IBOutlet UIView *viewForTap;

//@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerPlayView *playerView;
@property (nonatomic, strong) NSURL *URL;
@property (assign, nonatomic) BOOL isPlaying;

@property (nonatomic, weak) AVPlayer *currentPlayer;
@property (nonatomic, weak) IBOutlet UIButton *playPauseButton;
@property (nonatomic, weak) IBOutlet UILabel *playheadLabel;
@property (nonatomic, weak) IBOutlet UISlider *playheadSlider;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet UIButton *btnMute;

@property (nonatomic, assign, getter=wasPlayingOnSeek) BOOL playingOnSeek;
@property (nonatomic, assign) BOOL isShowHuds;
@property (nonatomic, assign) CGFloat widthDevice;
@property (nonatomic, assign) CGFloat heightDevice;
@property (nonatomic, strong) id playbackObserver;
@property (nonatomic, assign) BOOL isBrightCove;

@property (nonatomic, strong) IBOutlet UIImageView *imgViewPoster;
@property (nonatomic, strong) IBOutlet UIView *viewDimmed;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBtnXTopMargin;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBtnXTrailing;
//68x68 가로세로 25
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBtnOutBottomMargin;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBtnOutTrailing;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstSilderCenterY;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstLblDurationTrailing;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstLblPlayHeadLeading;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstViewGoProductX;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstViewGoProductY;

@end


@implementation Mocha_MPViewController

//@synthesize player = _player;
@synthesize playerItem = _playerItem;
@synthesize playerView = _playerView;
@synthesize URL = _URL;

- (id)initWithTargetid:(id)sender tgstr:(NSString*)urlstr
{
    self = [super init];
    if(self)
    {
        if(urlstr != nil){
            NSLog(@"url str: %@", urlstr);
            vodreqstr = urlstr;
            URLParser *parser = [[URLParser alloc] initWithURLString:urlstr];
            
            self.timeStart = 0.0;
            self.isFirstLiveLoad = YES;
            
            self.isAutoStart = YES;
            if([vodreqstr hasPrefix:@"toapp://vod?url="]){
                _mplayer_type = PLAYDEALVOD;
            }else if([vodreqstr hasPrefix:@"toapp://dealvod?url="]){
                _mplayer_type = PLAYDEALVOD;
            }else if([vodreqstr hasPrefix:@"toapp://basevod?url="]){
                _mplayer_type = PLAYBASEVOD;
            } else if([vodreqstr hasPrefix:@"toapp://liveBroadUrl?param="]){
                _mplayer_type = PLAYSTREAM;
            }else if([vodreqstr hasPrefix:@"toapp://livestreaming?"]){
                //공통
                if([Mocha_Util strContain:@".mp4" srcstring:[parser valueForVariable:@"url"]]){
                    //기타... type에 따른추가
                    _mplayer_type = PLAYDEALVOD;
                }
                else {
                    _mplayer_type = PLAYSTREAM;
                }
                
                
            }
            
            if ( ([NCS([parser valueForVariable:@"targeturl"]) length] > 0) && ([NCS([parser valueForVariable:@"targeturl"]) hasPrefix:@"http"] )) {
                self.viewGoProduct.hidden = NO;
            }else{
                self.viewGoProduct.hidden = YES;
            }
            
        }else {
            vodreqstr = nil;
        }
        self.target = sender;
        self.isShowHuds = YES;
        self.widthDevice = APPFULLWIDTH;
        self.heightDevice = APPFULLHEIGHT;
        self.isLandScapeOnly = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(catchNotiCloseEvent)
                                                     name:@"customovieViewRemove"
                                                   object:nil];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.viewBtn3GAlertCancel.layer.borderWidth = 1.0;
    self.viewBtn3GAlertCancel.layer.cornerRadius = 17.0;
    self.viewBtn3GAlertCancel.layer.shouldRasterize = YES;
    self.viewBtn3GAlertCancel.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewBtn3GAlertCancel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.viewBtn3GAlertConfirm.layer.cornerRadius = 17.0;
    self.viewBtn3GAlertConfirm.layer.shouldRasterize = YES;
    self.viewBtn3GAlertConfirm.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(18.0, 18.0), NO, 0.0f);
    [[UIImage imageNamed:@"new_rule_player_thumb_control.png"] drawInRect:CGRectMake(0.0, 0.0, 18.0, 18.0)];
    UIImage *imgProgress = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.playheadSlider setThumbImage:imgProgress forState:UIControlStateNormal];
    
    URLParser *parser = [[URLParser alloc] initWithURLString:vodreqstr];
    if ( ([NCS([parser valueForVariable:@"targeturl"]) length] > 0) && ([NCS([parser valueForVariable:@"targeturl"]) hasPrefix:@"http"] )) {
        self.viewGoProduct.hidden = NO;

        if ([NCS(self.strPrdImageURL) length] > 4){
            
            //http://image.gsshop.com/image/35/25/35256827_O1.jpg
            
            if ([[self.strPrdImageURL substringWithRange:NSMakeRange([self.strPrdImageURL length]-5, 1)] isEqualToString:@"."]) {
                self.strPrdImageURL = [self.strPrdImageURL stringByReplacingCharactersInRange:NSMakeRange([self.strPrdImageURL length]-7, 2) withString:@"V1"];
                NSLog(@"self.strPrdImageURL = %@",self.strPrdImageURL);
            }else if ([[self.strPrdImageURL substringWithRange:NSMakeRange([self.strPrdImageURL length]-4, 1)] isEqualToString:@"."]) {
                self.strPrdImageURL = [self.strPrdImageURL stringByReplacingCharactersInRange:NSMakeRange([self.strPrdImageURL length]-6, 2) withString:@"V1"];
                NSLog(@"self.strPrdImageURL = %@",self.strPrdImageURL);
            }
            
            [ImageDownManager blockImageDownWithURL:self.strPrdImageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                if (error == nil  && [self.strPrdImageURL isEqualToString:strInputURL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (isInCache) {
                            self.imgProduct.image = fetchedImage;
                        }
                        else {
                            self.imgProduct.alpha = 0;
                            self.imgProduct.image = fetchedImage;
                            
                            [UIView animateWithDuration:0.1f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.imgProduct.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        }//if else
                    });
                }//if
            }];
        }
        
    }else{
        self.viewGoProduct.hidden = YES;
    }

    
    
    if (self.isLandScapeOnly) {
        [self setLayoutConstrainLandscape];
    }else{
        [self setLayoutConstrainPortrait];
    }
    
    [self.viewDimmed layoutIfNeeded];
    [self.view layoutIfNeeded];
    
    self.viewGoProduct.layer.borderWidth = 1.0;
    self.viewGoProduct.layer.cornerRadius = 40.0;
    self.viewGoProduct.layer.shouldRasterize = YES;
    self.viewGoProduct.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewGoProduct.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.2f].CGColor;
    
    self.viewGoProductThumb.layer.borderWidth = 1.0;
    self.viewGoProductThumb.layer.cornerRadius = 25.0;
    self.viewGoProductThumb.layer.shouldRasterize = YES;
    self.viewGoProductThumb.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewGoProductThumb.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.3f].CGColor;
    
    
//    if ([NCS([parser valueForVariable:@"videoid"]) length] > 5) {
//        if (self.imgPoster != nil) {
//            self.imgViewPoster.image = self.imgPoster;
//        }else{
//            [self drawBCPosterVideoId:NCS([parser valueForVariable:@"videoid"])];
//        }
//
//        if (self.timeStart != 0.0) {
//            self.imgViewPoster.hidden = YES;
//        }
//
//    }else{
//        self.imgViewPoster.hidden = YES;
//    }

    
    if ([[[DataManager sharedManager] strGlobalSound] isEqualToString:@"D"]) {
        if([NetworkManager.shared currentReachabilityStatus] != NetworkReachabilityStatusViaWiFi) {
            self.btnMute.selected = NO;
        }else{
            if ([DataManager sharedManager].brigCoveAutoPlayYn == YES) {
                self.btnMute.selected = YES;
            }else{
                self.btnMute.selected = NO;
            }
        }
    }else if ([[[DataManager sharedManager] strGlobalSound] isEqualToString:@"Y"]) {
        self.btnMute.selected = NO;
    }else if ([[[DataManager sharedManager] strGlobalSound] isEqualToString:@"N"]) {
        self.btnMute.selected = YES;
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [ApplicationDelegate GTMscreenOpenSendLog:@"iOS - VideoPlayer"];
    
    
}

- (void)viewWillEnterForeground{
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    

    if (self.isLandScapeOnly == YES) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else{
        return UIInterfaceOrientationMaskAll;
        //return UIInterfaceOrientationMaskPortrait;
    }

}


-(void)setLayoutConstrainLandscape{
    if(IS_IPHONE_X_SERISE){
        
        self.lconstLblPlayHeadLeading.constant = 40.0;
        self.lconstBtnXTopMargin.constant = 15.0;
        self.lconstBtnXTrailing.constant = 15.0;
        self.lconstBtnOutBottomMargin.constant = 15.0;
        self.lconstSilderCenterY.constant = 0.0;
        self.lconstBtnOutTrailing.constant = 15.0;
        
        
        if (self.lconstLblDurationTrailing != nil) {
            [self.viewDimmed removeConstraint:self.lconstLblDurationTrailing];
            
            self.lconstLblDurationTrailing = [NSLayoutConstraint constraintWithItem:self.durationLabel
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.btnMute
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1
                                                                           constant:-15];
            [self.viewDimmed addConstraint:self.lconstLblDurationTrailing];
            
        }
        
        if (self.lconstViewGoProductX != nil) {
            [self.viewDimmed removeConstraint:self.lconstViewGoProductX];
            
            self.lconstViewGoProductX = [NSLayoutConstraint constraintWithItem:self.viewGoProduct
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.viewDimmed
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1
                                                                      constant:-40.0];
            [self.viewDimmed addConstraint:self.lconstViewGoProductX];
            
        }
        
    }else{
        self.lconstLblPlayHeadLeading.constant = 25.0;
        self.lconstBtnXTopMargin.constant = 0.0;
        self.lconstBtnXTrailing.constant = 0.0;
        self.lconstBtnOutBottomMargin.constant = 0.0;
        self.lconstSilderCenterY.constant = 0.0;
        self.lconstBtnOutTrailing.constant = 0.0;
        
        if (self.lconstLblDurationTrailing != nil) {
            [self.viewDimmed removeConstraint:self.lconstLblDurationTrailing];
            
            self.lconstLblDurationTrailing = [NSLayoutConstraint constraintWithItem:self.durationLabel
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.btnMute
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1
                                                                           constant:-15];
            [self.viewDimmed addConstraint:self.lconstLblDurationTrailing];
            
        }
        
        if (self.lconstViewGoProductX != nil) {
            [self.viewDimmed removeConstraint:self.lconstViewGoProductX];
            
            self.lconstViewGoProductX = [NSLayoutConstraint constraintWithItem:self.viewGoProduct
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.viewDimmed
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1
                                                                      constant:-25.0];
            [self.viewDimmed addConstraint:self.lconstViewGoProductX];
            
        }
    }
    
    
    
    if (self.lconstViewGoProductY != nil) {
        [self.viewDimmed removeConstraint:self.lconstViewGoProductY];
        
        self.lconstViewGoProductY = [NSLayoutConstraint constraintWithItem:self.viewGoProduct
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.viewDimmed
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0];
        [self.viewDimmed addConstraint:self.lconstViewGoProductY];
        
    }
}

-(void)setLayoutConstrainPortrait{
    if(IS_IPHONE_X_SERISE){
        self.lconstLblPlayHeadLeading.constant = 25.0;
        self.lconstBtnXTopMargin.constant = 35.0;
        self.lconstBtnXTrailing.constant = 0.0;
        self.lconstBtnOutBottomMargin.constant = 35.0;
        self.lconstSilderCenterY.constant = -34.0;
        self.lconstBtnOutTrailing.constant = 0.0;
        
        if (self.lconstLblDurationTrailing != nil) {
            [self.viewDimmed removeConstraint:self.lconstLblDurationTrailing];
            
            self.lconstLblDurationTrailing = [NSLayoutConstraint constraintWithItem:self.durationLabel
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.viewDimmed
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1
                                                                           constant:-25];
            [self.viewDimmed addConstraint:self.lconstLblDurationTrailing];
            
        }
        
    }else{
        self.lconstLblPlayHeadLeading.constant = 25.0;
        self.lconstBtnXTopMargin.constant = 20.0;
        self.lconstBtnXTrailing.constant = 0.0;
        self.lconstBtnOutBottomMargin.constant = 0.0;
        self.lconstSilderCenterY.constant = -34.0;
        self.lconstBtnOutTrailing.constant = 0.0;
        
        if (self.lconstLblDurationTrailing != nil) {
            [self.viewDimmed removeConstraint:self.lconstLblDurationTrailing];
            
            self.lconstLblDurationTrailing = [NSLayoutConstraint constraintWithItem:self.durationLabel
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.viewDimmed
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1
                                                                           constant:-25];
            [self.viewDimmed addConstraint:self.lconstLblDurationTrailing];
            
        }
    }
    
    if (self.lconstViewGoProductX != nil) {
        [self.viewDimmed removeConstraint:self.lconstViewGoProductX];
        
        self.lconstViewGoProductX = [NSLayoutConstraint constraintWithItem:self.viewGoProduct
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.viewDimmed
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0];
        [self.viewDimmed addConstraint:self.lconstViewGoProductX];
        
    }
    
    if (self.lconstViewGoProductY != nil) {
        [self.viewDimmed removeConstraint:self.lconstViewGoProductY];
        
        self.lconstViewGoProductY = [NSLayoutConstraint constraintWithItem:self.viewGoProduct
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.playheadSlider
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:-120];
        [self.viewDimmed addConstraint:self.lconstViewGoProductY];
        
    }
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         // do whatever

         if (orientation == UIInterfaceOrientationLandscapeLeft || orientation ==  UIInterfaceOrientationLandscapeRight) {
             [self setLayoutConstrainLandscape];
         }else{
             [self setLayoutConstrainPortrait];
         }

         [self.viewDimmed layoutIfNeeded];
         [self.view layoutIfNeeded];
     }

                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {


     }];
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/*
-(void)drawBCPosterVideoId:(NSString *)strKey{
    [self.BCPlaybackService findVideoWithVideoID:strKey parameters:nil completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {
        
        NSLog(@"jsonResponse = %@",jsonResponse);
        //BOOL isLive = [NCS([jsonResponse objectForKey:@"tags"]) isEqualToString:@"live"];
        //live 배열인지 확인
        
        if ([NCS([jsonResponse objectForKey:@"poster"]) hasPrefix:@"http"]) {
            self.strPosterUrl = [jsonResponse objectForKey:@"poster"];
            
            if([self.strPosterUrl length] > 0) {
                // 이미지 로딩
                [ImageDownManager blockImageDownWithURL:self.strPosterUrl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if (error == nil  && [self.strPosterUrl isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.imgPoster = fetchedImage;
                            if (isInCache) {
                                self.imgViewPoster.image = fetchedImage;
                            }
                            else {
                                self.imgViewPoster.alpha = 0;
                                self.imgViewPoster.image = fetchedImage;
                                
                                [UIView animateWithDuration:0.1f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseInOut
                                                 animations:^{
                                                     self.imgViewPoster.alpha = 1;
                                                 }
                                                 completion:^(BOOL finished) {
                                                 }];
                            }//if else
                        });
                    }//if
                }];
            }//if
            
        }
    }];
}
 */

-(void)catchNotiCloseEvent {
    
    [self onBtnBack:nil];
}

- (void)requestContentFromPlaybackService:(NSString *)strKey
{
    [self.BCPlaybackService findVideoWithVideoID:strKey parameters:nil completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {
        
        NSLog(@"jsonResponse = %@",jsonResponse);
        //BOOL isLive = [NCS([jsonResponse objectForKey:@"tags"]) isEqualToString:@"live"];
        //live 배열인지 확인
        
        if (video)
        {
            [self.BCPlaybackController setVideos:@[ video ]];
        }
        else
        {
            NSLog(@"ViewController Debug - Error retrieving video playlist: `%@`", error);
            
            Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"BCove_Error_text") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            malert.tag = 44;
            
            [ApplicationDelegate.window addSubview:malert];
        }
        
    }];
}

-(void)sendWiseLogWithType:(NSString *)strCase{

    NSArray *arrPt =[self.playheadLabel.text componentsSeparatedByString:@":"];
    NSArray *arrTt =[self.durationLabel.text componentsSeparatedByString:@":"];
    
//    NSInteger intPT = ([[arrPt objectAtIndex:0] integerValue]*60 +[[arrPt objectAtIndex:1] integerValue]);
//    NSInteger intTT = ([[arrTt objectAtIndex:0] integerValue]*60 +[[arrTt objectAtIndex:1] integerValue]);

    NSInteger intPT = 0;
    NSInteger intTT = 0;
    if ([arrPt count] > 0 && [Common_Util isAllDigits:NCS([arrPt objectAtIndex:0])]) {
        if ([arrPt count] == 1) {
            intPT = [NCS([arrPt objectAtIndex:0]) integerValue];
        }else{
            intPT = [NCS([arrPt objectAtIndex:0]) integerValue]*60;
        }
        
    }
    if ([arrPt count] > 1 && [Common_Util isAllDigits:NCS([arrPt objectAtIndex:1])]) {
        intPT = intPT + [NCS([arrPt objectAtIndex:1]) integerValue];
    }
    
    
    if ([arrTt count] > 0 && [Common_Util isAllDigits:NCS([arrTt objectAtIndex:0])]) {
        if ([arrTt count] == 1) {
            intTT = [NCS([arrTt objectAtIndex:0]) integerValue];
        }else{
            intTT = [NCS([arrTt objectAtIndex:0]) integerValue]*60;
        }
        
    }
    if ([arrTt count] > 1 && [Common_Util isAllDigits:NCS([arrTt objectAtIndex:1])]) {
        intTT = intTT + [NCS([arrTt objectAtIndex:1]) integerValue];
    }
    
    
    NSString *strPlayTime = [NSString stringWithFormat:@"%ld",(long)intPT];
    NSString *strTotalTime = [NSString stringWithFormat:@"%ld",(long)intTT];
    NSString *strPrdid = NCS(self.strDealNo);
    
    if (self.isFinish == YES) {
        strPlayTime = [strTotalTime copy];
    }
    
    //NSString *strLog = [NSString stringWithFormat:@"?bhrGbn=bcPlayer_%@&pt=%@&tt=%@&prdid=%@&mseq=A00492-V-CTL",strCase,strPlayTime,strTotalTime,strPrdid];
    
    NSString *strAutoPlay = self.isAutoStart?@"Y":@"N";
    
    NSString *strLog = [NSString stringWithFormat:@"?vid=%@&autoplay=%@&bhrGbn=bcPlayer_%@&pt=%@&tt=%@&prdid=%@&mseq=A00492-V-CTL",self.strVideoID,strAutoPlay,strCase,strPlayTime,strTotalTime,strPrdid];
    
    
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(strLog)];
    
}

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 44) {
        [self onBtnBack:nil];
    }
}

- (void)playMovie:(NSURL *)movieFileURL{
    
    self.isBrightCove = NO;
    
    self.playerView = [[AVPlayerPlayView alloc] init];
    self.playerView.backgroundColor = [UIColor blackColor];
    self.playerView.frame = self.videoContainer.bounds;
    self.playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.videoContainer insertSubview:self.playerView atIndex:0];
    
    self.durationLabel.hidden = YES;
    self.playheadLabel.hidden = YES;
    self.playheadSlider.hidden = YES;
    
    self.URL = movieFileURL;
    
}

-(void)playBrightCoveWithID:(NSString *)strVID{
    
    self.isBrightCove = YES;
    
    BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
    self.BCPlaybackController = [manager createPlaybackControllerWithViewStrategy:nil];
    self.BCPlaybackController.delegate = self;
    self.BCPlaybackController.autoAdvance = YES;
    
    if(self.timeStart == 0.0 && self.isAutoStart == YES){
        self.BCPlaybackController.autoPlay = YES;
    }
    
    [self.BCPlaybackController setAllowsExternalPlayback:YES];
    [self.BCPlaybackController addSessionConsumer:(id)self];
    
    self.BCPlayerView = [[BCOVPUIPlayerView alloc] initWithPlaybackController:self.BCPlaybackController options:nil controlsView:nil ];
    //self.BCPlayerView.delegate = self;
    //self.BCPlayerView.frame = self.videoContainer.bounds;
    //self.BCPlayerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //[self.videoContainer insertSubview:self.BCPlayerView atIndex:0];
    
    
    //BCPlayerView 를 붙혀버리면 상단 스테이터스 바 영역을 브라이트 코브SDK가 강제로 확보 해버려서 꽉찬 VOD재생이 안되어서 수정함
    //정상적으로 재생될경우 session.player 받아서 playerView 에 셋팅하도록 수정함
    self.playerView = [[AVPlayerPlayView alloc] init];
    self.playerView.backgroundColor = [UIColor blackColor];
    self.playerView.frame = self.videoContainer.bounds;
    self.playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.videoContainer insertSubview:self.playerView atIndex:0];
    
    
    self.BCPlaybackService = [[BCOVPlaybackService alloc] initWithAccountId:BRIGHTCOVE_ACCOUNTID policyKey:BRIGHTCOVE_POLICY_KEY];
    
    self.strVideoID =strVID;
    
    if([NetworkManager.shared currentReachabilityStatus] !=  NetworkReachabilityStatusViaWiFi) {
        if ([[DataManager sharedManager].strGlobal3GAgree isEqualToString:@"N"]) {
            return;
        }
    }
    
    [self requestContentFromPlaybackService:strVID];
    
}

-(IBAction)onBtnBack:(id)sender{

    //단품웹유에서 콜할경우 닫고 돌아갈때 하단 구매하기 버튼이 사라지는 버그수정
    id lastVC = [[ApplicationDelegate.mainNVC viewControllers] lastObject];
    
    if ([lastVC isKindOfClass:[ResultWebViewController class]]) {
        // nami0342 - 구매하기 버튼 나오게 처리해서 이 부분 불 필요.
//        ResultWebViewController *rvc = (ResultWebViewController*)[[ApplicationDelegate.mainNVC viewControllers] lastObject];
//        [rvc webViewReload];
    }else if ([lastVC isKindOfClass:[MyShopViewController class]]) {
        MyShopViewController *mvc = (MyShopViewController*)[[ApplicationDelegate.mainNVC viewControllers] lastObject];
        [mvc webViewReload];
    }
    
    if (self.isBrightCove == YES && sender == self.btnBack) {
        [self sendWiseLogWithType:@"EXIT"];
    }else if (self.isBrightCove == YES && sender == self.btnMini) {
        [self sendWiseLogWithType:@"MINI"];
    }
    
    [self mvPlayerDealloc];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

-(IBAction)onBtnMute:(id)sender{
    
    if (self.isBrightCove == YES && sender !=nil) {
        [self sendWiseLogWithType:@"SOUND"];
    }
    
    [self.currentPlayer setMuted:!self.btnMute.selected];
    self.btnMute.selected = !self.btnMute.selected;
    
    if (self.btnMute.selected == YES) {
        [[DataManager sharedManager] setStrGlobalSound:@"N"];
    }else{
        [[DataManager sharedManager] setStrGlobalSound:@"Y"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GS_GLOBAL_SOUND_CHANGE object:nil userInfo:nil];
}

- (IBAction)onBtnOverLayGoProduct:(id)sender{

    [self mvPlayerDealloc];
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
        URLParser *parser = [[URLParser alloc] initWithURLString:vodreqstr];
        NSLog(@"pstr: %@",vodreqstr );
        
        //요부분중요~
        if(_mplayer_type == PLAYSTREAM){
            
            if([Mocha_Util strContain:@"toapp://livestreaming?" srcstring:vodreqstr]){
                
                NSLog(@"commvideourl = %@", [parser valueForVariable:@"url"]);
                NSLog(@"commvideotargeturl = %@", [parser valueForVariable:@"targeturl"]);
                
                if([[parser valueForVariable:@"targeturl"] isEqualToString:@""]
                   || [parser valueForVariable:@"targeturl"] == nil
                   ){
                    return;
                }else{
                    
                    [self.target goWebView:[NSString stringWithFormat:@"%@",[parser valueForVariable:@"targeturl"]]];
                }
                
            }else {
                //동작없음
            }
            
        }
        else {
            
            
            if ([NCS(self.strGoProuctWiseLog) length] > 0 && [NCS(self.strGoProuctWiseLog) hasPrefix:@"http"]) {
                [ApplicationDelegate wiseLogRestRequest:self.strGoProuctWiseLog];
            }
            
            if([Mocha_Util strContain:@"toapp://vod?" srcstring:vodreqstr]){
                
                
                if([[parser valueForVariable:@"prdid"] isEqualToString:@""] || [parser valueForVariable:@"prdid"] == nil ){
                    
                    return;
                    
                }else{
                    [self.target goWebView:[NSString stringWithFormat:@"%@%@",VODPRDDETAILURL, [parser valueForVariable:@"prdid"]]];
                }
                
            } //toapp://vod? 닫기
            else if([Mocha_Util strContain:@"toapp://dealvod?" srcstring:vodreqstr]){
                
                if([[parser valueForVariable:@"targeturl"] isEqualToString:@""] || [parser valueForVariable:@"targeturl"] == nil ){
                    return;
                }else{
                    [self.target goWebView:[NSString stringWithFormat:@"%@",[parser valueForVariable:@"targeturl"]]];
                }
                
            }
            else if([Mocha_Util strContain:@"toapp://livestreaming?" srcstring:vodreqstr]){
                
                if([[parser valueForVariable:@"targeturl"] isEqualToString:@""] || [parser valueForVariable:@"targeturl"] == nil ){
                    return;
                }else{
                    [self.target goWebView:[NSString stringWithFormat:@"%@",[parser valueForVariable:@"targeturl"]]];
                }
                
            }else {
                return;
            }
        }
    
        }];
}

- (void)mvPlayerDealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    @try {
        
        if(self.BCPlaybackController != nil) {
            [self.BCPlaybackController pause];
            self.BCPlaybackController = nil;
        }
        if(self.BCPlayerView != nil) {
            [self.BCPlayerView removeFromSuperview];
            self.BCPlayerView = nil;
        }
        
        if(self.playerItem != nil) {
            [self.playerItem removeObserver:self forKeyPath:kStatusKey];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
            self.playerItem = nil;
        }
        
        if(self.currentPlayer != nil && self.isBrightCove == NO) {
            [self.currentPlayer removeObserver:self forKeyPath:kCurrentItemKey context:AVPlayerCurrentItemObservationContext];
            [self.currentPlayer pause];
            self.currentPlayer = nil;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"exceptionexception = %@",exception);
    }
}

-(void)dealloc{
    NSLog(@"Mocha_MPViewController deallocdeallocdeallocdealloc");

    if (self.currentPlayer != nil) {
        [self.currentPlayer removeTimeObserver:self.playbackObserver];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    /*
    // 백그라운드 음악 재생
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:&error];
     */
}

-(void) showHud:(BOOL)show {
    
    if(show) {
        
        self.viewDimmed.alpha = 0.0;
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.viewDimmed.alpha = 1.0;
                             [self.view layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             self.isShowHuds = show;
                         }];
    }
    else {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.viewDimmed.alpha = 0.0;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             self.isShowHuds = show;
                         }];
    }
    
    [self performSelector:@selector(HudTryHidden) withObject:nil afterDelay:2.5f inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
}

- (void) HudTryHidden {
    if (self.isShowHuds == YES) {
        [self showHud:NO];
    }
}

#pragma mark - BCOVPlaybackControllerDelegate

- (void)playbackController:(id<BCOVPlaybackController>)controller didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session
{
    
}

#pragma mark BCOVPlaybackSession Delegate

- (void)didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session
{
    self.currentPlayer = session.player;
    [self.playerView setPlayer:self.currentPlayer];
    [self.playerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
    
    // Reset State
    self.playingOnSeek = NO;
    self.playheadLabel.text = [Mocha_MPViewController formatTime:0];
    self.playheadSlider.value = 0.f;
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didChangeDuration:(NSTimeInterval)duration
{
    self.durationLabel.text = [Mocha_MPViewController formatTime:duration];
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didProgressTo:(NSTimeInterval)progress
{

    self.playheadLabel.text = [Mocha_MPViewController formatTime:progress];
    
    NSTimeInterval duration = CMTimeGetSeconds(session.player.currentItem.duration);
    float percent = progress / duration;

    [self.playheadSlider setValue:(isnan(percent) ? 0.0f : percent) animated:YES];
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didReceiveLifecycleEvent:(BCOVPlaybackSessionLifecycleEvent *)lifecycleEvent
{
    if ([kBCOVPlaybackSessionLifecycleEventPlay isEqualToString:lifecycleEvent.eventType])
    {

        self.isPlaying = YES;
        self.playPauseButton.selected = YES;
        
        //self.imgViewPoster.hidden = YES;
        
        [self sendWiseLogWithType:@"PLAY"];
        
        [self performSelector:@selector(HudTryHidden) withObject:nil afterDelay:2.5f inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
    }
    else if([kBCOVPlaybackSessionLifecycleEventReady isEqualToString:lifecycleEvent.eventType])
    {

        if (isnan(CMTimeGetSeconds(self.currentPlayer.currentItem.asset.duration)) ) {
            self.playheadSlider.userInteractionEnabled = NO;
        }else{
            self.playheadSlider.userInteractionEnabled = YES;
        }
        
        [self.currentPlayer setMuted:self.btnMute.selected];
        
        if (self.timeStart > 0.0) {
            
            //self.imgViewPoster.hidden = YES;
            
            NSTimeInterval newCurrentTime = self.timeStart;
            
            NSLog(@"newCurrentTime = %f",newCurrentTime);
            NSLog(@"self.timeStart = %f",self.timeStart);
            
            CMTime seekToTime = CMTimeMakeWithSeconds(newCurrentTime, 600);
            typeof(self) __weak weakSelf = self;
            
            CMTimeShow(seekToTime);
            
            [self.currentPlayer seekToTime:seekToTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                
                typeof(self) strongSelf = weakSelf;
                
                if (finished)
                {
                    if (self.isAutoStart == YES) {
                        [strongSelf play];
                    }
                    self.timeStart = 0.0;
                }
            }];
            
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HudTryHidden) object:nil];
        
    }
    else if([kBCOVPlaybackSessionLifecycleEventPause isEqualToString:lifecycleEvent.eventType])
    {
        self.isPlaying = NO;
        self.playPauseButton.selected = NO;
        
        
        [self sendWiseLogWithType:@"PAUSE"];
        
        self.isFinish = NO;
        
        //[self showHud:YES];
        
    }else if([kBCOVPlaybackSessionLifecycleEventEnd isEqualToString:lifecycleEvent.eventType])
    {
    
        self.isFinish = YES;
        
        //self.imgViewPoster.hidden = NO;
        //[self showHud:YES];
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.viewDimmed.alpha = 1.0;
                             [self.view layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             [self pause];
                             self.isShowHuds = YES;
                             [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playerTimeReset) userInfo:nil repeats:NO];
                             
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HudTryHidden) object:nil];
                         }];
        
        
    }
    
    
}

-(void)playerTimeReset{
    [self.currentPlayer seekToTime:kCMTimeZero];
    [self.playheadSlider setValue:0.0f animated:NO];
}

#pragma mark IBActions

- (IBAction)handlePlayPauseButtonPressed:(UIButton *)sender
{
    if (sender.selected)
    {
        
        self.isAutoStart = NO;
        
        [self pause];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HudTryHidden) object:nil];
        
    }
    else
    {
        if(self.isBrightCove == NO){
            NSString *strUrl = [self.URL absoluteString];
            self.URL = [NSURL URLWithString:strUrl];
            [self play];
            
        }else{
            [self play];
        }
        
    }
}

- (IBAction)handlePlayheadSliderValueChanged:(UISlider *)sender
{

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HudTryHidden) object:nil];
    if (self.isPlaying) {
        self.playingOnSeek = YES;
        [self pause];
        
    }
    
    self.playPauseButton.selected = YES;
    
    NSTimeInterval newCurrentTime = sender.value * CMTimeGetSeconds(self.currentPlayer.currentItem.duration);
    self.playheadLabel.text = [Mocha_MPViewController formatTime:newCurrentTime];
}

- (IBAction)handlePlayheadSliderTouchBegin:(UISlider *)sender
{
//    self.playingOnSeek = self.playPauseButton.selected;
//
//    if (self.playPauseButton.selected) {
//        NSLog(@"self.playPauseButton.selected = YES");
//    }else{
//        NSLog(@"self.playPauseButton.selected = NO");
//    }
    
    [self pause];
}

- (IBAction)handlePlayheadSliderTouchEnd:(UISlider *)sender
{
    NSTimeInterval newCurrentTime = sender.value * CMTimeGetSeconds(self.currentPlayer.currentItem.duration);
    CMTime seekToTime = CMTimeMakeWithSeconds(newCurrentTime, 600);
    
    typeof(self) __weak weakSelf = self;
    
    NSLog(@"playingOnSeek = %d",self.playingOnSeek);
    
    
    [self.currentPlayer seekToTime:seekToTime completionHandler:^(BOOL finished) {
        
        typeof(self) strongSelf = weakSelf;
        
        if (finished && strongSelf.wasPlayingOnSeek)
        {
            strongSelf.playingOnSeek = NO;
            [strongSelf play];
        }else{
            strongSelf.playPauseButton.selected = NO;
        }
        
    }];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // This makes sure that we don't try and hide the controls if someone is pressing any of the buttons
    // or slider.
    if([touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[UISlider class]])
    {
        return NO;
    }
    
    return YES;
}

- (IBAction)onBtnScreen:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HudTryHidden) object:nil];
    
    [self showHud:!self.isShowHuds];
    
}

- (IBAction)onBtn3GAlert:(id)sender{
    
    self.view3GAlert.hidden = YES;
    
    if ([((UIButton *)sender) tag] == 888) {
        if (self.isBrightCove == YES) {
            [self sendWiseLogWithType:@"LTE_Y"];
        }
        [DataManager sharedManager].strGlobal3GAgree = @"Y";
        [self play];
        
    }else{
        if (self.isBrightCove == YES) {
            [self sendWiseLogWithType:@"LTE_N"];
        }
        [self showHud:YES];
    }
}

#pragma mark Class Methods

+ (NSString *)formatTime:(NSTimeInterval)timeInterval
{
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.paddingCharacter = @"0";
        numberFormatter.minimumIntegerDigits = 2;
        
    });
    
    if (isnan(timeInterval) || !isfinite(timeInterval) || timeInterval == 0)
    {
        return @"00:00";
    }
    
    NSUInteger hours = floor(timeInterval / 60.0f / 60.0f);
    NSUInteger minutes = (NSUInteger)(timeInterval / 60.0f) % 60;
    NSUInteger seconds = (NSUInteger)timeInterval % 60;
    
    NSString *formattedMinutes = [numberFormatter stringFromNumber:@(minutes)];
    NSString *formattedSeconds = [numberFormatter stringFromNumber:@(seconds)];
    
    NSString *ret = nil;
    if (hours > 0)
    {
        ret = [NSString stringWithFormat:@"%@:%@:%@", @(hours), formattedMinutes, formattedSeconds];
    }
    else
    {
        ret = [NSString stringWithFormat:@"%@:%@", formattedMinutes, formattedSeconds];
    }
    
    return ret;
}




#pragma mark - Private methods

-(void)play
{
    
    if([NetworkManager.shared currentReachabilityStatus] !=  NetworkReachabilityStatusViaWiFi) {
        if ([[DataManager sharedManager].strGlobal3GAgree isEqualToString:@"N"]) {
            self.view3GAlert.hidden = NO;
            [self showHud:NO];
            return;
        }
    }
    

    //self.imgViewPoster.hidden = YES;
    self.isPlaying = YES;
    self.playPauseButton.selected = YES;
    
    if (self.currentPlayer == nil) {
        if (self.isBrightCove == YES) {
            self.BCPlaybackController.autoPlay = YES;
            [self requestContentFromPlaybackService:self.strVideoID];
            
        }else{
            //라이브 동영상의경우...
        }
        
    }else{
        [self.currentPlayer play];
    }
}

-(void)pause
{
    [self.currentPlayer pause];
    self.isPlaying = NO;
    self.playPauseButton.selected = NO;
    
    /*
    // 백그라운드 음악 재생
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:&error];
     */
}

- (void) playbackDidFinishLive:(NSNotification *)noti {
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.viewDimmed.alpha = 1.0;
                         [self.view layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished) {
                         [self pause];
                         [self.currentPlayer seekToTime:kCMTimeZero];
                         self.playheadSlider.value = 0.0;
                         self.isShowHuds = YES;
                     }];
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys {
    @try {
        for(NSString *thisKey in requestedKeys) {
            NSError *error = nil;
            AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
            if (keyStatus == AVKeyValueStatusFailed) {
                return;
            }
        }
        
        if(!asset.playable) {
            return;
        }
        
        if(self.playerItem == nil && self.playerItem != [AVPlayerItem playerItemWithAsset:asset]) {
            self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
            [self.playerItem addObserver:self forKeyPath:kStatusKey options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerStatusObservationContext];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(playbackDidFinishLive:)
                                                         name: AVPlayerItemDidPlayToEndTimeNotification
                                                       object: self.playerItem];
        }
        else {
            if(self.playerItem == nil) {
                NSLog(@"self.playerItem == nil");
            }
            
            if(self.playerItem != [AVPlayerItem playerItemWithAsset:asset]) {
                NSLog(@"self.playerItem = %@",self.playerItem);
                NSLog(@"[AVPlayerItem playerItemWithAsset:asset] = %@",[AVPlayerItem playerItemWithAsset:asset]);
                NSLog(@"self.playerItem != [AVPlayerItem playerItemWithAsset:asset]");
            }
            
            AVURLAsset *asset1 = (AVURLAsset *)[self.playerItem asset]; //currentItem is AVAsset type so incompitable pointer types ... notification will occur, however it does contain URL (see with NSLog)
            AVURLAsset *asset2 = (AVURLAsset *)asset;
            if([asset1.URL isEqual:asset2.URL]) {
                [self.playerItem removeObserver:self forKeyPath:kStatusKey];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
                self.playerItem = nil;
                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                [self.playerItem addObserver:self forKeyPath:kStatusKey options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerStatusObservationContext];
                [[NSNotificationCenter defaultCenter] addObserver: self
                                                         selector: @selector(playbackDidFinishLive:)
                                                             name: AVPlayerItemDidPlayToEndTimeNotification
                                                           object: self.playerItem];
                
            }
            else {
            }
        }
        
        
        if(![self currentPlayer]) {
            [self setCurrentPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];
            [self.currentPlayer addObserver:self
                          forKeyPath:kCurrentItemKey
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:AVPlayerCurrentItemObservationContext];
            
            //Current Time Label
            self.playheadLabel.text = [self getStringFromCMTime:self.currentPlayer.currentTime];
            
            if (isnan(CMTimeGetSeconds(self.currentPlayer.currentItem.asset.duration)) ) {
                self.durationLabel.text = @"00:00";
                self.playheadSlider.userInteractionEnabled = NO;
            }else{
                self.durationLabel.text = [self getStringFromCMTime:self.currentPlayer.currentItem.asset.duration];
                self.playheadSlider.userInteractionEnabled = YES;
            }
            
            CMTime interval = CMTimeMake(33, 1000);
            __weak __typeof(self) weakself = self;
            self.playbackObserver = [self.currentPlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
                CMTime endTime = CMTimeConvertScale (weakself.currentPlayer.currentItem.asset.duration, weakself.currentPlayer.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
                
                if (!isnan(CMTimeGetSeconds(endTime))) {
                 
                    if(CMTimeGetSeconds(endTime) != CMTimeGetSeconds(kCMTimeZero)){
                        double normalizedTime = (double) weakself.currentPlayer.currentTime.value / (double) endTime.value;
                        weakself.playheadSlider.value = normalizedTime;
                    }
                }
                
                weakself.playheadLabel.text = [weakself getStringFromCMTime:weakself.currentPlayer.currentTime];
            }];
        }
        
        if(self.currentPlayer.currentItem != self.playerItem) {
            [[self currentPlayer] replaceCurrentItemWithPlayerItem:self.playerItem];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException = %@",exception);
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

#pragma mark - Key Valye Observing

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    
    
    
    if(context == AVPlayerStatusObservationContext) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if(status == AVPlayerStatusReadyToPlay) {
            
            
            [self.currentPlayer setMuted:self.btnMute.selected];
            //self.btnMute.selected = self.isMuteStart;
            
            if (self.isFirstLiveLoad == YES) {
                self.isFirstLiveLoad = NO;
                
                if (self.isAutoStart == YES) {
                    [self play];
                    [self showHud:NO];
                    
                }else{
                    [self pause];
                }
            }
            
            
            [self performSelector:@selector(HudTryHidden) withObject:nil afterDelay:2.5f inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
            
        }
    }
    else if(context == AVPlayerCurrentItemObservationContext) {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        if(newPlayerItem) {
            [self.playerView setPlayer:self.currentPlayer];
            [self.playerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
        }
    }
    else {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}


#pragma mark - Public methods

- (void)setURL:(NSURL*)URL {
    
    _URL = [URL copy];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:_URL options:nil];
    NSArray *requestedKeys = [NSArray arrayWithObjects:@"tracks", @"playable", nil];
    [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler: ^{
        dispatch_async( dispatch_get_main_queue(), ^{
            [self prepareToPlayAsset:asset withKeys:requestedKeys];
        });
        
    }];
}

- (NSURL*)URL {
    return _URL;
}


@end
