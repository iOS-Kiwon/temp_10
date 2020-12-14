//
//  SCH_MAP_MUT_SUBTypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 17..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SCH_MAP_MUT_SUBTypeCell.h"
#import "SListTBViewController.h"

@implementation SCH_MAP_MUT_SUBTypeCell
@synthesize prdImage,InfoDimme,InfoDimmeText,alarmOffImg,alarmOnImg,buyNowText,buyNow,alarmView,target;
@synthesize lconstAlarmTrailing;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.lblBasePrice.hidden = YES;
    self.lblBasePriceWon.hidden = YES;
    self.viewBasePriceStrikeLine.hidden = YES;
    self.lblPerMonth.hidden = YES;
    self.lblSalePrice.hidden = YES;
    self.lblSalePriceWon.hidden = YES;
    self.lblCounsel.hidden = YES;
    
    //self.ProductName.numberOfLines = 2;
    self.viewImageBorder.layer.borderWidth = 1.0;
    self.viewImageBorder.layer.shouldRasterize = YES;
    self.viewImageBorder.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewImageBorder.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.06].CGColor;
    //self.viewBottomLine.hidden = YES;
    self.lconstAlarmTrailing.constant = 77.0;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.alarmOnImg.hidden = NO;
    self.alarmOffImg.hidden = NO;
    self.InfoDimme.hidden = YES;
    self.InfoDimmeText.text = @"";
//    self.ProductName.text = @"";
    self.prdImage.image = nil;
//    self.Price.text =  @"";
//    self.PriceText.text = @"";
    self.buyNowText.text = @"";
    self.buyNow.hidden = YES;
    self.alarmView.hidden = YES;
    //self.viewBottomLine.hidden = YES;
    self.lconstAlarmTrailing.constant = 77.0;

    self.lblBasePrice.hidden = YES;
    self.lblBasePrice.text = @"";
    self.lblBasePriceWon.hidden = YES;
    //self.lblBasePriceWon.text = @"";
    self.viewBasePriceStrikeLine.hidden = YES;
    self.lblPerMonth.hidden = YES;
    self.lblPerMonth.text = @"";
    self.lblSalePrice.hidden = YES;
    self.lblSalePrice.text = @"";
    self.lblSalePriceWon.hidden = YES;
    self.lblSalePriceWon.text = @"";
    self.lblCounsel.hidden = YES;
    self.lblCounsel.text = @"";
    self.lblReview.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
    self.lblBenefit.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
    
}


- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    if(NCO(rowinfoArr)) {
        infoDic = rowinfoArr;
        if( !NCO([infoDic objectForKey:@"product"])) {
            return;
        }
        
        self.dicRow = [infoDic objectForKey:@"product"];
        
        NSString *imageURL = NCS([[infoDic objectForKey:@"product"] objectForKey:@"subPrdImgUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        self.prdImage.image = fetchedImage;
                    }
                    else {
                        self.prdImage.alpha = 0;
                        self.prdImage.image = fetchedImage;                    
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             self.prdImage.alpha = 1;
                                         }
                                         completion:^(BOOL finished) {
                                         }];
                    }
                });
            }
        }];

        
        CGFloat heightProductInfoArea = 0.0;
        
        self.lconstPerMonthMargine.constant = 0.0;

        if ([NCS([self.dicRow objectForKey:@"rentalYn"]) isEqualToString:@"Y"] ||
                 [NCS([self.dicRow objectForKey:@"cellPhoneYn"]) isEqualToString:@"Y"]) {
         
            if([NCS([self.dicRow objectForKey:@"rentalYn"]) isEqualToString:@"Y"]) {  //렌탈
                heightProductInfoArea = heightProductInfoArea + 27;
                self.lblPerMonth.hidden = NO;
                self.lblSalePrice.hidden = NO;
                self.lblDiscountRate.hidden = YES;
                self.lblBasePrice.hidden = YES;
                
                NSString *rentalText = NCS([self.dicRow objectForKey:@"rentalText"]);
                NSString *rentalPrice = NCS([self.dicRow objectForKey:@"rentalPrice"]);
                
                if (rentalText.length > 0) {
                    
                    if ([@"월 렌탈료" isEqualToString:rentalText] || [@"월" isEqualToString:rentalText] ) {
                        self.lblPerMonth.text = @"월";
                        self.lconstPerMonthMargine.constant = 3.0;
                        if ( [rentalPrice length] > 0 && [rentalPrice hasPrefix:@"0"] == NO ) {
                            self.lblSalePrice.text = rentalPrice;
                        }
                        else {
                            self.lblSalePrice.text = @"";
                            self.lblPerMonth.text = GSSLocalizedString(@"home_tv_live_councel_text");
                        }
                    }
                    else { //rentalText 비어있음
                        //렌탈인데 월이 아니면,
                        if ( [rentalPrice length] > 0 && [rentalPrice hasPrefix:@"0"] == NO ) {
                            self.lblSalePrice.text = rentalPrice;
                        }
                        else {
                            self.lblSalePrice.text = @"";
                            self.lblPerMonth.text = GSSLocalizedString(@"home_tv_live_councel_text");
                        }
                    }
                }
                else if ( [rentalPrice length] > 0 && [rentalPrice hasPrefix:@"0"] == NO ) {
                    self.lblSalePrice.text = rentalPrice;
                }
                else {
                    self.lblSalePrice.text = @"";
                    self.lblPerMonth.text = GSSLocalizedString(@"home_tv_live_councel_text");
                }
                    
                
            }
        }
        else {

            CGFloat widthLineCut = WIDTH_LIMIT_TV_SUB;
            CGFloat widthTotal = 0.0;
            //CGFloat offsetXBasePrice = 0.0;
            
            if ([NCS([self.dicRow objectForKey:@"priceMarkUpType"]) isEqualToString:@"RATE"] && [NCS([self.dicRow objectForKey:@"priceMarkUp"]) length] > 0 ) {
                self.lblDiscountRate.text = [NSString stringWithFormat:@"%@%%",NCS([self.dicRow objectForKey:@"priceMarkUp"])];
                self.lconstBasePriceLeading.constant = 3;
            }else{
                self.lblDiscountRate.text = @"";
                self.lconstBasePriceLeading.constant = 0;
            }
            
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
                self.lblBasePrice.hidden = NO;
                self.lblBasePriceWon.hidden = NO;
                self.viewBasePriceStrikeLine.hidden = NO;
                self.lblBasePrice.text = NCS([self.dicRow objectForKey:@"salePrice"]);
            }
            
            
            
            CGSize sizeSalePrice = [self.lblSalePrice.text MochaSizeWithFont: self.lblSalePrice.font constrainedToSize:CGSizeMake(APPFULLWIDTH, self.lblSalePrice.frame.size.height) lineBreakMode:NSLineBreakByClipping];
            
            CGSize sizeSalePriceWon = [self.lblSalePriceWon.text MochaSizeWithFont: self.lblSalePriceWon.font constrainedToSize:CGSizeMake(APPFULLWIDTH, self.lblSalePriceWon.frame.size.height) lineBreakMode:NSLineBreakByClipping];
            
            CGSize sizeDiscountRate = [self.lblDiscountRate.text MochaSizeWithFont: self.lblDiscountRate.font constrainedToSize:CGSizeMake(APPFULLWIDTH, self.lblDiscountRate.frame.size.height) lineBreakMode:NSLineBreakByClipping];
            
            CGSize sizeBasePrice = [self.lblBasePrice.text MochaSizeWithFont: self.lblBasePrice.font constrainedToSize:CGSizeMake(APPFULLWIDTH, self.lblBasePrice.frame.size.height) lineBreakMode:NSLineBreakByClipping];
            
            CGSize sizeBasePriceWon = [self.lblBasePriceWon.text MochaSizeWithFont: self.lblBasePriceWon.font constrainedToSize:CGSizeMake(APPFULLWIDTH, self.lblBasePriceWon.frame.size.height) lineBreakMode:NSLineBreakByClipping];
            
            widthTotal = sizeSalePrice.width + sizeSalePriceWon.width + 3.0 + sizeDiscountRate.width + self.lconstBasePriceLeading.constant + sizeBasePrice.width + sizeBasePriceWon.width;

            if (self.lconstDisRateLeading != nil) {
                [self.viewPricesArea removeConstraint:self.lconstDisRateLeading];
                self.lconstDisRateLeading = nil;
            }
            
            if (self.lconstDisRateTop != nil) {
                [self.viewPricesArea removeConstraint:self.lconstDisRateTop];
                self.lconstDisRateTop = nil;
            }
            
            //금액이 커서 할인율과 베이스가를 줄바꿈함
            if (widthLineCut < widthTotal) {
                //2줄표시
                self.lconstDisRateLeading = [NSLayoutConstraint constraintWithItem:self.lblDiscountRate
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.viewPricesArea
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:12.0];
                [self.viewPricesArea addConstraint:self.lconstDisRateLeading];
                
                
                self.lconstDisRateTop = [NSLayoutConstraint constraintWithItem:self.lblSalePrice attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.lblDiscountRate attribute:NSLayoutAttributeTop multiplier:1 constant:0];
                
                [self.viewPricesArea addConstraint:self.lconstDisRateTop];
                                
                
            }
            else {
                //1줄표시
                self.lconstDisRateLeading = [NSLayoutConstraint constraintWithItem:self.lblDiscountRate
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.lblSalePriceWon
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1
                                                                          constant:3.0];
                [self.viewPricesArea addConstraint:self.lconstDisRateLeading];
                
                self.lconstDisRateTop = [NSLayoutConstraint constraintWithItem:self.lblSalePrice attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.lblDiscountRate attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
                
                [self.viewPricesArea addConstraint:self.lconstDisRateTop];
            }
            
            [self.viewPricesArea layoutIfNeeded];
        }
   
        if ([NCS([[infoDic objectForKey:@"product"] objectForKey:@"imageLayerFlag"]) length] > 0) {
            self.InfoDimme.hidden = NO;
            self.lconstInfoHeight.constant = 24.0;
            NSString *strFlag = @"";
            if ([NCS([[infoDic objectForKey:@"product"] objectForKey:@"imageLayerFlag"]) isEqualToString:@"AIR_BUY"]) {
                strFlag = @"방송중 구매가능";
                
                //self.btnProduct.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@ %@합니다.",NCS(self.lblProductTitle.text),NCS(self.Price.text),NCS(self.PriceText.text),strFlag];
                
            }
            else if ([NCS([[infoDic objectForKey:@"product"] objectForKey:@"imageLayerFlag"]) isEqualToString:@"SOLD_OUT"]) {
                strFlag = @"일시품절";
                //self.btnProduct.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@ %@되었습니다.",NCS(self.ProductName.text),NCS(self.Price.text),NCS(self.PriceText.text),strFlag];
            }
            else {
                self.InfoDimme.hidden = YES;
            }
            self.InfoDimmeText.text = strFlag;
        }
        else {
            self.InfoDimme.hidden = YES;
            self.lconstInfoHeight.constant = 0.0;
        }
        
        if ([NCS([[infoDic objectForKey:@"product"] objectForKey:@"broadTimeText"]) length] > 0) {
            self.viewBroadTime.hidden = NO;
            self.lconstBroadTimeHeight.constant = 24.0;
            self.lblBroadTime.text = NCS([[infoDic objectForKey:@"product"] objectForKey:@"broadTimeText"]);
        }
        else {
            self.viewBroadTime.hidden = YES;
            self.lconstBroadTimeHeight.constant = 0.0;
        }
        
        self.viewPlayBtn.hidden = YES;
        self.lconstPlayBtnBottom.constant = -(self.lconstInfoHeight.constant + self.lconstBroadTimeHeight.constant);
        
        /*
        self.InfoDimme.hidden = NO;
        self.lconstInfoHeight.constant = 24.0;
        self.InfoDimmeText.text = @"방송중 구매가능";
        
        self.viewBroadTime.hidden = NO;
        self.lconstBroadTimeHeight.constant = 24.0;
        self.lblBroadTime.text = @"08.24(토) 9:20 방송";
        
        self.viewPlayBtn.hidden = NO;
        self.lconstPlayBtnBottom.constant = -(self.lconstInfoHeight.constant + self.lconstBroadTimeHeight.constant);
        */
        
        
        self.lblProductTitle.attributedText = [Common_Util attributedProductTitle:self.dicRow titleKey:@"exposPrdName"];
        
        
        
        
        /*
        //바로구매 버튼
        if( NCO([[infoDic objectForKey:@"product"] objectForKey:@"directOrdInfo"]) ) {
            self.lconstAlarmTrailing.constant = 77.0;
            self.buyNowText.text = NCS([[[infoDic objectForKey:@"product"] objectForKey:@"directOrdInfo"] objectForKey:@"text"]);
            self.btnDirectOrd.accessibilityLabel = NCS([[[infoDic objectForKey:@"product"] objectForKey:@"directOrdInfo"] objectForKey:@"text"]);
            self.buyNow.hidden = NO;
        }
        else {
            self.lconstAlarmTrailing.constant = 10.0;
            self.buyNowText.text = @"";
            self.buyNow.hidden = YES;
        }
        */
        
        //보험및 공영일때 상품명만 노출 //insuYn, publicBroadYn,
        if( [NCS([[infoDic objectForKey:@"product"] objectForKey:@"insuYn"]) isEqualToString:@"Y"] ) {
            //self.Price.hidden = YES;
            self.buyNow.hidden = YES;
            self.alarmView.hidden = YES;
            self.buyNow.hidden = YES;
        }
        
        if( [NCS([[infoDic objectForKey:@"product"] objectForKey:@"publicBroadYn"]) isEqualToString:@"Y"] ) {
            //self.Price.hidden = YES;
            self.buyNow.hidden = YES;
            self.alarmView.hidden = YES;
            self.buyNow.hidden = YES;
        }
    }

    self.lblBenefit.attributedText = [Common_Util attributedBenefitString:self.dicRow widthLimit:WIDTH_LIMIT_TV_SUB lineLimit:2];
    
