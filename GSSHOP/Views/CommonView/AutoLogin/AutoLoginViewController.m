//
//  AutoLoginViewController.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "AutoLoginViewController.h"
#import "AppDelegate.h"
#import "URLDefine.h"
#import "DataManager.h"
#import "LoginData.h"
#import "PushData.h"
#import "PushDataRequest.h"
#import "ResultWebViewController.h"
#import "FullWebViewController.h"
#import "SNSLoginPopupView.h"
#import "LiveTalkViewController.h"
#import "HeaderWebViewController.h"
#import "PopupWebView.h"

#define UIColor_TextFieldHighlight [Mocha_Util getColor:@"B4CC2E"]


// App boy
#import <Appboy_iOS_SDK/AppboyKit.h>

//Fingerprint
#import <LocalAuthentication/LocalAuthentication.h>
#import <AirBridge/ABUserEvent.h>

//Naver 연동
@interface AutoLoginViewController (PrivateAPI)
- (BOOL)isStartsWithString:(NSString *)originString prefix:(NSString *)prefix;
- (BOOL)isContainWithString:(NSString *)originString string:(NSString *)string;
- (NSString *)parameterValueWithUrl:(NSString *)url paramName:(NSString *)name;
- (NSDictionary *)makeHeaderDictionary:(NSString *)headerString;
@end



@implementation AutoLoginViewController
@synthesize userId;
@synthesize userPass;
@synthesize DBData,DBName,DBPath;
@synthesize isFirstTimeAccess;
@synthesize delegate;
@synthesize btn_naviBack;
@synthesize btnLogin;
@synthesize isLogining;
@synthesize loginViewType;
@synthesize loginViewMode;
@synthesize currentOperation1;
@synthesize deletargetURLstr,textFieldPass,textFieldId;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _thirdPartyLoginConn = [NaverThirdPartyLoginConnection getSharedInstance];
        _thirdPartyLoginConn.delegate = self;
        strAccessToken = [[NSMutableString alloc] initWithString:@""];
        strRefreshToken = [[NSMutableString alloc] initWithString:@""];
        strSNSType = [[NSMutableString alloc] initWithString:@""];
        strLoginType = [[NSMutableString alloc] initWithString:@"TYPE_LOGIN"];
        
        /*
         순서유의
         @naver.com
         @hanmail.net
         @gmail.com
         @nate.com
         @hotmail.com
         @korea.com
         @dreamwiz.com
         @empal.com
         @paran.com
         @freechal.com
         */
        
        emailSet = [NSArray arrayWithObjects:@"naver.com",@"hanmail.net",@"gmail.com",@"nate.com",@"hotmail.com",@"korea.com",@"dreamwiz.com",@"empal.com",@"paran.com",@"freechal.com", nil];
        
        emailTemplite = [[NSMutableArray alloc] initWithArray:emailSet];
        
        self.isLogoutProcess = NO;
        self.pushAnimation = @"";
    }
    return self;
}



//이미지 버튼 처리 : Back 버튼
//데이터 자장(자동 로그인, 아이디, 패스 , 로그인 상태 )-> 로그인 성공했다면 저장한다.
-(IBAction)GoBack:(id)sender {
    [self textFieldCancel];
    if([self.pushAnimation isEqualToString:@"rise"]) {
        self.pushAnimation = @"";
        [self.navigationController popViewControllerMoveInFromDown];
    }
    else {
        [self.navigationController popViewControllerMoveInFromTop];
    }
    
    //성인인증인 경우 -  공백페이지
    if(self.loginViewMode == 2) {
        if( delegate != nil ){
            [delegate hideLoginViewController:self.loginViewMode];
        }
    }
}


-(void)hideLoginView {
    if([self.pushAnimation isEqualToString:@"rise"]) {
        self.pushAnimation = @"";
        [self.navigationController popViewControllerMoveInFromDown];
    }
    else {
        [self.navigationController popViewControllerMoveInFromTop];
    }
}


- (void)fromMypage:(NSInteger)index {
    
}


- (void)dealloc {
    delegate = nil;
    _thirdPartyLoginConn.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    ApplicationDelegate.isAviableBrazeInAppMessagePopupShow = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//GA 추적
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [ApplicationDelegate GTMscreenOpenSendLog:@"iOS - Login"];
    [ApplicationDelegate setAmplitudeEvent:@"View-기타-로그인진입"];
    
    /*fingerprint 맵핑되어 있으면 창을 띄운다.*/
    if( LL(FINGERPRINT_USE_KEY) != nil && snsLoginFlag == NO) {
        [self onFingerPrint:nil];
    }
    else {
        // 다음에 다시 오면 활성화 되야함.
        snsLoginFlag = NO;
    }
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // nami0342 - CSP
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_STOP_SOCKET object:nil];
    
//    lblInfo01.numberOfLines = 2;
//    lblInfo02.numberOfLines = 3;
    if (APPFULLWIDTH >= 768) {
        NSLog(@"APPFULLWIDTH = %f",APPFULLWIDTH);
        //lconstTTlabel_l3Height.constant = 32.0;
    }
    
    self.cntLoginFailed = 0;
    
    [self tableViewRegisterNib];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
//    LastPrdCustomTabBarView *tabBarView  = [[[NSBundle mainBundle] loadNibNamed:@"LastPrdCustomTabBarView" owner:self options:nil] firstObject];
//    tabBarView.frame = CGRectMake(0.0, APPFULLHEIGHT - APPTABBARHEIGHT, APPFULLWIDTH, APPTABBARHEIGHT);
//    tabBarView.autoresizesSubviews = NO;
//    tabBarView.autoresizingMask = UIViewAutoresizingNone;
//    [self.view addSubview:tabBarView];
    self.baseforcenterTopMargin.constant = 46 + STATUSBAR_HEIGHT;
    
    btn_gologin.layer.borderWidth = 0.0;
    btn_gologin.layer.cornerRadius = 4.0;
    btn_gologin.backgroundColor = [Mocha_Util getColor:@"cae72b"];
    btn_gologin.enabled = YES;
    
    
    //회원가입 버튼
    btn_foot3.layer.borderWidth = 1.0;
    btn_foot3.layer.cornerRadius = 4.0;
    btn_foot3.layer.shouldRasterize = YES;
    btn_foot3.layer.rasterizationScale = [UIScreen mainScreen].scale;
    btn_foot3.layer.borderColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    
  
    self.idView.layer.borderWidth = 1.0;
    self.idView.layer.cornerRadius = 4.0;
    self.idView.layer.borderColor = [Mocha_Util getColor:@"eeeeee"].CGColor;
    
    self.pwView.layer.borderWidth = 1.0;
    self.pwView.layer.cornerRadius = 4.0;
    self.pwView.layer.borderColor = [Mocha_Util getColor:@"eeeeee"].CGColor;
   
    
    
    //이메일 서포터
    self.emailInputSupport.layer.masksToBounds = NO;
    self.emailInputSupport.layer.cornerRadius = 8;
    self.emailTable.layer.cornerRadius = 8;
    
    self.emailInputSupport.layer.shadowColor =  UIColor.blackColor.CGColor;//[UIColor getColor:@"000000" alpha:0.16 defaultColor:UIColor.blackColor].CGColor;
    self.emailInputSupport.layer.shadowOffset =  CGSizeMake(0.0,2.0);
    self.emailInputSupport.layer.shadowRadius = 12.0/2.0;
    self.emailInputSupport.layer.shadowOpacity = 0.16;
    
    
    self.emailInputSupport.hidden = YES;


    /* 아이디 찾기, 비밀번호 찾기, 비회원 주문 끝*/
    btn_gocustomercenter.backgroundColor= [UIColor clearColor];

    NSDictionary *nomalTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                    NSForegroundColorAttributeName : [Mocha_Util getColor:@"999999"],
                                    };
    NSString *preText = @"해외거주 고객님! 로그인이 안되시면 메일 인증을 해주세요. 인증메일받기";
    
    NSMutableAttributedString *mAttributedStringPre = [[NSMutableAttributedString alloc]initWithString:preText attributes:nomalTextAttr];
    
    lblInfo01.attributedText = mAttributedStringPre;
    

    @try {
        
        // nami0342 - Apple ID 포함
        if (@available(iOS 13.0, *))
        {
            [self observeAppleSignInState];
        }
        else
        {
            m_AppleIDView.hidden = YES;
        }
        
        
        NSString *strUnderLine = @"인증메일받기"; //GSSLocalizedString(@"login_email_cert_description_link");
        
        NSRange stringRange = NSMakeRange(0, [mAttributedStringPre length]);
        NSRegularExpression *regexp = [[NSRegularExpression alloc] initWithPattern:strUnderLine options:NSRegularExpressionCaseInsensitive error:nil];
        NSRange rangeUnderline = [regexp rangeOfFirstMatchInString:[mAttributedStringPre string] options:0 range:stringRange];
                
        [mAttributedStringPre addAttribute:NSForegroundColorAttributeName
                                     value:[Mocha_Util getColor:@"444444"]
                                     range:rangeUnderline];
        [mAttributedStringPre addAttribute:NSFontAttributeName
                                     value:[UIFont boldSystemFontOfSize:12]
                                     range:rangeUnderline];
        
        lblInfo01.attributedText = mAttributedStringPre;
        lblInfo01.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    @catch (NSException *exception) {
        NSLog(@"exception = %@",exception);
    }
    @finally {
        lblInfo01.userInteractionEnabled = NO;
    }

    
    if(self.loginViewMode == 1) {
        //비회원주문
        
        viewNonMemberCenterLine.hidden = NO;
        btnNonMemberOrder.hidden = NO;
        
        self.nonMemberTrakingLeading.active = true;
        
        btn_gocustomercenter.hidden = NO;
        lblInfo01.hidden = NO;
        lblInfo02.hidden = NO;
        lblInfo02.attributedText = [[NSMutableAttributedString alloc]initWithString:@"비회원 주문시에는 GS SHOP의 다양한 혜택을 받으실 수 없어요." attributes:nomalTextAttr];
        
    }
    else {
        
        viewNonMemberCenterLine.hidden = YES;
        btnNonMemberOrder.hidden = YES;
        
        self.nonMemberTrakingLeading.active = false;
        
        lblInfo01.hidden = NO;
        lblInfo02.hidden = YES;
        lblInfo02.attributedText = [[NSMutableAttributedString alloc] init];
    }
    

    isLogining =YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.userId = @"";
    self.userPass = @"";
    textFieldId.text = @"";
    textFieldPass.text = @"";
    [textFieldId setKeyboardType:UIKeyboardTypeEmailAddress ];
    [textFieldPass setKeyboardType:UIKeyboardTypeASCIICapable ];
    
     // 지문로그인이 설정되어 있을경우 자동로그인 체크를 해제한다.
    if( LL(FINGERPRINT_USE_KEY) != nil ) {
        sw_autologin.selected = NO;
    }
    else {
        sw_autologin.selected = YES;
    }
    

    if([[DataManager sharedManager].loginYN isEqualToString:@"Y"] && (ApplicationDelegate.islogin)) {
        //로그아웃  콜~
        isLogining =YES;
        NSLog(@"logout done");
    }
    else {

        if (self.isLogoutProcess == NO) {
            [Mocha_ToastMessage toastWithDuration:2.0 andText:GSSLocalizedString(@"login_needs_toast") inView:ApplicationDelegate.window];
        }
        
        isLogining = NO;

        //DATAHUB CALL
        //D_1038 비로그인상태 - 로그인 페이지 진입 - 로그인 시작시점
        @try {
            [[GSDataHubTracker sharedInstance] NeoCallGTMWithReqURL:@"D_1038" str2:nil str3:nil];
        }
        @catch (NSException *exception) {

            NSLog(@"D_1038 ERROR : %@", exception);
        }
        @finally {
        }
    }
    
    SectionTBViewFooter *footercontainview = [[SectionTBViewFooter alloc] initWithTarget:self Nframe:CGRectMake(0.0,33, APPFULLWIDTH, 300.0)] ;
    //[viewFooter addSubview:footercontainview];
    [viewFooter insertSubview:footercontainview atIndex:0];
    //fingerprint 사용할래 기본값
    privateFingerprintUseFlag = NO;
    //sns로그인 실행
    snsLoginFlag = NO;
    
    if(IS_IPHONE_X_SERISE) {//faceID 지원
        [btnFinger setImage:[UIImage imageNamed:@"face_icon.png"] forState:UIControlStateNormal];
        [btnFinger setImage:[UIImage imageNamed:@"face_icon_press.png"] forState:UIControlStateSelected];
        btnFinger.accessibilityLabel = [NSString stringWithFormat:@"%@ 로그인",GSSLocalizedString(@"faceid_infotext2")];
    }
    else {        
        [btnFinger setImage:[UIImage imageNamed:@"finger-print_icon.png"] forState:UIControlStateNormal];
        [btnFinger setImage:[UIImage imageNamed:@"finger-print_icon_press.png"] forState:UIControlStateHighlighted];
        btnFinger.accessibilityLabel = [NSString stringWithFormat:@"%@ 로그인",GSSLocalizedString(@"fingerprint_infotext2")];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.currentOperation1 cancel];
    
    ApplicationDelegate.isAviableBrazeInAppMessagePopupShow = YES;
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [ApplicationDelegate.HMV showTabbarView];
    ApplicationDelegate.isAviableBrazeInAppMessagePopupShow = NO;
    
    // 혹시 로그인이 되어 있는 상태라면?? 닫아버림
    if(ApplicationDelegate.islogin) {
        NSLog(@"로그인이 되어 있어서 닫아버렸어!!!!!");
        [self.navigationController popViewControllerAnimated:NO];
        ApplicationDelegate.isAviableBrazeInAppMessagePopupShow = YES;
    }
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else if ([[NaverThirdPartyLoginConnection getSharedInstance] isOnlyPortraitSupportedInIphone]){
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}



- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


-(IBAction)goURL_Action:(id)sender {
    
    [self textFieldCancel];
    NSUInteger sbtntag = ((UIButton*)sender).tag;
    
    if(sbtntag == 1) {
        
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416122")];
        
        ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:GSLOGINFINDIDURL];
        resVC.view.tag = 505;
        [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
    }
    else if (sbtntag == 2) {
        
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416123")];
        
        ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:GSLOGINFINDPWURL];
        resVC.view.tag = 505;
        [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
    }
    else if (sbtntag == 6) {
        //비회원배송조회
        if( deletargetURLstr == NULL) {
            deletargetURLstr  = @"";
        }
        
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416126")];
        
        NSLog(@"dele url = %@",NONMEMBERORDERLISTURL(deletargetURLstr));
        ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:NONMEMBERORDERLISTURL(deletargetURLstr)];
        resVC.view.tag = 505;
        //resVC.isPassFirst = YES;
        [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
        
    }
    else if (sbtntag == 7) {
        //비회원주문
        NSInteger ltype = 7;
        if( delegate != nil ) {
            [delegate hideLoginViewController:ltype];
        }
        if([self.pushAnimation isEqualToString:@"rise"]) {
            self.pushAnimation = @"";
            [self.navigationController popViewControllerMoveInFromDown];
        }
        else {
            [self.navigationController popViewControllerMoveInFromTop];
        }
        
    }
    else if (sbtntag == 8) {
        //성인인증
        if( deletargetURLstr == NULL) {
            deletargetURLstr  = @"";
        }
        NSLog(@"dele url = %@",ADULTAUTHURL(deletargetURLstr));
        ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:ADULTAUTHURL(deletargetURLstr)];
        resVC.view.tag = 505;
        [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
    }
    
    //휴대폰로그인
    else if (sbtntag == 330) {
        
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416117")];
        
        if( deletargetURLstr == NULL) {
            deletargetURLstr  = @"";
        }
        NSLog(@"dele url = %@",GSFINDLOGINWITHPHONEURL(deletargetURLstr));

        ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:GSFINDLOGINWITHPHONEURL(deletargetURLstr)];
        resVC.view.tag = 505;
        [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
        //sns로그인을 시도 할때 플래그 활성화
        snsLoginFlag = YES;
        
        // nami0342 - Amplitude
        NSDictionary *dicProp = [NSDictionary dictionaryWithObjectsAndKeys:@"휴대폰",@"action", nil];
        [ApplicationDelegate setAmplitudeEventWithProperties:@"Click_로그인_기능" properties:dicProp];
    }
}



-(BOOL)isQuickorderReg {
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        {
            if( [cookie.name isEqualToString:@"mci"]) {
                if([cookie.value length] > 10) { return  YES; }
            }
        }
    }
    return  NO;
}



