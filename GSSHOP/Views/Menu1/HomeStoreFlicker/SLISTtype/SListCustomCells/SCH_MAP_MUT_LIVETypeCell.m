//
//  SCH_MAP_MUT_LIVETypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 4. 7..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SCH_MAP_MUT_LIVETypeCell.h"
#import "SListTBViewController.h"
#import "AVPlayerPlayView.h"

@interface SCH_MAP_MUT_LIVETypeCell ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerPlayView *playerView;
@property (nonatomic, strong) NSURL *URL;
@end

static void *AVPlayerCurrentItemObservationContext = &AVPlayerCurrentItemObservationContext;
static void *AVPlayerStatusObservationContext = &AVPlayerStatusObservationContext;

@implementation SCH_MAP_MUT_LIVETypeCell
@synthesize player = _player;
@synthesize playerItem = _playerItem;
@synthesize playerView = _playerView;
@synthesize URL = _URL;
@synthesize indexPathNow;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mvPlayerKillall)
                                                 name:MAINSECTIONLIVEVIDEOALLKILL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mvPlayerKillall)
                                                 name:SCHEDULELIVEVIDEOALLKILL
                                               object:nil];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.lblMobilePrice.numberOfLines = 0;
    
    //뱃지들 높이 , 일반일경우 78, 상담일경우 71
    
    self.viewBtnPlay.hidden = YES;
    self.viewMPlayerArea.hidden = YES;
    self.viewDimmed.hidden = YES;
//    self.viewScreenBtn.hidden = YES;
    self.viewImageLayer.hidden = YES;
    self.viewTagMobilePrice.hidden = YES;
    self.viewTagGsPrice.hidden = YES;
    self.viewTagPercent.hidden = YES;
    self.imgBackGround.hidden = NO;
    self.imgProduct.hidden = YES;
    self.viewPrdDimmed.hidden = YES;
    self.viewPrdWhiteDimmed.hidden = YES;
    self.lblBasePrice.hidden = YES;
    self.lblBasePriceWon.hidden = YES;
    self.viewBasePriceStrikeLine.hidden = YES;
    self.lblPerMonth.hidden = YES;
    self.lblSalePrice.hidden = YES;
    self.lblSalePriceWon.hidden = YES;
    self.lblCounsel.hidden = YES;
    self.viewImageAreaBorder.layer.borderWidth = 1.0;
    self.viewImageAreaBorder.layer.shouldRasterize = YES;
    self.viewImageAreaBorder.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewImageAreaBorder.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.05].CGColor;
    self.viewBottomDirectOrd.layer.cornerRadius = 2.0;
    self.viewBottomDirectOrd.layer.shouldRasterize = YES;
    self.viewBottomDirectOrd.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.viewBtn3GAlertCancel.layer.borderWidth = 1.0;
    self.viewBtn3GAlertCancel.layer.cornerRadius = 17.0;
    self.viewBtn3GAlertCancel.layer.shouldRasterize = YES;
    self.viewBtn3GAlertCancel.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewBtn3GAlertCancel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.viewBtn3GAlertConfirm.layer.cornerRadius = 17.0;
    self.viewBtn3GAlertConfirm.layer.shouldRasterize = YES;
    self.viewBtn3GAlertConfirm.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)prepareForReuse {
    [super prepareForReuse];
    if ([self.reuseIdentifier isEqualToString:SCH_MAP_MUT_LIVETypeIdentifier]) {
    }
    else {
        [self initViewObject];
    }
}

-(void)initViewObject {
    self.backgroundColor = [UIColor clearColor];
    self.imgBackGround.hidden = NO;
    self.imgSpeBanner.image = nil;
    self.viewBtnPlay.hidden = YES;
    self.viewMPlayerArea.hidden = YES;
    self.viewDimmed.hidden = YES;
//    self.viewScreenBtn.hidden = YES;
    self.viewImageLayer.hidden = YES;
    self.btnPlay.hidden = NO;
    self.viewTagMobilePrice.hidden = YES;
    self.viewTagGsPrice.hidden = YES;
    self.viewTagPercent.hidden = YES;
    self.lblBasePrice.hidden = YES;
    self.lblBasePriceWon.hidden = YES;
    self.viewBasePriceStrikeLine.hidden = YES;
    self.imgBackGround.hidden = NO;
    self.imgProduct.hidden = YES;
    self.viewPrdDimmed.hidden = YES;
    self.viewPrdWhiteDimmed.hidden = YES;
    self.lblPerMonth.hidden = YES;
    self.lblSalePrice.hidden = YES;
    self.lblSalePriceWon.hidden = YES;
    self.lblCounsel.hidden = YES;
    self.imgBenefit01.image = nil;
    self.imgBenefit02.image = nil;
    self.imgBenefit03.image = nil;
    self.lblTimer.text = @"";
    self.viewBottomLine.backgroundColor = [Mocha_Util getColor:@"C5C5C5"];
//    CGFloat bottomMarginVideoView = (widthTableLeftProduct - ((180.0/320.0) * widthTableLeftProduct)) / 2.0;
//
//    self.lconstBtnFullScrTop.constant = widthTableLeftProduct - bottomMarginVideoView;
//    [self.viewDimmed layoutIfNeeded];
    
    //self.playerView.frame = CGRectMake(0.0, 0, widthTableLeftProduct, (180.0/320.0) * widthTableLeftProduct);
    
    if ([self.reuseIdentifier isEqualToString:SCH_MAP_MUT_LIVETypeIdentifier]) {
        [self stopMoviePlayer];
    }
}


- (void) dealloc {
    [self mvPlayerDealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MAINSECTIONLIVEVIDEOALLKILL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SCHEDULELIVEVIDEOALLKILL object:nil];
}


