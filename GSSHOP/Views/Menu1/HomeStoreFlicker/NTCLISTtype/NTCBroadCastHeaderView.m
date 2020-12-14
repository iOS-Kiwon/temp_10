//
//  NTCBroadCastHeaderView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 6. 2..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "NTCBroadCastHeaderView.h"
#import "AppDelegate.h"

@implementation NTCBroadCastHeaderView

@synthesize imageLoadingOperation;
@synthesize target;
@synthesize viewDefault;
@synthesize viewTop;
@synthesize lcViewTopHeight;

@synthesize viewTopIconText;
@synthesize lblStatus;
@synthesize viewTopLiveGoBtn;

@synthesize viewImgArea;
@synthesize imgProduct;
@synthesize viewImgAreaOnAir;
@synthesize lblLiveTime;
@synthesize viewImgAreaVodTime;
@synthesize lblVodTime;

@synthesize viewNalTalk;
@synthesize carouselNalTalk;
@synthesize viewProductDesc;

@synthesize viewProductDescVNP;
@synthesize productTitleLabelVNP;

@synthesize soldoutView, soldoutimgView, productTitleLabel,discountRateLabel,discountRatePercentLabel,gsLabelView,extLabel,gsPriceLabel,gsPriceWonLabel  ;
@synthesize originalPriceLabel,originalPriceWonLabel,originalPriceLine,saleCountLabel,saleSaleLabel,saleSaleSubLabel;
@synthesize dummytagVT1, dummytagVT2;
@synthesize dummytagTF1;
@synthesize valuetextLabel, valueinfoLabel;

@synthesize dicRow;
@synthesize dicProduct;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.salesalelabel_width.constant = 46;
    self.valueinfolabel_lmargin.constant = 0;
    self.producttitlelabel_lmargin.constant = 0;
    self.gspricelabel_lmargin.constant = 52;
    self.originalPricelabel_rmargin.constant = 0;
    
    self.originalPricelabel_lmargin.constant =0;
    
    self.carouselNalTalk.type = iCarouselTypeLinear;
    self.carouselNalTalk.vertical = YES;
    self.carouselNalTalk.delegate = self;
    self.carouselNalTalk.dataSource = self;
    
    NSLog(@"self.frame = %@",NSStringFromCGRect(self.frame));
    
    if (arrNalTalk == nil) {
        arrNalTalk = [[NSMutableArray alloc] init];
    }
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)showViewTop:(BOOL)isShow{
    lcViewTopHeight.constant = isShow?35.0:0;
    viewTop.hidden = !isShow;
}

-(void)setNalTalkList:(NSArray *)arrTalk{
    [arrNalTalk removeAllObjects];
    [arrNalTalk addObjectsFromArray:arrTalk];
    [self.carouselNalTalk reloadData];
    [self startScrolling];
}

