//
//  SectionDSLtypeSubProductView.m
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 9..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionDSLtypeSubProductView.h"
#import "Common_Util.h"
#import "AppDelegate.h"


@implementation SectionDSLtypeSubProductView
@synthesize productImageView, videoImageView, productTitleLabel, productSubTitleLabel, discountRateLabel,discountRatePercentLabel,extLabel,gsPriceLabel,gsPriceWonLabel;
@synthesize originalPriceLabel,originalPriceWonLabel,originalPriceLine,saleCountLabel,saleSaleLabel,saleSaleSubLabel,imageURL,dummytagLT1, LTbutton, adPopup;
@synthesize noImageView;
@synthesize viewLabels;
@synthesize dummytagRB1,dummytagRB2,dummytagRB3,dummytagRB4;
@synthesize dummytagRB5;
@synthesize dummytagTF1;
@synthesize valuetextLabel, valueinfoLabel;
@synthesize adultImageView;
@synthesize soldoutView;
@synthesize soldoutImageView;
@synthesize viewImageBottomLine;


- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}


- (id)initWithTarget:(id)sender with:(NSString*) viewtype {
    self = [super init];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SectionDSLtypeSubProductView" owner:self options:nil];
        if( !NCA(nibs) ) {
            return self;
        }
        self = [nibs objectAtIndex:0];
        self.targettb = sender;
        //DSL_A2,BAN_SLD_GBC는 혜택영역 노출하지 않음.
        viewType = viewtype;
        float benefitH = BENEFITTAG_HEIGTH;
        if([viewType isEqualToString:@"DSL_A2"] || [viewType isEqualToString:@"BAN_SLD_GBC"]) {
            benefitH = 0;
        }
        self.frame = CGRectMake(0, 0, [Common_Util DPRateOriginVAL:270.0] + 8.0,  [Common_Util DPRateOriginVAL:135.0] + 58.0 + benefitH);
        self.productImageView.frame = CGRectMake(0, 0, [Common_Util DPRateOriginVAL:270.0],  [Common_Util DPRateOriginVAL:135.0]);
        self.noImageView.frame = self.productImageView.frame;
        self.adultImageView.frame = self.productImageView.frame;
        self.soldoutView.center = self.productImageView.center;
        self.soldoutImageView.center = self.productImageView.center;
        viewImageBottomLine.frame = CGRectMake(0, [Common_Util DPRateOriginVAL:135.0] - 1.0,[Common_Util DPRateOriginVAL:270.0] ,  1.0);
        self.viewLabels.frame = CGRectMake(0, [Common_Util DPRateOriginVAL:135.0],[Common_Util DPRateOriginVAL:270.0] ,  58.0);
        self.dummytagRB1.hidden = YES;
        self.dummytagRB2.hidden = YES;
        self.dummytagRB3.hidden = YES;
        self.dummytagRB4.hidden = YES;
        self.dummytagRB1.frame = CGRectMake(dummytagRB1.frame.origin.x, [Common_Util DPRateOriginVAL:135.0] - dummytagRB1.frame.size.height,dummytagRB1.frame.size.width ,  dummytagRB1.frame.size.height);
        self.dummytagRB2.frame = CGRectMake(dummytagRB2.frame.origin.x, [Common_Util DPRateOriginVAL:135.0] - dummytagRB2.frame.size.height,dummytagRB2.frame.size.width ,  dummytagRB2.frame.size.height);
        self.dummytagRB3.frame = CGRectMake(dummytagRB3.frame.origin.x, [Common_Util DPRateOriginVAL:135.0] - dummytagRB3.frame.size.height,dummytagRB3.frame.size.width ,  dummytagRB3.frame.size.height);
        self.dummytagRB4.frame = CGRectMake(dummytagRB4.frame.origin.x, [Common_Util DPRateOriginVAL:135.0] - dummytagRB4.frame.size.height,dummytagRB4.frame.size.width ,  dummytagRB4.frame.size.height);
        self.dummytagRB5.frame = CGRectMake(dummytagRB5.frame.origin.x, [Common_Util DPRateOriginVAL:135.0] - dummytagRB5.frame.size.height,dummytagRB5.frame.size.width ,  dummytagRB5.frame.size.height);
    }
    return self;
}


