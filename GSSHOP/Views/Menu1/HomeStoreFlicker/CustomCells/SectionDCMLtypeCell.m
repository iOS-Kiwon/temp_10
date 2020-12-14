//
//  SectionDCMLtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 10. 21..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionDCMLtypeCell.h"
#import "Common_Util.h"
#import "AppDelegate.h"
#import "RCMDCELL.h"
#import "HztbGlobalVariables.h"
#import "AVPlayerDemoPlaybackView.h"
#import "DataManager.h"


/* Asset keys */
NSString * const kTracksKey2 = @"tracks";
NSString * const kPlayableKey2 = @"playable";

/* PlayerItem keys */
NSString * const kStatusKey2         = @"status";
NSString * const kCurrentItemKey2    = @"currentItem";

@interface SectionDCMLtypeCell ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerDemoPlaybackView *playerView;
@property (nonatomic, strong) NSURL *URL;
@end

static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;

@implementation SectionDCMLtypeCell

@synthesize productImageView,soldoutView, videoImageView, productTitleLabel, productSubTitleLabel, discountRateLabel,discountRatePercentLabel,extLabel,gsPriceLabel,gsPriceWonLabel  ;
@synthesize originalPriceLabel,originalPriceWonLabel,originalPriceLine,saleCountLabel,saleSaleLabel,saleSaleSubLabel,imageURL;
@synthesize row_dic;
@synthesize targettb;
@synthesize promotionNameLabel;
@synthesize dummytagRB1,dummytagRB2,dummytagRB3,dummytagRB4;
@synthesize dummytagVT1, dummytagVT2;
@synthesize dummytagLT1;
@synthesize dummytagTF1;
@synthesize valuetextLabel, valueinfoLabel;
@synthesize imgAutoPlay;
@synthesize btnPlay;
@synthesize btnReplay;
@synthesize btnView;
@synthesize viewDimmButton;
@synthesize player = _player;
@synthesize playerItem = _playerItem;
@synthesize playerView = _playerView;
@synthesize URL = _URL;
@synthesize isPlayed;
@synthesize productImageViewBG;
@synthesize isSendPlay;
@synthesize originalPricelabel_lmargin;
@synthesize contLTHeight,contLTWidth;




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [[NSBundle mainBundle] loadNibNamed:@"SectionDCMLtypeCell" owner:self options:nil];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.view_Default];
        
        imgAutoPlay.animationImages = [NSArray arrayWithObjects:
                                       [UIImage imageNamed:@"blink_play01.png"],
                                       [UIImage imageNamed:@"blink_play02.png"],
                                       [UIImage imageNamed:@"blink_play03.png"],
                                       [UIImage imageNamed:@"blink_play04.png"],
                                       [UIImage imageNamed:@"blink_play05.png"],
                                       [UIImage imageNamed:@"blink_play04.png"],
                                       [UIImage imageNamed:@"blink_play03.png"],
                                       [UIImage imageNamed:@"blink_play02.png"],
                                       [UIImage imageNamed:@"blink_play01.png"],
                                       [UIImage imageNamed:@"blink_play02.png"],
                                       [UIImage imageNamed:@"blink_play03.png"],
                                       [UIImage imageNamed:@"blink_play04.png"],
                                       [UIImage imageNamed:@"blink_play05.png"],
                                       [UIImage imageNamed:@"blink_play04.png"],
                                       [UIImage imageNamed:@"blink_play03.png"],
                                       [UIImage imageNamed:@"blink_play02.png"],
                                       [UIImage imageNamed:@"blink_play01.png"],
                                       [UIImage imageNamed:@"blink_play02.png"],
                                       [UIImage imageNamed:@"blink_play03.png"],
                                       [UIImage imageNamed:@"blink_play04.png"],
                                       [UIImage imageNamed:@"blink_play05.png"],
                                       [UIImage imageNamed:@"blink_play04.png"],
                                       [UIImage imageNamed:@"blink_play03.png"],
                                       [UIImage imageNamed:@"blink_play02.png"],
                                       [UIImage imageNamed:@"blink_play01.png"],
                                       [UIImage imageNamed:@"blink_play02.png"],
                                       [UIImage imageNamed:@"blink_play03.png"],
                                       [UIImage imageNamed:@"blink_play04.png"],
                                       [UIImage imageNamed:@"blink_play05.png"],
                                       [UIImage imageNamed:@"blink_play04.png"],
                                       [UIImage imageNamed:@"blink_play03.png"],
                                       [UIImage imageNamed:@"blink_play02.png"],
                                       [UIImage imageNamed:@"blink_play01.png"],
                                       nil];
        
        imgAutoPlay.animationDuration = 4.0;
        [imgAutoPlay startAnimating];
        isPlayed = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mvPlayerKillall)
                                                     name:MAINSECTIONDEALVIDEOALLKILL
                                                   object:nil];
    }
    return self;
}



