//
//  PromotionView.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 6. 20..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "PromotionView.h"
#import "Home_Main_ViewController.h"


@implementation PromotionView


@synthesize target;


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [btn2 setTitle:GSSLocalizedString(@"promotionview_label_nottoday") forState:UIControlStateNormal];
    [btn3 setTitle:GSSLocalizedString(@"common_txt_alert_btn_close") forState:UIControlStateNormal];
}

-(void)setPromotionInfoData:(NSDictionary *)dic andTarget:(id)sender andImageData:(NSData *)dataImage{
    
    target = sender;
    promoDic = dic;

    // nami0342 - 오늘 한 번 띄웠으면 오늘은 본 것으로 처리해서 동시에 안 뜨게 한다.
    ApplicationDelegate.isPromotionPopup = YES;
    
    
    promoimg.backgroundColor = [UIColor clearColor];
    promoimg.image =  [UIImage imageWithData:dataImage];

    //MEDIUM banner타입이라면
    if([NCS([promoDic objectForKey:@"bannertype"]) isEqualToString:@"M"] || [NCS([promoDic objectForKey:@"bannertype"]) isEqualToString:@"P"] ){
        
        btn1.backgroundColor = [UIColor clearColor];
        btn1.frame = CGRectMake(0, 0, 300, 255);
        
        
        promoimg.frame = CGRectMake(0, 0, 300, 255);
        imgscrollview.frame = CGRectMake(0, 0, 300, 255);
        imgscrollview.contentSize = CGSizeMake (300, 255);
        imgscrollview.bounces = NO;
        btn2.frame = CGRectMake(0, 256, 150, 45);
        btn3.frame = CGRectMake(150, 256, 150, 45);
        hline1.frame =CGRectMake(0, 255, 300, 1);
        hline2.frame = CGRectMake(149, 256, 1, 45);
        
        if ([NCS([promoDic objectForKey:@"bannertype"]) isEqualToString:@"P"]) {
            btn1.hidden = YES;
            [btn2 setTitle:@"일주일간 보지않기" forState:UIControlStateNormal];
            [btn3 setTitle:@"좋아요" forState:UIControlStateNormal];
            
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=415588")];
        }
        
    }
    //small type 배너
    else if([NCS([promoDic objectForKey:@"bannertype"]) isEqualToString:@"S"]  ){
    
        
        promoimg.frame = CGRectMake(0, 0, 300, 135);
        imgscrollview.frame = CGRectMake(0, 0, 300, 135);
        imgscrollview.contentSize = CGSizeMake (300, 135);
        imgscrollview.bounces = NO;
        btn2.frame = CGRectMake(0, 135, 150, 45);
        btn3.frame = CGRectMake(150, 135, 150, 45);
        hline1.frame =CGRectMake(0, 134, 300, 1);
        hline2.frame = CGRectMake(149, 135, 1, 45);
        
    }
    
    else {
        
        
        
        if ([NCS([promoDic objectForKey:PERSONALPOPUP_KEY_DSPLSEQ]) length] > 0) {
            
            btn1.backgroundColor = [UIColor clearColor];
            btn1.frame = CGRectMake(0, 0, 300, 255);
            
            
            promoimg.frame = CGRectMake(0, 0, 300, 255);
            imgscrollview.frame = CGRectMake(0, 0, 300, 255);
            imgscrollview.contentSize = CGSizeMake (300, 255);
            imgscrollview.bounces = NO;
            btn2.frame = CGRectMake(0, 256, 150, 45);
            btn3.frame = CGRectMake(150, 256, 150, 45);
            hline1.frame =CGRectMake(0, 255, 300, 1);
            hline2.frame = CGRectMake(149, 256, 1, 45);
            
            [btn2 setTitle:@"다시보지않기" forState:UIControlStateNormal];
            [btn3 setTitle:@"닫기" forState:UIControlStateNormal];
            
        }else{
        
            promoimg.frame = CGRectMake(0, 0, 300, 135);
            imgscrollview.frame = CGRectMake(0, 0, 300, 135);
            imgscrollview.contentSize = CGSizeMake (300, 135);
            imgscrollview.bounces = NO;
            btn2.frame = CGRectMake(0, 135, 150, 45);
            btn3.frame = CGRectMake(150, 135, 150, 45);
            hline1.frame =CGRectMake(0, 134, 300, 1);
            hline2.frame = CGRectMake(149, 135, 1, 45);
        }
    }
    
#ifdef SM14
    // nami0342 - Accessability TEST !!!!!
//    promoimg.accessibilityLabel = @"프로모션 팝업";
//    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, promoimg);
#endif
}


-(IBAction)clickBtn:(id)sender {

    if ([NCS([promoDic objectForKey:PERSONALPOPUP_KEY_DSPLSEQ]) length] > 0) {
        
        if([((UIButton *)sender) tag] == 1){
            // 링크 클릭
            [target performSelector:@selector(ClickPersonalPopupBtn:) withObject:[NSNumber numberWithInt:1]];
        }else if([((UIButton *)sender) tag] == 2){
            // 취소
            [target performSelector:@selector(ClickPersonalPopupBtn:) withObject:[NSNumber numberWithInt:2]];
        }else if([((UIButton *)sender) tag] == 3){
            // 확인
            [target performSelector:@selector(ClickPersonalPopupBtn:) withObject:[NSNumber numberWithInt:3]];
        }
        
    }else{
        
        
        //2018.02.01 푸시수신동의 유도 프로모션 팝업
        if ([NCS([promoDic objectForKey:@"bannertype"]) isEqualToString:@"P"]) {
            
            if([((UIButton *)sender) tag] == 2){
                // 취소
                [target performSelector:@selector(ClickPushAgreePopupBtn:) withObject:[NSNumber numberWithInt:2]];
            }else if([((UIButton *)sender) tag] == 3){
                // 확인
                [target performSelector:@selector(ClickPushAgreePopupBtn:) withObject:[NSNumber numberWithInt:3]];
            }
            
        }else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            if([((UIButton *)sender) tag] == 1){
                
                // 링크 클릭
                [target performSelector:@selector(ClickPromotionPopupBtn:) withObject:[NSNumber numberWithInt:1]];
                
                
                
            }else if([((UIButton *)sender) tag] == 2){
                // 오늘 다시 보지 않기 선택
                [defaults setObject:[Mocha_Util  getCurrentDate:NO] forKey:PROMOTIONPOPUPDATE];
                [defaults synchronize];
                
                [target performSelector:@selector(ClickPromotionPopupBtn:) withObject:[NSNumber numberWithInt:2]];
                
                
            }else if([((UIButton *)sender) tag] == 3){
                
                [defaults setObject:@"" forKey:PROMOTIONPOPUPDATE];
                [defaults synchronize];
                
                // X 버튼 클릭
                
                [target performSelector:@selector(ClickPromotionPopupBtn:) withObject:[NSNumber numberWithInt:3]];
                
                
            }
        }
        
    }
}

@end
