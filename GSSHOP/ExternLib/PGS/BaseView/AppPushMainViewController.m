#import "AppPushMainViewController.h"
#import "AppPushConstants.h"
#import "AppPushNetworkAPI.h"
#import "AmailJSON.h"
#import "AmailActivityView.h"
#import "AppPushConstants.h"
#import "AppPushUtil.h"
#import "AmailPopUpView.h"
#import <sys/sysctl.h>
#define LIST_ROW_NUM    50

@implementation AppPushMainViewController
NSString *presentDate = nil;
NSString *retainFlag = nil;
@synthesize delegate;
@synthesize vcMsg;
@synthesize isShowPGS,isChangeUser;
@synthesize isCert,curGroupCode;

- (id)init {
    @try {
        self = [super init];
        if (self) {
            isCert = APPPUSH_DEF_CERT_NOT;
            currentPageNum = 1;
            dicRead = [[NSMutableDictionary alloc] init];
            dicNoti = [[NSMutableDictionary alloc] init];
            dicMsg = [[NSMutableDictionary alloc] init];
            
            [self initMainView];
            //[self showMainView];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController init : %@", exception);
    }
    return self;
}
- (void)viewDidLoad
{
    @try {
        
        [super viewDidLoad];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reDeviceCert)
                                                     name:APPPUSH_DEF_NOTI_REDEVICE_CERT
                                                   object:nil];
        
        
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController viewDidLoad : %@", exception);
    }
}

- (void) subViewchangePropertyForScrollsToTop:(UIView *)sview boolval:(BOOL)val{
    
    BOOL isch = NO;
    for (UIView *subview in sview.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            NSLog(@"setscroll전 stat = %i", [(UIScrollView*)subview scrollsToTop] );
            if
                ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"UIScrollView"])
                
            {
                if(!isch){
                    ((UIScrollView *)subview).scrollsToTop = val;
                    isch = YES;
                }
            }else {
                
                ((UIScrollView *)subview).scrollsToTop = val;
                
            }
            NSLog(@"  %@",   [NSString stringWithFormat:@"%s",   object_getClassName(subview)]);
            NSLog(@"setscroll  stat = %i", [(UIScrollView*)subview scrollsToTop] );
            
        }
        [self subViewchangePropertyForScrollsToTop:subview boolval:val];
    }
}


//
//- (void)viewDidUnload
//{
//    @try {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_DEF_NOTI_REDEVICE_CERT object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_DEF_NOTI_SET_THEME object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_NOTI_READ_MESSAGE object:nil];
//        [super viewDidUnload];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"PMS Exception at AppPushMainViewController viewDidUnload : %@", exception);
//    }
//}


// nami0342
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotate {
    return NO;
}


#pragma mark - Inner method

- (void)setNotiDic:(NSDictionary *)argDic notiTime:(int)argNotiTime {
    @try {
        if(dicNoti==nil) dicNoti = [[NSMutableDictionary alloc] init];
        [dicNoti setDictionary:argDic];
        notiTime = argNotiTime;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController setNotiDic : %@", exception);
    }
}

- (void)initMainView {
    @try {
        if(ivTitle==nil) {
            vcMsgRich = [[AppPushMessageRichViewController alloc] init];
            vcMsgRich.delegate = self;
            [vcMsgRich.view setFrame:CGRectMake(0.0f, 0.0f, AMAIL_POPUP_WIDTH, AMAIL_POPUP_HEIGHT)];
            [vcMsgRich viewInitalization];
            
            //int version =  [[UIDevice currentDevice] systemVersion].intValue;
            
            //화면 초기화
            
            ivNoti = [[UIImageView alloc] init];
            ivNoti.backgroundColor = [Mocha_Util getColor:@"F4F4F4"];
            /*
             if(version<6) {
             [ivNoti setImage:[[UIImage imageNamed:@"PMS.bundle/image/pms_alerts_bg_notice.png"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:15.0f]];
             } else {
             [ivNoti setImage:[[UIImage imageNamed:@"PMS.bundle/image/pms_alerts_bg_notice.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0f, 15.0f, 3.0f, 15.0f)                                                                                    resizingMode:UIImageResizingModeStretch]];
             }
             */
            //  [ivNoti setImage:[UIImage imageNamed:@"PMS.bundle/image/pms_notice_message.png"]];
            ivNoti.alpha = 0.5;
            [self.view addSubview:ivNoti];
            
            
            ivTitle = [[UIImageView alloc] init];
            [ivTitle setImage:[UIImage imageNamed:@"common_top_bar_bg.png"]];
            /*
             if(version<6) {
             [ivTitle setImage:[[UIImage imageNamed:@"PMS.bundle/image/pms_alerts_bg_title.png"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:23.0f]];
             } else {
             [ivTitle setImage:[[UIImage imageNamed:@"PMS.bundle/image/pms_alerts_bg_title.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0f, 23.0f, 3.0f, 23.0f)                                                                                    resizingMode:UIImageResizingModeStretch]];
             }
             */
            [self.view addSubview:ivTitle];
            
            
            lblTitle = [[UILabel alloc] init];
            [lblTitle setTextAlignment:NSTextAlignmentCenter];
            [lblTitle setFont:[UIFont boldSystemFontOfSize:17.0f]];
            [lblTitle setTextColor:[Mocha_Util getColor:@"111111"]];
            [lblTitle setBackgroundColor:[UIColor clearColor]];
            [lblTitle setText:GSSLocalizedString(@"pms_title")];
            [self.view addSubview:lblTitle];
            
            btnClose = [[UIButton alloc] init];
            [btnClose setImage:[UIImage imageNamed:@"6_top_bar_close.png"] forState:UIControlStateNormal];
            [btnClose setImage:[UIImage imageNamed:@"6_top_bar_close.png"] forState:UIControlStateHighlighted];
            [btnClose addTarget:self action:@selector(pressClose:) forControlEvents:UIControlEventTouchUpInside];
            
            btnClose.imageEdgeInsets  = UIEdgeInsetsMake(10, 10, 10, 10);
            [self.view addSubview:btnClose];
            
            /*
             lblNoti1 = [[UILabel alloc] init];
             [lblNoti1 setTextAlignment:NSTextAlignmentLeft];
             [lblNoti1 setFont:[UIFont boldSystemFontOfSize:13.0f]];
             [lblNoti1 setTextColor:AMAIL_RGB(255, 255, 255)];
             [lblNoti1 setBackgroundColor:[UIColor clearColor]];
             [lblNoti1 setText:@"잠깐!"];
             [self.view addSubview:lblNoti1];
             */
            
            vcMsg = [[AppPushMessageViewController alloc] init];
            vcMsg.delegate = self;
            [self.view addSubview:vcMsg.view];
            
            
            
            
            UIButton* cbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [cbtn1 setFrame:CGRectMake(10,55,120,20)];
            
            cbtn1.backgroundColor = [Mocha_Util getColor:@"F4F4F4"];
            [cbtn1 setTitle:GSSLocalizedString(@"common_txt_alert_title_pms")  forState:UIControlStateNormal];
            [cbtn1 setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
            cbtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
            cbtn1.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            
            
            [cbtn1.layer setMasksToBounds:NO];
            cbtn1.layer.shadowOffset = CGSizeMake(0, 0);
            cbtn1.layer.shadowRadius = 0.0;
            cbtn1.layer.borderColor = [Mocha_Util getColor:@"CFCFCF"].CGColor;
            cbtn1.layer.borderWidth = ([Common_Util isRetinaScale])?0.5:1.0;
            //   cbtn1.layer.shadowPath = [UIBezierPath bezierPathWithRect:cbtn1.bounds].CGPath;
            [self.view addSubview:cbtn1];
            
            
            
            
            
            
            lblNoti2 = [[UILabel alloc] init];
            [lblNoti2 setTextAlignment:NSTextAlignmentLeft];
            [lblNoti2 setFont:[UIFont systemFontOfSize:11.0f]];
            [lblNoti2 setTextColor:[Mocha_Util getColor:@"888888"]];
            [lblNoti2 setBackgroundColor:[UIColor clearColor]];
            [lblNoti2 setText:GSSLocalizedString(@"pms_notice2")];
            [lblNoti2 setLineBreakMode:NSLineBreakByWordWrapping];
            [lblNoti2 setNumberOfLines:2];
            
            [self.view addSubview:lblNoti2];
            
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *tempMsgFlag = [userDefaults valueForKey:APPPUSH_DEF_MSG_FLAG];
            
            
            if(tempMsgFlag!=nil && [tempMsgFlag isEqualToString:@"Y"]) {
                isMsgFlag = YES;
            } else {
                isMsgFlag = NO;
            }
            
        }
        
        [AmailKeyboardActivityView removeViewAnimated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController initMainView : %@", exception);
    }
}
/*
 //회전 관련 메서드
 #define degreesToRadian(x) (M_PI * (x) / 180.0)
 - (void) rotateLandscape:(UIDeviceOrientation)argOrientation {
 // Screen Size of Portrait.
 CGRect screenBounds = [[UIScreen mainScreen] bounds];
 int kWidth = screenBounds.size.width;
 int kHeight = screenBounds.size.height;
 
 CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
 //NSLog(@"window root view heigth : %f",statusBarFrame.size.height);
 int kStatusHeight = statusBarFrame.size.height;
 
 // Status Bar 로테이션 설정
 //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
 
 if(argOrientation==UIDeviceOrientationLandscapeLeft) {
 self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
 } else if(argOrientation==UIDeviceOrientationLandscapeRight){
 self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(-90));
 } else {
 self.view.transform = CGAffineTransformMakeRotation(0);
 }
 
 //    self.view.frame = CGRectMake(0, 0, 300, 480);
 //    self.view.bounds = CGRectMake(0, 0, 480, 300);
 
 self.view.frame =  CGRectMake(0, 0, kWidth - kStatusHeight, kHeight);
 self.view.bounds = CGRectMake(0, 0, kHeight, kWidth - kStatusHeight);
 }
 */
- (void)showMainView {
    @try {
        
        //[self rotateLandscape:[UIDevice currentDevice].orientation];
        
        //Portrait
        [ivTitle setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 50.0f)];
        
        [lblTitle setFrame:CGRectMake((int)(ivTitle.center.x - (200.0f/2)), (int)(ivTitle.center.y - (22.0f/2)), 200.0f, 22.0f)];
        
        [btnClose setFrame:CGRectMake(self.view.frame.size.width - 36.0f,
                                      (int)(ivTitle.center.y - (36.0f/2)),
                                      36.0f,
                                      36.0f)];
        
        btnClose.backgroundColor = [UIColor clearColor];
        
        
        //수신일로부터 헤더view
        [ivNoti setFrame:CGRectMake(0.0f, 45, self.view.frame.size.width, 40.0f)];
        
        
        
        //[lblNoti2 setFrame:CGRectMake(50.0f, (int)(ivNoti.center.y - (22.0f/2)), 280.0f, 22.0f)];
        [lblNoti2 setFrame:CGRectMake(135.0f, 45.0 , APPFULLWIDTH - 140.0, 40.0f)];
        
        
        [vcMsg.view setFrame:CGRectMake(0.0f,
                                        85,
                                        self.view.frame.size.width,
                                        self.view.frame.size.height - 85)];
        
        
        //[vcMsg.tableView reloadData];
        
        [[AppPushDatabase sharedInstance] truncateMsg];
        //메세지로드 주석1
        //        [vcMsg loadMsgView:nil];
        
        [vcMsg setViewFrame];
        
        [self subViewchangePropertyForScrollsToTop:vcMsg.view boolval:NO];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController showMainView : %@", exception);
    }
}

- (void)certProcess {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults valueForKey:APPPUSH_DEF_APNS_TOKEN]!=nil) {
            if(isCert == APPPUSH_DEF_CERT_NOT) {
                //최초인증
                [self deviceCert];
            } else if(isCert == APPPUSH_DEF_CERT_LOADING){
                if(isShowPGS) {
                    [AmailBezelActivityView activityViewForView:vcMsg.view withLabel:@"인증 중..."];
                }
            }
        } else {
            if(isShowPGS) {
                
                [ApplicationDelegate offloadingindicator];
                
                Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"PMS_auth_error_msg") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                [ApplicationDelegate.window addSubview:malert];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController certProcess : %@", exception);
    }
}

