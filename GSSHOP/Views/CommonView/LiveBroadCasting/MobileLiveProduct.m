//
//  MobileLiveProduct.m
//  GSSHOP
//
//  Created by nami0342 on 15/02/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "MobileLiveProduct.h"

@implementation MobileLiveProduct

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) setData : (NSDictionary *) dicData
{
    
    NSLog(@"dicDatadicData = %@",dicData);
    
    self.m_strDirectOrderURL = NCS([dicData objectForKey:@"directBuyUrl"]);
    self.m_strPreviewURL = NCS([dicData objectForKey:@"previewUrl"]);
    
    if([self.m_strPreviewURL length] > 0)
    {
        NSString *strTemp = @"external://prePrd?";
        if([Mocha_Util strContain:strTemp srcstring:self.m_strPreviewURL] == YES)
        {
            self.m_strPreviewURL = [self.m_strPreviewURL substringFromIndex:strTemp.length];
        }
    }
    
    // 보험 : 렌탈/시공/여행 관련 분기
    /*
     rentalText : 월 렌탈료 or 상담신청상품 텍스트
     rentalPrice
     mnlyRentCostVal : 상품 렌탈정보 attr2번항목
     attrCharVal15 : 단일가격 (N일때 (미체크시) 물결표시)

     위 4개 컬럼에 대해 신규로 추가했습니다.
     추가로 기존에 있던 컬럼 (salePrice, productType 등)을 고려하여 로직 개발하면 될 듯 합니다.
     */
    
    // 16 - bold
    NSDictionary *nomalTextAttr11 = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                                    NSForegroundColorAttributeName : [Mocha_Util getColor:@"111111"]
                                    };
    
    // 13 - regular
    NSDictionary *nomalTextAttr12 = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                    NSForegroundColorAttributeName : [Mocha_Util getColor:@"111111"]
                                    };
    
    // 13 - bold
    NSDictionary *nomalTextAttr13 = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13],
    NSForegroundColorAttributeName : [Mocha_Util getColor:@"111111"]
    };
    
    
    NSString *strProductType = NCS([dicData objectForKey:@"productType"]);
    NSString *strSalePrice = NCS([dicData objectForKey:@"salePrice"]);
    NSString *strRentalText = NCS([dicData objectForKey:@"rentalText"]);
    NSString *strRentalPrice = NCS([dicData objectForKey:@"rentalPrice"]);
    
    // 무형상품 구분
    if([strProductType isEqualToString:@"T"] || [strProductType isEqualToString:@"U"] ||
       [strProductType isEqualToString:@"S"] || [strProductType isEqualToString:@"I"] ||
       [strProductType isEqualToString:@"R"])
    {
        // 렌탈 관련
        if([strRentalPrice length] != 0 && [strRentalPrice isEqualToString:@"0"] == NO)
        {
            // 렌탈 텍스트에 월, 월 렌탈료 등 텍스트가 있다. = 앞에 '월' 붙여줌
            NSMutableAttributedString *attrMsg10 = [[NSMutableAttributedString alloc]initWithString:@"" attributes:nomalTextAttr13];
            if([strRentalText hasPrefix:@"월"] == YES)
            {
                attrMsg10 = [[NSMutableAttributedString alloc]initWithString:@"월" attributes:nomalTextAttr13];
            }
            
            // 렌탈 가격이더라도 안드로이드처럼 salePrice만으로 처리 나머지는 붙인다.
            NSMutableAttributedString *attrMsg11 = [[NSMutableAttributedString alloc]initWithString:strSalePrice attributes:nomalTextAttr11];
            
            [attrMsg10 appendAttributedString:attrMsg11];
             
            
            // 가격 뒤 '원' / '원~' 붙는 텍스트를 확인
            NSString *strExtraPriceTxt = NCS([dicData objectForKey:@"exposStartPriceTxt"]);
            
            if([strExtraPriceTxt length] > 0)
            {
                NSMutableAttributedString *attrMsg12 = [[NSMutableAttributedString alloc]initWithString:strExtraPriceTxt attributes:nomalTextAttr12];
                
                [attrMsg10 appendAttributedString:attrMsg12];
            }
            
            [self.m_lbSalePrice setAttributedText:attrMsg10];
            
            [self.m_btnDirectOrder setTitle:@"구매하기" forState:UIControlStateNormal];
            [self.m_btnDirectOrder setBackgroundColor:[Mocha_Util getColor:@"ee1f60"]];
            [self.m_btnDirectOrder setAlpha:1.0];
        }
        else
        {
            // 보험 => 상담신청 상품 || 렌탈 가격 없으면
            [self.m_btnDirectOrder setTitle:@"상담신청" forState:UIControlStateNormal];
            [self.m_btnDirectOrder setBackgroundColor:[Mocha_Util getColor:@"ee1f60"]];
            [self.m_btnDirectOrder setAlpha:1.0];
            
            NSMutableAttributedString *attrMsg11 = [[NSMutableAttributedString alloc]initWithString:@"상담신청상품" attributes:nomalTextAttr13];
            
            [self.m_lbSalePrice setAttributedText:attrMsg11];
        }
        
        
        // rental price > 0 이지만 버튼이 상담하기 '상담하기' 일 경우 가 있어 분기 처리
        // 혹시 몰라 무형상품 전체에 적용
        NSString *strDirectOdrText = NCS([dicData objectForKey:@"directOrdText"]);
        if([strDirectOdrText length] > 0)
        {
            [self.m_btnDirectOrder setTitle:strDirectOdrText forState:UIControlStateNormal];
            [self.m_btnDirectOrder setBackgroundColor:[Mocha_Util getColor:@"ee1f60"]];
            [self.m_btnDirectOrder setAlpha:1.0];
        }
    }
    else
    {
        // 일반 상품
        NSMutableAttributedString *attrMsg11 = [[NSMutableAttributedString alloc]initWithString:strSalePrice attributes:nomalTextAttr11];
        
        NSMutableAttributedString *attrMsg12 = [[NSMutableAttributedString alloc]initWithString:@"원" attributes:nomalTextAttr12];
        
        
        [attrMsg11 appendAttributedString:attrMsg12];
        
        [self.m_lbSalePrice setAttributedText:attrMsg11];
        
        [self.m_btnDirectOrder setTitle:@"구매하기" forState:UIControlStateNormal];
        [self.m_btnDirectOrder setBackgroundColor:[Mocha_Util getColor:@"ee1f60"]];
        [self.m_btnDirectOrder setAlpha:1.0];
    }
    
    //Temp Out
    NSString *strTempOut = NCS([dicData objectForKey:@"tempOut"]);
    if([strTempOut isEqualToString:@"1"] == YES)
    {
        [self.m_btnDirectOrder setTitle:@"일시품절" forState:UIControlStateNormal];
        [self.m_btnDirectOrder setBackgroundColor:[Mocha_Util getColor:@"000000"]];
        [self.m_btnDirectOrder setAlpha:0.4];
    }
    
    
    // Original price check