-(void) setCellInfoNDrawData:(NSDictionary*) dicRowInfo andIndexPath:(NSIndexPath *)path {
    self.backgroundColor = [UIColor clearColor];
    if (NCO(dicRowInfo) == NO || NCO([dicRowInfo objectForKey:@"product"]) == NO) {
        return;
    }
    if ([self.reuseIdentifier isEqualToString:SCH_MAP_MUT_LIVETypeIdentifier]) {
        if (self.isLiveCellNeedsReload == NO) {
            if ([[self.dicRow objectForKey:@"prdId"] isEqualToString:[[dicRowInfo objectForKey:@"product"] objectForKey:@"prdId"]]) {
                self.dicAll = dicRowInfo;
                self.dicRow = [dicRowInfo objectForKey:@"product"];
                self.indexPathNow = path;
                if ([NCS([self.dicRow objectForKey:@"broadAlarmDoneYn"]) isEqualToString:@"Y"]) {
                    self.btnAlarm.selected = YES;
                    self.btnAlarm.accessibilityLabel = @"방송알림 취소";
                }
                else {
                    self.btnAlarm.selected = NO;
                    self.btnAlarm.accessibilityLabel = @"방송알림 등록";
                }
                return;
            }
            else {
                [self initViewObject];
            }
        }
        else {
            [self initViewObject];
        }
    }
    
    self.dicAll = dicRowInfo;
    self.dicRow = [dicRowInfo objectForKey:@"product"];
    self.indexPathNow = path;
    
    if ([NCS([self.dicAll objectForKey:@"specialPgmYn"]) isEqualToString:@"Y"] && NCO([self.dicAll objectForKey:@"specialPgmInfo"])) {
        self.lconstViewBannerHeight.constant = (45.0/320.0) * widthTableLeftProduct;
        self.strBannerURL = NCS([[self.dicAll objectForKey:@"specialPgmInfo"] objectForKey:@"imageUrl"]);
        if ([self.strBannerURL length] > 0 && [self.strBannerURL hasPrefix:@"http"]) {
            [ImageDownManager blockImageDownWithURL:self.strBannerURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                if (error == nil  && [self.strBannerURL isEqualToString:strInputURL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache) {
                            self.imgSpeBanner.image = fetchedImage;
                        }
                        else {
                            self.imgSpeBanner.alpha = 0;
                            self.imgSpeBanner.image = fetchedImage;
                        }
                        
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             self.imgSpeBanner.alpha = 1;
                                         }
                                         completion:^(BOOL finished) {
                                             
                                         }];
                    });
                }
            }];
        }
    }
    else {
        self.lconstViewBannerHeight.constant = 0.0;
    }
    
    self.lconstViewImageHeight.constant = widthTableLeftProduct;
    if([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"SCH_MAP_MUT_LIVE"]) {
        if ([NCS([[self.dicAll objectForKey:@"livePlayInfo"] objectForKey:@"linkUrl"]) length] > 0) {
            self.viewPrdDimmed.hidden = NO;
            self.viewPrdWhiteDimmed.hidden = YES;
            self.curRequestString = [[self.dicAll objectForKey:@"livePlayInfo"] objectForKey:@"linkUrl"];
            self.viewBtnPlay.hidden = NO;
            self.viewDimmed.hidden = NO;
            //self.viewScreenBtn.hidden = NO;
            self.viewBtnPlay.userInteractionEnabled = YES;
            self.isLivePlay = YES;
            
            self.lconstCenterBtnFullScr.constant = -56.0;
            self.btnGOLink.hidden = NO;
            
        }
        else {
            self.viewBtnPlay.hidden = YES;
            self.viewPrdDimmed.hidden = YES;
            self.viewPrdWhiteDimmed.hidden = NO;
            self.lconstCenterBtnFullScr.constant = 0.0;
            self.btnGOLink.hidden = YES;
        }
       
        if ([NCS([self.dicAll  objectForKey:@"publicBroadYn"]) isEqualToString:@"Y"] || [NCS([self.dicRow  objectForKey:@"insuYn"]) isEqualToString:@"Y"] || [NCS([self.dicRow objectForKey:@"linkUrl"]) length] == 0) {
            //이동할 링크가 없으면 hidden YES
            self.lconstCenterBtnFullScr.constant = 0.0;
            self.btnGOLink.hidden = YES;
        }
        else{
            //이동할 링크가 있을경우에만 동영상 플레이어 화면의 링크이동을 활성화
            self.lconstCenterBtnFullScr.constant = -56.0;
            self.btnGOLink.hidden = NO;
        }
    }
    else {
        self.viewPrdDimmed.hidden = YES;
        self.viewPrdWhiteDimmed.hidden = NO;
    }

    // 이미지 로딩
    if([NCS([self.dicRow objectForKey:@"mainPrdImgUrl"]) length] > 0) {
        self.imageURL = NCS([self.dicRow objectForKey:@"mainPrdImgUrl"]);
    }
    else {
        self.imageURL = NCS([self.dicRow objectForKey:@"subPrdImgUrl"]);
    }

    [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        if (error == nil  && [self.imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imgProduct.hidden = NO;
                self.imgBackGround.hidden = NO;
                if (isInCache) {
                    self.imgProduct.image = fetchedImage;
                }
                else {
                    self.imgProduct.alpha = 0;
                    self.imgProduct.image = fetchedImage;
                }
                [UIView animateWithDuration:0.2f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     self.imgProduct.alpha = 1;
                                 }
                                 completion:^(BOOL finished) {
                                     
                                 }];
            });
        }
    }];

    
    if ([NCS([self.dicRow objectForKey:@"imageLayerFlag"]) length] > 0) {
        self.viewImageLayer.hidden = NO;
        NSString *strFlag = @"";
        if ([NCS([self.dicRow objectForKey:@"imageLayerFlag"]) isEqualToString:@"AIR_BUY"]) {
            strFlag = @"방송중 구매가능";
            self.btn_TVLink.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ 합니다.",NCS([self.dicRow objectForKey:@"exposPrdName"]),strFlag];
        }
        else if ([NCS([self.dicRow objectForKey:@"imageLayerFlag"]) isEqualToString:@"SOLD_OUT"]) {
            strFlag = @"일시품절";
            self.btn_TVLink.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ 되었습니다.",NCS([self.dicRow objectForKey:@"exposPrdName"]),strFlag];
        }
        else {
            self.viewImageLayer.hidden = YES;
        }
        self.lblImageLayer.text = strFlag;
    }
    else {
        self.viewImageLayer.hidden = YES;
    }

    //
    if ([NCS([self.dicRow objectForKey:@"priceMarkUpType"]) isEqualToString:@"LIVEPRICE"]) {
        self.viewTagMobilePrice.hidden = NO;
        [self.viewPriceArea removeConstraint:self.lconstSalePriceLeftMargin];
        self.lconstSalePriceLeftMargin = [NSLayoutConstraint constraintWithItem:self.lblSalePrice
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.viewTagMobilePrice
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1
                                                                       constant:10.0];
        [self.viewPriceArea addConstraint:self.lconstSalePriceLeftMargin];
    }