#pragma mark - View lifecycle
-(IBAction)pregoLogin {
    [self textFieldCancel];
    
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416118")];

    if(self.userId == NULL || [self.userId isEqualToString:@""])
    {
        NSLog(@"===================   : 1");
        [self errMessageForID:GSSLocalizedString(@"login_invalid_input_id")];
        
    }
    else if(self.userPass == NULL || [self.userPass isEqualToString:@""])
    {
        NSLog(@"===================   : 2");
        [self errMessageForIDPass:GSSLocalizedString(@"login_invalid_input_pw")];
    }
    
    else if([Mocha_Util strContain:@" " srcstring:self.userId])
    {
        NSLog(@"===================   : 3");
        [self errMessageForIDPass:GSSLocalizedString(@"login_invalid_space_id")];
    }
    
    else if([Mocha_Util strContain:@" " srcstring:self.userPass])
    {
        NSLog(@"===================   : 4");
        [self errMessageForIDPass:GSSLocalizedString(@"login_invalid_space_pw")];
    }
    
    else {
                 
        [self goLogin];
    }
    // nami0342 - Amplitude
    NSDictionary *dicProp = [NSDictionary dictionaryWithObjectsAndKeys:@"일반로그인",@"action", nil];
    [ApplicationDelegate setAmplitudeEventWithProperties:@"Click_로그인_기능" properties:dicProp];
    [viewMemberInput layoutIfNeeded];
    
}