- (void)pressShow {
    @try {
        [self certProcess];
        if(isCert==APPPUSH_DEF_CERT_DONE) {
            
            //GS의 요청으로 항시 갱신으로 변경
            [[AppPushDatabase sharedInstance] truncateMsg];
            [self getNewMsg:nil
                    msgCode:nil
                 courseType:@"P"];
            //메세지로드 주석2
            //            [vcMsg loadMsgView:nil];
            
            //            [self getNewMsg:[[AppPushDatabase sharedInstance] getMsgId:@"ORDER BY CAST(MSG_ID AS INTEGER) DESC LIMIT 1"]
            //                    msgCode:nil
            //                 courseType:nil];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController pressShow : %@", exception);
    }
}

- (void)pressClose:(id)sender {
    @try {
        
        [ApplicationDelegate offloadingindicator];
        [delegate closePMS];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController pressClose : %@", exception);
    }
}

- (void)notiUnReadMessage:(BOOL)argIsCert {
    @try {
        
        int totalCount = [self findUnReadMessage:argIsCert];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         totalCount>0?@"You have new notification":@"You have no notification",              @"message",
                                                         [NSString stringWithFormat:@"%d",totalCount],           @"count",
                                                         nil]
                                                 forKey:APPPUSH_DEF_NEW_RECEIVE_MESSAGE];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:APPPUSH_DEF_NOTI_RECEIVE_MESSAGE
                                                            object:nil
                                                          userInfo:nil];
        
        [delegate updateNewMessageCount:totalCount];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController notiUnReadMessage : %@", exception);
    }
}
- (int)findUnReadMessage:(BOOL)argIsCert {
    @try {
        int totalCount = 0;
        if(argIsCert) {
            totalCount = [[[NSUserDefaults standardUserDefaults] valueForKey:APPPUSH_DEF_NEW_MSG_COUNT] intValue];
            //+ [[AppPushDatabase sharedInstance] getAllNewMsgCntMsg];
        } else {
            totalCount = [[AppPushDatabase sharedInstance] getAllNewMsgCntMsg];
        }
        //NSLog(@"totalCount:%d",totalCount);
        return totalCount;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController findUnReadMessage : %@", exception);
        return 0;
    }
}
- (void)reDeviceCert {
    @try {
        if(isCert == APPPUSH_DEF_CERT_DONE) {
            isCert = APPPUSH_DEF_CERT_NOT;
            [self startCert];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController reDeviceCert : %@", exception);
    }
}

- (void)setMsgFlag:(BOOL)argIsMsg {
    @try {
        isTempMsgFlag = argIsMsg;
        if(isCert==APPPUSH_DEF_CERT_DONE) {
            [self performSelectorOnMainThread:@selector(setMsgStatusByApp) withObject:nil waitUntilDone:NO];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController setMsgFlag : %@", exception);
    }
}

- (NSString *)getDeviceInfo {
    @try {
        
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *platform = [NSString stringWithUTF8String:machine];
        free(machine);
        
        return platform;
        
        //http://www.everymac.com 스펙 참고
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController getPlatformInfo : %@",exception);
        return @"Define Fail";
    }
}


- (BOOL)saveNewMsg:(NSArray *)argArrNewMsg {
    
    if(argArrNewMsg==nil) return NO;
    BOOL isAdd = NO;
    
    @try {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        NSString *presentDate = [df stringFromDate:[NSDate date]];
        
        //        NSLog(@"argArrNewMsg %@",argArrNewMsg);
        //EXP_DATE가 지난 메시지가 들어온 경우 무시처리 만들기
        for(NSDictionary *dic in argArrNewMsg) {
            //TITLE, MSG, MSG_CODE, MSG_ID, MSG_TYPE, ATTACH_INFO, READ_YN, EXP_DATE, REG_DATE
            
            //            NSLog(@"new msg dic : %@",dic);
            
            if(![[AppPushDatabase sharedInstance] isMsg:[NSString stringWithFormat:@"WHERE MSG_ID = '%@'",[dic valueForKey:@"userMsgId"]]]) {
                
                if([MSG_TYPE_HTML isEqualToString:[dic valueForKey:@"msgType"]] ||
                   [MSG_TYPE_URL isEqualToString:[dic valueForKey:@"msgType"]]) {
                    
                    int minMsgCode = [[AppPushDatabase sharedInstance] getMinMsgCode];
                    if(minMsgCode>0) {
                        minMsgCode = -1;
                    } else {
                        minMsgCode--;
                    }
                    //NSLog(@"minMsgCode : %d",minMsgCode);
                    [dic setValue:[NSString stringWithFormat:@"%d",minMsgCode] forKey:@"msgGrpCd"];
                }
                
                NSString *expireDate = [dic valueForKey:@"expireDate"];
                //NSString *expireDate = @"20130117000000";
                expireDate = [expireDate substringToIndex:8];
                
                if([expireDate intValue] >= [presentDate intValue]) {
                    isAdd = YES;
                    NSString *uid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"msgUid"]];
                    if(!uid || [uid isEqualToString:@""]|| [uid isEqualToString:@"(null)"]){
                        uid = [dic valueForKey:@"msgId"];
                    }
                    NSString *appUserId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"appUserId"]];
                    if(!appUserId || [appUserId isEqualToString:@""] || [appUserId isEqualToString:@"(null)"]){
                        appUserId = [[NSUserDefaults standardUserDefaults] valueForKey:APPPUSH_DEF_APP_USER_ID];
                    }
                    
                    [self insertRowToMsgTable:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [dic valueForKey:@"msgGrpNm"]!=nil?[dic valueForKey:@"msgGrpNm"]:@"",
                                               AMAIL_MSG_TITLE,
                                               [dic valueForKey:@"msgText"]!=nil?[dic valueForKey:@"msgText"]:@"",
                                               AMAIL_MSG_MSG,
                                               [dic valueForKey:@"msgGrpCd"]!=nil?[dic valueForKey:@"msgGrpCd"]:@"",
                                               AMAIL_MSG_MSG_CODE,
                                               [dic valueForKey:@"userMsgId"]!=nil?[dic valueForKey:@"userMsgId"]:@"",
                                               AMAIL_MSG_MSG_ID,
                                               [dic valueForKey:@"msgId"]!=nil?[dic valueForKey:@"msgId"]:@"",
                                               AMAIL_MSG_COMMON_MSG_ID,
                                               [dic valueForKey:@"msgType"]!=nil?[dic valueForKey:@"msgType"]:@"",
                                               AMAIL_MSG_MSG_TYPE,
                                               [dic valueForKey:@"attachInfo"]!=nil?[dic valueForKey:@"attachInfo"]:@"",
                                               AMAIL_MSG_ATTACH_INFO,
                                               [dic valueForKey:@"readYn"]!=nil?[dic valueForKey:@"readYn"]:@"N",
                                               AMAIL_MSG_READ_YN,
                                               [dic valueForKey:@"expireDate"]!=nil?[dic valueForKey:@"expireDate"]:@"",
                                               AMAIL_MSG_EXP_DATE,
                                               [dic valueForKey:@"regDate"]!=nil?[dic valueForKey:@"regDate"]:@"",
                                               AMAIL_MSG_REG_DATE,
                                               [dic valueForKey:@"map1"]!=nil?[dic valueForKey:@"map1"]:@"",
                                               AMAIL_MSG_MAP1,
                                               [dic valueForKey:@"map2"]!=nil?[dic valueForKey:@"map2"]:@"",
                                               AMAIL_MSG_MAP2,
                                               [dic valueForKey:@"pushImg"]!=nil?[dic valueForKey:@"pushImg"]:@"",
                                               AMAIL_MSG_MAP3,
                                               [dic valueForKey:@"appLink"]!=nil?[dic valueForKey:@"appLink"]:@"",
                                               AMAIL_MSG_APP_LINK,
                                               [dic valueForKey:@"iconName"]!=nil?[dic valueForKey:@"iconName"]:@"",
                                               AMAIL_MSG_ICON_NAME,
                                               uid,
                                               AMAIL_MSG_UID,
                                               appUserId,
                                               AMAIL_MSG_APP_USER_ID,
                                               @"N",
                                               AMAIL_MSG_OWNER,
                                               nil]];
                    
                }
                
            }
            
        }
        return isAdd;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController saveNewMsg : %@", exception);
        return NO;
    }
}