//    else if ([NCS([self.dicRow objectForKey:@"priceMarkUpType"]) isEqualToString:@"GSPRICE"]) {
//        self.viewTagGsPrice.hidden = NO;
//        [self.viewPriceArea removeConstraint:self.lconstSalePriceLeftMargin];
//        self.lconstSalePriceLeftMargin = [NSLayoutConstraint constraintWithItem:self.lblSalePrice
//                                                                      attribute:NSLayoutAttributeLeading
//                                                                      relatedBy:NSLayoutRelationEqual
//                                                                         toItem:self.viewTagGsPrice
//                                                                      attribute:NSLayoutAttributeTrailing
//                                                                     multiplier:1
//                                                                       constant:10.0];
//        [self.viewPriceArea addConstraint:self.lconstSalePriceLeftMargin];
//    }
    else if ([NCS([self.dicRow objectForKey:@"priceMarkUpType"]) isEqualToString:@"RATE"] && [NCS([self.dicRow objectForKey:@"priceMarkUp"]) length] > 0 ) {
        self.viewTagPercent.hidden = NO;
        self.lblDiscountRate.text = NCS([self.dicRow objectForKey:@"priceMarkUp"]);
        [self.viewPriceArea removeConstraint:self.lconstSalePriceLeftMargin];
        self.lconstSalePriceLeftMargin = [NSLayoutConstraint constraintWithItem:self.lblSalePrice
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.viewTagPercent
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1
                                                                       constant:10.0];
        [self.viewPriceArea addConstraint:self.lconstSalePriceLeftMargin];
    }
    else { //GS가 노출안함. 
        self.viewTagGsPrice.hidden = YES;
        self.viewTagMobilePrice.hidden = YES;
        self.viewTagPercent.hidden = YES;
        
        [self.viewPriceArea removeConstraint:self.lconstSalePriceLeftMargin];
        self.lconstSalePriceLeftMargin = [NSLayoutConstraint constraintWithItem:self.lblSalePrice
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.lblProductTitle
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1
                                                                       constant:0.0];
        [self.viewPriceArea addConstraint:self.lconstSalePriceLeftMargin];
        
    }
    

    self.lblProductTitle.text = NCS([self.dicRow objectForKey:@"exposPrdName"]);
    self.btn_TVLink.accessibilityLabel = NCS([self.dicRow objectForKey:@"exposPrdName"]);
    
    CGFloat heightProductInfoArea = 0.0;
    CGFloat heightButtonArea = 0.0;
    
    //생방송 모바일가 일때와 아닐때의 높이값이 다름 ------ 상품 가격 영역 높이
    if ([NCS([self.dicRow objectForKey:@"priceMarkUpType"]) isEqualToString:@"LIVEPRICE"]) {
        heightProductInfoArea = 80;
    }
    else {
        heightProductInfoArea = 77;
    }
    
    if ([NCS([self.dicAll  objectForKey:@"publicBroadYn"]) isEqualToString:@"Y"] || [NCS([self.dicRow  objectForKey:@"insuYn"]) isEqualToString:@"Y"]){
        //공영방송 또는 보험방송이 생방송인경우
        heightProductInfoArea = 45.0;
        self.lconstTitleLabelTop.constant = 14.0;
        self.viewTagMobilePrice.hidden = YES;
        self.viewTagGsPrice.hidden = YES;
        self.viewTagPercent.hidden = YES;
        self.lblSalePrice.hidden = YES;
        self.lblSalePriceWon.hidden = YES;
        self.lblPerMonth.hidden = YES;
        self.lblCounsel.hidden = YES;
        self.lblBasePrice.hidden = YES;
        self.lblBasePriceWon.hidden = YES;

        self.btn_TVLinkPriceArea.accessibilityLabel = NCS([self.dicRow objectForKey:@"exposPrdName"]);
        
    //렌탈,휴대폰일때와 아닐때 ------ 상품 가격 영역 높이
    }
    else if ([NCS([self.dicRow objectForKey:@"rentalYn"]) isEqualToString:@"Y"] ||
        [NCS([self.dicRow objectForKey:@"cellPhoneYn"]) isEqualToString:@"Y"]) {
        self.lconstTitleLabelTop.constant = 8.0;
        self.lconstSalePriceTopMargin.constant = 45.0;
        if([NCS([self.dicRow objectForKey:@"rentalYn"]) isEqualToString:@"Y"]) {  //렌탈
            heightProductInfoArea = heightProductInfoArea + 27;            
            self.lblPerMonth.hidden = NO;
            self.lblSalePrice.hidden = NO;
            self.lblCounsel.hidden = NO;
            self.lblPerMonth.text = NCS([self.dicRow objectForKey:@"rentalText"]);
            self.lblSalePrice.text = NCS([self.dicRow objectForKey:@"rentalPrice"]);
            self.lblCounsel.text = NCS([self.dicRow objectForKey:@"rentalEtcText"]);
            
            self.btn_TVLinkPriceArea.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@ %@",NCS([self.dicRow objectForKey:@"exposPrdName"]), NCS([self.dicRow objectForKey:@"rentalText"]) ,NCS([self.dicRow objectForKey:@"rentalPrice"]) ,NCS([self.dicRow objectForKey:@"rentalEtcText"])];
            
            if ([NCS([self.dicRow objectForKey:@"priceMarkUpType"]) isEqualToString:@"LIVEPRICE"] || [NCS([self.dicRow objectForKey:@"priceMarkUpType"]) isEqualToString:@"GSPRICE"]|| [NCS([self.dicRow objectForKey:@"priceMarkUpType"]) isEqualToString:@"RATE"]) {
                
                [self.viewPriceArea removeConstraint:self.lconstCounselLeading];
                [self.viewPriceArea removeConstraint:self.lconstCounselBottom];
                
                self.lconstCounselLeading = [NSLayoutConstraint constraintWithItem:self.lblCounsel
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.lblSalePrice
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:0];
                
                self.lconstCounselBottom = [NSLayoutConstraint constraintWithItem:self.lblCounsel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.viewPriceArea
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:-12];
                [self.viewPriceArea addConstraint:self.lconstCounselLeading];
                [self.viewPriceArea addConstraint:self.lconstCounselBottom];
                
            }
            else {
                //priceMarkUpType 이 3경우가 아님
                if ([NCS([self.dicRow objectForKey:@"rentalEtcText"]) length] > 0 && [NCS([self.dicRow objectForKey:@"rentalText"]) length] == 0 && [NCS([self.dicRow objectForKey:@"rentalPrice"]) length] == 0) {
                
                    heightProductInfoArea = 55.0;
                    self.lblPerMonth.hidden = YES;
                    self.lblSalePrice.hidden = YES;
                    [self.viewPriceArea removeConstraint:self.lconstCounselLeading];
                    [self.viewPriceArea removeConstraint:self.lconstCounselBottom];
                    self.lconstCounselLeading = [NSLayoutConstraint constraintWithItem:self.lblCounsel
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.viewPriceArea
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1
                                                                              constant:0];
                    self.lconstCounselBottom = [NSLayoutConstraint constraintWithItem:self.lblCounsel
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.viewPriceArea
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1
                                                                             constant:-9];
                    [self.viewPriceArea addConstraint:self.lconstCounselLeading];
                    [self.viewPriceArea addConstraint:self.lconstCounselBottom];
                }
                else {
                    [self.viewPriceArea removeConstraint:self.lconstCounselLeading];
                    [self.viewPriceArea removeConstraint:self.lconstCounselBottom];
                    self.lconstCounselLeading = [NSLayoutConstraint constraintWithItem:self.lblCounsel
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.lblSalePrice
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1
                                                                              constant:0];
                    self.lconstCounselBottom = [NSLayoutConstraint constraintWithItem:self.lblCounsel
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.viewPriceArea
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1
                                                                             constant:-12];
                    [self.viewPriceArea addConstraint:self.lconstCounselLeading];
                    [self.viewPriceArea addConstraint:self.lconstCounselBottom];
                }
            }
        }
        else if([NCS([self.dicRow objectForKey:@"cellPhoneYn"]) isEqualToString:@"Y"]) { //휴대폰
            heightProductInfoArea = heightProductInfoArea + 27;
            self.lblSalePrice.hidden = NO;
            self.lblSalePriceWon.hidden = NO;
            self.lblSalePrice.text = NCS([self.dicRow objectForKey:@"broadPrice"]);
            self.lblSalePriceWon.text = NCS([self.dicRow objectForKey:@"exposePriceText"]);
            if( [NCS([self.dicRow objectForKey:@"rentalText"]) length] > 0) {
                self.lblPerMonth.hidden = NO;
                self.lblCounsel.hidden = NO;
                self.lblPerMonth.text = NCS([self.dicRow objectForKey:@"rentalText"]);
                self.lblCounsel.text = NCS([self.dicRow objectForKey:@"rentalEtcText"]);
                
                self.btn_TVLinkPriceArea.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@ %@",NCS([self.dicRow objectForKey:@"exposPrdName"]), NCS([self.dicRow objectForKey:@"rentalText"]) ,NCS([self.dicRow objectForKey:@"broadPrice"]) ,NCS([self.dicRow objectForKey:@"rentalEtcText"])];
            }
            else {
                if([NCS([self.dicRow objectForKey:@"salePrice"]) isEqualToString:@"0"] || [NCS([self.dicRow objectForKey:@"salePrice"]) length] == 0) {
                    self.lconstSalePriceTopMargin.constant = 38.5;
                }
                else {
                    self.lconstSalePriceTopMargin.constant = 45.0;
                    self.lblBasePrice.hidden = NO;
                    self.lblBasePriceWon.hidden = NO;
                    self.viewBasePriceStrikeLine.hidden = NO;
                    self.lblBasePrice.text = NCS([self.dicRow objectForKey:@"salePrice"]);
                    
                    self.btn_TVLinkPriceArea.accessibilityLabel = [NSString stringWithFormat:@"%@ %@  %@",NCS([self.dicRow objectForKey:@"exposPrdName"]), NCS([self.dicRow objectForKey:@"broadPrice"]),NCS([self.dicRow objectForKey:@"exposePriceText"])];
                }
            }
        }
    }
    else {
        self.lconstTitleLabelTop.constant = 8.0;
        self.lblSalePrice.hidden = NO;
        self.lblSalePriceWon.hidden = NO;
        self.lblSalePrice.text = NCS([self.dicRow objectForKey:@"broadPrice"]);
        self.lblSalePriceWon.text = NCS([self.dicRow objectForKey:@"exposePriceText"]);
        if([NCS([self.dicRow objectForKey:@"salePrice"]) isEqualToString:@"0"] || [NCS([self.dicRow objectForKey:@"salePrice"]) length] == 0) {
            //45,36 가격 top
            self.lconstSalePriceTopMargin.constant = 38.5;//36.0;
        }
        else {
            self.lconstSalePriceTopMargin.constant = 45.0;
            self.lblBasePrice.hidden = NO;
            self.lblBasePriceWon.hidden = NO;
            self.viewBasePriceStrikeLine.hidden = NO;
            self.lblBasePrice.text = NCS([self.dicRow objectForKey:@"salePrice"]);
        }
        
        self.btn_TVLinkPriceArea.accessibilityLabel = [NSString stringWithFormat:@"%@ %@  %@",NCS([self.dicRow objectForKey:@"exposPrdName"]), NCS([self.dicRow objectForKey:@"broadPrice"]),NCS([self.dicRow objectForKey:@"exposePriceText"])];
        
        
        // 혜택
        if (NCA([self.dicRow objectForKey:@"rwImgList"]) == YES) {
            NSArray *arrTagImage = [self.dicRow objectForKey:@"rwImgList"];
            
            if([arrTagImage count] > 0) {
                if([NCS([arrTagImage objectAtIndex:0]) length] > 0) {
                    self.strBenefitURL01 = NCS([arrTagImage objectAtIndex:0]);
                    [ImageDownManager blockImageDownWithURL:self.strBenefitURL01 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                        if (error == nil  && [self.strBenefitURL01 isEqualToString:strInputURL]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if(isInCache) {
                                    self.imgBenefit01.image = fetchedImage;
                                }
                                else {
                                    self.imgBenefit01.alpha = 0;
                                    self.imgBenefit01.image = fetchedImage;
                                }
                                
                                [UIView animateWithDuration:0.2f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseInOut
                                                 animations:^{
                                                     self.imgBenefit01.alpha = 1;
                                                 }
                                                 completion:^(BOOL finished) {
                                                 }];
                            });
                        }
                    }];
                }
            }
                           
             
                                       
           if([arrTagImage count] > 1) {
               if([NCS([arrTagImage objectAtIndex:1]) length] > 0) {
                   self.strBenefitURL02 = NCS([arrTagImage objectAtIndex:1]);
                   [ImageDownManager blockImageDownWithURL:self.strBenefitURL02 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                       if(error == nil  && [self.strBenefitURL02 isEqualToString:strInputURL]) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if(isInCache) {
                                   self.imgBenefit02.image = fetchedImage;
                               }
                               else {
                                   self.imgBenefit02.alpha = 0;
                                   self.imgBenefit02.image = fetchedImage;
                               }
                               
                               [UIView animateWithDuration:0.2f
                                                     delay:0.0f
                                                   options:UIViewAnimationOptionCurveEaseInOut
                                                animations:^{
                                                    self.imgBenefit02.alpha = 1;
                                                }
                                                completion:^(BOOL finished) {
                                                }];
                           });
                       }
                   }];
               }
           }
           
           
           if([arrTagImage count] > 2) {
               if([NCS([arrTagImage objectAtIndex:2]) length] > 0) {
                   self.strBenefitURL03 = NCS([arrTagImage objectAtIndex:2]);
                   [ImageDownManager blockImageDownWithURL:self.strBenefitURL03 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                       if(error == nil  && [self.strBenefitURL03 isEqualToString:strInputURL]) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if(isInCache) {
                                   self.imgBenefit03.image = fetchedImage;
                               }
                               else {
                                   self.imgBenefit03.alpha = 0;
                                   self.imgBenefit03.image = fetchedImage;
                               }
                               
                               [UIView animateWithDuration:0.2f
                                                     delay:0.0f
                                                   options:UIViewAnimationOptionCurveEaseInOut
                                                animations:^{
                                                    self.imgBenefit03.alpha = 1;
                                                }
                                                completion:^(BOOL finished) {
                                                }];
                           });
                       }
                   }];
               }
           }
            }
    }//else

    
   
    
    self.lconstViewPriceAreaHeight.constant = heightProductInfoArea;
    
    
    if ([NCS([self.dicAll  objectForKey:@"publicBroadYn"]) isEqualToString:@"Y"]) {
        heightButtonArea = 0.0;
        self.viewBottomBtns.hidden = YES;
    }
    else {
        self.viewBottomBtns.hidden = NO;
        BOOL isLiveTalk  = NO;
        BOOL isBroadAlarm  = NO;
        BOOL isDirectOrd  = NO;
        //버튼높이 계산
        if ([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"SCH_MAP_MUT_LIVE"] && (NCO([self.dicAll objectForKey:@"liveTalkInfo"]) == YES) ) {
            //라이브톡 버튼 노출 여부 ,생방송일때만 노출하려고 개발중
            isLiveTalk = YES;
            self.btnLiveTalk.hidden = NO;
        }
        else {
            self.btnLiveTalk.hidden = YES;
        }
        
        if ([NCS([self.dicRow objectForKey:@"broadAlarmDoneYn"]) isEqualToString:@"Y"] || [NCS([self.dicRow objectForKey:@"broadAlarmDoneYn"]) isEqualToString:@"N"] ) {// 방송알림 노출 여부
            isBroadAlarm = YES;
            self.btnAlarm.hidden = NO;
            if ([NCS([self.dicRow objectForKey:@"broadAlarmDoneYn"]) isEqualToString:@"Y"]) {
                self.btnAlarm.selected = YES;
                self.btnAlarm.accessibilityLabel = @"방송알림 취소";
            }
            else {
                self.btnAlarm.selected = NO;
                self.btnAlarm.accessibilityLabel = @"방송알림 등록";
            }
        }
        else {
            self.btnAlarm.hidden = YES;
        }
        
        if ((NCO([self.dicRow objectForKey:@"directOrdInfo"]) == YES && [NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"linkUrl"]) length] > 0) ) { // 바로구매 버튼 노출 여부
            isDirectOrd = YES;
            self.viewBottomDirectOrd.hidden = NO;
            if ([NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"text"]) length] > 0) {
                self.lblBottomDirectOrd.text = NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"text"]);
                self.btnDirectOrd.accessibilityLabel = NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"text"]);
            }
            else {
                self.lblBottomDirectOrd.text = @"구매하기";
                self.btnDirectOrd.accessibilityLabel = @"구매하기";
            }
            
        }
        else {
            self.viewBottomDirectOrd.hidden = YES;
        }


        heightButtonArea = 48.0;
        if (isBroadAlarm == YES && isLiveTalk == YES && isDirectOrd == YES) {  //111
            self.lconstBtnAlarmTrailing.constant = (widthTableLeftProduct - 118.0) + 17.0 + 49.0;
            self.lconstBtnLiveTalkTrailing.constant = (widthTableLeftProduct - 118.0) + 17;
        }
        else if (isBroadAlarm == YES && isLiveTalk == NO && isDirectOrd == YES) { //101
            self.lconstBtnAlarmTrailing.constant = (widthTableLeftProduct - 118.0) + 17.0;
        }
        else if (isBroadAlarm == NO && isLiveTalk == YES && isDirectOrd == YES) { //011
            self.lconstBtnLiveTalkTrailing.constant = (widthTableLeftProduct - 118.0) + 17.0;
        }
        else if (isBroadAlarm == YES && isLiveTalk == YES && isDirectOrd == NO) { //110
            self.lconstBtnAlarmTrailing.constant = 10.0 + 49.0;
            self.lconstBtnLiveTalkTrailing.constant = 10.0;
        }
        else if (isBroadAlarm == YES && isLiveTalk == NO && isDirectOrd == NO) { //100
            self.lconstBtnAlarmTrailing.constant = 10.0;
        }
        else if (isBroadAlarm == NO && isLiveTalk == YES && isDirectOrd == NO) { //010
            self.lconstBtnLiveTalkTrailing.constant = 10.0;
        }
        else if (isBroadAlarm == NO && isLiveTalk == NO && isDirectOrd == YES) { //001
            
        }
        else if (isBroadAlarm == NO && isLiveTalk == NO && isDirectOrd == NO) { //000
            heightButtonArea = 0.0;
        }
        
    }
    self.lconstViewBottomHeight.constant = heightButtonArea;
    if (NCA([self.dicRow objectForKey:@"subProductList"])) {
        self.viewBottomLine.backgroundColor = [Mocha_Util getColor:@"F4F4F4"];
    }
    else {
        self.viewBottomLine.backgroundColor = [Mocha_Util getColor:@"D9D9D9"];
    }
    
    [self.viewImageArea layoutIfNeeded];
    [self.viewPriceArea layoutIfNeeded];
    [self.viewBottomBtns layoutIfNeeded];
    [self layoutIfNeeded];
    
    if([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"SCH_MAP_MUT_LIVE"]) {
        if (NCO([self.dicRow objectForKey:@"salesInfo"])) {
            [self procGraphAnimation:[self.dicRow objectForKey:@"salesInfo"]];
        }
        else {
            [self RemoveGraphView];
        }
    }
}