//clicked login button
- (void)goLogin {
    //ecid값 복사
    [CooKieDBManager printSharedCookies];
    [[WKManager sharedManager] copyToSharedCookieName:@"ecid" OnCompletion:^(BOOL isSuccess) {
    //isSuccess성공여부는 무의미함
    [CooKieDBManager printSharedCookies];
        if( isLogining == NO ) {
            [self textFieldCancel];
            //텍스트 입력이 빠진것이 있나 확인하고 빠젓으면 경고 메시지 출력하고 빠진 텍스트 필드로 이동
            
            if((![strLoginType isEqualToString:@"TYPE_OAUTH"]) && (self.userId == NULL || self.userPass == NULL)) {
                NSLog(@"===================   : 5");
                Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"login_invalid_input") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                malert.tag = 5;
                [ApplicationDelegate.window addSubview:malert];
            }
            else if((![strLoginType isEqualToString:@"TYPE_OAUTH"]) && ( [self.userId isEqualToString:@""] || [self.userPass isEqualToString:@""] ))
            {
                NSLog(@"===================   : 6");
                Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"login_invalid_input")  maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                malert.tag = 5;
                [ApplicationDelegate.window addSubview:malert];
            }
            else//정상적이면 id,pass 자동로그인 상태를 JSON에 실어서 서버로 보내는 작업 s
            {
                [self textFieldCancel];
             
                NSString *nid = self.userId;
                NSString *npw = self.userPass;
                NSString *slogin = @"N";
                NSLog(@"---- id: %@ -- pw: %@", nid,npw);
                
       
                dispatch_async(dispatch_get_main_queue(),^{
                    [ApplicationDelegate.gactivityIndicator startAnimating];
                });
                
                [self.currentOperation1 cancel];
                
                self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsTOKENLOGINURL:(NSString*)nid userpass :(NSString*)npw simplelogin :(NSString*)slogin snsAccessToken:strAccessToken snsRefreshToken:strRefreshToken snsType:strSNSType loginType:strLoginType onCompletion:^(NSDictionary *result) {
                    //NSLog(@"ID N PW: %@, %@,  %@", nid, npw, slogin);
                    NSLog(@"GsshopViewController login comm success");
                    
                    NSLog(@"resutl=%@",result);//custno

                    
                    [ApplicationDelegate.gactivityIndicator stopAnimating];
                    
                    // 20140117 Youngmin Jin -Start
                    // EC통합재구축 응답 포맷 변경 사항 수정
                    BOOL successval = [NCB([result valueForKey:@"succs"]) boolValue];
                    
                    if( !successval ) //로그인실패
                    {
                        
                        self.userPass = @"";
                        textFieldPass.text = @"";
//                        btn_gologin.backgroundColor = [Mocha_Util getColor:@"E8F1B5"];
//                        btn_gologin.layer.borderColor = [Mocha_Util getColor:@"E1E9B0"].CGColor;
//                        [btn_gologin setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateNormal];
                        
                        self.btnClearPass.hidden = YES;
                        
                        // nami0342 - 회원지표 : 로그인 실패 - 아이디 / 비밀번호 오류
                        if([NCS([result objectForKey:@"retTyp"]) isEqualToString:@"30"] || [NCS([result objectForKey:@"retTyp"]) isEqualToString:@"31"])
                        {
                            
                            NSLog(@"===================   : 7");
                            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=413564")];
                            
                            if (self.cntLoginFailed == 2) {
                                Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"login_idpass_fail_three_times") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                simpleiddic = result;
                                malert.tag = 1;
                                
                                [ApplicationDelegate.window addSubview:malert];
                            }
                            
                            self.cntLoginFailed = self.cntLoginFailed +1;
                            
                            if([[result valueForKey:@"errMsg"] isKindOfClass:[NSNull class]] == NO) {
                                NSString *strMsg = NCS([result valueForKey:@"errMsg"]);
                                NSLog(@"strMsg = %@",strMsg);
                                [self errMessageForIDPass:strMsg];
                                return;
                            }
                        }
                        
                        // nami0342 - 회원지표 : 로그인 실패 - 비밀번호 강제 변경
                        if([NCS([result objectForKey:@"retTyp"]) isEqualToString:@"10"]) {
                            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=413566")];
                        }
                    
                        
                        
                        if ([NCS([result objectForKey:@"retTyp"]) isEqualToString:@"40"] ) {
                            if (NCO([result objectForKey:@"retOauthState"]) && [[result objectForKey:@"retOauthState"] isKindOfClass:[NSDictionary class]]) {
                                [strLoginType setString:@"TYPE_LOGIN"];
                                [strSNSType setString:@""];
                                [strAccessToken setString:@""];
                                [strRefreshToken setString:@""];
                                NSMutableString *strToMove = [[NSMutableString alloc] initWithString:NCS([[result objectForKey:@"retOauthState"] objectForKey:@"loginUrl"])];
                                
                                if ([NCS(deletargetURLstr) length] > 0) {
                                    [strToMove appendString:@"&returnurl="];
                                    [strToMove appendString:[deletargetURLstr urlEncodedString]];
                                }
                                
                                NSLog(@"strToMove = %@",strToMove);
                                ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:strToMove];
                                resVC.view.tag = 505;
                                [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
                                return;
                            }
                        }
                        else if ([NCS([result objectForKey:@"retTyp"]) isEqualToString:@"50"] && [NCS([result objectForKey:@"retUrl"]) hasPrefix:@"http"]) {
                            //
                            [strSNSType setString:@""];
                            [strLoginType setString:@"TYPE_LOGIN"];
                            [self snsAccessUrlMove:NCS([result objectForKey:@"retUrl"])];
                            return;
                        }
                        
                        if([[result valueForKey:@"errMsg"] isKindOfClass:[NSNull class]] == NO) {
                            Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:[result valueForKey:@"errMsg"] maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                            simpleiddic = result;
                            malert.tag = 1;
                            
                            [ApplicationDelegate.window addSubview:malert];
                        }
                        else {
                            Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"login_intro_fail") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                            simpleiddic = result;
                            malert.tag = 1;
                            
                            [ApplicationDelegate.window addSubview:malert];
                        }
                        
                        
                        
                        
                        return;
                    }
                    else {//로그인 성공 /ID/PW
                        
                        //로그인 성공
                        if([ApplicationDelegate checkLoginCookie:YES] == NO){
                            NSError *err = [NSError errorWithDomain:@"app_NomalLogin_Cookie_Failed" code:9004 userInfo:nil];
                            NSString *msg = [[NSString alloc] initWithFormat:@"일반로그인후 쿠키값이 이상함을 확인" ];
                            [ApplicationDelegate SendExceptionLog:err msg: msg];
                        }
                        
                        // nami0342 - 거래거절고객 처리
                        if([@"Y" isEqualToString:NCS([result objectForKey:@"txnRfuseCustYn"])] == YES)
                        {
                            [ApplicationDelegate SendPushRefuseWhenBlockUserLogin];
                        }
                        
                        [CooKieDBManager printSharedCookies];
                        
                        simpleiddic = result;
                        
                        
                        //비회원 주문 체크로직 추가
                         //[[WKManager sharedManager] resetPool];
                        
                                                
                        if(delegate != nil) {
                            [[NSNotificationCenter defaultCenter] addObserver:self
                                                                         selector:@selector(wkSessionSuccess)
                                                                             name:WKSESSION_SUCCESS
                                                                           object:nil];
                            
                            [[NSNotificationCenter defaultCenter] addObserver:self
                                                                         selector:@selector(wkSessionFail)
                                                                             name:WKSESSION_FAIL
                                                                           object:nil];
                            [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
                        }
                        else {
                            [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
                            [self loginSuccessProcessWithBio:NO];
                        }
                        
                        
                    }
                }
                                          onError:^(NSError* error) {
                                              [ApplicationDelegate.gactivityIndicator stopAnimating];
                                              ApplicationDelegate.islogin = NO;
                                              Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GNET_ERRSERVER maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                              malert.tag = 1;
                                              [ApplicationDelegate.window addSubview:malert];
                                              NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                    [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                              [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONGOTOPNRELOADNOTI object:[NSNumber numberWithInt:0]];
                                          }];
            }
        }
        else {// 로그아웃을 처리...
            // nami0342 - CSP
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_STOP_SOCKET object:nil];
            
            // nami0342 - Remove network cache
            [[UrlSessionCache sharedInstance] deleteAllMemory];
            
            //fingerprint
            //지문로그인을 사용중이면 서버를 태우지 않고 로컬 정보만 초기화 한다.
            // fingerprint 지문로그인은 로그인 정보를 초기화 하지 않는다.
           if( LL(FINGERPRINT_USE_KEY) != nil ) { // 지문로그인사용중
               [CooKieDBManager deleteLogoutCookies];
               
               
               //자동로그인 정보 및 비밀번호 초기화
               [[DataManager sharedManager] deleteLoginInfo];
               [DataManager sharedManager].loginYN = @"N";
               ApplicationDelegate.islogin = NO;
               //베스트딜 하단 추천상품 용으로 username 저장 2015.10.12 YS Jin
               [[DataManager sharedManager]setUserName:nil];
               [[DataManager sharedManager]setCustomerNo:nil];
               [ApplicationDelegate PMSsetUUIDNWapcidNpcid];
               //PMS로그아웃
               [PMS logout];
               [self.navigationController  popViewControllerAnimated:NO];
               [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONGOTOPNRELOADNOTI object:[NSNumber numberWithInt:1]];
               [delegate hideLoginViewController:self.loginViewType];
               [ApplicationDelegate updateBadgeInfo:[NSNumber numberWithBool:YES]];

               self.isLogoutProcess = YES;
               
               [[WKManager sharedManager] wkWebviewSetCookieAll:NO];
               
               return;
            }
            
            [[DataManager sharedManager]GetLoginData];
            NSString* db_loginid = [DataManager sharedManager].m_loginData.loginid;
            NSString* db_serieskey = [DataManager sharedManager].m_loginData.serieskey;
        
            [self.currentOperation1 cancel];
            self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsTOKENLOGOUTPROC:(NSString*) db_loginid
                                                                                 serieskey : (NSString*) db_serieskey
                                                                               onCompletion:^(NSDictionary *result) {
                                                                                   NSLog(@"logout result = %@", result);
                                                                                   // nami0342 - CSP
                                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_STOP_SOCKET object:nil];
                                                                                   [CooKieDBManager deleteLogoutCookies];
                                                                                   
                                                                                   isLogining = NO;
                                                                                   
                                                                                   
                                                                                   
                                                                                   //자동로그인 정보 및 비밀번호 초기화
                                                                                   [[DataManager sharedManager]deleteLoginInfo];
                                                                                   
                                                                                   [DataManager sharedManager].loginYN = @"N";
                                                                                   ApplicationDelegate.islogin = NO;
                                                                                   
                                                                                   self.isLogoutProcess = YES;
                                                                                   
                                                                                   //베스트딜 하단 추천상품 용으로 username 저장 2015.10.12 YS Jin
                                                                                   [[DataManager sharedManager]setUserName:nil];
                                                                                   [[DataManager sharedManager]setCustomerNo:nil];
                                                                                   
                                                                                   
                                                                                   [ApplicationDelegate PMSsetUUIDNWapcidNpcid];
                                                                                   //PMS로그아웃
                                                                                   [PMS logout];
                                                                                 
                                                                                   
                                                                                   [self.navigationController  popViewControllerAnimated:NO];
                                                                                   
                                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONGOTOPNRELOADNOTI object:[NSNumber numberWithInt:1]];
                                                                                   
                                                                                   [delegate hideLoginViewController:self.loginViewType];
                                                                                   
                                                                                   ////탭바제거
                                                                                   [ApplicationDelegate updateBadgeInfo:[NSNumber numberWithBool:YES]];
                                                                                   
                                                                                   [[WKManager sharedManager] wkWebviewSetCookieAll:NO];
                                                                                   
                                                                                 
                                                                               }
                                                                                    onError:^(NSError* error) {
                                                                                        
                                                                                        [CooKieDBManager deleteLogoutCookies];
                                                                                        
                                                                                        isLogining = NO;
                                                                                        //자동로그인 정보 및 비밀번호 초기화
                                                                                        [[DataManager sharedManager]deleteLoginInfo];
                                                                                        [DataManager sharedManager].loginYN = @"N";
                                                                                        ApplicationDelegate.islogin = NO;
                                                                                        self.isLogoutProcess = YES;
                                                                                        //베스트딜 하단 추천상품 용으로 username 저장 2015.10.12 YS Jin
                                                                                        [[DataManager sharedManager]setUserName:nil];
                                                                                        [[DataManager sharedManager]setCustomerNo:nil];
                                                                                        //PMS로그아웃
                                                                                        [PMS logout];
                                                                                        [self.navigationController popViewControllerAnimated:NO];
                                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONGOTOPNRELOADNOTI object:[NSNumber numberWithInt:1]];
                                                                                        [delegate hideLoginViewController:self.loginViewType];
                                                                                        ////탭바제거
                                                                                        [ApplicationDelegate updateBadgeInfo:[NSNumber numberWithBool:YES]];
                                                                                        //로그아웃 처리
                                                                                        [[WKManager sharedManager] wkWebviewSetCookieAll:NO];
                                                                                    }];
        }
    }];
}

//clicked joinbutton
- (IBAction)goJoinMember:(id)sender {
    [self textFieldCancel];
    //회원가입 사이트로 이동 엡뷰에 보여준다.
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416125")];
    ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:JOINURL];
    resVC.view.tag = 505;
    [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
}

//clicked  고객센터
- (IBAction)goCustomerCenter:(id)sender {
    //고객센터 웹뷰 이동
    ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:GSCUSTOMERCENTERURL];
    resVC.view.tag = 505;
    [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
}

//clicked  인증이메일재발송
- (IBAction)goEmailAuth:(id)sender {
    [self textFieldCancel];
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416124")];
    //인증이메일재발송 웹뷰 이동
    ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:GSEMAILAUTHURL];
    resVC.view.tag = 505;
    [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
}




 
- (void)saveNormalLoginUserData:(NSDictionary *)result {
    
    // nami0342 - DB -> 로컬 저장으로 변경
    [[DataManager sharedManager] GetLoginData];
    // nami0342 - 싱글톤 로그인 인스턴스에 로그인 값 저장
    [DataManager sharedManager].m_loginData.loginid  = ([NCS([result objectForKey:@"loginId"])length]>0)?NCS([result objectForKey:@"loginId"]):self.userId;
    [DataManager sharedManager].m_loginData.serieskey =  [result objectForKey:@"serisKey"];
    [DataManager sharedManager].m_loginData.authtoken = [result objectForKey:@"certToken"];
    [DataManager sharedManager].m_loginData.snsTyp =  NCS([result objectForKey:@"snsTyp"]);
    [DataManager sharedManager].m_loginData.simplelogin = NO;
    [DataManager sharedManager].m_loginData.autologin = sw_autologin.selected?YES:NO;
    [DataManager sharedManager].m_loginData.saveid = NO;
    [DataManager saveLoginData];
    //isLogining = YES;
    
    //fingerprint
    //지문로그인 정보를 최신으로 갱신한다
    if( LL(FINGERPRINT_USE_KEY) != nil ) {
        [[DataManager sharedManager] GetLoginData];
        SL([DataManager sharedManager].m_loginData,FINGERPRINT_USE_KEY);
    }
    
    [[Common_Util sharedInstance] saveToLocalData];
}