- (void)insertRowToMsgTable:(NSDictionary *)argDic
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:argDic];
    NSDictionary *distinct = [[AppPushDatabase sharedInstance] checkDistinctMsgUid:[dict objectForKey:AMAIL_MSG_UID]];
    
    // 메시지 중복 발생!!
    if(distinct){
        // 중복이지만.. 이미 들어간게 내꺼 일때 그냥 Pass
        if([[distinct objectForKey:AMAIL_MSG_OWNER] isEqualToString:@"Y"]){
            return;
        }
        // 중복된 msg 삭제
        [[AppPushDatabase sharedInstance] deleteMsg:[NSString stringWithFormat:@"WHERE %@ = '%@'",AMAIL_MSG_ID,[distinct objectForKey:AMAIL_MSG_ID]]];
    }
    
    NSString *appUserId = [[NSUserDefaults standardUserDefaults] valueForKey:APPPUSH_DEF_APP_USER_ID];
    // MSG 주인 판별
    if([[dict objectForKey:AMAIL_MSG_APP_USER_ID] isEqualToString:appUserId]){
        [dict setValue:@"Y" forKey:AMAIL_MSG_OWNER];
    }else{
        [dict setValue:@"N" forKey:AMAIL_MSG_OWNER];
    }
    [[AppPushDatabase sharedInstance] addMsg:dict];
}