-(void)setCellInfoNDrawData:(NSDictionary*)infoDic{
    NSLog(@"infoDic = %@",infoDic);

    
    self.dicRow = infoDic;
    self.backgroundColor = [UIColor clearColor];
    
    NSString *imageURL = NCS([infoDic objectForKey:@"imageUrl"]);
    if([imageURL length] > 0){
        
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){

              dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
              {
                  self.imgProduct.image = fetchedImage;
                  
              }
              else
              {
                  self.imgProduct.alpha = 0;
                  self.imgProduct.image = fetchedImage;
                  
                  
                  
                  
                  [UIView animateWithDuration:0.1f
                                        delay:0.0f
                                      options:UIViewAnimationOptionCurveEaseInOut
                                   animations:^{
                                       
                                       self.imgProduct.alpha = 1;
                                       
                                   }
                                   completion:^(BOOL finished) {
                                       
                                   }];
              }

                });
                          }
            
          }];
    }
    
    
    NSLog(@"NCS([dicRow objectForKey:onAirYn] = %@",NCS([self.dicRow objectForKey:@"onAirYn"]));
    
    if ([NCS([self.dicRow objectForKey:@"onAirYn"]) isEqualToString:@"Y"]) {
        
        //생방송 일때
        //공지사항 , 프로모션 텍스트 여부는 높이값 미리 적용해야 함으로 NTCListTBViewController 에서 설정
        
        self.viewImgAreaOnAir.hidden = NO;
        self.viewNalTalk.hidden = NO;
        self.viewImgAreaVodTime.hidden = YES;
        self.viewProductDesc.hidden = YES;
        self.viewProductDescVNP.hidden = YES;
        
        
        lblStatus.text = NCS([self.dicRow objectForKey:@"promotionName"]);
        
        
        if (NCO([self.dicRow objectForKey:@"nalTalkBanner"])) {
            
            if(NCA([[self.dicRow objectForKey:@"nalTalkBanner"] objectForKey:@"talkList"])){
                [self setNalTalkList:(NSArray *)[[self.dicRow objectForKey:@"nalTalkBanner"] objectForKey:@"talkList"]];
            }else{
                self.viewNalTalk.hidden = YES;
            }
            
        }else{
            self.viewNalTalk.hidden = YES;
        }
        
        
    }else{
        //vod 일때
        self.viewImgAreaOnAir.hidden = YES;
        self.viewNalTalk.hidden = YES;
        self.viewImgAreaVodTime.hidden = NO;
        
        self.lblVodTime.text = NCS([dicRow objectForKey:@"videoTime"]);
        self.viewProductDesc.hidden = YES;
        self.viewProductDescVNP.hidden = YES;
        
        
        if (NCO([self.dicRow objectForKey:@"product"])) {
            
            if ([[self.dicRow objectForKey:@"product"] isKindOfClass:[NSDictionary class]]) {
                NSLog(@"[self.dicRow objectForKey:product] = %@",[self.dicRow objectForKey:@"product"]);
                
                
                if ([NCS([[self.dicRow objectForKey:@"product"] objectForKey:@"viewType"]) isEqualToString:@"VP"]) { //상품 있음
                    self.viewProductDesc.hidden = NO;
                    self.viewProductDescVNP.hidden = YES;
                    [self setProductInfoData:[self.dicRow objectForKey:@"product"]];
                    
                }else if ([NCS([[self.dicRow objectForKey:@"product"] objectForKey:@"viewType"]) isEqualToString:@"VNP"]) { //상품없이 제목만
                    
                    self.viewProductDesc.hidden = YES;
                    self.viewProductDescVNP.hidden = NO;
                    self.productTitleLabelVNP.text = NCS([[self.dicRow objectForKey:@"product"] objectForKey:@"productName"]);
                    
                }
                
            }
            
        }

    }
    
    
    
}