//fingerprint
- (IBAction)onFingerPrint:(id)sender {
    
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416116")];
    
    //20180102 생체로그인 실행시 키패드 내림.
    [textFieldId resignFirstResponder];
    [textFieldPass resignFirstResponder];
    
    //sns로그인을 시도 할때 플래그 비활성화
    snsLoginFlag = NO;
    
    NSLog(@"%@",[UIDevice currentDevice].deviceModelName);
    //지문인식 가능 폰여부
    if ([LAContext class] && !([Mocha_Util strContain:@"iPhone 5" srcstring:[UIDevice currentDevice].deviceModelName] ? ([Mocha_Util strContain:@"iPhone 5s" srcstring:[UIDevice currentDevice].deviceModelName] ? NO : YES) : NO) ) {
        
        //지문연동되어 있음.?
        if( LL(FINGERPRINT_USE_KEY) != nil ) {
            
            LAContext *myContext = [[LAContext alloc] init];
            NSError *authError = nil;
            
            
            // pass code 입력 버튼 없앰
            myContext.localizedFallbackTitle = @"";
            
            LoginData *obj = (LoginData *)LL(FINGERPRINT_USE_KEY);
            
            NSString *myLocalizedReasonString = [NSString stringWithFormat:@"%@ %@",[Common_Util getIDMask:obj.loginid], (IS_IPHONE_X_SERISE ?  GSSLocalizedString(@"Info_faceid") : GSSLocalizedString(@"Info_fingerprint")) ];
            
            if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
                [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                          localizedReason:myLocalizedReasonString
                                    reply:^(BOOL success, NSError *error) {
                                        if (success) {
                                            // User authenticated successfully, take appropriate action
                                            NSLog(@"SUCCESS");
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self fingerLogin];
                                                // 로그인을 태웁니다.
                                            });
                                        }
                                        else {
                                            // User did not authenticate successfully, look at error and take appropriate action
                                            NSLog(@"ERROR: %@",error);
                                            if(error.code == LAErrorUserFallback) {
                                                // 비번입력
                                                // 정상적인 방법으로 처리 되지않음.
                                                // 위 context.localizedFallbackTitle = @""; 코드로 해당 버튼 노출 제거
                                            }
                                            // 지문등록안되어 있거나, 비밀번호사용을 안하거나, 지문인식 활성화가 안되어 있거나.
                                            else if(error.code == LAErrorTouchIDNotEnrolled || error.code == LAErrorPasscodeNotSet || error.code == LAErrorTouchIDNotAvailable) {
                                                dispatch_async(dispatch_get_main_queue(),^{
                                                    [ApplicationDelegate touchIDSetting_Popup:(int)error.code];
                                                });
                                            }
                                            else if (error.code == LAErrorTouchIDLockout) {
                                                // 이 PASSCODE 입력창은 LAPolicyDeviceOwnerAuthenticationWithBiometrics 에서 retrun이 NO 이어야만 동작함.
                                                [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason: (IS_IPHONE_X_SERISE ? GSSLocalizedString(@"faceid_lockout") : GSSLocalizedString(@"fingerprint_lockout") ) reply:^(BOOL success, NSError * _Nullable error) {
                                                    if (success) {
                                                        // User authenticated successfully, take appropriate action
                                                        NSLog(@"SUCCESS");
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            // 지문로그인이 가능하도록 다시 시도.
                                                            [self onFingerPrint:nil];
                                                        });
                                                    }
                                                    else {
                                                        // User did not authenticate successfully, look at error and take appropriate action
                                                        NSLog(@"ERROR");
                                                    }
                                                    
                                                }];
                                                return;
                                            }
                                            else if(error.code == LAErrorAuthenticationFailed) {
                                                // 3회 실패시 잠시후 다시 시도 요청 팝업
                                            }
                                        }
                                    }];
            }
            else {
                
                //20170807 parksegun 지문인식이 연속으로 (5회) 틀렸을경우 에러코드를 통해 비밀번호를 입력하도록 되어 있음. 9에선 자동으로. 10에선 명시적 코딩이 필요함.
                if (authError.code == LAErrorTouchIDLockout) {
                    // 이 PASSCODE 입력창은 LAPolicyDeviceOwnerAuthenticationWithBiometrics 에서 retrun이 NO 이어야만 동작함.
                    [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:(IS_IPHONE_X_SERISE ? GSSLocalizedString(@"faceid_lockout") : GSSLocalizedString(@"fingerprint_lockout") ) reply:^(BOOL success, NSError * _Nullable error) {
                        
                        if (success) {
                            // User authenticated successfully, take appropriate action
                            NSLog(@"SUCCESS");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // 지문로그인이 가능하도록 다시 시도.
                                [self onFingerPrint:nil];
                            });
                        }
                        else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            NSLog(@"ERROR");
                        }
                        
                    }];
                    
                    return;
                }
                // 지문등록안되어 있거나, 비밀번호사용을 안하거나, 지문인식 활성화가 안되어 있거나.
                else if(authError.code == LAErrorTouchIDNotEnrolled || authError.code == LAErrorPasscodeNotSet || authError.code == LAErrorTouchIDNotAvailable) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [ApplicationDelegate touchIDSetting_Popup:(int)authError.code];
                    });
                }
                else {
                    NSLog(@"authError: %@",authError);
                }
                
            }
            
        }
        else {
            //지문연동이 할래?
            //지문등록은 되어 있나?
            if([ApplicationDelegate isCanUseBioAuth]) {
                // 지문로그인을 위해 로그인해주세요.
                // 지문로그인 불가능 alert
                Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle: (IS_IPHONE_X_SERISE ? GSSLocalizedString(@"Info_Use_faceid") : GSSLocalizedString(@"Info_Use_fingerprint")) maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"fingerprint_nextprocess"), GSSLocalizedString(@"fingerprint_loginprocess"), nil]];
                
                malert.tag = 6;
                [ApplicationDelegate.window addSubview:malert];
                
            }
            else {
                // 지문을 단말기에 등록하세요.
                [ApplicationDelegate touchIDSetting_Popup:0];
                
            }
        }
    }
    else {
        
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416553")];
        
        // 지문로그인 불가능 alert
        Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle: (IS_IPHONE_X_SERISE ? GSSLocalizedString(@"Info_Dont_Use_faceid") : GSSLocalizedString(@"Info_Dont_Use_fingerprint")) maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        
        [ApplicationDelegate.window addSubview:malert];
    }
    
    // nami0342 - Amplitude
    NSDictionary *dicProp = [NSDictionary dictionaryWithObjectsAndKeys:@"지문",@"action", nil];
    [ApplicationDelegate setAmplitudeEventWithProperties:@"Click_로그인_기능" properties:dicProp];
    
}

-(void) fingerLogin {
    //지문 로그인- 자동로그인 토큰을 가지고 시작
    //autologin check
    
    [[DataManager sharedManager] GetLoginData];
    LoginData *obj;// = [DataManager sharedManager].m_loginData;
    
    if( LL(FINGERPRINT_USE_KEY) != nil ) {
        obj = (LoginData *)LL(FINGERPRINT_USE_KEY);
    }
    
    if( [obj isKindOfClass:[LoginData class]] && [obj.loginid length] > 0 && [obj.authtoken length] > 0 )
    {
        ApplicationDelegate.isauthing = YES;
        
        
        self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsTOKENAUTHURL:(NSString*)obj.loginid serieskey :(NSString*)obj.serieskey authtken : (NSString*)obj.authtoken snsTyp:obj.snsTyp  onCompletion:^(NSDictionary *result) {
            NSLog(@"GsshopViewController login success");
            NSLog(@"resutl=%@",result);//custno
            NSLog(@"errmsg: %@", [result valueForKey:@"errorMessage"] );
            
            // 20140117 Youngmin Jin -Start
            // 통합재구축 변경 사항 수정
            BOOL successval = [NCB([result valueForKey:@"succs"]) boolValue];
            
            if( !successval ) {
                if([[result valueForKey:@"errMsg"] isKindOfClass:[NSNull class]] == NO) {
                    //로그인 정보가 변경되어 다시 로그인 해주세요
                    Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:@"로그인 정보가 유효하지 않아 다시 로그인 해주세요." maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                    
                    [ApplicationDelegate.window addSubview:malert];
                    SL(nil,FINGERPRINT_USE_KEY);
                    privateFingerprintUseFlag = YES;
                }
            }
            else { //로그인 성공
                
                
                //로그인 성공
                if([ApplicationDelegate checkLoginCookie:YES] == NO){
                    NSError *err = [NSError errorWithDomain:@"app_fingerLogin_Cookie_Failed" code:9004 userInfo:nil];
                    NSString *msg = [[NSString alloc] initWithFormat:@"생체로그인후 쿠키값이 이상함을 확인:" ];
                    [ApplicationDelegate SendExceptionLog:err msg: msg];
                }
                
                // nami0342 - 거래거절고객 처리
                if([@"Y" isEqualToString:NCS([result objectForKey:@"txnRfuseCustYn"])] == YES)
                {
                    [ApplicationDelegate SendPushRefuseWhenBlockUserLogin];
                }
                
                simpleiddic = result;
                
                if( delegate != nil ) {
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(wkSessionSuccessFinger)
                                                                 name:WKSESSION_SUCCESS
                                                               object:nil];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(wkSessionFail)
                                                                 name:WKSESSION_FAIL
                                                               object:nil];
                    [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
                }
                else {
                    [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
                    [self loginSuccessProcessWithBio:YES];
                }
                
                
                
                
            }
        }
                                                                             onError:^(NSError* error) {
                                                                                 [ApplicationDelegate.gactivityIndicator stopAnimating];
                                                                                 ApplicationDelegate.islogin = NO;
                                                                                 Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GNET_ERRSERVER maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                                                                 malert.tag = 1;
                                                                                 [ApplicationDelegate.window addSubview:malert];
                                                                                 
                                                                                 NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                                                       [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                                                 
                                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONGOTOPNRELOADNOTI object:[NSNumber numberWithInt:0]];
                                                                                 
                                                                             }];
        
        
        
    }
    else {
        // 로그인 실패
        Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle: (IS_IPHONE_X_SERISE ? GSSLocalizedString(@"Info_faceid_login_Fail") : GSSLocalizedString(@"Info_fingerprint_login_Fail")) maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        //malert.tag = 1;
        [ApplicationDelegate.window addSubview:malert];
        SL(nil,FINGERPRINT_USE_KEY);
        [[Common_Util sharedInstance] saveToLocalData];
        privateFingerprintUseFlag = YES;
        
    }
    
}



