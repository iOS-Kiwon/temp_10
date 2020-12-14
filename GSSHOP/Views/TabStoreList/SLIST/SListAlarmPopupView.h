//
//  SListAlarmPopupView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 4. 20..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SListAlarmPopupView : UIView {
    NSDictionary *dicAlarm;
}

@property (nonatomic,weak) id delegate;
@property (nonatomic,strong) IBOutlet UIView *viewRegister;
@property (nonatomic,strong) IBOutlet UIView *viewSuccessReuslt;
@property (nonatomic,strong) IBOutlet UIView *viewAlarmCanceled;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *lconstViewRegistHeight;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *lconstViewDescHeight;

@property (nonatomic,strong) NSString *imageURL;
@property (nonatomic,strong) IBOutlet UIView *viewRegImageBorder;
@property (nonatomic,strong) IBOutlet UIImageView *imgRegProduct;
@property (nonatomic,strong) IBOutlet UILabel *lblRegProductTitle;
@property (nonatomic,strong) IBOutlet UIView *viewRegPhoneBackGround;
@property (nonatomic,strong) IBOutlet UILabel *lblRegPhoneNumber;
@property (nonatomic,strong) IBOutlet UIView *viewRegPeriod01;
@property (nonatomic,strong) IBOutlet UIButton *btnRegPeriod01;
@property (nonatomic,strong) IBOutlet UIView *viewRegPeriod02;
@property (nonatomic,strong) IBOutlet UIButton *btnRegPeriod02;
@property (nonatomic,strong) IBOutlet UIView *viewRegPeriod03;
@property (nonatomic,strong) IBOutlet UIButton *btnRegPeriod03;
@property (nonatomic,strong) IBOutlet UIView *viewRegCount01;
@property (nonatomic,strong) IBOutlet UIButton *btnRegCount01;
@property (nonatomic,strong) IBOutlet UIView *viewRegCount02;
@property (nonatomic,strong) IBOutlet UIButton *btnRegCount02;
@property (nonatomic,strong) IBOutlet UIView *viewRegCount03;
@property (nonatomic,strong) IBOutlet UIButton *btnRegCount03;
@property (nonatomic,strong) IBOutlet UIView *viewDescArea;
@property (nonatomic,strong) IBOutlet UIButton *btnRegProcess;

@property (nonatomic,strong) IBOutlet UILabel *lblSucPhoneNumber;
@property (nonatomic,strong) IBOutlet UILabel *lblSucInfo;
@property (nonatomic,strong) IBOutlet UILabel *lblSucBtnInfo;
@property (nonatomic,strong) IBOutlet UIView *viewSucMyAlarmList;
@property (nonatomic,strong) IBOutlet UIButton *btnSucMyAlarmList;

-(void)setViewInfoNDrawData:(NSDictionary *)dicToSet alarmType:(NSString *)strType;
-(IBAction)onBtnClose:(id)sender;

@end