-(void)setProductInfoData:(NSDictionary*)infoDic{
    
    
    
    //20160126 segun 숫자인지 아닌지 확인이 필요한데...... String이 아니라면?
    // soldout image view
    self.soldoutView.hidden =![(NSNumber *)NCB([infoDic objectForKey:@"isTempOut"]) boolValue];
    self.soldoutimgView.hidden =![(NSNumber *)NCB([infoDic objectForKey:@"isTempOut"]) boolValue];
    
    
    if(NCO([infoDic objectForKey:@"infoBadge"]) && NCA([[infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ]))
    {
        
        switch ([    (NSArray*)[[infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ] count]) {
            case 0:
                
                self.dummytagVT1.hidden = YES;
                self.dummytagVT2.hidden = YES;
                
                break;
                
            case 1:
                
                self.dummytagVT1.hidden = NO;
                self.dummytagVT2.hidden = YES;
                
                self.dummytagVT1.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                
                
                break;
                
            case 2:
                
                self.dummytagVT1.hidden = NO;
                self.dummytagVT2.hidden = NO;
                
                self.dummytagVT1.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                self.dummytagVT2.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ] objectAtIndex:1] objectForKey: @"type" ])  ];
                
                break;
            default:
                break;
        }
        
    }
    else    // nami0342 - NCA
    {
        self.dummytagVT1.hidden = YES;
        self.dummytagVT2.hidden = YES;
    }
    
    
    if(NCO([infoDic objectForKey:@"infoBadge"]) && NCA([[infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {

        if([(NSArray*)[[infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.dummytagTF1.hidden = NO;
            @try {
                self.dummytagTF1.text = (NSString*)NCS([ [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
                if( [(NSString*)NCS([[ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]) length] > 0){
                    self.dummytagTF1.textColor = [Mocha_Util getColor:(NSString*)[ [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"exception = %@",exception);
            }
            
            
            self.producttitlelabel_lmargin.constant = 4;
        }
        else {
            self.dummytagTF1.hidden = YES;
            self.dummytagTF1.text = @"";
            self.producttitlelabel_lmargin.constant = 0;
        }
    }
    else    // nami0342 - NCA
    {
        self.dummytagTF1.hidden = YES;
        self.dummytagTF1.text = @"";
        self.producttitlelabel_lmargin.constant = 0;
    }
    
    
    self.productTitleLabel.text = NCS([infoDic objectForKey:@"productName"]);
    
    
    
    NSString *removeCommadrstr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",NCS([infoDic objectForKey:@"discountRate"])]      ];
    
    
    if([NCS([infoDic objectForKey:@"discountRateText"])  length] > 0 ) {
        self.gsLabelView.hidden = YES;
        self.extLabel.text = NCS([infoDic objectForKey:@"discountRateText"]);
        self.extLabel.hidden = NO;
        
        CGSize extlabelsize = [self.extLabel sizeThatFits:extLabel.frame.size];
        self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN+extlabelsize.width+kCELLCONTENTSBETWEENMARGIN;
        
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
    }
    else if(  [Common_Util isThisValidWithZeroStr:removeCommadrstr] == YES){
        //확인이 필요하다.
        if(NCO([infoDic objectForKey:@"discountRate"])) {
            int discountRate = [(NSNumber *)[infoDic objectForKey:@"discountRate"] intValue];
            if(discountRate > 0) {
                self.discountRateLabel.text = [NSString stringWithFormat:@"%d", discountRate];
                self.discountRateLabel.hidden = NO;
                self.discountRatePercentLabel.hidden = NO;
                float disratelabelsize = [self.discountRateLabel sizeThatFits:discountRateLabel.frame.size].width + [self.discountRatePercentLabel sizeThatFits:discountRatePercentLabel.frame.size].width;
                self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN+disratelabelsize+kCELLCONTENTSBETWEENMARGIN;
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
    
    
    
    
    
    
    
    //valueText
    if([NCS([infoDic objectForKey:@"valueText"])  length] > 0 ) {
        
        self.gsLabelView.hidden = YES;
        self.extLabel.hidden = YES;
        
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
        
        self.valuetextLabel.text = [infoDic objectForKey:@"valueText"];
        
        CGSize vtlabelsize = [self.valuetextLabel sizeThatFits:valuetextLabel.frame.size];
        self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN+vtlabelsize.width+kCELLCONTENTSBETWEENMARGIN;
        
        self.valuetextLabel.hidden = NO;
        
        
        
        
    }else {
        self.valuetextLabel.text = @"";
        self.valuetextLabel.hidden = YES;
        
    }
    
    //valueInfo
    if([NCS([infoDic objectForKey:@"valueInfo"])  length] > 0 ) {
        
        self.valueinfoLabel.hidden = NO;
        
        self.valueinfoLabel.text = [infoDic objectForKey:@"valueInfo"];
        
        
        self.valueinfolabel_lmargin.constant = 7;
    }else{
        self.valueinfoLabel.text = @"";
        self.valueinfoLabel.hidden = YES;
        
        
        
        self.valueinfolabel_lmargin.constant = 0;
        
    }
    
    
    
    
    
    
    int salePrice = 0;
    
    if(NCO([infoDic objectForKey:@"salePrice"])) {
        
        
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"salePrice"]]      ];
        
        
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES){
            
            salePrice = [(NSNumber *)removeCommaspricestr intValue];
            
            self.gsPriceLabel.text = [Common_Util commaStringFromDecimal:salePrice];
            
            self.gsPriceWonLabel.text  =  NCS([infoDic objectForKey:@"exposePriceText"]);
            
            
            self.gsPriceLabel.hidden = NO;
            self.gsPriceWonLabel.hidden = NO;
            
        }else {
            //숫자아님
            self.gsPriceLabel.hidden = YES;
            self.gsPriceWonLabel.hidden = NO;
            
        }
        
        
    }else {
        
        self.gsPriceLabel.hidden = YES;
        self.gsPriceWonLabel.hidden = YES;
    }
    
    
    
    
    
    
    
    
    
    
    
    //실선 baseprice 원래 가격
    
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([infoDic objectForKey:@"basePrice"])];
    int basePrice = [(NSNumber *)removeCommaorgstr intValue];
    if (basePrice > 0 && basePrice > salePrice)
    {
        //2015/07/29 yunsang.jin 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        
        if (NCO([infoDic objectForKey:@"discountRate"]) && [ [infoDic objectForKey:@"discountRate"] intValue] < 1) {
            
            self.originalPriceLabel.text = @"";
            self.originalPriceWonLabel.text = @"";
            self.originalPriceLine.hidden = YES;
            self.originalPriceLabel.hidden = YES;
            self.originalPriceWonLabel.hidden = YES;
            
            self.originalPricelabel_lmargin.constant =0;
            self.originalPricelabel_rmargin.constant =0;
            
            
            if([NCS([infoDic objectForKey:@"valueInfo"] ) length] > 1 ) {
                
                self.originalPricelabel_rmargin.constant = 0;
            }else {
                
                self.originalPricelabel_rmargin.constant = 8;
            }
        }else{
            
            self.originalPriceLabel.text = [Common_Util commaStringFromDecimal:basePrice];
            self.originalPriceWonLabel.text = NCS([infoDic objectForKey:@"exposePriceText"]);
            
            self.originalPriceLabel.hidden = NO;
            self.originalPriceWonLabel.hidden = NO;
            self.originalPriceLine.hidden = NO;
            
            self.originalPricelabel_lmargin.constant =5;
            self.originalPricelabel_rmargin.constant =8;
        }
        
    }
    else
    {
        self.originalPriceLabel.text = @"";
        self.originalPriceWonLabel.text = @"";
        self.originalPriceLabel.hidden = YES;
        self.originalPriceWonLabel.hidden = YES;
        self.originalPriceLine.hidden = YES;
        
        self.originalPricelabel_lmargin.constant =0;
        self.originalPricelabel_rmargin.constant =0;
        
        
        if([NCS([infoDic objectForKey:@"valueInfo"])  length] > 1 ) {
            
            self.originalPricelabel_rmargin.constant =0;
        }else {
            
            self.originalPricelabel_rmargin.constant =8;
        }
        
    }
    
    
    
    //매진시 판매수량 노출하지않음
    if(self.soldoutView.hidden == NO) {
        self.saleCountLabel.hidden = YES;
        self.saleSaleLabel.hidden =YES;
        self.saleSaleSubLabel.hidden = YES;
        
        self.originalPricelabel_lmargin.constant =0;
        self.originalPricelabel_rmargin.constant =0;

        return;
    }
    
    
    
    
    
    
    
    
    
    
    //3열 판매수량
    if(NCO([infoDic objectForKey:@"saleQuantity"])){
        
        NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([infoDic objectForKey:@"saleQuantity"])];
        //숫자가 맞음
        if([Common_Util isThisValidNumberStr:removeCommaorgstr]){
            
            self.saleCountLabel.text = [NSString stringWithFormat:@"%@", NCS([infoDic objectForKey:@"saleQuantity"]) ];
            self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", NCS([infoDic objectForKey:@"saleQuantityText"]) ];
            self.saleSaleSubLabel.text = [NSString stringWithFormat:@"%@", NCS([infoDic objectForKey:@"saleQuantitySubText"]) ];
            
            self.saleCountLabel.hidden = NO;
            self.saleSaleLabel.hidden = NO;
            self.saleSaleSubLabel.hidden = NO;
            self.salesalelabel_width.constant = 46;
            
        }
        //숫자아니거나 0일때 수량text 존재함
        else if(  [NCS([infoDic objectForKey:@"saleQuantityText"]) length] > 0)
        {
            
            self.saleCountLabel.hidden = YES;
            self.saleSaleSubLabel.hidden = YES;
            self.saleSaleLabel.hidden = NO;
            
            
            self.salesalelabel_width.constant = 10;
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

-(IBAction)onBtnNalBangImage:(id)sender{
    [target dctypetouchEventTBCell:self.dicRow andCnum:0 withCallType:@"NALBANG_LIVE"];
}

-(IBAction)onBtnNalTalk:(id)sender{
    if (NCO([self.dicRow objectForKey:@"nalTalkBanner"])) {
        
        if([NCS([[self.dicRow objectForKey:@"nalTalkBanner"] objectForKey:@"linkUrl"]) length] > 0){
            [target dctypetouchEventTBCell:[self.dicRow objectForKey:@"nalTalkBanner"] andCnum:0 withCallType:@"NALBANG_LIVE_TALK"];
        }
        
    }
}

-(IBAction)onBtnProductDesc:(id)sender{
    if (NCO([self.dicRow objectForKey:@"product"])) {
        [target dctypetouchEventTBCell:[self.dicRow objectForKey:@"product"] andCnum:0 withCallType:@"NALBANG_LIVE"];
    }
    
}



-(UIImage*) tagimageWithtype : (NSString*)ttype {
    
    UIImage *timage;
    //RB
    if([ttype isEqualToString:@"freeDlv"]){
        
        timage = [UIImage imageNamed:@"dc_badge_free"];
    }
    else if([ttype isEqualToString:@"todayClose"]){
        
        timage = [UIImage imageNamed:@"dc_badge_end"];
    }
    
    else if([ttype isEqualToString:@"freeInstall"]){
        
        timage = [UIImage imageNamed:@"dc_badge_finstall"];
    }
    
    else if([ttype isEqualToString:@"Reserves"]){
        
        timage = [UIImage imageNamed:@"dc_badge_reward"];
    }
    else if([ttype isEqualToString:@"interestFree"]){
        
        timage = [UIImage imageNamed:@"dc_badge_nogain"];
    }
    //VT
    else if([ttype isEqualToString:@"quickDlv"]){
        
        timage = [UIImage imageNamed:@"dc_stag_delivery"];
    }
    else if([ttype isEqualToString:@"worldDlv"]){
        
        timage = [UIImage imageNamed:@"dc_btag_ocdelivery"];
    }
    
    else {
        return nil;
    }
    return timage;
}

-(void)setTextWithNextBoardTime:(NSString *)strTimeString{
    
    NSArray *arrSplitTime = [strTimeString componentsSeparatedByString:@":"];
    
    if ([arrSplitTime count] > 2) {
        NSMutableString *strTimeLeft = [[NSMutableString alloc] initWithString:@""];
        if ([[arrSplitTime objectAtIndex:0] integerValue] > 0) {
            [strTimeLeft appendString:[NSString stringWithFormat:@"%lu시간 ",(long)[[arrSplitTime objectAtIndex:0] integerValue]] ];
        }else{
            [strTimeLeft appendString:@"0시간 "];
        }
        
        if ([[arrSplitTime objectAtIndex:1] integerValue] > 0) {
            [strTimeLeft appendString:[NSString stringWithFormat:@"%lu분 ",(long)[[arrSplitTime objectAtIndex:1] integerValue]] ];
        }else{
            [strTimeLeft appendString:@"00분 "];
        }
        
        if ([[arrSplitTime objectAtIndex:2] integerValue] > 0) {
            [strTimeLeft appendString:[NSString stringWithFormat:@"%lu초",(long)[[arrSplitTime objectAtIndex:2] integerValue]] ];
        }else{
            [strTimeLeft appendString:@"00초"];
        }

        
        @try {
            lblStatus.font = [UIFont systemFontOfSize:15.0];
            lblStatus.text = [NSString stringWithFormat:@"다음 생방송까지 %@ 남음",strTimeLeft];
            
            [lblStatus setText:lblStatus.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
                
                NSRegularExpression *regexp = [[NSRegularExpression alloc] initWithPattern:strTimeLeft options:NSRegularExpressionCaseInsensitive error:nil];
                NSRange nameRange = [regexp rangeOfFirstMatchInString:[mutableAttributedString string] options:0 range:stringRange];
                UIFont *highlightFont = [UIFont boldSystemFontOfSize:15.0];
                
                CTFontRef hihiFont = CTFontCreateWithName((__bridge CFStringRef)highlightFont.fontName, highlightFont.pointSize,  NULL);
                if (hihiFont) {
                    [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:nameRange];
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)hihiFont range:nameRange];
                    
                    [mutableAttributedString addAttribute:(id)kCTForegroundColorAttributeName
                                                    value:(id)[Mocha_Util getColor:@"FF2C36"].CGColor
                                                    range:nameRange];
                    
                    CFRelease(hihiFont);
                }
                
                [mutableAttributedString replaceCharactersInRange:nameRange withString:[[[mutableAttributedString string] substringWithRange:nameRange] uppercaseString]];
                
                return mutableAttributedString;
            }];
        }
        
        @catch (NSException *exception) {
            NSLog(@"exception = %@",exception);
        }
        @finally {
            
        }
        
    }
    
    

}



#pragma mark -
#pragma mark iCarousel methods 메인 컨텐츠 페이징 + 상단 최신댓글용

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [arrNalTalk count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    UILabel *label = nil;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, carouselNalTalk.frame.size.width, carouselNalTalk.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        
        label = [[UILabel alloc] initWithFrame:view.frame];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [label.font fontWithSize:15];
        label.textColor = [Mocha_Util getColor:@"444444"];
        label.tag = 9999;
        
        label.lineBreakMode = NSLineBreakByClipping;
        
        [view addSubview:label];
        
        NSLog(@"carouselNalTalk.frame = %@",NSStringFromCGRect(carouselNalTalk.frame));
        
        NSLog(@"view.frame = %@",NSStringFromCGRect(view.frame));
        NSLog(@"label.frame = %@",NSStringFromCGRect(label.frame));
        
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:9999];
        
    }
    
    
    
    label.text = [arrNalTalk objectAtIndex:index];
   
    return view;
    
    
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionSpacing:
            return value * 1.0;
        case iCarouselOptionWrap:
            return YES;
        default:
            return value;
    }
}

#pragma mark -
#pragma mark Autoscroll

- (void)startScrolling
{
    [scrollTimer invalidate];
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                   target:self
                                                 selector:@selector(scrollStep)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (void)stopScrolling
{
    [scrollTimer invalidate];
    scrollTimer = nil;
}

- (void)scrollStep
{
    
    if (!self.carouselNalTalk.dragging && !self.carouselNalTalk.decelerating)
    {
        NSInteger idxNext = (self.carouselNalTalk.currentItemIndex+1==[arrNalTalk count])?0:self.carouselNalTalk.currentItemIndex+1;
        [self.carouselNalTalk scrollToItemAtIndex:idxNext animated:YES];
    }
    
    
}

-(void)dealloc{
    NSLog(@"");
    [self stopScrolling];
}

@end
