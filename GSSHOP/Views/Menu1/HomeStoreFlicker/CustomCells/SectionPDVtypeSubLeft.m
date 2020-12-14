//
//  SectionPDVtypeSubLeft.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 27..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionPDVtypeSubLeft.h"
#import "AppDelegate.h"
#import "SectionPDVtypeCell.h"

@implementation SectionPDVtypeSubLeft

@synthesize imageLoadingOperation;
@synthesize target;

@synthesize viewProductImage01;
@synthesize imgProduct01;
@synthesize viewProductDesc01;
@synthesize lblSpecialCopy01;

@synthesize dummytagTF01;
@synthesize lblProductName01;

@synthesize discountRateLabel01;
@synthesize discountRatePercentLabel01;
@synthesize extLabel01;

@synthesize gspricelabel_lmargin01;
@synthesize gsPriceLabel01;
@synthesize gsPriceWonLabel01;

@synthesize originalPriceLabel01;
@synthesize originalPriceWonLabel01;
@synthesize originalPriceLine01;

@synthesize dicRow01;
@synthesize idxRow;

@synthesize promotionName01;
@synthesize valuetext01;
@synthesize lineTop;

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo{
    dicRow01 = rowinfo;
    
    NSLog(@"dicRow01dicRow01dicRow01 = %@",dicRow01);
    
    [self setImageView:imgProduct01 withURL:[dicRow01 objectForKey:@"imageUrl"]];
    
    if (NCS([dicRow01 objectForKey:@"etcText1"])) {
        lblSpecialCopy01.text = [dicRow01 objectForKey:@"etcText1"];
    }
    
    
    
    if(NCO([dicRow01 objectForKey:@"infoBadge"]) && NCA([[dicRow01 objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {
        if([(NSArray*)[[dicRow01 objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.dummytagTF01.hidden = NO;
            @try {
                self.dummytagTF01.text = (NSString*)NCS([   [ [ [dicRow01 objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
                if( [(NSString*)NCS([ [ [ [dicRow01 objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]) length] > 0){
                    self.dummytagTF01.textColor = [Mocha_Util getColor:(NSString*)[ [ [ [dicRow01 objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"exception = %@",exception);
            }
        }
        else {
            self.dummytagTF01.hidden = YES;
            self.dummytagTF01.text = @"";
        }
    }
    else {
        self.dummytagTF01.hidden = YES;
        self.dummytagTF01.text = @"";
    }
    
    
    self.lblProductName01.text = NCS([dicRow01 objectForKey:@"productName"]);
    
    ///////// 프로모션 노출 시작 /////////
    self.promotionName01.text = NCS([dicRow01 objectForKey:@"promotionName"]);
    if(self.promotionName01.text.length > 0) {
        self.promotionName01.hidden = NO;
        self.promotionName01.text = [NSString stringWithFormat:@"(%@)",self.promotionName01.text];
    }
    else {
        self.promotionName01.hidden = YES;
    }
    ///////// 프로모션 노출 종료 /////////
    
    
    
    // 할인율 / GS가
    NSString *removeCommadrstr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",NCS([dicRow01 objectForKey:@"discountRate"])] ];
    
    if([NCS([dicRow01 objectForKey:@"discountRateText"])  length] > 0 ) {
        
        self.extLabel01.text = NCS([dicRow01 objectForKey:@"discountRateText"]);
        self.extLabel01.hidden = NO;
        CGSize extlabelsize = [self.extLabel01 sizeThatFits:extLabel01.frame.size];
        self.gspricelabel_lmargin01.constant =  kCELLCONTENTSLEFTMARGIN+extlabelsize.width+kCELLCONTENTSBETWEENMARGIN;
        self.discountRateLabel01.hidden = YES;
        self.discountRatePercentLabel01.hidden = YES;
    }
    else if(  [Common_Util isThisValidWithZeroStr:removeCommadrstr] == YES) {
        //확인이 필요하다.
        if(NCO([dicRow01 objectForKey:@"discountRate"])) {
            int discountRate = [(NSNumber *)[dicRow01 objectForKey:@"discountRate"] intValue];
            if(discountRate > 0) {
                self.discountRateLabel01.text = [NSString stringWithFormat:@"%d", discountRate];
                self.discountRateLabel01.hidden = NO;
                self.discountRatePercentLabel01.hidden = NO;
                float disratelabelsize = [self.discountRateLabel01 sizeThatFits:discountRateLabel01.frame.size].width + [self.discountRatePercentLabel01 sizeThatFits:discountRatePercentLabel01.frame.size].width;
                self.gspricelabel_lmargin01.constant =  kCELLCONTENTSLEFTMARGIN+disratelabelsize+kCELLCONTENTSBETWEENMARGIN;
                
                self.extLabel01.hidden = YES;
            }
            else {
                self.discountRateLabel01.hidden = YES;
                self.discountRatePercentLabel01.hidden = YES;
                self.gspricelabel_lmargin01.constant =  kCELLCONTENTSLEFTMARGIN;
                self.extLabel01.hidden = YES;
            }
        }
        else {
            //전체 뷰히든
            //20160630 parksegun discountRate값이 nil이면 해당 영역을 숨긴다.
            self.discountRateLabel01.hidden = YES;
            self.discountRatePercentLabel01.hidden = YES;
            
            self.extLabel01.hidden = YES;
        }
    }
    else {
        //전체 뷰히든
        self.discountRateLabel01.hidden = YES;
        self.discountRatePercentLabel01.hidden = YES;
        
        self.extLabel01.hidden = YES;
    }
    
    int salePrice = 0;
    
    if(NCO([dicRow01 objectForKey:@"salePrice"])) {
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[dicRow01 objectForKey:@"salePrice"]] ];
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES) {
            salePrice = [(NSNumber *)removeCommaspricestr intValue];
            self.gsPriceLabel01.text = [Common_Util commaStringFromDecimal:salePrice];
            self.gsPriceWonLabel01.text  =  NCS([dicRow01 objectForKey:@"exposePriceText"]);
            self.gsPriceLabel01.hidden = NO;
            self.gsPriceWonLabel01.hidden = NO;
        }
        else {
            //숫자아님
            self.gsPriceLabel01.hidden = YES;
            self.gsPriceWonLabel01.hidden = NO;
        }
    }
    else {
        self.gsPriceLabel01.hidden = YES;
        self.gsPriceWonLabel01.hidden = YES;
    }
    
    
    
    
    //실선 baseprice 원래 가격
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([dicRow01 objectForKey:@"basePrice"])];
    int basePrice = [(NSNumber *)removeCommaorgstr intValue];
    if(basePrice > 0 && basePrice > salePrice) {
        //2015/07/29 yunsang.jin 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        if(NCO([dicRow01 objectForKey:@"discountRate"]) && [ [dicRow01 objectForKey:@"discountRate"] intValue] < 1) {
            self.originalPriceLabel01.text = @"";
            self.originalPriceWonLabel01.text = @"";
            self.originalPriceLine01.hidden = YES;
            self.originalPriceLabel01.hidden = YES;
            self.originalPriceWonLabel01.hidden = YES;
        }
        else {
            
            self.originalPriceLabel01.text = [Common_Util commaStringFromDecimal:basePrice];
            self.originalPriceWonLabel01.text = NCS([dicRow01 objectForKey:@"exposePriceText"]);
            self.originalPriceLabel01.hidden = NO;
            self.originalPriceWonLabel01.hidden = NO;
            self.originalPriceLine01.hidden = NO;
        }
    }
    else {
        self.originalPriceLabel01.text = @"";
        self.originalPriceWonLabel01.text = @"";
        self.originalPriceLabel01.hidden = YES;
        self.originalPriceWonLabel01.hidden = YES;
        self.originalPriceLine01.hidden = YES;
    }
    
    if([NCS([dicRow01 objectForKey:@"valueText"])  length] > 0 ) {
        self.valuetext01.hidden = NO;
        self.valuetext01.text = [dicRow01 objectForKey:@"valueText"];
    }
    else {
        self.valuetext01.text = @"";
        self.valuetext01.hidden = YES;
    }
}

-(IBAction)onBtn:(id)sender{
    [(SectionPDVtypeCell *)target onBtnBrandBanner:dicRow01 andIndex:idxRow];
}


-(void)setImageView:(UIImageView *)imgView withURL:(NSString *)imageURL{
    
    
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 if (isInCache)
                                      {
                                          imgView.image = fetchedImage;
                                      }
                                      else
                                      {
                                          imgView.alpha = 0;
                                          imgView.image = fetchedImage;
                                          
                                          
                                          
                                          
                                          [UIView animateWithDuration:0.2f
                                                                delay:0.0f
                                                              options:UIViewAnimationOptionCurveEaseInOut
                                                           animations:^{
                                                               
                                                               imgView.alpha = 1;
                                                               
                                                           }
                                                           completion:^(BOOL finished) {
                                                               
                                                           }];
                                      }
            });
                                     
        }
      }];
}

@end
