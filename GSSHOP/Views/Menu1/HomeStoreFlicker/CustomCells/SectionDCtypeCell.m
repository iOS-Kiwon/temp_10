//
//  SectionDCtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 10. 21..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionDCtypeCell.h"
#import "Common_Util.h"
#import "AppDelegate.h"
#import "RCMDCELL.h"
#import "HztbGlobalVariables.h"

@implementation SectionDCtypeCell

@synthesize productImageView,soldoutView, soldoutimgView, videoImageView, productTitleLabel, productSubTitleLabel, discountRateLabel,discountRatePercentLabel,gsLabelView,extLabel,gsPriceLabel,gsPriceWonLabel  ;
@synthesize originalPriceLabel,originalPriceWonLabel,originalPriceLine,saleCountLabel,saleSaleLabel,saleSaleSubLabel,imageURL,timeDealLabel,timeDealView,adPopupButton,adPopup;
@synthesize contLTHeight,contLTWidth,contPrdImageWidth;

@synthesize promotionNameLabel;
@synthesize dummytagRB1,dummytagRB2,dummytagRB3,dummytagRB4;
@synthesize dummytagVT1, dummytagVT2;
@synthesize dummytagLT1;
@synthesize dummytagTF1;

@synthesize valuetextLabel, valueinfoLabel;

//
@synthesize abPercentageLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
}


//셀 화면 초기화
-(void)cellScreenDefine {
    textAreaHeigth = 92 + self.benefitHeigth;
    self.infoBoxBottom.constant = 28 + self.benefitHeigth;
    self.heightConstraint.constant = kTVCBOTTOMMARGIN;
    self.salesalelabel_width.constant = 46;
    self.valueinfolabel_lmargin.constant = 0;
    self.producttitlelabel_lmargin.constant = 0;
    self.gspricelabel_lmargin.constant = 60;
    self.originalPricelabel_rmargin.constant = 0;
    self.originalPricelabel_lmargin.constant =0;
    self.view_Default.frame = CGRectMake(0, 0, APPFULLWIDTH,  [Common_Util DPRateOriginVAL:160] + textAreaHeigth );
    //전체 높이와 같다고 봐야함.
    self.textSpace_bottom.constant = textAreaHeigth;
    self.imgSpace_bottom.constant = textAreaHeigth;
    self.bottomLineSpace_bottom.constant = textAreaHeigth;
    self.videoiConBottom.constant = textAreaHeigth + 6;
    
    
    
    [self.view_Default layoutIfNeeded];
}


