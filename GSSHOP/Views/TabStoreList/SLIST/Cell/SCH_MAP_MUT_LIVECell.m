//
//  SCH_MAP_MUT_LIVECell.m
//  GSSHOP
//
//  Created by gsshop iOS on 06/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "SCH_MAP_MUT_LIVECell.h"
#import "SListTBViewController.h"

@implementation SCH_MAP_MUT_LIVECell
@synthesize indexPathNow;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.isLivePlay = NO;
    self.backgroundColor = [UIColor clearColor];
    self.imgProduct.hidden = YES;
    self.lblBasePrice.hidden = YES;
    self.lblBasePriceWon.hidden = YES;
    self.viewBasePriceStrikeLine.hidden = YES;
    self.lblPerMonth.hidden = YES;
    self.lblSalePrice.hidden = YES;
    self.lblSalePriceWon.hidden = YES;
    
    self.viewImageArea.layer.borderColor = [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.06].CGColor;
    self.viewImageArea.layer.borderWidth = 1.0;
    
    self.viewLeftTime.layer.cornerRadius = self.viewLeftTime.frame.size.height/2.0;
    self.viewLeftTime.layer.shouldRasterize = YES;
    self.viewLeftTime.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.lblTimer.font = [UIFont monospacedDigitSystemFontOfSize:14.0 weight:UIFontWeightRegular];
    
    self.viewLiveTalk.layer.borderColor = [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.2].CGColor;
    self.viewLiveTalk.layer.borderWidth = 1.0;
    self.viewLiveTalk.layer.cornerRadius = 2.0;
    self.viewLiveTalk.layer.shouldRasterize = YES;
    self.viewLiveTalk.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.viewAlarm.layer.borderColor = [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.2].CGColor;
    self.viewAlarm.layer.borderWidth = 1.0;
    self.viewAlarm.layer.cornerRadius = 2.0;
    self.viewAlarm.layer.shouldRasterize = YES;
    self.viewAlarm.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.viewDirectOrd.layer.cornerRadius = 2.0;
    self.viewDirectOrd.layer.shouldRasterize = YES;
    self.viewDirectOrd.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [self.imgProduct setBorderWithWidth:1.0 color:@"000000"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)prepareForReuse {
    [super prepareForReuse];
    [self initViewObject];
}

-(void)initViewObject {
    self.backgroundColor = [UIColor clearColor];
    //self.viewMPlayerArea.hidden = YES;
    //    self.viewScreenBtn.hidden = YES;
    self.lblBasePrice.hidden = YES;
    self.lblBasePrice.text = @"";
    self.lblBasePriceWon.hidden = YES;
    self.lblBasePriceWon.text = @"";
    self.viewBasePriceStrikeLine.hidden = YES;
    self.imgProduct.hidden = YES;
    self.lblPerMonth.hidden = YES;
    self.lblPerMonth.text = @"";
    self.lblSalePrice.hidden = YES;
    self.lblSalePrice.text = @"";
    self.lblSalePriceWon.hidden = YES;
    self.lblSalePriceWon.text = @"";
    self.lblTimer.text = @"";
    self.imgOnAir.hidden = YES;
    self.lconstViewTopPromotion.constant = 26.0;
    self.isLivePlay = NO;
    
    self.lconstViewTopHeight.constant = 50.0;
    
    self.lblTopBenefit.text = @"";
    self.imgNoImg.hidden = NO;
    
    if ([timerLive isValid]) {
        [timerLive invalidate];
        timerLive = nil;
    }
}


