//
//  SectionMAP_CX_GBB_PRDtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 29..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_CX_GBB_PRDtypeCell.h"
#import "SUPListTableViewController.h"
#import "Common_Util.h"
#import "AppDelegate.h"

#define MIN_DISCOUNT_RATE_VALUE 1

@implementation SectionMAP_CX_GBB_PRDtypeCell


@synthesize target;
@synthesize L_infoDic,L_imageLoadingOperationByLT;
@synthesize R_infoDic,R_imageLoadingOperationByLT;

@synthesize L_productImageView ,L_productName,L_salePrice,L_exposePriceText,L_basePrice,L_basePrice_exposePriceText,L_basePriceCancelLine,L_LT,L_LTvalue,L_TF,L_valuetext,L_LT2,L_air_on;


@synthesize R_productImageView ,R_productName,R_salePrice,R_exposePriceText,R_basePrice,R_basePrice_exposePriceText,R_basePriceCancelLine,R_LT,R_LTvalue,R_TF,R_valuetext,R_LT2,R_air_on;

@synthesize R_View;



- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
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
    self.L_salePrice.hidden = YES;
    self.L_TF.hidden = YES;
    self.L_valuetext.hidden = YES;
    self.L_valuetext.text = @"";
    self.L_salePrice.text = @"";
    self.L_productName.text = @"";
    self.L_LTvalue.text = @"";
    self.L_exposePriceText.text = @"";
    self.L_basePrice_exposePriceText.text = @"";
    self.L_basePrice.text = @"";
    self.L_productImageView.image = nil;
    self.L_LT.image = nil;
    self.L_LT2.hidden = YES;
    self.L_air_on.hidden = YES;
    self.L_LinkBtn01.accessibilityLabel = @"";
    self.L_LinkBtn02.accessibilityLabel = @"";
    self.L_lblPercentText.text = @"";
    self.L_viewFullBanner.hidden = YES;
    self.L_imgFullBanner.image = nil;
    
    
    self.R_basePriceCancelLine.hidden = YES;
    self.R_basePrice.hidden = YES;
    self.R_basePrice_exposePriceText.hidden = YES;
    self.R_exposePriceText.hidden = YES;
    self.R_LT.hidden = YES;
    self.R_LTvalue.hidden = YES;
    self.R_productName.hidden = YES;
    self.R_salePrice.hidden = YES;
    self.R_TF.hidden = YES;
    self.R_valuetext.hidden = YES;
    self.R_valuetext.text = @"";
    self.R_salePrice.text = @"";
    self.R_productName.text = @"";
    self.R_LTvalue.text = @"";
    self.R_exposePriceText.text = @"";
    self.R_basePrice_exposePriceText.text = @"";
    self.R_basePrice.text = @"";
    self.R_productImageView.image = nil;
    self.R_LT.image = nil;
    self.R_LT2.hidden = YES;
    self.R_air_on.hidden = YES;
    self.R_LinkBtn01.accessibilityLabel = @"";
    self.R_LinkBtn02.accessibilityLabel = @"";
    self.R_lblPercentText.text = @"";
    self.R_viewFullBanner.hidden = YES;
    self.R_imgFullBanner.image = nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic{
    
    BOOL isFullBannerLeft = NO;
    BOOL isFullBannerRight = NO;
    
    //self.L_productName.text = @"";
    
    if (NCA([rowinfoDic objectForKey:@"subProductList"]) && [(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] > 0)
    {
        self.L_infoDic =  [[rowinfoDic objectForKey:@"subProductList"] objectAtIndex:0];
        
        if([(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] >= 2)
        {
            self.R_infoDic =  [[rowinfoDic objectForKey:@"subProductList"] objectAtIndex:1];
            self.R_View.hidden = NO;
            
            
        }
        else
        {
            self.R_infoDic = nil;
            // 왼쪽엔 노출되지 않도록 처리 (회색? 흰색)
            self.R_View.hidden = YES;
            
        }
        
        isFullBannerLeft = [NCS([self.L_infoDic objectForKey:@"viewType"]) isEqualToString:@"IMG_ONLY"];
        isFullBannerRight = [NCS([self.R_infoDic objectForKey:@"viewType"]) isEqualToString:@"IMG_ONLY"];

        self.L_viewFullBanner.hidden = !isFullBannerLeft;
        self.R_viewFullBanner.hidden = !isFullBannerRight;
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
                                if (isFullBannerLeft) {
                                    self.L_imgFullBanner.image = fetchedImage;
                                    
                                    
                                }else{
                                    self.L_productImageView.image = fetchedImage;
                                }
                                
                            }
                            else
                            {
                                
                                
                                if (isFullBannerLeft) {
                                    self.L_imgFullBanner.alpha = 0;
                                    self.L_imgFullBanner.image = fetchedImage;
                                }else{
                                    self.L_productImageView.alpha = 0;
                                    self.L_productImageView.image = fetchedImage;
                                }
                                
                                [UIView animateWithDuration:0.2f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseInOut
                                                 animations:^{
                                                     
                                                     if (isFullBannerLeft) {
                                                         self.L_imgFullBanner.alpha = 1;
                                                     }else{
                                                         self.L_productImageView.alpha = 1;
                                                     }
                                                     
                                                     
                                                     
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
                            if (isFullBannerLeft) {
                                self.L_imgFullBanner.image = fetchedImage;
                            }else{
                                self.L_productImageView.image = fetchedImage;
                            }
                            
                        }
                        else
                        {
                            
                            
                            if (isFullBannerLeft) {
                                self.L_imgFullBanner.alpha = 0;
                                self.L_imgFullBanner.image = fetchedImage;
                            }else{
                                self.L_productImageView.alpha = 0;
                                self.L_productImageView.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 
                                                 if (isFullBannerLeft) {
                                                     self.L_imgFullBanner.alpha = 1;
                                                 }else{
                                                     self.L_productImageView.alpha = 1;
                                                 }
                                                 
                                                 
                                                 
                                             }
                                             completion:^(BOOL finished)
                             {
                                 
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
            
            self.L_lblPercent.text = @"";
            self.L_lblPercentText.text = @"";
            self.LvalueTextLeading.constant = 0.0;
            self.LbasePriceLeading.constant = 0.0;
        }
        else
        {
            
            self.L_basePrice.text = [Common_Util commaStringFromDecimal:basePrice];
            self.L_basePrice_exposePriceText.text = NCS([self.L_infoDic objectForKey:@"exposePriceText"]);
            
            self.L_basePrice.hidden = NO;
            self.L_basePrice_exposePriceText.hidden = NO;
            self.L_basePriceCancelLine.hidden = NO;
            
            self.L_lblPercent.text = NCS([self.L_infoDic objectForKey:@"discountRate"]);
            self.L_lblPercentText.text = @"%";
            self.LvalueTextLeading.constant = 5;
            self.LbasePriceLeading.constant = 5;
            
            
        }
        
    }
    else
    {
        self.L_basePrice.text = @"";
        self.L_basePrice_exposePriceText.text = @"";
        self.L_basePrice.hidden = YES;
        self.L_basePrice_exposePriceText.hidden = YES;
        self.L_basePriceCancelLine.hidden = YES;
        
        self.L_lblPercent.text = @"";
        self.L_lblPercentText.text = @"";
        self.LvalueTextLeading.constant = 0.0;
        self.LbasePriceLeading.constant = 0.0;
        
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
    //접근성 버그로 인해 버튼 2개를 분리해서 적용함
    self.L_LinkBtn01.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([self.L_infoDic objectForKey:@"productName"]),NCS([self.L_infoDic objectForKey:@"salePrice"]),NCS([self.L_infoDic objectForKey:@"exposePriceText"])];
    self.L_LinkBtn02.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([self.L_infoDic objectForKey:@"productName"]),NCS([self.L_infoDic objectForKey:@"salePrice"]),NCS([self.L_infoDic objectForKey:@"exposePriceText"])];

    
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
                                if (isFullBannerRight) {
                                    self.R_imgFullBanner.image = fetchedImage;
                                }else{
                                    self.R_productImageView.image = fetchedImage;
                                }
                                
                            }
                            else
                            {
                                
                                
                                if (isFullBannerRight) {
                                    self.R_imgFullBanner.alpha = 0;
                                    self.R_imgFullBanner.image = fetchedImage;
                                }else{
                                    self.R_productImageView.alpha = 0;
                                    self.R_productImageView.image = fetchedImage;
                                }
                                
                                [UIView animateWithDuration:0.2f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseInOut
                                                 animations:^{
                                                     
                                                     if (isFullBannerRight) {
                                                         self.R_imgFullBanner.alpha = 1;
                                                     }else{
                                                         self.R_productImageView.alpha = 1;
                                                     }
                                                     
                                                     
                                                     
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
                            if (isFullBannerRight) {
                                self.R_imgFullBanner.image = fetchedImage;
                            }else{
                                self.R_productImageView.image = fetchedImage;
                            }
                            
                        }
                        else
                        {
                            
                            
                            if (isFullBannerRight) {
                                self.R_imgFullBanner.alpha = 0;
                                self.R_imgFullBanner.image = fetchedImage;
                            }else{
                                self.R_productImageView.alpha = 0;
                                self.R_productImageView.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 
                                                 if (isFullBannerRight) {
                                                     self.R_imgFullBanner.alpha = 1;
                                                 }else{
                                                     self.R_productImageView.alpha = 1;
                                                 }
                                                 
                                                 
                                                 
                                             }
                                             completion:^(BOOL finished)
                             {
                                 
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
            
            self.R_lblPercent.text = @"";
            self.R_lblPercentText.text = @"";
            self.RvalueTextLeading.constant = 0.0;
            self.RbasePriceLeading.constant = 0.0;
        }
        else
        {
            
            self.R_basePrice.text = [Common_Util commaStringFromDecimal:basePrice];
            self.R_basePrice_exposePriceText.text = NCS([self.R_infoDic objectForKey:@"exposePriceText"]);
            
            self.R_basePrice.hidden = NO;
            self.R_basePrice_exposePriceText.hidden = NO;
            self.R_basePriceCancelLine.hidden = NO;
            
            
            self.R_lblPercent.text = NCS([self.R_infoDic objectForKey:@"discountRate"]);            
            self.R_lblPercentText.text = @"%";
            self.RvalueTextLeading.constant = 5.0;
            self.RbasePriceLeading.constant = 5.0;
            
        }
        
    }
    else
    {
        self.R_basePrice.text = @"";
        self.R_basePrice_exposePriceText.text = @"";
        self.R_basePrice.hidden = YES;
        self.R_basePrice_exposePriceText.hidden = YES;
        self.R_basePriceCancelLine.hidden = YES;
        
        self.R_lblPercent.text = @"";
        self.R_lblPercentText.text = @"";
        self.RvalueTextLeading.constant = 0.0;
        self.RbasePriceLeading.constant = 0.0;
        
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
    //접근성 버그로인해 버튼2개를 분리함
    self.R_LinkBtn01.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([self.R_infoDic objectForKey:@"productName"]),NCS([self.R_infoDic objectForKey:@"salePrice"]),NCS([self.R_infoDic objectForKey:@"exposePriceText"])];
    self.R_LinkBtn02.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([self.R_infoDic objectForKey:@"productName"]),NCS([self.R_infoDic objectForKey:@"salePrice"]),NCS([self.R_infoDic objectForKey:@"exposePriceText"])];
    
    //////////////////////////////////////////////////////////// R 종료 ///////////////////////////////////////////////////////////
    
}

//상품 클릭처리
-(IBAction)onBtnContents:(id)sender{
    
    // 0 = L, 1 = R
    NSString *strLink = nil;
    if([((UIButton *)sender) tag] == 0)
    {
        strLink = NCS([self.L_infoDic objectForKey:@"linkUrl"]);
        //[target dctypetouchEventTBCell:self.L_infoDic  andCnum:[NSNumber numberWithInt:(int)[sender tag]] withCallType:@"BFP"];
    }
    else
    {
        strLink = NCS([self.R_infoDic objectForKey:@"linkUrl"]);
        //[target dctypetouchEventTBCell:self.R_infoDic  andCnum:[NSNumber numberWithInt:(int)[sender tag]] withCallType:@"BFP"];
    }
    
    if ([target respondsToSelector:@selector(onBtnSUPCellJustLinkStr:)] && [strLink length] > 0) {
        [target onBtnSUPCellJustLinkStr:strLink];
    }
    
}

-(IBAction)onBtnCart:(id)sender{
    NSDictionary *dicSend = nil;
    if (sender == self.L_cartBtn) {
        dicSend = self.L_infoDic;
    }else{
        dicSend = self.R_infoDic;
    }
    
    if ([target respondsToSelector:@selector(addCartProcess:)] && NCO(dicSend)) {
        [target addCartProcess:dicSend];
    }
}

@end