-(void) prepareForReuse {
    //아랫줄 필수
    [super prepareForReuse];
    [self cellScreenDefine];
    self.valuetextLabel.hidden = YES;
    self.valueinfoLabel.hidden = YES;
    self.dummytagRB1.hidden = YES;
    self.dummytagRB2.hidden = YES;
    self.dummytagRB3.hidden = YES;
    self.dummytagRB4.hidden = YES;
    self.dummytagRB5.hidden = YES;
    self.dummytagVT1.hidden = YES;
    self.dummytagVT2.hidden = YES;
    self.dummytagLT1.hidden = YES;
    self.dummytagLT1.image = nil;
    self.dummytagTF1.text = @"";
    self.gsLabelView.hidden = YES;
    self.originalPriceLine.hidden = YES;
    self.extLabel.hidden = YES;
    self.gsPriceLabel.text = @"";
    self.originalPriceLabel.text = @"";
    self.originalPriceWonLabel.hidden = YES;
    self.saleCountLabel.text = @"";
    self.saleSaleLabel.hidden =YES;
    self.saleSaleSubLabel.hidden = YES;
    self.discountRateLabel.hidden =YES;
    self.discountRateLabel.text = @"";
    self.discountRatePercentLabel.hidden =YES;
    self.videoImageView.hidden  = YES;
    self.soldoutView.hidden = YES;
    self.soldoutimgView.hidden = YES;
    self.productTitleLabel.text = @"";
    self.productSubTitleLabel.text = @"";
    self.productSubTitleLabel.hidden = YES;
    self.productImageView.image = nil;
    self.promotionNameLabel.text = @"";
    timeDealValue = @"";
    self.timeDealLabel.text = @"";
    self.timeDealLabel.hidden = YES;
    self.timeDealView.hidden = YES;
    self.adPopupButton.hidden = YES;
    self.adPopup.hidden = YES;
    if ([self.timeDealTimer isValid]) {
        [self.timeDealTimer invalidate];
        self.timeDealTimer = nil;
    }
    if(benefitview != nil) {
       [benefitview removeFromSuperview];
        benefitview = nil;
    }
    self.backgroundColor = [UIColor clearColor];
    
    // nami0342 - Init color for Apptimize
    [self.gsPriceLabel setTextColor:[Mocha_Util getColor:@"121212"]];
    [self.gsPriceWonLabel setTextColor:[Mocha_Util getColor:@"121212"]];
    self.abPercentageLabel.text = @"";
    self.abPercentageLabel.hidden = YES;
    self.m_isApptimizeON = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//셀 데이터 셋팅 , 테이블뷰에서 호출
- (void) setCellInfoNDrawData:(NSDictionary*) infoDic {
    
    NSMutableString *strAccess = [[NSMutableString alloc] initWithString:@""];
    
    //AI 매장용 정사각형 상품셀 대응
    if ([self.reuseIdentifier isEqualToString:@"SectionDCtypeCell_S"]) {
        self.contPrdImageWidth.constant = (CGFloat)roundf(APPFULLWIDTH*(2.0/3.0));
        self.noImageView.image = [UIImage imageNamed:@"noimg_550_550.png"];
    }
    else {
        self.contPrdImageWidth.constant = APPFULLWIDTH;
        self.noImageView.image = [UIImage imageNamed:@"noimg_320.png"];
    }
 
    self.backgroundColor = [UIColor clearColor];
    
    //19금 제한 적용 v3.1.6.17 20150602~
    if([NCS([infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"]) {
        if( [Common_Util isthisAdultCerted] == NO) {
            //AI 매장용 정사각형 이미지대응
            if ([self.reuseIdentifier isEqualToString:@"SectionDCtypeCell_S"]) {
                self.productImageView.image =  [UIImage imageNamed:@"img19.png"];
            }
            else {
                self.productImageView.image =  [UIImage imageNamed:@"prevent19cellimg"];
            }
        }
        else {
            self.imageURL = NCS([infoDic objectForKey:@"imageUrl"]);
            if([self.imageURL length] > 0) {
                // 이미지 로딩
                [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if (error == nil  && [self.imageURL isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(isInCache) {
                              self.productImageView.image = fetchedImage;
                            }
                            else {
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
                            }//else
                        });//dispatch
                    }//if
                }];//[ImageDownManager
            }
        }
    }
    else {
        self.imageURL = NCS([infoDic objectForKey:@"imageUrl"]);
        if([self.imageURL length] > 0) {
            // 이미지 로딩
            [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                if (error == nil  && [self.imageURL isEqualToString:strInputURL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache) {
                            self.productImageView.image = fetchedImage;
                        }
                        else {
                            self.productImageView.alpha = 0;
                            self.productImageView.image = fetchedImage;
                            
                            [UIView animateWithDuration:0.1f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.productImageView.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        }//if else
                    });
                }//if
            }];
        }//if
    }
    
    
    
    
    
    //성인여부
    if([NCS([infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"]) {
        if( [Common_Util isthisAdultCerted] == YES) {
            //LT 처리
            if(NCO([infoDic objectForKey:@"imgBadgeCorner"])) {
                if( !NCA([[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ]) ) {
                    self.dummytagLT1.hidden = YES;
                }
                else {
                    self.dummytagLT1.hidden = NO;
                    if(self.dummytagLT1.image == nil) {
                        NSString *LTurl  = NCS([[ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] objectAtIndex:0] objectForKey: @"imgUrl" ]);
                        if(LTurl.length > 0) {
                            [ImageDownManager blockImageDownWithURL:LTurl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                                if (error == nil  && [LTurl isEqualToString:strInputURL]) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                    //실제 사이즈 대비 1/2로 축소
                                        UIImage *resizeImage = [UIImage imageWithCGImage:fetchedImage.CGImage scale:fetchedImage.scale * 2.0f orientation:fetchedImage.imageOrientation];
                                    
                                        self.contLTWidth.constant = resizeImage.size.width;
                                        self.contLTHeight.constant = resizeImage.size.height;

                                        if(isInCache) {
                                           self.dummytagLT1.image = resizeImage;
                                        }
                                        else {
                                           self.dummytagLT1.alpha = 0;
                                           self.dummytagLT1.image = resizeImage;
                                           
                                           [UIView animateWithDuration:0.1f
                                                                 delay:0.0f
                                                               options:UIViewAnimationOptionCurveEaseInOut
                                                            animations:^{
                                                                self.dummytagLT1.alpha = 1;
                                                            }
                                                            completion:^(BOOL finished) {
                                                                
                                                            }];
                                        }
                                    });
                                }
                           }];
                            //ad구좌 여부 확인후 팝업 노출 표기
                            if([NCS([infoDic objectForKey:@"adDealYn"])  isEqualToString:@"Y"]) {
                                self.adPopupButton.hidden = NO;
                                if(self.dummytagLT1.image == nil) {
                                    self.dummytagLT1.hidden = NO;
                                    self.dummytagLT1.image = [UIImage imageNamed:@"ic_ad3"];
                                }
                            }
                            else {
                                self.adPopup.hidden = YES;
                                self.adPopupButton.hidden = YES;
                            }
                        }//if
                    }
                }
            }
            
            
            
            //R 시리즈 처리
            if(NCO([infoDic objectForKey:@"imgBadgeCorner"]) && NCA([[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ]) ) {
                switch( [(NSArray*)[[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] count] ) {
                    case 0:
                        self.dummytagRB1.hidden = YES;
                        self.dummytagRB2.hidden = YES;
                        self.dummytagRB3.hidden = YES;
                        self.dummytagRB4.hidden = YES;
                        self.dummytagRB5.hidden = YES;
                        break;
                    case 1:
                        self.dummytagRB1.hidden = YES;
                        self.dummytagRB2.hidden = YES;
                        self.dummytagRB3.hidden = YES;
                        self.dummytagRB4.hidden = YES;
                        self.dummytagRB5.hidden = NO;
                        self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                        break;
                    case 2:
                        self.dummytagRB1.hidden = YES;
                        self.dummytagRB2.hidden = YES;
                        self.dummytagRB3.hidden = YES;
                        self.dummytagRB4.hidden = NO;
                        self.dummytagRB5.hidden = NO;
                        self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                        self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ])  ];
                        break;
                    case 3:
                        self.dummytagRB1.hidden = YES;
                        self.dummytagRB2.hidden = YES;
                        self.dummytagRB3.hidden = NO;
                        self.dummytagRB4.hidden = NO;
                        self.dummytagRB5.hidden = NO;
                        self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                        self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ])  ];
                        self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:2] objectForKey: @"type" ])  ];
                        break;
                    case 4:
                        self.dummytagRB1.hidden = YES;
                        self.dummytagRB2.hidden = NO;
                        self.dummytagRB3.hidden = NO;
                        self.dummytagRB4.hidden = NO;
                        self.dummytagRB5.hidden = NO;
                        self.dummytagRB2.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                        self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ])  ];
                        self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:2] objectForKey: @"type" ])  ];
                        self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:3] objectForKey: @"type" ])  ];
                        break;
                    case 5:
                        self.dummytagRB1.hidden = NO;
                        self.dummytagRB2.hidden = NO;
                        self.dummytagRB3.hidden = NO;
                        self.dummytagRB4.hidden = NO;
                        self.dummytagRB5.hidden = NO;
                        self.dummytagRB1.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                        self.dummytagRB2.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ])  ];
                        self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:2] objectForKey: @"type" ])  ];
                        self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:3] objectForKey: @"type" ])  ];
                        self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:4] objectForKey: @"type" ])  ];
                        break;
                    default:
                        break;
                }
            }
            else {
                // nami0342 - NCA
                self.dummytagRB1.hidden = YES;
                self.dummytagRB2.hidden = YES;
                self.dummytagRB3.hidden = YES;
                self.dummytagRB4.hidden = YES;
                self.dummytagRB5.hidden = YES;
            }
        }
        else {
            
            //// 성인상품인데 성인인증 안한 상태이며 우 하단 벳지들 모두 prepareReuse 로 초기화만 된 상태임
            self.dummytagRB1.hidden = YES;
            self.dummytagRB2.hidden = YES;
            self.dummytagRB3.hidden = YES;
            self.dummytagRB4.hidden = YES;
            self.dummytagRB5.hidden = YES;
        }
    }
    else {
        // 성인여부체크
        //LT용
        if(NCO([infoDic objectForKey:@"imgBadgeCorner"])){
        
            if( !NCA([[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ])) {
                self.dummytagLT1.hidden = YES;
            }
            else {
                self.dummytagLT1.hidden = NO;
                if(self.dummytagLT1.image == nil) {
                    
                    //20160106 벳지 크기가 다양하게 들어와도 대응할수 있도록 처리
                    NSString *LTurl  = NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] objectAtIndex:0] objectForKey: @"imgUrl" ]);
                    NSLog(@"%@",LTurl);
                    [ImageDownManager blockImageDownWithURL:LTurl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                        if (error == nil  && [LTurl isEqualToString:strInputURL]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //실제 사이즈 대비 1/2로 축소
                                UIImage *resizeImage = [UIImage imageWithCGImage:fetchedImage.CGImage scale:fetchedImage.scale * 2.0f orientation:fetchedImage.imageOrientation];
                                NSLog(@"%f,%f",resizeImage.size.width,resizeImage.size.height);
                                
                                self.contLTWidth.constant = resizeImage.size.width;
                                self.contLTHeight.constant = resizeImage.size.height;
                                
                                if (isInCache) {
                                    self.dummytagLT1.image = resizeImage;
                                }
                                else {
                                    self.dummytagLT1.alpha = 0;
                                    self.dummytagLT1.image = resizeImage;
                                    
                                    [UIView animateWithDuration:0.1f
                                                          delay:0.0f
                                                        options:UIViewAnimationOptionCurveEaseInOut
                                                     animations:^{
                                                         self.dummytagLT1.alpha = 1;
                                                     }
                                                     completion:^(BOOL finished) {
                                                         
                                                     }];
                                }
                            });
                        }// if
                   }];
                    //ad구좌 여부 확인후 팝업 노출 표기
                    if([NCS([infoDic objectForKey:@"adDealYn"])  isEqualToString:@"Y"]) {
                        self.adPopupButton.hidden = NO;
                    }
                    else {
                        self.adPopup.hidden = YES;
                        self.adPopupButton.hidden = YES;
                    }                    
                }
            }
        }
        
        
        //RB처리
        if(NCO([infoDic objectForKey:@"imgBadgeCorner"]) && NCA([[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ]) ) {
            
            switch ([(NSArray*)[[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] count]) {
                case 0:
                    self.dummytagRB1.hidden = YES;
                    self.dummytagRB2.hidden = YES;
                    self.dummytagRB3.hidden = YES;
                    self.dummytagRB4.hidden = YES;
                    self.dummytagRB5.hidden = YES;
                    break;
                    
                case 1:
                    self.dummytagRB1.hidden = YES;
                    self.dummytagRB2.hidden = YES;
                    self.dummytagRB3.hidden = YES;
                    self.dummytagRB4.hidden = YES;
                    self.dummytagRB5.hidden = NO;
                    self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                    break;
                    
                case 2:
                    self.dummytagRB1.hidden = YES;
                    self.dummytagRB2.hidden = YES;
                    self.dummytagRB3.hidden = YES;
                    self.dummytagRB4.hidden = NO;
                    self.dummytagRB5.hidden = NO;
                    self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                    self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ])  ];
                    break;
                    
                case 3:
                    self.dummytagRB1.hidden = YES;
                    self.dummytagRB2.hidden = YES;
                    self.dummytagRB3.hidden = NO;
                    self.dummytagRB4.hidden = NO;
                    self.dummytagRB5.hidden = NO;
                    self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                    self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ])  ];
                    self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:2] objectForKey: @"type" ])  ];
                    break;
                    
                case 4:
                    self.dummytagRB1.hidden = YES;
                    self.dummytagRB2.hidden = NO;
                    self.dummytagRB3.hidden = NO;
                    self.dummytagRB4.hidden = NO;
                    self.dummytagRB5.hidden = NO;
                    self.dummytagRB2.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                    self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ])  ];
                    self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:2] objectForKey: @"type" ])  ];
                    self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:3] objectForKey: @"type" ])  ];
                    break;
                    
                case 5:
                    self.dummytagRB1.hidden = NO;
                    self.dummytagRB2.hidden = NO;
                    self.dummytagRB3.hidden = NO;
                    self.dummytagRB4.hidden = NO;
                    self.dummytagRB5.hidden = NO;
                    self.dummytagRB1.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ])  ];
                    self.dummytagRB2.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ])  ];
                    self.dummytagRB3.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:2] objectForKey: @"type" ])  ];
                    self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:3] objectForKey: @"type" ])  ];
                    self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:4] objectForKey: @"type" ])  ];
                    break;
                    
                default:
                    break;
            }
            
        }
        else {
             // nami0342 - NCA
            self.dummytagRB1.hidden = YES;
            self.dummytagRB2.hidden = YES;
            self.dummytagRB3.hidden = YES;
            self.dummytagRB4.hidden = YES;
            self.dummytagRB5.hidden = YES;
        }
    }
    
    //20160126 segun 숫자인지 아닌지 확인이 필요한데...... String이 아니라면?
    // soldout image view
    self.soldoutView.hidden =![(NSNumber *)NCB([infoDic objectForKey:@"isTempOut"]) boolValue];
    self.soldoutimgView.hidden =![(NSNumber *)NCB([infoDic objectForKey:@"isTempOut"]) boolValue];
    
    // video image view
    self.videoImageView.hidden = ![(NSNumber *)NCB([infoDic objectForKey:@"hasVod"]) boolValue];
    
    
    if(NCO([infoDic objectForKey:@"infoBadge"]) && NCA([[infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ])) {
    
        switch ([(NSArray*)[[infoDic objectForKey:@"infoBadge"] objectForKey:@"VT" ] count]) {
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
    else {
        // nami0342 - NCA
        self.dummytagVT1.hidden = YES;
        self.dummytagVT2.hidden = YES;
    }
    
    
    if(NCO([infoDic objectForKey:@"infoBadge"]) && NCA([[infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ])) {
        
        if([(NSArray*)[[infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
            self.dummytagTF1.hidden = NO;
            @try {
                self.dummytagTF1.text = (NSString*)NCS([ [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
                
                [strAccess appendString:(NSString*)NCS([ [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ])];
                
                if( [(NSString*)NCS([ [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]) length] > 0){
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
    else {
        // nami0342 - NCA
        self.dummytagTF1.hidden = YES;
        self.dummytagTF1.text = @"";
        self.producttitlelabel_lmargin.constant = 0;
    }
    
    self.productTitleLabel.text = NCS([infoDic objectForKey:@"productName"]);
    self.promotionNameLabel.text = NCS([infoDic objectForKey:@"promotionName"]);
    
    [strAccess appendString:NCS([infoDic objectForKey:@"productName"])];
    
    
    // 할인율 / GS가
    NSString *removeCommadrstr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",NCS([infoDic objectForKey:@"discountRate"])] ];
    
//    if([NCS([infoDic objectForKey:@"discountRateText"])  length] > 0 ) {
//        self.gsLabelView.hidden = YES;
//        self.extLabel.text = NCS([infoDic objectForKey:@"discountRateText"]);
//        self.extLabel.hidden = NO;
//        CGSize extlabelsize = [self.extLabel sizeThatFits:extLabel.frame.size];
//        self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN+extlabelsize.width+kCELLCONTENTSBETWEENMARGIN;
//        self.discountRateLabel.hidden = YES;
//        self.discountRatePercentLabel.hidden = YES;
//    }
//    else
    if([Common_Util isThisValidWithZeroStr:removeCommadrstr] == YES) {
        //확인이 필요하다.
        if(NCO([infoDic objectForKey:@"discountRate"])) {
            int discountRate = [(NSNumber *)[infoDic objectForKey:@"discountRate"] intValue];
           
             if(discountRate > 0) {
                 if(self.m_isApptimizeON &&([ApplicationDelegate.m_strApptimize isEqualToString:@"pd1"] ||
                    [ApplicationDelegate.m_strApptimize isEqualToString:@"pd2"] ||
                    [ApplicationDelegate.m_strApptimize isEqualToString:@"pd4"]))
                 {
                     // nami0342 - Apptimize : 할인률 제거
                     self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN;
                     self.discountRateLabel.hidden = YES;
                     self.discountRatePercentLabel.hidden = YES;
                 }
                 else if(self.m_isApptimizeON &&([ApplicationDelegate.m_strApptimize isEqualToString:@"pd3"]))
                 {
                     self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN;
                     self.discountRateLabel.hidden = YES;
                     self.discountRatePercentLabel.hidden = YES;
                     
                     self.abPercentageLabel.text = [NSString stringWithFormat:@"%d%%", discountRate];
                     self.abPercentageLabel.hidden = NO;
                     [self.abPercentageLabel setTextColor:[Mocha_Util getColor:@"EC2261"]];
                     
                 }
                 else
                 {
                    self.discountRateLabel.text = [NSString stringWithFormat:@"%d", discountRate];
                    self.discountRateLabel.hidden = NO;
                    self.discountRatePercentLabel.hidden = NO;
                    float disratelabelsize = [self.discountRateLabel sizeThatFits:discountRateLabel.frame.size].width + [self.discountRatePercentLabel sizeThatFits:discountRatePercentLabel.frame.size].width;
                    self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN+disratelabelsize+kCELLCONTENTSBETWEENMARGIN;
                 }
                self.gsLabelView.hidden = YES;
                self.extLabel.hidden = YES;
            }
             else {
                 self.gspricelabel_lmargin.constant =  kCELLCONTENTSLEFTMARGIN;
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
    }
    else {
        self.valuetextLabel.text = @"";
        self.valuetextLabel.hidden = YES;
    }
    
    //valueInfo
    if([NCS([infoDic objectForKey:@"valueInfo"])  length] > 0 ) {
        self.valueinfoLabel.hidden = NO;
        self.valueinfoLabel.text = [infoDic objectForKey:@"valueInfo"];
        self.valueinfolabel_lmargin.constant = 7;
    }
    else {
        self.valueinfoLabel.text = @"";
        self.valueinfoLabel.hidden = YES;
        self.valueinfolabel_lmargin.constant = 0;
    }
    
    
    int salePrice = 0;
    
    if(NCO([infoDic objectForKey:@"salePrice"])) {
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"salePrice"]]      ];
        
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES) {
            salePrice = [(NSNumber *)removeCommaspricestr intValue];
            self.gsPriceLabel.text = [Common_Util commaStringFromDecimal:salePrice];
            self.gsPriceWonLabel.text  =  NCS([infoDic objectForKey:@"exposePriceText"]);
            self.gsPriceLabel.hidden = NO;
            self.gsPriceWonLabel.hidden = NO;
            
            [strAccess appendString:[Common_Util commaStringFromDecimal:salePrice]];
            [strAccess appendString:NCS([infoDic objectForKey:@"exposePriceText"])];
            
            // nami0342 - Apptimize : 가격과 원 붉은 색으로
            if(self.m_isApptimizeON &&([ApplicationDelegate.m_strApptimize isEqualToString:@"pd4"]))
            {
                [self.gsPriceLabel setTextColor:[Mocha_Util getColor:@"EC2261"]];
                [self.gsPriceWonLabel setTextColor:[Mocha_Util getColor:@"EC2261"]];
            }
        }
        else {
            //숫자아님
            self.gsPriceLabel.hidden = YES;
            self.gsPriceWonLabel.hidden = NO;
        }
    }
    else {
        self.gsPriceLabel.hidden = YES;
        self.gsPriceWonLabel.hidden = YES;
        
        [strAccess appendString:self.valuetextLabel.text];
        [strAccess appendString:self.valueinfoLabel.text];
        
    }
    
    
    
    
    //실선 baseprice 원래 가격
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([infoDic objectForKey:@"basePrice"])];
    int basePrice = [(NSNumber *)removeCommaorgstr intValue];
    if (basePrice > 0 && basePrice > salePrice) {
        //2015/07/29 yunsang.jin 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        if (NCO([infoDic objectForKey:@"discountRate"]) && [ [infoDic objectForKey:@"discountRate"] intValue] < 1) {
            self.originalPriceLabel.text = @"";
            self.originalPriceWonLabel.text = @"";
            self.originalPriceLine.hidden = YES;
            self.originalPriceLabel.hidden = YES;
            self.originalPriceWonLabel.hidden = YES;
            self.originalPricelabel_lmargin.constant = 0;
            self.originalPricelabel_rmargin.constant = 0;
            
            if([NCS([infoDic objectForKey:@"valueInfo"] ) length] > 1 ) {
                self.originalPricelabel_rmargin.constant = 0;
            }
            else {
                self.originalPricelabel_rmargin.constant = 8;
            }
        }
        else {
            
            // nami0342 : Apptimize - 베이스가 비 노출
            if(self.m_isApptimizeON &&([ApplicationDelegate.m_strApptimize isEqualToString:@"pd2"] ||
               [ApplicationDelegate.m_strApptimize isEqualToString:@"pd4"] ))
            {
                self.originalPriceLine.hidden = YES;
                self.originalPriceLabel.hidden = YES;
                self.originalPriceWonLabel.hidden = YES;
                self.originalPricelabel_lmargin.constant = 0;
                self.originalPricelabel_rmargin.constant = 0;
            }
            else if(self.m_isApptimizeON &&([ApplicationDelegate.m_strApptimize isEqualToString:@"pd3"]))
            {
                self.originalPriceLabel.text = [Common_Util commaStringFromDecimal:basePrice];
                self.originalPriceWonLabel.text = NCS([infoDic objectForKey:@"exposePriceText"]);
                self.originalPriceLabel.hidden = NO;
                self.originalPriceWonLabel.hidden = NO;
                self.originalPriceLine.hidden = NO;
                float disratelabelsize = [self.abPercentageLabel sizeThatFits:abPercentageLabel.frame.size].width;
                self.originalPricelabel_lmargin.constant = kCELLCONTENTSLEFTMARGIN+ disratelabelsize;
                self.originalPricelabel_rmargin.constant = 8;
            }
            else
            {
                self.originalPriceLabel.text = [Common_Util commaStringFromDecimal:basePrice];
                self.originalPriceWonLabel.text = NCS([infoDic objectForKey:@"exposePriceText"]);
                self.originalPriceLabel.hidden = NO;
                self.originalPriceWonLabel.hidden = NO;
                self.originalPriceLine.hidden = NO;
                self.originalPricelabel_lmargin.constant = 5;
                self.originalPricelabel_rmargin.constant = 8;
            }
        }
    }
    else {
        self.originalPriceLabel.text = @"";
        self.originalPriceWonLabel.text = @"";
        self.originalPriceLabel.hidden = YES;
        self.originalPriceWonLabel.hidden = YES;
        self.originalPriceLine.hidden = YES;
        self.originalPricelabel_lmargin.constant = 0;
        self.originalPricelabel_rmargin.constant = 0;
        
        if([NCS([infoDic objectForKey:@"valueInfo"])  length] > 1 ) {
            self.originalPricelabel_rmargin.constant = 0;
        }
        else {
            self.originalPricelabel_rmargin.constant = 8;
        }
    }
    
    
    //매진시 판매수량 노출하지않음
    if(self.soldoutView.hidden == NO) {
        self.saleCountLabel.hidden = YES;
        self.saleSaleLabel.hidden =YES;
        self.saleSaleSubLabel.hidden = YES;
        self.originalPricelabel_lmargin.constant = 0;
        self.originalPricelabel_rmargin.constant = 0;
        
        [self.view_Default layoutIfNeeded];
        return;
    }
    
    
    
    
    //3열 판매수량
    if(NCO([infoDic objectForKey:@"saleQuantity"])) {
        NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([infoDic objectForKey:@"saleQuantity"])];
        //숫자가 맞음
        if( [Common_Util isThisValidNumberStr:removeCommaorgstr]) {
            self.saleCountLabel.text = [NSString stringWithFormat:@"%@", NCS([infoDic objectForKey:@"saleQuantity"]) ];
            self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", NCS([infoDic objectForKey:@"saleQuantityText"]) ];
            self.saleSaleSubLabel.text = [NSString stringWithFormat:@"%@", NCS([infoDic objectForKey:@"saleQuantitySubText"]) ];
            self.saleCountLabel.hidden = NO;
            self.saleSaleLabel.hidden = NO;
            self.saleSaleSubLabel.hidden = NO;
            self.salesalelabel_width.constant = 50;
            
        }
        //숫자아니거나 0일때 수량text 존재함
        else if( [NCS([infoDic objectForKey:@"saleQuantityText"]) length] > 0) {
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
    
    
    // 타임딜 시작
    if(NCO([infoDic objectForKey:@"imgBadgeCorner"])) {
        if( NCA([[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ])) {
            // 타임딜 설정
            if( [NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] objectAtIndex:0] objectForKey: @"type" ]) isEqualToString:@"timeDeal"] == YES ) {
                timeDealValue = NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT" ] objectAtIndex:0] objectForKey: @"text" ]);
                [self startTimeDealTimer];
            }
            else {
                self.timeDealLabel.text = @"";
                self.timeDealView.hidden = YES;
            }

        }
        else {
            self.timeDealLabel.text = @"";
            self.timeDealView.hidden = YES;
        }
    }
    else {
        self.timeDealLabel.text = @"";
        self.timeDealView.hidden = YES;
    }


    
    //////// 하단 혜택 딱지 노출 시작 ////////20170929
    if(self.benefitHeigth != 0) {
        if(benefitview == nil) {
            benefitview = [[[NSBundle mainBundle] loadNibNamed:@"BenefitTagView" owner:self options:nil] firstObject];
            [self.view_Default addSubview:benefitview];
            
            //AI 매장용 정사각형 이미지대응
            if ([self.reuseIdentifier isEqualToString:@"SectionDCtypeCell_S"]) {
                benefitview.frame = CGRectMake(0,  (CGFloat)roundf(APPFULLWIDTH*(2.0/3.0)) + 64 , self.frame.size.width, self.benefitHeigth);
            }
            else {
                benefitview.frame = CGRectMake(0,  [Common_Util DPRateOriginVAL:160]  + 64 , self.frame.size.width, self.benefitHeigth);
            }
        }
        [benefitview setBenefitTag:infoDic];
    }
    //////// 하단 혜택 딱지 노출 종료 ////////
    
    self.accessibilityLabel = strAccess;
    
    [self.view_Default layoutIfNeeded];
}


//내부적으로 이미지 정보 있는 뱃지들 셋팅
-(UIImage*) tagimageWithtype : (NSString*)ttype {    
    UIImage *timage;
    //RB
    if([ttype isEqualToString:@"freeDlv"]) {
        timage = [UIImage imageNamed:@"dc_badge_free"];
    }
    else if([ttype isEqualToString:@"todayClose"]) {
        timage = [UIImage imageNamed:@"dc_badge_end"];
    }
    else if([ttype isEqualToString:@"freeInstall"]) {
        timage = [UIImage imageNamed:@"dc_badge_finstall"];
    }
    else if([ttype isEqualToString:@"Reserves"]) {
        timage = [UIImage imageNamed:@"dc_badge_reward"];
    }
    else if([ttype isEqualToString:@"interestFree"]) {
        timage = [UIImage imageNamed:@"dc_badge_nogain"];
    }
    //VT
    else if([ttype isEqualToString:@"quickDlv"]) {
        timage = [UIImage imageNamed:@"dc_stag_delivery"];
    }
    else if([ttype isEqualToString:@"worldDlv"]) {
        timage = [UIImage imageNamed:@"dc_btag_ocdelivery"];
    }
    else {
        return nil;
    }
    return timage;
}


#pragma 타임딜 메서드

-(void) startTimeDealTimer {
    if(NCS(timeDealValue).length <= 0) {
        return;
    }
    self.timeDealLabel.hidden = NO;
    self.timeDealView.hidden = NO;
    
    [self TimeDealTimerProcess];
    
    if ([self.timeDealTimer isValid]) {
        [self.timeDealTimer invalidate];
        self.timeDealTimer = nil;
    }
    self.timeDealTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(TimeDealTimerProcess)
                                                        userInfo:nil
                                                         repeats:YES];
}

-(void) stopTimeDealTimer {
    
    if ([self.timeDealTimer isValid]) {
        [self.timeDealTimer invalidate];
        self.timeDealTimer = nil;
    }
    else {

    }
    self.timeDealLabel.text = @"";
    self.timeDealLabel.hidden = YES;
    self.timeDealView.hidden = YES;
}



-(void) TimeDealTimerProcess {
    
    NSDate *startTime = [dateformat dateFromString:timeDealValue];
    long long startStamp = [startTime timeIntervalSince1970];

    //다음 방송까지 남은시간
    // nami0342 : 시스템 시간이 변경되도 서울 시간을 얻어온다.
    long long leftTimeSec = startStamp - (long long)[[NSDate getSeoulDateTime] timeIntervalSince1970];
    
    if ((leftTimeSec > 0) ) {
        NSString * dbstr =   [NSString stringWithFormat:@"%lld", (long long)startStamp ];
        self.timeDealLabel.text = [self getDateLeftToStart:dbstr];
        
    }
    else {
        // 끝나면..
        if ([self.timeDealTimer isValid]) {
            [self.timeDealTimer invalidate];
            self.timeDealTimer = nil;
        }
        self.timeDealLabel.text = @"";
        self.timeDealLabel.hidden = YES;
        self.timeDealView.hidden = YES;
    }
}




- (NSString *) getDateLeftToStart:(NSString *)date{
    
    // nami0342 : 시스템 시간이 변경되도 서울 시간을 얻어온다.
    double left = [date doubleValue] - [[NSDate getSeoulDateTime] timeIntervalSince1970];
    int tminite = left/60;
    int hour = left/3600;
    int minite = (left-(hour*3600))/60;
    int second = (left-(hour*3600)-(minite*60));
    
    NSString *callTemp = nil;
    
    //종료일이 100시간이 넘을 경우 99시간으로 표시. 2자리 시간이 남을 경우 정상적으로 2자리만 표시
    if(hour >= 100) {
        callTemp = [NSString stringWithFormat:@"99:59:59"];
    }
    else if(tminite >= 60) {
        callTemp = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minite, second];
    }
    else if(left <= 0) {
        callTemp  = [NSString stringWithFormat:@"00:00:00"];
    }
    else {
        callTemp  = [NSString stringWithFormat:@"00:%02d:%02d", minite, second];
    }
    
    if([callTemp isEqualToString:@"00:00:00"]) {
        [self.timeDealTimer invalidate];
        self.timeDealTimer = nil;
        self.timeDealLabel.text = @"";
        self.timeDealLabel.hidden = YES;
        self.timeDealView.hidden = YES;
    }
    
    return callTemp;
}



- (IBAction)adPopupCloseClick:(id)sender {
    self.adPopup.hidden = YES;
}

- (IBAction)adPopupShowClick:(id)sender {
    self.adPopup.hidden = YES;//!self.adPopup.hidden;
}
@end
