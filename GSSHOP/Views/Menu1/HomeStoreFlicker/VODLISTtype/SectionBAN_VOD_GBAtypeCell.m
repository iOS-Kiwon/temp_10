//
//  SectionBAN_VOD_GBAtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2019. 4. 8..
//  Copyright © 2019년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_VOD_GBAtypeCell.h"
#import "AppDelegate.h"
#import "VODListTableViewController.h"
#import "BenefitTagView.h"

@interface SectionBAN_VOD_GBAtypeCell () <BCOVPlaybackControllerDelegate , BCOVPUIPlayerViewDelegate /*BCOVPlaybackSession*/>
@property (nonatomic, strong) BCOVPlaybackService *BCPlaybackService;
@property (nonatomic, strong) id<BCOVPlaybackController> BCPlaybackController;
@property (nonatomic, strong) BCOVPUIPlayerView *BCPlayerView;
@property (nonatomic, weak) AVPlayer *currentPlayer;
@property (nonatomic, assign) NSTimeInterval durTotal;
@end

@implementation SectionBAN_VOD_GBAtypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fixedWidth = APPFULLWIDTH;
    self.fixedHeight = APPFULLHEIGHT;
    
    [self cellScreenDefine];
    
    self.viewPGMImageBorder.layer.borderWidth = 1.0;
    self.viewPGMImageBorder.layer.cornerRadius = 25/2;
    self.viewPGMImageBorder.layer.shouldRasterize = YES;
    self.viewPGMImageBorder.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewPGMImageBorder.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.05f].CGColor;
    
    self.viewBtn3GAlertCancel.layer.borderWidth = 1.0;
    self.viewBtn3GAlertCancel.layer.cornerRadius = 17.0;
    self.viewBtn3GAlertCancel.layer.shouldRasterize = YES;
    self.viewBtn3GAlertCancel.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewBtn3GAlertCancel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.viewBtn3GAlertConfirm.layer.cornerRadius = 17.0;
    self.viewBtn3GAlertConfirm.layer.shouldRasterize = YES;
    self.viewBtn3GAlertConfirm.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, APPFULLWIDTH-20.0, 50.0);
    gradient.colors = @[(id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.00].CGColor,(id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8].CGColor];
    [self.viewBottomGraDimm.layer addSublayer:gradient];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSoundStatus)
                                                 name:GS_GLOBAL_SOUND_CHANGE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mvPlayerDealloc)
                                                 name:MAINSECTION_VODVIDEOALLKILL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mvPlayerPause)
                                                 name:MAINSECTION_VODVIDEOPAUSE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mvPlayerAutoPlayPause)
                                                 name:MAINSECTION_VODVIDEOPAUSE_NOTME
                                               object:nil];
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mvPlayerAutoPlayPause)
                                                 name:MAINSECTION_VODVIDEOAUTOPLAY_PAUSE
                                               object:nil];
    */
    
    
}

-(void)drawRect:(CGRect)rect{
    NSLog(@"self.viewMPlayerArea = %@",self.viewMPlayerArea);
    NSLog(@"self.viewShowProduct = %@",self.viewShowProduct);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HudTryHidden) object:nil];
    [self mvPlayerDealloc];
    [self cellScreenDefine];
}

-(void)cellScreenDefine{

    [self.btnPlay setImage:[UIImage imageNamed:@"vod_shop_icPlayRound.png"] forState:UIControlStateNormal];
    self.btnPlay.selected = NO;
    self.strPosterUrl = nil;
    self.imgPoster = nil;
    self.imgVerticalVideoBG.hidden = YES;
    self.isPlaying = NO;

    self.isFullScreenPause = NO;
    self.imgThumbnail.hidden = NO;
    //self.imgThumbnail.alpha = 1.0;
    self.view3GAlert.hidden = YES;
    self.btnDimms.hidden = NO;
    self.viewImageDimm.alpha = 0.2;
    
    self.btnMute.hidden = YES;
    self.btnFullMovie.hidden = YES;
    self.btnDimmClose.hidden = YES;
    
    self.valuetextLabel.hidden = YES;
    self.valueinfoLabel.hidden = YES;
    
    self.strAutoPlay = @"N";
    
//    [self.viewVideoArea removeConstraint:self.lconstViewVideoAreaRatio];
//    self.lconstViewVideoAreaRatio = [NSLayoutConstraint constraintWithItem:self.viewVideoArea
//                                                                  attribute:NSLayoutAttributeWidth
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:self.viewVideoArea
//                                                                  attribute:NSLayoutAttributeHeight
//                                                                 multiplier:(16.0/9.0)
//                                                                   constant:0];
//    [self.viewVideoArea addConstraint:self.lconstViewVideoAreaRatio];
    
    
    self.viewPGMArea.hidden = YES;
    self.lconstHeightPGMArea.constant = 0.0;
    self.imgPGM.image = nil;
    self.lblPGM.text = @"";
    self.btnPGM.accessibilityLabel = @"";
    self.gspricelabel_lmargin.constant = 30.0;
    
    self.imgThumbnail.image = nil;
    
    self.valuetextLabel.hidden = YES;
    self.valueinfoLabel.hidden = YES;
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
    self.productTitleLabel.text = @"";
    self.promotionNameLabel.text = @"";
    
    self.lconstPromotionLeading.constant = 0.0;
    self.viewShowProduct.hidden = YES;
}



- (void)mvPlayerDealloc {
    
    NSLog(@"mvPlayerDeallocmvPlayerDealloc");
    
    @try {
        
        if(self.BCPlaybackController != nil) {
            [self.BCPlaybackController pause];
            self.BCPlaybackController = nil;
        }
        if(self.BCPlayerView != nil) {
            [self.BCPlayerView removeFromSuperview];
            self.BCPlayerView = nil;
        }
        if (self.currentPlayer !=nil) {
            [self.currentPlayer pause];
            self.currentPlayer = nil;
        }
        
        
        [self showControllerIsMuteFullOnly:NO];
        self.lblLeftTime.text = NCS([self.dicRow objectForKey:@"videoTime"]);
        self.btnPlay.selected = NO;
        self.isPlaying = NO;
        self.isFullScreenPause = NO;
        
        self.view3GAlert.hidden = YES;
        self.btnDimms.hidden = NO;

        //self.imgThumbnail.hidden = NO;
        //self.imgThumbnail.alpha =1.0;
        self.viewMPlayerArea.alpha = 1.0;
        self.viewMPlayerArea.hidden = YES;
        self.viewBadge.hidden = NO;
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"exceptionexception = %@",exception);
    }
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    /*
     // 백그라운드 음악 재생
     NSError *error;
     [[AVAudioSession sharedInstance] setActive:NO
     withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
     error:&error];
     */

}

