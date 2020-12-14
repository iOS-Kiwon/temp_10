//
//  SectionBAN_IMG_C2_GBATypeCell.m
//  GSSHOP
//
//  Created by admin on 2018. 4. 10..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_IMG_C2_GBATypeCell.h"

#import "Common_Util.h"
#import "AppDelegate.h"
#import "Home_Main_ViewController.h"

@implementation SectionBAN_IMG_C2_GBATypeCell

@synthesize target;
@synthesize L_infoDic;
@synthesize R_infoDic;

@synthesize L_productImageView ,L_promotionName,L_productName,L_salePrice,L_exposePriceText,L_basePrice,L_basePrice_exposePriceText,L_basePriceCancelLine,L_TF,L_valuetext,L_air_on,L_reviewCount,L_viewBenefit01,L_viewBenefit02,L_viewBenefit03,L_imgBenefit01,L_imgBenefit02,L_imgBenefit03,L_lconstBenefitWidth01,L_lconstBenefitWidth02,L_lconstBenefitWidth03,L_tvTimeView,L_tvTimeText,L_lconstAirOnH,L_textBadgeInfo,L_viewPlay,L_lblPlayTime,L_btnPlay;

@synthesize R_productImageView ,R_promotionName,R_productName,R_salePrice,R_exposePriceText,R_basePrice,R_basePrice_exposePriceText,R_basePriceCancelLine,R_TF,R_valuetext,R_air_on,R_reviewCount,R_viewBenefit01,R_viewBenefit02,R_viewBenefit03,R_imgBenefit01,R_imgBenefit02,R_imgBenefit03,R_lconstBenefitWidth01,R_lconstBenefitWidth02,R_lconstBenefitWidth03,R_tvTimeView,R_tvTimeText,R_lconstAirOnH,R_textBadgeInfo,R_viewPlay,R_lblPlayTime,R_btnPlay;

@synthesize R_View,R_under_line;


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.L_btnPlay.accessibilityLabel = @"동영상 플레이";
    self.R_btnPlay.accessibilityLabel = @"동영상 플레이";
    
}