-(void)procGraphAnimation:(NSDictionary*)dic {
    
    if([NCS([dic objectForKey:@"saleRate"]) isEqualToString:@"N"]) {
        [self RemoveGraphView]; return;
    }
    if([NCS([dic objectForKey:@"saleRate"]) length] == 0 || [NCS([dic objectForKey:@"saleRate"]) intValue] < 80 ) {
        [self RemoveGraphView]; return;
    }
    if([NCS([dic objectForKey:@"ordQty"]) length] == 0 || [NCS([dic objectForKey:@"ordQty"]) intValue] < 1 ) {
        [self RemoveGraphView]; return;
    }
    
    if(isgraphAniming == YES) {
        return;
    }
    self.viewBtnPlay.alpha = 0.0;
    isgraphAniming = YES;
    self.view_graphcontainner.hidden = NO;
    self.view_graphcontainner.alpha = 1.0f;
    self.label_ordqty.alpha = 1.0;
    self.label_saletext.alpha = 1.0;
    self.label_tailtext.alpha = 1.0;
    
    NSString* tstr = [Common_Util commaStringFromDecimal:[[dic objectForKey:@"ordQty"] intValue]];
    self.label_ordqty.textColor = [UIColor whiteColor];
    self.label_ordqty.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    self.label_ordqty.minLength = 2;
    if([tstr length] > 7) {
        //100만
        self.lconsLblOrdqtyWidth.constant = 98.0;
        self.lconsLblOrdqtyX.constant = 13.0;
    }
    else if([tstr length] == 7) {
        //10만
        self.lconsLblOrdqtyWidth.constant = 78.0;
        self.lconsLblOrdqtyX.constant = 13.0;
    }
    else if([tstr length] == 6) {
        self.lconsLblOrdqtyWidth.constant = 68.0;
        self.lconsLblOrdqtyX.constant = 22.0;
    }
    else if([tstr length] == 2) {
        self.lconsLblOrdqtyWidth.constant = 40.0;
        self.lconsLblOrdqtyX.constant = 37.0;
    }
    else {
        self.lconsLblOrdqtyWidth.constant = 53.0;
        self.lconsLblOrdqtyX.constant = 32.0;
    }
    
    [self.viewProcCount layoutIfNeeded];
    [self.label_ordqty setValue:tstr];
    [self.label_ordqty startAnimation];
    if ([self.target respondsToSelector:@selector(liveCellSaleCountEnd:)]) {
        [self.target liveCellSaleCountEnd:self.indexPathNow];
    }
    [self performSelector:@selector(RemoveGraphView) withObject:nil afterDelay:2.0f];    
}

