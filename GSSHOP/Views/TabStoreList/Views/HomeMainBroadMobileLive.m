//
//  HomeMainBroadMobileLive.m
//  GSSHOP
//
//  Created by gsshop iOS on 04/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "Common_Util.h"
#import "AppDelegate.h"
#import "MobileLiveViewController.h"
#import "SectionTBViewController.h"

#import "HomeMainBroadMobileLive.h"


@implementation HomeMainBroadMobileLive

@synthesize target,lefttimelabel, productImageView,productTitleLabel;
@synthesize noImageView;
//@synthesize  view_livetalk, view_schedule, view_dorder,  btn_livetalk, btn_schedule, btn_dorder, btn_livetalktxt,btn_scheduletxt,btn_dordertxt;
@synthesize imageLoadingOperation, imageURL;
@synthesize curRequestString;
@synthesize viewTvArea;
@synthesize viewPriceArea;
@synthesize lblDiscountRate;
@synthesize lblBasePrice;
@synthesize viewBasePriceStrikeLine;
@synthesize lblPerMonth;
@synthesize lblSalePrice;
@synthesize lblSalePriceWon;


- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblSalePriceWon.text = GSSLocalizedString(@"home_tv_live_view_no_won");
    //self.btn_scheduletxt.text = GSSLocalizedString(@"home_tv_live_btn_schedule_text");
    self.btn_dordertxt.text =  GSSLocalizedString(@"home_tv_live_btn_tv_pay_text");
    
    viewDimmed.hidden = YES;
    viewScreenBtn.hidden = YES;
    self.lblBasePrice.hidden = YES;
    self.viewBasePriceStrikeLine.hidden = YES;
    self.lblPerMonth.hidden = YES;
    self.lblSalePrice.hidden = YES;
    self.lblSalePriceWon.hidden = YES;
    self.lblSalePrice.textColor = [Mocha_Util getColor:@"111111"];
    self.lblSalePriceWon.textColor = [Mocha_Util getColor:@"111111"];
    
    self.isEnterBackGround = NO;
    
    
    self.viewLeftTime.layer.cornerRadius = self.viewLeftTime.frame.size.height/2.0;
    self.viewLeftTime.layer.shouldRasterize = YES;
    self.viewLeftTime.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.lefttimelabel.font = [UIFont monospacedDigitSystemFontOfSize:14.0 weight:UIFontWeightRegular];
    // 상품 이미지뷰 테두리
    [self.productImageView setBorderWithWidth:1.0 color:@"000000"];
}

