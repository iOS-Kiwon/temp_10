//
//  SplashViewController.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 21..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"
#import "Common_Util.h"

@implementation SplashViewController {
    
    NSMutableArray *views;
    
}

@synthesize   _activityIndicator;

@synthesize timer;



//GA 추적
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
    [ApplicationDelegate GTMscreenOpenSendLog:@"iOS - Intro"];
}



-(void)checkSplashImage{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicSplash = [userDefaults valueForKey:DIC_SPLASH];
    BOOL isShowDefault = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];

    
    
    double now = [[formatter stringFromDate:[NSDate date]] doubleValue];
    
    double dStartdate = 0;
    double dEnddate = 0;
    if (dicSplash != nil)
    {
        dStartdate = [[dicSplash objectForKey:@"startDate"] doubleValue];
        dEnddate = [[dicSplash objectForKey:@"endDate"] doubleValue];
    }
    //20160222180400
    //20160224162903
    
    if (dStartdate <= now && dEnddate >= now) {
        

        NSLog(@"dicSplash = %@",dicSplash);
        NSLog(@"[NSDate date]  %f",now);
        NSLog(@"startDate  %f",[[dicSplash objectForKey:@"startDate"] doubleValue]);
        NSLog(@"endDate  %f",[[dicSplash objectForKey:@"endDate"] doubleValue]);
        
        
        isShowDefault = NO;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = NCA(paths)?[paths objectAtIndex:0]:@"";

        UIImage *imgSplash =[UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",documentsDirectory,[dicSplash objectForKey:@"imageName"]]]];
        
        NSLog(@"imgSplash = %@",imgSplash);
        
        splashImageView = [[UIImageView alloc] initWithImage:imgSplash];
        
        splashImageView.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
        
        
        NSLog(@"splashImageView = %@",splashImageView);
        
    }
    //기간 만료
    else {
        //기간 만료되면  등급 별 텍스트 문구 정보를 지운다.
        //SL(nil,DIC_SPLASH_TXT);
        
        NSUserDefaults *spl = [NSUserDefaults standardUserDefaults];
        @synchronized (spl) {
            [spl removeObjectForKey:DIC_SPLASH_TXT];
            [spl synchronize];
        }
    }
    
    
    if (isShowDefault) {
        
        splashImageView = [[UIImageView alloc] initWithImage:[self getCurrentLaunchImage]];
        splashImageView.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
        
    }
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    // Init the view
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:appFrame];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.view = view;
    
    [self checkSplashImage];
    [self.view addSubview:splashImageView];
    [self.view setBackgroundColor:[UIColor clearColor]];
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(finishedFading) userInfo:nil repeats:NO];
    
    if(ApplicationDelegate.spviewController != nil) {
        //자동로그인 여부 확인
        [[DataManager sharedManager]GetLoginData];
        LoginData *obj = [DataManager sharedManager].m_loginData;
        if( [obj isKindOfClass:[LoginData class]] && (obj.autologin == 0 || [obj.loginid length] <= 0 || [obj.authtoken length] <= 0) ) {
            [ApplicationDelegate.spviewController showUserInfo:nil grade:@"ETC"];
        }
        
#if SM14 && !APPSTORE
        UILabel *mode = [[UILabel alloc] initWithFrame: CGRectMake(10, APPFULLHEIGHT-10, APPFULLWIDTH-20, 10)];
        mode.text = [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"TM14"] ? @"T" : [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"M"] ? @"M" : @"S";
        NSString *ver = [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_VERSION_CODE] length] > 0 ? [[NSUserDefaults standardUserDefaults] objectForKey:DEV_VERSION_CODE] : APP_NAVI_VERSION;
        mode.text = [NSString stringWithFormat:@"%@ %@",mode.text,ver];
        mode.numberOfLines = 1;
        mode.backgroundColor = UIColor.clearColor;
        mode.textColor = UIColor.grayColor;
        mode.font = [UIFont boldSystemFontOfSize:8];
        mode.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:mode];