-(void)cellScreenDefine {
    
    isSendPlay = NO;
    textAreaHeigth = 92 + self.benefitHeigth;
    self.infoBoxBottom.constant = 1 - self.benefitHeigth;
    self.frame = CGRectMake(0, 0, APPFULLWIDTH,  [Common_Util DPRateOriginVAL:160] + textAreaHeigth );
    
    self.salesalelabel_width.constant = 46;
    self.valueinfolabel_lmargin.constant = 7;
    self.producttitlelabel_lmargin.constant = 0;
    self.gspricelabel_lmargin.constant = 60;
    self.view_Default.frame = CGRectMake(0, 0, APPFULLWIDTH,  [Common_Util DPRateOriginVAL:160] + textAreaHeigth );
    
    //전체 높이와 같다고 봐야함.
    self.textSpace_bottom.constant = textAreaHeigth;
    self.imgSpace_bottom.constant = textAreaHeigth;
    self.bottomLineSpace_bottom.constant = textAreaHeigth;
    self.videoiConBottom.constant = textAreaHeigth + 6;
    self.videoPlayer_bottom.constant = textAreaHeigth;
    viewProductInfo.hidden = NO;
    [self.view_Default layoutIfNeeded];
}




-(void) prepareForReuse {
    //아랫줄 필수
    [super prepareForReuse];
    [self cellScreenDefine];
    
    self.valuetextLabel.hidden = YES;
    self.valueinfoLabel.hidden = YES;
    self.dummytagRB1.hidden = YES;
    self.dummytagRB2.hidden = YES;
    self.dummytagRB3.hidden = YES;
    self.dummytagRB4.hidden = YES;
    self.dummytagVT1.hidden = YES;
    self.dummytagVT2.hidden = YES;
    self.dummytagLT1.hidden = YES;
    self.dummytagTF1.text = @"";
    self.originalPriceLine.hidden = YES;
    self.extLabel.hidden = YES;
    self.gsPriceLabel.text = @"";
    self.originalPriceLabel.text = @"";
    self.originalPriceWonLabel.hidden = YES;
    self.saleCountLabel.text = @"";
    self.saleSaleLabel.hidden =YES;
    self.saleSaleSubLabel.hidden = YES;
    self.discountRateLabel.hidden =YES;
    self.discountRateLabel.text = @"";
    self.discountRatePercentLabel.hidden =YES;
    self.videoImageView.hidden  = YES;
    self.soldoutView.hidden = YES;
    self.productTitleLabel.text = @"";
    self.productSubTitleLabel.text = @"";
    self.productSubTitleLabel.hidden = YES;
    self.productImageView.image = nil;
    self.dummytagLT1.image = nil;
    self.promotionNameLabel.text = @"";
    
    if(benefitview != nil) {
        [benefitview removeFromSuperview];
        benefitview = nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



- (void)mvPlayerKillall {
    [self mvPlayerDealloc];
}



- (void)mvPlayerDealloc {
    isSendPlay = NO;
    @try {
        if (self.playerItem != nil) {
            [self.playerItem removeObserver:self forKeyPath:kStatusKey2];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
            self.playerItem = nil;
        }
        
        if (self.player != nil) {
            [self.player removeObserver:self forKeyPath:kCurrentItemKey2 context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
            self.player = nil;
        }
        
        if (self.playerView != nil) {
            [self.playerView removeFromSuperview];
            self.playerView = nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exceptionexception = %@",exception);
    }
}



-(void)mvPlayerInit {
    if (self.playerView !=nil) {
        [self mvPlayerDealloc];
    }
    
    @try {
        NSString *path = [self.row_dic objectForKey:@"dealMcVideoUrlAddr"];
        
#if APPSTORE
#else
        //치명
        //NSString *path = @"http://image.gsshop.com/mi09/deal/vod/20150706144459079978.mp4"; //소리나는 베딜 찰흙놀이 4분12초
        //NSString *path = @"http://image.gsshop.com/mi09/deal/vod/20151103103356576583.mp4"; //전지현
        //NSString *path = @"http://image.gsshop.com/mi09/deal/vod/20151028160357551912.mp4"; //아디다스 30초
#endif
        
        if ([path length] == 0 || ![path hasPrefix:@"http://"]) {
            imgAutoPlay.hidden = YES;
            btnPlay.hidden = YES;
            viewDimmed.hidden = YES;
            return;
        }
        
        self.playerView = [[AVPlayerDemoPlaybackView alloc] init];
        self.playerView.frame = CGRectMake(0.0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:160.0]);
        self.playerView.backgroundColor = [UIColor blackColor];
        [viewMPlayerArea addSubview:self.playerView];
        viewDimmed.hidden = YES;
        self.URL = [NSURL URLWithString:path];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


- (void)dealloc {
    [self mvPlayerDealloc];
}



-(void)pauseMoviePlayer {
    
}


-(void)stopMoviePlayer{
    
    viewProductInfo.hidden = NO;
    [self mvPlayerDealloc];
    
    if (!isPlayed) {
        viewDimmed.hidden = YES;
        if([LL(BESTDEAL_AUTOPLAYMOVIE) isEqualToString:@"Y"]) {
            btnPlay.hidden = YES;
            imgAutoPlay.hidden = NO;
            imgAutoPlay.alpha = 1.0;
            self.productImageViewBG.hidden = NO;
        }
        else {
            btnPlay.hidden = NO;
            imgAutoPlay.hidden = YES;
        }
    }
    else {
        viewDimmed.hidden = NO;
        btnPlay.hidden = YES;
    }
}


- (IBAction)onStop:(id)sender {
    [self stopMoviePlayer];
}

- (IBAction)playMoviePlayer:(id)sender {
    self.productImageView.hidden = NO;
    if (sender == btnPlay) {
        
    }
    else if (sender == btnReplay) {
        
    }
    else if (sender == nil) {
        if(![LL(BESTDEAL_AUTOPLAYMOVIE) isEqualToString:@"Y"]) {
            if (btnPlay.hidden == NO) {
                return;
            }
        }
    }
    
    viewDimmed.hidden = YES;
    imgAutoPlay.hidden = NO;
    imgAutoPlay.alpha = 1.0;
    btnPlay.hidden = YES;
    [imgAutoPlay startAnimating];
    [self mvPlayerInit];
}

- (float)nowPlayingRate {
    return self.player.rate;
}


- (void)checkPlayStateAndResume {
    
    NSString *path = [self.row_dic objectForKey:@"dealMcVideoUrlAddr"];
    if ([(NSNumber *)[self.row_dic objectForKey:@"isTempOut"] boolValue]) {
        imgAutoPlay.hidden = NO;
        btnPlay.hidden = YES;
        viewDimmed.hidden = YES;
        soldoutView.hidden = NO;
        return;
    }
    
    if ([path length] == 0 || ![path hasPrefix:@"http://"]) {
        imgAutoPlay.hidden = YES;
        btnPlay.hidden = YES;
        viewDimmed.hidden = YES;
        return;
    }
    
    if (!isPlayed) {
        viewDimmed.hidden = YES;
        self.productImageView.hidden = NO;
        
        if([LL(BESTDEAL_AUTOPLAYMOVIE) isEqualToString:@"Y"]) {
            btnPlay.hidden = YES;
            imgAutoPlay.hidden = NO;
            imgAutoPlay.alpha = 1.0;
            [imgAutoPlay startAnimating];
            [self mvPlayerInit];
        }
        else {
            btnPlay.hidden = NO;
            imgAutoPlay.hidden = YES;
        }
    }
    else {
        viewDimmed.hidden = NO;
    }
}


- (void) playbackDidFinish:(NSNotification *)noti {
    
    isPlayed = YES;
    [self playerStopAndShowDimmedView];
    
    if (self.playerItem != nil) {
        [self mvPlayerDealloc];
    }
}


- (IBAction)onBtnViewProduct:(id)sender {
    [targettb dctypetouchEventTBCell:self.row_dic  andCnum:[NSNumber numberWithInt:(int)index] withCallType:@"ML"];
}


- (void)playerStopAndShowDimmedView{
    
    viewProductInfo.hidden = NO;
    if (!isPlayed) {
        viewDimmed.hidden = YES;
        if([LL(BESTDEAL_AUTOPLAYMOVIE) isEqualToString:@"Y"]) {
            btnPlay.hidden = YES;
            imgAutoPlay.hidden = NO;
        }
        else {
            btnPlay.hidden = NO;
            imgAutoPlay.hidden = YES;
        }
    }
    else {
        viewDimmed.hidden = NO;
        btnPlay.hidden = YES;
    }
}



- (void)setCellInfoNDrawData:(NSDictionary*) infoDic {
    
    self.row_dic = infoDic;
    self.productImageView.hidden = NO;
    
    if ([(NSNumber *)[self.row_dic objectForKey:@"isTempOut"] boolValue]) {
        [imgAutoPlay stopAnimating];
        imgAutoPlay.hidden = NO;
        imgAutoPlay.alpha = 1.0;
        
        btnPlay.hidden = YES;
        viewDimmed.hidden = YES;
        self.productImageView.hidden = NO;
        
    }
    else {
        if (!isPlayed) {
            viewDimmed.hidden = YES;
            self.productImageView.hidden = NO;
            
            if([LL(BESTDEAL_AUTOPLAYMOVIE) isEqualToString:@"Y"]){
                btnPlay.hidden = YES;
                imgAutoPlay.hidden = NO;
                imgAutoPlay.alpha = 1.0;
                
            }
            else {
                btnPlay.hidden = NO;
                imgAutoPlay.hidden = YES;
            }
        }
        else {
            viewDimmed.hidden = NO;
        }
    }
    
    
    
    //19금 제한 적용 v3.1.6.17 20150602~
    if([NCS([infoDic objectForKey:@"adultCertYn"]) isEqualToString:@"Y"]) {
        if( [Common_Util isthisAdultCerted] == NO){
            self.productImageView.image =  [UIImage imageNamed:@"prevent19cellimg"];
        }
        else {
            if([NCS([infoDic objectForKey:@"imageUrl"]) length] > 0 ) {
                
                // 이미지 로딩
                self.imageURL = NCS([infoDic objectForKey:@"imageUrl"]);
                [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if (error == nil  && [self.imageURL isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(isInCache) {
                                self.productImageView.image = fetchedImage;
                            }
                            else {
                                self.productImageView.alpha = 0;
                                self.productImageView.image = fetchedImage;
                                
                                [UIView animateWithDuration:0.2f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseInOut
                                                 animations:^{
                                                     self.productImageView.alpha = 1;
                                                 }
                                                 completion:^(BOOL finished) {
                                                 }];
                            }
                        });
                    }
                }];
            }
        }
    }
    else {
        if([NCS([infoDic objectForKey:@"imageUrl"]) length] > 0) {
            // 이미지 로딩
            self.imageURL = NCS([infoDic objectForKey:@"imageUrl"]);
            [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                
                if (error == nil  && [self.imageURL isEqualToString:strInputURL]){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(isInCache) {
                            self.productImageView.image = fetchedImage;
                        }
                        else {
                            self.productImageView.alpha = 0;
                            self.productImageView.image = fetchedImage;
                            [UIView animateWithDuration:0.1f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.productImageView.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                             }];
                        }
                    });
                }
            }];
        }
    }
    
    
    if([NCS([infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"]) {
        if( [Common_Util isthisAdultCerted] == YES) {
            if(NCO([infoDic objectForKey:@"imgBadgeCorner"]) == NO && NCO([[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ]) == NO && [(NSArray*)[[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] count] == 0) {
                self.dummytagLT1.hidden = YES;
            }
            else {
                self.dummytagLT1.hidden = NO;
                if(self.dummytagLT1.image == nil) {
                    //20160106 벳지 크기가 다양하게 들어와도 대응할수 있도록 처리
                    NSString *LTurl  = NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] objectAtIndex:0] objectForKey: @"imgUrl" ]);
                    [ImageDownManager blockImageDownWithURL:LTurl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                        if (error == nil  && [LTurl isEqualToString:strInputURL]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //실제 사이즈 대비 1/2로 축소
                                UIImage* resizeImage = [UIImage imageWithCGImage:fetchedImage.CGImage scale:fetchedImage.scale * 2.0f orientation:fetchedImage.imageOrientation];
                                
                                self.contLTWidth.constant = resizeImage.size.width;
                                self.contLTHeight.constant = resizeImage.size.height;
                                if(isInCache) {
                                    self.dummytagLT1.image = resizeImage;
                                }
                                else {
                                    self.dummytagLT1.alpha = 0;
                                    self.dummytagLT1.image = resizeImage;
                                    [UIView animateWithDuration:0.1f
                                                          delay:0.0f
                                                        options:UIViewAnimationOptionCurveEaseInOut
                                                     animations:^{
                                                         self.dummytagLT1.alpha = 1;
                                                     }
                                                     completion:^(BOOL finished) {
                                                     }];
                                }
                            });
                        }
                    }];
                }
            }
            
            if([infoDic objectForKey:@"imgBadgeCorner"]  != [NSNull null]) {
                switch ([    (NSArray*)[[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] count]) {
                    case 0:
                        self.dummytagRB1.hidden = YES;
                        self.dummytagRB2.hidden = YES;
                        self.dummytagRB3.hidden = YES;
                        self.dummytagRB4.hidden = YES;
                        break;
                    case 1:
                        self.dummytagRB1.hidden = YES;
                        self.dummytagRB2.hidden = YES;
                        self.dummytagRB3.hidden = YES;
                        self.dummytagRB4.hidden = NO;
                        self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ]  ];
                        
                        break;
                        
                    case 2:
                        self.dummytagRB1.hidden = YES;
                        self.dummytagRB2.hidden = YES;
                        self.dummytagRB3.hidden = NO;
                        self.dummytagRB4.hidden = NO;
                        
                        self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ]  ];
                        self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ]  ];
                        
                        break;
                        
                    case 3:
                        self.dummytagRB1.hidden = YES;
                        self.dummytagRB2.hidden = NO;
                        self.dummytagRB3.hidden = NO;
                        self.dummytagRB4.hidden = NO;
                        
                        self.dummytagRB2.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ]  ];
                        self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ]  ];
                        self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:2] objectForKey: @"type" ]  ];
                        
                        break;
                        
                    case 4:
                        self.dummytagRB1.hidden = NO;
                        self.dummytagRB2.hidden = NO;
                        self.dummytagRB3.hidden = NO;
                        self.dummytagRB4.hidden = NO;
                        
                        self.dummytagRB1.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ]  ];
                        self.dummytagRB2.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ]  ];
                        self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:2] objectForKey: @"type" ]  ];
                        self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:3] objectForKey: @"type" ]  ];
                        
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
    else {
        if(NCO([infoDic objectForKey:@"imgBadgeCorner"]) && NCO([[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] ) && [    (NSArray*)[[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] count] == 0) {
            self.dummytagLT1.hidden = YES;
        }
        else {
            self.dummytagLT1.hidden = NO;
            if(self.dummytagLT1.image == nil) {
                
                //20160106 벳지 크기가 다양하게 들어와도 대응할수 있도록 처리
                NSString *LTurl  = NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] objectAtIndex:0] objectForKey: @"imgUrl" ]);
                NSLog(@"%@",LTurl);
                [ImageDownManager blockImageDownWithURL:LTurl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    
                    if (error == nil  && [LTurl isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //실제 사이즈 대비 1/2로 축소
                            UIImage *resizeImage = [UIImage imageWithCGImage:fetchedImage.CGImage scale:fetchedImage.scale * 2.0f orientation:fetchedImage.imageOrientation];
                            self.contLTWidth.constant = resizeImage.size.width;
                            self.contLTHeight.constant = resizeImage.size.height;
                            
                            if(isInCache) {
                                self.dummytagLT1.image = resizeImage;
                            }
                            else {
                                self.dummytagLT1.alpha = 0;
                                self.dummytagLT1.image = resizeImage;
                                
                                [UIView animateWithDuration:0.1f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseInOut
                                                 animations:^{
                                                     self.dummytagLT1.alpha = 1;
                                                 }
                                                 completion:^(BOOL finished) {
                                                     
                                                 }];
                            }
                        });
                    }
                }];
            }
        }
        
        if([infoDic objectForKey:@"imgBadgeCorner"]  != [NSNull null]) {
            switch ([    (NSArray*)[[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] count]) {
                case 0:
                    self.dummytagRB1.hidden = YES;
                    self.dummytagRB2.hidden = YES;
                    self.dummytagRB3.hidden = YES;
                    self.dummytagRB4.hidden = YES;
                    
                    break;
                    
                case 1:
                    self.dummytagRB1.hidden = YES;
                    self.dummytagRB2.hidden = YES;
                    self.dummytagRB3.hidden = YES;
                    self.dummytagRB4.hidden = NO;
                    
                    self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ]  ];
                    
                    break;
                    
                case 2:
                    self.dummytagRB1.hidden = YES;
                    self.dummytagRB2.hidden = YES;
                    self.dummytagRB3.hidden = NO;
                    self.dummytagRB4.hidden = NO;
                    
                    self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ]  ];
                    self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ]  ];
                    
                    break;
                    
                case 3:
                    self.dummytagRB1.hidden = YES;
                    self.dummytagRB2.hidden = NO;
                    self.dummytagRB3.hidden = NO;
                    self.dummytagRB4.hidden = NO;
                    
                    self.dummytagRB2.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ]  ];
                    self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ]  ];
                    self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:2] objectForKey: @"type" ]  ];
                    
                    break;
                    
                case 4:
                    self.dummytagRB1.hidden = NO;
                    self.dummytagRB2.hidden = NO;
                    self.dummytagRB3.hidden = NO;
                    self.dummytagRB4.hidden = NO;
                    
                    self.dummytagRB1.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ]  ];
                    self.dummytagRB2.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ]  ];
                    self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:2] objectForKey: @"type" ]  ];
                    self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:3] objectForKey: @"type" ]  ];
                    
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    
    // soldout image view
    self.soldoutView.hidden =![(NSNumber *)[infoDic objectForKey:@"isTempOut"] boolValue];
    
    // video image view
    self.videoImageView.hidden = ![(NSNumber *)[infoDic objectForKey:@"hasVod"] boolValue];
    
    // title
    switch ([ (NSArray*)[[infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ] count]) {
        case 0:
            self.dummytagVT1.hidden = YES;
            self.dummytagVT2.hidden = YES;
            
            break;
            
        case 1:
            self.dummytagVT1.hidden = NO;
            self.dummytagVT2.hidden = YES;
            
            self.dummytagVT1.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ] objectAtIndex:0] objectForKey: @"type" ]  ];
            
            break;
            
        case 2:
            self.dummytagVT1.hidden = NO;
            self.dummytagVT2.hidden = NO;
            
            self.dummytagVT1.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ] objectAtIndex:0] objectForKey: @"type" ]  ];
            self.dummytagVT2.image = [self tagimageWithtype:     (NSString*)[   [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ] objectAtIndex:1] objectForKey: @"type" ]  ];
            
            break;
        default:
            break;
    }
    
    
    if(NCO([infoDic objectForKey:@"infoBadge"]) && NCA([[infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {
        
        if([(NSArray*)[[infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.dummytagTF1.hidden = NO;
            self.dummytagTF1.text = (NSString*)[ [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ];
            
            if( [(NSString*)[ [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ] length] > 0) {
                self.dummytagTF1.textColor = [Mocha_Util getColor:(NSString*)[   [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]];
            }
            self.producttitlelabel_lmargin.constant = 5;
        }
        else {
            self.dummytagTF1.hidden = YES;
            self.dummytagTF1.text = @"";
            self.producttitlelabel_lmargin.constant = 0;
        }
    }else{
        self.dummytagTF1.hidden = YES;
        self.dummytagTF1.text = @"";
        self.producttitlelabel_lmargin.constant = 0;
    }
    
    self.productTitleLabel.text = [infoDic objectForKey:@"productName"];
    self.promotionNameLabel.text = [infoDic objectForKey:@"promotionName"];
    
    // 할인율 / GS가
    NSString *removeCommadrstr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"discountRate"]] ];
    
    if([NCS([infoDic objectForKey:@"discountRateText"]) length] > 0 ) {
        self.extLabel.text = NCS([infoDic objectForKey:@"discountRateText"]);
        self.extLabel.hidden = NO;
        
        CGSize extlabelsize = [self.extLabel sizeThatFits:extLabel.frame.size];
        self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN+extlabelsize.width+kCELLCONTENTSBETWEENMARGIN;
        
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
    }
    
    else if(  [Common_Util isThisValidWithZeroStr:removeCommadrstr] == YES) {
        int discountRate = [(NSNumber *)[infoDic objectForKey:@"discountRate"] intValue];
        
        if(NCO([infoDic objectForKey:@"discountRate"])) {
            if(discountRate > 0) {
                self.discountRateLabel.text = [NSString stringWithFormat:@"%d", discountRate];
                self.discountRateLabel.hidden = NO;
                self.discountRatePercentLabel.hidden = NO;
                float disratelabelsize = [self.discountRateLabel sizeThatFits:discountRateLabel.frame.size].width + [self.discountRatePercentLabel sizeThatFits:discountRatePercentLabel.frame.size].width;
                self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN+disratelabelsize+kCELLCONTENTSBETWEENMARGIN;
                self.extLabel.hidden = YES;
            }
            else {
                self.discountRateLabel.hidden = YES;
                self.discountRatePercentLabel.hidden = YES;
                self.extLabel.hidden = YES;
                self.gspricelabel_lmargin.constant = kCELLCONTENTSLEFTMARGIN;
            }
        }
        else {
            //전체 뷰히든
            //20160630 parksegun discountRate값이 nil이면 해당 영역을 숨긴다.
            self.discountRateLabel.hidden = YES;
            self.discountRatePercentLabel.hidden = YES;
            self.extLabel.hidden = YES;
        }
    }
    else {
        //전체 뷰히든
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
        self.extLabel.hidden = YES;
    }
    
    
    
    //valueText
    if([[infoDic objectForKey:@"valueText"]  length] > 0 ) {
        self.extLabel.hidden = YES;
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
        self.valuetextLabel.text = [infoDic objectForKey:@"valueText"];
        CGSize vtlabelsize = [self.valuetextLabel sizeThatFits:valuetextLabel.frame.size];
        self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN+vtlabelsize.width+kCELLCONTENTSBETWEENMARGIN;
        self.valuetextLabel.hidden = NO;
    }
    else {
        self.valuetextLabel.text = @"";
        self.valuetextLabel.hidden = YES;
    }
    
    //valueInfo
    if([[infoDic objectForKey:@"valueInfo"]  length] > 0 ) {
        self.valueinfoLabel.hidden = NO;
        self.valueinfoLabel.text = [infoDic objectForKey:@"valueInfo"];
        self.valueinfolabel_lmargin.constant = 7;
    }
    else {
        self.valueinfoLabel.text = @"";
        self.valueinfoLabel.hidden = YES;
        self.valueinfolabel_lmargin.constant = 0;
    }
    
    
    int salePrice = 0;
    
    if([infoDic objectForKey:@"salePrice"] != nil) {
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"salePrice"]]];
        
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES) {
            salePrice = [(NSNumber *)removeCommaspricestr intValue];
            self.gsPriceLabel.text = [Common_Util commaStringFromDecimal:salePrice];
            self.gsPriceWonLabel.text  =  [infoDic objectForKey:@"exposePriceText"];
            
            self.gsPriceLabel.hidden = NO;
            self.gsPriceWonLabel.hidden = NO;
            
        }
        else {
            //숫자아님
            self.gsPriceLabel.hidden = YES;
            self.gsPriceWonLabel.hidden = NO;
        }
    }
    else {
        self.gsPriceLabel.hidden = YES;
        self.gsPriceWonLabel.hidden = YES;
    }
    
    
    
    
    //실선 baseprice 원래 가격
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:[infoDic objectForKey:@"basePrice"]];
    int basePrice = [(NSNumber *)removeCommaorgstr intValue];
    if (basePrice > 0 && basePrice > salePrice) {
        self.originalPriceLabel.text = [Common_Util commaStringFromDecimal:basePrice];
        self.originalPriceWonLabel.text = [infoDic objectForKey:@"exposePriceText"];
        
        //2015/07/29 yunsang.jin 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        if ([infoDic objectForKey:@"discountRate"] != nil && [[infoDic objectForKey:@"discountRate"] intValue] < 1) {
            self.originalPriceLine.hidden = YES;
            self.originalPriceLabel.hidden = YES;
            self.originalPriceWonLabel.hidden = YES;
            self.originalPricelabel_lmargin.constant = 0;
        }
        else {
            self.originalPriceLabel.hidden = NO;
            self.originalPriceWonLabel.hidden = NO;
            self.originalPriceLine.hidden = NO;
            self.originalPricelabel_lmargin.constant = 5;
        }
    }
    else {
        self.originalPriceLabel.hidden = YES;
        self.originalPriceWonLabel.hidden = YES;
        self.originalPriceLine.hidden = YES;
        self.originalPricelabel_lmargin.constant = 0;
    }
    
    
    //매진시 판매수량 노출하지않음
    if(self.soldoutView.hidden == NO) {
        self.saleCountLabel.hidden = YES;
        self.saleSaleLabel.hidden =YES;
        self.saleSaleSubLabel.hidden = YES;
        self.originalPricelabel_lmargin.constant = 0;
        return;
    }
    
    
    
    //3열 판매수량
    if([infoDic objectForKey:@"saleQuantity"] != [NSNull null]) {
        
        NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:[infoDic objectForKey:@"saleQuantity"]];
        //숫자가 맞음
        if([Common_Util isThisValidNumberStr:removeCommaorgstr]) {
            self.saleCountLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantity"] ];
            self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantityText"] ];
            self.saleSaleSubLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantitySubText"] ];
            self.saleCountLabel.hidden = NO;
            self.saleSaleLabel.hidden = NO;
            self.saleSaleSubLabel.hidden = NO;
            self.salesalelabel_width.constant = 50;
        }
        //숫자아니거나 0일때 수량text 존재함
        else if(  [[infoDic objectForKey:@"saleQuantityText"] length] > 0) {
            self.saleCountLabel.hidden = YES;
            self.saleSaleSubLabel.hidden = YES;
            self.saleSaleLabel.hidden = NO;
            //saleSaleLabel  확장시키자
            self.salesalelabel_width.constant = 10;
            self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantityText"] ];
        }
        else {
            //숫자가 아니거나 0인경우 사라짐
            self.saleCountLabel.hidden = YES;
            self.saleSaleLabel.hidden =YES;
            self.saleSaleSubLabel.hidden = YES;
        }
    }
    
    //////// 하단 혜택 딱지 노출 시작 ////////20170929
    if(self.benefitHeigth != 0) {
        if(benefitview == nil) {
            benefitview = [[[NSBundle mainBundle] loadNibNamed:@"BenefitTagView" owner:self options:nil] firstObject];
            [self.view_Default addSubview:benefitview];
            benefitview.frame = CGRectMake(0,  [Common_Util DPRateOriginVAL:160]  + 64 , self.frame.size.width, self.benefitHeigth);
        }
        [benefitview setBenefitTag:infoDic];
    }
    //////// 하단 혜택 딱지 노출 종료 ////////
    
}