-(void)checkSoundStatus{
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
    
    if (self.currentPlayer != nil) {
        self.currentPlayer.muted = self.btnMute.selected;
    }
}

-(void)checkEndDisplayingCell{
    if(self.btnPlay.selected == YES) {
        [self sendWiseLogWithType:@"PAUSE"];
    }
    
    if (self.currentPlayer != nil) {
        [self stopMoviePlayer];
    }
    
}


-(void)setCellInfoNDrawData:(NSDictionary*) infoDic{

    NSMutableString *strAccess = [[NSMutableString alloc] initWithString:@""];
    
    //self.dicRow = self.dicRow;
    self.dicAll = infoDic;
    self.backgroundColor = [UIColor clearColor];

    
    if ([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"BAN_VOD_GBB"] || [[self.dicAll objectForKey:@"viewType"] isEqualToString:@"BAN_VOD_GBC"]) {
        self.imgThumbnail.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        self.imgThumbnail.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    if ([[infoDic objectForKey:@"subProductList"] count] > 1) {
        self.dicPGM = [[infoDic objectForKey:@"subProductList"] objectAtIndex:1];
        
        self.viewPGMArea.hidden = NO;
        self.lconstHeightPGMArea.constant = 45.0;
        NSString * productName = NCS([self.dicPGM objectForKey:@"productName"]);
        self.lblPGM.text = productName;
        if (productName.length > 0) {
            self.btnPGM.accessibilityLabel = [NSString stringWithFormat:@"%@으로 이동하기", productName];
        }
        self.strPGMImageUrl = NCS([self.dicPGM objectForKey:@"imageUrl"]);
        if([self.strPGMImageUrl length] > 0) {
            // 이미지 로딩
            [ImageDownManager blockImageDownWithURL:self.strPGMImageUrl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                if (error == nil  && [self.strPGMImageUrl isEqualToString:strInputURL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache) {
                            self.imgPGM.image = fetchedImage;
                        }
                        else {
                            self.imgPGM.alpha = 0;
                            self.imgPGM.image = fetchedImage;
                            
                            [UIView animateWithDuration:0.1f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.imgPGM.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        }//if else
                    });
                }//if
            }];
        }//if
        
    }else{
        self.dicPGM = nil;
    }
    
    if (NCA([infoDic objectForKey:@"subProductList"])) {
        self.dicRow = [[infoDic objectForKey:@"subProductList"] objectAtIndex:0];
    }else{
        return;
    }
    
    
    
    //if ([NCS([self.dicAll objectForKey:@"videoid"]) length] > 4) {
    self.btnPlay.alpha = 1.0;
    self.btnPlay.hidden = NO;
    self.viewDimmed.hidden = NO;
    //}
    
    
    self.lblLeftTime.text = NCS([self.dicRow objectForKey:@"videoTime"]);

    
    
    self.strPosterUrl =NCS([self.dicAll objectForKey:@"imageUrl"]);
    if([self.strPosterUrl length] > 0) {
        // 이미지 로딩
        [ImageDownManager blockImageDownWithURL:self.strPosterUrl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [self.strPosterUrl isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //self.imgPoster = fetchedImage;
                    
                    
                    
                    if ([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"BAN_VOD_GBB"] || [[self.dicAll objectForKey:@"viewType"] isEqualToString:@"BAN_VOD_GBC"]) {
                        
                        self.imgVerticalVideoBG.hidden = NO;
                        
                        if (fetchedImage.size.width > fetchedImage.size.height) {
                            self.imgThumbnail.contentMode = UIViewContentModeScaleAspectFill;
                        }else{
                            self.imgThumbnail.contentMode = UIViewContentModeScaleAspectFit;
                        }
                    }
                    
                    if (isInCache) {
                        self.imgThumbnail.image = fetchedImage;
                    }
                    else {
                        self.imgThumbnail.alpha = 0;
                        self.imgThumbnail.image = fetchedImage;
                        
                        [UIView animateWithDuration:0.1f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             self.imgThumbnail.alpha = 1;
                                         }
                                         completion:^(BOOL finished) {
                                         }];
                    }//if else
                });
            }//if
        }];
    }//if
    
    
    if(NCO([self.dicRow objectForKey:@"infoBadge"]) && NCA([[self.dicRow objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {
        
        if([(NSArray*)[[self.dicRow objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.dummytagTF1.hidden = NO;
            @try {
                self.dummytagTF1.text = (NSString*)NCS([ [ [ [self.dicRow objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
                
                [strAccess appendString:(NSString*)NCS([ [ [ [self.dicRow objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ])];
                
                if( [(NSString*)NCS([ [ [ [self.dicRow objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]) length] > 0){
                    self.dummytagTF1.textColor = [Mocha_Util getColor:(NSString*)[ [ [ [self.dicRow objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"exception = %@",exception);
            }
            self.producttitlelabel_lmargin.constant = 4;
        }
        else {
            self.dummytagTF1.hidden = YES;
            self.dummytagTF1.text = @"";
            self.producttitlelabel_lmargin.constant = 0;
        }
    }
    else {
        // nami0342 - NCA
        self.dummytagTF1.hidden = YES;
        self.dummytagTF1.text = @"";
        self.producttitlelabel_lmargin.constant = 0;
    }
    
    if(NCO([self.dicRow objectForKey:@"directOrdInfo"])) {
        
        self.view_dorder.hidden = NO;
        if ([NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"text"]) length] > 0 ) {
            self.btn_dordertxt.text = [[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"text"];
            if([self.btn_dordertxt.text isEqualToString:@"구매하기"] == YES) {
                [self.btn_dorder setAccessibilityLabel:@"현재 생방송중인 상품 구매하기"];
            }
        }
        
        self.view_dorder.layer.cornerRadius = 15.0;
        self.view_dorder.layer.shouldRasterize = YES;
        self.view_dorder.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }else{
        self.view_dorder.hidden = YES;
    }
    
    self.productTitleLabel.text = NCS([self.dicRow objectForKey:@"productName"]);
    self.promotionNameLabel.text = NCS([self.dicRow objectForKey:@"promotionName"]);
    [strAccess appendString:NCS([self.dicRow objectForKey:@"productName"])];
    
    // 할인율 / GS가
    NSString *removeCommadrstr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",NCS([self.dicRow objectForKey:@"discountRate"])] ];
    
    if([NCS([self.dicRow objectForKey:@"discountRateText"])  length] > 0 ) {
//        if ([NCS([self.dicRow objectForKey:@"discountRateText"]) isEqualToString:@"GS가"]) {
//            //self.gsLabelView.hidden = NO;
//            self.extLabel.hidden = YES;
//            self.discountRateLabel.hidden = YES;
//            self.gspricelabel_lmargin.constant = 60;
//        }
//        else {
            //self.gsLabelView.hidden = YES;
            self.extLabel.text = NCS([self.dicRow objectForKey:@"discountRateText"]);
            self.extLabel.hidden = NO;
            self.discountRateLabel.hidden = YES;
//        }
    }
    else if([Common_Util isThisValidWithZeroStr:removeCommadrstr] == YES) {
        //확인이 필요하다.
        if(NCO([self.dicRow objectForKey:@"discountRate"])) {
            int discountRate = [(NSNumber *)[self.dicRow objectForKey:@"discountRate"] intValue];
            /*
            if(discountRate < 5) {
                //할인비율0 이면 GS가로 변경
                //self.gsLabelView.hidden = NO;
                self.extLabel.hidden = YES;
                self.discountRateLabel.hidden = YES;
                self.discountRatePercentLabel.hidden = YES;
                self.gspricelabel_lmargin.constant = 60;
            }
            else {
                
                self.discountRateLabel.text = [NSString stringWithFormat:@"%d", discountRate];
                self.discountRateLabel.hidden = NO;
                self.discountRatePercentLabel.hidden = NO;
                //float disratelabelsize = [self.discountRateLabel sizeThatFits:discountRateLabel.frame.size].width + [self.discountRatePercentLabel sizeThatFits:discountRatePercentLabel.frame.size].width;
                //self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN+disratelabelsize+kCELLCONTENTSBETWEENMARGIN;
                //self.gsLabelView.hidden = YES;
                self.extLabel.hidden = YES;
            }
            */
            
            if (discountRate > 0) {
                self.discountRateLabel.hidden = NO;
                self.discountRateLabel.text = [NSString stringWithFormat:@"%d%%", discountRate];
                //self.lconstLblDiscountLeading.constant = 12.0;
                
                float disratelabelsize = [self.discountRateLabel sizeThatFits:self.discountRateLabel.frame.size].width;
                self.gspricelabel_lmargin.constant =  kLEFTMARGIN+disratelabelsize+kBETWEENMARGIN;
                
            }else{
            
                //self.lconstLblDiscountLeading.constant = 6.0;
                self.gspricelabel_lmargin.constant =  kLEFTMARGIN;
                self.discountRateLabel.hidden = YES;
                //self.gsLabelView.hidden = YES;
                self.extLabel.hidden = YES;
            }
            
        }
        else {
            //전체 뷰히든
            //20160630 parksegun discountRate값이 nil이면 해당 영역을 숨긴다.
            self.discountRateLabel.hidden = YES;
            //self.gsLabelView.hidden = YES;
            self.extLabel.hidden = YES;
        }
        
    }
    else {
        //전체 뷰히든
        self.discountRateLabel.hidden = YES;
        //self.gsLabelView.hidden = YES;
        self.extLabel.hidden = YES;
    }
    
    
    
    
    //valueText
    if([NCS([self.dicRow objectForKey:@"valueText"])  length] > 0 ) {
        //self.gsLabelView.hidden = YES;
        self.extLabel.hidden = YES;
        self.discountRateLabel.hidden = YES;
        self.valuetextLabel.text = [self.dicRow objectForKey:@"valueText"];
        CGSize vtlabelsize = [self.valuetextLabel sizeThatFits:self.valuetextLabel.frame.size];
        self.gspricelabel_lmargin.constant =  kLEFTMARGIN+vtlabelsize.width+kBETWEENMARGIN;
        self.valuetextLabel.hidden = NO;
    }
    else {
        self.valuetextLabel.text = @"";
        self.valuetextLabel.hidden = YES;
    }
    
    
    //valueInfo
    if([NCS([self.dicRow objectForKey:@"valueInfo"])  length] > 0 ) {
        self.valueinfoLabel.hidden = NO;
        self.valueinfoLabel.text = [self.dicRow objectForKey:@"valueInfo"];
        self.valueinfolabel_lmargin.constant = 7;
    }
    else {
        self.valueinfoLabel.text = @"";
        self.valueinfoLabel.hidden = YES;
        self.valueinfolabel_lmargin.constant = 0;
    }
    
    
    int salePrice = 0;
    
    if(NCO([self.dicRow objectForKey:@"salePrice"])) {
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[self.dicRow objectForKey:@"salePrice"]]      ];
        
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES) {
            salePrice = [(NSNumber *)removeCommaspricestr intValue];
            self.gsPriceLabel.text = [Common_Util commaStringFromDecimal:salePrice];
            self.gsPriceWonLabel.text  =  NCS([self.dicRow objectForKey:@"exposePriceText"]);
            self.gsPriceLabel.hidden = NO;
            self.gsPriceWonLabel.hidden = NO;
            
            [strAccess appendString:[Common_Util commaStringFromDecimal:salePrice]];
            [strAccess appendString:NCS([self.dicRow objectForKey:@"exposePriceText"])];
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
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([self.dicRow objectForKey:@"basePrice"])];
    int basePrice = [(NSNumber *)removeCommaorgstr intValue];
    if (basePrice > 0 && basePrice > salePrice) {
        
        self.originalPriceLabel.text = [Common_Util commaStringFromDecimal:basePrice];
        self.originalPriceWonLabel.text = NCS([self.dicRow objectForKey:@"exposePriceText"]);
        self.originalPriceLabel.hidden = NO;
        self.originalPriceWonLabel.hidden = NO;
        self.originalPriceLine.hidden = NO;
        self.originalPricelabel_lmargin.constant = 5;
        //self.originalPricelabel_rmargin.constant = 8;
        
    }
    else {
        self.originalPriceLabel.text = @"";
        self.originalPriceWonLabel.text = @"";
        self.originalPriceLabel.hidden = YES;
        self.originalPriceWonLabel.hidden = YES;
        self.originalPriceLine.hidden = YES;
        self.originalPricelabel_lmargin.constant = 0;
        //self.originalPricelabel_rmargin.constant = 0;
        
        /*
        if([NCS([self.dicRow objectForKey:@"valueInfo"])  length] > 1 ) {
            self.originalPricelabel_rmargin.constant = 0;
        }
        else {
            self.originalPricelabel_rmargin.constant = 8;
        }
         */
    }
    
    if([NCS([self.dicAll objectForKey:@"cateGb"]) isEqualToString:@"LIVE"]) {
        self.imgTagLive.hidden = NO;
        self.imgTagMyShop.hidden = YES;
        self.lconstPromotionLeading.constant = 113.0;
    }
    else if([NCS([self.dicAll objectForKey:@"cateGb"]) isEqualToString:@"DATA"]) {
        self.imgTagLive.hidden = YES;
        self.imgTagMyShop.hidden = NO;
        self.lconstPromotionLeading.constant = 100.0;
    }
    else {
        self.imgTagLive.hidden = YES;
        self.imgTagMyShop.hidden = YES;
        self.lconstPromotionLeading.constant = 10.0;
    }
    
    
    if (APPFULLWIDTH <= 320) {
        self.saleSaleLabel.hidden = YES;
        self.saleCountLabel.hidden = YES;
        self.saleSaleSubLabel.hidden = YES;
        self.lcontPromotionRmargin.constant = 10.0;
        
    }else{
     
        //3열 판매수량
        if(NCO([self.dicRow objectForKey:@"saleQuantity"])) {
            NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([self.dicRow objectForKey:@"saleQuantity"])];
            //숫자가 맞음
            if( [Common_Util isThisValidNumberStr:removeCommaorgstr]) {
                self.saleCountLabel.text = [NSString stringWithFormat:@"%@", NCS([self.dicRow objectForKey:@"saleQuantity"]) ];
                self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", NCS([self.dicRow objectForKey:@"saleQuantityText"]) ];
                self.saleSaleSubLabel.text = [NSString stringWithFormat:@"%@", NCS([self.dicRow objectForKey:@"saleQuantitySubText"]) ];
                self.saleCountLabel.hidden = NO;
                self.saleSaleLabel.hidden = NO;
                self.saleSaleSubLabel.hidden = NO;
                self.salesalelabel_width.constant = 50;
                
            }
            //숫자아니거나 0일때 수량text 존재함
            else if( [NCS([self.dicRow objectForKey:@"saleQuantityText"]) length] > 0) {
                self.saleCountLabel.hidden = YES;
                self.saleSaleSubLabel.hidden = YES;
                self.saleSaleLabel.hidden = NO;
                self.salesalelabel_width.constant = 10;
                self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", [self.dicRow objectForKey:@"saleQuantityText"] ];
            }
            else {
                //숫자가 아니거나 0인경우 사라짐
                self.saleCountLabel.hidden = YES;
                self.saleSaleLabel.hidden =YES;
                self.saleSaleSubLabel.hidden = YES;
            }
        }
    }
    
    
    
    self.imgRightTag01.image = nil;
    self.imgRightTag02.image = nil;
    self.imgRightTag03.image = nil;
    
    if(NCA([self.dicRow objectForKey:@"rwImgList"]) == YES) {
        
        NSArray *arrTagImage = [self.dicRow objectForKey:@"rwImgList"];
        if([NCS([arrTagImage objectAtIndex:0]) length] > 0) {
            self.imageTagURL01 = NCS([arrTagImage objectAtIndex:0]);
            [ImageDownManager blockImageDownWithURL:self.imageTagURL01 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil  && [self.imageTagURL01 isEqualToString:strInputURL]) {
                        
                        if(isInCache) {
                            self.imgRightTag01.image = fetchedImage;
                        }
                        else {
                            self.imgRightTag01.alpha = 0;
                            self.imgRightTag01.image = fetchedImage;
                        }
                        
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             self.imgRightTag01.alpha = 1;
                                         }
                                         completion:^(BOOL finished) {
                                         }];
                    }
                });
            }];
        }else{
            self.imgRightTag01.image = nil;
        }
        
        
        if([arrTagImage count] > 1) {
            if([NCS([arrTagImage objectAtIndex:1]) length] > 0) {
                self.imageTagURL02 = NCS([arrTagImage objectAtIndex:1]);
                [ImageDownManager blockImageDownWithURL:self.imageTagURL02 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.imageTagURL02 isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if(isInCache) {
                                self.imgRightTag02.image = fetchedImage;
                            }
                            else {
                                self.imgRightTag02.alpha = 0;
                                self.imgRightTag02.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.imgRightTag02.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        });
                    }
                }];
            }
        }else{
            self.imgRightTag02.image = nil;
        }
        
        if([arrTagImage count] > 2) {
            if([NCS([arrTagImage objectAtIndex:2]) length] > 0) {
                self.imageTagURL03 = NCS([arrTagImage objectAtIndex:2]);
                [ImageDownManager blockImageDownWithURL:self.imageTagURL03 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.imageTagURL03 isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if(isInCache) {
                                self.imgRightTag03.image = fetchedImage;
                            }
                            else {
                                self.imgRightTag03.alpha = 0;
                                self.imgRightTag03.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.imgRightTag03.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        });
                    }
                }];
            }
        }else{
            self.imgRightTag03.image = nil;
        }
    }
    
    
    if ([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"BAN_VOD_GBB"] || [[self.dicAll objectForKey:@"viewType"] isEqualToString:@"BAN_VOD_GBC"]) {
        //self.imgVerticalVideoBG.hidden = NO;
//        [self.viewVideoArea removeConstraint:self.lconstViewVideoAreaRatio];
//        double heightImageArea = round((APPFULLWIDTH*0.4)*(16.0/9.0));
//
//        self.lconstViewVideoAreaRatio = [NSLayoutConstraint constraintWithItem:self.viewVideoArea
//                                                                     attribute:NSLayoutAttributeWidth
//                                                                     relatedBy:NSLayoutRelationEqual
//                                                                        toItem:self.viewVideoArea
//                                                                     attribute:NSLayoutAttributeHeight
//                                                                    multiplier:(APPFULLWIDTH/heightImageArea)
//                                                                      constant:0];
//        [self.viewVideoArea addConstraint:self.lconstViewVideoAreaRatio];
    }
    
    [self checkSoundStatus];
    self.btnPriceArea.accessibilityLabel = strAccess;
    [self.view_Default layoutIfNeeded];
    
}

-(void)setVODStatusDefault{
    
    if([self.target respondsToSelector:@selector(setIndexPathForVODPlaying: andStatus:)]){
        [self.target setIndexPathForVODPlaying:self.path andStatus:VODVIEW_CLOSE];
    }
}

#pragma mark - IBAction
-(IBAction)onBtnPriceArea:(id)sender{
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_VODVIDEOALLKILL object:nil userInfo:nil];
    
    if ([self.target respondsToSelector:@selector(touchEventDealCell:)]) {
        [self.target touchEventDealCell:self.dicRow];
    }
    //상품 보기 
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00492-V-PRD")];
    
    if ( sender != nil ) {
        if ([((UIButton *)sender) tag] == 38) {
            [self sendAmplitudeWithType:TOMORROW_TV_FULL_PRD_CLICK];
        }else{
            [self sendAmplitudeWithType:TOMORROW_TV_LIST_PRD_CLICK];
        }
    }
}

-(IBAction)onBtnPGMArea:(id)sender {
    if ([self.target respondsToSelector:@selector(touchEventDealCell:)]) {
        [self.target touchEventDealCell:self.dicPGM];
    }
}

-(IBAction)onBtnMute:(id)sender {
    [self.currentPlayer setMuted:!self.btnMute.selected];
    self.btnMute.selected = !self.btnMute.selected;
    
    if (self.btnMute.selected == YES) {
        [self sendWiseLogWithType:@"SOUND_OFF"];
        [[DataManager sharedManager] setStrGlobalSound:@"N"];
    }else{
        [self sendWiseLogWithType:@"SOUND_ON"];
        [[DataManager sharedManager] setStrGlobalSound:@"Y"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GS_GLOBAL_SOUND_CHANGE object:nil userInfo:nil];
}

- (IBAction)onBtnMoviePlay:(id)sender {
    
    self.view3GAlert.hidden = YES;
    self.btnDimms.hidden = NO;
    
    if(self.btnPlay.selected == NO){
        self.strAutoPlay = @"N";
        if(self.currentPlayer != nil) {
            if([NetworkManager.shared currentReachabilityStatus] != NetworkReachabilityStatusViaWiFi) {
                if ([[DataManager sharedManager].strGlobal3GAgree isEqualToString:@"N"]) {
                    self.view3GAlert.hidden = NO;
                    self.btnDimms.hidden = YES;
                    self.btn3GAlertConfirm.tag = 888;
                    [self hideController];
                    return;
                }
            }

            [self playMovieWithNotice];
            

            [self viewDimmedShow:NO afterViewHide:NO];
        }
        else {
            [self playMoviePlayer:nil];
        }
    }
    else {
        if (self.viewMPlayerArea.hidden == NO) {
            [self.currentPlayer pause];
            self.btnPlay.selected = NO;
        }
    }
}

-(void)playMovieWithNotice{
    
    self.btnPlay.hidden = YES;
    [self.btnPlay setImage:[UIImage imageNamed:@"vod_shop_icPlayRound.png"] forState:UIControlStateNormal];
    self.btnPlay.selected = YES;
    
    if([self.target respondsToSelector:@selector(setIndexPathForVODPlaying: andStatus:)]){
        [self.target setIndexPathForVODPlaying:self.path andStatus:VODVIEW_OPEN];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_VODVIDEOPAUSE_NOTME object:nil userInfo:nil];
    
    [self.currentPlayer play];
}


- (IBAction)onBtn3GAlert:(id)sender {
    if ([((UIButton *)sender) tag] == 888) {
        self.view3GAlert.hidden = YES;
        self.btnDimms.hidden = NO;
        [DataManager sharedManager].strGlobal3GAgree = @"Y";
        [self sendWiseLogWithType:@"LTE_Y"];
        
        if(self.currentPlayer != nil) {
            [self playMovieWithNotice];
            [self viewDimmedShow:NO afterViewHide:NO];
        }else {
            [self playBrightCoveWithID:NCS([self.dicAll objectForKey:@"videoid"])];
        }
    }
    else {
        [self sendWiseLogWithType:@"LTE_N"];
        self.view3GAlert.hidden = YES;
        self.btnDimms.hidden = NO;
        [self showControllerIsMuteFullOnly:NO];
    }
}

- (IBAction)onBtnMovieScreenBtn:(id)sender {
    NSLog(@"");
    
    if([((UIButton *)sender) tag] == 3011) {
        
        //[self mvPlayerPause];
        
//        [self sendWiseLogWithType:@"EXIT"];
//        self.isVODExit = YES;
//        [self viewDimmedShow:NO afterViewHide:YES];

        [self setVODStatusDefault];
        
        
        //바로구매
        if(NCO([self.dicRow objectForKey:@"directOrdInfo"])) {
            if (NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"linkUrl"]) && [[[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"linkUrl"] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                
                NSString *linkstr = [[[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"linkUrl"] substringFromIndex:11];
                NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                //[self.tableView setContentOffset:CGPointMake(0.0, tableheaderBANNERheight + tableheaderListheight) animated:YES];
                [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
            }
            else {
                NSString *linkstr = [[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"linkUrl"];
                
                if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                    [self.target touchEventDualPlayerJustLinkStr:linkstr];
                }
                
            }
            
        }
        else {
            
            if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                [self.target touchEventDualPlayerJustLinkStr: [self.dicRow objectForKey:@"rightNowBuyUrl"] ];
            }
            
        }
        
    }else if([((UIButton *)sender) tag] == 4000) {
        
        self.isFullScreenPause = YES;
        [self sendWiseLogWithType:@"FULL"];

        @try {
            if([[[ApplicationDelegate.mainNVC viewControllers] objectAtIndex:0] isKindOfClass:[Home_Main_ViewController class]]) {
                [self requestFullVideo:NCS([self.dicAll objectForKey:@"videoid"])];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception at Searching Home_Main_ViewController : %@", exception);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_VODVIDEOPAUSE object:nil userInfo:nil];
        //[self mvPlayerPause];
        
    }else if([((UIButton *)sender) tag] == 4004) {
        [self sendWiseLogWithType:@"EXIT"];
        self.isVODExit = YES;
        [self viewDimmedShow:NO afterViewHide:YES];
    }
}



- (IBAction)onBtnMovieScreen:(id)sender {
    if (self.viewMPlayerArea.hidden == NO) {
        if (self.viewDimmed.alpha == 0.0) {
            [self viewDimmedShow:YES afterViewHide:NO];
        }
        else {
            [self viewDimmedShow:NO afterViewHide:NO];
        }
    }
    else {
        // 20190814 MC 내일TV 플레이어영역 PLAY 터치 영역 확대
        // 홈 라이브, 마이샵 과 동일하게 섬네일일때 딤 눌러도 플레이되도록 변경
        [self onBtnMoviePlay:nil];
    }
}


#pragma mark Class Methods

-(void)goWebView:(NSString *)url{
    if ([NCS(url) length] > 0) {
        [ApplicationDelegate.HMV goWebView:url];
    }
    
}

-(void)sendWiseLogWithType:(NSString *)strCase{
    
    NSArray *arrPt = [self.lblLeftTime.text componentsSeparatedByString:@":"];
    NSArray *arrTt = [NCS([self.dicRow objectForKey:@"videoTime"]) componentsSeparatedByString:@":"];
    
    
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
    
    NSString *strPlayTime = [NSString stringWithFormat:@"%ld",(long)intTT-(long)intPT];
    NSString *strTotalTime = [NSString stringWithFormat:@"%ld",(long)intTT];
    NSString *strPrdid =  NCS([self.dicRow objectForKey:@"dealNo"]);
    
    NSString *strLog = [NSString stringWithFormat:@"?vid=%@&autoplay=%@&bhrGbn=bcPlayer_%@&pt=%@&tt=%@&prdid=%@&mseq=A00492-V-CTL",NCS([self.dicAll objectForKey:@"videoid"]),self.strAutoPlay,strCase,strPlayTime,strTotalTime,strPrdid];
    
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(strLog)];
    
}

- (void)mvPlayerPause{
    
    self.view3GAlert.hidden = YES;
    self.btnDimms.hidden = NO;
    if (self.currentPlayer != nil) {
        self.btnPlay.selected = NO;
        [self.currentPlayer pause];
        [self viewDimmedShow:YES afterViewHide:NO];
    }else{
        
        [self showControllerIsMuteFullOnly:NO];
    }
}


- (void)mvPlayerAutoPlayPause{
    
    self.view3GAlert.hidden = YES;
    self.btnDimms.hidden = NO;
    
    if ([self.target isKindOfClass:[VODListTableViewController class]]) {
        VODListTableViewController* VTVC = (VODListTableViewController*)self.target;
        if (self.path != VTVC.pathVODPlaying) {

            if (self.currentPlayer != nil) {
                self.btnPlay.selected = NO;
                [self.currentPlayer pause];
                [self viewDimmedShow:YES afterViewHide:NO];
                //NSLog(@"self.pathself.path = %@",self.path);
            }else{
                
                [self showControllerIsMuteFullOnly:NO];
                //NSLog(@"self.pathself.path = %@",self.path);
            }
        }else{
            //NSLog(@"self.pathself.path = %@",self.path);
        }
    }
}


- (void)mvPlayerBackGroundPause{
    //self.isEnterBackGround = YES;
    [self mvPlayerPause];
}

- (void)stopMoviePlayer {

    [self showControllerIsMuteFullOnly:NO];
    
    self.isPlaying = NO;
    [self.btnPlay setImage:[UIImage imageNamed:@"vod_shop_icPlayRound.png"] forState:UIControlStateNormal];
    self.btnPlay.selected = NO;
    self.btnPlay.hidden = NO;
    
    self.imgThumbnail.hidden = NO;
    self.view3GAlert.hidden = YES;
    self.btnDimms.hidden = NO;
    self.viewDimmed.alpha = 0.0;
    self.viewMPlayerArea.hidden = YES;
    self.viewMPlayerArea.alpha = 1.0;
    self.viewBadge.hidden = NO;
    
    self.lblLeftTime.text = NCS([self.dicRow objectForKey:@"videoTime"]);
    
    
    
    [self mvPlayerDealloc];
}


- (void)playMoviePlayer:(id)sender {

    if([NetworkManager.shared currentReachabilityStatus] != NetworkReachabilityStatusViaWiFi) {
        if ([[DataManager sharedManager].strGlobal3GAgree isEqualToString:@"N"]) {
            self.view3GAlert.hidden = NO;
            self.btn3GAlertConfirm.tag = 888;
            
            [self hideController];
            return;
        }
    }
    
    
    self.btnPlay.hidden = YES;
    self.btnPlay.selected = YES;

    if(self.currentPlayer != nil) {
        [self playMovieWithNotice];
        [self viewDimmedShow:NO afterViewHide:NO];
    }
    else {
        
        self.btnPlay.hidden = YES;
        [self.btnPlay setImage:[UIImage imageNamed:@"vod_shop_icPlayRound.png"] forState:UIControlStateNormal];
        self.btnPlay.selected = YES;
        [self setVODStatusDefault];
        
        [self playBrightCoveWithID:NCS([self.dicAll objectForKey:@"videoid"])];
        
        [self sendAmplitudeWithType:TOMORROW_TV_BUTTONPLAY];
    }
}

- (void)sendAmplitudeWithType:(TOMORROW_TV_AMP_SEND_TYPE)ampType{
    
    NSMutableDictionary *dicProp = [[NSMutableDictionary alloc] init];
    [dicProp setObject:NCS([self.dicAll objectForKey:@"videoid"]) forKey:@"videoId"];
    [dicProp setObject:NCS([self.dicRow objectForKey:@"dealNo"]) forKey:@"prdCd"];

    if (ampType == TOMORROW_TV_BUTTONPLAY) {
        [dicProp setObject:@"재생시작" forKey:@"action"];
        [dicProp setObject:NCS([self.dicRow objectForKey:@"productName"]) forKey:@"prdNm"];
        [dicProp setObject:NCS([self.dicAll objectForKey:@"videoTime"]) forKey:@"duration"];
    }else if(ampType == TOMORROW_TV_LIST_PRD_CLICK){
        [dicProp setObject:@"리스트상품클릭" forKey:@"action"];
        [dicProp setObject:NCS([self.dicRow objectForKey:@"productName"]) forKey:@"prdNm"];
        [dicProp setObject:NCS([self.dicRow objectForKey:@"salePrice"]) forKey:@"price"];
        [dicProp setObject:NCS([self.dicAll objectForKey:@"videoTime"]) forKey:@"duration"];
    }else if (ampType == TOMORROW_TV_FULL_PRD_CLICK){
        [dicProp setObject:@"전체보기상품클릭" forKey:@"action"];
    }
    //NSLog(@"dicPropdicProp = %@",dicProp)
    [ApplicationDelegate setAmplitudeEventWithProperties:@"Click-메인매장-내일TV" properties:dicProp];
}

- (void)requestFullVideo: (NSString*)videoID {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    
    NSString *strReqURL = [NSString stringWithFormat:@"toapp://dealvod?url=%@&targeturl=%@&videoid=%@",[self.dicAll objectForKey:@"dealMcVideoUrlAddr"],[self.dicRow objectForKey:@"linkUrl"],videoID];
    
    Mocha_MPViewController *VCPlayer = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:strReqURL];
    VCPlayer.isMuteStart = self.btnMute.selected;
    VCPlayer.modalPresentationStyle =UIModalPresentationOverFullScreen;
    
    if (CMTimeGetSeconds(self.currentPlayer.currentItem.currentTime) > 0.0) {
        
        VCPlayer.timeStart = CMTimeGetSeconds(self.currentPlayer.currentItem.currentTime);
    }
    
    if ([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"BAN_VOD_GBB"] || [[self.dicAll objectForKey:@"viewType"] isEqualToString:@"BAN_VOD_GBC"]) {
        VCPlayer.isLandScapeOnly = NO;
    }else{
        VCPlayer.isLandScapeOnly = YES;
    }
    
    VCPlayer.isAutoStart = self.btnPlay.selected;
    
    if (self.imgPoster != nil) {
        VCPlayer.imgPoster = self.imgPoster;
    }
    
    if ([NCS([self.dicRow objectForKey:@"imageUrl"]) length] > 0) {
        VCPlayer.strPrdImageURL = NCS([self.dicRow objectForKey:@"imageUrl"]);
    }
    
    if ([NCS([self.dicRow objectForKey:@"dealNo"]) length] > 0) {
        VCPlayer.strDealNo = NCS([self.dicRow objectForKey:@"dealNo"]);
    }
    
    [ApplicationDelegate.window.rootViewController presentViewController:VCPlayer animated:YES completion:^{
    }];
    
    [VCPlayer playBrightCoveWithID:videoID];
    
}



- (NSString *)formatTime:(NSTimeInterval)timeInterval
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
    
    if (hours > 0) {
        minutes = minutes + (hours*60);
    }
    
    NSString *formattedMinutes = [numberFormatter stringFromNumber:@(minutes)];
    NSString *formattedSeconds = [numberFormatter stringFromNumber:@(seconds)];
    
    NSString *ret = nil;
    ret = [NSString stringWithFormat:@"%@:%@", formattedMinutes, formattedSeconds];
    
    return ret;
}

-(NSString*)getStringFromCMTime:(CMTime)time {
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}


-(void)showControllerIsMuteFullOnly:(BOOL)isMuteFullOnly{
    
    if (isMuteFullOnly) {
        if (self.currentPlayer != nil) {
            self.btnMute.hidden = NO;
            self.btnFullMovie.hidden = NO;
        }else{
            self.btnMute.hidden = YES;
            self.btnFullMovie.hidden = YES;
        }
        
        self.btnMute.hidden = NO;
        self.btnFullMovie.hidden = NO;
        
        NSLog(@"");
        self.btnPlay.hidden = YES;
        self.lblLeftTime.hidden = YES;
        self.viewShowProduct.hidden = YES;
        self.btnDimmClose.hidden = YES;
    }else{
        NSLog(@"");
        self.btnPlay.hidden = NO;
        self.lblLeftTime.hidden = NO;
        
        
        if (self.currentPlayer != nil) {
            self.viewShowProduct.hidden = NO;
            self.btnMute.hidden = NO;
            self.btnFullMovie.hidden = NO;
            self.btnDimmClose.hidden = NO;
        }else{
            
            if ([self.btnPlay.imageView.image isEqual:[UIImage imageNamed:@"vod_shop_new_icReplay.png"]]) {
                self.viewShowProduct.hidden = NO;
                self.btnMute.hidden = NO;
                self.btnFullMovie.hidden = NO;
                self.btnDimmClose.hidden = NO;
            }else{
                self.viewShowProduct.hidden = YES;
                self.btnMute.hidden = YES;
                self.btnFullMovie.hidden = YES;
                self.btnDimmClose.hidden = YES;
            }
            
            
        }
        
    }
}

-(void)hideController{
    
    self.btnMute.hidden = YES;
    self.btnFullMovie.hidden = YES;
    self.btnPlay.hidden = YES;
    self.lblLeftTime.hidden = YES;
    self.viewShowProduct.hidden = YES;
}

- (void) HudTryHidden {
    if (self.isPlaying == YES) {
        [self viewDimmedShow:NO afterViewHide:NO];
    }
}

- (void)viewDimmedShow:(BOOL)isShow afterViewHide:(BOOL)isViewHide {
    
    CGFloat alphaModifier = 0.0;
    CGFloat alphaModifierBtn = 1.0;
    
    self.view3GAlert.hidden = YES;
    self.btnDimms.hidden = NO;
    
    if(isShow) {
        alphaModifier = 1.0;
        alphaModifierBtn = 0.0;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(HudTryHidden) object:nil];
        [self performSelector:@selector(HudTryHidden) withObject:nil afterDelay:2.5f inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
    }
    
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.viewDimmed.alpha = alphaModifier;
                     }
     
                     completion:^(BOOL finished) {
                         
                         if (isViewHide) {
                             
                             [self.currentPlayer pause];
                             [self stopMoviePlayer];
                             [self setVODStatusDefault];
                             
                         }else{
                            [self showControllerIsMuteFullOnly:!isShow];
                         }
                     }];
}


#pragma mark - BCOVPlaybackControllerDelegate

- (void)playbackController:(id<BCOVPlaybackController>)controller didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session
{
    self.currentPlayer = session.player;
    [self checkSoundStatus];
}

#pragma mark BCOVPlaybackSession Delegate

- (void)didAdvanceToPlaybackSession:(id<BCOVPlaybackSession>)session
{
    
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didChangeDuration:(NSTimeInterval)duration
{
    self.durTotal = duration;
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didProgressTo:(NSTimeInterval)progress
{
    
    if (self.isPlaying == YES && self.durTotal > 0) {
        self.lblLeftTime.text = [self formatTime:self.durTotal-progress];
    }
    
    NSLog(@"self.lblLeftTime.text = %@",self.lblLeftTime.text);
    NSLog(@"progress = %f",progress);
    
    
    if (progress > 1.0 && self.viewMPlayerArea.hidden == YES && self.currentPlayer != nil && [self.lblLeftTime.text isEqualToString:@"00:00"] == NO) {
        self.viewMPlayerArea.hidden = NO;
        self.imgThumbnail.hidden = YES;
        
        if (self.viewBadge.hidden == NO) {
            self.viewBadge.hidden = YES;
        }
        
        [self showControllerIsMuteFullOnly:YES];
    }
    
}

- (void)playbackSession:(id<BCOVPlaybackSession>)session didReceiveLifecycleEvent:(BCOVPlaybackSessionLifecycleEvent *)lifecycleEvent
{
    if ([kBCOVPlaybackSessionLifecycleEventPlay isEqualToString:lifecycleEvent.eventType])
    {

        //self.imgThumbnail.hidden = YES;
        self.isPlaying = YES;
        self.isFullScreenPause = NO;
        
        [self sendWiseLogWithType:@"PLAY"];
        self.isVODExit = NO;
        NSLog(@"11111 self.pathself.path = %@",self.path);

    }
    else if([kBCOVPlaybackSessionLifecycleEventReady isEqualToString:lifecycleEvent.eventType])
    {
        
        if([self.target respondsToSelector:@selector(setIndexPathForVODPlaying: andStatus:)]){
            [self.target setIndexPathForVODPlaying:self.path andStatus:VODVIEW_OPEN];
        }
        
        self.BCPlayerView.center = self.viewMPlayerArea.center;
        
        NSLog(@"kBCOVPlaybackSessionLifecycleEventReady");

        self.btnPlay.hidden = YES;
        self.btnPlay.selected = YES;
        [self.btnPlay setImage:[UIImage imageNamed:@"vod_shop_icPlayRound.png"] forState:UIControlStateNormal];
        self.viewMPlayerArea.hidden = NO;
        self.viewBadge.hidden = YES;
        //[self showThumbImageArea:NO];
        self.imgThumbnail.hidden = YES;
        
        [self showControllerIsMuteFullOnly:YES];
        
    }
    else if([kBCOVPlaybackSessionLifecycleEventPause isEqualToString:lifecycleEvent.eventType])
    {
        self.isPlaying = NO;
        if (self.isVODExit == NO) {
            [self sendWiseLogWithType:@"PAUSE"];
        }

    }else if([kBCOVPlaybackSessionLifecycleEventEnd isEqualToString:lifecycleEvent.eventType])
    {

        [self.currentPlayer pause];
        
        self.isPlaying = NO;
        
        self.lblLeftTime.text = @"00:00";//NCS([self.dicRow objectForKey:@"videoTime"]);
        self.btnPlay.selected = NO;
        NSLog(@"");
        self.btnPlay.hidden = NO;
        [self.btnPlay setImage:[UIImage imageNamed:@"vod_shop_new_icReplay.png"] forState:UIControlStateNormal];
        
        self.viewImageDimm.alpha = 0.2;
        //[self showThumbImageArea:YES];
        self.viewMPlayerArea.hidden = YES;
        self.viewBadge.hidden = YES;
        self.imgThumbnail.hidden = NO;
        [self showControllerIsMuteFullOnly:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(playerTimeReset) userInfo:nil repeats:NO];

    }
}


-(void)playBrightCoveWithID:(NSString *)strVideoID{
    
    if(self.BCPlayerView !=nil) {
        [self mvPlayerDealloc];
    }
    @try {
        
        self.imgVerticalVideoBG.hidden = NO;
        
        BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
        self.BCPlaybackController = [manager createPlaybackControllerWithViewStrategy:nil];
        self.BCPlaybackController.delegate = self;
        self.BCPlaybackController.autoAdvance = YES;
        self.BCPlaybackController.autoPlay = YES;
        [self.BCPlaybackController setAllowsExternalPlayback:YES];
        [self.BCPlaybackController addSessionConsumer:(id)self];
        
        self.BCPlayerView = [[BCOVPUIPlayerView alloc] initWithPlaybackController:self.BCPlaybackController options:nil controlsView:nil ];
        self.BCPlayerView.delegate = self;
        
        if ([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"BAN_VOD_GBB"]) {
            self.BCPlayerView.frame = CGRectMake(0.0, 0.0, floor(self.fixedWidth*0.4), round((self.fixedWidth)*0.4)*(16.0/9.0) +2.0);
        }else if ([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"BAN_VOD_GBC"]) {
            CGFloat widthRect = round((self.fixedWidth)*0.4)*(16.0/9.0);
            self.BCPlayerView.frame = CGRectMake(0.0, 0.0, widthRect,widthRect);
        }else{
            self.BCPlayerView.frame = CGRectMake(0.0, 0.0, floor(self.fixedWidth-20), round((self.fixedWidth-20)*(9.0/16.0)));
        }
        
        NSLog(@"self.BCPlayerView.frame = %@",NSStringFromCGRect(self.BCPlayerView.frame));
        
        self.BCPlaybackService = [[BCOVPlaybackService alloc] initWithAccountId:BRIGHTCOVE_ACCOUNTID policyKey:BRIGHTCOVE_POLICY_KEY];
        [self.viewMPlayerArea insertSubview:self.BCPlayerView atIndex:0];
        self.BCPlayerView.center = self.viewMPlayerArea.center;
        
        [self viewDimmedShow:NO afterViewHide:NO];

        [self requestContentFromPlaybackService:strVideoID];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
}

- (void)requestContentFromPlaybackService:(NSString *)strKey {
    [self.BCPlaybackService findVideoWithVideoID:strKey parameters:nil completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {
        NSLog(@"jsonResponse = %@",jsonResponse);
        if (video) {
            if (self.BCPlaybackController != nil) {
                [self.BCPlaybackController setVideos:@[ video ]];
            }
            else {
                NSLog(@"nilnilnlinli");
            }
        }
        else
        {
            NSLog(@"ViewController Debug - Error retrieving video playlist: `%@`", error);
         
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Mocha_ToastMessage toastWithDuration:2.0 andText:GSSLocalizedString(@"BCove_Error_text") inView:ApplicationDelegate.window];
                    NSLog(@"");
                    

                    self.btnPlay.hidden = YES;
                    self.btnPlay.selected = NO;
                    self.lblLeftTime.hidden = YES;
                    self.btnDimms.hidden = YES;
                    
                    //[self showThumbImageArea:YES];
                    self.viewMPlayerArea.hidden = YES;
                    self.viewBadge.hidden = NO;
                    self.imgThumbnail.hidden = NO;
                    self.imgVerticalVideoBG.hidden = YES;

                    self.btnMute.hidden = YES;
                    self.btnFullMovie.hidden = YES;
                    self.btnDimmClose.hidden = YES;
                    //[self showControllerIsMuteFullOnly:NO];
                    //[self setVODStatusDefault];
                
            });
        }
        
    }];
}


-(void)playerTimeReset{
    [self.currentPlayer seekToTime:kCMTimeZero];
}
-(BOOL)isPlayerValid{
    
    if (self.currentPlayer == nil) {
        return NO;
    }else{
        return YES;
    }
}
@end