-(void)loginSuccessProcessWithBio:(BOOL)isBioLogin {
    //쿠키복사후 시도
    //[[WKManager sharedManager] copyToSharedCookieAll:^(BOOL isSuccess) {
        
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    NSDictionary *result = [simpleiddic copy];
    
    //2018.02.01 비밀번호 안보기 여부를 서버로 전송하기위해 평문으로 catvId 값 받음
    if ([NCS([result objectForKey:@"passwdNeedChgYn"]) isEqualToString:@"Y"] && [NCS([result objectForKey:@"passwdChgUrl"]) length] > 0) {
        [Common_Util checkPassWordChangeAlertShowWithUrl:NCS([result objectForKey:@"passwdChgUrl"]) andUserKey:[NSString stringWithFormat:@"%@", [result valueForKey:@"custNo"]]];
    }
    //20181017 parksegun TV고객 로그인번호 변경
    else if ([NCS([result objectForKey:@"tvCustPasswdNeedChgYn"]) isEqualToString:@"Y"] && [NCS([result objectForKey:@"tvCustPasswdChgUrl"]) length] > 0) {
        [Common_Util checkTVUserPassWordChangeAlertShowWithUrl:NCS([result objectForKey:@"tvCustPasswdChgUrl"]) andUserKey:[NSString stringWithFormat:@"%@", [result valueForKey:@"custNo"]]];
    }
    else {
        //20181107 parksegun ID/PW 로그인 사용자이고 지문로그인/안면로그인 가능하고 지문로그인을 안했다면 권유 팝업 노출(최초 한번)
        if(isBioLogin == NO && privateFingerprintUseFlag != YES && LL(INFOFINGERPRINTSUGGEST) == nil && [ApplicationDelegate isCanUseBioAuth] && LL(FINGERPRINT_USE_KEY) == nil) {
            Mocha_Alert *senseLoginAlert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"Info_fingerprint_suggest") maintitle:nil delegate:ApplicationDelegate buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"Info_noview"),GSSLocalizedString(@"fingerprint_loginprocess"), nil]];
            senseLoginAlert.tag = 7;
            [ApplicationDelegate.window addSubview:senseLoginAlert];
        }
    }
    
    // nami0342 - CSP
    [ApplicationDelegate CSP_StartWithCustomerID:[result valueForKey:@"custNo"]];
   
    //떠 있는 웹뷰를 모두 새로 고침하라!!! 단!!! 나를 부른 녀석은 제외!! why? 다시 로그인창을 불러올수 있는 위험이 있다!!
    UINavigationController * navigationController = ApplicationDelegate.mainNVC;
    NSLog(@"[DataManager sharedManager].selectTab = %lu",(long)[DataManager sharedManager].selectTab);
    for (id vc in navigationController.viewControllers){
        if ([vc respondsToSelector:@selector(webViewReload)]) {
            if ([vc isKindOfClass:[Home_Main_ViewController class]] == NO && delegate != vc) {
                [vc webViewReload];
            }
        }
    }
    
    
    // nami0342 - Set Amplitude identify : 직원여부, 고객 등급
    if(NCO([result valueForKey:@"custType"]) == YES) {
        [ApplicationDelegate setAmplitudeIdentifyWithSet:@"custType" value:[result valueForKey:@"custType"]];
    }
    
    if(NCO([result valueForKey:@"grade"]) == YES) {
        [ApplicationDelegate setUGradeValue:NCS([result valueForKey:@"grade"])];
        [ApplicationDelegate setAmplitudeIdentifyWithSet:@"grade" value:[result valueForKey:@"grade"]];
    }
    

    
    if (isBioLogin) {
        //지문로그인 성공시 호출
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=414542")];
    }
    
    [[DataManager sharedManager]getPushInfo];
    
    // 디바이스 토큰이 없을때. nil로 푸시정보전송
    if([[DataManager sharedManager].m_pushData.deviceToken isEqualToString:@""] == YES) {
        PushDataRequest *pushRequest = [[PushDataRequest alloc]init];
        [pushRequest sendData:nil  customNo:[result valueForKey:@"custNo"]];
        
    }else{
        // 디바이스 토큰이 존재함. 정상적으로 토큰포함 푸시정보전송
        PushDataRequest *pushRequest = [[PushDataRequest alloc]init];
        [pushRequest sendData:[DataManager sharedManager].m_pushData.deviceToken customNo:[result valueForKey:@"custNo"]];
        
    }
    
    //로그인 성공하면 데이터 저장
    [DataManager sharedManager].loginYN = @"Y";
    
    if (isBioLogin == YES) {
        // 토큰로그인(자동로그인)은 정보가 일부만 전송된다.
        [[DataManager sharedManager] GetLoginData];
        LoginData *obj;// = [DataManager sharedManager].m_loginData;
        if( LL(FINGERPRINT_USE_KEY) != nil ) {
            obj = (LoginData *)LL(FINGERPRINT_USE_KEY);
        }
        // nami0342 - 싱글톤 로그인 인스턴스에 로그인 값 저장
        [DataManager sharedManager].m_loginData.loginid = obj.loginid;
        [DataManager sharedManager].m_loginData.serieskey = obj.serieskey;
        [DataManager sharedManager].m_loginData.authtoken = [result valueForKey:@"certToken"]; //obj.authtoken;
        [DataManager sharedManager].m_loginData.snsTyp = obj.snsTyp;
        [DataManager sharedManager].m_loginData.simplelogin = NO;
        [DataManager sharedManager].m_loginData.autologin = sw_autologin.selected?YES:NO;
        [DataManager sharedManager].m_loginData.saveid = NO;
        [DataManager saveLoginData];
        //isLogining = YES;
        
        //지문로그인 정보를 갱신한다.
        [[DataManager sharedManager] GetLoginData];
        SL([DataManager sharedManager].m_loginData,FINGERPRINT_USE_KEY);
        [[Common_Util sharedInstance] saveToLocalData];
        
    }else{
        //fingerprint
        if(privateFingerprintUseFlag == YES) {// 지문등록할꺼면 지문정보 꺼내오기
            [[DataManager sharedManager] GetLoginData];
            SL([DataManager sharedManager].m_loginData,FINGERPRINT_USE_KEY);
            [[Common_Util sharedInstance] saveToLocalData];
            privateFingerprintUseFlag = NO;
            //지문로그인 연동 맵핑 완료
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=414541")];
            /*fingerprint 성공시 토스트 팝업 추가*/
            [Mocha_ToastMessage toastWithDuration:2.0 andText: (IS_IPHONE_X_SERISE ? GSSLocalizedString(@"faceid_loginSucess") : GSSLocalizedString(@"fingerprint_loginSucess")) inView:ApplicationDelegate.window];
        }
        else { // 지문로그인을 하고자 하지 않고 로그인을 하면 지워버림.
            // privateFingerprintUseFlag == NO
            SL(nil,FINGERPRINT_USE_KEY); // 연동해제
            [[Common_Util sharedInstance] saveToLocalData];
        }
        
        [self saveNormalLoginUserData:result];
    }
    
    ApplicationDelegate.islogin = YES;
    
    //베스트딜 하단 추천상품 용으로 username 저장 2015.10.12 YS Jin
    [[DataManager sharedManager]setUserName:[result objectForKey:@"custNm"]];
    //PMS아이디세팅
    [PMS setUserId:[NSString stringWithFormat:@"%@",[result valueForKey:@"custNo"]] ];
    [ApplicationDelegate PMSsetUUIDNWapcidNpcid];
    [PMS login];
    
    //Amplitude
    [ApplicationDelegate setAmplitudeUserId:[[result valueForKey:@"custNo"] stringValue]];
    
    //20160118 custNo 상품평을 위해 저장
    [[DataManager sharedManager]setCustomerNo:[result valueForKey:@"custNo"]];
    
    // App boy - Custom event sending
    NSString *strCustNo = [NSString stringWithFormat:@"%@",[result valueForKey:@"custNo"]];
    if ([NCS(strCustNo) length] > 0) {
        [[Appboy sharedInstance] changeUser:strCustNo];
        [[Appboy sharedInstance].user setCustomAttributeWithKey:@"catvid" andStringValue:strCustNo];
        
        // nami0342 - AirBridge 1.0.0
        ABUser *abuser = [[ABUser alloc] init];
        [abuser setID:strCustNo];
        ABUserEvent *abUserEvent = [[ABUserEvent alloc] initWithUser:abuser];
        [abUserEvent sendSignin];
    }
    
    if ([NCS(DEVICEUUID) length] > 0) {
        [[Appboy sharedInstance].user setCustomAttributeWithKey:@"uuid" andStringValue:DEVICEUUID];
    }
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if([cookie.name isEqualToString:@"gd"]){
            NSString *strGd = NCS([cookie.value copy]);
            if ([strGd length] > 0) {
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"gd" andStringValue:strGd];
                [ApplicationDelegate setGender:strGd];
            }
        }else if ([cookie.name isEqualToString:@"yd"]){
            NSString *strYd = NCS([cookie.value copy]);
            if ([strYd length] > 0) {
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"yd" andStringValue:strYd];
                [ApplicationDelegate setAge:strYd];
            }
            
        }
    }
    // App boy end
    if( delegate != nil ) {
        NSLog(@"return url = %@", [delegate definecurrentUrlString]);
        if([[delegate definecurrentUrlString] hasPrefix:@"gsshopmobile"]){
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[delegate definecurrentUrlString]]];
            //인증상태 배지정보최초 가져오기
            ////탭바제거
            [ApplicationDelegate performSelector:@selector(updateBadgeInfo:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.00f];
            return;
        }
        else {
            //단품네이티브 상단 장바구니를 모두 업데이트 하기위한 노티
            [[NSNotificationCenter defaultCenter] postNotificationName:PRODUCT_NATIVE_CARTUPDATE object:nil userInfo:nil];
            [delegate hideLoginViewController:self.loginViewType];
            NSLog(@"delegatedelegatedelegate = %@",delegate);
        }
    }
    
    //DATAHUB CALL
    //D_1032 비로그인상태 - 로그인 페이지 진입 - 아이디비번 입력 - 로그인버튼 클릭 - 로그인 완료시점
    @try {
        [[GSDataHubTracker sharedInstance] NeoCallGTMWithReqURL:@"D_1032" str2:nil str3:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"D_1032 ERROR : %@", exception);
    }
    @finally {
    }
    
    if([self.pushAnimation isEqualToString:@"rise"]) {
        self.pushAnimation = @"";
        [self.navigationController popViewControllerMoveInFromDown];
    }
    else {
        [self.navigationController popViewControllerMoveInFromTop];
    }
    //인증상태 배지정보최초 가져오기
    ////탭바제거
    [ApplicationDelegate performSelector:@selector(updateBadgeInfo:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.00f];
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONGOTOPNRELOADNOTI object:(NSNumber*)[NSNumber numberWithInt:1]];
    if ([NCS([result objectForKey:@"succMsg"]) length] > 2) {
        [Mocha_ToastMessage toastWithDuration:2.0 andText:[result objectForKey:@"succMsg"] inView:ApplicationDelegate.window];
    }
    
   
    simpleiddic = nil;
        
    
}