- (void)showRichView:(NSDictionary *)argDic {
    @try {
        if(!isPopUp) {
            isPopUp = YES;
            [vcMsgRich.view setFrame:CGRectMake(0.0f, 0.0f, AMAIL_POPUP_WIDTH, AMAIL_POPUP_HEIGHT)];
            [vcMsgRich setViewFrame:CGRectMake(0.0f, 0.0f, AMAIL_POPUP_WIDTH, AMAIL_POPUP_HEIGHT)];
            [vcMsgRich setMsgDic:argDic];
            
            [AmailPopUpView openCustomPopViewWithView:vcMsgRich.view backTouch:NO];
            
            [vcMsgRich loadRichView];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController showRichView : %@", exception);
    }
    
}

- (void)showTextView:(NSDictionary *)argDic {
    @try {
        
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if (!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:[argDic valueForKey:AMAIL_MSG_MSG]
                                                       maintitle:nil
                                                        delegate:self
                                                     buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"), @"보기", nil]];
        malert.tag=1000;
        [window addSubview:malert];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController showTextView : %@", exception);
    }
    
}


- (void)checkReadMessage {
    @try {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dicTemp = [userDefaults valueForKey:APPPUSH_DEF_READ_MESSAGE];
        
        if(dicTemp!=nil) {
            
            [dicRead setDictionary:dicTemp];
            
            NSArray *arrKeys = [dicRead allKeys];
            
            if(arrKeys!=nil && [arrKeys count] > 0) {
                
                NSString *strReadMsgIds = [dicRead valueForKey:[arrKeys objectAtIndex:0]];
                
                [self setReadMsg:strReadMsgIds readTag:[arrKeys objectAtIndex:0]];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController checkReadMessage : %@", exception);
    }
}
- (void)startLogin {
    @try {
        
        //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        //        NSString *uniqueDate = [userDefault valueForKey:APPPUSH_DEF_UNIQUE_DATE];
        //        NSDateFormatter *at_df = [[NSDateFormatter alloc] init];
        //        [at_df setDateFormat:@"yyyyMMdd"];
        //        presentDate = [[at_df stringFromDate:[NSDate date]] retain];
        
        
        // CRM do not use 2014. 11. 10
        if(isChangeUser) {
            isChangeUser = NO;
        }
        [self performSelectorOnMainThread:@selector(loginProcess) withObject:nil waitUntilDone:NO];
        
        /*
         if([userDefault valueForKey:APPPUSH_DEF_USER_CRM] == nil || isChangeUser) {
         isChangeUser = NO;
         [self performSelectorOnMainThread:@selector(getCRMData:) withObject:@"login" waitUntilDone:NO];
         } else {
         if([userDefault valueForKey:APPPUSH_DEF_USER_CRM] == nil) {
         //하루가 지난 경우
         [self performSelectorOnMainThread:@selector(getCRMData:) withObject:@"login" waitUntilDone:NO];
         } else {
         //하루가 안지난 경우
         [self performSelectorOnMainThread:@selector(loginProcess) withObject:nil waitUntilDone:NO];
         }
         }
         */
        
        //        if(uniqueDate == nil || isChangeUser) {
        //            isChangeUser = NO;
        //            [self performSelectorOnMainThread:@selector(getCRMData:) withObject:@"login" waitUntilDone:NO];
        //        } else {
        //            if([uniqueDate intValue] < [presentDate intValue]) {
        //                //하루가 지난 경우
        //                [self performSelectorOnMainThread:@selector(getCRMData:) withObject:@"login" waitUntilDone:NO];
        //            } else {
        //                //하루가 안지난 경우
        //                [self performSelectorOnMainThread:@selector(login) withObject:nil waitUntilDone:NO];
        //            }
        //        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController startLogin : %@", exception);
    }
}

- (void)startLogout {
    @try {
        
        [self performSelectorOnMainThread:@selector(logoutProcess) withObject:nil waitUntilDone:NO];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController startLogout : %@", exception);
    }
}

- (void)deviceCert {
    
    @try {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userId = [NSString stringWithFormat:@"%@", [userDefault valueForKey:APPPUSH_DEF_USER_ID]];
        if(userId!=nil && userId.length>0) {
            //userId가 존재하는 경우
            //NSString *uniqueDate = [userDefault valueForKey:APPPUSH_DEF_UNIQUE_DATE];
            //NSDateFormatter *at_df = [[NSDateFormatter alloc] init];
            //[at_df setDateFormat:@"yyyyMMdd"];
            //presentDate = [[at_df stringFromDate:[NSDate date]] retain];
            
            // CRM do not use 2014. 11. 10
            if([userDefault valueForKey:APPPUSH_DEF_USER_CRM] == nil || isChangeUser) {
                isChangeUser = NO;
            }
        }
        [self performSelectorOnMainThread:@selector(startCert) withObject:nil waitUntilDone:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController deviceCert : %@", exception);
    }
    
    
}

- (void)getNewMsg:(NSString *)argStandardMsgId
          msgCode:(NSString *)argMsgCode
       courseType:(NSString *)argType {
    @try {
        isFirstNewMsg = YES;
        currentPageNum = 1;
        [self newMsg:argStandardMsgId msgCode:argMsgCode courseType:argType];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController getNewMsg : %@", exception);
    }
}

- (void)getNewMsgWithPush {
    @try {
        
        //GS요청에 따른 갱신 처리
        [self getNewMsg:[[AppPushDatabase sharedInstance] getMsgId:@"ORDER BY CAST(MSG_ID AS INTEGER) DESC LIMIT 1"]
                msgCode:nil
             courseType:@"N"];
        
        //        isFirstNewMsg = YES;
        //        currentPageNum = 1;
        //        if(argStandardMsgId==nil) {
        //            [self newMsg:[[AppPushDatabase sharedInstance] getMsgId:@"ORDER BY CAST(MSG_ID AS INTEGER) DESC LIMIT 1"]
        //                 msgCode:nil
        //              courseType:nil];
        //        } else {
        //            [self newMsg:argStandardMsgId msgCode:argMsgCode courseType:argType];
        //        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController getNewMsgWithPush : %@", exception);
    }
}


- (void)playNotiSound:(NSArray *)argArrSound {
    
    @try {
        if(argArrSound!=nil && [argArrSound count]==2) {
            
            SystemSoundID soundIDNoti;
            id sndPath = [[NSBundle mainBundle] pathForResource:[argArrSound objectAtIndex:0]
                                                         ofType:[argArrSound objectAtIndex:1]];
            // URL 타입 생성
            
            CFURLRef baseURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:sndPath]);
            // SoundID 생성
            AudioServicesCreateSystemSoundID(baseURL, &soundIDNoti);
            AudioServicesPlayAlertSound(soundIDNoti);
            //AudioServicesDisposeSystemSoundID(soundIDNoti);
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController playNotiSound : %@", exception);
    }
}

#define APNS_MSG_ID_KEY     @"i"
#define APNS_MSG_TYPE_KEY   @"t"
#define APNS_MSG_LINK_KEY   @"l"
#define APNS_KEY            @"aps"
#define APNS_SOUND_KEY      @"sound"
#define APNS_ALERT_KEY      @"alert"

- (void)processNoti {
    @try {
        if(dicNoti!=nil && [dicNoti count]>0) {
            //app으로부터 수신 받았다고 전달받은 경우
            //NSLog(@"dicNoti :%@",dicNoti);
            
            NSString *notiMsgId = [dicNoti valueForKey:APNS_MSG_ID_KEY];
            //NSLog(@"notiMsgId :%@",notiMsgId);
            if(notiMsgId!=nil) {
                NSString *msgType = [dicNoti valueForKey:APNS_MSG_TYPE_KEY];
                NSString *notiName = [[dicNoti valueForKey:APNS_KEY] valueForKey:APNS_SOUND_KEY];
                NSArray *arrSound = [notiName componentsSeparatedByString:@"."];
                NSString *appLink = [dicNoti valueForKey:APNS_MSG_LINK_KEY];
                
                if(dicMsg==nil) dicMsg = [[NSMutableDictionary alloc] init];
                [dicMsg setDictionary:[[AppPushDatabase sharedInstance] getMsg:[NSString stringWithFormat:@"WHERE COMMON_MSG_ID = '%@' LIMIT 1",notiMsgId]]];
                if(dicMsg!=nil && [dicMsg count]>0) {
                    
                    //NSLog(@"dicMsg : %@",dicMsg);
                    NSString *dbApplink = [dicMsg valueForKey:AMAIL_MSG_APP_LINK];
                    if(dbApplink==nil || [@"" isEqualToString:dbApplink]) {
                        [dicMsg setValue:GSSHOP_HOME_URL forKey:AMAIL_MSG_APP_LINK];
                    }
                    
                    if(notiTime==PUSH_FORE) {
                        
                        if([MSG_TYPE_HTML isEqualToString:[dicMsg valueForKey:AMAIL_MSG_MSG_TYPE]] ||
                           [MSG_TYPE_URL isEqualToString:[dicMsg valueForKey:AMAIL_MSG_MSG_TYPE]]) {
                            [self playNotiSound:arrSound];
                            [self showRichView:dicMsg];
                        } else if([MSG_TYPE_TEXT isEqualToString:[dicMsg valueForKey:AMAIL_MSG_MSG_TYPE]]){
                            [dicMsg setValue:[[dicNoti valueForKey:APNS_KEY] valueForKey:APNS_ALERT_KEY] forKey:AMAIL_MSG_MSG];
                            [self playNotiSound:arrSound];
                            [self showTextView:dicMsg];
                        }
                        
                    }
                    //푸시수정 by shawn
                    // else if(notiTime==PUSH_START || notiTime==PUSH_BACK) {
                    else if(notiTime==PUSH_BACK) {
                        
                        [self readMsgProcess:dicMsg];
                        [delegate interlockMain:[dicMsg valueForKey:AMAIL_MSG_APP_LINK]
                                           data:[dicMsg valueForKey:AMAIL_MSG_MAP3]];
                        
                    }
                    
                } else if([MSG_TYPE_TEXT isEqualToString:msgType]) {
                    
                    [dicMsg removeAllObjects];
                    [dicMsg setValue:[[dicNoti valueForKey:APNS_KEY] valueForKey:APNS_ALERT_KEY] forKey:AMAIL_MSG_MSG];
                    [dicMsg setValue:appLink forKey:AMAIL_MSG_APP_LINK];
                    [dicMsg setValue:@"" forKey:AMAIL_MSG_MAP3];
                    [dicMsg setValue:notiMsgId forKey:AMAIL_MSG_MSG_ID];
                    [dicMsg setValue:@"N" forKey:AMAIL_MSG_READ_YN];
                    
                    if(appLink==nil || [@"" isEqualToString:appLink]) {
                        [dicMsg setValue:GSSHOP_HOME_URL forKey:AMAIL_MSG_APP_LINK];
                    }
                    
                    if(notiTime==PUSH_FORE) {
                        [self playNotiSound:arrSound];
                        [self showTextView:dicMsg];
                    }
                    //푸시수정 by shawn
                    //else if(notiTime==PUSH_START || notiTime==PUSH_BACK) {
                    else if(notiTime==PUSH_BACK) {
                        [self readMsgProcess:dicMsg];
                        [delegate interlockMain:[dicMsg valueForKey:AMAIL_MSG_APP_LINK]
                                           data:[dicMsg valueForKey:AMAIL_MSG_MAP3]];
                    }
                    
                }
            }
            
            //            NSLog(@"dicNoti remove");
            [dicNoti removeAllObjects];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController processNoti : %@", exception);
    }
}

- (NSString *)clickMsgProcess:(NSURLRequest *)argRequest {
    @try {
        
        if(argRequest!=nil) {
            
            
            NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef)argRequest.URL.relativeString, CFSTR("")) );
            
            
            //NSLog(@"shouldStartLoadWithRequest : %@",result);
            //location.href='pms||'+msgId+'||'+linkSeq+'||'+msgPushType+'||'+url;
            NSArray *arrUrl = [[NSString stringWithFormat:@"test%@",result] componentsSeparatedByString:APPPUSH_DEF_SEPARATE_CLICK];
            if(arrUrl!=nil && [arrUrl count]>=5) {
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyyMMddHHmmss"];
                NSString *strMsgId = [arrUrl objectAtIndex:1];
                NSString *strLinkSeq = [arrUrl objectAtIndex:2];
                NSString *strMsgPushType = [arrUrl objectAtIndex:3];
                NSString *strWorkDay = [df stringFromDate:[NSDate date]];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *arrClickMsg = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults valueForKey:APPPUSH_DEF_CLICK_MSG]];
                
                if(arrClickMsg!=nil) {
                    [arrClickMsg addObject:[NSArray arrayWithObjects:strMsgId,strLinkSeq,strMsgPushType,strWorkDay,nil]];
                    if([arrClickMsg count]>0) {
                        [userDefaults setValue:arrClickMsg forKey:APPPUSH_DEF_CLICK_MSG];
                        [userDefaults synchronize];
                    }
                    
                } else {
                    NSMutableArray *arrNewClickMsg = [[NSMutableArray alloc] init];
                    if([arrNewClickMsg count]>0) {
                        [userDefaults setValue:arrNewClickMsg forKey:APPPUSH_DEF_CLICK_MSG];
                        [userDefaults synchronize];
                    }
                }
                
                [self performSelectorOnMainThread:@selector(checkClickMsg) withObject:nil waitUntilDone:NO];
                
                return [arrUrl objectAtIndex:4];
            } else {
                return nil;
            }
            
        } else {
            return nil;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController clickProcess : %@", exception);
        return nil;
    }
    
}

- (void)readMsgProcess:(NSDictionary *)argReadMsgDic {
    @try {
        
        if(argReadMsgDic!=nil && [argReadMsgDic count]>0) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *arrReadMsg = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults valueForKey:APPPUSH_DEF_READ_MSG]];
            
            if(arrReadMsg!=nil) {
                NSString *msgId = [argReadMsgDic valueForKey:AMAIL_MSG_MSG_ID];
                if(msgId!=nil) {
                    [arrReadMsg addObject:msgId];
                }
                if([arrReadMsg count]>0) {
                    [userDefaults setValue:arrReadMsg forKey:APPPUSH_DEF_READ_MSG];
                    [userDefaults synchronize];
                }
            } else {
                NSMutableArray *arrNewReadMsg = [[NSMutableArray alloc] init];
                NSString *msgId = [argReadMsgDic valueForKey:AMAIL_MSG_MSG_ID];
                if(msgId!=nil) {
                    [arrNewReadMsg addObject:msgId];
                }
                if([arrNewReadMsg count]>0) {
                    [userDefaults setValue:arrNewReadMsg forKey:APPPUSH_DEF_READ_MSG];
                    [userDefaults synchronize];
                }
            }
            
            [self checkReadMsg];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController setReadMsgArrByApp : %@", exception);
    }
}