- (void) dealloc {
    
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
    
    
    // Show Message
    NSDictionary *nomalTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                    };
    
    NSDictionary *pipeTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName : [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2]
                                   };
    
    NSDictionary *boldTextAttr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]
                                   };
    
    
    
    
    
    if ([NCS([self.dicAll objectForKey:@"startTime"]) length] > 0) {
        
        self.lconstViewTopHeight.constant = 50.0;
        self.viewTopPromotion.hidden = NO;
        NSString *strStartTime = [self.dicAll objectForKey:@"startTime"];
        //NSString *strBroadTime = [NSString stringWithFormat:@"%@:%@",[strStartTime substringWithRange:NSMakeRange(8, 2)],[strStartTime substringWithRange:NSMakeRange(10, 2)]];
        
        //NSString *strBroadTime = NCS([self.dicAll objectForKey:@"startTime"]);
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc]initWithString:strStartTime attributes:nomalTextAttr];
        
        NSError *error             = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9:]" options:0 error:&error];
        NSArray *arrMatch = [regex matchesInString:strStartTime options:NSMatchingReportCompletion range:NSMakeRange(0, strStartTime.length)];
        
        //NSLog(@"arrMatch = %@",arrMatch);
        
        if ([arrMatch count] > 0) {
            for (NSTextCheckingResult *resultMatch in arrMatch) {
                [strAttr setAttributes:boldTextAttr range:resultMatch.range];
            }
        }
        
        if ([NCS([self.dicAll objectForKey:@"specialPgmYn"]) isEqualToString:@"Y"] && NCO([self.dicAll objectForKey:@"specialPgmInfo"])) {
            
            NSDictionary *dicPGM = [self.dicAll objectForKey:@"specialPgmInfo"];
            NSString *strPgmName = NCS([dicPGM objectForKey:@"text"]);
            NSAttributedString *strAttrPipe = [[NSAttributedString alloc] initWithString:@" | " attributes:pipeTextAttr];
            NSAttributedString *strAttrPGM = [[NSAttributedString alloc] initWithString:strPgmName attributes:nomalTextAttr];
            
            [strAttr appendAttributedString:strAttrPipe];
            [strAttr appendAttributedString:strAttrPGM];
        }
        
        self.lblTopTimeTitle.attributedText = strAttr;
        
        CGRect rectTopPGM = [strAttr boundingRectWithSize:CGSizeMake(APPFULLWIDTH, 17.0) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        
        self.lconstTopBeneWidth.constant = (APPFULLWIDTH - rectTopPGM.size.width - 26.0 - 16.0 );
        
        if ([NCS([self.dicAll objectForKey:@"liveBenefitLText"]) length] > 0 || [NCS([self.dicAll objectForKey:@"liveBenefitRText"]) length] > 0) {
            
            NSMutableString *strTopBene = [[NSMutableString alloc] initWithString:@""];
            
            if ([NCS([self.dicAll objectForKey:@"liveBenefitLText"]) length] > 0) {
                [strTopBene appendString:NCS([self.dicAll objectForKey:@"liveBenefitLText"])];
            }
            
            if ([NCS([self.dicAll objectForKey:@"liveBenefitRText"]) length] > 0) {
                if ([strTopBene length] > 0) {
                    [strTopBene appendString:@" "];
                }
                [strTopBene appendString:NCS([self.dicAll objectForKey:@"liveBenefitRText"])];
            }
            
            self.lblTopBenefit.text = strTopBene;
        }
        
    }else{
        self.viewTopPromotion.hidden = YES;
        self.lconstViewTopHeight.constant = 16.0;
    }
    
    
    
    
    [self.lblTopTimeTitle layoutIfNeeded];
    [self.viewTopPromotion layoutIfNeeded];
    
    
    
    
    if([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"SCH_MAP_MUT_LIVE"]) {
        if (NCO([self.dicAll objectForKey:@"livePlayInfo"]) && [NCS([[self.dicAll objectForKey:@"livePlayInfo"] objectForKey:@"linkUrl"]) length] > 0) {
            self.isLivePlay = YES;
            self.imgOnAir.hidden = NO;
            self.lconstViewTopPromotion.constant = 44.0;
        }
        
        if ([NCS([self.dicAll  objectForKey:@"publicBroadYn"]) isEqualToString:@"Y"] || [NCS([self.dicRow  objectForKey:@"insuYn"]) isEqualToString:@"Y"] || [NCS([self.dicRow objectForKey:@"linkUrl"]) length] == 0) {
            //이동할 링크가 없으면 hidden YES
            //            self.lconstCenterBtnFullScr.constant = 0.0;
            //            self.btnGOLink.hidden = YES;
        }
        else{
            //이동할 링크가 있을경우에만 동영상 플레이어 화면의 링크이동을 활성화
            //            self.lconstCenterBtnFullScr.constant = -56.0;
            //            self.btnGOLink.hidden = NO;
        }
    }
    else {
        //        self.viewPrdDimmed.hidden = YES;
        //        self.viewPrdWhiteDimmed.hidden = NO;
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
                
                if(fetchedImage == nil)
                {
                    self.imageURL = NCS([self.dicRow objectForKey:@"subPrdImgUrl"]);
                    
                    [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                        if(error == nil  && [self.imageURL isEqualToString:strInputURL]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (isInCache) {
                                    self.imgProduct.image = fetchedImage;
                                }
                                else {
                                    
                                    self.imgProduct.alpha = 0;
                                    self.imgProduct.image = fetchedImage;
                                }
                                
                                
                                if(fetchedImage != nil)
                                {
                                    [UIView animateWithDuration:0.2f
                                                          delay:0.0f
                                                        options:UIViewAnimationOptionCurveEaseInOut
                                                     animations:^{
                                                         self.imgProduct.alpha = 1;
                                                     }
                                                     completion:^(BOOL finished) {
                                                         self.imgNoImg.hidden = YES;
                                                     }];
                                }
                                else
                                {
                                    self.imgNoImg.hidden = NO;
                                }
                                
                            });
                            
                        }
                        
                    }];
                    
                }
                else
                {
                    if (isInCache) {
                        self.imgProduct.image = fetchedImage;
                    }
                    else {
                        
                        self.imgProduct.alpha = 0;
                        self.imgProduct.image = fetchedImage;
                    }
                }
                [UIView animateWithDuration:0.2f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     self.imgProduct.alpha = 1;
                                 }
                                 completion:^(BOOL finished) {
                                     self.imgNoImg.hidden = YES;
                                 }];
            });
        }
    }];
    
    
    if ([NCS([self.dicRow objectForKey:@"priceMarkUpType"]) isEqualToString:@"RATE"] && [NCS([self.dicRow objectForKey:@"priceMarkUp"]) length] > 0 ) {
        self.lblDiscountRate.text = [NSString stringWithFormat:@"%@%%",NCS([self.dicRow objectForKey:@"priceMarkUp"])];
        self.lconstBasePriceLeading.constant = 3;
    }else{
        self.lblDiscountRate.text = @"";
        self.lconstBasePriceLeading.constant = 0;
    }
    
    
    self.lblProductTitle.attributedText = [Common_Util attributedProductTitle:self.dicRow titleKey:@"exposPrdName"];
    
    self.lblReview.attributedText = [Common_Util attributedReview:self.dicRow isWidth320Cut:YES];
    
    self.lconstPriceViewHeight.constant = SCH_MAP_MUT_LIVE_heightPriceArea;
    
    self.lconstPerMonthMargine.constant = 0.0;
    
    if ([NCS([self.dicAll  objectForKey:@"publicBroadYn"]) isEqualToString:@"Y"] || [NCS([self.dicRow  objectForKey:@"insuYn"]) isEqualToString:@"Y"]){
        self.lblSalePrice.hidden = YES;
        self.lblSalePriceWon.hidden = YES;
        self.lblPerMonth.hidden = YES;
        self.lblBasePrice.hidden = YES;
        self.lblBasePriceWon.hidden = YES;
        
        self.lconstPriceViewHeight.constant = SCH_MAP_MUT_LIVE_heightPriceArea - 30.0;
        
        //        self.btn_TVLinkPriceArea.accessibilityLabel = NCS([self.dicRow objectForKey:@"exposPrdName"]);
        
        //렌탈,휴대폰일때와 아닐때 ------ 상품 가격 영역 높이
    }
    else if ([NCS([self.dicRow objectForKey:@"rentalYn"]) isEqualToString:@"Y"]) {
        
        self.lblPerMonth.hidden = NO;
        self.lblSalePrice.hidden = NO;
        
        NSString *rentalText = NCS([self.dicRow objectForKey:@"rentalText"]);
        NSString *rentalPrice = NCS([self.dicRow objectForKey:@"rentalPrice"]);
        NSString *strVoiceOver = @"";
        
        if (rentalText.length > 0) {
            
            if ([@"월 렌탈료" isEqualToString:rentalText] || [@"월" isEqualToString:rentalText] ) {
                self.lblPerMonth.text = @"월";
                self.lconstPerMonthMargine.constant = 3.0;
                if ( [rentalPrice length] > 0 && [rentalPrice hasPrefix:@"0"] == NO ) {
                    self.lblSalePrice.text = rentalPrice;
                    strVoiceOver = [NSString stringWithFormat:@"월 %@",rentalPrice];
                }
                else {
                    self.lblSalePrice.text = @"";
                    self.lblPerMonth.text = GSSLocalizedString(@"home_tv_live_councel_text");
                    strVoiceOver = GSSLocalizedString(@"home_tv_live_councel_text");
                }                
            }
            else { //rentalText 비어있음
                //렌탈인데 월이 아니면,
                if ( [rentalPrice length] > 0 && [rentalPrice hasPrefix:@"0"] == NO ) {
                    self.lblSalePrice.text = rentalPrice;
                    self.lblPerMonth.text = @"";
                    strVoiceOver = rentalPrice;
                }
                else {
                    self.lblSalePrice.text = @"";
                    self.lblPerMonth.text = GSSLocalizedString(@"home_tv_live_councel_text");
                    strVoiceOver = GSSLocalizedString(@"home_tv_live_councel_text");
                }
            }
        }
        else if ( [rentalPrice length] > 0 && [rentalPrice hasPrefix:@"0"] == NO ) {
            self.lblSalePrice.text = rentalPrice;
            self.lblPerMonth.text = @"";
            strVoiceOver = rentalPrice;
        }
        else {
            self.lblSalePrice.text = @"";
            self.lblPerMonth.text = GSSLocalizedString(@"home_tv_live_councel_text");
            strVoiceOver = GSSLocalizedString(@"home_tv_live_councel_text");
        }
        
        self.btn_TVLinkPriceArea.accessibilityLabel = [NSString stringWithFormat:@"%@ %@",NCS(self.lblProductTitle.text),strVoiceOver];
        
        self.btn_TVLink.accessibilityLabel = [NSString stringWithFormat:@"%@ %@",NCS(self.lblProductTitle.text),strVoiceOver];
        
    }
    else {
        
        self.lblSalePrice.hidden = NO;
        self.lblSalePriceWon.hidden = NO;
        self.lblSalePrice.text = NCS([self.dicRow objectForKey:@"broadPrice"]);
        self.lblSalePriceWon.text = NCS([self.dicRow objectForKey:@"exposePriceText"]);
        if([NCS([self.dicRow objectForKey:@"salePrice"]) isEqualToString:@"0"] || [NCS([self.dicRow objectForKey:@"salePrice"]) length] == 0) {
            //45,36 가격 top
            //self.lconstSalePriceTopMargin.constant = 38.5;//36.0;
        }
        else {
            //self.lconstSalePriceTopMargin.constant = 45.0;
            //할인율 없으면... 베이스도 없어야함.
            if([NCS(self.lblDiscountRate.text) length] > 0) {
                self.lblBasePrice.hidden = NO;
                self.lblBasePriceWon.hidden = NO;
                self.viewBasePriceStrikeLine.hidden = NO;
                self.lblBasePrice.text = NCS([self.dicRow objectForKey:@"salePrice"]);
                self.lblBasePriceWon.text = NCS([self.dicRow objectForKey:@"exposePriceText"]);
            }
            else {
                //할인율 없으면 기본가 비노출
                self.lblBasePrice.hidden = YES;
                self.lblBasePriceWon.hidden = YES;
                self.viewBasePriceStrikeLine.hidden = YES;
            }
        }
        
        self.btn_TVLinkPriceArea.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS(self.lblProductTitle.text), NCS(self.lblSalePrice.text) ,NCS(self.lblSalePriceWon.text)];
        
        self.btn_TVLink.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS(self.lblProductTitle.text), NCS(self.lblSalePrice.text) ,NCS(self.lblSalePriceWon.text)];
        
    }
    
    //        self.btn_TVLinkPriceArea.accessibilityLabel = [NSString stringWithFormat:@"%@ %@  %@",NCS([self.dicRow objectForKey:@"exposPrdName"]), NCS([self.dicRow objectForKey:@"broadPrice"]),NCS([self.dicRow objectForKey:@"exposePriceText"])];
    
    
    
    //self.lconstViewPriceAreaHeight.constant = heightProductInfoArea;
    
    
    CGFloat widthBenefitMod = 0;
    
    if ([NCS([self.dicAll  objectForKey:@"publicBroadYn"]) isEqualToString:@"Y"]) {
        
    }
    else {
        //self.viewBottomBtns.hidden = NO;
        
        BOOL isLiveTalk  = NO;
        BOOL isBroadAlarm  = NO;
        BOOL isDirectOrd  = NO;
        //버튼높이 계산
        if ([[self.dicAll objectForKey:@"viewType"] isEqualToString:@"SCH_MAP_MUT_LIVE"] && (NCO([self.dicAll objectForKey:@"liveTalkInfo"]) == YES) ) {
            //라이브톡 버튼 노출 여부 ,생방송일때만 노출하려고 개발중
            isLiveTalk = YES;
            self.viewLiveTalk.hidden = NO;
            
            widthBenefitMod = widthBenefitMod + 46.0;
        }
        else {
            self.viewLiveTalk.hidden = YES;
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
            
            widthBenefitMod = widthBenefitMod + 46.0;
        }
        else {
            self.btnAlarm.hidden = YES;
        }
        
        
        self.lconstViewAlarmTrailing.constant = 6.0;
        if ([NCS([self.dicRow objectForKey:@"imageLayerFlag"]) length] > 0) {
            isDirectOrd = YES;
            NSString *strFlag = @"";
            
            if ([NCS([self.dicRow objectForKey:@"imageLayerFlag"]) isEqualToString:@"AIR_BUY"]) {
                strFlag = @"방송중 구매가능";
                self.btnDirectOrd.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ 합니다.",NCS([self.dicRow objectForKey:@"exposPrdName"]),strFlag];
            }else if ([NCS([self.dicRow objectForKey:@"imageLayerFlag"]) isEqualToString:@"SOLD_OUT"]) {
                strFlag = @"일시품절";
                self.btnDirectOrd.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ 되었습니다.",NCS([self.dicRow objectForKey:@"exposPrdName"]),strFlag];
            }
            
            self.lblDirectOrd.text = strFlag;
            self.viewDirectOrd.backgroundColor = [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.4];
            
            [self.viewContents layoutIfNeeded];
            [self.viewDirectOrd layoutIfNeeded];
            
            widthBenefitMod = widthBenefitMod + self.btnDirectOrd.frame.size.width;
            
        }else{
            
            self.viewDirectOrd.hidden = YES;
            if (NCO([self.dicRow objectForKey:@"directOrdInfo"]) == YES && [NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"linkUrl"]) length] > 0 ) { // 바로구매 버튼 노출 여부
                isDirectOrd = YES;
                self.viewDirectOrd.hidden = NO;
                if ([NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"text"]) length] > 0) {
                    self.lblDirectOrd.text = NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"text"]);
                    self.btnDirectOrd.accessibilityLabel = NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"text"]);
                }else{
                    self.lblDirectOrd.text = @"구매하기";
                    self.btnDirectOrd.accessibilityLabel = @"구매하기";
                }

                self.viewDirectOrd.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:31.0/255.0 blue:96.0/255.0 alpha:1.0];

                [self.viewContents layoutIfNeeded];
                [self.viewDirectOrd layoutIfNeeded];
                widthBenefitMod = widthBenefitMod + self.btnDirectOrd.frame.size.width;

            }
            else {
                self.lblDirectOrd.text = @"";
                if (widthBenefitMod > 6.0) {
                    widthBenefitMod = widthBenefitMod - 6.0;
                }
                
                
                self.viewDirectOrd.hidden = YES;
                // 구매하기 버튼이 없음.. 여백 - 안쪽 텍스트 간격 까지 고려해서 뺌
                self.lconstViewAlarmTrailing.constant = -32.0;
                
            }
        }
        
        if (isLiveTalk || isBroadAlarm || isDirectOrd) {
            widthBenefitMod = widthBenefitMod + 10.0;
        }
        
    }
    
    
    
    CGFloat widthLblBenefit = APPFULLWIDTH - (16.0 + widthBenefitMod + 16.0);
    
    self.lblBenefit.attributedText = [Common_Util attributedBenefitString:self.dicRow widthLimit:widthLblBenefit lineLimit:2 fontSize:14.0];
    
    if(self.isLivePlay == YES){
        
        self.imgIconPlayOnly.hidden = YES;
        self.btnIconPlayOnly.hidden = YES;
        self.viewLeftTime.hidden = NO;
        self.btnLeftTime.hidden = NO;
        
        //방송 끝나는 시간 애러시 뷰 히든
        if([timerLive isValid]){
            [timerLive invalidate];
        }
        timerLive = nil;
        
        timerLive = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startLiveTimer) userInfo:nil repeats:YES];
        
        [self startLiveTimer];
        
    }else{
        
        self.viewLeftTime.hidden = YES;
        self.imgIconPlayOnly.hidden = YES;
        self.btnIconPlayOnly.hidden = YES;
        self.btnLeftTime.hidden = YES;
    }
    
    [self.viewImageArea layoutIfNeeded];
    [self.viewDefault layoutIfNeeded];
    [self layoutIfNeeded];
    
    UIBezierPath *maskPath_ph = [UIBezierPath bezierPathWithRoundedRect:self.viewTopPromotion.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(self.viewTopPromotion.frame.size.height, self.viewTopPromotion.frame.size.height)];
    CAShapeLayer *maskLayer_ph = [CAShapeLayer layer];
    maskLayer_ph.frame = self.viewTopPromotion.bounds;
    maskLayer_ph.path = maskPath_ph.CGPath;
    self.viewTopPromotion.layer.mask = maskLayer_ph;
    
    
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
        self.lconstViewTimerPlay.constant = 117.0;
        self.imgIconTimerPlay.hidden = NO;
        self.lblTimerNameum.hidden = NO;
    } else if(left <= 0) {
        callTemp = GSSLocalizedString(@"home_tv_live_view_close_text");
        self.lconstViewTimerPlay.constant = 61.0;
        self.imgIconTimerPlay.hidden = YES;
        self.lblTimerNameum.hidden = YES;
    } else {
        callTemp  = [NSString stringWithFormat:@"00:%02d:%02d", minite, second];
        self.lconstViewTimerPlay.constant = 117.0;
        self.imgIconTimerPlay.hidden = NO;
        self.lblTimerNameum.hidden = NO;
    }
    
    [self.viewLeftTime layoutIfNeeded];
    
    if([callTemp isEqualToString:GSSLocalizedString(@"home_tv_live_view_close_text")]){
        
        if ([timerLive isValid]) {
            [timerLive invalidate];
            NSLog(@"[timer invalidate]");
        }
        
        timerLive = nil;
        
        if ([self.target respondsToSelector:@selector(hideRightTimeLineOnImage:)]) {
            [self.target hideRightTimeLineOnImage:self.indexPathNow];
        }
        
    }
    
    
    return callTemp;
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
            
            NSString *strLinkUrl = NCS([[self.dicRow objectForKey:@"directOrdInfo"] objectForKey:@"linkUrl"]);
            
            //            if ([strLinkUrl length] == 0 && [NCS([self.dicRow objectForKey:@"imageLayerFlag"]) length] > 0 ) {
            //                strLinkUrl = NCS([self.dicRow objectForKey:@"linkUrl"]);
            //            }
            
            [self.target touchEventTBCellJustLinkStr:strLinkUrl];
        }
        
    }
    
}
-(IBAction)onBtnSpeBanner:(id)sender{
    NSDictionary *dicSpe = [self.dicAll objectForKey:@"specialPgmInfo"];
    if (NCO(dicSpe) == YES && [self.target respondsToSelector:@selector(touchEventTBCell:)]) {
        [self.target touchEventTBCell:dicSpe];
    }
}

