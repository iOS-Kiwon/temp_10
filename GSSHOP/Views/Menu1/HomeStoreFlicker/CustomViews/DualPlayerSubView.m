//
//  DualPlayerSubView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 2. 9..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "DualPlayerSubView.h"
#import "DualPlayerView.h"
#import "TDCLiveTBViewController.h"
#import "AppDelegate.h"

@implementation DualPlayerSubView

- (void)awakeFromNib {
    [super awakeFromNib];
 
    
    self.btnLiveTalk.layer.borderWidth = 1.0;
    self.btnLiveTalk.layer.cornerRadius = 2.0;
    self.btnLiveTalk.layer.shouldRasterize = YES;
    self.btnLiveTalk.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.btnLiveTalk.layer.borderColor = [Mocha_Util getColor:@"C9C9C9"].CGColor;
    
    self.btnSchedule.layer.borderWidth = 1.0;
    self.btnSchedule.layer.cornerRadius = 2.0;
    self.btnSchedule.layer.shouldRasterize = YES;
    self.btnSchedule.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.btnSchedule.layer.borderColor = [Mocha_Util getColor:@"C9C9C9"].CGColor;
    
    self.btnPurchase.layer.cornerRadius = 2.0;
    self.btnPurchase.layer.shouldRasterize = YES;
    self.btnPurchase.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.lblMobilePrice.numberOfLines = 0;
    
    
}

-(void)dealloc{
    NSLog(@"deallocdeallocdeallocdeallocdealloc");
}

- (void)sectionReloadTimerRemove{
    [self stopTimer];
}

-(void)stopTimer{
    if([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"");
    }
}