-(void)cellScreenDefine {
}


-(void) prepareForReuse {
    self.valuetextLabel.hidden = YES;
    self.valueinfoLabel.hidden = YES;
    self.dummytagRB1.hidden = YES;
    self.dummytagRB2.hidden = YES;
    self.dummytagRB3.hidden = YES;
    self.dummytagRB4.hidden = YES;
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
    self.productTitleLabel.text = @"";
    self.productSubTitleLabel.text = @"";
    self.productSubTitleLabel.hidden = YES;
    self.productImageView.image = nil;
    self.LTbutton.hidden = YES;
    self.adPopup.hidden = YES;
    if(benefitview != nil) {
        [benefitview removeFromSuperview];
        benefitview = nil;
    }
    self.accessibilityLabel = @"";
    self.dummytagLT1.image = nil;
    self.backgroundColor = [UIColor clearColor];
}

//20180313 ad전용 클릭시 팝업 노출
- (IBAction)adNotiClick:(id)sender {
    //클릭하면 팝업 노출
    self.adPopup.hidden = YES;//!self.adPopup.hidden;
}

//20180313 ad팝업 닫기
- (IBAction)adNotiCloseClick:(id)sender {
    self.adPopup.hidden = YES;
}

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


-(void) setCellInfoNDrawData:(NSDictionary*) infoDic {
    
    NSMutableString *strAccess = [[NSMutableString alloc] initWithString:@""];
    
    //19금 제한 적용 v3.1.6.17 20150602~
    if([NCS([infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"] && [Common_Util isthisAdultCerted] == NO) {
        self.adultImageView.image =  [UIImage imageNamed:@"prevent19cellimg"];
        self.adultImageView.hidden = NO;
    }
    else {
        self.adultImageView.hidden = YES;
        if([NCS([infoDic objectForKey:@"imageUrl"]) length] > 0) {
            // 이미지 로딩
            self.imageURL = [infoDic objectForKey:@"imageUrl"];
            [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                if (error == nil  && [self.imageURL isEqualToString:strInputURL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache) {
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
                        }
                    });
                }//if
            }];           
        }
    }
    // soldout image view
    self.soldoutView.hidden = ![(NSNumber *)NCB([infoDic objectForKey:@"isTempOut"]) boolValue];
    // video image view
    self.videoImageView.hidden = ![(NSNumber *)NCB([infoDic objectForKey:@"hasVod"]) boolValue];
    self.videoImageView.frame = CGRectMake(videoImageView.frame.origin.x, [Common_Util DPRateOriginVAL:135.0] - videoImageView.frame.size.height - 5.0,videoImageView.frame.size.width ,  videoImageView.frame.size.height);
    //20180207 parksegun -> left top 이미지 벳지 가변 크기 변경
    //LT 처리
    if(NCO([infoDic objectForKey:@"imgBadgeCorner"])) {
        if( !NCA([[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"LT"]) ) {
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
                                self.dummytagLT1.frame = CGRectMake(0, 0, resizeImage.size.width, resizeImage.size.height);
                                self.LTbutton.frame = self.dummytagLT1.frame;
                                //ad팝업 위치 조정
                                self.adPopup.frame = CGRectMake(5, resizeImage.size.height, self.adPopup.frame.size.width, self.adPopup.frame.size.height);
                                
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
                        self.LTbutton.hidden = NO;
                        if(self.dummytagLT1.image == nil) {
                            self.dummytagLT1.hidden = NO;
                            self.dummytagLT1.image = [UIImage imageNamed:@"ic_ad3"];
                        }
                    }
                    else {
                        self.adPopup.hidden = YES;
                        self.LTbutton.hidden = YES;
                    }
                }//if
            }
        }
    }
    //20160108 타이틀앞 텍스트 벳지 추가
    NSDictionary *fontWithAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize dummytagTF1Size;
    // nami0342 - NCA
    if(NCO([infoDic objectForKey:@"infoBadge"]) == YES) {
        if(NCA([[infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ]) == YES) {
            if([(NSArray*)[[infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] count] > 0) { // >= 1
                self.dummytagTF1.hidden = NO;
                @try {
                    self.dummytagTF1.text =  (NSString*)NCS([   [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"text" ]);
                    
                    if( [(NSString*)NCS([   [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]) length] > 0){
                        self.dummytagTF1.textColor = [Mocha_Util getColor:
                                                      (NSString*)[   [ [ [infoDic objectForKey:@"infoBadge"] objectForKey:@"TF" ] objectAtIndex:0] objectForKey: @"type" ]];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"exception = %@",exception);
                }
                dummytagTF1Size =  [self.dummytagTF1.text  sizeWithAttributes:fontWithAttributes];
                self.productTitleLabel.frame = CGRectMake(dummytagTF1Size.width + 11 + 3, 9, self.view_Default.frame.size.width -  dummytagTF1Size.width  - 22, self.productTitleLabel.frame.size.height);
            }
            else {
                self.dummytagTF1.hidden = YES;
                self.dummytagTF1.text = @"";
                self.productTitleLabel.frame = CGRectMake(11, 9, self.view_Default.frame.size.width - 22, self.productTitleLabel.frame.size.height);
            }
        }
        else {
            self.dummytagTF1.hidden = YES;
            self.dummytagTF1.text = @"";
            self.productTitleLabel.frame = CGRectMake(11, 9, self.view_Default.frame.size.width  - 22 , self.productTitleLabel.frame.size.height);
        }
    }
    else {
        self.dummytagTF1.hidden = YES;
        self.dummytagTF1.text = @"";
        self.productTitleLabel.frame = CGRectMake(11, 9, self.view_Default.frame.size.width  - 22, self.productTitleLabel.frame.size.height);
    }
    self.productTitleLabel.text = NCS([infoDic objectForKey:@"productName"]);
    
    [strAccess appendString:NCS([infoDic objectForKey:@"productName"])];
    
    //20160108 TF 벳지추가로 타이틀 위치 및 크기 조정
    @try {
        if(NCO([infoDic objectForKey:@"imgBadgeCorner"]) && NCA([[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ]) ) {
            switch ([    (NSArray*)[[infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] count]) {
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
                    self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0]objectForKey: @"type" ])  ];
                    break;
                case 2:
                    self.dummytagRB1.hidden = YES;
                    self.dummytagRB2.hidden = YES;
                    self.dummytagRB3.hidden = YES;
                    self.dummytagRB4.hidden = NO;
                    self.dummytagRB5.hidden = NO;
                    
                    self.dummytagRB4.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:0] objectForKey: @"type" ]) ];
                    self.dummytagRB5.image = [self tagimageWithtype:     (NSString*)NCS([   [ [ [infoDic objectForKey:@"imgBadgeCorner"] objectForKey:@"RB" ] objectAtIndex:1] objectForKey: @"type" ]) ];
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
    @catch (NSException *exception) {
        NSLog(@"SectionDSLtypeSubProductView : %@", exception);
    }
    
    //A타입 = 광고 일반타입 광고셀
    if( [NCS([infoDic objectForKey:@"productType"])  isEqualToString:@"AD"] && [NCS([infoDic objectForKey:@"viewType"]) isEqualToString:@"L"] ) {
        if(NCO([infoDic objectForKey:@"promotionName"]) ) {
            self.productSubTitleLabel.text = NCS([infoDic objectForKey:@"promotionName"]);
            self.productSubTitleLabel.hidden = NO;
        }
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
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
    }// if
    
    // 할인율 / GS가
    NSString *removeCommadrstr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",NCS([infoDic objectForKey:@"discountRate"])]      ];
    
//    if([NCS([infoDic objectForKey:@"discountRateText"])  length] > 0 ) {
//
//        self.gsLabelView.hidden = YES;
//        self.extLabel.text = NCS([infoDic objectForKey:@"discountRateText"]);
//        self.extLabel.hidden = NO;
//        UILabel *label = self.extLabel;
//        CGSize size = [label sizeThatFits:label.frame.size];
//        label.frame = CGRectMake(label.frame.origin.x,
//                                 label.frame.origin.y,
//                                 size.width,
//                                 label.frame.size.height);
//
//        self.discountRateLabel.hidden = YES;
//        self.discountRatePercentLabel.hidden = YES;
//
//    }
//    else
    if(  [Common_Util isThisValidWithZeroStr:removeCommadrstr] == YES) {
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
                self.extLabel.hidden = YES;
            }
            else {
                //0% 숨김
                UILabel *label = self.discountRateLabel;
                UIView *nextView = self.discountRatePercentLabel;
                float nextOffset = 0;
                {
                    CGSize size = CGSizeMake(0, 0);
                    label.frame = CGRectMake(label.frame.origin.x,
                                             label.frame.origin.y,
                                             size.width,
                                             label.frame.size.height);
                    nextView.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + nextOffset,
                                                nextView.frame.origin.y,
                                                nextView.frame.size.width,
                                                nextView.frame.size.height);
                }
                self.discountRateLabel.hidden = YES;
                self.discountRatePercentLabel.hidden = YES;
                self.extLabel.hidden = YES;
            }
        }
        else {
            //20160630 parksegun discountRate값이 nil이면 해당 영역을 숨긴다.
            //전체 뷰히든
            self.discountRateLabel.hidden = YES;
            self.discountRatePercentLabel.hidden = YES;
            self.extLabel.hidden = YES;
        }
    }
    else {
        //전체 뷰히든
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
        self.extLabel.hidden = YES;
    }
    
    //valueText
    if( [NCS([infoDic objectForKey:@"valueText"])  length] > 0 ) {
        
        self.extLabel.hidden = YES;
        self.discountRateLabel.hidden = YES;
        self.discountRatePercentLabel.hidden = YES;
        self.valuetextLabel.text = NCS([infoDic objectForKey:@"valueText"]);
        self.valuetextLabel.hidden = NO;
        if (self.valuetextLabel.hidden == NO) {
            NSDictionary *fontWithAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            CGSize priceLabelSize =  [self.valuetextLabel.text  sizeWithAttributes:fontWithAttributes];
            self.valuetextLabel.frame = CGRectMake(self.valuetextLabel.frame.origin.x, self.valuetextLabel.frame.origin.y, priceLabelSize.width,  self.valuetextLabel.frame.size.height);
        }
        
        [strAccess appendString:self.valuetextLabel.text];
    }
    else {
        self.valuetextLabel.text = @"";
        self.valuetextLabel.hidden = YES;
    }
    
    int salePrice = 0;
    if(NCO([infoDic objectForKey:@"salePrice"])) {
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",NCS([infoDic objectForKey:@"salePrice"])] ];
        
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES) {
            salePrice = [(NSNumber *)removeCommaspricestr intValue];
            self.gsPriceLabel.text = [Common_Util commaStringFromDecimal:salePrice];

            NSDictionary *fontWithAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
            CGSize priceLabelSize =  [self.gsPriceLabel.text sizeWithAttributes:fontWithAttributes];
            if (self.valuetextLabel.hidden == NO) {
                gsPriceLabel.frame = CGRectMake(self.valuetextLabel.frame.origin.x + self.valuetextLabel.frame.size.width + 10, self.gsPriceLabel.frame.origin.y, priceLabelSize.width,  gsPriceLabel.frame.size.height);
                
            }
            else {
                gsPriceLabel.frame = CGRectMake(self.gsPriceLabel.frame.origin.x, self.gsPriceLabel.frame.origin.y, priceLabelSize.width,  gsPriceLabel.frame.size.height);
                //gsPriceLabel.frame = CGRectMake(self.discountRatePercentLabel.hidden ? 10 : self.gsPriceLabel.frame.origin.x, self.gsPriceLabel.frame.origin.y, priceLabelSize.width,  gsPriceLabel.frame.size.height);
            }
            
            self.gsPriceWonLabel.text  =  NCS([infoDic objectForKey:@"exposePriceText"]);
            
            NSDictionary *fontWithWonAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
            CGSize priceWonLabelSize =  [self.gsPriceWonLabel.text  sizeWithAttributes:fontWithWonAttributes];
            self.gsPriceWonLabel.frame = CGRectMake(self.gsPriceWonLabel.frame.origin.x, self.gsPriceWonLabel.frame.origin.y, priceWonLabelSize.width,  self.gsPriceWonLabel.frame.size.height);
            
            UILabel *label = self.gsPriceLabel;
            UIView *nextView = self.gsPriceWonLabel;
            float nextOffset = 0;
            //extLabel,discountRatePercentLabel(discountRate) 가 안보이면.. 가격을 앞으로 땡긴다.  prevOffset 기본값이 5라 11을 맞추기 위해 6을 적용
            UIView *prevView = (self.extLabel.hidden ? (self.discountRatePercentLabel.hidden ? [[UIView alloc] initWithFrame:CGRectMake(6, 0, 0, 0)] : self.discountRatePercentLabel) : self.extLabel);
            float prevOffset = 5;
            {
                CGSize size = [label sizeThatFits:label.frame.size];
                if (self.valuetextLabel.hidden == NO) {
                    label.frame = CGRectMake(valuetextLabel.frame.origin.x + valuetextLabel.frame.size.width + prevOffset,
                                             label.frame.origin.y,
                                             size.width,
                                             label.frame.size.height);
                }
                else {
                    if (prevView == self.discountRatePercentLabel) {
                        prevOffset = 6.0;
                    }
                    
                    if( [NCS([infoDic objectForKey:@"productType"])  isEqualToString:@"C"]) {
                        // 할인율 + GS가 노출 안함 로직 추가
                        
                        //가격정보가 가장왼쪽으로붙도록
                        self.discountRateLabel.hidden = YES;
                        self.discountRatePercentLabel.hidden = YES;
                        self.extLabel.hidden = YES;
                        
                        label.frame = CGRectMake(11,
                                                 label.frame.origin.y,
                                                 size.width,
                                                 label.frame.size.height);
                        
                    }
                    else {
                        label.frame = CGRectMake(prevView.frame.origin.x + prevView.frame.size.width + prevOffset,
                                                 label.frame.origin.y,
                                                 size.width,
                                                 label.frame.size.height);
                    }
                }
                
                nextView.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + nextOffset,
                                            nextView.frame.origin.y,
                                            nextView.frame.size.width,
                                            nextView.frame.size.height);
            }
            self.gsPriceLabel.hidden = NO;
            self.gsPriceWonLabel.hidden = NO;
            
            [strAccess appendString:[Common_Util commaStringFromDecimal:salePrice]];
            [strAccess appendString:NCS([infoDic objectForKey:@"exposePriceText"])];
            
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
    }
    
    //valueInfo
    if([NCS([infoDic objectForKey:@"valueInfo"])  length] > 0 ) {
        
        self.valueinfoLabel.hidden = NO;
        self.valueinfoLabel.text = NCS([infoDic objectForKey:@"valueInfo"]);
        if (self.gsPriceWonLabel.hidden == NO) {
            NSDictionary *fontWithAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            CGSize valueInfoLabelSize =  [self.valueinfoLabel.text  sizeWithAttributes:fontWithAttributes];
            self.valueinfoLabel.frame = CGRectMake(self.gsPriceWonLabel.frame.origin.x + self.gsPriceWonLabel.frame.size.width + 2.0, self.valueinfoLabel.frame.origin.y + 2.0, valueInfoLabelSize.width,  self.valueinfoLabel.frame.size.height);
        }
        [strAccess appendString:self.valueinfoLabel.text];
    }
    else {
        self.valueinfoLabel.text = @"";
        self.valueinfoLabel.hidden = YES;
    }
    
    // 원래 가격
    NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:[infoDic objectForKey:@"basePrice"]];
    int basePrice = [(NSNumber *)removeCommaorgstr intValue];
    if(basePrice > 0 && basePrice > salePrice) {
        self.originalPriceLabel.text = [Common_Util commaStringFromDecimal:basePrice];
        self.originalPriceWonLabel.text = NCS([infoDic objectForKey:@"exposePriceText"]);
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
        
        //2015/07/29 yunsang.jin 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
        if(NCO([infoDic objectForKey:@"discountRate"]) && [[infoDic objectForKey:@"discountRate"] intValue] < 1) {
            self.originalPriceLine.hidden = YES;
            self.originalPriceLabel.hidden = YES;
            self.originalPriceWonLabel.hidden = YES;
        }
        else {
            self.originalPriceLabel.hidden = NO;
            self.originalPriceWonLabel.hidden = NO;
            self.originalPriceLine.hidden = NO;
        }
    }
    else {
        self.originalPriceLabel.hidden = YES;
        self.originalPriceWonLabel.hidden = YES;
        self.originalPriceLine.hidden = YES;
    }
    
 
    
    if(NCO([infoDic objectForKey:@"saleQuantity"])) {
        NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([infoDic objectForKey:@"saleQuantity"])];
        //숫자가 맞음
        if([Common_Util isThisValidNumberStr:removeCommaorgstr]) {
            self.saleCountLabel.text = [NSString stringWithFormat:@"%@", NCS([infoDic objectForKey:@"saleQuantity"]) ];
            self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", NCS([infoDic objectForKey:@"saleQuantityText"]) ];
            self.saleSaleSubLabel.text = [NSString stringWithFormat:@"%@", NCS([infoDic objectForKey:@"saleQuantitySubText"]) ];
            [self.saleSaleSubLabel sizeToFit];
            [self.saleSaleLabel sizeToFit];
            [self.saleCountLabel sizeToFit];
            int e1padd= 3;
            //위치교정
            self.saleSaleSubLabel.frame =  CGRectMake( self.view_Default.frame.size.width- self.saleSaleSubLabel.frame.size.width -10, self.saleSaleSubLabel.frame.origin.y, self.saleSaleSubLabel.frame.size.width, self.saleSaleSubLabel.frame.size.height);
            if([[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"saleQuantitySubText"] ] isEqualToString:@""]) {
                e1padd = 0;
            }
            self.saleSaleLabel.frame =  CGRectMake(self.saleSaleSubLabel.frame.origin.x-self.saleSaleLabel.frame.size.width-e1padd, self.saleSaleLabel.frame.origin.y, self.saleSaleLabel.frame.size.width, self.saleSaleLabel.frame.size.height);
            self.saleCountLabel.frame =  CGRectMake(self.saleSaleLabel.frame.origin.x -  self.saleCountLabel.frame.size.width , self.saleSaleLabel.frame.origin.y, self.saleCountLabel.frame.size.width, self.saleCountLabel.frame.size.height);
            self.saleCountLabel.hidden = NO;
            self.saleSaleLabel.hidden = NO;
            self.saleSaleSubLabel.hidden = NO;
            if ([NCB([infoDic objectForKey:@"isTempOut"]) boolValue]) {
                self.saleCountLabel.hidden = YES;
                self.saleSaleLabel.hidden =YES;
                self.saleSaleSubLabel.hidden = YES;
            }
        }
        //숫자아니거나 0일때 수량text 존재함
        else if(  [NCS([infoDic objectForKey:@"saleQuantityText"]) length] > 0) {
            self.saleCountLabel.hidden = YES;
            self.saleSaleSubLabel.hidden = YES;
            self.saleSaleLabel.hidden = NO;
            //saleSaleLabel  확장시키자
            self.saleSaleLabel.frame = CGRectMake(self.view_Default.frame.size.width-180-10, self.saleSaleLabel.frame.origin.y, 180, 15);
            self.saleSaleLabel.text = [NSString stringWithFormat:@"%@", NCS([infoDic objectForKey:@"saleQuantityText"]) ];
        }
        else {
            //숫자가 아니거나 0인경우 사라짐
            self.saleCountLabel.hidden = YES;
            self.saleSaleLabel.hidden =YES;
            self.saleSaleSubLabel.hidden = YES;
        }
    }
    //////// 하단 혜택 딱지 노출 시작 ////////20170929
    //20180110 DSL_A2일때는 하단 해텍 딱지 노출안함. - 기존은 없어도 노출
    if(benefitview == nil && ![viewType isEqualToString:@"DSL_A2"]) {
        benefitview = [[[NSBundle mainBundle] loadNibNamed:@"BenefitTagView" owner:self options:nil] firstObject];
        [self.view_Default insertSubview:benefitview belowSubview:self.viewImageBottomLine]; //라인이 있어서 라인 뒤에 넣어야 한다.
        benefitview.frame = CGRectMake(0, self.viewLabels.frame.origin.y + self.viewLabels.frame.size.height , self.frame.size.width, BENEFITTAG_HEIGTH);
    }
    [benefitview setBenefitTag:infoDic];
    //////// 하단 혜택 딱지 노출 종료 ////////
    
    self.accessibilityLabel = strAccess;
}



@end