#endif
        
    }
    
//    //201610 narava 프로모션 팝업을 비동기로 진행 시킨다
//    //탭바제거
//    Home_Main_ViewController * HVC =  (Home_Main_ViewController *)[[ApplicationDelegate.mainNVC viewControllers] objectAtIndex:0];
//    [HVC showPromotionPopup_async];
}

- (void) finishedFading {
    
    [UIView beginAnimations:nil context:nil]; // begins animation block
    [UIView setAnimationDuration:0.5f];        // sets animation duration
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedLoading)];
    self.view.alpha = 0.0;   // fades the view to 1.0 alpha over 0.75 seconds
    [UIView commitAnimations];   // commits the animation block.  This Block is done.

}

- (void) finishedLoading {
    
    ApplicationDelegate.appfirstLoading = NO;
    
    [self.view removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_FINISH_SPLASHVIEW" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


// 비로그인 grade값은 ETC이고 모든 경우 예외값으로 BASIC을 노출한다.
- (void)showUserInfo:(NSString *)name grade:(NSString *) vip {
    
    NSString *grade = vip.uppercaseString;
    NSString *nameText = @"";
    NSString *endText = @"";
    NSString *fontcolor = @"000000";
    
    //먼저 떠있는 뷰가 있다면 제거 한다.
    [[self.view viewWithTag:200] removeFromSuperview];
    [[self.view viewWithTag:201] removeFromSuperview];
   
    NSDictionary *infoDic;
    @try {
        //비로그인 = name = nil, vip = ETC
        //infoDic = LL(DIC_SPLASH_TXT);
        
        NSUserDefaults *spl = [NSUserDefaults standardUserDefaults];
        
        @synchronized (spl) {
            infoDic = [spl valueForKey:DIC_SPLASH_TXT];
        }
        
        if(!(NCO(infoDic) && [infoDic count] > 0)) {
            return;
        }
    } @catch (NSException *exception) {
        [exception setValue:@"showUserInfo cresh!!" forKey:@"dev Message"];
        [ApplicationDelegate SendExceptionLog:exception];
    } @finally {
        
    }
    
   
    
    
    //좌측마진
    CGFloat leftMargin = 32.0;
    //상단 디자인
    UIView *indicateBar = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, STATUSBAR_HEIGHT + 8.0, 20.0, 4.0)];
    indicateBar.backgroundColor = [Mocha_Util getColor:@"BED730"];
    indicateBar.layer.cornerRadius = 2.0;
    indicateBar.tag = 200;
    [self.view addSubview:indicateBar];

    
    UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, STATUSBAR_HEIGHT + 8.0 + 10.0, APPFULLWIDTH - (leftMargin*2), 100)];
    mainview.backgroundColor = UIColor.clearColor;
    UILabel *nameLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainview.frame.size.width, mainview.frame.size.height)]; //[[UILabel alloc] init];
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    nameLabel.numberOfLines = 2;
       
  
    
    /*
     **1. 사용자가 VVIP일 경우 (VIP, GOLD 등급 표시 제외 하고 동일)**
     
     VVIP 홍길동 고객님
     올 한해도 GS SHOP과 함께 행복한 시간 되세요
     
     **2. VVIP, VIP, GOLD 외 사용자 로그인 시**
     
     홍길동 고객님
     올 한해도 GS SHOP과 함께 행복한 시간 되세요
     
     **3. 비로그인 사용자**
     BASIC의 subTitle만 본다.
     
     
     혹 해당하는 등급의 mainTitle 내용이 비어있을 경우에는 @"고객님"
     subTitle의 내용이 비어있을 경우에는 "방문해 주셔서 감사합니다."
    
     */
    
    NSDictionary *basicDic = [infoDic objectForKey:@"BASIC"];
    NSDictionary *gradeDic = [infoDic objectForKey:grade];
    
    if(name == nil && [grade isEqualToString:@"ETC"]) { //비로그인
        grade = @"";
        nameText = @"";
        fontcolor = [basicDic objectForKey:@"fontColor"];
        endText = [self dicGetValue:@"subTitle" grade:basicDic hardCodeMsg:@"방문해 주셔서 감사합니다."];
    }
    else {
        //로그인 사용자
        if(NCO(gradeDic) ) { // 등급값이 있다.
            fontcolor = [gradeDic objectForKey:@"fontColor"];
            nameText = [NSString stringWithFormat:@"%@ %@ \n", name, [self dicGetValue:@"mainTitle" grade:gradeDic hardCodeMsg:@"고객님"] ];
            endText = [self dicGetValue:@"subTitle" grade:gradeDic hardCodeMsg:@"방문해 주셔서 감사합니다."];
        }
        else { //등급외 사용자
            grade = @"";
            fontcolor = [basicDic objectForKey:@"fontColor"];
            nameText = [NSString stringWithFormat:@"%@ %@ \n", name, [self dicGetValue:@"mainTitle" grade:basicDic hardCodeMsg:@"고객님"] ];
            endText = [self dicGetValue:@"subTitle" grade:basicDic hardCodeMsg:@"방문해 주셔서 감사합니다."];
        }
    
    }
    
    
    
    NSDictionary *gradeTextAttr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:28],
                                    NSForegroundColorAttributeName : [Mocha_Util getColor:fontcolor]
                                    };
    NSDictionary *nameTextAttr = @{NSFontAttributeName :
                                       [UIFont boldSystemFontOfSize:18],
                                   NSForegroundColorAttributeName : [Mocha_Util getColor:fontcolor]
                                   };
    NSDictionary *welcomTextAttr = @{NSFontAttributeName :
                                         [UIFont boldSystemFontOfSize:16],
                                     NSForegroundColorAttributeName : [Mocha_Util getColor:fontcolor]
                                     };
    
    
    
    if([NCS(grade) length] > 0 ) {
        grade = [NSString stringWithFormat:@"%@ ", grade]; //뒤에 스페이스 추가
    }
    NSMutableAttributedString *attrGrade = [[NSMutableAttributedString alloc]initWithString:grade attributes:gradeTextAttr];
    NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc]initWithString:nameText attributes:nameTextAttr];
    NSMutableAttributedString *attrEnd = [[NSMutableAttributedString alloc]initWithString:endText attributes:welcomTextAttr];

    [attrGrade appendAttributedString:attrName];
    [attrGrade appendAttributedString:attrEnd];
    
    nameLabel.attributedText = attrGrade;
    [nameLabel sizeToFit];
    [mainview addSubview:nameLabel];
    mainview.tag = 201;
    mainview.alpha = 0.9;
    
    [self.view addSubview:mainview];
}



-(NSString *) dicGetValue:(NSString *) key grade:(NSDictionary *)gradeDic hardCodeMsg:(NSString *)msg {
    NSString *rValue = @"";
    
    if([NCS([gradeDic objectForKey:key]) length] > 0) {
        rValue = [gradeDic objectForKey:key];
    }
    else {
        rValue = msg;
    }
    return rValue;
    
}


- (UIImage *)getCurrentLaunchImage {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    NSString *interfaceOrientation = nil;
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) ||
        ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
        interfaceOrientation = @"Portrait";
    } else {
        interfaceOrientation = @"Landscape";
    }
    
    NSString *launchImageName = nil;
    
    NSArray *launchImages = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *launchImage in launchImages) {
        CGSize launchImageSize = CGSizeFromString(launchImage[@"UILaunchImageSize"]);
        NSString *launchImageOrientation = launchImage[@"UILaunchImageOrientation"];
        
        if (CGSizeEqualToSize(launchImageSize, screenSize) &&
            [launchImageOrientation isEqualToString:interfaceOrientation]) {
            launchImageName = launchImage[@"UILaunchImageName"];
            break;
        }
    }
    
    return [UIImage imageNamed:launchImageName];
}


@end