-(IBAction)onBtnPlay:(id)sender{

    if ([self.lefttimelabel.text isEqualToString:GSSLocalizedString(@"home_tv_live_view_close_text")]) {
        
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"tvShopBroadCastEnd_Popup") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        [ApplicationDelegate.window addSubview:lalert];
        
    }else{
    
        if ([self.target respondsToSelector:@selector(onBtnPlayDualSub:)]) {
            if (self.isDualTvLive == YES) {
                [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00053-C-2_PLAY")];
                [self.target onBtnPlayDualSub:YES];
            }else{
                [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00053-C-2_DPLAY")];
                [self.target onBtnPlayDualSub:NO];
            }
        }
    }
}

- (void) setCellInfoNDrawData:(NSDictionary*) infoDic {
    
    self.dicRowInfo = [infoDic copy];
    
    self.viewTagMobilePrice.hidden = YES;
    self.viewTagPercent.hidden = YES;
    self.viewTagGsPrice.hidden = YES;
    self.lblBasePrice.hidden = YES;
    self.lblBasePriceWon.hidden = YES;
    self.viewBasePriceStrikeLine.hidden = YES;
    self.lblPerMonth.hidden = YES;
    self.lblSalePrice.hidden = YES;
    self.lblSalePriceWon.hidden = YES;
    self.lblCounsel.hidden = YES;
    
    if (self.isDualTvLive == YES) {
        self.imgLiveOrMyShop.image = [UIImage imageNamed:@"dualplayer_live-logo.png"];
        //self.lconstWidthImgLiveOrShop.constant = 99.0;
    }else{
        self.imgLiveOrMyShop.image = [UIImage imageNamed:@"dualplayer_myshop-logo.png"];
        //self.lconstWidthImgLiveOrShop.constant = 99.0;
    }
    
    if([self.dicRowInfo objectForKey:@"livePlay"] != nil) {
        if([NCS([[self.dicRowInfo objectForKey:@"livePlay"] objectForKey:@"livePlayYN"]) isEqualToString:@"Y"] && [NCS([[self.dicRowInfo objectForKey:@"livePlay"] objectForKey:@"livePlayUrl"]) length] > 0) {
            self.btnPlay.hidden = NO;
            self.imgPlay.hidden = NO;
            //self.viewDimmed.hidden = NO;
            
            self.lblOnAir.text = @"ON-AIR";
            
        }else{
            
            self.btnPlay.hidden = YES;
            self.imgPlay.hidden = YES;
            //self.viewDimmed.hidden = YES;
            self.lblOnAir.text = @"BEST";
        }
    }else{
        self.btnPlay.hidden = YES;
        self.imgPlay.hidden = YES;
        //self.viewDimmed.hidden = YES;
        self.lblOnAir.text = @"BEST";
    }
    
    
    
    
    if([NCS([self.dicRowInfo objectForKey:@"imageUrl"]) length] > 0) {
        // 이미지 로딩
        self.imageURL = NCS([self.dicRowInfo objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if(error == nil  && [self.imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.productImageView.clipsToBounds = YES;
                    
                    if(isInCache) {
                        self.productImageView.image = fetchedImage;
                    }
                    else {
                        self.productImageView.alpha = 0;
                        self.productImageView.image = fetchedImage;
                    }
                    
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         self.productImageView.alpha = 1;
                                     }
                                     completion:^(BOOL finished) {
                                         
                                     }];
                });
            }
        }];
    }
    
    if([NCS([self.dicRowInfo objectForKey:@"broadStartTime"]) isEqualToString:@""] && [NCS([self.dicRowInfo objectForKey:@"broadCloseTime"]) isEqualToString:@""]) {
        //20160728 parksegun 방송종료시간이 없을때 TV HIT 표시
        self.lefttimelabel.hidden = NO;
        [ self.lefttimelabel setText:@"TV HIT"];
        self.lefttimelabel.textAlignment = NSTextAlignmentCenter;
    }
    else {
        self.lefttimelabel.hidden = NO;
    }
    
    
    if ([NCS([self.dicRowInfo objectForKey:@"priceMarkUpType"]) isEqualToString:@"LIVEPRICE"]) {
        self.viewTagMobilePrice.hidden = NO;
        
        [self.viewPriceArea removeConstraint:self.lconstSalePriceLeftMargin];
        
        self.lconstSalePriceLeftMargin = [NSLayoutConstraint constraintWithItem:self.lblSalePrice
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.viewTagMobilePrice
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1
                                                                       constant:10.0];
        
        [self.viewPriceArea addConstraint:self.lconstSalePriceLeftMargin];
        self.constPriceWidthLimit.constant = (((APPFULLWIDTH-4.0) / 2.0) - 86.0);
        
    }else if ([NCS([self.dicRowInfo objectForKey:@"priceMarkUpType"]) isEqualToString:@"GSPRICE"]) {
        self.viewTagGsPrice.hidden = NO;
        
        [self.viewPriceArea removeConstraint:self.lconstSalePriceLeftMargin];
        
        self.lconstSalePriceLeftMargin = [NSLayoutConstraint constraintWithItem:self.lblSalePrice
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.viewTagGsPrice
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1
                                                                       constant:10.0];
        
        [self.viewPriceArea addConstraint:self.lconstSalePriceLeftMargin];
        self.constPriceWidthLimit.constant = (((APPFULLWIDTH-4.0) / 2.0) - 80.0);
        
    }else if ([NCS([self.dicRowInfo objectForKey:@"priceMarkUpType"]) isEqualToString:@"RATE"]) {
        self.viewTagPercent.hidden = NO;
        
        self.lblDiscountRate.text = NCS([self.dicRowInfo objectForKey:@"priceMarkUp"]);
        
        [self.viewPriceArea removeConstraint:self.lconstSalePriceLeftMargin];
        
        self.lconstSalePriceLeftMargin = [NSLayoutConstraint constraintWithItem:self.lblSalePrice
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.viewTagPercent
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1
                                                                       constant:8.0];
        
        [self.viewPriceArea addConstraint:self.lconstSalePriceLeftMargin];
        self.constPriceWidthLimit.constant = (((APPFULLWIDTH-4.0) / 2.0) - 76.0);
        
    }
    
    self.productTitleLabel.text = NCS([self.dicRowInfo objectForKey:@"productName"]);
    if([[self.dicRowInfo objectForKey:@"isRental"] intValue] == YES) { //렌탈
        self.lblPerMonth.hidden = NO;
        self.lblSalePrice.hidden = NO;
        self.lblCounsel.hidden = NO;
        
        
        self.lblPerMonth.text = NCS([self.dicRowInfo objectForKey:@"rentalText"]);
        self.lblSalePrice.text = NCS([self.dicRowInfo objectForKey:@"rentalPrice"]);
        self.lblCounsel.text = NCS([self.dicRowInfo objectForKey:@"rentalEtcText"]);
        
        if([NCS([self.dicRowInfo objectForKey:@"priceMarkUpType"]) isEqualToString:@"LIVEPRICE"] || [NCS([self.dicRowInfo objectForKey:@"priceMarkUpType"]) isEqualToString:@"GSPRICE"]|| [NCS([self.dicRowInfo objectForKey:@"priceMarkUpType"]) isEqualToString:@"RATE"]) {
            
            self.constPriceWidthLimit.constant = self.constPriceWidthLimit.constant + 4.0;
            self.constPerMonthWidthLimit.constant = (((APPFULLWIDTH-4.0) / 2.0) - 70.0);
            
        }
        else {
            //priceMarkUpType 이 3경우가 아님
            if ([NCS([self.dicRowInfo objectForKey:@"rentalEtcText"]) length] > 0 && [NCS([self.dicRowInfo objectForKey:@"rentalText"]) length] == 0 && [NCS([self.dicRowInfo objectForKey:@"rentalPrice"]) length] == 0) {
                self.lblPerMonth.hidden = YES;
                self.lblSalePrice.hidden = YES;
                
                [self.viewPriceArea layoutIfNeeded];
            }
        }
    }
    else if([[self.dicRowInfo objectForKey:@"isCellPhone"] intValue] == YES  ) { //휴대폰
        self.lblSalePrice.hidden = NO;
        self.lblSalePriceWon.hidden = NO;
        self.lblSalePrice.text = NCS([self.dicRowInfo objectForKey:@"salePrice"]);
        self.lblSalePriceWon.text = NCS([self.dicRowInfo objectForKey:@"exposePriceText"]);
        
        if([[self.dicRowInfo objectForKey:@"rentalText"] isEqualToString:@"단말기 가격"]) {
            self.constPerMonthWidthLimit.constant = (((APPFULLWIDTH-4.0) / 2.0) - 70.0);
            self.lblPerMonth.hidden = NO;
            self.lblCounsel.hidden = NO;
            self.lblPerMonth.text = NCS([self.dicRowInfo objectForKey:@"rentalText"]);
            self.lblCounsel.text = NCS([self.dicRowInfo objectForKey:@"rentalEtcText"]);
            
            
        }
        else {
            self.constBasePriceWidthLimit.constant = self.constPriceWidthLimit.constant;
            self.lblBasePrice.hidden = NO;
            self.lblBasePriceWon.hidden = NO;
            self.viewBasePriceStrikeLine.hidden = NO;
            self.lblBasePrice.text = NCS([self.dicRowInfo objectForKey:@"basePrice"]);
            
        }
    }
    else { // 일반
        self.lblSalePrice.hidden = NO;
        self.lblSalePriceWon.hidden = NO;
        self.lblSalePrice.text = NCS([self.dicRowInfo objectForKey:@"salePrice"]);
        self.lblSalePriceWon.text = NCS([self.dicRowInfo objectForKey:@"exposePriceText"]);
        //////가격표시 2017/03/30 개편
        if([NCS([self.dicRowInfo objectForKey:@"basePrice"]) isEqualToString:@"0"] || [NCS([self.dicRowInfo objectForKey:@"basePrice"]) length] == 0) {
            self.lconstSalePriceTopMargin.constant = 59.0;
            
            self.lblBasePrice.hidden = YES;
            self.lblBasePriceWon.hidden = YES;
            self.viewBasePriceStrikeLine.hidden = YES;
            
        }
        else {
            self.constBasePriceWidthLimit.constant = self.constPriceWidthLimit.constant;
            self.lblBasePrice.hidden = NO;
            self.lblBasePriceWon.hidden = NO;
            self.viewBasePriceStrikeLine.hidden = NO;
            
            self.lblBasePrice.text = NCS([self.dicRowInfo objectForKey:@"basePrice"]);
        }
    }
    
    [self.viewPriceArea layoutIfNeeded];
    
    NSLog(@"self.lblSalePrice.font = %@",self.lblSalePrice.font);
    
    
    if(NCA([self.dicRowInfo objectForKey:@"rwImgList"]) == YES) {
        
        NSArray *arrTagImage = [[[self.dicRowInfo objectForKey:@"rwImgList"] reverseObjectEnumerator] allObjects]; //듀얼은 역순
        if([NCS([arrTagImage objectAtIndex:0]) length] > 0) {
            self.imageTagURL01 = NCS([arrTagImage objectAtIndex:0]);
            [ImageDownManager blockImageDownWithURL:self.imageTagURL01 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil  && [self.imageTagURL01 isEqualToString:strInputURL]) {
                        
                        if(isInCache) {
                            self.imgLeftTag01.image = fetchedImage;
                        }
                        else {
                            self.imgLeftTag01.alpha = 0;
                            self.imgLeftTag01.image = fetchedImage;
                        }
                        
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             self.imgLeftTag01.alpha = 1;
                                         }
                                         completion:^(BOOL finished) {
                                         }];
                    }
                });
            }];
        }
        
        
        if([arrTagImage count] > 1) {
            if([NCS([arrTagImage objectAtIndex:1]) length] > 0) {
                self.imageTagURL02 = NCS([arrTagImage objectAtIndex:1]);
                [ImageDownManager blockImageDownWithURL:self.imageTagURL02 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.imageTagURL02 isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(isInCache) {
                                self.imgLeftTag02.image = fetchedImage;
                            }
                            else {
                                self.imgLeftTag02.alpha = 0;
                                self.imgLeftTag02.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.imgLeftTag02.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        });
                    }
                }];
            }
        }
        
        if([arrTagImage count] > 2) {
            if([NCS([arrTagImage objectAtIndex:2]) length] > 0) {
                self.imageTagURL03 = NCS([arrTagImage objectAtIndex:2]);
                [ImageDownManager blockImageDownWithURL:self.imageTagURL03 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if(error == nil  && [self.imageTagURL03 isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(isInCache) {
                                self.imgLeftTag03.image = fetchedImage;
                            }
                            else {
                                self.imgLeftTag03.alpha = 0;
                                self.imgLeftTag03.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.imgLeftTag03.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        });
                    }
                }];
            }
        }
    }
    
    if( [NCS([self.dicRowInfo objectForKey:@"liveTalkYn"]) isEqualToString:@"Y"]) {
        
        [self.btnLiveTalk setAccessibilityLabel:@"라이브톡"];
        self.constViewLiveTalkWidth.constant = ((((APPFULLWIDTH-4.0) / 2.0) - 20.0) /2.0 ) +3.0;
    }else{
        [self.btnLiveTalk removeFromSuperview];
        self.constViewLiveTalkWidth.constant = 0.0;
    }
 

    if( [NCS([self.dicRowInfo objectForKey:@"liveTalkYn"]) isEqualToString:@"Y"]) {

        [self.btnLiveTalk setTitle:[self.dicRowInfo objectForKey:@"liveTalkText"] forState:UIControlStateNormal];
        [self.btnLiveTalk setAccessibilityLabel:@"라이브톡"];
    }
    if([NCS([self.dicRowInfo objectForKey:@"brodScheduleYn"]) isEqualToString:@"Y"] ) {
        [self.btnSchedule setAccessibilityLabel:@"TV 편성표"];
        [self.btnSchedule setTitle:[self.dicRowInfo objectForKey:@"brodScheduleText"] forState:UIControlStateNormal];
    }
    
    //바로구매-상담하기 기본텍스트 및 내려주는 텍스트
    if( [[self.dicRowInfo objectForKey:@"isRental"] intValue] == YES ) {
        [self.btnPurchase setTitle:GSSLocalizedString(@"home_tv_live_view_no_advice_text02") forState:UIControlStateNormal];
        [self.btnPurchase setAccessibilityLabel:@"현재 생방송중인 상품 상담하기"];
    }
    
    if(NCO([self.dicRowInfo objectForKey:@"btnInfo3"])) {
        if ([NCS([[self.dicRowInfo objectForKey:@"btnInfo3"] objectForKey:@"text"]) length] > 0 ) {
            [self.btnPurchase setTitle:[[self.dicRowInfo objectForKey:@"btnInfo3"] objectForKey:@"text"] forState:UIControlStateNormal];
            [self.btnPurchase setAccessibilityLabel:@"현재 생방송중인 상품 바로구매"];
            
            if([self.btnPurchase.titleLabel.text isEqualToString:@"바로구매"] == YES) {
                [self.btnPurchase setAccessibilityLabel:@"현재 생방송중인 상품 바로구매"];
            }
            else if([self.btnPurchase.titleLabel.text isEqualToString:@"구매하기"] == YES) {
                [self.btnPurchase setAccessibilityLabel:@"현재 생방송중인 상품 구매하기로 이동"];
            }
        }
    }
    
    
    if([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self drawliveBroadlefttime];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timerProc)
                                           userInfo:nil
                                            repeats:YES];
    
}

