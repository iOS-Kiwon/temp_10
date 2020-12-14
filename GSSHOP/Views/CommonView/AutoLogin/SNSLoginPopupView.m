//
//  SNSLoginPopupView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 3. 14..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SNSLoginPopupView.h"
#import "AutoLoginViewController.h"
#import "AppDelegate.h"

@implementation SNSLoginPopupView
@synthesize delegate;
@synthesize strNowSNS;

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, APPFULLHEIGHT);
    
    lblTopTitle.numberOfLines = 0;
    lblEmailType.numberOfLines = 0;
    lblTelType.numberOfLines = 0;
    lblOauthType01.numberOfLines = 0;
    lblOauthType02.numberOfLines = 0;
    lblOauthType03.numberOfLines = 0;
    
    
    imgTopConfirm.hidden = YES;
    lblTopTitle.hidden = YES;
    
    viewEmailType.hidden = YES;
    
    viewTelType.hidden = YES;
    viewBtnTel.hidden = YES;
    
    viewOauthType.hidden = YES;
    btnLeft.hidden = YES;
    btnRight.hidden = YES;
    viewButtons.hidden = YES;
    
    btnLeft.layer.borderWidth = 1.0;
    btnLeft.layer.cornerRadius = 2.0;
    btnLeft.layer.shouldRasterize = YES;
    btnLeft.layer.rasterizationScale = [UIScreen mainScreen].scale;
    btnLeft.layer.borderColor = [Mocha_Util getColor:@"C9C9C9"].CGColor;
    
    btnRight.layer.borderWidth = 1.0;
    btnRight.layer.cornerRadius = 2.0;
    btnRight.layer.shouldRasterize = YES;
    btnRight.layer.rasterizationScale = [UIScreen mainScreen].scale;
    btnRight.layer.borderColor = [Mocha_Util getColor:@"B4CC2E"].CGColor;
    
    viewBtnTel.layer.borderWidth = 1.0;
    viewBtnTel.layer.cornerRadius = 2.0;
    viewBtnTel.layer.shouldRasterize = YES;
    viewBtnTel.layer.rasterizationScale = [UIScreen mainScreen].scale;
    viewBtnTel.layer.borderColor = [Mocha_Util getColor:@"C9C9C9"].CGColor;
    
    
    viewPopupContents.layer.cornerRadius = 2.0;
    viewPopupContents.layer.shouldRasterize = YES;
    viewPopupContents.layer.rasterizationScale = [UIScreen mainScreen].scale;

    
    // 팝업 애니메이션
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = 0.2;
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.2],
                        [NSNumber numberWithFloat:0.6],
                        [NSNumber numberWithFloat:1.0],
                        nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:0.5],
                          [NSNumber numberWithFloat:1.0],
                          nil];
    
    [viewPopupContents.layer addAnimation:animation forKey:@"scaleAnimation"];
    
}

-(void)dealloc{
    NSLog(@"");
}

