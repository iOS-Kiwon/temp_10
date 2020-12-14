//
//  TableHeaderDCtypeView.m
//  GSSHOP
//
//  Created by gsshop on 2015. 4. 2..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "TableHeaderDCtypeView.h"
#import "Common_Util.h"
#import "AppDelegate.h"


@implementation TableHeaderDCtypeView


@synthesize target, productImageView,soldoutImageView, videoImageView, productTitleLabel, productSubTitleLabel, discountRateLabel,discountRatePercentLabel,gsLabelView,extLabel,gsPriceLabel,gsPriceWonLabel  ;
@synthesize originalPriceLabel,originalPriceWonLabel,originalPriceLine,saleCountLabel,saleSaleLabel,saleSaleSubLabel,btn_no1best,imageURL;
@synthesize tagfreeImageView, tagquickImageView,tag_no1BestDeal;


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.btn_no1best.hidden = YES;
    
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    if(getLongerScreenLength == 1024){
        self.productImageView.frame = CGRectMake(0, 0, 320, 160);
    }
    
    
    
    
}

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe
{
    
    self = [super init];
    if (self)
    {
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"TableHeaderDCtypeView" owner:self options:nil];
        
        self = [nibs objectAtIndex:0];
        target = sender;
        self.frame = tframe;

        
    }
    return self;
    
    
    
}


-(void)drawRect:(CGRect)rect {
    
    
    
    
}