-(IBAction)onBottomButtons:(id)sender{
    
    //GTMSendLog:: Area_Tracking, MC_홈_생방송_Main_Live, 0_[세실엔느] 3D보정 초밀착 팬티 패키지 7종
    if([sender tag] == 3007) {
        //플레이 버튼 영역 클릭
        
        if ([self.lefttimelabel.text isEqualToString:GSSLocalizedString(@"home_tv_live_view_close_text")]) {
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"tvShopBroadCastEnd_Popup") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            [ApplicationDelegate.window addSubview:lalert];
            
        }else{
       
            @try {
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_%@_%@_Main_Live",self.strSectionName, (self.isDualTvLive)?@"생방송":@"데이터 홈쇼핑"]
                                       withLabel:[NSString stringWithFormat:@"0_%@", [self.dicRowInfo objectForKey:@"productName"] ]];
            }
            @catch (NSException *exception) {
                NSLog(@"TDC LinkUrl Exception: %@", exception);
            }
            @finally {
                
            }
            
            if ([self.targetTableView respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                [self.targetTableView touchEventDualPlayerJustLinkStr: [self.dicRowInfo objectForKey:@"linkUrl"] ];
            }
            
        }
        
        
    }else if([sender tag] == 3008) {
        //오늘추천 생방송영역클릭
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@_Main_Live",self.strSectionName, (self.isDualTvLive)?@"생방송":@"데이터 홈쇼핑"]
                                   withLabel:[NSString stringWithFormat:@"0_%@", [self.dicRowInfo objectForKey:@"productName"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"TDC LinkUrl Exception: %@", exception);
        }
        @finally {
            
        }
        
        if ([self.targetTableView respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.targetTableView touchEventDualPlayerJustLinkStr: [self.dicRowInfo objectForKey:@"linkUrl"] ];
        }
        
        
    }
    else if([sender tag] == 3009) {
        //라이브톡
        if ([NCS([self.dicRowInfo objectForKey:@"liveTalkUrl"]) length] > 0) {
            
            if ([self.targetTableView respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                [self.targetTableView touchEventDualPlayerJustLinkStr: NCS([self.dicRowInfo objectForKey:@"liveTalkUrl"])];
            }
        }
    }
    else if([sender tag] == 3010) {
        //편성표 링크
        if ([self.targetTableView respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.targetTableView touchEventDualPlayerJustLinkStr: NCS([self.dicRowInfo objectForKey:@"broadScheduleLinkUrl"])];
        }
    }
    else if([sender tag] == 3011) {
        //바로구매
        if(NCO([self.dicRowInfo objectForKey:@"btnInfo3"])) {
            if (NCS([[self.dicRowInfo objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"]) && [[[self.dicRowInfo objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                
                NSString *linkstr = [[[self.dicRowInfo objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] substringFromIndex:11];
                NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                //[self.tableView setContentOffset:CGPointMake(0.0, tableheaderBANNERheight + tableheaderListheight) animated:YES];
                [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
            }
            else {
                NSString *linkstr = [[self.dicRowInfo objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"];
                
                if ([self.targetTableView respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                    [self.targetTableView touchEventDualPlayerJustLinkStr:linkstr];
                }
                
            }
            
            
            @try {
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_App_%@_DirectOrd",self.strSectionName]
                                       withLabel:[NSString stringWithFormat:@"%@",[[self.dicRowInfo objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] ]];
            }
            @catch (NSException *exception) {
                NSLog(@"TDC LinkUrl Exception: %@", exception);
            }
            @finally {
                
            }
            
        }
        else {
            
            if ([self.targetTableView respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                [self.targetTableView touchEventDualPlayerJustLinkStr: [self.dicRowInfo objectForKey:@"rightNowBuyUrl"] ];
            }
            
            
            @try {
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_App_%@_DirectOrd",self.strSectionName]
                                       withLabel:[NSString stringWithFormat:@"%@",[self.dicRowInfo objectForKey:@"rightNowBuyUrl"] ]];
            }
            @catch (NSException *exception) {
                NSLog(@"TDC LinkUrl Exception: %@", exception);
            }
            @finally {
                
            }
        }
        
    }else if([sender tag] == 3012) {
        //편성표 링크
        if ([self.targetTableView respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.targetTableView touchEventDualPlayerJustLinkStr: NCS([self.dicRowInfo objectForKey:@"totalPrdViewLinkUrl"])];
        }
    }
}

- (double)leftLiveTVTime {
    
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    //종료시간
    NSDate *closeTime = [dateformat dateFromString:[self.dicRowInfo objectForKey:@"broadCloseTime"]];
    int closestamp = [closeTime timeIntervalSince1970];
    //남은방송시간
    double leftTimeSec =    closestamp - [[NSDate getSeoulDateTime] timeIntervalSince1970];
    return leftTimeSec;
}


- (void)timerProc {

    [self drawliveBroadlefttime];
}

- (void) drawliveBroadlefttime {

    NSLog(@"");
    
    if([NCS([self.dicRowInfo objectForKey:@"broadCloseTime"]) isEqualToString:@""]) {
        [self.timer invalidate];
        self.timer = nil;
        
        self.btnPlay.hidden = YES;
        self.imgPlay.hidden = YES;
        self.lefttimelabel.hidden = YES;
        
        if ([self.lblOnAir.text isEqualToString:@"BEST"]) {
            self.lblOnAir.hidden = YES;
        }else{
            self.lblOnAir.hidden = NO;
        }
        
        return;
    }
    
    
    self.lefttimelabel.hidden = NO;
    
    //((20 / 60) *100)
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    
    //종료시간
    NSDate *closeTime = [dateformat dateFromString:[self.dicRowInfo objectForKey:@"broadCloseTime"]];
    int closestamp = [closeTime timeIntervalSince1970];
    NSString * dbstr =   [NSString stringWithFormat:@"%d", closestamp];
    //reload tb 통신 실패시
    @try {
        [ self.lefttimelabel setText:[self getDateLeft:dbstr]];
        self.lefttimelabel.textAlignment = NSTextAlignmentCenter;
    }
    @catch (NSException *exception) {
        
        NSLog(@"lefttimeLabel not Exist : %@",exception);
    }
    @finally {
        
    }
}


- (NSString *) getDateLeft:(NSString *)date {
    
    double left = [date doubleValue] - [[NSDate getSeoulDateTime] timeIntervalSince1970];
    int tminite = left/60;
    int hour = left/3600;
    int minite = (left-(hour*3600))/60;
    int second = (left-(hour*3600)-(minite*60));
    NSString *callTemp = nil;
    
    if(tminite >= 60) {
        callTemp = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minite, second];
    }
    else if(left <= 0) {
        callTemp = GSSLocalizedString(@"home_tv_live_view_close_text");
    }
    else {
        callTemp  = [NSString stringWithFormat:@"00:%02d:%02d", minite, second];
    }
    
    if([callTemp isEqualToString:GSSLocalizedString(@"home_tv_live_view_close_text")]) {
        
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
        self.imgPlay.hidden = YES;
        self.lefttimelabel.hidden = YES;
        self.lblNextBroadCast.hidden = NO;
        self.lblNextBroadCast.text = GSSLocalizedString(@"tvShopBroadCastEnd_DualPlayer");
        
        self.lblOnAir.hidden = YES;
        
        if ([self.target respondsToSelector:@selector(stopDualPlayerPlayEnd)]) {
            [self.target stopDualPlayerPlayEnd];
        }
        
    }
    return callTemp;
}


@end
