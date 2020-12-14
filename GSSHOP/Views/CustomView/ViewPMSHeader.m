//
//  ViewPMSHeader.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 1. 13..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "ViewPMSHeader.h"
#import "AppPushMessageViewController.h"

@implementation ViewPMSHeader
@synthesize constImgArrowSizeWidth;
@synthesize constImgArrowLeading;
@synthesize constImgArrowBottom;

@synthesize lblTitleWithRanking;
@synthesize lblCustInfo;
@synthesize imgCenterArrow;
@synthesize lblCustExpire;
@synthesize imgGradeState;
@synthesize delegate;

-(void)awakeFromNib{
    [super awakeFromNib];
    
    

    dicRankColor = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"000000",@"무등급",
                    @"de7c3e",@"브론즈",
                    @"666666",@"실버",
                    @"f4b400",@"골드",
                    @"6d43b6",@"VIP",
                    @"2a1f19",@"VVIP",
                     nil];
    
    dicRankArrow = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"pms_center_arrow_norank.png",@"무등급",
                    @"pms_center_arrow_bronze.png",@"브론즈",
                    @"pms_center_arrow_silver.png",@"실버",
                    @"pms_center_arrow_gold.png",@"골드",
                    @"pms_center_arrow_vip.png",@"VIP",
                    @"pms_center_arrow_vvip.png",@"VVIP",
                    nil];
    
    CGFloat heightImageBG = (APPFULLWIDTH-30.0) * (133.0/290.0);
    
    self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH,132.0 + heightImageBG );
    
    self.constImgArrowSizeWidth.constant = (APPFULLWIDTH/320.0)*(45.0);
    self.constImgArrowLeading.constant = ((APPFULLWIDTH-30.0)/290.0)*110.0;
    self.constImgArrowBottom.constant =  -(heightImageBG*(32.0/133.0));

    self.lblTitleWithRanking.text = @"";
    self.lblCustInfo.text = @"";
    self.lblCustExpire.text = @"";
    
}

