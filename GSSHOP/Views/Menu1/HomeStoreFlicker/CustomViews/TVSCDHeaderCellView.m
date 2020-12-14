//
//  TVSCDHeaderCellView.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 22..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "TVSCDHeaderCellView.h"

@implementation TVSCDHeaderCellView

@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize productImageView;
@synthesize priceLabel,wonLabel,onAirText, councelText;
@synthesize  target;


@synthesize onAirTime;
@synthesize originalPriceLabel;
@synthesize originalPriceLine;
@synthesize originalPriceWonLabel;
@synthesize air_buy,sold_out;


- (void)awakeFromNib {
    [super awakeFromNib];
}


-(void)dealloc {
    self.productImageView = nil;
    self.priceLabel =nil;
    self.wonLabel = nil;
    self.onAirText = nil;
    self.councelText = nil;
    self.sold_out = nil;
    self.air_buy = nil;
}


- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe {
    self = [super init];
    if (self) {
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"TVSCDHeaderCellView" owner:self options:nil];
        self = [nibs objectAtIndex:0];
        target = sender;
        self.frame = tframe;
        self.wonLabel.text = GSSLocalizedString(@"section_customview_tvscdheadercell_won");
        self.onAirText.text = GSSLocalizedString(@"section_customview_tvscdheadercell_onair");
    }
    return self;
}