-(void)setViewInfoNDrawData:(NSDictionary*)dicToSet{
    dicViewInfo = dicToSet;
    
    NSLog(@"dicViewInfodicViewInfo = %@",dicViewInfo);
    
    
    
//    lconstPopupViewHeight;
//    lconstTopTitleLabelHeight;
//    lconstEmailLabelHeight;
//    lconstTelLabelHeight;
//    lconstMappingLabel01Height;
//    lconstMappingLabel02Height;
//    lconstMappingLabel03Height;
//    lconstMappingViewHeight;
    
    if ([NCS([dicViewInfo objectForKey:@"type"]) length] > 0) {
        
        if ([[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_EQUAL"] || [[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_MAPPING"]) {
            //이메일이 들어가는 타입 , SNS이메일과 동일한 이메일이 있거나 매핑이력이 있는경우
            
            imgTopConfirm.hidden = NO;
            lblTopTitle.hidden = NO;
            viewEmailType.hidden = NO;
            viewButtons.hidden = NO;
            btnLeft.hidden = NO;
            btnRight.hidden = NO;
            
            
            CGSize sizeTitle = [NCS([dicViewInfo objectForKey:@"title"]) MochaSizeWithFont:lblTopTitle.font constrainedToSize:CGSizeMake(viewPopupContents.frame.size.width - 40.0, 300.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            lblTopTitle.text = [dicViewInfo objectForKey:@"title"];
            
            lconstTopTitleLabelHeight.constant = sizeTitle.height + 3.0;
            
            NSLog(@"lconstTopTitleLabelHeight.constant = %f",lconstTopTitleLabelHeight.constant);
            
            NSMutableString *strEmailText = [[NSMutableString alloc] initWithString:@""];
           
            if ([NCS([dicViewInfo objectForKey:@"msgTop"]) length] > 0) {
                [strEmailText appendString:NCS([dicViewInfo objectForKey:@"msgTop"])];
                [strEmailText appendString:@"\n"];
            }
            
            [strEmailText appendString:NCS([dicViewInfo objectForKey:@"email"])];
            
            if ([NCS([dicViewInfo objectForKey:@"msgBottom"]) length] > 0) {
                [strEmailText appendString:@"\n"];
                [strEmailText appendString:NCS([dicViewInfo objectForKey:@"msgBottom"])];
            }
            
            
            CGSize sizeEmailLabel = [strEmailText MochaSizeWithFont:lblEmailType.font constrainedToSize:CGSizeMake(viewPopupContents.frame.size.width - 40.0, 300.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            lconstEmailLabelHeight.constant = sizeEmailLabel.height + 3;
            
            if ([NCS([dicViewInfo objectForKey:@"email"]) length] > 0) {
                NSString *strEmail = [dicViewInfo objectForKey:@"email"];
                @try {
                    
                    [lblEmailType setText:strEmailText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                        
                        
                        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
                        NSRegularExpression *regexp = [[NSRegularExpression alloc] initWithPattern:strEmail options:NSRegularExpressionCaseInsensitive error:nil];
                        NSRange emailRange = [regexp rangeOfFirstMatchInString:[mutableAttributedString string] options:0 range:stringRange];
                        [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:emailRange];
                        [mutableAttributedString addAttribute:(id)kCTForegroundColorAttributeName
                                                        value:(id)[Mocha_Util getColor:@"111111"].CGColor
                                                        range:emailRange];
                        
                        return mutableAttributedString;
                    }];
                }
                
                @catch (NSException *exception) {
                    NSLog(@"exception = %@",exception);
                }
                @finally {
                    
                }
                
            }else{
                lblEmailType.text = strEmailText;
            }
            
            [btnLeft setTitle:@"비밀번호 찾기" forState:UIControlStateNormal];
            [btnRight setTitle:@"로그인" forState:UIControlStateNormal];
            
            NSLog(@"lblEmailType.text = %@",lblEmailType.text);
            
            lconstPopupViewHeight.constant = 49.0 + lconstTopTitleLabelHeight.constant + 13.0 + lconstEmailLabelHeight.constant + 13.0 + 60.0 + 45.0;
            
            [viewEmailType layoutIfNeeded];
            
            
        }else if([[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_TEL"]){
            //탈퇴이력이 있어서 전화연결해야하는 타입
        
            viewTelType.hidden = NO;
            viewBtnTel.hidden = NO;
            viewButtons.hidden = NO;
            
            
            CGSize sizeTitle = [NCS([dicViewInfo objectForKey:@"msgTop"]) MochaSizeWithFont:lblTelType.font constrainedToSize:CGSizeMake(viewPopupContents.frame.size.width - 40.0, 300.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            lblTelType.text = [dicViewInfo objectForKey:@"msgTop"];
            
            lconstTelLabelHeight.constant = sizeTitle.height + 3.0;
            
            lblTelTypeButtonTitle.text = @"문의 1899-4500";
            
            lconstPopupViewHeight.constant = 25.0 + lconstTelLabelHeight.constant + 17.0 + 60.0 + 45.0;
            
            
            [viewTelType layoutIfNeeded];
            
        }else if([[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_OAUTH"]){
            //SNS 인증완료
            
            
            imgTopConfirm.hidden = NO;
            lblTopTitle.hidden = NO;
            viewOauthType.hidden = NO;
            viewButtons.hidden = NO;
            btnLeft.hidden = NO;
            btnRight.hidden = NO;
            
            
            CGSize sizeTitle = [NCS([dicViewInfo objectForKey:@"title"]) MochaSizeWithFont:lblTopTitle.font constrainedToSize:CGSizeMake(viewPopupContents.frame.size.width - 40.0, 300.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            lblTopTitle.text = [dicViewInfo objectForKey:@"title"];
            
            lconstTopTitleLabelHeight.constant = sizeTitle.height + 3.0;
            
            
            CGSize sizeOauth01 = [NCS([dicViewInfo objectForKey:@"msgTop"]) MochaSizeWithFont:lblOauthType01.font constrainedToSize:CGSizeMake(viewPopupContents.frame.size.width - 40.0, 300.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            lblOauthType01.text = [dicViewInfo objectForKey:@"msgTop"];
            
            lconstOauthLabel01Height.constant = sizeOauth01.height + 3.0;
            
            CGSize sizeOauth02 = [NCS([dicViewInfo objectForKey:@"msgBottom"]) MochaSizeWithFont:lblOauthType02.font constrainedToSize:CGSizeMake(viewPopupContents.frame.size.width - 20.0, 300.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            lblOauthType02.text = [dicViewInfo objectForKey:@"msgBottom"];
            
            lconstOauthLabel02Height.constant = sizeOauth02.height + 3.0;
            
            NSLog(@"lconstOauthLabel02Height.constant = %f",lconstOauthLabel02Height.constant);
            
            CGSize sizeOauth03 = [NCS([dicViewInfo objectForKey:@"groundMsg"]) MochaSizeWithFont:lblOauthType03.font constrainedToSize:CGSizeMake(viewPopupContents.frame.size.width - 40.0, 300.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            lblOauthType03.text = [dicViewInfo objectForKey:@"groundMsg"];
            
            lconstOauthLabel03Height.constant = sizeOauth03.height + 3.0;
            
            lconstOauthViewHeight.constant = lconstOauthLabel01Height.constant + 12.0 + lconstOauthLabel02Height.constant + 12.0 + 12.0 + lconstOauthLabel03Height.constant + 17.0;
            
            [btnLeft setTitle:@"로그인" forState:UIControlStateNormal];
            [btnRight setTitle:@"회원가입" forState:UIControlStateNormal];
            
            lconstPopupViewHeight.constant = 49.0 + lconstTopTitleLabelHeight.constant + 17.0 + lconstOauthViewHeight.constant + 60.0 + 45.0;
            
            [viewOauthType layoutIfNeeded];
            
        }else{
            //타입 미 정의시 닫기 버튼만 노출
            viewTelType.hidden = NO;
            
            CGSize sizeTitle = [NCS([dicViewInfo objectForKey:@"msgTop"]) MochaSizeWithFont:lblTelType.font constrainedToSize:CGSizeMake(viewPopupContents.frame.size.width - 40.0, 300.0) lineBreakMode:NSLineBreakByWordWrapping];
            
            lblTelType.text = [dicViewInfo objectForKey:@"msgTop"];
            
            lconstTelLabelHeight.constant = sizeTitle.height + 3.0;
            
            lconstPopupViewHeight.constant = 25.0 + lconstTelLabelHeight.constant + 17.0 + 45.0;
            
        }
        
    }else{
        //타입 미 정의시 닫기 버튼만 노출
        lconstPopupViewHeight.constant = 45.0;
    }

}

-(IBAction)onBtnClose:(id)sender{
    
    
    if ([[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_OAUTH"] || [[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_EQUAL"] || [[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_MAPPING"]){

        if ([delegate respondsToSelector:@selector(setAuthType:)]) {
            [delegate setAuthType:@"TYPE_MAPPING"];
        }
        
    }else{
        
        if ([delegate respondsToSelector:@selector(setAuthClean)]) {
            [delegate setAuthClean];
        }
        
    }
    
    [self removeFromSuperview];
    
}

-(IBAction)onBtnAction:(id)sender{
    if (sender == btnLeft) {
        NSLog(@"btnLeftbtnLeftbtnLeft");
        
        if ([[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_OAUTH"]) {
            [self closeWithAuthType:@"TYPE_MAPPING"];
        }else if ([[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_EQUAL"] || [[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_MAPPING"]){
            
            if ([NCS([dicViewInfo objectForKey:@"searchUrl"]) length] > 0 && [NCS([dicViewInfo objectForKey:@"searchUrl"]) hasPrefix:@"http"]) {
                [self closeWithUrlMove:[dicViewInfo objectForKey:@"searchUrl"]];
            }
        }
        
    }else if (sender == btnRight) {
        NSLog(@"btnRightbtnRightbtnRight");
        
        if ([[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_OAUTH"]) {
            
            
            if ([NCS([dicViewInfo objectForKey:@"searchUrl"]) length] > 0 && [NCS([dicViewInfo objectForKey:@"searchUrl"]) hasPrefix:@"http"]) {
                [self closeWithUrlMove:[dicViewInfo objectForKey:@"joinUrl"]];
            }
            
        }else if ([[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_EQUAL"] || [[dicViewInfo objectForKey:@"type"] isEqualToString:@"TYPE_MAPPING"]){
            
            [self closeWithAuthType:@"TYPE_MAPPING"];
        }
        
        
    }else if (sender == btnTel) {
        NSLog(@"btnTelbtnTelbtnTel");
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:MEMBERCENTER_TEL]];
        
    }
}

- (void)closeWithAuthType:(NSString *)strType{
    
    if ([strNowSNS isEqualToString:@"NA"]) {
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=413068")];
    }else if ([strNowSNS isEqualToString:@"KA"]) {
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=413070")];
    }
    
    if ([delegate respondsToSelector:@selector(setAuthType:)]) {
        [delegate setAuthType:strType];
    }
    
    [self removeFromSuperview];
    
    
}

- (void)closeWithUrlMove:(NSString *)strUrl{
    
    if ([delegate respondsToSelector:@selector(snsAccessUrlMove:)]) {
        [delegate snsAccessUrlMove:strUrl];
    }
    
    [self removeFromSuperview];
    
    
}

@end