-(void)wkSessionSuccess{
    
    [self loginSuccessProcessWithBio:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)wkSessionSuccessFinger{
    
    [self loginSuccessProcessWithBio:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)wkSessionFail{
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    ApplicationDelegate.islogin = NO;
    Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GNET_ERRSERVER maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
    malert.tag = 1;
    [ApplicationDelegate.window addSubview:malert];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONGOTOPNRELOADNOTI object:[NSNumber numberWithInt:0]];
    
    simpleiddic = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark UICustomAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index {
    if(alert.tag ==1) {
        //로그인 인증 실패 시 확인. simpledic에 result 결과 가지고 있음
        //20161021 parksegun 방어코드 추가
        if(NCS([simpleiddic valueForKey:@"retTyp"]) && ([[simpleiddic valueForKey:@"retTyp"] intValue] == 10) && [NCS([simpleiddic valueForKey:@"retUrl"]) length] > 0) {
            NSString *tgurl = nil;
            if([NCS([simpleiddic valueForKey:@"retUrl"]) isEqualToString:@"/index.gs"] ){
                UIButton *dd = [[UIButton alloc] init];
                dd.tag = 0;
                [ApplicationDelegate.mainNVC popToRootViewControllerAnimated:NO];
                if([ApplicationDelegate.HMV respondsToSelector:@selector(firstProc)]) {
                    [ApplicationDelegate.HMV firstProc];
                }
                simpleiddic = nil;
                return;
            }
            else if([[simpleiddic valueForKey:@"retUrl"] hasPrefix:@"http"] ) {
                NSString *strTgurl = [simpleiddic valueForKey:@"retUrl"];
                // nami0342 - URL 인코딩 판단 후 디코딩 처리
                tgurl = [Common_Util getURLEndcodingCheck:strTgurl];
                //20181114 parksegun returnurl이 있으면 포함.
                if([NCS(deletargetURLstr) length] > 0) {
                    tgurl = [Common_Util makeUrlWithParam:tgurl parameter:[NSString stringWithFormat:@"returnurl=%@",[deletargetURLstr urlEncodedString]] ];
                }
                //20181115 parksegun 자동로그인
                if(sw_autologin.selected == YES) {
                    tgurl = [Common_Util makeUrlWithParam:tgurl parameter:[NSString stringWithFormat:@"appAutoLoginFlg=Y"] ];
                }
            }
            else {
                //http:// 등 프로토콜 정의가 없으면 기본도메인 붙여서 절대경로로
                tgurl = [NSString stringWithFormat:@"%@%@", SERVERURI, [simpleiddic valueForKey:@"retUrl"]];
            }
            ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:tgurl];
            resVC.view.tag = 505;
            [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
            simpleiddic = nil;
        }
        else if(NCS([simpleiddic valueForKey:@"retTyp"]) && ([[simpleiddic valueForKey:@"retTyp"] intValue] == 20) && [NCS([simpleiddic valueForKey:@"retUrl"]) length] > 0) {
            NSLog(@" retUrl = %@  ",   [simpleiddic valueForKey:@"retUrl"] );
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[simpleiddic valueForKey:@"retUrl"] ]];
            simpleiddic = nil;
        }
    }
    
    else if(alert.tag == 2) {
        //아래서 위로 올라오는 애니메이션이었으면 동일하게 맞춘다.
        if([self.pushAnimation isEqualToString:@"rise"]) {
            self.pushAnimation = @"";
            [self.navigationController popViewControllerMoveInFromDown];
        }
        else {
            [self.navigationController popViewControllerMoveInFromTop];
        }
    }
    else if (alert.tag == 3) {
        
    }
    //아이디 혹은 패스워드가 \n 입력 되지 않았습니다. 확인 tag = 5
    else if (alert.tag == 5) {
        [textFieldId performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1f];
    }
    
    else if (alert.tag == 555) {
        [self goLogin];
    }
    else if( alert.tag == 6) {//지문로그인 할래?
        if(index == 0) {
            // 아뇨
            privateFingerprintUseFlag = NO;
        }
        else {
            //네
            privateFingerprintUseFlag = YES;
            //지문 로그인 안내팝업 확인
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=414558")];
            //아이디창에 포커싱한다.
            [textFieldId performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0f];
        }
    }
    else if(alert.tag == 7) { //지문로그인 유도 // 위치 이동함.. appDelegete
        if(index == 0) {
            //다시안보기
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416702")];
            SL(@"YES",INFOFINGERPRINTSUGGEST);
            [[Common_Util sharedInstance] saveToLocalData];
        }
        else {
            //동의 -  지문로그인 활성화
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416703")];
             if([ApplicationDelegate isCanUseBioAuth]) {
                 [[DataManager sharedManager] GetLoginData];
                 SL([DataManager sharedManager].m_loginData,FINGERPRINT_USE_KEY);
                 SL(@"YES",INFOFINGERPRINTSUGGEST);
                 [[Common_Util sharedInstance] saveToLocalData];
             }
             else {                     // 지문을 단말기에 등록하세요.
                     [ApplicationDelegate touchIDSetting_Popup:0];
             }
        }
    }
}

- (void)errMessageForID:(NSString*)strMsg {
    self.lblIDErrorMessage.text = strMsg;
    self.IDerrorH.constant = 40;
}

- (void)errMessageForIDPass:(NSString*)strMsg {
    self.lblErrorMessage.text = strMsg;
    self.PWerrorH.constant = 24;
}


- (void)errMessageForIDPassClear {
    self.lblIDErrorMessage.text = @"";
    self.lblErrorMessage.text = @"";
    self.IDerrorH.constant = 8;
    self.PWerrorH.constant = 0;
}



#pragma mark -
#pragma mark TextField Delegate
// return NO to disallow editing. 텍스트필드를 터치 했을때

-(void)textFieldBorderInit {
//    viewMemberInput.layer.borderWidth = 1.0;
//    viewMemberInput.layer.shouldRasterize = YES;
//    viewMemberInput.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    viewMemberInput.layer.borderColor = [UIColor clearColor].CGColor;
  
}



- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self textFieldBorderInit];
    
    if ([textField isEqual:textFieldId]) {
        NSLog(@"");
    }
    if ([textField isEqual:textFieldPass]) {
        NSLog(@"textField.text = %@",textField.text);
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    textField.textColor = [UIColor blackColor];
    if ([textField isEqual:textFieldId]) {
        NSLog(@"");
    }
    if ([textField isEqual:textFieldPass]) {
        NSLog(@"textField.text = %@",textField.text);
    }
    [self textFieldBorderInit];
    return YES;
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:textFieldId]) {
        self.userId = textField.text;
        self.emailInputSupport.hidden = YES;
    }
    if ([textField isEqual:textFieldPass]) {
        NSLog(@"textField.text = %@",textField.text);
        self.userPass = textField.text;
    }//UISearchBar
}

- (IBAction)textFiledDidChangeIdPw:(id)txtfield {
    NSLog(@"");
    [self textFieldBorderInit];
   
    UITextField* txt = txtfield;
    if ([txt isEqual:textFieldId]) {
        self.userId = txt.text;
        [self emailSurppotShow];
    }
    
    if ([txt isEqual:textFieldPass]) {
        self.userPass = txt.text;
    }
    
    
   
    
    if ([self.textFieldId.text length] > 0 ) {
        self.btnClearId.hidden = NO;
    }
    else {
        self.btnClearId.hidden = YES;
    }
    
    if ([self.textFieldPass.text length] > 0 ) {
        self.btnClearPass.hidden = NO;
    }
    else {
        self.btnClearPass.hidden = YES;
    }
}

// return NO 면 텍스트 안바뀜
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // iOS UITextView에 패스워드 설정이 되어 있으면 텍스트창에 포커스를 잃은후 다시 입력이 들어오면 기존값을 제거하고 처음부터 입력함. - 기본설정임.
    // 이를 우회하기 위해 아래 코드 적용. 자동으로 날리는것을 막고 이전 입력 텍스트를 받아서 텍스트 필드에 넣도록 변경하는 코드임.
    if ([textField isEqual:textFieldPass]) {
        //Setting the new text.
        NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        textField.text = updatedString;
        //Setting the cursor at the right place
        NSRange selectedRange = NSMakeRange(range.location + string.length, 0);
        UITextPosition* from = [textField positionFromPosition:textField.beginningOfDocument offset:selectedRange.location];
        UITextPosition* to = [textField positionFromPosition:from offset:selectedRange.length];
        textField.selectedTextRange = [textField textRangeFromPosition:from toPosition:to];
        //Sending an action
        [textField sendActionsForControlEvents:UIControlEventEditingChanged];
        return NO;
    }
    else {
        return YES;
    }
    
}

// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([textField isEqual:textFieldId]) {
        self.userId = textField.text;
    }
    if ([textField isEqual:textFieldPass]) {
        self.userPass = textField.text;
    }
    return YES;
}

//UITextFiled delegate 입력한 텍스트 저장
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:textFieldId]) {
        self.userId = textField.text;
        [textFieldPass becomeFirstResponder]; //2번째로 포커스 이
    }
    if([textField isEqual:textFieldPass]) {
        //키보드 감춤 & 로그인!
        self.userPass = textField.text;
        [textFieldPass resignFirstResponder];//키보드 사라짐
    }
    [self textFieldBorderInit];
    [self pregoLogin];
    //여기서 바로 로그인
    return YES;
}

- (IBAction)onBtnClearButtons:(id)sender {
    UIButton *btnSender = (UIButton *)sender;
    if ([btnSender isEqual:self.btnClearId]) {
        self.btnClearId.hidden = YES;
        self.textFieldId.text = @"";
        [self.textFieldId becomeFirstResponder];
    }
    else if ([btnSender isEqual:self.btnClearPass]) {
        self.btnClearPass.hidden = YES;
        self.textFieldPass.text = @"";
        [self.textFieldPass becomeFirstResponder];
    }
}

-(void)onCursorTextFieldId {
    if(APPFULLHEIGHT == 480.0) {
        [scrview_baseforcenter setContentOffset:CGPointMake(0.0, 36.0) animated:YES];
    }
    else {
        [scrview_baseforcenter setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    }
}

-(void)onCursorTextFieldPassWord {
    if(APPFULLHEIGHT == 480.0){
        [scrview_baseforcenter setContentOffset:CGPointMake(0.0, 88.0) animated:YES];
    }else{
        [scrview_baseforcenter setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    }
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    NSLog(@"");
    
    self.isEditingTextField = YES;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,  [[UIScreen mainScreen] bounds].size.height, APPFULLWIDTH, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *prevBtn = [[UIBarButtonItem alloc] initWithTitle:GSSLocalizedString(@"common_txt_uibarbtn_prev") style:UIBarButtonItemStylePlain target:self action:@selector(textFieldPriv:)];
    [prevBtn setTag:textField.tag];
    
    if (prevBtn.tag < 102) {
        [prevBtn setEnabled:NO];
    }

    if(textField.tag == 101) {
        textFieldId.textColor = [UIColor getColor:@"111111" alpha:1.00 defaultColor:UIColor.blackColor];
        textFieldPass.textColor = [UIColor getColor:@"111111" alpha:0.48 defaultColor:UIColor.blackColor];
        [self emailSurppotShow];
    }
    else {
        textFieldId.textColor = [UIColor getColor:@"111111" alpha:0.48 defaultColor:UIColor.blackColor];
        textFieldPass.textColor = [UIColor getColor:@"111111" alpha:1.00 defaultColor:UIColor.blackColor];
    }
    
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:GSSLocalizedString(@"common_txt_uibarbtn_next") style:UIBarButtonItemStylePlain target:self action:@selector(textFieldNext:)];
    [nextBtn setTag:textField.tag];
    if (nextBtn.tag > 101) {
        [nextBtn setEnabled:NO];
    }
    
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:GSSLocalizedString(@"common_txt_alert_btn_complete") style:UIBarButtonItemStylePlain target:self action:@selector(textFieldCancel)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:prevBtn, nextBtn, flexibleSpace, closeBtn, nil] animated:YES];
    if(textField ==textFieldId){
        textFieldId.inputAccessoryView = toolBar;
        [self performSelector:@selector(onCursorTextFieldId) withObject:nil afterDelay:0.1];
    }else if(textField == textFieldPass){
        textFieldPass.inputAccessoryView = toolBar;
        [self performSelector:@selector(onCursorTextFieldPassWord) withObject:nil afterDelay:0.1];
    }
    resignTextField = textField;
    
    //if (lconstViewMemberInput.constant != 103.0) {
        [self errMessageForIDPassClear];
    //}
    
    
    
    return  YES;
}