//    if([NCS([dicData objectForKey:@"basePrice"]) length] > 0)
//    {
//        if([NCS([dicData objectForKey:@"basePrice"]) isEqualToString:@"0"] == YES)
//        {
//            self.m_vDash.hidden = YES;
//            self.m_lbProductOriginalPrice.hidden = YES;
//        }
//        else
//        {
//            NSString *strOriginalPrice = NCS([dicData objectForKey:@"basePrice"]);
//            self.m_vDash.hidden = NO;
//            strOriginalPrice = [strOriginalPrice stringByAppendingString:@"원"];
//            [self.m_lbProductOriginalPrice setText:strOriginalPrice];
//        }
//    }
//    else
//    {
//        self.m_vDash.hidden = YES;
//        self.m_lbProductOriginalPrice.hidden = YES;
//    }
    
    
    
    
    // Set product with prefix title.
    NSString *strProduct = NCS([dicData objectForKey:@"productName"]);
    NSString *strPrefix = @"";
    
    NSDictionary *nomalTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName : [Mocha_Util getColor:@"444444"]
                                    };
    
    
    if(NCO([dicData objectForKey:@"infoBadge"]) && NCA([[dicData objectForKey:@"infoBadge"] objectForKey:@"TF" ]))
    {
        strPrefix = NCS([[[[dicData objectForKey:@"infoBadge"] objectForKey:@"TF"] objectAtIndex:0] objectForKey: @"text" ]);
        UIColor *colorPrefix = [Mocha_Util getColor:NCS([[[[dicData objectForKey:@"infoBadge"] objectForKey:@"TF"]objectAtIndex:0]objectForKey: @"type" ])];
        
        NSDictionary *spetialTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                          NSForegroundColorAttributeName : colorPrefix};
        
        NSMutableAttributedString *attrMsg0 = [[NSMutableAttributedString alloc]initWithString:strPrefix attributes:spetialTextAttr];
        NSMutableAttributedString *attrMsg1 = [[NSMutableAttributedString alloc]initWithString:strProduct attributes:nomalTextAttr];
        NSMutableAttributedString *attrMsg9 = [[NSMutableAttributedString alloc]initWithString:@" " attributes:nomalTextAttr];
        
        [attrMsg0 appendAttributedString:attrMsg9];
        [attrMsg0 appendAttributedString:attrMsg1];
        
        [self.m_lbProductTitle setAttributedText:attrMsg0];
    }
    else
    {
        NSMutableAttributedString *attrMsg1 = [[NSMutableAttributedString alloc]initWithString:strProduct attributes:nomalTextAttr];
        [self.m_lbProductTitle setAttributedText:attrMsg1];
    }
    
    [self.m_lbProductTitle setAdjustsFontSizeToFitWidth:YES];
    
    
    
    //
    NSString *strImg = NCS([dicData objectForKey:@"imageUrl"]);
    [ImageDownManager blockImageDownWithURL:strImg responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.m_imgProduct setImage:fetchedImage];
            
            [self.m_imgProduct.layer setBorderWidth:0.5];
            [self.m_imgProduct.layer setBorderUIColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.06]];
            
        });
    }];
    
    // Set Product broadcast time -> 나중에 사용할 상품 인덱스 용
//    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
//    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
//    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
//
//    NSDate *endTime = [dateformat dateFromString:NCS([dicData objectForKey:@"dealStrDate"])];
//    double endtimestamp = [endTime timeIntervalSince1970];
//    self.m_dblDateOfEnd = endtimestamp;
}


- (IBAction) click_directOrder:(id)sender
{
    [self.delegate MobileLiveProduct_DirectOrderClick:self.m_strDirectOrderURL];
}

- (IBAction) click_ALL:(id)sender
{
    [self.delegate MobileLiveProduct_Preview:self.m_strPreviewURL];
}



@end