//    CGRect rectBene = [self.lblBenefit.attributedText boundingRectWithSize:CGSizeMake(WIDTH_LIMIT_TV_SUB, 500.0) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
//    NSLog(@"WIDTH_LIMIT_TV_SUB_BENEFIT = %f",WIDTH_LIMIT_TV_SUB_BENEFIT);
//    NSLog(@"rectBenerectBene2 = %@",NSStringFromCGRect(rectBene));
    
    self.lblReview.attributedText = [Common_Util attributedReview:self.dicRow isWidth320Cut:NO];

    [self.viewBackGround layoutIfNeeded];
    [self layoutIfNeeded];

    NSLog(@"self.lblDiscountRate.frame = %@",NSStringFromCGRect(self.lblDiscountRate.frame));
    NSLog(@"self.lblSalePrice.frame = %@",NSStringFromCGRect(self.lblSalePrice.frame));
    NSLog(@"self.lblProductTitle.frame = %@",NSStringFromCGRect(self.lblProductTitle.frame));
    NSLog(@"self.lblBenefit.frame = %@",NSStringFromCGRect(self.lblBenefit.frame));
    NSLog(@"self.lblReview.frame = %@",NSStringFromCGRect(self.lblReview.frame));
//    최하단 리뷰 프레임은 최종적으로다시 조정됨
    
    self.btnProduct.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS(self.lblProductTitle.text), NCS(self.lblSalePrice.text) ,NCS(self.lblSalePriceWon.text)];
}