-(void)setCellInfo:(NSDictionary *)dicInfo{
    
    dicRow = dicInfo;
    
    if (dicRow == nil) {
        return;
    }
    
//    "custWelcome": "홍*길동님의 등급은 VIP입니다",
//    "custGrade": "VIP",
//    "orderText": "주문 3건",
//    "prdText": "상품평 1건",
//    "gradeText": "달성하면 승급",
//    "custExpire": "(다음달 25일까지)",
//    "gradeStateImage": "http://10.52.214.146:8080/grade_VIP.png",
//    "bottomText": "리얼멤버쉽 자세히 보기",
//    "linkUrl": "http://m.gsshop.com/mygsshop/myRealMembership.gs"
    
    
    //NSString *strCustIntfo =@"주문 3건\n상품평 1건\n달성하면 승급";
    
    NSInteger intLineNumber = 0;
    
    NSMutableString *strCustIntfo = [[NSMutableString alloc] initWithString:@""];
    
    if ([NCS([dicRow objectForKey:@"orderText"]) length] > 0) {
        [strCustIntfo appendString:[dicRow objectForKey:@"orderText"]];
        intLineNumber ++;
    }
    
    if ([NCS([dicRow objectForKey:@"prdText"]) length] > 0) {
        if ([strCustIntfo length] > 0) {
            [strCustIntfo appendString:@"\n"];
        }
        [strCustIntfo appendString:[dicRow objectForKey:@"prdText"]];
        intLineNumber ++;
    }
    
    
    if ([NCS([dicRow objectForKey:@"gradeText"]) length] > 0) {
        if ([strCustIntfo length] > 0) {
            [strCustIntfo appendString:@"\n"];
        }
        [strCustIntfo appendString:[dicRow objectForKey:@"gradeText"]];
        intLineNumber ++;
    }
    
    //NSString *strCustIntfo =@"주문 3건\n상품평 1건\n달성하면 승급";
    
    NSLog(@"strCustIntfo =%@",strCustIntfo);
    NSLog(@"intLineNumber =%d",(int)intLineNumber);
    
    self.lblCustInfo.numberOfLines = intLineNumber;
    self.lblCustInfo.text = strCustIntfo;
    
    
    [self.lblCustInfo sizeToFit];
    
    self.lblCustExpire.text = NCS([dicRow objectForKey:@"custExpire"]);
    
    NSString *strRank = NCS([dicRow objectForKey:@"custGrade"]);
    
    NSString *strRankColor = NCS([dicRankColor objectForKey:strRank]);
    NSString *strImageName = NCS([dicRankArrow objectForKey:strRank]);
    
    if ([NCS([dicRow objectForKey:@"gradeStateImage"]) length] > 0 && [[dicRow objectForKey:@"gradeStateImage"] hasPrefix:@"http"]) { //) {
        NSLog(@"[dicRow objectForKey:@gradeStateImage] = %@",[dicRow objectForKey:@"gradeStateImage"]);

        NSString *imageURL = NCS([dicRow objectForKey:@"gradeStateImage"]);
        
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                {
                    self.imgGradeState.image = fetchedImage;
                }
                else
                {
                    self.imgGradeState.alpha = 0;
                    self.imgGradeState.image = fetchedImage;
                    
                    
                    
                    
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         
                                         self.imgGradeState.alpha = 1;
                                         
                                     }
                                     completion:^(BOOL finished) {
                                         
                                     }];
                }
                });
                
            }
        }];

        
        
    }
    
    
    
    self.imgCenterArrow.image = [UIImage imageNamed:([strImageName length]>0)?strImageName:@"pms_center_arrow_bg.png"];
    
    
    if ([strRank length] > 0 && [strRankColor length] == 6) {
        
        @try {
            [self.lblTitleWithRanking setText:NCS([dicRow objectForKey:@"custWelcome"]) afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
                
                NSRegularExpression *regexp = [[NSRegularExpression alloc] initWithPattern:strRank options:NSRegularExpressionCaseInsensitive error:nil];
                
                if ([regexp numberOfMatchesInString:[mutableAttributedString string] options:0 range:stringRange] > 0) {
                    NSRange nameRange = [regexp rangeOfFirstMatchInString:[mutableAttributedString string] options:0 range:stringRange];
                    
                    NSLog(@"nameRange = %@",NSStringFromRange(nameRange));
                    
                    UIFont *highlightFont = [UIFont boldSystemFontOfSize:18.0];
                    
                    CTFontRef hihiFont = CTFontCreateWithName((__bridge CFStringRef)highlightFont.fontName, highlightFont.pointSize,  NULL);
                    if (hihiFont) {
                        [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:nameRange];
                        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)hihiFont range:nameRange];
                        
                        [mutableAttributedString addAttribute:(id)kCTForegroundColorAttributeName
                                                        value:(id)[Mocha_Util getColor:strRankColor].CGColor
                                                        range:nameRange];
                        
                        CFRelease(hihiFont);
                    }
                    
                    [mutableAttributedString replaceCharactersInRange:nameRange withString:[[[mutableAttributedString string] substringWithRange:nameRange] uppercaseString]];
                }
                
                
                
                
                
                return mutableAttributedString;
            }];
        }
        
        @catch (NSException *exception) {
            NSLog(@"exception = %@",exception);
        }
        @finally {
            
        }
        
        
    }else{
        [self.lblTitleWithRanking setText:NCS([dicRow objectForKey:@"custWelcome"])];
    }

}

-(IBAction)onBtnRealMemberShip:(id)sender{
    if ([self.delegate respondsToSelector:@selector(pressPersonalTableHeader:)]) {
        
        //NSString *strArgLink = [NSString stringWithFormat:@"gsshopmobile://home?%@",NCS([dicRow objectForKey:@"linkUrl"])];
        //NSLog(@"strArgLinkstrArgLink = %@",strArgLink);
        [self.delegate pressPersonalTableHeader:NCS([dicRow objectForKey:@"linkUrl"])];
    }
}

@end
