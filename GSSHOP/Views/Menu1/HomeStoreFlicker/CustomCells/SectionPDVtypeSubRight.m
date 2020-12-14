//
//  SectionPDVtypeSubRight.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 27..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionPDVtypeSubRight.h"
#import "AppDelegate.h"
#import "SectionPDVtypeCell.h"

@implementation SectionPDVtypeSubRight

@synthesize imageLoadingOperation;
@synthesize target;

@synthesize viewProductImage02;
@synthesize imgProduct02;
@synthesize viewProductDesc02;
@synthesize lblSpecialCopy02;

@synthesize dummytagTF02;
@synthesize lblProductName02;

@synthesize discountRateLabel02;
@synthesize discountRatePercentLabel02;
@synthesize extLabel02;

@synthesize gspricelabel_lmargin02;
@synthesize gsPriceLabel02;
@synthesize gsPriceWonLabel02;

@synthesize originalPriceLabel02;
@synthesize originalPriceWonLabel02;
@synthesize originalPriceLine02;

@synthesize dicRow02;
@synthesize idxRow;

@synthesize promotionName02;
@synthesize valuetext02;

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo{
    dicRow02 = rowinfo;
    
    NSLog(@"dicRow02dicRow02dicRow02 = %@",dicRow02);
    
    [self setImageView:imgProduct02 withURL:[dicRow02 objectForKey:@"imageUrl"]];
    
    if (NCS([dicRow02 objectForKey:@"etcText1"])) {
        lblSpecialCopy02.text = [dicRow02 objectForKey:@"etcText1"];
    }
    
    
    
    if(NCO([dicRow02 objectForKey:@"infoBadge"]) && NCA([[dicRow02 objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {
        if([(NSArray*)[[dicRow02 objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.dummytagTF02.hidden = NO;
            @try {
                self.dummytagTF02.text = (NSString*)NCS([ [ [ [dicRow02 objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
                if( [(NSString*)NCS([ [ [ [dicRow02 objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]) length] > 0){
                    self.dummytagTF02.textColor = [Mocha_Util getColor: (NSString*)[   [ [ [dicRow02 objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"exception = %@",exception);
            }
        }
        else {
            self.dummytagTF02.hidden = YES;
            self.dummytagTF02.text = @"";
        }
    }
    else {
        self.dummytagTF02.hidden = YES;
        self.dummytagTF02.text = @"";
    }
    
    
    self.lblProductName02.text = NCS([dicRow02 objectForKey:@"productName"]);
    
    
    
    ///////// 프로모션 노출 시작 /////////
    self.promotionName02.text = NCS([dicRow02 objectForKey:@"promotionName"]);
    if(self.promotionName02.text.length > 0)
    {
        self.promotionName02.hidden = NO;
        self.promotionName02.text = [NSString stringWithFormat:@"(%@)",self.promotionName02.text];
    }
    else
    {
        self.promotionName02.hidden = YES;
    }
    ///////// 프로모션 노출 종료 /////////
    
    
    
    
    
    
    // 할인율 / GS가
    NSString *removeCommadrstr02 = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",NCS([dicRow02 objectForKey:@"discountRate"])] ];
    
    if([NCS([dicRow02 objectForKey:@"discountRateText"])  length] > 0 ) {        
        self.extLabel02.text = NCS([dicRow02 objectForKey:@"discountRateText"]);
        self.extLabel02.hidden = NO;
        
        CGSize extlabelsize = [self.extLabel02 sizeThatFits:extLabel02.frame.size];
        self.gspricelabel_lmargin02.constant =  kCELLCONTENTSLEFTMARGIN+extlabelsize.width+kCELLCONTENTSBETWEENMARGIN;
        
        self.discountRateLabel02.hidden = YES;
        self.discountRatePercentLabel02.hidden = YES;
    }
    
    else if(  [Common_Util isThisValidWithZeroStr:removeCommadrstr02] == YES){
        //확인이 필요하다.
        if(NCO([dicRow02 objectForKey:@"discountRate"])) {
            int discountRate = [(NSNumber *)[dicRow02 objectForKey:@"discountRate"] intValue];
            if(discountRate > 0) {
                self.discountRateLabel02.text = [NSString stringWithFormat:@"%d", discountRate];
                self.discountRateLabel02.hidden = NO;
                self.discountRatePercentLabel02.hidden = NO;
                float disratelabelsize = [self.discountRateLabel02 sizeThatFits:discountRateLabel02.frame.size].width + [self.discountRatePercentLabel02 sizeThatFits:discountRatePercentLabel02.frame.size].width;
                self.gspricelabel_lmargin02.constant =  kCELLCONTENTSLEFTMARGIN+disratelabelsize+kCELLCONTENTSBETWEENMARGIN;
                self.extLabel02.hidden = YES;
            }
            else {
                self.discountRateLabel02.hidden = YES;
                self.discountRatePercentLabel02.hidden = YES;
                self.gspricelabel_lmargin02.constant = kCELLCONTENTSLEFTMARGIN;
                self.extLabel02.hidden = YES;
            }
        }
        else {
            //전체 뷰히든
            //20160630 parksegun discountRate값이 nil이면 해당 영역을 숨긴다.
            self.discountRateLabel02.hidden = YES;
            self.discountRatePercentLabel02.hidden = YES;
            self.extLabel02.hidden = YES;
        }
        
    }
    else {
        //전체 뷰히든        
        self.discountRateLabel02.hidden = YES;
        self.discountRatePercentLabel02.hidden = YES;
        self.extLabel02.hidden = YES;
    }
    
    int salePrice02 = 0;
    
    if(NCO([dicRow02 objectForKey:@"salePrice"])) {
        
        
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[dicRow02 objectForKey:@"salePrice"]]      ];
        
        
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES){
            
            salePrice02 = [(NSNumber *)removeCommaspricestr intValue];
            
            self.gsPriceLabel02.text = [Common_Util commaStringFromDecimal:salePrice02];
            
            self.gsPriceWonLabel02.text  =  NCS([dicRow02 objectForKey:@"exposePriceText"]);
            
            
            self.gsPriceLabel02.hidden = NO;
            self.gsPriceWonLabel02.hidden = NO;
            
        }else {
            //숫자아님
            self.gsPriceLabel02.hidden = YES;
            self.gsPriceWonLabel02.hidden = NO;
            
        }
        
        
    }else {
        
        self.gsPriceLabel02.hidden = YES;
        self.gsPriceWonLabel02.hidden = YES;
    }
    
    //실선 baseprice 원래 가격
    NSString *removeCommaorgstr02 = [Mocha_Util strReplace:@"," replace:@"" string:NCS([dicRow02 objectForKey:@"basePrice"])];
    int basePrice02 = [(NSNumber *)removeCommaorgstr02 intValue];
    if (basePrice02 > 0 && basePrice02 > salePrice02)
    {
        //2025/07/29 yunsang.jin 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        
        if (NCO([dicRow02 objectForKey:@"discountRate"]) && [ [dicRow02 objectForKey:@"discountRate"] intValue] < 1) {
            
            self.originalPriceLabel02.text = @"";
            self.originalPriceWonLabel02.text = @"";
            self.originalPriceLine02.hidden = YES;
            self.originalPriceLabel02.hidden = YES;
            self.originalPriceWonLabel02.hidden = YES;
            
        }else{
            
            self.originalPriceLabel02.text = [Common_Util commaStringFromDecimal:basePrice02];
            self.originalPriceWonLabel02.text = NCS([dicRow02 objectForKey:@"exposePriceText"]);
            
            self.originalPriceLabel02.hidden = NO;
            self.originalPriceWonLabel02.hidden = NO;
            self.originalPriceLine02.hidden = NO;
            
        }
        
    }
    else
    {
        self.originalPriceLabel02.text = @"";
        self.originalPriceWonLabel02.text = @"";
        self.originalPriceLabel02.hidden = YES;
        self.originalPriceWonLabel02.hidden = YES;
        self.originalPriceLine02.hidden = YES;
        
        
    }
    
    
    if([NCS([dicRow02 objectForKey:@"valueText"])  length] > 0 )
    {
        
        self.valuetext02.hidden = NO;
        self.valuetext02.text = [dicRow02 objectForKey:@"valueText"];
    }
    else
    {
        self.valuetext02.text = @"";
        self.valuetext02.hidden = YES;
        
    }
    
    
}
-(IBAction)onBtn:(id)sender{
    [(SectionPDVtypeCell *)target onBtnBrandBanner:dicRow02 andIndex:idxRow];
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