#pragma mark - Network Method

// CRM do not use 2014. 11. 10
/*
 - (void)getCRMData:(id)argObject {
 @try {
 isCert = APPPUSH_DEF_CERT_LOADING;
 NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
 NSString *userId = [userDefault valueForKey:APPPUSH_DEF_USER_ID];
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(onResponseForCRMData:)
 name:APPPUSH_NOTI_GSSHOP
 object:nil];
 [[AppPushNetworkAPI sharedNetworkAPI] getGSShopUserInfo:userId
 object:[@"login" isEqualToString:(NSString *)argObject]?@"GSShop_login":@"GSShop_cert"];
 }
 @catch (NSException *exception) {
 NSLog(@"PMS Exception at AppPushMainViewController getCRMData : %@", exception);
 }
 }
 */



- (void)startCert {
    @try {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSString *uuid = [userDefault valueForKey:APPPUSH_DEF_DEVICE_ID];
        
        NSLog(@"@@@@@@@@@@@@@@@@  UUID : %@", uuid);
        if(uuid == nil) {
            uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, CFUUIDCreate(CFAllocatorGetDefault())));
            [userDefault setValue:uuid forKey:APPPUSH_DEF_UUID];
 
        }
        NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        NSString* appKey = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"PMSAppKey"];
        
        NSString* osVersion = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
        
        NSString* device = [self getDeviceInfo];
        NSString *token = [userDefault valueForKey:APPPUSH_DEF_APNS_TOKEN];
        
        NSString *userId = [userDefault valueForKey:APPPUSH_DEF_USER_ID];
        NSString *deviceId = [userDefault valueForKey:APPPUSH_DEF_DEVICE_ID];
        NSString *waPcId = [userDefault valueForKey:APPPUSH_DEF_WA_PC_ID];
        NSString *advrId = [userDefault valueForKey:APPPUSH_DEF_GA_ID];
        NSString *pcId = [userDefault valueForKey:APPPUSH_DEF_PC_ID];
        
        // waPcId 길이 100바이트이상 짜름
        if(waPcId){
            NSData* data = [waPcId dataUsingEncoding:NSUTF8StringEncoding];
            if(data.length > 100){
                waPcId = @"";
            }
        }
        
        // waPcId 길이 100바이트이상 짜름
        if(pcId){
            NSData* data = [pcId dataUsingEncoding:NSUTF8StringEncoding];
            if(data.length > 100){
                pcId = @"";
            }
        }
        
        [userDefault removeObjectForKey:APPPUSH_DEF_NETWORK_KEY];
        isCert = APPPUSH_DEF_CERT_LOADING;
        if(isShowPGS) {
            [AmailBezelActivityView activityViewForView:vcMsg.view withLabel:@"인증 중..."];
        }
        // CRM do not use 2014. 11. 10
        //        NSDictionary *dicCRM = (NSDictionary *)[userDefault valueForKey:APPPUSH_DEF_USER_CRM];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResponseForDeviceCert:)
                                                     name:APPPUSH_NOTI_DEVICE
                                                   object:nil];
        
//        [[AppPushNetworkAPI sharedNetworkAPI] deviceCert:userId?userId:@""
//                                                deviceId:deviceId?deviceId:@""
//                                                  waPcId:waPcId?waPcId:@""
//                                               pushToken:token
//                                               osVersion:osVersion
//                                              appVersion:appVersion
//                                                  device:device
//                                                    uuid:deviceId
//                                                  appKey:appKey
//                                                  advrId:advrId?advrId:@""
//                                                userInfo:nil
//                                                  object:@"noCRM"];
        [[AppPushNetworkAPI sharedNetworkAPI] deviceCert:userId?userId:@""
                                                deviceId:deviceId?deviceId:@""
                                                  waPcId:waPcId?waPcId:@""
                                               pushToken:token
                                               osVersion:osVersion
                                              appVersion:appVersion
                                                  device:device
                                                    uuid:deviceId
                                                  appKey:appKey
                                                  advrId:advrId?advrId:@""
                                                    pcId:pcId
                                                userInfo:nil
                                                  object:@"noCRM"];
        [userDefault synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController startCert : %@", exception);
    }
}

- (void)newMsg:(NSString *)argStandardMsgId
       msgCode:(NSString *)argMsgCode
    courseType:(NSString *)argType {
    @try {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResponseForNewMsg:)
                                                     name:APPPUSH_NOTI_NEW_MESSAGE
                                                   object:nil];
        [[AppPushNetworkAPI sharedNetworkAPI] getNewMsg:argStandardMsgId==nil?@"-1":argStandardMsgId
                                              groupCode:argMsgCode==nil?@"-1":argMsgCode
                                             courseType:argType==nil?@"N":argType
                                                pageNum:currentPageNum
                                                 rowNum:LIST_ROW_NUM
                                                 object:argType==nil?@"N":argType];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController newMsg : %@", exception);
    }
}

- (void)setMsgStatusByApp {
    @try {
        [self setMsgStatus:isTempMsgFlag];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController setMsgStatusByApp : %@", exception);
    }
}

- (void)setMsgStatus:(BOOL)argMsgFlag {
    @try {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResponseForConfig:)
                                                     name:APPPUSH_NOTI_SET_CONFIG
                                                   object:nil];
        [[AppPushNetworkAPI sharedNetworkAPI] setConfig:argMsgFlag];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController setMsgStatus : %@", exception);
    }
}

- (void)loginProcess {
    @try {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userId = [NSString stringWithFormat:@"%@", [userDefault valueForKey:APPPUSH_DEF_USER_ID]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResponseForLogin:)
                                                     name:APPPUSH_NOTI_LOGIN
                                                   object:nil];
        // CRM do not use 2014. 11. 10
        //NSDictionary *dicCRM = (NSDictionary *)[userDefault valueForKey:APPPUSH_DEF_USER_CRM];
        [[AppPushNetworkAPI sharedNetworkAPI] login:userId
                                           userInfo:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController login : %@", exception);
    }
}