-(void) setCellInfoNDrawData:(NSDictionary*) infoDic{
    
    rdic = infoDic;
    
//    //데이터 초기화
//    self.lblBasePrice.hidden = YES;
//    self.viewBasePriceStrikeLine.hidden = YES;
//    self.lblPerMonth.hidden = YES;
//    self.lblSalePrice.hidden = YES;
//    self.lblSalePriceWon.hidden = YES;
//    
//    self.lblPerMonth.text = @"";
//    self.lblBasePrice.text = @"";
//    self.lblSalePrice.text = @"";
//    self.lblSalePriceWon.text = @"";
    
    self.dicMobileLiveInfo = [rdic objectForKey:@"mobileLiveInfo"];
    
    if([rdic objectForKey:@"livePlay"] != nil) {
        if([NCS([[rdic objectForKey:@"livePlay"] objectForKey:@"livePlayYN"]) isEqualToString:@"Y"] && [NCS([[rdic objectForKey:@"livePlay"] objectForKey:@"livePlayUrl"]) length] > 0) {
            
            
            self.curRequestString = [[rdic objectForKey:@"livePlay"] objectForKey:@"livePlayUrl"];
            viewDimmed.hidden = NO;
            viewScreenBtn.hidden = NO;
        }
    }
    
    self.productImageView.image = nil;
    
    if([NCS([infoDic objectForKey:@"imageUrl"]) length] > 0) {
        // 이미지 로딩
        self.imageURL = NCS([infoDic objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if(error == nil  && [imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.productImageView layoutIfNeeded];
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
    
    
    self.lblMobileLiveGO.text = NCS([self.dicMobileLiveInfo objectForKey:@"text"]);
    
    if([NCS([infoDic objectForKey:@"broadStartTime"]) isEqualToString:@""] && [NCS([infoDic objectForKey:@"broadCloseTime"]) isEqualToString:@""]) {
        //20160728 parksegun 방송종료시간이 없을때 TV HIT 표시
        
        if(![NCS([infoDic objectForKey:@"broadType"]) isEqualToString:@"베스트"]) {
            self.lefttimelabel.hidden = NO;
            self.btnLeftTime.hidden = NO;
            [ self.lefttimelabel setText:@"TV HIT"];
            self.lefttimelabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    else {
        self.lefttimelabel.hidden = NO;
        self.btnLeftTime.hidden = NO;
        
        NSString *strStartTime = NCS([infoDic objectForKey:@"broadStartTime"]);
        NSString *strCloseTime = NCS([infoDic objectForKey:@"broadCloseTime"]);
        
        //2019 0807 19 50 00
        if ([strStartTime length] >= 14 && [strCloseTime length] >= 14 ) {
            
            self.lblMobileLivePlayTime.text = [NSString stringWithFormat:@"%@:%@~%@:%@",[strStartTime substringWithRange:NSMakeRange(8, 2)],[strStartTime substringWithRange:NSMakeRange(10, 2)],[strCloseTime substringWithRange:NSMakeRange(8, 2)],[strCloseTime substringWithRange:NSMakeRange(10, 2)]];
        }else{
            self.lblMobileLivePlayTime.text = @"";
        }
        
    }
    
    
    //생방송, 베스트, 방송중
    
    //mobileLive_homemain_top_replay
    
    if([NCS([infoDic objectForKey:@"broadType"]) isEqualToString:@"replay"]) {
        self.imgLiveStatus.hidden = YES;
        self.lconstLiveStausLeading.constant = 0.0;
    }else{
        self.imgLiveStatus.hidden = NO;
        self.lconstLiveStausLeading.constant = 17.0;
    }
    
    [self.viewTopArea layoutIfNeeded];
    
    if ([NCS([infoDic objectForKey:@"priceMarkUpType"]) isEqualToString:@"RATE"] && [NCS([infoDic objectForKey:@"priceMarkUp"]) length] > 0) {
        self.lblDiscountRate.text = [NSString stringWithFormat:@"%@%%",NCS([infoDic objectForKey:@"priceMarkUp"])];
        self.lconstBasePriceLeading.constant = 3;
    }
    else {
        self.lblDiscountRate.text = @"";
        self.lconstBasePriceLeading.constant = 0;
    }
    
    
    self.productTitleLabel.text = NCS([infoDic objectForKey:@"productName"]);
    
    
    self.productTitleLabel.attributedText = [Common_Util attributedProductTitle:infoDic titleKey:@"productName"];
    
    self.lconstPerMonthMargine.constant = 0.0;
    
    if([[infoDic objectForKey:@"isRental"] intValue] == YES) { //렌탈
        self.lblSalePriceWon.hidden = YES;
        
        
        self.lblBasePrice.hidden = YES;
        self.viewBasePriceStrikeLine.hidden = YES;
        
        self.lblPerMonth.hidden = NO;
        self.lblSalePrice.hidden = NO;
                
        NSString *rentalText = NCS([infoDic objectForKey:@"rentalText"]);
        NSString *rentalPrice = NCS([infoDic objectForKey:@"rentalPrice"]);
        NSString *strVoiceOver = @"";
        
        
        if (rentalText.length > 0) {
            
            if ([@"월 렌탈료" isEqualToString:rentalText] || [@"월" isEqualToString:rentalText] ) {
                self.lblPerMonth.text = @"월";
                self.lconstPerMonthMargine.constant = 3.0;
                if ( [rentalPrice length] > 0 && [rentalPrice hasPrefix:@"0"] == NO ) {
                    self.lblSalePrice.text = rentalPrice;
                    strVoiceOver = [NSString stringWithFormat:@"월 %@",rentalPrice];
                }
                else {
                    self.lblSalePrice.text = @"";
                    self.lblPerMonth.text = GSSLocalizedString(@"home_tv_live_councel_text");
                    strVoiceOver = GSSLocalizedString(@"home_tv_live_councel_text");
                }
                
                
            }
            else { //rentalText 비어있음
                //렌탈인데 월이 아니면,
                if ( [rentalPrice length] > 0 && [rentalPrice hasPrefix:@"0"] == NO ) {
                    self.lblSalePrice.text = rentalPrice;
                    self.lblPerMonth.text = @"";
                    strVoiceOver = rentalPrice;
                }
                else {
                    self.lblSalePrice.text = @"";
                    self.lblPerMonth.text = GSSLocalizedString(@"home_tv_live_councel_text");
                    strVoiceOver = GSSLocalizedString(@"home_tv_live_councel_text");
                }
            }
        }
        else if ( [rentalPrice length] > 0 && [rentalPrice hasPrefix:@"0"] == NO ) {
            self.lblSalePrice.text = rentalPrice;
            self.lblPerMonth.text = @"";
            strVoiceOver = rentalPrice;
        }
        else {
            self.lblSalePrice.text = @"";
            self.lblPerMonth.text = GSSLocalizedString(@"home_tv_live_councel_text");
            strVoiceOver = GSSLocalizedString(@"home_tv_live_councel_text");
        }
        
        self.btn_TVLinkPriceArea.accessibilityLabel = strVoiceOver;
        self.btn_TVLink.accessibilityLabel = strVoiceOver;
    }
    else if([[infoDic objectForKey:@"isCellPhone"] intValue] == YES  ) { //휴대폰
        
        self.lblSalePrice.hidden = NO;
        self.lblSalePriceWon.hidden = NO;
        self.lblSalePrice.text = NCS([infoDic objectForKey:@"salePrice"]);
        self.lblSalePriceWon.text = NCS([infoDic objectForKey:@"exposePriceText"]);

        self.btn_TVLinkPriceArea.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([infoDic objectForKey:@"productName"]), NCS([infoDic objectForKey:@"salePrice"]) ,NCS([infoDic objectForKey:@"exposePriceText"])];
        
        self.btn_TVLink.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([infoDic objectForKey:@"productName"]), NCS([infoDic objectForKey:@"salePrice"]) ,NCS([infoDic objectForKey:@"exposePriceText"])];
        
        if( [NCS([infoDic objectForKey:@"rentalText"]) length] > 0) {
            self.lblPerMonth.hidden = NO;
            self.lblPerMonth.text = NCS([infoDic objectForKey:@"rentalText"]);
            //self.lblCounsel.text = NCS([infoDic objectForKey:@"rentalEtcText"]);
            self.lblBasePrice.hidden = YES;
            self.viewBasePriceStrikeLine.hidden = YES;
            
        }
        else {
            self.lblPerMonth.hidden = YES;
            self.lblBasePrice.hidden = NO;
            self.viewBasePriceStrikeLine.hidden = NO;
            self.lblBasePrice.text = [NSString stringWithFormat:@"%@원",NCS([infoDic objectForKey:@"basePrice"])];
            
        }
    }
    else { // 일반
        
        self.lblPerMonth.hidden = YES;
        self.lblSalePrice.hidden = NO;
        self.lblSalePriceWon.hidden = NO;
        self.lblSalePrice.text = NCS([infoDic objectForKey:@"salePrice"]);
        self.lblSalePriceWon.text = NCS([infoDic objectForKey:@"exposePriceText"]);
        
        //self.btn_TVLinkPriceArea.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([infoDic objectForKey:@"productName"]), NCS([infoDic objectForKey:@"salePrice"]) ,NCS([infoDic objectForKey:@"exposePriceText"])];
        
        self.btn_TVLinkPriceArea.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([infoDic objectForKey:@"productName"]), NCS([infoDic objectForKey:@"salePrice"]) ,NCS([infoDic objectForKey:@"exposePriceText"])];
        
        self.btn_TVLink.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ %@",NCS([infoDic objectForKey:@"productName"]), NCS([infoDic objectForKey:@"salePrice"]) ,NCS([infoDic objectForKey:@"exposePriceText"])];
        
        if([NCS([infoDic objectForKey:@"basePrice"]) isEqualToString:@"0"] || [NCS([infoDic objectForKey:@"basePrice"]) length] == 0) {
            self.lblBasePrice.hidden = YES;
            self.viewBasePriceStrikeLine.hidden = YES;
        }
        else {
            self.lblBasePrice.hidden = NO;
            self.viewBasePriceStrikeLine.hidden = NO;
            self.lblBasePrice.text = [NSString stringWithFormat:@"%@원",NCS([infoDic objectForKey:@"basePrice"])];
        }
    }
    
    [self.viewPriceArea layoutIfNeeded];
    
    
    //    //parksegun 20190826 코너 라운드 처리 -- 취소
    //    [self layoutIfNeeded];
    //    [Common_Util cornerRadius:self.viewTopArea byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerSize:10.0];
    //    [Common_Util cornerRadius:self.viewPriceArea byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerSize:10.0];
    //
    
    //바로구매-상담하기 기본텍스트 및 내려주는 텍스트
    if( [[infoDic objectForKey:@"isRental"] intValue] == YES ) {
        self.btn_dordertxt.text = GSSLocalizedString(@"home_tv_live_view_no_advice_text02");
        [self.btn_dorder setAccessibilityLabel:@"현재 생방송중인 상품 상담하기"];
    }
    
    if(NCO([infoDic objectForKey:@"btnInfo3"])) {
        if ([NCS([[infoDic objectForKey:@"btnInfo3"] objectForKey:@"text"]) length] > 0 ) {
            self.btn_dordertxt.text = [[infoDic objectForKey:@"btnInfo3"] objectForKey:@"text"];
            if([self.btn_dordertxt.text isEqualToString:@"구매하기"] == YES) {
                [self.btn_dorder setAccessibilityLabel:@"현재 생방송중인 상품 구매하기"];
            }
            
            self.view_dorder.layer.cornerRadius = 2.0;
            self.view_dorder.layer.shouldRasterize = YES;
            self.view_dorder.layer.rasterizationScale = [UIScreen mainScreen].scale;
            
        }else{
            
        }
        
        
    }
    
    self.lblReview.attributedText = [Common_Util attributedReview:infoDic isWidth320Cut:YES];
    
     [self.viewPriceArea layoutIfNeeded];
    
    CGFloat widthLblBenefit = APPFULLWIDTH - (16.0 + self.view_dorder.frame.size.width + 16.0);
    
    self.lblBenefit.attributedText = [Common_Util attributedBenefitString:infoDic widthLimit:widthLblBenefit lineLimit:2 fontSize:14.0];
    [self.viewPriceArea layoutIfNeeded];
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



- (IBAction)tvcBtnAction:(id)sender {
    NSLog(@"[sender tag][sender tag] = %ld",(long)[((UIButton *)sender) tag]);
    NSLog(@"sendersendersendersender = %@",sender);
    
    //GTMSendLog:: Area_Tracking, MC_홈_생방송_Main_Live, 0_[세실엔느] 3D보정 초밀착 팬티 패키지 7종
    if([((UIButton *)sender) tag] == 3007) {
        //플레이 버튼 영역 클릭
        
        
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@_Main_Live",self.strSectionName, @"모바일 라이브"]
                                   withLabel:[NSString stringWithFormat:@"0_%@", [rdic objectForKey:@"productName"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"TDC LinkUrl Exception: %@", exception);
        }
        @finally {
            
        }
        
        if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.target touchEventDualPlayerJustLinkStr: [rdic objectForKey:@"linkUrl"] ];
        }
        
        
        
    }else if([((UIButton *)sender) tag] == 3008) {
        //오늘추천 생방송영역클릭
        @try {
            [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                  withAction:[NSString stringWithFormat:@"MC_%@_%@_Main_Live",self.strSectionName, @"모바일 라이브"]
                                   withLabel:[NSString stringWithFormat:@"0_%@", [rdic objectForKey:@"productName"] ]];
        }
        @catch (NSException *exception) {
            NSLog(@"TDC LinkUrl Exception: %@", exception);
        }
        @finally {
            
        }
        
        if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.target touchEventDualPlayerJustLinkStr: [rdic objectForKey:@"linkUrl"] ];
        }
        
        
    }
    else if([((UIButton *)sender) tag] == 3009) {
        //라이브톡
        if ([NCS([rdic objectForKey:@"liveTalkUrl"]) length] > 0) {
            
            if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                [self.target touchEventDualPlayerJustLinkStr: NCS([rdic objectForKey:@"liveTalkUrl"])];
            }
        }
    }
    else if([((UIButton *)sender) tag] == 3010) {
        //편성표 링크
        if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.target touchEventDualPlayerJustLinkStr: NCS([rdic objectForKey:@"broadScheduleLinkUrl"])];
        }
    }
    else if([((UIButton *)sender) tag] == 3011) {
        //바로구매
        if(NCO([rdic objectForKey:@"btnInfo3"])) {
            if (NCS([[rdic objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"]) && [[[rdic objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                
                NSString *linkstr = [[[rdic objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] substringFromIndex:11];
                NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                //[self.tableView setContentOffset:CGPointMake(0.0, tableheaderBANNERheight + tableheaderListheight) animated:YES];
                [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
            }
            else {
                NSString *linkstr = [[rdic objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"];
                
                if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                    [self.target touchEventDualPlayerJustLinkStr:linkstr];
                }
                
            }
            
            
            @try {
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_App_%@_DirectOrd",self.strSectionName]
                                       withLabel:[NSString stringWithFormat:@"%@",[[rdic objectForKey:@"btnInfo3"] objectForKey:@"linkUrl"] ]];
            }
            @catch (NSException *exception) {
                NSLog(@"TDC LinkUrl Exception: %@", exception);
            }
            @finally {
                
            }
            
        }
        else {
            
            if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
                [self.target touchEventDualPlayerJustLinkStr: [rdic objectForKey:@"rightNowBuyUrl"] ];
            }
            
            
            @try {
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking"
                                      withAction:[NSString stringWithFormat:@"MC_App_%@_DirectOrd",self.strSectionName]
                                       withLabel:[NSString stringWithFormat:@"%@",[rdic objectForKey:@"rightNowBuyUrl"] ]];
            }
            @catch (NSException *exception) {
                NSLog(@"TDC LinkUrl Exception: %@", exception);
            }
            @finally {
                
            }
        }
        
    }else if([((UIButton *)sender) tag] == 3012) {
        //전체상품보기 링크
        if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
            [self.target touchEventDualPlayerJustLinkStr: NCS([rdic objectForKey:@"totalPrdViewLinkUrl"])];
        }
    }
    
    /*
     if ([self.target respondsToSelector:@selector(btntouchWithLinkStrBD:)]) {
     [self.target btntouchWithLinkStrBD:sender];
     }
     */
    
}


- (void)goWebView:(NSString *)url {
    
    @try {
        [target dctypetouchEventTBCell:rdic andCnum:0 withCallType:@""];
    }
    @catch (NSException *exception) {
        NSLog(@"exception = %@",exception);
    }
}


- (void) dealloc {
    NSLog(@"deallocdeallocdealloc");
    
    if([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.viewTopArea = nil;
    self.imgLiveStatus = nil;
    self.lconstLiveStausLeading = nil;
    self.noImageView = nil;
    self.productImageView = nil;
    self.lefttimelabel = nil;
    self.viewLeftTime = nil;
    self.btnLeftTime = nil;
    self.productTitleLabel = nil;
    self.lblDiscountRate = nil;
    self.lblBasePrice = nil;
    self.viewBasePriceStrikeLine = nil;
    self.lconstBasePriceLeading = nil;
    self.lblPerMonth = nil;
    self.lconstPerMonthMargine = nil;
    self.lblSalePrice = nil;
    self.lblSalePriceWon = nil;
    self.viewTvArea = nil;
    self.viewPriceArea = nil;
    self.view_dorder = nil;
    self.btn_dorder = nil;
    self.btn_dordertxt = nil;
    self.btn_TVLink = nil;
    self.btn_TVLinkPriceArea = nil;
    self.imageLoadingOperation = nil;
    self.imageURL = nil;
    self.curRequestString = nil;
    self.mseqValue = nil;
    self.lblBroadCastEnd = nil;
    self.strSectionName = nil;
    self.strSectionCode = nil;
    self.dicMobileLiveInfo = nil;
    self.lblMobileLiveGO = nil;
    self.lblMobileLivePlayTime = nil;
    self.lblBenefit = nil;
    self.lblReview = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)stopAndDealloc{
    [self stopTimer];
}

- (IBAction)onBtnMobileLive:(id)sender {
    
    //    [ApplicationDelegate wiseAPPLogRequest: WISELOGCOMMONURL(@"?mseq=A00054-C_MLIVE-PLAY")];
    
    if ([self.target respondsToSelector:@selector(updateHeaderMoviePlaying:)]) {
        [self.target updateHeaderMoviePlaying:NO];
    }
    
    if ([self.target respondsToSelector:(@selector(touchEventDualPlayerJustLinkStr:))]) {
        [self.target touchEventDualPlayerJustLinkStr:NCS([rdic objectForKey:@"playUrl"])];
    }
}

- (void)timerProc {
    
    [self drawliveBroadlefttime];
}

- (void) drawliveBroadlefttime {
    if([NCS([rdic objectForKey:@"broadCloseTime"]) isEqualToString:@""]) {
        [self.timer invalidate];
        self.timer = nil;
        
        self.lefttimelabel.hidden = YES;
        return;
    }
    
    //    if([NCS([rdic objectForKey:@"broadType"]) isEqualToString:@"베스트"]) {
    //        self.lefttimelabel.hidden = YES;
    //    }else{
    //        self.lefttimelabel.hidden = NO;
    //    }
    
    //((20 / 60) *100)
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    
    //종료시간
    NSDate *closeTime = nil;
    
    if (self.isPreparingBroad == NO) {
        closeTime = [dateformat dateFromString:[rdic objectForKey:@"broadCloseTime"]];
    }else{
        //방송 준비중
        closeTime = [dateformat dateFromString:[rdic objectForKey:@"broadStartTime"]];
    }
    
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
    
    //NSLog(@"[date doubleValue] = %f",[date doubleValue]);
    //NSLog(@"[[NSDate getSeoulDateTime] timeIntervalSince1970] = %f",[[NSDate getSeoulDateTime] timeIntervalSince1970]);
    double left = [date doubleValue] - [[NSDate getSeoulDateTime] timeIntervalSince1970];
    //NSLog(@"leftleft = %f",left);
    
    int tminite = left/60;
    int hour = left/3600;
    int minite = (left-(hour*3600))/60;
    int second = (left-(hour*3600)-(minite*60));
    NSString *callTemp = nil;
    
    if(tminite >= 60) {
        callTemp = [NSString stringWithFormat:@"%02d:%02d:%02d 남음", hour, minite, second];
        TVCapirequestcount = 0;
    }
    else if(left <= 0) {
        callTemp = @"00:00:00 남음";
        TVCapirequestcount ++;
    }
    else {
        callTemp  = [NSString stringWithFormat:@"00:%02d:%02d 남음", minite, second];
        TVCapirequestcount = 0;
    }
    
    //    NSLog(@"callTempcallTemp = %@",callTemp);
    //    NSLog(@"selfself = %@",self);
    
    if([callTemp isEqualToString:@"00:00:00 남음"]) {
        
        [self stopTimer];
        //[self viewDimmedShow:NO afterViewHide:YES];
        
        //self.lefttimelabel.hidden = NO;
        /*
         live 갱신 딜레이되면 타이머가 사라진 채 재 시도 하는데,
         > 갱신이 정상적으로 되기전까지 타이머 보여달래.
         >> 00:00:00 으로 나와도 되니까.
         NSLog(@"TVCapirequestcount = %ld",(long)TVCapirequestcount);
         */
        @try {
            
            NSInteger randNum = arc4random_uniform(11);
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshTVLiveContents) object:nil];
            [self performSelector:@selector(refreshTVLiveContents)  withObject:nil afterDelay:5.0f + (double)randNum];
            
        }
        @catch (NSException *exception) {
            NSLog(@"방송종료 후 방송컨텐츠 새로고침 ERROR : %@", exception);
        }
        
    }
    return callTemp;
}

- (void)sectionReloadTimerRemove{
    [self stopTimer];
}

-(void)stopTimer{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshTVLiveContents) object:nil];
    
    if([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"");
    }
}