- (void)alarmOn:(BOOL) isOn {
    self.btnAlarm.selected = isOn;
}


- (IBAction)onClick:(id)sender {
    //상세보기 이동
    if(self.target) {
        if ([self.target respondsToSelector:@selector(touchEventTBCell:)]) {
            [self.target touchEventTBCell:[infoDic objectForKey:@"product"]];
        }
    }
}


- (IBAction)onAlramClick:(id)sender {
    NSMutableDictionary *dicAlarm = [[NSMutableDictionary alloc] init];
    [dicAlarm addEntriesFromDictionary:[infoDic objectForKey:@"product"]];
    [dicAlarm setObject:NCS([[infoDic objectForKey:@"product"] objectForKey:@"exposPrdName"]) forKey:@"prdName"];
    
    if ([NCS([[infoDic objectForKey:@"product"] objectForKey:@"broadAlarmDoneYn"]) length] > 0 && [NCS([[infoDic objectForKey:@"product"] objectForKey:@"broadAlarmDoneYn"]) isEqualToString:@"Y"]) {
        
        if([self.target respondsToSelector:@selector(requestAlarmWithDic:andProcess:andPeroid:andCount:)]){
            [self.target requestAlarmWithDic:dicAlarm andProcess:TVS_ALARMDELETE andPeroid:@"" andCount:@""];
        }
        
        
    }
    else {
        if([self.target respondsToSelector:@selector(requestAlarmWithDic:andProcess:andPeroid:andCount:)]){
            [self.target requestAlarmWithDic:dicAlarm andProcess:TVS_ALARMINFO andPeroid:@"" andCount:@""];
        }
    }
}

- (IBAction)onBuyNowClick:(id)sender {
    //바로구매 클릭
    if (NCO([infoDic objectForKey:@"product"]) && NCO([[infoDic objectForKey:@"product"] objectForKey:@"directOrdInfo"])) {
        if([self.target respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]){
            [self.target touchEventTBCellJustLinkStr:NCS([[[infoDic objectForKey:@"product"] objectForKey:@"directOrdInfo"] objectForKey:@"linkUrl"])];
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

- (void) setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}


@end
