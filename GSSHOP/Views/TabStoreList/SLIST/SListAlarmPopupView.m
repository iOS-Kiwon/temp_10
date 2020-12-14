//
//  SListAlarmPopupView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 4. 20..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SListAlarmPopupView.h"
#import "SListTBViewController.h"

@implementation SListAlarmPopupView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    
    self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, APPFULLHEIGHT);

    self.viewRegister.layer.cornerRadius = 4.0;
    self.viewRegister.layer.shouldRasterize = YES;
    self.viewRegister.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.viewSuccessReuslt.layer.cornerRadius = 4.0;
    self.viewSuccessReuslt.layer.shouldRasterize = YES;
    self.viewSuccessReuslt.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.viewRegImageBorder.layer.borderWidth = 1.0;
    self.viewRegImageBorder.layer.shouldRasterize = YES;
    self.viewRegImageBorder.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegImageBorder.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    self.lblSucInfo.numberOfLines = 0;
    
    self.viewSucMyAlarmList.layer.borderWidth = 1.0;
    self.viewSucMyAlarmList.layer.shouldRasterize = YES;
    self.viewSucMyAlarmList.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewSucMyAlarmList.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;

}

-(void)setViewInfoNDrawData:(NSDictionary *)dicToSet alarmType:(NSString *)strType{
    self.alpha = 1.0;
    self.viewRegister.hidden = YES;
    self.viewSuccessReuslt.hidden = YES;
    self.viewAlarmCanceled.hidden = YES;
    
    self.btnRegCount01.selected = YES;
    self.btnRegPeriod01.selected = YES;
    
    self.viewRegPeriod01.layer.borderWidth = 1.0;
    self.viewRegPeriod01.layer.shouldRasterize = YES;
    self.viewRegPeriod01.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegPeriod01.layer.borderColor = [Mocha_Util getColor:@"A4DD00"].CGColor;
    
    self.viewRegPeriod02.layer.borderWidth = 1.0;
    self.viewRegPeriod02.layer.shouldRasterize = YES;
    self.viewRegPeriod02.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegPeriod02.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    self.viewRegPeriod03.layer.borderWidth = 1.0;
    self.viewRegPeriod03.layer.shouldRasterize = YES;
    self.viewRegPeriod03.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegPeriod03.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    self.viewRegCount01.layer.borderWidth = 1.0;
    self.viewRegCount01.layer.shouldRasterize = YES;
    self.viewRegCount01.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegCount01.layer.borderColor = [Mocha_Util getColor:@"A4DD00"].CGColor;
    
    self.viewRegCount02.layer.borderWidth = 1.0;
    self.viewRegCount02.layer.shouldRasterize = YES;
    self.viewRegCount02.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegCount02.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    self.viewRegCount03.layer.borderWidth = 1.0;
    self.viewRegCount03.layer.shouldRasterize = YES;
    self.viewRegCount03.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegCount03.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    NSLog(@"dicToSetdicToSetdicToSet = %@",dicToSet);
    
    dicAlarm = dicToSet;
    
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

    
    if ([strType isEqualToString:TVS_ALARMINFO]) {
        
        self.viewRegister.hidden = NO;

        [self.viewRegister.layer addAnimation:animation forKey:@"scaleAnimation"];
        
        self.lblRegProductTitle.text = NCS([dicToSet objectForKey:@"prdName"]);
        self.lblRegPhoneNumber.text = NCS([dicToSet objectForKey:@"phoneNo"]);
        self.imageURL = NCS([dicToSet objectForKey:@"imgUrl"]);
        
        [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [self.imageURL isEqualToString:strInputURL]){
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    

                    if (isInCache)
                    {
                        self.imgRegProduct.image = fetchedImage;
                    }
                    else
                    {
                        self.imgRegProduct.alpha = 0;
                        self.imgRegProduct.image = fetchedImage;
                    }
                    
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         
                                         self.imgRegProduct.alpha = 1;
                                         
                                     }
                                     completion:^(BOOL finished) {
                                         
                                         
                                     }];
                    
                });
                
            }
        }];

        
        NSArray *arrDesc = [dicToSet objectForKey:@"infoTextList"];
        CGFloat heightDescView = 15.0 + 6.0;
        
        CGFloat heightBase = 15.0;
        
        for (NSInteger i=0; i<[arrDesc count]; i++) {
            NSString *strText = NCS([arrDesc objectAtIndex:i]);
            
            UIImageView *imgGrayDot = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, heightBase + 6.0, 3.0, 3.0)];
            imgGrayDot.image = [UIImage imageNamed:@"slist_popup_ic_bu.png"];
            
            CGSize sizeText = [strText MochaSizeWithFont: [UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(266.0, 200.0) lineBreakMode:NSLineBreakByClipping];
            
            UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(24.0, heightBase, 266.0, sizeText.height)];
            lblDesc.font = [UIFont systemFontOfSize:12.0];
            lblDesc.textColor = [Mocha_Util getColor:@"999999"];
            lblDesc.text = strText;
            lblDesc.numberOfLines = 0;
            lblDesc.lineBreakMode = NSLineBreakByClipping;
            
            [self.viewDescArea addSubview:imgGrayDot];
            [self.viewDescArea addSubview:lblDesc];
            
            
            heightBase = heightBase + sizeText.height + 9.0;
            heightDescView = heightDescView + sizeText.height + 9.0;
        }
        
        
        self.lconstViewDescHeight.constant = heightDescView;
        self.lconstViewRegistHeight.constant = 302.0 + heightDescView;
        
        NSLog(@"self.lconstViewRegistHeight.constant = %f",self.lconstViewRegistHeight.constant);
        NSLog(@"self.lconstViewDescHeight.constant = %f",self.lconstViewDescHeight.constant);
        
        [self.viewRegister layoutIfNeeded];

    }else if ([strType isEqualToString:TVS_ALARMADD]) {
        
        self.viewSuccessReuslt.hidden = NO;

        self.lblSucPhoneNumber.text = NCS([dicToSet objectForKey:@"phoneNo"]);
        
        self.lblSucInfo.text = @"GS SHOP LIVE / GS MY SHOP 방송 30분 전,\n방송 예정시간을 알려드립니다.\n(PUSH/문자 중 한 가지로 안내)";
        self.lblSucBtnInfo.text = NCS([dicToSet objectForKey:@"linkUrlText"]);

        [self.viewSuccessReuslt.layer addAnimation:animation forKey:@"scaleAnimation"];
        
        [self.viewSuccessReuslt layoutIfNeeded];
        
        
    }else if ([strType isEqualToString:TVS_ALARMDELETE]) {
        
        self.viewAlarmCanceled.hidden = NO;
        
        [self.viewAlarmCanceled.layer addAnimation:animation forKey:@"scaleAnimation"];
        
        [self performSelector:@selector(fadeOutAlarmCancel) withObject:nil afterDelay:0.6];
    }
    
    
}