-(void) prepareForReuse {
    [super prepareForReuse];
    self.L_basePriceCancelLine.hidden = YES;
    self.L_basePrice.hidden = YES;
    self.L_basePrice_exposePriceText.hidden = YES;
    self.L_exposePriceText.hidden = YES;
    self.L_productName.hidden = YES;
    self.L_promotionName.hidden = YES;
    self.L_salePrice.hidden = YES;
    self.L_TF.hidden = YES;
    self.L_valuetext.hidden = YES;
    self.L_valuetext.text = @"";
    self.L_salePrice.text = @"";
    self.L_promotionName.text = @"";
    self.L_productName.text = @"";
    self.L_exposePriceText.text = @"";
    self.L_basePrice_exposePriceText.text = @"";
    self.L_basePrice.text = @"";
    self.L_productImageView.image = nil;
    self.L_air_on.hidden = YES;
    self.L_reviewCount.text = @"";
    self.L_reviewCount.hidden = YES;
    self.L_viewBenefit01.hidden = YES;
    self.L_viewBenefit02.hidden = YES;
    self.L_viewBenefit03.hidden = YES;
    self.L_imgBenefit01.image = nil;
    self.L_imgBenefit02.image = nil;
    self.L_imgBenefit03.image = nil;
    self.L_tvTimeText.text = @"";
    self.L_tvTimeView.hidden = YES;
    self.L_textBadgeInfo.text = @"";
    self.L_viewPlay.hidden = YES;
    self.L_btnPlay.hidden = YES;
    self.L_link.accessibilityLabel = @"";
    
    
    self.R_basePriceCancelLine.hidden = YES;
    self.R_basePrice.hidden = YES;
    self.R_basePrice_exposePriceText.hidden = YES;
    self.R_exposePriceText.hidden = YES;
    self.R_productName.hidden = YES;
    self.R_promotionName.hidden = YES;
    self.R_salePrice.hidden = YES;
    self.R_TF.hidden = YES;
    self.R_valuetext.hidden = YES;
    self.R_valuetext.text = @"";
    self.R_salePrice.text = @"";
    self.R_promotionName.text = @"";
    self.R_productName.text = @"";
    self.R_exposePriceText.text = @"";
    self.R_basePrice_exposePriceText.text = @"";
    self.R_basePrice.text = @"";
    self.R_productImageView.image = nil;
    self.R_air_on.hidden = YES;
    self.R_reviewCount.text = @"";
    self.R_reviewCount.hidden = YES;
    self.R_viewBenefit01.hidden = YES;
    self.R_viewBenefit02.hidden = YES;
    self.R_viewBenefit03.hidden = YES;
    self.R_imgBenefit01.image = nil;
    self.R_imgBenefit02.image = nil;
    self.R_imgBenefit03.image = nil;
    self.R_tvTimeText.text = @"";
    self.R_tvTimeView.hidden = YES;
    self.R_textBadgeInfo.text = @"";
    self.R_viewPlay.hidden = YES;
    self.R_btnPlay.hidden = YES;
    self.R_Link.accessibilityLabel = @"";
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic {
    self.backgroundColor = [UIColor clearColor];
    if (NCA([rowinfoDic objectForKey:@"subProductList"]) && [(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] > 0) {
        self.L_infoDic =  [[rowinfoDic objectForKey:@"subProductList"] objectAtIndex:0];
        if([(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] >= 2) {
            self.R_infoDic =  [[rowinfoDic objectForKey:@"subProductList"] objectAtIndex:1];
            self.R_under_line.hidden = NO;
            self.R_View.hidden = NO;
        }
        else {
            self.R_infoDic = nil;
            // 왼쪽엔 노출되지 않도록 처리 (회색? 흰색)
            self.R_under_line.hidden = YES;
            self.R_View.hidden = YES;
        }
    }
    else {
        // 아무것도 노출되지 않음
        return;
    }
    
    //////////////////// L 시작 ///////////////////
    
    
    //////////// 상품 이미지 시작 //////////
    //19금 제한?
    if([NCS([self.L_infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"]) {
        if( [Common_Util isthisAdultCerted] == NO) {
            self.L_productImageView.image =  [UIImage imageNamed:@"prevent19cellimg"];
        }
        else {
            self.L_imageURL = NCS([self.L_infoDic objectForKey:@"imageUrl"]);
            if([self.L_imageURL length] > 0) {
                // 이미지 로딩
                [ImageDownManager blockImageDownWithURL:self.L_imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.L_imageURL isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (isInCache) {
                                self.L_productImageView.image = fetchedImage;
                            }
                            else {
                                self.L_productImageView.alpha = 0;
                                self.L_productImageView.image = fetchedImage;
                                
                                [UIView animateWithDuration:0.2f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseInOut
                                                 animations:^{
                                                     self.L_productImageView.alpha = 1;
                                                 }
                                                 completion:^(BOOL finished)
                                 {
                                     
                                 }];
                            }
                            
                        });
                    }
                }];
            }
            
        } //else
    }
    else {
        self.L_imageURL = NCS([self.L_infoDic objectForKey:@"imageUrl"]);
        if([self.L_imageURL length] > 0) {
            [ImageDownManager blockImageDownWithURL:self.L_imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                if(error == nil  && [self.L_imageURL isEqualToString:strInputURL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache) {
                            self.L_productImageView.image = fetchedImage;
                        }
                        else {
                            self.L_productImageView.alpha = 0;
                            self.L_productImageView.image = fetchedImage;
                            [UIView animateWithDuration:0.1f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.L_productImageView.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        }
                    });
                }
            }];
        }
        
    }// else
    //////////// 상품 이미지 종료 //////////
    
    
    ////////// 상품명 노출 시작 (feat. TF)/////////
    if(NCO([self.L_infoDic objectForKey:@"infoBadge"]) && NCA([[self.L_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {
        if([(NSArray*)[[self.L_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.L_TF.hidden = NO;
            @try {
                self.L_TF.text = (NSString*)NCS([   [ [ [self.L_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
                if( [(NSString*)NCS([ [ [ [self.L_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]) length] > 0) {
                    self.L_TF.textColor = [Mocha_Util getColor:(NSString*)[ [ [ [self.L_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"exception = %@",exception);
            }
        }
        else {
            self.L_TF.hidden = YES;
            self.L_TF.text = @"";
        }
    }
    else {    // nami0342 - NCA
        self.L_TF.hidden = YES;
        self.L_TF.text = @"";
    }
    
    // 상품명 앞에 TF값이 있으면 넣어준다. 공간 확보용
    if( self.L_TF.hidden ) {
        self.L_productName.text = NCS([self.L_infoDic objectForKey:@"productName"]);
    }
    else {
        self.L_productName.text = [NSString stringWithFormat:@"%@ %@", self.L_TF.text , NCS([self.L_infoDic objectForKey:@"productName"]) ];
    }
    
    self.L_productName.text = [NSString stringWithFormat:@"%@\n ",self.L_productName.text]; //줄바꿈?
    if(self.L_productName.text.length > 0) {
        self.L_productName.hidden = NO;
    }
    else {
        self.L_productName.hidden = YES;
    }
    
    ////////// 상품명 노출 종료 //////////
    
    ///////// 프로모션 노출 시작 /////////
    self.L_promotionName.text = NCS([self.L_infoDic objectForKey:@"promotionName"]);
    if(self.L_promotionName.text.length > 0) {
        self.L_promotionName.hidden = NO;
        self.L_promotionName.text = [NSString stringWithFormat:@"(%@)",self.L_promotionName.text];
    }
    else {
        self.L_promotionName.hidden = YES;
    }
    ///////// 프로모션 노출 종료 /////////
    
    
    //////// 판매금액 노출 시작 ////////
    
    int salePrice = 0;
    if(NCO([self.L_infoDic objectForKey:@"salePrice"])) {
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[self.L_infoDic objectForKey:@"salePrice"]] ];
        
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES) {
            salePrice = [(NSNumber *)removeCommaspricestr intValue];
            self.L_salePrice.text = [Common_Util commaStringFromDecimal:salePrice];
            self.L_exposePriceText.text  =  NCS([self.L_infoDic objectForKey:@"exposePriceText"]);
            self.L_salePrice.hidden = NO;
            self.L_exposePriceText.hidden = NO;
        }
        else {
            //숫자아님
            self.L_salePrice.hidden = YES;
            self.L_exposePriceText.hidden = NO;
        }
    }
    else {
        self.L_salePrice.hidden = YES;
        self.L_exposePriceText.hidden = YES;
    }
    //////// 판매금액 노출 종료 ////////
    
    
    //////// 원래금액 노출 시작 ////////
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([self.L_infoDic objectForKey:@"basePrice"])];
    int basePrice = [(NSNumber *)removeCommaorgstr intValue];
    if (basePrice > 0 && basePrice > salePrice) {
        // 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        
        if (NCO([self.L_infoDic objectForKey:@"discountRate"]) && [ [self.L_infoDic objectForKey:@"discountRate"] intValue] < 1) {
            self.L_basePrice.text = @"";
            self.L_basePrice_exposePriceText.text = @"";
            self.L_basePriceCancelLine.hidden = YES;
            self.L_basePrice.hidden = YES;
            self.L_basePrice_exposePriceText.hidden = YES;
        }
        else {
            self.L_basePrice.text = [Common_Util commaStringFromDecimal:basePrice];
            self.L_basePrice_exposePriceText.text = NCS([self.L_infoDic objectForKey:@"exposePriceText"]);
            self.L_basePrice.hidden = NO;
            self.L_basePrice_exposePriceText.hidden = NO;
            self.L_basePriceCancelLine.hidden = NO;
        }
    }
    else {
        self.L_basePrice.text = @"";
        self.L_basePrice_exposePriceText.text = @"";
        self.L_basePrice.hidden = YES;
        self.L_basePrice_exposePriceText.hidden = YES;
        self.L_basePriceCancelLine.hidden = YES;
    }
    
    
    //////// 원래금액 노출 종료 ////////
    
    
    //////// valueInfo 노출 시작 ///////
    //valueInfo
    if([NCS([self.L_infoDic objectForKey:@"valueText"]) length] > 0 ) {
        self.L_valuetext.hidden = NO;
        self.L_valuetext.text = [self.L_infoDic objectForKey:@"valueText"];
    }
    else {
        self.L_valuetext.text = @"";
        self.L_valuetext.hidden = YES;
    }
    
    
    //////// 방송중구매 레이어 노출 시작 //////// 20160720 추가
    if([NCS([self.L_infoDic objectForKey:@"imageLayerFlag"]) length] > 0 && [NCS([self.L_infoDic objectForKey:@"imageLayerFlag"]) isEqualToString:@"AIR_BUY"]) {
        self.L_air_on.hidden = NO;
    }
    else {
        self.L_air_on.hidden = YES;
    }
    //////// 방송중구매 레이어 노출 종료 ////////
    
    ///////// 방송시간 노출 시작 //////////
    if([NCS([self.L_infoDic objectForKey:@"etcText1"]) length] > 0) {
        self.L_tvTimeView.hidden = NO;
        self.L_tvTimeText.text = NCS([self.L_infoDic objectForKey:@"etcText1"]);
        if(self.L_air_on.hidden) {
            self.L_lconstAirOnH.constant = 0;
        }
        else {
            self.L_lconstAirOnH.constant = 28;
        }
    }
    else {
        self.L_tvTimeView.hidden = YES;
    }
    ///////// 방송시간 노출 종료 //////////
    
    /////////// 상품평 갯수 노출 시작 /////////////
    // -> 상품평에서 상품 갯수로 변경됨.
    if(NCO([self.L_infoDic objectForKey:@"saleQuantity"])) {
        NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([self.L_infoDic objectForKey:@"saleQuantity"])];
        //숫자가 맞음
        if([Common_Util isThisValidNumberStr:removeCommaorgstr]) {
            self.L_reviewCount.hidden = NO;
            self.L_reviewCount.text = [NSString stringWithFormat:@"%@%@ %@",NCS([self.L_infoDic objectForKey:@"saleQuantity"]),NCS([self.L_infoDic objectForKey:@"saleQuantityText"]) ,NCS([self.L_infoDic objectForKey:@"saleQuantitySubText"]) ];
        }
        else if(  [NCS([self.L_infoDic objectForKey:@"saleQuantityText"]) length] > 0) { //텍스트만 있는경우 (첫구매 !!)
            self.L_reviewCount.hidden = NO;
            self.L_reviewCount.text = [NSString stringWithFormat:@"%@", NCS([self.L_infoDic objectForKey:@"saleQuantityText"]) ];
        }
        else {
            self.L_reviewCount.text = @"";
            self.L_reviewCount.hidden = YES;
        }
    }
    else {
        self.L_reviewCount.text = @"";
        self.L_reviewCount.hidden = YES;
    }
    /////////// 상품평 갯수 노출 종료 /////////////
    
    ///////////// 혜택 딱지 노출 시작 //////////////
    if(NCA([self.L_infoDic objectForKey:@"rwImgList"]) == YES) {
        self.L_viewBenefit01.hidden = YES;
        self.L_viewBenefit02.hidden = YES;
        self.L_viewBenefit03.hidden = YES;
        NSArray *arrBene = [self.L_infoDic objectForKey:@"rwImgList"];
        for(NSInteger i=0; i<[arrBene count]; i++) {
            if(i>3) {
                break;
            }
            if([NCS([arrBene objectAtIndex:i]) length] ==0) {
                continue;
            }
            //파일명에서 이미지 너비값 구하기
            NSArray *arrSplit = [NCS([arrBene objectAtIndex:i]) componentsSeparatedByString:@"/"];
            NSArray *arrFileName = [[arrSplit lastObject] componentsSeparatedByString:@"."];
            NSString *strWidth = nil;
            if ([arrFileName count] >= 2) {
                strWidth = [[[arrFileName objectAtIndex:[arrFileName count]-2] componentsSeparatedByString:@"_"] lastObject];
            }
            else {
                continue;
            }
            
            CGFloat widthBenefit = 0.0;
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet]; //숫자가 아닌?
            if([strWidth rangeOfCharacterFromSet:notDigits].location == NSNotFound) {// 숫자가 아닌걸 못찾았다
                widthBenefit = (CGFloat)([strWidth integerValue]/2.0);
            }
            else {
                continue;
            }
            
            if(i == 0) {
                self.L_lconstBenefitWidth01.constant = widthBenefit;
                self.L_viewBenefit01.hidden = NO;
                self.L_imgBenefit01.image = nil;
                self.L_strBenefitURL01 = [arrBene objectAtIndex:i];
                [ImageDownManager blockImageDownWithURL:self.L_strBenefitURL01 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.L_strBenefitURL01 isEqualToString:strInputURL]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //정사각형 이미지 처리 분기
                            if(isInCache) {
                                self.L_imgBenefit01.alpha = 1;
                                self.L_imgBenefit01.image = fetchedImage;
                            }
                            else {
                                self.L_imgBenefit01.alpha = 0;
                                self.L_imgBenefit01.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.L_imgBenefit01.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                             }];
                        });
                    }
                }];
                
                
            }
            else if(i == 1) {
                self.L_lconstBenefitWidth02.constant = widthBenefit;
                self.L_viewBenefit02.hidden = NO;
                self.L_imgBenefit02.image = nil;
                self.L_strBenefitURL02 = [arrBene objectAtIndex:i];
                [ImageDownManager blockImageDownWithURL:self.L_strBenefitURL02 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.L_strBenefitURL02 isEqualToString:strInputURL]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //정사각형 이미지 처리 분기
                            if(isInCache) {
                                self.L_imgBenefit02.alpha = 1;
                                self.L_imgBenefit02.image = fetchedImage;
                            }
                            else {
                                self.L_imgBenefit02.alpha = 0;
                                self.L_imgBenefit02.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.L_imgBenefit02.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                             }];
                        });
                    }
                }];
            }
            else if(i == 2) {
                self.L_lconstBenefitWidth03.constant = widthBenefit;
                self.L_viewBenefit03.hidden = NO;
                self.L_imgBenefit03.image = nil;
                self.L_strBenefitURL03 = [arrBene objectAtIndex:i];
                [ImageDownManager blockImageDownWithURL:self.L_strBenefitURL03 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.L_strBenefitURL03 isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //정사각형 이미지 처리 분기
                            if(isInCache) {
                                self.L_imgBenefit03.alpha = 1;
                                self.L_imgBenefit03.image = fetchedImage;
                            }
                            else {
                                self.L_imgBenefit03.alpha = 0;
                                self.L_imgBenefit03.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.L_imgBenefit03.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        });
                    }
                }];
            }
        }
    }
    else {
        self.L_viewBenefit01.hidden = YES;
        self.L_viewBenefit02.hidden = YES;
        self.L_viewBenefit03.hidden = YES;
    }
    ///////////// 혜택 딱지 노출 종료 //////////////
    
    
    ///////////// 벳지 텍스트로 노출 시작 /////////////
    //혜택이 있으면 텍스트를 노출하지 않는다.
    if( self.L_viewBenefit01.hidden && self.L_viewBenefit02.hidden && self.L_viewBenefit03.hidden && NCO([self.L_infoDic objectForKey:@"imgBadgeCorner"]) ) {
        NSArray* badges = [[self.L_infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB"];
        NSString* textValue = @"";
        for (NSDictionary* badgeType in badges) {
            textValue = [NSString stringWithFormat:(textValue.length > 0)?@"%@ %@":@"%@%@", textValue, [self tagWithtype:badgeType] ];
        }
        self.L_textBadgeInfo.text = textValue;
    }
    ///////////// 벳지 텍스트로 노출 종료 /////////////
    
    
    ///////////// 동영상 버튼 노출 시작 //////////////
    if(([NCS([self.L_infoDic objectForKey:@"dealMcVideoUrlAddr"]) length] > 0 || [NCS([self.L_infoDic objectForKey:@"videoid"]) length] > 4) && [NCS([self.L_infoDic objectForKey:@"videoTime"]) length] > 0) {
        self.L_viewPlay.hidden = NO;
        self.L_btnPlay.hidden = NO;
        self.L_lblPlayTime.text = NCS([self.L_infoDic objectForKey:@"videoTime"]);
        self.L_btnPlay.accessibilityLabel = [NSString stringWithFormat:@"%@ 동영상 플레이",  NCS(self.L_productName.text)];
        
    }
    else if(([NCS([self.L_infoDic objectForKey:@"dealMcVideoUrlAddr"]) length] > 0 || [NCS([self.L_infoDic objectForKey:@"videoid"]) length] > 4)&& [NCS([self.L_infoDic objectForKey:@"videoTime"]) length] <= 0) {
        // 플레이 버튼만 노출
        self.L_viewPlay.hidden = NO;
        self.L_btnPlay.hidden = NO;
        self.L_lblPlayTime.text = @"";
        self.L_btnPlay.accessibilityLabel = [NSString stringWithFormat:@"%@ 동영상 플레이", NCS(self.L_productName.text)];
    }
    else {
        self.L_viewPlay.hidden = YES;
        self.L_btnPlay.hidden = YES;
        self.L_lblPlayTime.text = @"";
    }
    ///////////// 동영상 버튼 노출 종료 //////////////
    
    ///////////// accessibilityLabel 적용 /////////////
    self.L_link.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([self.L_infoDic objectForKey:@"productName"]),NCS([self.L_infoDic objectForKey:@"salePrice"]),NCS([self.L_infoDic objectForKey:@"exposePriceText"])];
    
    
    
    
    //////////////////////////////////////////////////////////// L 종료 ///////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    
    //////////////////////////////////////////////////////////// R 시작 ///////////////////////////////////////////////////////////
    //////////// 상품 이미지 시작 //////////
    //19금 제한?
    if([NCS([self.R_infoDic objectForKey:@"adultCertYn"]) isEqualToString:@"Y"]) {
        if( [Common_Util isthisAdultCerted] == NO) {
            self.R_productImageView.image =  [UIImage imageNamed:@"prevent19cellimg"];
        }
        else {
            self.R_imageURL = NCS([self.R_infoDic objectForKey:@"imageUrl"]);
            if([self.R_imageURL length] > 0) {
                // 이미지 로딩
                [ImageDownManager blockImageDownWithURL:self.R_imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.R_imageURL isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(isInCache) {
                                self.R_productImageView.image = fetchedImage;
                            }
                            else {
                                self.R_productImageView.alpha = 0;
                                self.R_productImageView.image = fetchedImage;
                                [UIView animateWithDuration:0.2f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseInOut
                                                 animations:^{
                                                     self.R_productImageView.alpha = 1;
                                                 }
                                                 completion:^(BOOL finished)
                                 {
                                 }];
                            }
                        });
                    }
                }];
            }
        } //else
    }
    else {
        self.R_imageURL = NCS([self.R_infoDic objectForKey:@"imageUrl"]);
        if([self.R_imageURL length] > 0) {
            [ImageDownManager blockImageDownWithURL:self.R_imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                if(error == nil  && [self.R_imageURL isEqualToString:strInputURL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(isInCache) {
                            self.R_productImageView.image = fetchedImage;
                        }
                        else {
                            self.R_productImageView.alpha = 0;
                            self.R_productImageView.image = fetchedImage;
                            
                            [UIView animateWithDuration:0.1f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.R_productImageView.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        }
                    });
                }
            }];
        }
        
    }// else
    //////////// 상품 이미지 종료 //////////
    
   
    
    
    
    ////////// 상품명 노출 시작 (feat. TF)/////////
    if(NCO([self.R_infoDic objectForKey:@"infoBadge"]) && NCA([[self.R_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {
        if([(NSArray*)[[self.R_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.R_TF.hidden = NO;
            @try {
                self.R_TF.text = (NSString*)NCS([ [ [ [self.R_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
                if( [(NSString*)NCS([ [ [ [self.R_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]) length] > 0) {
                    self.R_TF.textColor = [Mocha_Util getColor: (NSString*)[ [ [ [self.R_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"exception = %@",exception);
            }
        }
        else {
            self.R_TF.hidden = YES;
            self.R_TF.text = @"";
        }
    }
    else {    // nami0342 - NCA
        self.R_TF.hidden = YES;
        self.R_TF.text = @"";
    }
    
    // 상품명 앞에 TF값이 있으면 넣어준다. 공간 확보용
    if( self.R_TF.hidden ) {
        self.R_productName.text = NCS([self.R_infoDic objectForKey:@"productName"]);
    }
    else {
        self.R_productName.text = [NSString stringWithFormat:@"%@ %@", self.R_TF.text , NCS([self.R_infoDic objectForKey:@"productName"]) ];
    }
    
    self.R_productName.text =  [NSString stringWithFormat:@"%@\n ",self.R_productName.text]; //줄바꿈?
    
    if(self.R_productName.text.length > 0) {
        self.R_productName.hidden = NO;
    }
    else {
        self.R_productName.hidden = YES;
    }
    ////////// 상품명 노출 종료 //////////
    
    
    ///////// 프로모션 노출 시작 /////////
    self.R_promotionName.text = NCS([self.R_infoDic objectForKey:@"promotionName"]);
    if(self.R_promotionName.text.length > 0) {
        self.R_promotionName.hidden = NO;
        self.R_promotionName.text = [NSString stringWithFormat:@"(%@)",self.R_promotionName.text];
    }
    else {
        self.R_promotionName.hidden = YES;
    }
    ///////// 프로모션 노출 종료 /////////
    
    
    //////// 판매금액 노출 시작 ////////
    salePrice = 0;
    if(NCO([self.R_infoDic objectForKey:@"salePrice"])) {
        // 판매 가격
        NSString *R_removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[self.R_infoDic objectForKey:@"salePrice"]] ];
        
        if( [Common_Util isThisValidWithZeroStr:R_removeCommaspricestr] == YES) {
            salePrice = [(NSNumber *)R_removeCommaspricestr intValue];
            self.R_salePrice.text = [Common_Util commaStringFromDecimal:salePrice];
            self.R_exposePriceText.text = NCS([self.R_infoDic objectForKey:@"exposePriceText"]);
            self.R_salePrice.hidden = NO;
            self.R_exposePriceText.hidden = NO;
        }
        else {
            //숫자아님
            self.R_salePrice.hidden = YES;
            self.R_exposePriceText.hidden = NO;
        }
    }
    else {
        self.R_salePrice.hidden = YES;
        self.R_exposePriceText.hidden = YES;
    }
    //////// 판매금액 노출 종료 ////////
    
    
    
    //////// 원래금액 노출 시작 ////////
    NSString *R_removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([self.R_infoDic objectForKey:@"basePrice"])];
    basePrice = 0;
    basePrice = [(NSNumber *)R_removeCommaorgstr intValue];
    if (basePrice > 0 && basePrice > salePrice) {
        // 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        if (NCO([self.R_infoDic objectForKey:@"discountRate"]) && [ [self.R_infoDic objectForKey:@"discountRate"] intValue] < 1) {
            self.R_basePrice.text = @"";
            self.R_basePrice_exposePriceText.text = @"";
            self.R_basePriceCancelLine.hidden = YES;
            self.R_basePrice.hidden = YES;
            self.R_basePrice_exposePriceText.hidden = YES;
        }
        else {
            self.R_basePrice.text = [Common_Util commaStringFromDecimal:basePrice];
            self.R_basePrice_exposePriceText.text = NCS([self.R_infoDic objectForKey:@"exposePriceText"]);
            self.R_basePrice.hidden = NO;
            self.R_basePrice_exposePriceText.hidden = NO;
            self.R_basePriceCancelLine.hidden = NO;
        }
        
    }
    else {
        self.R_basePrice.text = @"";
        self.R_basePrice_exposePriceText.text = @"";
        self.R_basePrice.hidden = YES;
        self.R_basePrice_exposePriceText.hidden = YES;
        self.R_basePriceCancelLine.hidden = YES;
    }
    
    
    //////// 원래금액 노출 종료 ////////
    
    
    //////// valueText 노출 시작 ///////
    //valueText
    if([NCS([self.R_infoDic objectForKey:@"valueText"])  length] > 0 ) {
        self.R_valuetext.hidden = NO;
        self.R_valuetext.text = [self.R_infoDic objectForKey:@"valueText"];
    }
    else {
        self.R_valuetext.text = @"";
        self.R_valuetext.hidden = YES;
    }
    
    //////// 방송중구매 레이어 노출 시작 //////// 20160720 추가
    if([NCS([self.R_infoDic objectForKey:@"imageLayerFlag"]) length] > 0 && [NCS([self.R_infoDic objectForKey:@"imageLayerFlag"]) isEqualToString:@"AIR_BUY"]) {
        self.R_air_on.hidden = NO;
    }
    else {
        self.R_air_on.hidden = YES;
    }
    //////// 방송중구매 레이어 노출 종료 ////////
    
    ///////// 방송시간 노출 시작 //////////
    if([NCS([self.R_infoDic objectForKey:@"etcText1"]) length] > 0) {
        self.R_tvTimeView.hidden = NO;
        self.R_tvTimeText.text = NCS([self.R_infoDic objectForKey:@"etcText1"]);
        if(self.R_air_on.hidden) {
            self.R_lconstAirOnH.constant = 0;
        }
        else {
            self.R_lconstAirOnH.constant = 28;
        }
    }
    else {
        self.R_tvTimeView.hidden = YES;
    }
    ///////// 방송시간 노출 종료 //////////
    
    /////////// 상품평 갯수 노출 시작 /////////////
    // -> 상품평에서 상품 갯수로 변경됨.
    if(NCO([self.R_infoDic objectForKey:@"saleQuantity"])) {
        NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([self.R_infoDic objectForKey:@"saleQuantity"])];
        //숫자가 맞음
        if([Common_Util isThisValidNumberStr:removeCommaorgstr]) {
            self.R_reviewCount.hidden = NO;
            self.R_reviewCount.text = [NSString stringWithFormat:@"%@%@ %@",NCS([self.R_infoDic objectForKey:@"saleQuantity"]),NCS([self.R_infoDic objectForKey:@"saleQuantityText"]) ,NCS([self.R_infoDic objectForKey:@"saleQuantitySubText"]) ];
        }
        else if(  [NCS([self.R_infoDic objectForKey:@"saleQuantityText"]) length] > 0) { //텍스트만 있는경우 (첫구매 !!)
            self.R_reviewCount.hidden = NO;
            self.R_reviewCount.text = [NSString stringWithFormat:@"%@", NCS([self.R_infoDic objectForKey:@"saleQuantityText"]) ];
        }
        else {
            self.R_reviewCount.text = @"";
            self.R_reviewCount.hidden = YES;
        }
    }
    else {
        self.R_reviewCount.text = @"";
        self.R_reviewCount.hidden = YES;
    }
    /////////// 상품평 갯수 노출 종료 /////////////
    
    ///////////// 혜택 딱지 노출 시작 //////////////
    if(NCA([self.R_infoDic objectForKey:@"rwImgList"]) == YES) {
        self.R_viewBenefit01.hidden = YES;
        self.R_viewBenefit02.hidden = YES;
        self.R_viewBenefit03.hidden = YES;
        NSArray *arrBene = [self.R_infoDic objectForKey:@"rwImgList"];
        for(NSInteger i=0; i<[arrBene count]; i++) {
            if(i>3) {
                break;
            }
            if([NCS([arrBene objectAtIndex:i]) length] ==0) {
                continue;
            }
            //파일명에서 이미지 너비값 구하기
            NSArray *arrSplit = [NCS([arrBene objectAtIndex:i]) componentsSeparatedByString:@"/"];
            NSArray *arrFileName = [[arrSplit lastObject] componentsSeparatedByString:@"."];
            NSString *strWidth = nil;
            if ([arrFileName count] >= 2) {
                strWidth = [[[arrFileName objectAtIndex:[arrFileName count]-2] componentsSeparatedByString:@"_"] lastObject];
            }
            else {
                continue;
            }
            
            CGFloat widthBenefit = 0.0;
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet]; //숫자가 아닌?
            if([strWidth rangeOfCharacterFromSet:notDigits].location == NSNotFound) {// 숫자가 아닌걸 못찾았다
                widthBenefit = (CGFloat)([strWidth integerValue]/2.0);
            }
            else {
                continue;
            }
            
            if(i == 0) {
                self.R_lconstBenefitWidth01.constant = widthBenefit;
                self.R_viewBenefit01.hidden = NO;
                self.R_imgBenefit01.image = nil;
                self.R_strBenefitURL01 = [arrBene objectAtIndex:i];
                [ImageDownManager blockImageDownWithURL:self.R_strBenefitURL01 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.R_strBenefitURL01 isEqualToString:strInputURL]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //정사각형 이미지 처리 분기
                            if(isInCache) {
                                self.R_imgBenefit01.alpha = 1;
                                self.R_imgBenefit01.image = fetchedImage;
                            }
                            else {
                                self.R_imgBenefit01.alpha = 0;
                                self.R_imgBenefit01.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.R_imgBenefit01.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                             }];
                        });
                    }
                }];
                
                
            }
            else if(i == 1) {
                self.R_lconstBenefitWidth02.constant = widthBenefit;
                self.R_viewBenefit02.hidden = NO;
                self.R_imgBenefit02.image = nil;
                self.R_strBenefitURL02 = [arrBene objectAtIndex:i];
                [ImageDownManager blockImageDownWithURL:self.R_strBenefitURL02 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.R_strBenefitURL02 isEqualToString:strInputURL]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //정사각형 이미지 처리 분기
                            if(isInCache) {
                                self.R_imgBenefit02.alpha = 1;
                                self.R_imgBenefit02.image = fetchedImage;
                            }
                            else {
                                self.R_imgBenefit02.alpha = 0;
                                self.R_imgBenefit02.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.R_imgBenefit02.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                             }];
                        });
                    }
                }];
            }
            else if(i == 2) {
                self.R_lconstBenefitWidth03.constant = widthBenefit;
                self.R_viewBenefit03.hidden = NO;
                self.R_imgBenefit03.image = nil;
                self.R_strBenefitURL03 = [arrBene objectAtIndex:i];
                [ImageDownManager blockImageDownWithURL:self.R_strBenefitURL03 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.R_strBenefitURL03 isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //정사각형 이미지 처리 분기
                            if(isInCache) {
                                self.R_imgBenefit03.alpha = 1;
                                self.R_imgBenefit03.image = fetchedImage;
                            }
                            else {
                                self.R_imgBenefit03.alpha = 0;
                                self.R_imgBenefit03.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.R_imgBenefit03.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        });
                    }
                }];
            }
        }
    }
    else {
        self.R_viewBenefit01.hidden = YES;
        self.R_viewBenefit02.hidden = YES;
        self.R_viewBenefit03.hidden = YES;
    }
    ///////////// 혜택 딱지 노출 종료 //////////////
    
    ///////////// 벳지 텍스트로 노출 시작 /////////////
    // 혜택이 있으면 텍스트를 노출하지 않는다.
    if( self.R_viewBenefit01.hidden && self.R_viewBenefit02.hidden && self.R_viewBenefit03.hidden && NCO([self.R_infoDic objectForKey:@"imgBadgeCorner"]) ) {
        NSArray* badges = [[self.R_infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB"];
        NSString* textValue = @"";
        for (NSDictionary* badgeType in badges) {
            textValue = [NSString stringWithFormat:(textValue.length > 0)?@"%@ %@":@"%@%@", textValue, [self tagWithtype:badgeType] ];
        }
        self.R_textBadgeInfo.text = textValue;
    }
    ///////////// 벳지 텍스트로 노출 종료 /////////////
    
    ///////////// 동영상 버튼 노출 시작 //////////////
    if(([NCS([self.R_infoDic objectForKey:@"dealMcVideoUrlAddr"]) length] > 0 || [NCS([self.R_infoDic objectForKey:@"videoid"]) length] > 4)&& [NCS([self.R_infoDic objectForKey:@"videoTime"]) length] > 0) {
        self.R_viewPlay.hidden = NO;
        self.R_btnPlay.hidden = NO;
        self.R_lblPlayTime.text = NCS([self.R_infoDic objectForKey:@"videoTime"]);
        self.R_btnPlay.accessibilityLabel = [NSString stringWithFormat:@"%@ 동영상 플레이", self.R_productName.text];
    }
    else  if(([NCS([self.R_infoDic objectForKey:@"dealMcVideoUrlAddr"]) length] > 0 || [NCS([self.R_infoDic objectForKey:@"videoid"]) length] > 4) && [NCS([self.R_infoDic objectForKey:@"videoTime"]) length] <= 0) {
        // 플레이 버튼만 노출
        self.R_viewPlay.hidden = NO;
        self.R_btnPlay.hidden = NO;
        self.R_lblPlayTime.text = @"";
        self.R_btnPlay.accessibilityLabel = [NSString stringWithFormat:@"%@ 동영상 플레이", self.R_productName.text];
    }
    else{
        self.R_viewPlay.hidden = YES;
        self.R_btnPlay.hidden = YES;
        self.R_lblPlayTime.text = @"";
    }
    ///////////// 동영상 버튼 노출 종료 //////////////
    
    ///////////// accessibilityLabel 적용 /////////////
    self.R_Link.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([self.R_infoDic objectForKey:@"productName"]),NCS([self.R_infoDic objectForKey:@"salePrice"]),NCS([self.R_infoDic objectForKey:@"exposePriceText"])];
    
    
    //////////////////////////////////////////////////////////// R 종료 ///////////////////////////////////////////////////////////
    
}