-(IBAction)onBtnAlarm:(id)sender {
    
    // nami0342 - 생방송이 아닐 경우 (Live, Data 방송) 방송알림 효율 : A000323-V-AR (Live, Data 방송 구분 안 함)
    if(self.isLivePlay == YES)
    {
        if([self.target isLiveBrd]) {
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-C_LIVE-AR")];
        }else{
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-C_MYSHOP-AR")];
        }
    }
    else
    {
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-V-AR")];
    }
    
    
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
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-C_LIVE-TALK")];
    
    if (NCO([self.dicAll objectForKey:@"liveTalkInfo"])) { //2016.01 jin 라이브톡 프로토콜 추가
        if([self.target respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]) {
            [self.target touchEventTBCellJustLinkStr:NCS([[self.dicAll objectForKey:@"liveTalkInfo"] objectForKey:@"linkUrl"])];
        }
    }
}


-(IBAction)onBtnVodLink:(id)sender {
    if([self.target respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]) {
        NSString *strVodLink = NCS([self.dicRow objectForKey:@"playUrl"]);
        if(![strVodLink containsString:@"vodPlay="]) {
            strVodLink = [NSString stringWithFormat:@"%@&vodPlay=LIVE",NCS([self.dicRow objectForKey:@"playUrl"])];
        }
        [self.target touchEventTBCellJustLinkStr:strVodLink];
    }
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
@end