-(void)RemoveGraphView{
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.view_graphcontainner.alpha = 0.0f;
                         
                         self.viewBtnPlay.alpha = 1.0;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         self.view_graphcontainner.hidden = YES;
                         isgraphAniming = NO;
                         
                         if([NCS([self.dicAll objectForKey:@"broadEndDate"]) isEqualToString:@""]){
                             //방송 끝나는 시간 애러시 뷰 히든
                             self.viewBtnPlay.hidden = YES;
                         }else{
                             
                             self.viewBtnPlay.hidden = NO;
                             
                             if([timerLive isValid]){
                                 [timerLive invalidate];
                             }
                             timerLive = nil;
                             
                             timerLive = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startLiveTimer) userInfo:nil repeats:YES];
                             
                             [self startLiveTimer];
                         }
                         
                         
                     }];
}

-(void)startLiveTimer{
    
    
    //broadStartDate
    //20170620144000
    //broadEndDate
    
    //((20 / 60) *100)
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *closeTime = [dateformat dateFromString:NCS([self.dicAll objectForKey:@"broadEndDate"])];
    int closestamp = [closeTime timeIntervalSince1970];
    
    NSString * dbstr =   [NSString stringWithFormat:@"%d", closestamp ];
    
    @try {
        
        [self.lblTimer setText:[self getDateLeft:dbstr]];
        
    }@catch (NSException *exception)
    {
        NSLog(@"lefttimeLabel not Exist : %@",exception);
    }
    @finally
    {
    }
    
}