//상품 클릭처리
-(IBAction)onBtnContents:(id)sender{
    // 0 = L, 1 = R
    if([((UIButton *)sender) tag] == 0) {
        [target dctypetouchEventTBCell:self.L_infoDic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"BAN_IMG_C2_GBA"];
    }
    else {
        [target dctypetouchEventTBCell:self.R_infoDic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"BAN_IMG_C2_GBA"];
    }    
    
}

//동영상 클릭처리
-(IBAction)onBtnMovieContents:(id)sender{
    // 0 = L, 1 = R

    NSString *strVodURL = nil;
    NSString *strVideoID = nil;
    NSString *strLinkURL = nil;
    NSString *strClickWiseLog = nil;
    NSString *strGoProductWiseLog = nil;

    if([((UIButton *)sender) tag] == 0) {
        strVideoID = NCS([self.L_infoDic objectForKey:@"videoid"]);
        strVodURL = NCS([self.L_infoDic objectForKey:@"dealMcVideoUrlAddr"]);
        strLinkURL = NCS([self.L_infoDic objectForKey:@"linkUrl"]);
        strClickWiseLog = NCS([self.L_infoDic objectForKey:@"wiseLog"]);
        strGoProductWiseLog = NCS([self.L_infoDic objectForKey:@"wiseLog2"]);
    }
    else {
        strVideoID = NCS([self.R_infoDic objectForKey:@"videoid"]);
        strVodURL = NCS([self.R_infoDic objectForKey:@"dealMcVideoUrlAddr"]);
        strLinkURL= NCS([self.R_infoDic objectForKey:@"linkUrl"]);
        strClickWiseLog = NCS([self.R_infoDic objectForKey:@"wiseLog"]);
        strGoProductWiseLog = NCS([self.R_infoDic objectForKey:@"wiseLog2"]);
    }
    
    //클릭시 와이즈로그 전송
    if ([NCS(strClickWiseLog) length] > 0 && [NCS(strClickWiseLog) hasPrefix:@"http"]) {
        [ApplicationDelegate wiseLogRestRequest:strClickWiseLog];
    }
    
    //전체화면 플레이어
    if ( [strVodURL length] > 0 || [strVideoID length] > 4 ) {//&& [strVodURL hasPrefix:@"http"]) {
        NSString *strReqURL = [NSString stringWithFormat:@"toapp://dealvod?url=%@&targeturl=%@&videoid=%@",strVodURL,strLinkURL,strVideoID];
        Home_Main_ViewController *HMV = (Home_Main_ViewController *)ApplicationDelegate.HMV;
        if ([HMV respondsToSelector:@selector(checkVODStatusAndPlay:goProuctWiseLog:)]) {
            [HMV checkVODStatusAndPlay:strReqURL goProuctWiseLog:strGoProductWiseLog];
        }
    }
    
}



// 태그 텍스트 노출
-(NSString*) tagWithtype:(NSDictionary*)dic {
    NSString *ttype = NCS([dic objectForKey:@"type"]);
    NSString *tText = NCS([dic objectForKey:@"text"]);
    NSString *tagText;
    //RB
    if([ttype isEqualToString:@"freeDlv"]) {
        tagText = (tText.length > 0)?tText:@"무료배송";
    }
    else if([ttype isEqualToString:@"todayClose"]) {
        tagText = (tText.length > 0)?tText:@"오늘마감";
    }
    else if([ttype isEqualToString:@"freeInstall"]) {
        tagText = (tText.length > 0)?tText:@"무료설치";
    }
    else if([ttype isEqualToString:@"Reserves"]) {
        tagText = (tText.length > 0)?tText:@"적립금";
    }
    else if([ttype isEqualToString:@"interestFree"]) {
        tagText = (tText.length > 0)?tText:@"무이자";
    }
    else if([ttype isEqualToString:@"etc"]) {
       tagText = tText;
    }
    else {
        return @"";
    }
    return tagText;
}


@end
