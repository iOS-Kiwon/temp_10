//
//  SectionBFPtypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2016. 5. 2..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionBFPtypeCell.h"
#import "Common_Util.h"
#import "AppDelegate.h"

#define MIN_DISCOUNT_RATE_VALUE 1

@implementation SectionBFPtypeCell

@synthesize target;
@synthesize L_infoDic;
@synthesize R_infoDic;

@synthesize L_productImageView ,L_promotionName,L_productName,L_salePrice,L_exposePriceText,L_basePrice,L_basePrice_exposePriceText,L_basePriceCancelLine,L_LT,L_LTvalue,L_TF,L_valuetext,L_LT2,L_air_on;


@synthesize R_productImageView ,R_promotionName,R_productName,R_salePrice,R_exposePriceText,R_basePrice,R_basePrice_exposePriceText,R_basePriceCancelLine,R_LT,R_LTvalue,R_TF,R_valuetext,R_LT2,R_air_on;

@synthesize R_View,R_under_line;



- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}


-(void) prepareForReuse {
    [super prepareForReuse];
    self.L_basePriceCancelLine.hidden = YES;
    self.L_basePrice.hidden = YES;
    self.L_basePrice_exposePriceText.hidden = YES;
    self.L_exposePriceText.hidden = YES;
    self.L_LT.hidden = YES;
    self.L_LTvalue.hidden = YES;
    self.L_productName.hidden = YES;
    self.L_promotionName.hidden = YES;
    self.L_salePrice.hidden = YES;
    self.L_TF.hidden = YES;
    self.L_valuetext.hidden = YES;
    self.L_valuetext.text = @"";
    self.L_salePrice.text = @"";
    self.L_promotionName.text = @"";
    self.L_productName.text = @"";
    self.L_LTvalue.text = @"";
    self.L_exposePriceText.text = @"";
    self.L_basePrice_exposePriceText.text = @"";
    self.L_basePrice.text = @"";
    self.L_productImageView.image = nil;
    self.L_LT.image = nil;
    self.L_LT2.hidden = YES;
    self.L_air_on.hidden = YES;
    self.L_link.accessibilityLabel = @"";
    self.L_discountValue.text = @"";
    self.L_discountValueText.text = @"";
    
    
    
    self.R_basePriceCancelLine.hidden = YES;
    self.R_basePrice.hidden = YES;
    self.R_basePrice_exposePriceText.hidden = YES;
    self.R_exposePriceText.hidden = YES;
    self.R_LT.hidden = YES;
    self.R_LTvalue.hidden = YES;
    self.R_productName.hidden = YES;
    self.R_promotionName.hidden = YES;
    self.R_salePrice.hidden = YES;
    self.R_TF.hidden = YES;
    self.R_valuetext.hidden = YES;
    self.R_valuetext.text = @"";
    self.R_salePrice.text = @"";
    self.R_promotionName.text = @"";
    self.R_productName.text = @"";
    self.R_LTvalue.text = @"";
    self.R_exposePriceText.text = @"";
    self.R_basePrice_exposePriceText.text = @"";
    self.R_basePrice.text = @"";
    self.R_productImageView.image = nil;
    self.R_LT.image = nil;
    self.R_LT2.hidden = YES;
    self.R_air_on.hidden = YES;
    self.R_link.accessibilityLabel = @"";

    
    self.backgroundColor = [UIColor clearColor];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic{
    
    if (self.isBanImgC2GBB == YES) {
        self.backgroundColor = [UIColor whiteColor];
        self.lcontTopMargin.constant = 10.0;
        
        if(self.isBanImgC2GBBLastLine == YES){
            self.viewBottomLine.hidden = NO;
            self.L_under_line.backgroundColor = [UIColor whiteColor];
            self.R_under_line.backgroundColor = [UIColor whiteColor];
            
        }else{
            self.L_under_line.backgroundColor = [Mocha_Util getColor:@"F4F4F4"];
            self.R_under_line.backgroundColor = [Mocha_Util getColor:@"F4F4F4"];
            self.viewBottomLine.hidden = YES;
        }
        
    }else{
        self.viewBottomLine.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        self.lcontTopMargin.constant = 0.0;
        self.L_under_line.backgroundColor = [Mocha_Util getColor:@"D9D9D9"];
        self.R_under_line.backgroundColor = [Mocha_Util getColor:@"D9D9D9"];
    }
    
//    //20195029 parksegun BAN_IMG_C2_GBB일때만 폰트 컬러가 달라짐.. BFP는 유지하자..
//    if (self.isBanImgC2GBB == YES) {
//        self.L_salePrice.textColor = [Mocha_Util getColor:@""];
//    }
    
    
    //self.L_productName.text = @"";
    
    if (NCA([rowinfoDic objectForKey:@"subProductList"]) && [(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] > 0)
    {
        self.L_infoDic =  [[rowinfoDic objectForKey:@"subProductList"] objectAtIndex:0];
    
        if([(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] >= 2)
        {
            self.R_infoDic =  [[rowinfoDic objectForKey:@"subProductList"] objectAtIndex:1];
            self.R_under_line.hidden = NO;
            self.R_View.hidden = NO;
            
            
        }
        else
        {
            self.R_infoDic = nil;
            // 왼쪽엔 노출되지 않도록 처리 (회색? 흰색)
            self.R_under_line.hidden = YES;
            self.R_View.hidden = YES;
            
        }
        
        
    }
    else
    {
        // 아무것도 노출되지 않음
        return;
    }
    
    
    //////////////////// L 시작 ///////////////////
    
    
    //////////// 상품 이미지 시작 //////////
    //19금 제한?
    if([NCS([self.L_infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"])
    {
        if( [Common_Util isthisAdultCerted] == NO)
        {
            self.L_productImageView.image =  [UIImage imageNamed:@"prevent19cellimg"];
        }
        else
        {
            self.L_imageURL = NCS([self.L_infoDic objectForKey:@"imageUrl"]);
            if([self.L_imageURL length] > 0)
            {
                // 이미지 로딩
                [ImageDownManager blockImageDownWithURL:self.L_imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    
                    if (error == nil  && [self.L_imageURL isEqualToString:strInputURL]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (isInCache)
                                                      {
                                                          self.L_productImageView.image = fetchedImage;
                                                      }
                                                      else
                                                      {
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
    else
    {
        
        self.L_imageURL = NCS([self.L_infoDic objectForKey:@"imageUrl"]);
        if([self.L_imageURL length] > 0){
            
            [ImageDownManager blockImageDownWithURL:self.L_imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                
                if (error == nil  && [self.L_imageURL isEqualToString:strInputURL]){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache)
                                                  {
                                                      self.L_productImageView.image = fetchedImage;
                                                      
                                                  }
                                                  else
                                                  {
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
    
    ///////// 딜 벳지 노출 시작 /////////
    
    if([NCS([self.L_infoDic objectForKey:@"dealProductType"]) isEqualToString:@"Deal"]) {
        self.L_LT2.hidden = NO;
    }
    else {
        self.L_LT2.hidden = YES;
    }
    
    ///////// 딜 벳지 노출 종료 /////////
    
    
    /////////// LT 벳지 카운트 정보 출력 시작 /////////
    
    if(NCO([self.L_infoDic objectForKey:@"imgBadgeCorner"])) {
        
        if( !NCA([[self.L_infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ])) {
            self.L_LT.hidden = YES;
            self.L_LTvalue.hidden = YES;
        }
        else {
            NSString *ltvalue = NCS([   [ [ [self.L_infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] objectAtIndex:0] objectForKey: @"text" ]);
            NSString *lttype = NCS([   [ [ [self.L_infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] objectAtIndex:0] objectForKey: @"type" ]);
            // 좌상단 벳지가 있으면 랭킹 표기 안함.
            if(self.L_LT2.hidden) {
                if([[Mocha_Util trim:ltvalue] length] > 0) {
                    //T 이면 top5 라서 붉은 색 벳지
                    if([[Mocha_Util trim:lttype]  isEqual: @"T"])
                    {
                        self.L_LT.image = [UIImage imageNamed:@"best_ranking1-5_bg"];
                        self.L_LTvalue.textColor = [Mocha_Util getColor:@"FFFFFF"];
                    }
                    else
                    {
                        self.L_LT.image = [UIImage imageNamed:@"best_ranking6-100_bg"];
                        self.L_LTvalue.textColor = [Mocha_Util getColor:@"ee2162"];
                    }
                    
                    self.L_LT.hidden = NO;
                    self.L_LTvalue.hidden = NO;
                    self.L_LTvalue.text = ltvalue;
                    self.L_LT2.hidden = YES;
                }
                else
                {
                    self.L_LT.hidden = YES;
                    self.L_LTvalue.hidden = YES;
                    //self.L_LT2.hidden = YES;
                }
            }
        
        }
    }
    /////////// LT 벳지 카운트 정보 출력 종료 /////////
    
    
    ////////// 상품명 노출 시작 (feat. TF)/////////
    if(NCO([self.L_infoDic objectForKey:@"infoBadge"]) && NCA([[self.L_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {
        if([(NSArray*)[[self.L_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.L_TF.hidden = NO;
            @try {
                self.L_TF.text = (NSString*)NCS([ [ [ [self.L_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
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
    else    // nami0342 - NCA
    {
        self.L_TF.hidden = YES;
        self.L_TF.text = @"";
    }
    
    // 상품명 앞에 TF값이 있으면 넣어준다. 공간 확보용
    if( self.L_TF.hidden )
    {
        self.L_productName.text = NCS([self.L_infoDic objectForKey:@"productName"]);
    }
    else
    {
        self.L_productName.text = [NSString stringWithFormat:@"%@ %@", self.L_TF.text , NCS([self.L_infoDic objectForKey:@"productName"]) ];
    }
    
    self.L_productName.text =  [NSString stringWithFormat:@"%@\n ",self.L_productName.text]; //줄바꿈?
    if(self.L_productName.text.length > 0)
    {
        self.L_productName.hidden = NO;
    }
    else
    {
        self.L_productName.hidden = YES;
    }
    
    ////////// 상품명 노출 종료 //////////
    
    ///////// 프로모션 노출 시작 /////////
    self.L_promotionName.text = NCS([self.L_infoDic objectForKey:@"promotionName"]);
    if(self.L_promotionName.text.length > 0)
    {
        self.L_promotionName.hidden = NO;
        self.L_promotionName.text = [NSString stringWithFormat:@"(%@)",self.L_promotionName.text];
    }
    else
    {
        self.L_promotionName.hidden = YES;
    }
    ///////// 프로모션 노출 종료 /////////
    
    
    //////// 판매금액 노출 시작 ////////
    
    int salePrice = 0;
    
    if(NCO([self.L_infoDic objectForKey:@"salePrice"])) {
        
        
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[self.L_infoDic objectForKey:@"salePrice"]]      ];
        
        
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES){
            
            salePrice = [(NSNumber *)removeCommaspricestr intValue];
            
            self.L_salePrice.text = [Common_Util commaStringFromDecimal:salePrice];
            
            self.L_exposePriceText.text  =  NCS([self.L_infoDic objectForKey:@"exposePriceText"]);
            
            
            self.L_salePrice.hidden = NO;
            self.L_exposePriceText.hidden = NO;
            
        }
        else
        {
            //숫자아님
            self.L_salePrice.hidden = YES;
            self.L_exposePriceText.hidden = NO;
            
        }
        
        
    }
    else
    {
        
        self.L_salePrice.hidden = YES;
        self.L_exposePriceText.hidden = YES;
    }
    
    //////// 판매금액 노출 종료 ////////
    
    //////// 원래금액 노출 시작 ////////
    
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([self.L_infoDic objectForKey:@"basePrice"])];
    int basePrice = [(NSNumber *)removeCommaorgstr intValue];
    if (basePrice > 0 && basePrice > salePrice)
    {
        // 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        if (NCO([self.L_infoDic objectForKey:@"discountRate"]) && [ [self.L_infoDic objectForKey:@"discountRate"] intValue] < MIN_DISCOUNT_RATE_VALUE) {
            
            self.L_basePrice.text = @"";
            self.L_basePrice_exposePriceText.text = @"";
            self.L_basePriceCancelLine.hidden = YES;
            self.L_basePrice.hidden = YES;
            self.L_basePrice_exposePriceText.hidden = YES;
            
            self.L_discountValue.text = @"";
            self.L_discountValueText.text = @"";
            self.L_valuetextLeading.constant = 0.0;
            self.L_basePriceLeading.constant = 0.0;
            
        }
        else
        {
            
            self.L_basePrice.text = [Common_Util commaStringFromDecimal:basePrice];
            self.L_basePrice_exposePriceText.text = NCS([self.L_infoDic objectForKey:@"exposePriceText"]);
            
            self.L_basePrice.hidden = NO;
            self.L_basePrice_exposePriceText.hidden = NO;
            self.L_basePriceCancelLine.hidden = NO;
            
            if(self.isBanImgC2GBB == YES) { //GBB만 적용
                self.L_discountValue.text = NCS([self.L_infoDic objectForKey:@"discountRate"]);
                self.L_discountValueText.text = @"%";
                self.L_valuetextLeading.constant = 5.0;
                self.L_basePriceLeading.constant = 5.0;
            }
            else {
                self.L_discountValue.text = @"";
                self.L_discountValueText.text = @"";
                self.L_valuetextLeading.constant = 0.0;
                self.L_basePriceLeading.constant = 0.0;
            }
            
        }
        
    }
    else
    {
        self.L_basePrice.text = @"";
        self.L_basePrice_exposePriceText.text = @"";
        self.L_basePrice.hidden = YES;
        self.L_basePrice_exposePriceText.hidden = YES;
        self.L_basePriceCancelLine.hidden = YES;
        
        self.L_discountValue.text = @"";
        self.L_discountValueText.text = @"";
        self.L_valuetextLeading.constant = 0.0;
        self.L_basePriceLeading.constant = 0.0;

    }
    
    
    //////// 원래금액 노출 종료 ////////
    
    
    //////// valueInfo 노출 시작 ///////
    //valueInfo
    if([NCS([self.L_infoDic objectForKey:@"valueText"])  length] > 0 )
    {
        
        self.L_valuetext.hidden = NO;
        self.L_valuetext.text = [self.L_infoDic objectForKey:@"valueText"];
    }
    else
    {
        self.L_valuetext.text = @"";
        self.L_valuetext.hidden = YES;
        
    }
    
    
    //////// 방송중구매 레이어 노출 시작 //////// 20160720 추가
    if([NCS([self.L_infoDic objectForKey:@"imageLayerFlag"]) length] > 0 && [NCS([self.L_infoDic objectForKey:@"imageLayerFlag"]) isEqualToString:@"AIR_BUY"])
    {
        self.L_air_on.hidden = NO;
    }
    else
    {
        self.L_air_on.hidden = YES;
    }
    
    //////// 방송중구매 레이어 노출 종료 ////////
    
    ///////////// accessibilityLabel 적용 /////////////
    self.L_link.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([self.L_infoDic objectForKey:@"productName"]),NCS([self.L_infoDic objectForKey:@"salePrice"]),NCS([self.L_infoDic objectForKey:@"exposePriceText"])];
    
    
    
    //////////////////////////////////////////////////////////// L 종료 ///////////////////////////////////////////////////////////
    
    
    
    //////////////////////////////////////////////////////////// R 시작 ///////////////////////////////////////////////////////////
    
    
    //////////// 상품 이미지 시작 //////////
    //19금 제한?
    if([NCS([self.R_infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"])
    {
        if( [Common_Util isthisAdultCerted] == NO)
        {
            self.R_productImageView.image =  [UIImage imageNamed:@"prevent19cellimg"];
        }
        else
        {
            self.R_imageURL = NCS([self.R_infoDic objectForKey:@"imageUrl"]);
            if([self.R_imageURL length] > 0)
            {
                // 이미지 로딩
                [ImageDownManager blockImageDownWithURL:self.R_imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    
                    if (error == nil  && [self.R_imageURL isEqualToString:strInputURL]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (isInCache)
                                                        {
                                                            self.R_productImageView.image = fetchedImage;
                                                        }
                                                        else
                                                        {
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
    else
    {
        
        self.R_imageURL = NCS([self.R_infoDic objectForKey:@"imageUrl"]);
        if([self.R_imageURL length] > 0){
            
            [ImageDownManager blockImageDownWithURL:self.R_imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                
                if (error == nil  && [self.R_imageURL isEqualToString:strInputURL]){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache)
                                                    {
                                                        self.R_productImageView.image = fetchedImage;
                                                        
                                                    }
                                                    else
                                                    {
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
    
    
    ///////// 딜 벳지 노출 시작 /////////
    
    if([NCS([self.R_infoDic objectForKey:@"dealProductType"]) isEqualToString:@"Deal"]){
        self.R_LT2.hidden = NO;
    }
    else{
        self.R_LT2.hidden = YES;
    }
    
    ///////// 딜 벳지 노출 종료 /////////
    
    
    /////////// LT 벳지 카운트 정보 출력 시작 /////////
    
    if(NCO([self.R_infoDic objectForKey:@"imgBadgeCorner"])){
        
        if( !NCA([[self.R_infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ]))
        {
            self.R_LT.hidden = YES;
            self.R_LTvalue.hidden = YES;
        }
        else
        {
            
            NSString *ltvalue = NCS([   [ [ [self.R_infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] objectAtIndex:0] objectForKey: @"text" ]);
            NSString *lttype = NCS([   [ [ [self.R_infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] objectAtIndex:0] objectForKey: @"type" ]);
            // 좌상단 벳지가 있으면 랭킹 표기 안함.
            if(self.R_LT2.hidden)
            {
                
                if([[Mocha_Util trim:ltvalue] length] > 0)
                {
                    //T 이면 top5 라서 붉은 색 벳지
                    if([[Mocha_Util trim:lttype]  isEqual: @"T"])
                    {
                        self.R_LT.image = [UIImage imageNamed:@"best_ranking1-5_bg"];
                        self.R_LTvalue.textColor = [Mocha_Util getColor:@"FFFFFF"];
                    }
                    else
                    {
                        self.R_LT.image = [UIImage imageNamed:@"best_ranking6-100_bg"];
                        self.R_LTvalue.textColor = [Mocha_Util getColor:@"ee2162"];
                    }
                    
                    self.R_LT.hidden = NO;
                    self.R_LTvalue.hidden = NO;
                    self.R_LTvalue.text = ltvalue;
                    self.R_LT2.hidden = YES;
                }
                else
                {
                    self.R_LT.hidden = YES;
                    self.R_LTvalue.hidden = YES;
                }
            }
            
        }
    }
    /////////// LT 벳지 카운트 정보 출력 종료 /////////
    
    
    ////////// 상품명 노출 시작 (feat. TF)/////////
    if(NCO([self.R_infoDic objectForKey:@"infoBadge"]) && NCA([[self.R_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {
        if([(NSArray*)[[self.R_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.R_TF.hidden = NO;
            @try {
                self.R_TF.text = (NSString*)NCS([ [ [ [self.R_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
                if( [(NSString*)NCS([ [ [ [self.R_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]) length] > 0){
                    self.R_TF.textColor = [Mocha_Util getColor:(NSString*)[ [ [ [self.R_infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]];
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
    else    // nami0342 - NCA
    {
        self.R_TF.hidden = YES;
        self.R_TF.text = @"";
    }

    
    // 상품명 앞에 TF값이 있으면 넣어준다. 공간 확보용
    if( self.R_TF.hidden )
    {
        self.R_productName.text = NCS([self.R_infoDic objectForKey:@"productName"]);
    }
    else
    {
        self.R_productName.text = [NSString stringWithFormat:@"%@ %@", self.R_TF.text , NCS([self.R_infoDic objectForKey:@"productName"]) ];
    }
    
    
    self.R_productName.text =  [NSString stringWithFormat:@"%@\n ",self.R_productName.text]; //줄바꿈?
    
    
    if(self.R_productName.text.length > 0)
    {
        self.R_productName.hidden = NO;
    }
    else
    {
        self.R_productName.hidden = YES;
    }
    
    ////////// 상품명 노출 종료 //////////
    
    ///////// 프로모션 노출 시작 /////////
    self.R_promotionName.text = NCS([self.R_infoDic objectForKey:@"promotionName"]);
    if(self.R_promotionName.text.length > 0)
    {
        self.R_promotionName.hidden = NO;
        self.R_promotionName.text = [NSString stringWithFormat:@"(%@)",self.R_promotionName.text];
    }
    else
    {
        self.R_promotionName.hidden = YES;
    }
    ///////// 프로모션 노출 종료 /////////
    
    
    //////// 판매금액 노출 시작 ////////
    
    salePrice = 0;
    
    if(NCO([self.R_infoDic objectForKey:@"salePrice"])) {
        
        
        // 판매 가격
        NSString *R_removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[self.R_infoDic objectForKey:@"salePrice"]]      ];
        
        
        if( [Common_Util isThisValidWithZeroStr:R_removeCommaspricestr] == YES){
            
            salePrice = [(NSNumber *)R_removeCommaspricestr intValue];
            
            self.R_salePrice.text = [Common_Util commaStringFromDecimal:salePrice];
            
            self.R_exposePriceText.text  =  NCS([self.R_infoDic objectForKey:@"exposePriceText"]);
            
            
            self.R_salePrice.hidden = NO;
            self.R_exposePriceText.hidden = NO;
            
        }
        else
        {
            //숫자아님
            self.R_salePrice.hidden = YES;
            self.R_exposePriceText.hidden = NO;
            
        }
        
        
    }
    else
    {
        
        self.R_salePrice.hidden = YES;
        self.R_exposePriceText.hidden = YES;
    }
    
    //////// 판매금액 노출 종료 ////////
    
    //////// 원래금액 노출 시작 ////////
    
    NSString *R_removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([self.R_infoDic objectForKey:@"basePrice"])];
    basePrice = 0;
    basePrice = [(NSNumber *)R_removeCommaorgstr intValue];
    
    if (basePrice > 0 && basePrice > salePrice)
    {
        // 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        if (NCO([self.R_infoDic objectForKey:@"discountRate"]) && [ [self.R_infoDic objectForKey:@"discountRate"] intValue] < MIN_DISCOUNT_RATE_VALUE) {
            
            self.R_basePrice.text = @"";
            self.R_basePrice_exposePriceText.text = @"";
            self.R_basePriceCancelLine.hidden = YES;
            self.R_basePrice.hidden = YES;
            self.R_basePrice_exposePriceText.hidden = YES;
            
            self.R_discountValue.text = @"";
            self.R_discountValueText.text = @"";
            self.R_valuetextLeading.constant = 0.0;
            self.R_basePriceLeading.constant = 0.0;
        }
        else {
            self.R_basePrice.text = [Common_Util commaStringFromDecimal:basePrice];
            self.R_basePrice_exposePriceText.text = NCS([self.R_infoDic objectForKey:@"exposePriceText"]);
            
            self.R_basePrice.hidden = NO;
            self.R_basePrice_exposePriceText.hidden = NO;
            self.R_basePriceCancelLine.hidden = NO;
            
            
            if(self.isBanImgC2GBB == YES) { //GBB만 적용
                self.R_discountValue.text = NCS([self.R_infoDic objectForKey:@"discountRate"]);
                self.R_discountValueText.text = @"%";
                self.R_valuetextLeading.constant = 5.0;
                self.R_basePriceLeading.constant = 5.0;
            }
            else {
                self.R_discountValue.text = @"";
                self.R_discountValueText.text = @"";
                self.R_valuetextLeading.constant = 0.0;
                self.R_basePriceLeading.constant = 0.0;
            }
            
        }
        
    }
    else
    {
        self.R_basePrice.text = @"";
        self.R_basePrice_exposePriceText.text = @"";
        self.R_basePrice.hidden = YES;
        self.R_basePrice_exposePriceText.hidden = YES;
        self.R_basePriceCancelLine.hidden = YES;
        
        self.R_discountValue.text = @"";
        self.R_discountValueText.text = @"";
        self.R_valuetextLeading.constant = 0.0;
        self.R_basePriceLeading.constant = 0.0;
        
    }
    
    
    //////// 원래금액 노출 종료 ////////
    
    
    //////// valueText 노출 시작 ///////
    //valueText
    if([NCS([self.R_infoDic objectForKey:@"valueText"])  length] > 0 )
    {
        
        self.R_valuetext.hidden = NO;
        self.R_valuetext.text = [self.R_infoDic objectForKey:@"valueText"];
    }
    else
    {
        self.R_valuetext.text = @"";
        self.R_valuetext.hidden = YES;
        
    }
    
    //////// 방송중구매 레이어 노출 시작 //////// 20160720 추가
    if([NCS([self.R_infoDic objectForKey:@"imageLayerFlag"]) length] > 0 && [NCS([self.R_infoDic objectForKey:@"imageLayerFlag"]) isEqualToString:@"AIR_BUY"])
    {
        self.R_air_on.hidden = NO;
    }
    else
    {
        self.R_air_on.hidden = YES;
    }
    //////// 방송중구매 레이어 노출 종료 ////////
    
    ///////////// accessibilityLabel 적용 /////////////
    self.R_link.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([self.R_infoDic objectForKey:@"productName"]),NCS([self.R_infoDic objectForKey:@"salePrice"]),NCS([self.R_infoDic objectForKey:@"exposePriceText"])];
       
     //////////////////////////////////////////////////////////// R 종료 ///////////////////////////////////////////////////////////
    
}

//상품 클릭처리
-(IBAction)onBtnContents:(id)sender{
    
    // 0 = L, 1 = R
    if([((UIButton *)sender) tag] == 0)
    {
        [target dctypetouchEventTBCell:self.L_infoDic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"BFP"];
    }
    else
    {
        [target dctypetouchEventTBCell:self.R_infoDic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"BFP"];

    }
    
    
}





@end