- (void)logoutProcess {
    @try {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userId = [NSString stringWithFormat:@"%@", [userDefault valueForKey:APPPUSH_DEF_USER_ID]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResponseForLogout:)
                                                     name:APPPUSH_NOTI_LOGOUT
                                                   object:nil];
        [[AppPushNetworkAPI sharedNetworkAPI] logout:userId];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController logout : %@", exception);
    }
}

- (void)sessionOut {
    @try {
        [[AppPushNetworkAPI sharedNetworkAPI] sessionOut];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController sessionOut : %@", exception);
    }
}

- (void)setReadMsg:(NSString *)argReadMsgIds readTag:(NSString *)argReadTag {
    @try {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResponseForReadMsg:)
                                                     name:APPPUSH_NOTI_READ_MESSAGE
                                                   object:nil];
        
        
        [[AppPushNetworkAPI sharedNetworkAPI] setReadMsg:argReadMsgIds
                                                  object:argReadTag];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController setReadMsg : %@", exception);
    }
}

- (void)checkReadMsg {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arrReadMsg = [userDefaults valueForKey:APPPUSH_DEF_READ_MSG];
        if(arrReadMsg!=nil && [arrReadMsg count]>0) {
            
            NSMutableString *strReadMsgId = [[NSMutableString alloc] initWithString:@""];
            for (NSString *msgId in arrReadMsg) {
                [strReadMsgId appendFormat:@"\"%@\",",msgId];
            }
            
            if(strReadMsgId.length>0) {
                [strReadMsgId replaceCharactersInRange:NSMakeRange((strReadMsgId.length-1), 1)
                                            withString:@""];
                
                NSDictionary *dicObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                           strReadMsgId==nil?@"-1":strReadMsgId, @"msgIds",
                                           nil];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(onResponseForReadMsg:)
                                                             name:APPPUSH_NOTI_READ_MESSAGE
                                                           object:nil];
                
                [[AppPushNetworkAPI sharedNetworkAPI] setReadMsg:strReadMsgId
                                                          object:dicObject];
                
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController checkReadMsg : %@", exception);
    }
}

- (void)checkClickMsg {
    @try {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arrClickMsg = [userDefaults valueForKey:APPPUSH_DEF_CLICK_MSG];
        if(arrClickMsg!=nil && [arrClickMsg count]>0) {
            
            NSMutableString *strClickMsgIdParam = [[NSMutableString alloc] initWithString:@""];
            NSMutableString *strClickMsgId = [[NSMutableString alloc] initWithString:@""];
            
            for(NSArray *arrMsg in arrClickMsg) {
                if([arrMsg count] >= 4){ //20160128 segun 방어코드
                    [strClickMsgIdParam appendFormat:@"{\"msgId\":\"%@\",\"linkSeq\":\"%@\",\"msgPushType\":\"%@\",\"workday\":\"%@\"},",
                     
                     [arrMsg objectAtIndex:0],
                     [arrMsg objectAtIndex:1],
                     [arrMsg objectAtIndex:2],
                     [arrMsg objectAtIndex:3]];
                    [strClickMsgId appendFormat:@"%@,",[arrMsg objectAtIndex:0]];
                }
            }
            
            if(strClickMsgIdParam.length>0 && strClickMsgId.length>0) {
                [strClickMsgIdParam replaceCharactersInRange:NSMakeRange((strClickMsgIdParam.length-1), 1)
                                                  withString:@""];
                [strClickMsgId replaceCharactersInRange:NSMakeRange((strClickMsgId.length-1), 1)
                                             withString:@""];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(onResponseForClickMsg:)
                                                             name:APPPUSH_NOTI_CLICK_MESSAGE
                                                           object:nil];
                [[AppPushNetworkAPI sharedNetworkAPI] setClickMsg:strClickMsgIdParam object:strClickMsgId];
                
            }
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController checkClickLink : %@", exception);
    }
}
#pragma mark - Network Response
/*
 - (void)onResponseForCRMData:(NSNotification *)notification {
 @try {
 BOOL isFail = YES;
 [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_NOTI_GSSHOP object:nil];
 if([notification userInfo] != nil) {
 NSString *response = [[notification userInfo] objectForKey:@"response"];
 NSLog(@"response :%@",response);
 AmailSBJSON *jsonParser = [AmailSBJSON new];
 NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:response error:NULL];
 
 if(dic!=nil && [dic count] > 0 && [response rangeOfString:@"\"success\":true"].location != NSNotFound) {
 isFail = NO;
 NSLog(@"PMS : GSSHOP CRM : %@",dic);
 
 NSMutableDictionary *dicCRM = [[NSMutableDictionary alloc] init];
 [dicCRM setValue:[dic valueForKey:@"username"] forKey:@"custName"];
 [dicCRM setValue:[dic valueForKey:@"birthday"] forKey:@"birthday"];
 [dicCRM setValue:[dic valueForKey:@"phonenumber"] forKey:@"phoneNumber"];
 [dicCRM setValue:[dic valueForKey:@"sido"] forKey:@"location1"];
 [dicCRM setValue:[dic valueForKey:@"gugun"] forKey:@"location2"];
 [dicCRM setValue:[dic valueForKey:@"sex"] forKey:@"gender"];
 [dicCRM setValue:@"" forKey:@"data1"];
 [dicCRM setValue:@"" forKey:@"data2"];
 [dicCRM setValue:@"" forKey:@"data3"];
 
 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
 [userDefaults setValue:dicCRM forKey:APPPUSH_DEF_USER_CRM];
 
 
 //NSLog(@"dicCRM :%@",dicCRM);
 //                if(presentDate!=nil) {
 //                    [userDefaults setValue:presentDate forKey:APPPUSH_DEF_UNIQUE_DATE];
 //                    [presentDate release],presentDate=nil;
 //                }
 
 [userDefaults synchronize];
 
 }
 }
 
 if([@"GSShop_cert" isEqualToString:(NSString *)notification.object]) {
 [self startCert];
 } else {
 [self loginProcess];
 }
 
 
 }
 @catch (NSException *exception) {
 NSLog(@"PMS Exception at AppPushMainViewController onResponseForCRMData : %@", exception);
 }
 }
 */

- (void)onResponseForDeviceCert:(NSNotification *)notification {
    BOOL isFail = YES;
    NSString *code;
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_NOTI_DEVICE object:nil];
        if([notification userInfo] != nil) {
            NSString *response = [[notification userInfo] objectForKey:@"response"];
            AmailSBJSON *jsonParser = [AmailSBJSON new];
            NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:response error:NULL];
            
            if([dic count] > 0) {
                code = [dic valueForKey:@"code"];
                if([APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:code]) {
                    isFail = NO;
                    isCert = APPPUSH_DEF_CERT_DONE;
                    
                    
                    //기본 데이타 초기화
                    [userDefaults setValue:[dic valueForKey:@"encKey"]
                                    forKey:APPPUSH_DEF_NETWORK_KEY];
                    [userDefaults setValue:[dic valueForKey:@"appUserId"]
                                    forKey:APPPUSH_DEF_APP_USER_ID];
                    [userDefaults setValue:[dic valueForKey:@"newMsgCnt"]
                                    forKey:APPPUSH_DEF_NEW_MSG_COUNT];
                    [userDefaults setValue:[dic valueForKey:@"notiFlag"]
                                    forKey:APPPUSH_DEF_NOTI_FLAG];
                    [userDefaults setValue:[dic valueForKey:@"msgFlag"]
                                    forKey:APPPUSH_DEF_MSG_FLAG];
                    
                    if([NCS([dic valueForKey:@"msgFlag"]) isEqualToString:@"Y"]) {
                        isMsgFlag = YES;
                    } else {
                        isMsgFlag = NO;
                    }
                    
                    
                    
                    [self notiUnReadMessage:YES];
                    [self checkReadMessage];
                    
                } else {
                    code = APPPUSH_NETWORK_ERROR_CODE;
                }
            } else {
                code = APPPUSH_NETWORK_ERROR_CODE;
            }
        }
        
        if(isFail) {
            isCert = APPPUSH_DEF_CERT_NOT;
            if(isShowPGS) {
                [AmailBezelActivityView activityViewForView:vcMsg.view
                                                  withLabel:@"인증 실패. 잠시후 이용해주세요."
                                                  indicator:NO];
            }
        } else {
            
            //메세지로드 주석3
            [vcMsg loadMsgView:nil];
            [AmailBezelActivityView removeViewAnimated:YES];
            
            [self getNewMsg:[[AppPushDatabase sharedInstance] getMsgId:@"ORDER BY CAST(MSG_ID AS INTEGER) DESC LIMIT 1"]
                    msgCode:nil
                 courseType:@"N"];
            
            //GS 요청에 따른 메시지 갱신 처리
            //            int msgCount = [[AppPushDatabase sharedInstance] getMsgCount:nil];
            //            if(msgCount==0) {
            //                currentPageNum = 1;
            //                [self getNewMsg:nil msgCode:nil courseType:@"P"];
            //            } else {
            //                currentPageNum = 1;
            //                [[AppPushDatabase sharedInstance] deleteAllData];
            //                [self getNewMsg:[[AppPushDatabase sharedInstance] getMsgId:@"ORDER BY CAST(MSG_ID AS INTEGER) DESC LIMIT 1"]
            //                        msgCode:nil
            //                     courseType:nil];
            //            }
            
            //[self checkClickLink];
            
        }
        
        NSString *withCrm = (NSString *)notification.object;
        if([@"CRM" isEqualToString:withCrm]) {
            //[userDefaults removeObjectForKey:APPPUSH_DEF_USER_CRM];
        } else {
            
        }
        
        [userDefaults synchronize];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController onResponseForDeviceCert : %@", exception);
        code = APPPUSH_NETWORK_ERROR_CODE;
    }
    @finally {
        [delegate authorize:code];
        [self checkReadMsg];
        [self checkClickMsg];
    }
}