- (NSString *) getDateLeft:(NSString *)date{
    
    
    double left = [date doubleValue] - [[NSDate getSeoulDateTime] timeIntervalSince1970];
    
    int tminite = left/60;
    int hour = left/3600;
    int minite = (left-(hour*3600))/60;
    int second = (left-(hour*3600)-(minite*60));
    
    NSString *callTemp = nil;
    
    
    if(tminite >= 60) {
        callTemp = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minite, second];
    } else if(left <= 0) {
        callTemp = GSSLocalizedString(@"home_tv_live_view_close_text");
    } else {
        callTemp  = [NSString stringWithFormat:@"00:%02d:%02d", minite, second];
    }
    
    if([callTemp isEqualToString:GSSLocalizedString(@"home_tv_live_view_close_text")]){
        
        if ([timerLive isValid]) {
            [timerLive invalidate];
            NSLog(@"[timer invalidate]");
        }
        
        timerLive = nil;
        
        //if ((self.player.rate != 0) && (self.player.error == nil)) {
        
        if ((self.player.rate != 0) && (self.player.error == nil)) {
            // 재생중일경우에는 플레이버튼 히든 안함
        }
        else {
            self.btnPlay.hidden = YES;
            self.viewBtnPlay.userInteractionEnabled = NO;
        }
        
        
        if ([self.target respondsToSelector:@selector(hideRightTimeLineOnImage:)]) {
            [self.target hideRightTimeLineOnImage:self.indexPathNow];
        }
        
    }
    
    
    return callTemp;
}



