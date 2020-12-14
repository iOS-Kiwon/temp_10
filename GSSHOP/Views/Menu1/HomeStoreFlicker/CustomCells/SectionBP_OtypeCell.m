//
//  SectionBP_OtypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2016. 5. 19..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionBP_OtypeCell.h"
#import "Common_Util.h"
#import "AppDelegate.h"

@implementation SectionBP_OtypeCell


@synthesize view_Default,contentsView,productImage,productName,discountRate,discountRatePercent,salePrice,salePriceWon,basePrice,basePriceCancelLine,valuetext,valueinfo,TF,LT,bannerImage,arrow,noImage;
@synthesize infoDic;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


-(void) prepareForReuse {
    //아랫줄 필수]
    [super prepareForReuse];
    
    self.bannerImage.hidden = YES;
    self.productImage.hidden = YES;
    self.LT.hidden = YES;
    self.productName.text = @"";
    self.productName.hidden = YES;
    self.discountRate.text = @"";
    self.discountRate.hidden = YES;
    self.discountRatePercent.hidden =YES;
    self.salePrice.text = @"";
    self.salePrice.hidden = YES;
    self.salePriceWon.text = @"";
    self.salePriceWon.hidden = YES;
    self.basePrice.text = @"";
    self.basePrice.hidden = YES;
    self.basePriceCancelLine.hidden = YES;
    self.valueinfo.text = @"";
    self.valueinfo.hidden = YES;
    self.valuetext.text = @"";
    self.valuetext.hidden = YES;
    self.TF.text = @"";
    self.TF.hidden = YES;
    
    //하단 베너 지움.
    self.contentsView.hidden= YES;
    //하단바위치 숨김처리
    self.underLine.hidden = YES;
    self.underLine2.hidden = YES;
    self.arrow.hidden = YES;
        
    
    self.backgroundColor = [UIColor clearColor];
    
    
}