- (void)drawRect:(CGRect)rect {

}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    
    NSString *strStartTime = nil;
    NSString *strCloseTime = nil;
    
    @try {
        NSString *strToSub = nil;
        if ([[rowinfoArr objectForKey:@"broadCloseTime"] isKindOfClass:[NSString class]]) {
            strToSub = [rowinfoArr objectForKey:@"broadCloseTime"];
        }
        else{
            strToSub = [NSString stringWithFormat:@"%d",[[rowinfoArr objectForKey:@"broadCloseTime"] intValue]];
        }
        
        strCloseTime = [NSString stringWithFormat:@"%@:%@",[strToSub substringWithRange:NSMakeRange(8, 2)],[strToSub substringWithRange:NSMakeRange(10, 2)]];
    }
    @catch (NSException *exception) {
        NSLog(@"broadCloseTime exception = %@",exception);
    }
    
    @try {
        NSString *strToSub = nil;
        if ([[rowinfoArr objectForKey:@"broadStartTime"] isKindOfClass:[NSString class]]) {
            strToSub = [rowinfoArr objectForKey:@"broadStartTime"];
        }
        else {
            strToSub = [NSString stringWithFormat:@"%d",[[rowinfoArr objectForKey:@"broadStartTime"] intValue]];
        }
        
        strStartTime = [NSString stringWithFormat:@"%@:%@",[strToSub substringWithRange:NSMakeRange(8, 2)],[strToSub substringWithRange:NSMakeRange(10, 2)]];
    }
    @catch (NSException *exception) {
        NSLog(@"broadStartTime exception = %@",exception);
    }
    
    
    onAirTime.text = [NSString stringWithFormat:@"%@ ~ %@",strStartTime,strCloseTime];
    productTitleLabel.text = NCS([rowinfoArr objectForKey:@"productName"]);
    label_broadType.text = NCS([rowinfoArr objectForKey:@"broadType"]);
    
    if( [NCS([rowinfoArr objectForKey:@"liveBenefitsYn"]) isEqualToString:@"Y"]) {
        self.onAirText.text = [NSString stringWithFormat:@"%@", NCS([rowinfoArr objectForKey:@"liveBenefitsText"])  ];
    }
    else if( [NCS([rowinfoArr objectForKey:@"liveBenefitsYn"]) isEqualToString:@"B"]) {
        self.onAirText.textColor = [Mocha_Util getColor:@"00AEBD"];
        self.onAirText.text = [NSString stringWithFormat:@"%@", NCS([rowinfoArr objectForKey:@"liveBenefitsText"])  ];
    }
    else {
        self.onAirText.text = @"";
    }
    
    
    if( [[rowinfoArr objectForKey:@"isRental"] intValue] == YES || [[rowinfoArr objectForKey:@"isCellPhone"] intValue] == YES ) {
        self.priceLabel.hidden =  YES;
        self.wonLabel.hidden = YES;
        self.councelText.hidden = NO;
    }
    else {
        self.councelText.hidden = YES;
        self.priceLabel.hidden =  NO;
        self.wonLabel.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"%@", NCS([rowinfoArr objectForKey:@"salePrice"])  ];
        self.wonLabel.text = [NSString stringWithFormat:@"%@", NCS([rowinfoArr objectForKey:@"exposePriceText"])  ];
    }
    
    CGSize size = [self.priceLabel sizeThatFits:self.priceLabel.frame.size];
    self.priceLabel.frame =  CGRectMake(self.priceLabel.frame.origin.x, self.priceLabel.frame.origin.y, size.width, self.priceLabel.frame.size.height);
    CGSize wonsize = [self.wonLabel sizeThatFits:self.wonLabel.frame.size];
    self.wonLabel.frame =  CGRectMake(self.priceLabel.frame.origin.x+size.width, self.wonLabel.frame.origin.y, wonsize.width , self.wonLabel.frame.size.height);
    int salePrice = 0;
    
    if([rowinfoArr objectForKey:@"salePrice"] != nil) {
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[rowinfoArr objectForKey:@"salePrice"]]      ];
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES) {
            salePrice = [(NSNumber *)removeCommaspricestr intValue];
        }
    }
    
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:[rowinfoArr objectForKey:@"basePrice"]];
    int basePrice = [(NSNumber *)removeCommaorgstr intValue];
    if (basePrice > 0 && basePrice > salePrice) {
        self.originalPriceLabel.text = [Common_Util commaStringFromDecimal:basePrice];
        self.originalPriceWonLabel.text = [rowinfoArr objectForKey:@"exposePriceText"];
        
        CGSize oripriceSize = [self.originalPriceLabel sizeThatFits:self.originalPriceLabel.frame.size];
        self.originalPriceLabel.frame =  CGRectMake(self.wonLabel.frame.origin.x+self.wonLabel.frame.size.width + 8.0, self.originalPriceLabel.frame.origin.y, oripriceSize.width , self.originalPriceLabel.frame.size.height);
        self.originalPriceLine.frame =  CGRectMake(self.wonLabel.frame.origin.x+self.wonLabel.frame.size.width + 8.0, self.originalPriceLine.frame.origin.y, oripriceSize.width , self.originalPriceLine.frame.size.height);
        
        CGSize oripriceWonSize = [self.originalPriceWonLabel sizeThatFits:self.originalPriceWonLabel.frame.size];
        self.originalPriceWonLabel.frame =  CGRectMake(self.originalPriceLabel.frame.origin.x+self.originalPriceLabel.frame.size.width, self.originalPriceWonLabel.frame.origin.y, oripriceWonSize.width , self.originalPriceWonLabel.frame.size.height);
    }
    else {
        self.originalPriceLabel.hidden = YES;
        self.originalPriceWonLabel.hidden = YES;
        self.originalPriceLine.hidden = YES;
    }

    
    NSString *imageURL = NCS([rowinfoArr objectForKey:@"imageUrl"]);
    
    if( [imageURL length] > 0) {
        
        // 이미지 로딩
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){
                
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
    
    
    //////// 방송중구매 레이어 노출 시작 //////// 20160720 추가
    if([NCS([rowinfoArr objectForKey:@"imageLayerFlag"]) length] > 0 && [NCS([rowinfoArr objectForKey:@"imageLayerFlag"]) isEqualToString:@"AIR_BUY"]) {
        self.air_buy.hidden = NO;
    }
    else {
        self.air_buy.hidden = YES;
    }
    //////// 방송중구매 레이어 노출 종료 ////////
    
    //////// 일시품절 레이어 노출 시작 //////// 20160720 추가
    if([NCS([rowinfoArr objectForKey:@"imageLayerFlag"]) length] > 0 && [NCS([rowinfoArr objectForKey:@"imageLayerFlag"]) isEqualToString:@"SOLD_OUT"]) {
        self.sold_out.hidden = NO;
    }
    else {
        self.sold_out.hidden = YES;
    }
    //////// 일시품절 레이어 노출 종료 ////////

    //////// 하단 혜택 딱지 노출 시작 ////////20170929
    
    benefitview = [[[NSBundle mainBundle] loadNibNamed:@"BenefitTagView" owner:self options:nil] firstObject];
    [self addSubview:benefitview];
    
    benefitview.frame = CGRectMake(0, 208 , self.frame.size.width, BENEFITTAG_HEIGTH);
    
    [benefitview setBenefitTag:rowinfoArr];
    
    //////// 하단 혜택 딱지 노출 종료 ////////
    
}


@end