-(IBAction)onBtnSpeBanner:(id)sender{
    NSDictionary *dicSpe = [self.dicAll objectForKey:@"specialPgmInfo"];
    if (NCO(dicSpe) == YES && [self.target respondsToSelector:@selector(touchEventTBCell:)]) {
        [self.target touchEventTBCell:dicSpe];
    }
}

-(IBAction)onBtnGoLinkUrl:(id)sender{
    if ([self.target respondsToSelector:@selector(touchEventTBCell:)]) {
        [self.target touchEventTBCell:self.dicRow];
    }
}

-(IBAction)onBtnDirectOrder:(id)sender{
    
    if (NCO([self.dicRow objectForKey:@"directOrdInfo"])) {
        NSLog(@"[self.dicRow objectForKey:@directOrdInfo] = %@",[self.dicRow objectForKey:@"directOrdInfo"]);
        
        if([self.target respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]){
            [self.target touchEventTBCellJustLinkStr:NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"linkUrl"])];
        }
        
    }
    
}

-(IBAction)onBtnAlarm:(id)sender {
    NSMutableDictionary *dicAlarm = [[NSMutableDictionary alloc] init];
    [dicAlarm addEntriesFromDictionary:self.dicRow];
    [dicAlarm setObject:NCS([self.dicRow objectForKey:@"exposPrdName"]) forKey:@"prdName"];
    if ([NCS([self.dicRow objectForKey:@"broadAlarmDoneYn"]) length] > 0 && [NCS([self.dicRow objectForKey:@"broadAlarmDoneYn"]) isEqualToString:@"Y"]) {
        if([self.target respondsToSelector:@selector(requestAlarmWithDic:andProcess:andPeroid:andCount:)]) {
            [self.target requestAlarmWithDic:dicAlarm andProcess:TVS_ALARMDELETE andPeroid:@"" andCount:@""];
        }
    }
    else {
        if([self.target respondsToSelector:@selector(requestAlarmWithDic:andProcess:andPeroid:andCount:)]){
            [self.target requestAlarmWithDic:dicAlarm andProcess:TVS_ALARMINFO andPeroid:@"" andCount:@""];
        }
    }
}

-(IBAction)onBtnLiveTalk:(id)sender {    
    //효율코드
    if([self.target isLiveBrd]) {
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_L-LIVET")];
    }
    else {
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_L_D-LIVET")];
    }
    
    if (NCO([self.dicAll objectForKey:@"liveTalkInfo"])) { //2016.01 jin 라이브톡 프로토콜 추가
        if([self.target respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]) {
            [self.target touchEventTBCellJustLinkStr:NCS([[self.dicAll objectForKey:@"liveTalkInfo"] objectForKey:@"linkUrl"])];
        }
    }
}


#pragma mark - Movie Player

-(IBAction)onBtnMovieScreenBtn:(id)sender {
    [self viewDimmedShow:NO afterViewHide:YES];
    if ([((UIButton *)sender) tag] == 3008) {
        [self onBtnGoLinkUrl:nil];
    }
    else if ([((UIButton *)sender) tag] == 4000) {
        @try {
            if ([[[ApplicationDelegate.mainNVC viewControllers] objectAtIndex:0] isKindOfClass:[Home_Main_ViewController class]]) {
                [self playrequestLiveVideo:self.curRequestString];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception at Searching Home_Main_ViewController : %@", exception);
        }
    }
    else if([((UIButton *)sender) tag] == 5500) {
        if([self.target isLiveBrd]) {
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_L-STOP")];
        }
        else {
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_L_D-STOP")];
        }
    }
}



- (IBAction)onBtnMovieScreen:(id)sender {
    if (self.viewDimmed.alpha == 0.0) {
        [self viewDimmedShow:YES afterViewHide:NO];
    }
    else {
        [self viewDimmedShow:NO afterViewHide:NO];
    }
}


- (void)viewDimmedShow:(BOOL)isShow afterViewHide:(BOOL)isViewHide {
    CGFloat alphaModifier = 0.0;
    if (isShow) {
        alphaModifier = 1.0;
    }
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.viewDimmed.alpha = alphaModifier;
                     }
                     completion:^(BOOL finished) {
                         if (isViewHide) {
                             [UIView animateWithDuration:0.2f
                                                   delay:0.0f
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  self.viewMPlayerArea.alpha = alphaModifier;
                                              }
                                              completion:^(BOOL finished) {
                                                  [self stopMoviePlayer];
                                              }];
                         }
                     }];
}


- (float)nowPlayingRate {
    return self.player.rate;
}

- (void) playbackDidFinishLive:(NSNotification *)noti {
    [self stopMoviePlayer];
}


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
            [self.playerItem addObserver:self forKeyPath:kStatusKey options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerStatusObservationContext];
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(playbackDidFinishLive:)
                                                         name: AVPlayerItemDidPlayToEndTimeNotification
                                                       object: self.playerItem];
        }
        else {
            if (self.playerItem == nil) {
                NSLog(@"self.playerItem == nil");
            }
            
            if (self.playerItem != [AVPlayerItem playerItemWithAsset:asset]) {
                NSLog(@"self.playerItem = %@",self.playerItem);
                NSLog(@"[AVPlayerItem playerItemWithAsset:asset] = %@",[AVPlayerItem playerItemWithAsset:asset]);
                NSLog(@"self.playerItem != [AVPlayerItem playerItemWithAsset:asset]");
            }
            AVURLAsset *asset1 = (AVURLAsset *)[self.playerItem asset];
            AVURLAsset *asset2 = (AVURLAsset *)asset;
            if ([asset1.URL isEqual:asset2.URL]) {
                NSLog(@"asset1.URL = %@",asset1.URL);
                NSLog(@"asset2.URL = %@",asset2.URL);
                [self.playerItem removeObserver:self forKeyPath:kStatusKey];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
                self.playerItem = nil;
                NSLog(@"self.playerItem Redefine");
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
        
        
        if (![self player]) {
            NSLog(@"");
            [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];
            [self.player addObserver:self
                          forKeyPath:kCurrentItemKey
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:AVPlayerCurrentItemObservationContext];
        }
        
        if (self.player.currentItem != self.playerItem) {
            NSLog(@"");
            [[self player] replaceCurrentItemWithPlayerItem:self.playerItem];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException = %@",exception);
    }
}

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    if (context == AVPlayerStatusObservationContext) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"self address = %@",self);
            [self.player setMuted:NO];
            [self.player play];
        }
    }
    else if (context == AVPlayerCurrentItemObservationContext) {
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


-(IBAction)onBtnMoviePlay:(id)sender {
    // 플레이 효율코드
    if([self.target isLiveBrd]) {
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_L-PLAY")];
    }
    else {
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_L_D-PLAY")];
    }
    [self playMoviePlayer:nil];
}


//생방송 재생
-(void)playrequestLiveVideo: (NSString*)requrl {
    //생방송 영상
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    NSString *strReqURL = nil;
    if ([NCS([self.dicRow  objectForKey:@"insuYn"]) isEqualToString:@"Y"]) {
        strReqURL = [NSString stringWithFormat:@"toapp://livestreaming?url=%@&targeturl=",requrl];
    }
    else {
        strReqURL = [NSString stringWithFormat:@"toapp://livestreaming?url=%@&targeturl=%@",requrl,NCS([self.dicRow objectForKey:@"linkUrl"])];
    }
    
    Mocha_MPViewController *vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:strReqURL];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(playbackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:vc.moviePlayerController];
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    vc.isLandScapeOnly = YES;
    vc.isAutoStart = YES;
    
    if([NCS([self.dicRow objectForKey:@"mainPrdImgUrl"]) length] > 0) {
        vc.strPrdImageURL = NCS([self.dicRow objectForKey:@"mainPrdImgUrl"]);
    }
    else {
        vc.strPrdImageURL = NCS([self.dicRow objectForKey:@"subPrdImgUrl"]);
    }

    
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
    [vc playMovie:[NSURL URLWithString:requrl]];
}