- (void)refreshTVLiveContents {
    NSString *itemString = [Mocha_Util strReplace:@"#" replace:@"" string:self.strSectionCode ];
    
    NSURL *turl = [NSURL URLWithString:HOME_MAIN_MOBILE_LIVE_URLWITHCODE(itemString )];
    
    
    // nami0342 - BRD time 적용
    NSString *strBrdTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"API_ADD_BRD_TIME"];
    if(NCS(strBrdTime).length > 0)
    {
        NSString *strURL = [NSString stringWithFormat:@"%@%@",HOME_MAIN_MOBILE_LIVE_URLWITHCODE(itemString), strBrdTime];
        turl = [NSURL URLWithString:strURL];
    }
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0f];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    [urlRequest setHTTPMethod: @"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      if ([NCS(resultString) length] == 0) {
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              NSLog(@"[NCS(resultString) length] == 0");
                                              if(TVCapirequestcount < TVCREQUESTMAXCOUNT) {
                                                  TVCapirequestcount ++;
                                                  
                                                  [self stopTimer];
                                                  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                                                                target:self
                                                                                              selector:@selector(timerProc)
                                                                                              userInfo:nil
                                                                                               repeats:NO];
                                                  //[self performSelector:@selector(refreshTVLiveContents)  withObject:nil afterDelay:5.0f + (double)randNum];
                                              }
                                          });
                                      }
                                      else {
                                          
                                          NSDictionary *result = [resultString JSONtoValue];
                                          
                                          NSLog(@"result = %@",result);
                                          
                                          if(NCO(result) && NCO([result objectForKey:@"mobileLiveBanner"])) {
                                              
                                              NSDictionary *dicMobileLive = [result objectForKey:@"mobileLiveBanner"];
                                              
                                              NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
                                              [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
                                              [dateformat setDateFormat:@"yyyyMMddHHmmss"];
                                              
                                              NSDate *closeTime = nil;
                                              
                                              if (self.isPreparingBroad == NO) {
                                                  closeTime = [dateformat dateFromString:NCS([dicMobileLive objectForKey:@"broadCloseTime"])];
                                              }else{
                                                  //방송준비중
                                                  closeTime = [dateformat dateFromString:NCS([dicMobileLive objectForKey:@"broadStartTime"])];
                                              }
                                              
                                              double closestamp = [closeTime timeIntervalSince1970];
                                              //NSString * dbstr =   [NSString stringWithFormat:@"%d", closestamp ];
                                              double left = closestamp - [[NSDate getSeoulDateTime] timeIntervalSince1970];
                                              dispatch_async( dispatch_get_main_queue(),^{
                                                  
                                                  
                                                  if (self.isPreparingBroad == NO) {
                                                      //방송중 다음방송 갱신
                                                      if (left <=0) {
                                                          if(TVCapirequestcount < TVCREQUESTMAXCOUNT) {
                                                              TVCapirequestcount ++;
                                                              if ([NCS([dicMobileLive objectForKey:@"broadCloseTime"]) length] > 0) {
                                                                  
                                                                  [self stopTimer];
                                                                  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                                                                                target:self
                                                                                                              selector:@selector(timerProc)
                                                                                                              userInfo:nil
                                                                                                               repeats:NO];
                                                              }
                                                              
                                                              
                                                              //[self performSelector:@selector(refreshTVLiveContents)  withObject:nil afterDelay:5.0f+ (double)randNum];
                                                          }
                                                      }
                                                      else {
                                                          //다음방송 정보를 불러왔는데 준비중인지 바로 방송인지?
                                                          
                                                          //rdic = [result objectForKey:@"mobileLiveBanner"];
                                                          
                                                          NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
                                                          [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
                                                          [dateformat setDateFormat:@"yyyyMMddHHmmss"];
                                                          //종료시간
                                                          NSDate *startTime = [dateformat dateFromString:NCS([[result objectForKey:@"mobileLiveBanner"] objectForKey:@"broadStartTime"])];
                                                          int startStamp = [startTime timeIntervalSince1970];
                                                          //남은방송시간
                                                          double leftTimeSec = startStamp - [[NSDate getSeoulDateTime] timeIntervalSince1970];
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              
                                                              if ([NCS([[result objectForKey:@"mobileLiveBanner"] objectForKey:@"broadStartTime"]) length] > 0) {
                                                                  
                                                                  if (leftTimeSec > 0.0) {
                                                                      //방송 준비중
                                                                      self.hidden = YES;
                                                                      self.isPreparingBroad = YES;
                                                                      
                                                                      [self stopTimer];
                                                                      //[self stopMoviePlayer];
                                                                      
                                                                      if ([self.target respondsToSelector:@selector(tableHeaderChangeSizeBTypeIsSpread:isLiveBroad:mobileLiveBroadStart:)]) {
                                                                          //숨김처리
                                                                          [self.target tableHeaderChangeSizeBTypeIsSpread:NO isLiveBroad:HEADER_BTYPE_MOBILELIVE mobileLiveBroadStart:YES];
                                                                      }
                                                                      
                                                                      [self setCellInfoNDrawData:dicMobileLive];
                                                                      
                                                                  }else{
                                                                      //방송중
                                                                      self.hidden = NO;
                                                                      self.isPreparingBroad = NO;
                                                                      
                                                                      [self setCellInfoNDrawData:dicMobileLive];
                                                                      
                                                                  }
                                                              }else{
                                                                  //방송시작시간 없음 판단기준 없음으로 안그림
                                                                  
                                                                  self.hidden = YES;
                                                                  self.isPreparingBroad = YES;
                                                                  //[self stopMoviePlayer];
                                                                  [self stopTimer];
                                                              }
                                                              
                                                              
                                                              if([self.target respondsToSelector:@selector(updateHeaderDicInfo:broadType:)]){
                                                                  [self.target updateHeaderDicInfo:dicMobileLive broadType:HEADER_BTYPE_MOBILELIVE];
                                                              }
                                                          });
                                                          
                                                      }
                                                  }else{
                                                      //방송준비중상태에서 방송시작시간이 되어서 통신성공
                                                      
                                                      //방송시작시간이 지나서 통신을 성공했는데 방송 시작 시간이 이미 지났으면
                                                      //방송중으로 판단
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          if (left <=0) {
                                                              
                                                              //rdic = [result objectForKey:@"mobileLiveBanner"];
                                                              
                                                              if ([NCS([dicMobileLive objectForKey:@"broadType"]) isEqualToString:@""] == NO && [NCS([dicMobileLive objectForKey:@"imageUrl"]) isEqualToString:@""] == NO && [NCS([dicMobileLive objectForKey:@"linkUrl"]) isEqualToString:@""] == NO) {
                                                                  [self setCellInfoNDrawData:dicMobileLive];
                                                                  
                                                                  self.hidden = NO;
                                                                  self.isPreparingBroad = NO;
                                                                  
                                                                  if ([self.target respondsToSelector:@selector(tableHeaderChangeSizeBTypeIsSpread:isLiveBroad:mobileLiveBroadStart:)]) {
                                                                      [self.target tableHeaderChangeSizeBTypeIsSpread:NO isLiveBroad:HEADER_BTYPE_MOBILELIVE mobileLiveBroadStart:YES];
                                                                  }
                                                              }
                                                              
                                                              if([self.target respondsToSelector:@selector(updateHeaderDicInfo:broadType:)]){
                                                                  [self.target updateHeaderDicInfo:dicMobileLive broadType:HEADER_BTYPE_MOBILELIVE];
                                                              }
                                                          }
                                                          else {
                                                              
                                                              if(TVCapirequestcount < TVCREQUESTMAXCOUNT) {
                                                                  TVCapirequestcount ++;
                                                                  
                                                                  if ([NCS([dicMobileLive objectForKey:@"broadStartTime"]) length] > 0) {
                                                                      
                                                                      [self stopTimer];
                                                                      self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                                                                                    target:self
                                                                                                                  selector:@selector(timerProc)
                                                                                                                  userInfo:nil
                                                                                                                   repeats:NO];
                                                                  }
                                                                  
                                                                  
                                                                  //[self performSelector:@selector(refreshTVLiveContents)  withObject:nil afterDelay:5.0f+ (double)randNum];
                                                              }
                                                              
                                                              
                                                          }
                                                          
                                                      });
                                                  }
                                                  
                                                  
                                              });
                                              
                                          }
                                      }
                                  }];
    [task resume];
    
}
@end