-(void)textFieldPriv:(UIBarButtonItem *)sender {
    UITextField *nextField = (UITextField *)[self.view viewWithTag:sender.tag-1];
    if (nextField != nil) {
        [nextField becomeFirstResponder];
    }
    else {
        [self textFieldCancel];
    }
}


-(void)textFieldNext:(UIBarButtonItem *)sender {
    UITextField *nextField = (UITextField *)[self.view viewWithTag:sender.tag+1];
    if (nextField != nil) {
        [nextField becomeFirstResponder];
    }
    else {
        [self textFieldCancel];
    }
}



-(void)clearTextFields{
    self.userId = @"";
    self.userPass = @"";
    textFieldId.text = @"";
    textFieldPass.text = @"";
    isLogining = NO;
    
    self.btnClearPass.hidden = YES;
    self.btnClearId.hidden = YES;
    
//    btn_gologin.backgroundColor = [Mocha_Util getColor:@"E8F1B5"];
//    btn_gologin.layer.borderColor = [Mocha_Util getColor:@"E1E9B0"].CGColor;
//    [btn_gologin setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateNormal];
//
    sw_autologin.selected = YES;
    
}


// start ---- 2012.02.27 로그인 인코딩 처리 (특수문자처리 오류) ---- start
// 문자열 교체 함수.
- (NSString *)ReplaceString:(NSString*)OriginalString findString:(NSString *)findstr replaceString:(NSString *)replstr {
    NSMutableString *mStr = [NSMutableString stringWithString:OriginalString];
    NSRange substr;
    substr = [mStr rangeOfString:findstr];
    
    while(substr.location != NSNotFound) {
        [mStr replaceCharactersInRange:substr withString:replstr];
        substr = [mStr rangeOfString:findstr];
    }
    
    NSString *rValue = [[NSString alloc] initWithString:mStr];
    return rValue;
}

// end ---- 2012.02.27 로그인 인코딩 처리 (특수문자처리 오류) ---- end

- (IBAction)goTVUserLogin:(id)sender {
    //targetUrl 이 있으면 포함해서 웹뷰 띄움.
    if( deletargetURLstr == NULL) {
        deletargetURLstr  = @"";
    }
    ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:TVUSERLOGIN(deletargetURLstr)];
    //20181017 parksegun 탭바 없애기
    [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
    
    // nami0342 - Amplitude
    NSDictionary *dicProp = [NSDictionary dictionaryWithObjectsAndKeys:@"로그인번호",@"action", nil];
    [ApplicationDelegate setAmplitudeEventWithProperties:@"Click_로그인_기능" properties:dicProp];
}

-(void) textFieldCancel {
    textFieldId.textColor = [UIColor getColor:@"111111" alpha:0.48 defaultColor:UIColor.blackColor];
    textFieldPass.textColor = [UIColor getColor:@"111111" alpha:0.48 defaultColor:UIColor.blackColor];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:textFieldId selector:@selector(becomeFirstResponder) object: nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:textFieldPass selector:@selector(becomeFirstResponder) object: nil];
    
    if (resignTextField != nil) {
        [resignTextField resignFirstResponder];
        resignTextField = nil;
    }
    
    if ([self.timerKeyboard isValid]) {
        [self.timerKeyboard invalidate];
        self.timerKeyboard = nil;
    }
   
}



-(IBAction) btn_ok_Press:(id)sender {
    UIButton* sbtn = sender;
    sbtn.selected = !sbtn.selected;
    sw_autologin.userInteractionEnabled = YES;
    sw_autologin.alpha = 1.0;
    
    if (sbtn.selected == NO) {
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416119")];
    }
}

- (void)btntouchAction:(id)sender {
    
    [self textFieldCancel];
    
    if([((UIButton *)sender) tag] == 1005)  {
        //사업자정보
        
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:GSCOMPANYINFOTURL]];
        
        
        return;
    }else if([((UIButton *)sender) tag] == 1006)  {
        //채무지급보증
        
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:GSCOMPANYGUARANTEEURL]];
        
        
        return;
        
    }
    
    else if([((UIButton *)sender) tag] == 1002)
    {
        
        //이용약관
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:MANUALGUIDEFOOTERURL];
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
        
    }
    else if([((UIButton *)sender) tag] == 1003)
    {
        //결제안내
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:PAYGUIDEIPHONEFOOTERURL];
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
        
    }
    else if([((UIButton *)sender) tag] == 1004)
    {
        //고객센터
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:CUSTOMERCENTERFOOTERURL];
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
    
    
    else if([((UIButton *)sender) tag] == 1007)
    {
        //앱알림 설정
        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
        
        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
    }
    else if([((UIButton *)sender) tag] == 1009)
    {
        //개인정보 취급방침
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlStringByNoTab:PRIVATEINFOFOOTERURL];
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
    else if([((UIButton *)sender) tag] == 1010)
    {
        //청소년 보호정책
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlStringByNoTab:TEENAGERPOLICYFOOTERURL];
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
    //1050 : 10x10
    //1051: 29cm
    //1052: call
    else if([((UIButton *)sender) tag] == 1050)  {
        //10x10
        
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:FAMILY_10X10]];
        return;
        
    }    
    else if([((UIButton *)sender) tag] == 1052)
    {// call
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=415448")];
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:CUSTOMCENTER_TEL]];
        return;
    }
    else if([((UIButton *)sender) tag] == 1053)
    {// 2017.08.24 nPoint 추가
        
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:FAMILY_NPOINT]];
        return;
    }
    
    else {
        
    }
}

-(IBAction)onBtnLoginOnlyFooter:(id)sender{

    [self textFieldCancel];
    
    if([((UIButton *)sender) tag] == 401)  {
        //공지사항
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:GSNOTICEFOOTERURL];
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
        
    }else if([((UIButton *)sender) tag] == 402)  {
        //고객서비스
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:GSSERVICEFOOTERURL];
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌        
    }else if([((UIButton *)sender) tag] == 404){
        //설정
        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
        
    }else{
        
    }
}

#pragma mark - SNS Login Kakao

-(IBAction)onBtnKakaoLogin:(id)sender{
    
    //지문 로그인 개편때 수정
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416115")];
    
    [self textFieldCancel];
    
    [[KOSession sharedSession] close];
    
    //옵션 더있음
    
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        if ([[KOSession sharedSession] isOpen]) {
            NSLog(@"kakao Login Succeeded.");
            
            [strLoginType setString:@"TYPE_OAUTH"];
            [strSNSType setString:@"KA"];
            [strAccessToken setString:[KOSession sharedSession].token.accessToken];
            [strRefreshToken setString:[KOSession sharedSession].token.refreshToken];
            
            //fingerprint 성공시 만약에 설정되어 있을 지문로그인 플래그를 해제 한다. 로그인 프로세스에 성공하면
            privateFingerprintUseFlag = NO;
            [self goLogin];
            
        }else{
            NSLog(@"kakao Login Failed.");
        }
    }];
    //sns로그인을 시도 할때 플래그 활성화
    snsLoginFlag = YES;
    
    // nami0342 - Amplitude
    NSDictionary *dicProp = [NSDictionary dictionaryWithObjectsAndKeys:@"카카오",@"action", nil];
    [ApplicationDelegate setAmplitudeEventWithProperties:@"Click_로그인_기능" properties:dicProp];
}


- (IBAction)onBtnNaverLogin:(id)sender{
    //지문 로그인 개편때 수정
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416114")];
    
    // NaverThirdPartyLoginConnection의 인스턴스에 인증을 요청합니다.
    NaverThirdPartyLoginConnection *tlogin = [NaverThirdPartyLoginConnection getSharedInstance];
    tlogin.delegate = self;
    [tlogin requestThirdPartyLogin];
    
    [self textFieldCancel];
    
    //sns로그인을 시도 할때 플래그 활성화
    snsLoginFlag = YES;
    
    // nami0342 - Amplitude
    NSDictionary *dicProp = [NSDictionary dictionaryWithObjectsAndKeys:@"네이버",@"action", nil];
    [ApplicationDelegate setAmplitudeEventWithProperties:@"Click_로그인_기능" properties:dicProp];

}


// nami0342 : Apple ID 로그인
- (IBAction) onBtnAppleIDLogin :(id)sender{
    // 효율코드 -
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=419336")];
    
    [self textFieldCancel];
    //sns로그인을 시도 할때 플래그 활성화
    
    if (@available(iOS 13.0, *)) {
        
        NSString *strAppleUserId =[[NSUserDefaults standardUserDefaults] objectForKey:APPLEIDCREDENTIALKEY];
        if([NCS(strAppleUserId) length] > 0)
        {
            [self perfomExistingAccountSetupFlows];
        }
        else
        {
            [self showAppleLogin];
        }
    }
    

    
    // nami0342 - Amplitude
    NSDictionary *dicProp = [NSDictionary dictionaryWithObjectsAndKeys:@"애플ID",@"action", nil];
    [ApplicationDelegate setAmplitudeEventWithProperties:@"Click_로그인_기능" properties:dicProp];
    
}


- (void)requestAccessTokenWithRefreshToken
{
    NaverThirdPartyLoginConnection *tlogin = [NaverThirdPartyLoginConnection getSharedInstance];
    [tlogin requestAccessTokenWithRefreshToken];
}

- (void)resetToken
{
    [_thirdPartyLoginConn resetToken];
}

- (void)requestDeleteToken
{
    NaverThirdPartyLoginConnection *tlogin = [NaverThirdPartyLoginConnection getSharedInstance];
    [tlogin requestDeleteToken];
}

- (void)setAuthType:(NSString *)strType{
    [strLoginType setString:strType];
    [textFieldId performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1f];
}

- (void)setAuthClean{
    [strLoginType setString:@"TYPE_LOGIN"];
    [strSNSType setString:@""];
    [strAccessToken setString:@""];
    [strRefreshToken setString:@""];
}


- (void)snsAccessUrlMove:(NSString *)strUrl{
    
    [strLoginType setString:@"TYPE_MAPPING"];
    
    ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:strUrl];
    resVC.view.tag = 505;
    [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
}

#pragma mark - Naver auth deleagate

- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailWithError:(NSError *)error {
        NSLog(@"%s=[%@]", __FUNCTION__, error);
    //[_mainView setResultLabelText:[NSString stringWithFormat:@"%@", error]];
}