- (IBAction)clickProduct:(id)sender
{
    [_targettb dctypetouchEventTBCell:self.infoDic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"BP_O"];
    
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr{
    self.backgroundColor = [UIColor clearColor];
    //bannerImage
    self.imageURLBybanner = NCS([rowinfoArr objectForKey:@"imageUrl"]);
    if([self.imageURLBybanner length] > 0)
    {
        self.bannerImage.hidden = NO;
        
        [ImageDownManager blockImageDownWithURL:self.imageURLBybanner responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [self.imageURLBybanner isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                                          {
                                              self.bannerImage.image = fetchedImage;
                                          }
                                          else
                                          {
                                              self.bannerImage.alpha = 0;
                                              self.bannerImage.image = fetchedImage;
                                              
                                              
                                              
                                              
                                              [UIView animateWithDuration:0.2f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveEaseInOut
                                                               animations:^{
                                                                   
                                                                   self.bannerImage.alpha = 1;
                                                                   
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   
                                                               }];
                                          }
                });
                                          
                                      }
                                  }];
    }
    else
    {
        self.bannerImage.hidden = YES;
    }



     NSArray *subPro = [rowinfoArr objectForKey:@"subProductList"];
    
    if(NCA(subPro))
    {
        self.infoDic =  [subPro objectAtIndex:0];
        self.view_Default.frame = CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:160] + 130);
        self.bannerImage.frame = CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:160]);
        self.noImage.frame = self.bannerImage.frame;
        
        self.contentsView.hidden= NO;
        //하단바위치 이동? 지움?
        self.underLine.hidden = NO;
        self.underLine2.hidden = YES;
        self.arrow.hidden = NO;
        
    }
    else
    {
        
        self.view_Default.frame = CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:160]);
        self.bannerImage.frame = CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:160]);
        self.noImage.frame = self.bannerImage.frame;
        
                //하단 베너 지움.
        self.contentsView.hidden= YES;
        //하단바위치 이동? 지움?
        self.underLine.hidden = YES;
        self.underLine2.hidden = NO;
        self.underLine2.frame = CGRectMake(0, [Common_Util DPRateOriginVAL:160]-1, APPFULLWIDTH, 1);
        self.arrow.hidden = YES;
        return;
    }






    ///////////////// 하위 상품 /////////////////
    
    ///////////////// 상품이미지 시작 /////////////////
    //19금 제한
    if([NCS([self.infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"]) {
        if( [Common_Util isthisAdultCerted] == NO){
            self.productImage.image =  [UIImage imageNamed:@"prevent19cellimg"];
            self.productImage.hidden = NO;
        }else {
            
            self.imageURL = NCS([self.infoDic objectForKey:@"imageUrl"]);
            if([self.imageURL length] > 0)
            {
                // 이미지 로딩
                 self.productImage.hidden = NO;
                [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    
                    if (error == nil  && [self.imageURL isEqualToString:strInputURL]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (isInCache)
                                                      {
                                                          self.productImage.image = fetchedImage;
                                                      }
                                                      else
                                                      {
                                                          self.productImage.alpha = 0;
                                                          self.productImage.image = fetchedImage;
                                                          
                                                          
                                                          
                                                          
                                                          [UIView animateWithDuration:0.2f
                                                                                delay:0.0f
                                                                              options:UIViewAnimationOptionCurveEaseInOut
                                                                           animations:^{
                                                                               
                                                                               self.productImage.alpha = 1;
                                                                               
                                                                           }
                                                                           completion:^(BOOL finished) {
                                                                               
                                                                           }];
                                                      }

                        });
                                                                                                        }
                                              }];
                
                
                
            }
            else
            {
                 self.productImage.hidden = YES;
            }
            
            
            
        }
    }
    else
    {
        
        self.imageURL = NCS([self.infoDic objectForKey:@"imageUrl"]);
        if([self.imageURL length] > 0)
        {
            
            self.productImage.hidden = NO;
            // 이미지 로딩
            
            [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                
                if (error == nil  && [self.imageURL isEqualToString:strInputURL]){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache)
                                                  {
                                                      self.productImage.image = fetchedImage;
                                                      
                                                  }
                                                  else
                                                  {
                                                      self.productImage.alpha = 0;
                                                      self.productImage.image = fetchedImage;
                                                      
                                                      
                                                      
                                                      
                                                      [UIView animateWithDuration:0.1f
                                                                            delay:0.0f
                                                                          options:UIViewAnimationOptionCurveEaseInOut
                                                                       animations:^{
                                                                           
                                                                           self.productImage.alpha = 1;
                                                                           
                                                                       }
                                                                       completion:^(BOOL finished) {
                                                                           
                                                                       }];
                                                  }
                    });
                                                  
                                              }
                                          }];
            
            
            
        }
        else
        {
            self.productImage.hidden = YES;
        }
        
    }
    ///////////////// 상품이미지 종료 /////////////////
    
    
    /////////// LT 벳지 카운트 정보 출력 시작 /////////
    
    if([NCS([self.infoDic objectForKey:@"dealProductType"]) isEqualToString:@"Deal"]){
        self.LT.hidden = NO;
    }
    else{
        self.LT.hidden = YES;
    }
        /////////// LT 벳지 카운트 정보 출력 종료 /////////
    
    
    ////////// 상품명 노출 시작 (feat. TF)/////////
    if(NCO([self.infoDic objectForKey:@"infoBadge"]) && NCA([[self.infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {        
        if([(NSArray*)[[self.infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.TF.hidden = NO;
            @try {
                self.TF.text = (NSString*)NCS([ [ [ [self.infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
                if( [(NSString*)NCS([   [ [ [self.infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]) length] > 0){
                    self.TF.textColor = [Mocha_Util getColor: (NSString*)[ [ [ [self.infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]];
                }
                [self.TF sizeToFit];
            }
            @catch (NSException *exception) {
                NSLog(@"exception = %@",exception);
            }
        }
        else {
            self.TF.hidden = YES;
            self.TF.text = @"";
        }  
    }
    else    // nami0342 - NCA
    {
        self.TF.hidden = YES;
        self.TF.text = @"";
    }
    
    // 상품명 앞에 TF값이 있으면 넣어준다. 공간 확보용
    if( self.TF.hidden )
    {
        self.productName.text = NCS([self.infoDic objectForKey:@"productName"]);
    }
    else
    {
        self.productName.text = [NSString stringWithFormat:@"%@ %@", self.TF.text , NCS([self.infoDic objectForKey:@"productName"]) ];
    }
    
    self.productName.text =  [NSString stringWithFormat:@"%@\n ",self.productName.text]; //줄바꿈?
    
    if(self.productName.text.length > 0)
    {
        self.productName.hidden = NO;
        [self.productName sizeToFit];
        
        
        // 위치 보정 시작
        self.productName.frame = CGRectMake(10+110+15, 20, APPFULLWIDTH - 15 - self.productName.frame.origin.x, self.productName.frame.size.height);
        self.TF.frame = CGRectMake(self.productName.frame.origin.x, self.productName.frame.origin.y, self.TF.frame.size.width + 1, self.TF.frame.size.height);
    }
    else
    {
        self.productName.hidden = YES;
    }
    
    
    ////////// 상품명 노출 종료 //////////
    
    
    
    ///////// 할인율 노출 //////////
    // 할인율 / GS가
    NSString *removeCommadrstr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",NCS([self.infoDic objectForKey:@"discountRate"])]      ];
    
    
    if([NCS([self.infoDic objectForKey:@"discountRateText"])  length] > 0 ) {
        //그냥 값만 표시
        self.discountRate.text = [self.infoDic  objectForKey:@"discountRateText"];
        self.discountRate.hidden = NO;
        self.discountRatePercent.hidden = YES;
        
        [self.discountRate sizeToFit];
        //사이즈 조정
        self.discountRate.frame = CGRectMake(self.productName.frame.origin.x, 69, self.discountRate.frame.size.width, self.discountRate.frame.size.height);
    }
    else if(  [Common_Util isThisValidWithZeroStr:removeCommadrstr] == YES) {
        //확인이 필요하다.
        if(NCO([self.infoDic objectForKey:@"discountRate"])) {
            int idiscountRate = [(NSNumber *)[self.infoDic objectForKey:@"discountRate"] intValue];
            if(idiscountRate > 0) {
                self.discountRate.text = [NSString stringWithFormat:@"%d", idiscountRate];
                self.discountRatePercent.text = @"%";
                //할인율 표시
                self.discountRate.hidden = NO;
                self.discountRatePercent.hidden = NO;
                
                [self.discountRate sizeToFit];
                [self.discountRatePercent sizeToFit];
                //사이즈 조정
                self.discountRate.frame = CGRectMake(self.productName.frame.origin.x, 69, self.discountRate.frame.size.width, self.discountRate.frame.size.height);
                self.discountRatePercent.frame = CGRectMake(self.discountRate.frame.origin.x + self.discountRate.frame.size.width , 77, self.discountRatePercent.frame.size.width, self.discountRatePercent.frame.size.height);
            }
            else {
                
                self.discountRate.hidden = YES;
                self.discountRatePercent.hidden = YES;
            }
        }
        else //20160630 parksegun discountRate값이 nil이면 해당 영역을 숨긴다.
        {
            //전체 뷰히든
            self.discountRate.hidden = YES;
            self.discountRatePercent.hidden = YES;
        }
        
    }
    else
    {
        //전체 뷰히든
        self.discountRate.hidden = YES;
        self.discountRatePercent.hidden = YES;
    }
    

    
    //////// 판매금액 노출 시작 ////////
    
    int isalePrice = 0;
    
    if(NCO([self.infoDic objectForKey:@"salePrice"]))
    {
        
        
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"salePrice"]]      ];
        
        
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES){
            
            isalePrice = [(NSNumber *)removeCommaspricestr intValue];
            
            self.salePrice.text = [Common_Util commaStringFromDecimal:isalePrice];
            
            self.salePriceWon.text  =  NCS([self.infoDic objectForKey:@"exposePriceText"]);
            
            
            self.salePrice.hidden = NO;
            self.salePriceWon.hidden = NO;
            
            // 위치 보정
            [self.salePrice sizeToFit];
            [self.salePriceWon sizeToFit];
            //마진, 이미지, GS가 포함 여백
            int margin = 0;
            if(self.discountRate.hidden == YES && self.discountRatePercent.hidden == NO) //GS가
            {
                margin = 10+110 + 15 + self.discountRatePercent.frame.size.width + 8;
            }
            else if(self.discountRate.hidden == NO && self.discountRatePercent.hidden == NO) //할인율
            {
                margin = 10+110 + 15 + self.discountRate.frame.size.width + self.discountRatePercent.frame.size.width + 8;
            }
            else // 없음.
            {
                margin = self.productName.frame.origin.x;
            }
            self.salePrice.frame = CGRectMake(margin, 78, self.salePrice.frame.size.width, self.salePrice.frame.size.height);
            
            
            self.salePriceWon.frame = CGRectMake(self.salePrice.frame.origin.x + self.salePrice.frame.size.width, self.salePrice.frame.origin.y + (self.salePrice.frame.size.height - self.salePriceWon.frame.size.height) - 1, self.salePriceWon.frame.size.width, self.salePriceWon.frame.size.height);
            
            
        }
        else
        {
            //숫자아님
            self.salePrice.hidden = YES;
            self.salePriceWon.hidden = YES;
            
        }
        
        
    }
    else
    {
        
        self.salePrice.hidden = YES;
        self.salePriceWon.hidden = YES;
    }
    
    //////// 판매금액 노출 종료 ////////
    
    
    //////// 원래금액 노출 시작 ////////
    
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([self.infoDic objectForKey:@"basePrice"])];
    int ibasePrice = [(NSNumber *)removeCommaorgstr intValue];
    if (ibasePrice > 0 && ibasePrice > isalePrice)
    {
        // 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        
        if (NCO([self.infoDic objectForKey:@"discountRate"]) && [ [self.infoDic objectForKey:@"discountRate"] intValue] < 1)
        {
            self.basePrice.text = @"";
            self.basePriceCancelLine.hidden = YES;
            self.basePrice.hidden = YES;
        }
        else
        {
            
            self.basePrice.text = [NSString stringWithFormat:@"%@%@",[Common_Util commaStringFromDecimal:ibasePrice], NCS([self.infoDic objectForKey:@"exposePriceText"]) ];
            
            self.basePrice.hidden = NO;
            self.basePriceCancelLine.hidden = NO;
            
            NSDictionary *fontWithAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            CGSize textSize =  [[Common_Util commaStringFromDecimal:ibasePrice] sizeWithAttributes:fontWithAttributes];
            
            //위치 보정
            [self.basePrice sizeToFit];
            self.basePrice.frame = CGRectMake(self.salePrice.frame.origin.x, self.salePrice.frame.origin.y - self.basePrice.frame.size.height + 2, self.basePrice.frame.size.width, self.basePrice.frame.size.height);
            self.basePriceCancelLine.frame = CGRectMake(self.basePrice.frame.origin.x, 64 + self.basePrice.frame.size.height/2, textSize.width, 1);
            
        }
        
    }
    else
    {
        self.basePrice.text = @"";
        self.basePrice.hidden = YES;
        self.basePriceCancelLine.hidden = YES;
        
    }
    
    
    //////// 원래금액 노출 종료 ////////

    //////// valueText 노출 시작 ///////
    if([NCS([self.infoDic objectForKey:@"valueText"])  length] > 0 )
    {
        
        self.valuetext.hidden = NO;
        self.valuetext.text = [self.infoDic objectForKey:@"valueText"];
        [self.valuetext sizeToFit];
        self.valuetext.frame = CGRectMake(self.salePrice.frame.origin.x, self.salePrice.frame.origin.y - self.valuetext.frame.size.height + 2, self.valuetext.frame.size.width, self.valuetext.frame.size.height);
        
    }
    else
    {
        self.valuetext.text = @"";
        self.valuetext.hidden = YES;
        
    }
    //////// valueText 노출 종료 ///////

}




@end