-(void)fadeOutAlarmCancel{
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         self.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         [self onBtnClose:nil];
                     }];

}

-(IBAction)onBtnPeriods:(id)sender{
    self.btnRegPeriod01.selected = NO;
    self.btnRegPeriod02.selected = NO;
    self.btnRegPeriod03.selected = NO;
   
    self.viewRegPeriod01.layer.borderWidth = 1.0;
    self.viewRegPeriod01.layer.shouldRasterize = YES;
    self.viewRegPeriod01.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegPeriod01.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    self.viewRegPeriod02.layer.borderWidth = 1.0;
    self.viewRegPeriod02.layer.shouldRasterize = YES;
    self.viewRegPeriod02.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegPeriod02.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    self.viewRegPeriod03.layer.borderWidth = 1.0;
    self.viewRegPeriod03.layer.shouldRasterize = YES;
    self.viewRegPeriod03.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegPeriod03.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    UIButton *btnSelected = (UIButton *)sender;
    btnSelected.selected = YES;
    
    UIView *viewBorder = nil;
    if (btnSelected == self.btnRegPeriod02) {
        viewBorder = self.viewRegPeriod02;
    }else if (btnSelected == self.btnRegPeriod03){
        viewBorder = self.viewRegPeriod03;
    }else{
        viewBorder = self.viewRegPeriod01;
    }
    
    viewBorder.layer.borderWidth = 1.0;
    viewBorder.layer.shouldRasterize = YES;
    viewBorder.layer.rasterizationScale = [UIScreen mainScreen].scale;
    viewBorder.layer.borderColor = [Mocha_Util getColor:@"A4DD00"].CGColor;
    
    
}

-(IBAction)onBtnCounts:(id)sender{
    
    self.btnRegCount01.selected = NO;
    self.btnRegCount02.selected = NO;
    self.btnRegCount03.selected = NO;
    
    self.viewRegCount01.layer.borderWidth = 1.0;
    self.viewRegCount01.layer.shouldRasterize = YES;
    self.viewRegCount01.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegCount01.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    self.viewRegCount02.layer.borderWidth = 1.0;
    self.viewRegCount02.layer.shouldRasterize = YES;
    self.viewRegCount02.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegCount02.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    self.viewRegCount03.layer.borderWidth = 1.0;
    self.viewRegCount03.layer.shouldRasterize = YES;
    self.viewRegCount03.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewRegCount03.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    
    
    UIButton *btnSelected = (UIButton *)sender;
    btnSelected.selected = YES;
    
    UIView *viewBorder = nil;
    if (btnSelected == self.btnRegCount02) {
        viewBorder = self.viewRegCount02;
    }else if (btnSelected == self.btnRegCount03){
        viewBorder = self.viewRegCount03;
    }else{
        viewBorder = self.viewRegCount01;
    }
    
    viewBorder.layer.borderWidth = 1.0;
    viewBorder.layer.shouldRasterize = YES;
    viewBorder.layer.rasterizationScale = [UIScreen mainScreen].scale;
    viewBorder.layer.borderColor = [Mocha_Util getColor:@"A4DD00"].CGColor;
}

-(IBAction)onBtnGoAlarmList:(id)sender{
    [self onBtnClose:nil];
    if ([self.delegate respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]) {
        [self.delegate touchEventTBCellJustLinkStr:NCS([dicAlarm objectForKey:@"linkUrl"])];
    }
}

-(IBAction)onBtnAlarmProcess:(id)sender{
    //[self setViewInfoNDrawData:nil alarmType:@"TYPE_REG_OK"];
    NSString *strPeriod = nil;
    NSString *strCount = nil;
    if (self.btnRegPeriod01.selected == YES) {
        strPeriod = @"1";
    }else if (self.btnRegPeriod02.selected == YES){
        strPeriod = @"2";
    }else if (self.btnRegPeriod03.selected == YES){
        strPeriod = @"3";
    }else{
        strPeriod = @"1";
    }
    

    
    if (self.btnRegCount01.selected == YES) {
        strCount = @"1";
    }else if (self.btnRegCount02.selected == YES){
        strCount = @"3";
    }else if (self.btnRegCount03.selected == YES){
        strCount = @"99";
    }else{
        strCount = @"1";
    }
    
    if([self.delegate respondsToSelector:@selector(requestAlarmWithDic:andProcess:andPeroid:andCount:)]){
        [self.delegate requestAlarmWithDic:dicAlarm andProcess:TVS_ALARMADD andPeroid:strPeriod andCount:strCount];
    }
}


-(IBAction)onBtnClose:(id)sender{
    [self removeFromSuperview];
}
@end