- (UIImage*) tagimageWithtype : (NSString*)ttype {
    
    UIImage *timage;
    //RB
    if([ttype isEqualToString:@"freeDlv"]) {
        
        timage = [UIImage imageNamed:@"dc_badge_free"];
    }
    else if([ttype isEqualToString:@"todayClose"]) {
        
        timage = [UIImage imageNamed:@"dc_badge_end"];
    }
    
    else if([ttype isEqualToString:@"freeInstall"]) {
        
        timage = [UIImage imageNamed:@"dc_badge_finstall"];
    }
    
    else if([ttype isEqualToString:@"Reserves"]) {
        
        timage = [UIImage imageNamed:@"dc_badge_reward"];
    }
    else if([ttype isEqualToString:@"interestFree"]) {
        
        timage = [UIImage imageNamed:@"dc_badge_nogain"];
    }
    //VT
    else if([ttype isEqualToString:@"quickDlv"]) {
        
        timage = [UIImage imageNamed:@"dc_stag_delivery"];
    }
    else if([ttype isEqualToString:@"worldDlv"]) {
        
        timage = [UIImage imageNamed:@"dc_btag_ocdelivery"];
    }
    else {
        return nil;
    }
    return timage;
}




#pragma mark - Private methods

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys {
    
    @try {
        for (NSString *thisKey in requestedKeys) {
            NSError *error = nil;
            AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
            if (keyStatus == AVKeyValueStatusFailed) {
                return;
            }
        }
        
        if (!asset.playable) {
            return;
        }
        
        if (self.playerItem == nil && self.playerItem != [AVPlayerItem playerItemWithAsset:asset]) {
            self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
            [self.playerItem addObserver:self forKeyPath:kStatusKey2 options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(playbackDidFinish:)
                                                         name: AVPlayerItemDidPlayToEndTimeNotification
                                                       object: self.playerItem];
        }
        else {
            
            if (self.playerItem == nil) {
            }
            
            if (self.playerItem != [AVPlayerItem playerItemWithAsset:asset]) {
            }
            AVURLAsset *asset1 = (AVURLAsset *)[self.playerItem asset]; //currentItem is AVAsset type so incompitable pointer types ... notification will occur, however it does contain URL (see with NSLog)
            AVURLAsset *asset2 = (AVURLAsset *)asset;
            if ([asset1.URL isEqual:asset2.URL]) {
                
                [self.playerItem removeObserver:self forKeyPath:kStatusKey2];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
                self.playerItem = nil;
                
                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                [self.playerItem addObserver:self forKeyPath:kStatusKey2 options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
                [[NSNotificationCenter defaultCenter] addObserver: self
                                                         selector: @selector(playbackDidFinish:)
                                                             name: AVPlayerItemDidPlayToEndTimeNotification
                                                           object: self.playerItem];
                
            }
            else {
                
            }
        }
        if (![self player]) {
            
            [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];
            [self.player addObserver:self
                          forKeyPath:kCurrentItemKey2
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
        }
        
        if (self.player.currentItem != self.playerItem) {
            [[self player] replaceCurrentItemWithPlayerItem:self.playerItem];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException = %@",exception);
    }
}


#pragma mark - Key Valye Observing
- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    
    if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            
            isPlayed = NO;
            btnPlay.hidden = YES;
            viewDimmed.hidden = YES;
            viewProductInfo.hidden = YES;
            
            if (imgAutoPlay.hidden == NO) {
                [imgAutoPlay stopAnimating];
                [UIView animateWithDuration:0.4f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     imgAutoPlay.alpha = 0;
                                 }
                                 completion:^(BOOL finished) {
                                     
                                 }];
            }
            
            [self.player setMuted:YES];
            [self.player play];
        }
    }
    else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext) {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        if (newPlayerItem) {
            [self.playerView setPlayer:self.player];
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
    NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey2, kPlayableKey2, nil];
    [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler: ^{
        dispatch_async( dispatch_get_main_queue(), ^{
            [self prepareToPlayAsset:asset withKeys:requestedKeys];
        });
    }];
}

- (NSURL*)URL {
    return _URL;
}


- (void)downTest {
    
}

@end