- (NSString *)getPushImg:(NSString *)msgId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pushImg = [[NSString alloc]init];
    
    if ([[userDefaults valueForKey:AMAIL_MSG_MSG_ID] isEqual:msgId]) {
        pushImg = [userDefaults valueForKey:AMAIL_MSG_IMG];
    }
    
    return pushImg;
}

- (void)onResponseForNewMsg:(NSNotification *)notification {
    BOOL isFail = YES;
    NSString *code;
    @try {
        //NSString *msgId = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_NOTI_NEW_MESSAGE object:nil];
        if([notification userInfo] != nil) {
            NSString *response = [[notification userInfo] objectForKey:@"response"];
            //NSLog(@"response :%@",response);
            
            
            AmailSBJSON *jsonParser = [AmailSBJSON new];
            NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:response error:NULL];
            
            if([dic count] > 0) {
                code = [dic valueForKey:@"code"];
                if([APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:code]) {
                    
                    isFail = NO;
                    
                    //                    NSLog(@"dic :%@",dic);
                    
                    NSArray *arrMsgList = [dic valueForKey:@"msgs"];
                    
                    if([self saveNewMsg:arrMsgList]) {
                        //새로운 메시지가 있는 경우
                        [vcMsg loadMsgView:nil];
                        
                    }
                    
                    if(isFirstNewMsg) {
                        isFirstNewMsg = NO;
                        //first New Msg Api call
                        
                    }
                    
                    NSString *type = (NSString *)notification.object;
                    if(arrMsgList!=nil && [arrMsgList count]>=LIST_ROW_NUM) {
                        //NSLog(@"type :%@",type);
                        if([@"P" isEqualToString:type]) {
                            currentPageNum++;
                            [self newMsg:nil
                                 msgCode:nil
                              courseType:@"P"];
                        } else if([@"N" isEqualToString:type]) {
                            currentPageNum = 1;
                            [self newMsg:[[AppPushDatabase sharedInstance] getMsgId:@"ORDER BY CAST(MSG_ID AS INTEGER) DESC LIMIT 1"]
                                 msgCode:nil
                              courseType:@"N"];
                        }
                        
                    }
                    
                    [self notiUnReadMessage:NO];
                    
                } else {
                    code = APPPUSH_NETWORK_ERROR_CODE;
                }
            } else {
                code = APPPUSH_NETWORK_ERROR_CODE;
            }
        } else {
            code = APPPUSH_NETWORK_ERROR_CODE;
        }
        
        [self processNoti];
        [vcMsg loadMsgView:nil];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController onResponseForNewMsg : %@", exception);
        code = APPPUSH_NETWORK_ERROR_CODE;
    }
    @finally {
        [self checkReadMsg];
        [self checkClickMsg];
    }
}
- (void)onResponseForConfig:(NSNotification *)notification {
    BOOL isFail = YES;
    NSString *code;
    @try {
        if([notification userInfo] != nil)
        {
            NSString *response = [[notification userInfo] objectForKey:@"response"];
            AmailSBJSON *jsonParser = [AmailSBJSON new];
            NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:response error:NULL];
            
            if([dic count] > 0) {
                code = [dic valueForKey:@"code"];
                if([APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:code]) {
                    isFail = NO;
                    isMsgFlag = isTempMsgFlag;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setValue:isMsgFlag?@"Y":@"N" forKey:APPPUSH_DEF_MSG_FLAG];
                    [userDefaults setValue:isMsgFlag?@"Y":@"N" forKey:APPPUSH_DEF_NOTI_FLAG];
                    [userDefaults synchronize];
                    
                }
            }
        } else {
            code = APPPUSH_NETWORK_ERROR_CODE;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController onResponseForConfig : %@", exception);
        code = APPPUSH_NETWORK_ERROR_CODE;
    }
    @finally {
        [delegate configMsgResult:code msgFlag:isTempMsgFlag];
        [self checkReadMsg];
        [self checkClickMsg];
    }
}



- (void)onResponseForLogin:(NSNotification *)notification {
    BOOL isFail = YES;
    NSString *code;
    @try {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_NOTI_LOGIN object:nil];
        if([notification userInfo] != nil) {
            NSString *response = [[notification userInfo] objectForKey:@"response"];
            AmailSBJSON *jsonParser = [AmailSBJSON new];
            NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:response error:NULL];
            
            if([dic count] > 0) {
                code = [dic valueForKey:@"code"];
                if([APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:code]) {
                    isFail = NO;
                    
                    isCert = APPPUSH_DEF_CERT_DONE;
                    
                    //GS 요청에 따른 메시지 갱신 처리
                    [[AppPushDatabase sharedInstance] truncateMsg];
                    [self getNewMsg:nil msgCode:nil courseType:@"P"];
                    
                    //isFirstNewMsg = YES;
                    //currentPageNum = 1;
                    //[self newMsg:nil msgCode:nil courseType:@"P"];
                    
                    
                } else {
                    code = APPPUSH_NETWORK_ERROR_CODE;
                }
            } else {
                code = APPPUSH_NETWORK_ERROR_CODE;
            }
        } else {
            code = APPPUSH_NETWORK_ERROR_CODE;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController onResponseForLogin : %@", exception);
        code = APPPUSH_NETWORK_ERROR_CODE;
    }
    @finally {
        [delegate login:code];
    }
}

- (void)onResponseForLogout:(NSNotification *)notification {
    BOOL isFail = YES;
    NSString *code;
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_NOTI_LOGOUT object:nil];
        if([notification userInfo] != nil) {
            NSString *response = [[notification userInfo] objectForKey:@"response"];
            AmailSBJSON *jsonParser = [AmailSBJSON new];
            NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:response error:NULL];
            
            if([dic count] > 0) {
                code = [dic valueForKey:@"code"];
                if([APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:code]) {
                    isFail = NO;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setValue:@"" forKey:APPPUSH_DEF_USER_ID];
                    //                    [userDefaults removeObjectForKey:APPPUSH_DEF_DEVICE_ID];
                    [userDefaults removeObjectForKey:APPPUSH_DEF_WA_PC_ID];
                    [userDefaults removeObjectForKey:APPPUSH_DEF_USER_CRM];
                    [userDefaults synchronize];
                    
                    [[AppPushDatabase sharedInstance] truncateMsg];
                    
                } else {
                    code = APPPUSH_NETWORK_ERROR_CODE;
                }
            } else {
                code = APPPUSH_NETWORK_ERROR_CODE;
            }
        } else {
            code = APPPUSH_NETWORK_ERROR_CODE;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController onResponseForLogout : %@", exception);
        code = APPPUSH_NETWORK_ERROR_CODE;
    }
    @finally {
        [delegate logout:code];
    }
}