- (void)oauth20ConnectionDidFinishRequestACTokenWithAuthCode {
    
    NSLog(@"%@",[NSString stringWithFormat:@"OAuth Success!\n\nAccess Token - %@\n\nAccess Token Expire Date- %@\n\nRefresh Token - %@", _thirdPartyLoginConn.accessToken, _thirdPartyLoginConn.accessTokenExpireDate, _thirdPartyLoginConn.refreshToken])
    
    [strLoginType setString:@"TYPE_OAUTH"];
    [strSNSType setString:@"NA"];
    [strAccessToken setString:_thirdPartyLoginConn.accessToken];
    [strRefreshToken setString:_thirdPartyLoginConn.refreshToken];
    //fingerprint 성공시 만약에 설정되어 있을 지문로그인 플래그를 해제 한다. 로그인 프로세스에 성공하면
    privateFingerprintUseFlag = NO;
    [self goLogin];
}

- (void)oauth20ConnectionDidFinishRequestACTokenWithRefreshToken {
    
    NSLog(@"%@",[NSString stringWithFormat:@"Refresh Success!\n\nAccess Token - %@\n\nAccess sToken ExpireDate- %@", _thirdPartyLoginConn.accessToken, _thirdPartyLoginConn.accessTokenExpireDate ]);
    
    [strLoginType setString:@"TYPE_OAUTH"];
    [strSNSType setString:@"NA"];
    [strAccessToken setString:_thirdPartyLoginConn.accessToken];
    [strRefreshToken setString:_thirdPartyLoginConn.refreshToken];
    //fingerprint 성공시 만약에 설정되어 있을 지문로그인 플래그를 해제 한다. 로그인 프로세스에 성공하면
    privateFingerprintUseFlag = NO;
    [self goLogin];
    
}
- (void)oauth20ConnectionDidFinishDeleteToken {
    NSLog(@"로그아웃 완료");
}


// 20170508 parksegun 이메일입력 테이블
#pragma mark - Email TableView
-(void)tableViewRegisterNib{
    
    [self.emailTable registerNib:[UINib nibWithNibName:@"emailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"emailCell"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [emailTemplite count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    emailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emailCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
   
    NSArray *arr = [self.textFieldId.text componentsSeparatedByString:@"@"];

    if([arr count] > 0)
    {
        NSString *tempId = [arr objectAtIndex:0];
        cell.idText.text = [NSString stringWithFormat:@"%@@",tempId];
        if([emailTemplite count] > indexPath.row){
            cell.domainText.text = [emailTemplite objectAtIndex:indexPath.row];
        }
    }
    
    return  cell;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr = [self.textFieldId.text componentsSeparatedByString:@"@"];
    
    if([arr count] > 0)
    {
        NSString *tempId = [arr objectAtIndex:0];
        if([emailTemplite count] > indexPath.row){
            self.textFieldId.text = [NSString stringWithFormat:@"%@@%@",tempId, [emailTemplite objectAtIndex:indexPath.row]  ];
        }
    }
    
    self.emailInputSupport.hidden = YES;
    
}

-(void) emailSurppotShow{
    if( [Mocha_Util strContain:@"@" srcstring:textFieldId.text] ) {
        
        self.emailInputSupport.hidden = NO;
        
        //@ 뒤에 오는 데이터로 자동완성 만들기
        NSArray *arr = [self.textFieldId.text componentsSeparatedByString:@"@"];
        
        if([arr count] > 1) {
            NSString *tempText = [arr objectAtIndex:1];
            
            if(tempText.length > 0) {
                
                [emailTemplite removeAllObjects];
                for (NSString* domain in emailSet) {
                    //if( [Mocha_Util strContain:tempText srcstring:domain] )
                    if( [domain.uppercaseString hasPrefix:tempText.uppercaseString] ) {
                        [emailTemplite addObject:domain];
                    }
                }
            }
            else {
                [emailTemplite removeAllObjects];
                [emailTemplite setArray:emailSet];
            }
        }
        else {
            [emailTemplite removeAllObjects];
            [emailTemplite setArray:emailSet];
        }
        
        if([emailTemplite count] == 0) {
            self.emailInputSupport.hidden = YES;
        }
        else {
                      
            //아이폰에 따라 노출 갯수가 다르다.
            // 기본높이 256 = 48*5 + 8
            int flag = APPFULLHEIGHT - 267 -48 - 66 - STATUSBAR_HEIGHT;
            if(flag > 256) {
                self.emailInputSupportHeight.constant = 256.0;
            }
            else {
                int etc = ((flag-8)/48);
                if(etc > 5){
                    self.emailInputSupportHeight.constant = 256.0;
                }
                else {
                    self.emailInputSupportHeight.constant = (etc * 48) + 8;
                }
            }
            
            [self.emailInputSupport layoutIfNeeded];
            [self.emailTable reloadData];
        }
    }
    else {
        self.emailInputSupport.hidden = YES;
    }
}




#pragma mark
#pragma mark Apple ID

- (void)observeAppleSignInState {
    if (@available(iOS 13.0, *)) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handleSignInWithAppleStateRevoked:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

- (void)handleSignInWithAppleStateRevoked:(id)noti {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", noti);

    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:APPLEIDCREDENTIALKEY];
    
}

- (void)perfomExistingAccountSetupFlows {
    if (@available(iOS 13.0, *)) {
        
        NSString *strAppleUserId =[[NSUserDefaults standardUserDefaults] objectForKey:APPLEIDCREDENTIALKEY];
                ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        
                [appleIDProvider getCredentialStateForUserID:strAppleUserId completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
        
                    if (credentialState == ASAuthorizationAppleIDProviderCredentialAuthorized) {
                        NSLog(@"ASAuthorizationAppleIDProviderCredentialAuthorized");
                    }else {
                        if (credentialState == ASAuthorizationAppleIDProviderCredentialRevoked) {
                            NSLog(@"ASAuthorizationAppleIDProviderCredentialRevoked");
                        }else if (credentialState == ASAuthorizationAppleIDProviderCredentialNotFound) {
                            NSLog(@"ASAuthorizationAppleIDProviderCredentialNotFound");
                        }else if (credentialState == ASAuthorizationAppleIDProviderCredentialTransferred) {
                            NSLog(@"ASAuthorizationAppleIDProviderCredentialTransferred");
                        }
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:APPLEIDCREDENTIALKEY];
                    }
                    
                    [self showAppleLogin];
                    
                }];
        
        
    }
}

-(void)showAppleLogin{
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        controller.delegate = self;
        controller.presentationContextProvider = self;
        [controller performRequests];
    }
}

// nami0342 - 성공 처리
 - (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){

    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", controller);
    NSLog(@"%@", authorization);

    NSLog(@"authorization.credential：%@", authorization.credential);
     
    // 효율코드 -
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=419340")];

    NSMutableString *mStr = [NSMutableString string];
//    mStr = [appleIDLoginInfoTextView.text mutableCopy];

    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:APPLEIDCREDENTIALKEY];
        [mStr appendString:user?:@""];
//        NSString *familyName = appleIDCredential.fullName.familyName;
//        [mStr appendString:familyName?:@""];
//        NSString *givenName = appleIDCredential.fullName.givenName;
//        [mStr appendString:givenName?:@""];
        NSString *email = appleIDCredential.email;
        [mStr appendString:email?:@""];
        NSLog(@"mStr：%@", mStr);
//        [mStr appendString:@"\n"];
//        appleIDLoginInfoTextView.text = mStr;

        snsLoginFlag = YES;
        [strAccessToken setString:user];
        [strLoginType setString:@"TYPE_OAUTH"];
        [strSNSType setString:@"AP"];

        [self goLogin];

    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *passwordCredential = authorization.credential;
        //GSSHOP으로 로그인했던 일반아이디,비번 값이 바로 내려옴 일반로그인으로 해결
        self.userId = NCS(passwordCredential.user);
        self.userPass = NCS(passwordCredential.password);
        [self goLogin];
    } else {
         mStr = [@"check" mutableCopy];
//        appleIDLoginInfoTextView.text = mStr;
    }
}

// nami0342 - 실패 처리
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
    // 효율코드 -
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=419341")];

    NSLog(@"%s", __FUNCTION__);
    NSLog(@"error ：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"인증 작업을 취소하였습니다.";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"인증 처리에 실패하였습니다.";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"잘못된 인증 정보가 수신되었습니다.";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"처리할 수 없는 인증 오류입니다.";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"알 수 없는 인증 오류가 발생하였습니다.";
            break;
    }

//    NSMutableString *mStr = [appleIDLoginInfoTextView.text mutableCopy];
//    [mStr appendString:errorMsg];
//    [mStr appendString:@"\n"];
//    appleIDLoginInfoTextView.text = [mStr copy];

    if(error.code != ASAuthorizationErrorCanceled)
    {
        Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:errorMsg  maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        [ApplicationDelegate.window addSubview:malert];
        return;
    }

    
    if (error.localizedDescription) {
//        NSMutableString *mStr = [appleIDLoginInfoTextView.text mutableCopy];
//        [mStr appendString:error.localizedDescription];
//        [mStr appendString:@"\n"];
//        appleIDLoginInfoTextView.text = [mStr copy];
    }
    NSLog(@"controller requests：%@", controller.authorizationRequests);
    /*
     ((ASAuthorizationAppleIDRequest *)(controller.authorizationRequests[0])).requestedScopes
     <__NSArrayI 0x2821e2520>(
     full_name,
     email
     )
     */
}

//! Tells the delegate from which window it should present content to the user.
 -(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){

    NSLog(@"window：%s", __FUNCTION__);
    return self.view.window;
}

- (IBAction)btnDown:(id)sender {
    if([sender isEqual:btn_gologin]) {
        btn_gologin.backgroundColor = [UIColor getColor:@"BAD427" alpha:1.00 defaultColor:UIColor.blackColor];
    }
    else if([(UIButton*)sender tag] == 202006){
        self.loginNmView.backgroundColor = [UIColor getColor:@"000000" alpha:0.08 defaultColor:UIColor.clearColor];
    }
    else {
        ((UIButton*)sender).backgroundColor = [UIColor getColor:@"000000" alpha:0.08 defaultColor:UIColor.clearColor];
    }
}

- (IBAction)btnUp:(id)sender {
    if([sender isEqual:btn_gologin]) {
           btn_gologin.backgroundColor = [UIColor getColor:@"cae72b" alpha:1.00 defaultColor:UIColor.blackColor];
    }
    else if([(UIButton*)sender tag] == 202006){
       self.loginNmView.backgroundColor = [UIColor getColor:@"000000" alpha:0.00 defaultColor:UIColor.clearColor];
    }
    else {
        ((UIButton*)sender).backgroundColor = [UIColor getColor:@"FFFFFF" alpha:1.00 defaultColor:UIColor.clearColor];
    }
}

- (IBAction)btnCancel:(id)sender {
    if([sender isEqual:btn_gologin]) {
           btn_gologin.backgroundColor = [UIColor getColor:@"cae72b" alpha:1.00 defaultColor:UIColor.blackColor];
    }
    else if([(UIButton*)sender tag] == 202006){
       self.loginNmView.backgroundColor = [UIColor getColor:@"000000" alpha:0.00 defaultColor:UIColor.clearColor];
    }
    else {
        ((UIButton*)sender).backgroundColor = [UIColor getColor:@"FFFFFF" alpha:1.00 defaultColor:UIColor.clearColor];
    }
}


@end