//전체화면에서 페이지 이동시
-(void)goWebView:(NSString *)url {
    NSLog(@"url = %@",url);
    @try {
        [self onBtnGoLinkUrl:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"exception = %@",exception);
    }
}

/*
- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index {
    if(alert.tag == 777) {
        switch (index) {
            case 1:
                //생방송 영상재생? 예
                [self playrequestLiveVideo:self.curRequestString];
                break;
            default:
                break;
        }
    }
    else if(alert.tag == 888) {
        if (index == 1) {
            isAgree3G = YES;
            self.imgProduct.hidden = NO;
            [self mvPlayerInit];
        }
        else {
        }
    }
}
*/
- (IBAction)onBtn3GAlert:(id)sender{
    self.view3GAlert.hidden = YES;
    
    if ([((UIButton *)sender) tag] == 888) {
        [DataManager sharedManager].strGlobal3GAgree = @"Y";
        [self playMoviePlayer:nil];
        
    }else{
        self.viewBtnPlay.hidden = NO;
    }
}


//moviePlayerAdd

- (void)mvPlayerKillall {
    if ([self.reuseIdentifier isEqualToString:SCH_MAP_MUT_LIVETypeIdentifier]) {
        [self stopMoviePlayer];
    }
}


- (void)mvPlayerDealloc {
    @try {
        if (self.playerItem != nil) {
            NSLog(@"");
            [self.playerItem removeObserver:self forKeyPath:kStatusKey];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
            self.playerItem = nil;
        }
        
        if (self.player != nil) {
            NSLog(@"");
            [self.player removeObserver:self forKeyPath:kCurrentItemKey context:AVPlayerCurrentItemObservationContext];
            [self.player pause];
            self.player = nil;
        }
        
        if (self.playerView != nil) {
            NSLog(@"");
            [self.playerView removeFromSuperview];
            self.playerView = nil;
            NSLog(@"");
        }
        
        self.viewBtnPlay.hidden = NO;
        self.viewMPlayerArea.hidden = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"exceptionexception = %@",exception);
    }
}


- (void)mvPlayerInit {
    //휴먼애러로 메인동영상 셀이 어러개 들어올수 있음으로 다른 동영상은 정지하고 플레이 시작
    [[NSNotificationCenter defaultCenter] postNotificationName:SCHEDULELIVEVIDEOALLKILL object:nil userInfo:nil];
    if (self.playerView !=nil) {
        [self mvPlayerDealloc];
    }
    
    @try {
        self.playerView = [[AVPlayerPlayView alloc] init];
        self.playerView.frame = CGRectMake(0.0, 0, widthTableLeftProduct, (180.0/320.0) * widthTableLeftProduct);
        self.playerView.center = self.viewMPlayerArea.center;
        self.playerView.backgroundColor = [UIColor blackColor];
        [self.viewMPlayerArea insertSubview:self.playerView atIndex:0];
        self.viewMPlayerArea.hidden = NO;
        self.viewBtnPlay.hidden = YES;
        self.URL = [NSURL URLWithString:self.curRequestString];
        
        //벳지 제거
        self.viewBenefit01.hidden = YES;
        self.viewBenefit02.hidden = YES;
        self.viewBenefit03.hidden = YES;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)stopMoviePlayer {
    //방종여부 확인 필요
    if([self.lblTimer.text isEqualToString:GSSLocalizedString(@"home_tv_live_view_close_text")]){
        self.btnPlay.hidden = YES;
    }
    else {
        self.btnPlay.hidden = NO;
    }
    self.viewBtnPlay.hidden = NO;
    self.viewMPlayerArea.hidden = YES;
    self.viewDimmed.alpha = 0.0;
    self.viewMPlayerArea.alpha = 1.0;
    [self mvPlayerDealloc];
    //벳지 제거
    self.viewBenefit01.hidden = NO;
    self.viewBenefit02.hidden = NO;
    self.viewBenefit03.hidden = NO;
    
    /*
    // 백그라운드 음악 재생
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:&error];
     */
}


- (void)playMoviePlayer:(id)sender {
    
    if([NetworkManager.shared currentReachabilityStatus] !=  NetworkReachabilityStatusViaWiFi) {
        if ([[DataManager sharedManager].strGlobal3GAgree isEqualToString:@"N"]) {
            self.view3GAlert.hidden = NO;
            self.viewBtnPlay.hidden = YES;
            return;
        }
    }
    self.imgProduct.hidden = NO;
    [self mvPlayerInit];
}

- (void)setURL:(NSURL*)URL {
    _URL = [URL copy];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:_URL options:nil];
    NSArray *requestedKeys = [NSArray arrayWithObjects:@"tracks", @"playable", nil];
    [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
     ^{
         dispatch_async( dispatch_get_main_queue(),
                        ^{
                            [self prepareToPlayAsset:asset withKeys:requestedKeys];
                        });
     }];
}

- (NSURL*)URL {
    return _URL;
}



@end