- (void)onResponseForReadMsg:(NSNotification *)notification {
    BOOL isFail = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_NOTI_READ_MESSAGE object:nil];
    NSString *code;
    NSDictionary *dicTemp = (NSDictionary *)notification.object;
    @try {
        if([notification userInfo] != nil) {
            NSString *response = [[notification userInfo] objectForKey:@"response"];
            AmailSBJSON *jsonParser = [AmailSBJSON new];
            NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:response error:NULL];
            
            if([dic count] > 0) {
                code = [dic valueForKey:@"code"];
                if([APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:code]) {
                    isFail = NO;
                    
                    //NSLog(@"readMsgIds :%@",[dicTemp valueForKey:@"msgIds"]);
                    //NSLog(@"grpCode :%@",[dicTemp valueForKey:@"grpCode"]);
                    NSString *strMsgIds = [((NSString *)[dicTemp valueForKey:@"msgIds"]) stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    [[AppPushDatabase sharedInstance] setMsgReadY:strMsgIds];
                    
                    [self resetMsgCnt];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    NSArray *arrMsgId = [strMsgIds componentsSeparatedByString:@","];
                    NSMutableArray *arrSaveMsgId = [NSMutableArray arrayWithArray:[userDefaults valueForKey:APPPUSH_DEF_READ_MSG]];
                    if(arrMsgId!=nil && [arrMsgId count]>0 &&
                       arrSaveMsgId!=nil && [arrSaveMsgId count]>0) {
                        for(NSString *tempMsgId in arrMsgId) {
                            [arrSaveMsgId removeObject:tempMsgId];
                        }
                        [userDefaults setValue:arrSaveMsgId forKey:APPPUSH_DEF_READ_MSG];
                        [userDefaults synchronize];
                    }
                    
                } else {
                    code = APPPUSH_NETWORK_ERROR_CODE;
                }
            } else {
                code = APPPUSH_NETWORK_ERROR_CODE;
            }
        } else {
            code = APPPUSH_NETWORK_ERROR_CODE;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController onResponseForReadMsg : %@", exception);
        code = APPPUSH_NETWORK_ERROR_CODE;
    }
    @finally {
        //
    }
}



- (void)onResponseForClickMsg:(NSNotification *)notification {
    BOOL isFail = YES;
    NSString *code;
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:APPPUSH_NOTI_CLICK_MESSAGE object:nil];
        if([notification userInfo] != nil) {
            NSString *response = [[notification userInfo] objectForKey:@"response"];
            AmailSBJSON *jsonParser = [AmailSBJSON new];
            NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:response error:NULL];
            
            if([dic count] > 0) {
                code = [dic valueForKey:@"code"];
                if([APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:code] ||
                   [APPPUSH_NETWORK_ALREADY_READ_CODE isEqualToString:code]) {
                    isFail = NO;
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    
                    NSString *clickMsgIds = (NSString *)notification.object;
                    NSArray *arrClickMsg = [clickMsgIds componentsSeparatedByString:@","];
                    NSMutableArray *arrSaveClickMsg = [NSMutableArray arrayWithArray:(NSMutableArray *)[userDefaults valueForKey:APPPUSH_DEF_CLICK_MSG]];
                    if(arrSaveClickMsg!=nil && [arrSaveClickMsg count]>0 &&
                       arrClickMsg!=nil && [arrClickMsg count]>0) {
                        [arrSaveClickMsg removeObjectsInRange:NSMakeRange(0, [arrClickMsg count])];
                        [userDefaults setValue:arrSaveClickMsg forKey:APPPUSH_DEF_CLICK_MSG];
                        [userDefaults synchronize];
                    }
                } else {
                    code = APPPUSH_NETWORK_ERROR_CODE;
                }
            } else {
                code = APPPUSH_NETWORK_ERROR_CODE;
            }
        } else {
            code = APPPUSH_NETWORK_ERROR_CODE;
        }
        
        //For Test
        //        NSMutableDictionary *tempDicClickLink = [[NSUserDefaults standardUserDefaults] valueForKey:APPPUSH_CLICK_LINK];
        //        NSLog(@"tempDicClickLink:%@",tempDicClickLink);
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController onResponseForClick : %@", exception);
        code = APPPUSH_NETWORK_ERROR_CODE;
    }
    @finally {
        //
    }
}

#pragma mark - MessageViewDelegate

//MsgView에서 refresh 요청하는 경우
- (void)loadNewMsg:(NSString *)argStandardMsgId
           msgCode:(NSString *)argMsgCode
        courseType:(NSString *)argType {
    @try {
        
        //GS요청에 따른 갱신 처리
        [[AppPushDatabase sharedInstance] truncateMsg];
        [self getNewMsg:nil msgCode:nil courseType:@"P"];
        
        //        isFirstNewMsg = YES;
        //        currentPageNum = 1;
        //        if(argStandardMsgId==nil) {
        //            [self newMsg:[[AppPushDatabase sharedInstance] getMsgId:@"ORDER BY CAST(MSG_ID AS INTEGER) DESC LIMIT 1"]
        //                 msgCode:nil
        //              courseType:nil];
        //        } else {
        //            [self newMsg:argStandardMsgId msgCode:argMsgCode courseType:argType];
        //        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController loadNewMsg : %@", exception);
    }
}

- (void)resetMsgCnt {
    @try {
        [self notiUnReadMessage:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController resetMsgCnt : %@", exception);
    }
}

-(void)pressPersonalTableHeader:(NSString *)argLink{
    @try {
        
        if([NCS(argLink) length] > 0) {
            
           [delegate interlockTouchHeader:argLink data:@""];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController pressPersonalTableHeader : %@", exception);
    }
}

- (void)pressTableCell:(NSDictionary *)argDic {
    @try {
        
        if([MSG_TYPE_HTML isEqualToString:[argDic valueForKey:AMAIL_MSG_MSG_TYPE]] ||
           [MSG_TYPE_URL isEqualToString:[argDic valueForKey:AMAIL_MSG_MSG_TYPE]]) {
            //if([[argDic valueForKey:AMAIL_MSG_MSG] rangeOfString:@"<html>"].location != NSNotFound) {
            [self showRichView:argDic];
        } else {
            [self readMsgProcess:argDic];
            //shawnPMS 추가
            [delegate interlockTBTOUCHMain:[argDic valueForKey:AMAIL_MSG_APP_LINK]
                                      data:[argDic valueForKey:AMAIL_MSG_MAP3]];
            
            // [delegate interlockMain:[argDic valueForKey:AMAIL_MSG_APP_LINK]
            //                    data:[argDic valueForKey:AMAIL_MSG_MAP3]];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController pressTableCell : %@", exception);
    }
}

#pragma mark - MessageRichViewDelegate

- (void)setRichSize:(CGSize)argSize {
    @try {
        
        if(vcMsgRich) {
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            
            [vcMsgRich.view setFrame:CGRectMake(0.0f, 0.0f, argSize.width, argSize.height)];
            [vcMsgRich setViewFrame:CGRectMake(0.0f, 0.0f, argSize.width, argSize.height)];
            
            [UIView commitAnimations];
            
            [AmailPopUpView resizePopView:vcMsgRich.view.frame.size];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController setSize : %@", exception);
    }
}

- (void)pressLink:(NSDictionary *)argDic {
    @try {
        if(argDic!=nil) {
            [self readMsgProcess:argDic];
        }
        [delegate interlockMain:[argDic valueForKey:AMAIL_MSG_APP_LINK]
                           data:[argDic valueForKey:AMAIL_MSG_MAP3]];
        //[vcMsgRich release], vcMsgRich = nil;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController pressLink : %@", exception);
    }
}

- (void)pressCloseView:(NSDictionary *)argDic {
    @try {
        isPopUp = NO;
        [AmailPopUpView closeCustomPopView];
        //[vcMsgRich release], vcMsgRich = nil;
        if(vcMsgRich!=nil) {
            [vcMsgRich resetData];
            [vcMsgRich.view setFrame:CGRectMake(0.0f, 0.0f, AMAIL_POPUP_WIDTH, AMAIL_POPUP_HEIGHT)];
            [vcMsgRich setViewFrame:CGRectMake(0.0f, 0.0f, AMAIL_POPUP_WIDTH, AMAIL_POPUP_HEIGHT)];
        }
        //        if(argDic!=nil) {
        //            [self processRead:argDic];
        //        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController pressClose : %@", exception);
    }
}

- (NSString *)clickLink:(NSURLRequest *)argRequest {
    @try {
        return [self clickMsgProcess:argRequest];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMainViewController clickLink : %@", exception);
        return nil;
    }
}


#pragma mark - Mocha_AlertDelegate

- (void) customAlertView:(UIView*)alert clickedButtonAtIndex:(NSInteger)index {
    
    if(alert.tag==1000) {
        
        switch (index) {
            case 0:
                
                break;
            case 1:
                [self readMsgProcess:dicMsg];
                [delegate interlockMain:[dicMsg valueForKey:AMAIL_MSG_APP_LINK]
                                   data:[dicMsg valueForKey:AMAIL_MSG_MAP3]];
                
                break;
            default:
                break;
        }
        
    }
    
}

@end