-(void) setCellInfoNDrawData:(NSDictionary*) infoDic
{
    
    self.tagfreeImageView.hidden = YES;
    self.tagquickImageView.hidden = YES;
    self.tag_no1BestDeal.hidden = YES;
    
    //NSLog(@"인포딕 %@", infoDic);
    
    rdic = infoDic;
    if([NCS([infoDic objectForKey:@"imageUrl"]) length] > 0){
        
        
        // 이미지 로딩
        self.imageURL = NCS([infoDic objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [self.imageURL isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                                              {
                                                  self.productImageView.image = fetchedImage;
                                              }
                                              else
                                              {
                                                  self.productImageView.alpha = 0;
                                                  self.productImageView.image = fetchedImage;
                                                  
                                                  
                                                  
                                                  
                                                  [UIView animateWithDuration:0.2f
                                                                        delay:0.0f
                                                                      options:UIViewAnimationOptionCurveEaseInOut
                                                                   animations:^{
                                                                       
                                                                       self.productImageView.alpha = 1;
                                                                       
                                                                   }
                                                                   completion:^(BOOL finished) {
                                                                       
                                                                   }];
                                              }
                });
                                              
                                          }
                                      }];
        
        
        
    }
    
    
    
    self.tagfreeImageView.hidden = ![NCS([infoDic objectForKey:@"freeDlvYn"]) isEqualToString:@"Y"];
    self.tagquickImageView.hidden = ![NCS([infoDic objectForKey:@"quickShippingYn"]) isEqualToString:@"Y"];
    self.tag_no1BestDeal.hidden = ![NCS([infoDic objectForKey:@"no1DealYn"]) isEqualToString:@"Y"];
    
    if( ![NCS([infoDic objectForKey:@"freeDlvYn"]) isEqualToString:@"Y"] && [NCS([infoDic objectForKey:@"quickShippingYn"]) isEqualToString:@"Y"]) {
        
        
        self.tagquickImageView.frame = CGRectMake(248, 137, 72, 24);
        
    }
    
         
    
    
    // soldout image view
    self.soldoutImageView.hidden = ![(NSNumber *)[infoDic objectForKey:@"isTempOut"] boolValue];
    
    // video image view
    self.videoImageView.hidden = ![(NSNumber *)[infoDic objectForKey:@"hasVod"] boolValue];
    
    // title
    
    if([NCS([infoDic objectForKey:@"isNo1Schedule"]) isEqualToString:@"Y"]){
        productTitleLabel.frame = CGRectMake(productTitleLabel.frame.origin.x, productTitleLabel.frame.origin.y, APPFULLWIDTH-86 , productTitleLabel.frame.size.height);
    }else {
        productTitleLabel.frame = CGRectMake(productTitleLabel.frame.origin.x, productTitleLabel.frame.origin.y, APPFULLWIDTH-26 , productTitleLabel.frame.size.height);
        
    }
    
    
    self.productTitleLabel.text = NCS([infoDic objectForKey:@"productName"]);
    
    
    
    //A타입 = 광고 일반타입 광고셀
    if( [NCS([infoDic objectForKey:@"productType"]) isEqualToString:@"AD"] &&
       [NCS([infoDic objectForKey:@"viewType"]) isEqualToString:@"L"]
       ){
        
        if([infoDic objectForKey:@"promotionName"] != [NSNull null]){
            self.productSubTitleLabel.text = NCS([infoDic objectForKey:@"promotionName"]);
            self.productSubTitleLabel.hidden = NO;
        }
        
        
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
        self.gsLabelView.hidden = YES;
        self.extLabel.hidden = YES;
        
        self.gsPriceLabel.hidden = YES;
        self.gsPriceWonLabel.hidden = YES;
        self.originalPriceLabel.hidden = YES;
        self.originalPriceWonLabel.hidden = YES;
        self.originalPriceLine.hidden = YES;
        
        
        self.saleCountLabel.hidden = YES;
        self.saleSaleLabel.hidden =YES;
        self.saleSaleSubLabel.hidden = YES;
        return;
    }
    
    
    //I타입 =보험 광고셀
    if( [NCS([infoDic objectForKey:@"productType"]) isEqualToString:@"I"]  ){
        
        
        self.productSubTitleLabel.text = [infoDic objectForKey:@"promotionName"];
        self.productSubTitleLabel.hidden = NO;
        
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
        self.gsLabelView.hidden = YES;
        self.extLabel.hidden = YES;
        
        self.gsPriceLabel.hidden = YES;
        self.gsPriceWonLabel.hidden = YES;
        self.originalPriceLabel.hidden = YES;
        self.originalPriceWonLabel.hidden = YES;
        self.originalPriceLine.hidden = YES;
        
        
        
        //매진시 판매수량 노출하지않음
        if(self.soldoutImageView.hidden == NO) {
            self.saleCountLabel.hidden = YES;
            self.saleSaleLabel.hidden =YES;
            self.saleSaleSubLabel.hidden = YES;
            
            return;
        }
        
        
        if([infoDic objectForKey:@"saleQuantity"] != [NSNull null]){
            
            NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:[infoDic objectForKey:@"saleQuantity"]];
            //숫자가 맞음
            if([Common_Util isThisValidNumberStr:removeCommaorgstr]){
                
                self.saleCountLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantity"] ];
                self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantityText"] ];
                self.saleSaleSubLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantitySubText"] ];
                
                [self.saleSaleSubLabel sizeToFit];
                [self.saleSaleLabel sizeToFit];
                [self.saleCountLabel sizeToFit];
                
                int e1padd= 3;
                
                //아랫줄 위치교정  Celltype=320을 쓰지만 view 는 APPFULLWIDTH
                self.saleSaleSubLabel.frame =  CGRectMake( APPFULLWIDTH- self.saleSaleSubLabel.frame.size.width -10, self.saleSaleSubLabel.frame.origin.y, self.saleSaleSubLabel.frame.size.width, self.saleSaleSubLabel.frame.size.height);
                
                if([[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantitySubText"] ] isEqualToString:@""]) { e1padd = 0; }
                
                self.saleSaleLabel.frame =  CGRectMake(self.saleSaleSubLabel.frame.origin.x-self.saleSaleLabel.frame.size.width-e1padd, self.saleSaleLabel.frame.origin.y, self.saleSaleLabel.frame.size.width, self.saleSaleLabel.frame.size.height);
                
                
                self.saleCountLabel.frame =  CGRectMake(self.saleSaleLabel.frame.origin.x -  self.saleCountLabel.frame.size.width , self.saleSaleLabel.frame.origin.y, self.saleCountLabel.frame.size.width, self.saleCountLabel.frame.size.height);
                
                self.saleCountLabel.hidden = NO;
                self.saleSaleLabel.hidden = NO;
                self.saleSaleSubLabel.hidden = NO;
                
                
            }
            //숫자아니거나 0일때 수량text 존재함
            else if(  [NCS([infoDic objectForKey:@"saleQuantityText"]) length] > 0)
            {
                self.saleCountLabel.hidden = YES;
                self.saleSaleSubLabel.hidden = YES;
                self.saleSaleLabel.hidden = NO;
                
                //saleSaleLabel  확장시키자
                self.saleSaleLabel.frame = CGRectMake(APPFULLWIDTH-180-10, 193, 180, 15);
                
                self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantityText"] ];
            }
            
            else {
                //숫자가 아니거나 0인경우 사라짐
                self.saleCountLabel.hidden = YES;
                self.saleSaleLabel.hidden =YES;
                self.saleSaleSubLabel.hidden = YES;
            }
            
            
        }
        
        return;
    }
    


    // 할인율 / GS가
    
    NSString *removeCommadrstr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"discountRate"]]      ];
    
    
    if([NCS([infoDic objectForKey:@"discountRateText"])  length] > 0 ) {
        self.gsLabelView.hidden = YES;
        self.extLabel.text = NCS([infoDic objectForKey:@"discountRateText"]);
        self.extLabel.hidden = NO;
        {
            UILabel *label = self.extLabel;
            CGSize size = [label sizeThatFits:label.frame.size];
            label.frame = CGRectMake(label.frame.origin.x,
                                     label.frame.origin.y,
                                     size.width,
                                     label.frame.size.height);
        }
        
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
    }
    else if(  [Common_Util isThisValidWithZeroStr:removeCommadrstr] == YES) {
        if(NCO([infoDic objectForKey:@"discountRate"])) {
            int discountRate = [(NSNumber *)[infoDic objectForKey:@"discountRate"] intValue];
            if(discountRate > 0) {
                self.discountRateLabel.text = [NSString stringWithFormat:@"%d", discountRate];
                UILabel *label = self.discountRateLabel;
                UIView *nextView = self.discountRatePercentLabel;
                float nextOffset = 0;
                {
                    CGSize size = [label sizeThatFits:label.frame.size];
                    label.frame = CGRectMake(label.frame.origin.x,
                                             label.frame.origin.y,
                                             size.width,
                                             label.frame.size.height);
                    nextView.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + nextOffset,
                                                nextView.frame.origin.y,
                                                nextView.frame.size.width,
                                                nextView.frame.size.height);
                }
                
                self.discountRateLabel.hidden = NO;
                self.discountRatePercentLabel.hidden = NO;
                self.gsLabelView.hidden = YES;
                self.extLabel.hidden = YES;
            }
            else {
                self.discountRateLabel.hidden = YES;
                self.discountRatePercentLabel.hidden = YES;
                self.gsLabelView.hidden = YES;
                self.extLabel.hidden = YES;
            }
        }
        else {
            //전체 뷰히든
            //20160630 parksegun discountRate값이 nil이면 해당 영역을 숨긴다.
            self.discountRateLabel.hidden = YES;
            self.discountRatePercentLabel.hidden = YES;
            self.gsLabelView.hidden = YES;
            self.extLabel.hidden = YES;
        }
        
        
    }
    else {
        //전체 뷰히든
        
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
        self.gsLabelView.hidden = YES;
        self.extLabel.hidden = YES;
    }
    
    
    
    
    
    //}
    int salePrice = 0;
    
    if([infoDic objectForKey:@"salePrice"] != [NSNull null]) {
        
        // 판매 가격
        NSString *removeCommastr = [Mocha_Util strReplace:@"," replace:@"" string:[infoDic objectForKey:@"salePrice"]];
        
        salePrice = [(NSNumber *)removeCommastr intValue];
        
        self.gsPriceLabel.text = [Common_Util commaStringFromDecimal:salePrice];
        
        self.gsPriceWonLabel.text  =  [infoDic objectForKey:@"exposePriceText"]  ;
        
        NSDictionary *fontWithAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGSize priceWonLabelSize =  [self.gsPriceWonLabel.text  sizeWithAttributes:fontWithAttributes];
        
        self.gsPriceWonLabel.frame = CGRectMake(self.gsPriceWonLabel.frame.origin.x, self.gsPriceWonLabel.frame.origin.y, priceWonLabelSize.width,  self.gsPriceWonLabel.frame.size.height);
        
        
        
        
        UILabel *label = self.gsPriceLabel;
        UIView *nextView = self.gsPriceWonLabel;
        float nextOffset = 0;
        UIView *prevView = (self.extLabel.hidden ? (self.gsLabelView.hidden ? self.discountRatePercentLabel : self.gsLabelView) : self.extLabel);
        float prevOffset = 8;
        {
            CGSize size = [label sizeThatFits:label.frame.size];
            label.frame = CGRectMake(prevView.frame.origin.x + prevView.frame.size.width + prevOffset,
                                     label.frame.origin.y,
                                     size.width,
                                     label.frame.size.height);
            nextView.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + nextOffset,
                                        nextView.frame.origin.y,
                                        nextView.frame.size.width,
                                        nextView.frame.size.height);
        }
        
        
        
    }
    
    
    // 원래 가격
    
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:[infoDic objectForKey:@"basePrice"]];
    int basePrice = [(NSNumber *)removeCommaorgstr intValue];
    if (basePrice > 0 && basePrice > salePrice)
    {
        
        self.originalPriceLabel.text = [Common_Util commaStringFromDecimal:basePrice];
        self.originalPriceWonLabel.text = [infoDic objectForKey:@"exposePriceText"];
        
        UILabel *label = self.originalPriceLabel;
        UIView *nextView = self.originalPriceWonLabel;
        float nextOffset = 0;
        UIView *prevView =self.gsPriceWonLabel;
        float prevOffset = 5;
        {
            CGSize size = [label sizeThatFits:label.frame.size];
            label.frame = CGRectMake(prevView.frame.origin.x + prevView.frame.size.width + prevOffset,
                                     label.frame.origin.y,
                                     size.width,
                                     label.frame.size.height);
            nextView.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + nextOffset,
                                        nextView.frame.origin.y,
                                        nextView.frame.size.width,
                                        nextView.frame.size.height);
        }
        
        CGSize opricewonsize = [self.originalPriceWonLabel sizeThatFits:self.originalPriceWonLabel.frame.size];
        self.originalPriceWonLabel.frame = CGRectMake(self.originalPriceWonLabel.frame.origin.x, self.originalPriceWonLabel.frame.origin.y, opricewonsize.width,self.originalPriceWonLabel.frame.size.height);
        
        self.originalPriceLine.frame = CGRectMake(self.originalPriceLabel.frame.origin.x,
                                                  self.originalPriceLine.frame.origin.y,
                                                  self.originalPriceWonLabel.frame.origin.x + self.originalPriceWonLabel.frame.size.width - self.originalPriceLabel.frame.origin.x,
                                                  self.originalPriceLine.frame.size.height);
        
        self.originalPriceLabel.hidden = NO;
        self.originalPriceWonLabel.hidden = NO;
        self.originalPriceLine.hidden = NO;
        
        
        
    }
    else
    {
        self.originalPriceLabel.hidden = YES;
        self.originalPriceWonLabel.hidden = YES;
        self.originalPriceLine.hidden = YES;
        
    }
      
     
    
    
    
    if([infoDic objectForKey:@"saleQuantity"] != [NSNull null]){
        
        NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:[infoDic objectForKey:@"saleQuantity"]];
        //숫자가 맞음
        if([Common_Util isThisValidNumberStr:removeCommaorgstr]){
            
            self.saleCountLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantity"] ];
            self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantityText"] ];
            self.saleSaleSubLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantitySubText"] ];
            
            [self.saleSaleSubLabel sizeToFit];
            [self.saleSaleLabel sizeToFit];
            [self.saleCountLabel sizeToFit];
            
            int e1padd= 3;
            
            //위치교정
            self.saleSaleSubLabel.frame =  CGRectMake( APPFULLWIDTH- self.saleSaleSubLabel.frame.size.width -10, self.saleSaleSubLabel.frame.origin.y, self.saleSaleSubLabel.frame.size.width, self.saleSaleSubLabel.frame.size.height);
            
            if([[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantitySubText"] ] isEqualToString:@""]) { e1padd = 0; }
            
            self.saleSaleLabel.frame =  CGRectMake(self.saleSaleSubLabel.frame.origin.x-self.saleSaleLabel.frame.size.width-e1padd, self.saleSaleLabel.frame.origin.y, self.saleSaleLabel.frame.size.width, self.saleSaleLabel.frame.size.height);
            
            
            self.saleCountLabel.frame =  CGRectMake(self.saleSaleLabel.frame.origin.x -  self.saleCountLabel.frame.size.width , self.saleSaleLabel.frame.origin.y, self.saleCountLabel.frame.size.width, self.saleCountLabel.frame.size.height);
            
            self.saleCountLabel.hidden = NO;
            self.saleSaleLabel.hidden = NO;
            self.saleSaleSubLabel.hidden = NO;
            
            
        }
        //숫자아니거나 0일때 수량text 존재함
        else if(  [NCS([infoDic objectForKey:@"saleQuantityText"]) length] > 0)
        {
            self.saleCountLabel.hidden = YES;
            self.saleSaleSubLabel.hidden = YES;
            self.saleSaleLabel.hidden = NO;
            
            //saleSaleLabel  확장시키자
            self.saleSaleLabel.frame = CGRectMake(APPFULLWIDTH-180-10, 193, 180, 15);
            
            self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantityText"] ];
        }
        
        else {
            //숫자가 아니거나 0인경우 사라짐
            self.saleCountLabel.hidden = YES;
            self.saleSaleLabel.hidden =YES;
            self.saleSaleSubLabel.hidden = YES;
        }
        
        
    }
    

    
    
    
}
-(IBAction)clickEvtwithDic:(id)sender {
    //calltype N andCnum 은 GTM 로깅용도
    [target dctypetouchEventTBCell:rdic andCnum:[NSNumber numberWithInt:(int)0] withCallType:@"Sec_TodayDeal"];
    
}
@end
