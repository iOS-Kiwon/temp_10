#import "PMS.h"
#import "AppPushMainViewController.h"
#import "AppPushNetworkAPI.h"
#import "AmailJSON.h"
#import "AppPushDatabase.h"
#import "AppPushUtil.h"
#import "AppPushConstants.h"
#import "AmailActivityView.h"
#define SESSION_TIMEOVER_MINUTE    30
@interface PMS (private) <AppPushMainDelegate>
- (void)initalization;
- (void)initPushToken:(NSData *)argTokenData;
- (void)initUserId:(NSString *)argUserId;
// added start
- (void)initDeviceId:(NSString *)argDeviceId;
- (void)initWaPcId:(NSString *)argWaPcId;
// added fin
- (BOOL)authorize;
- (void)authorizeStart;
- (void)checkMain:(NSNotification *)notification;
- (void)showMain;
- (void)closeMain;
- (BOOL)checkCertCondition;
- (BOOL)checkAuthorize;
- (void)receivePush:(NSDictionary *)argDic notiType:(int)argType;
- (void)initMsgFlag:(BOOL)argIsMsg;
- (void)initAppPushDelegate:(id<PMSDelegate>)argDelegate;
- (void)deleteAllData;
- (NSString *)getUserId;
- (NSString *)getAdvrId;

- (BOOL)getMsgFlag;
- (void)enterForegroundApp;
- (BOOL)isSessionTimeOver;
- (void)login;
- (void)logout;
- (int)getNewMessageCount;
- (void)sessionOut;
- (void)startProcess:(BOOL)isPush;
@end
@implementation PMS
static PMS                  *sharedPMS = nil;
UIView                      *backView;
AppPushMainViewController   *mainVC;
UINavigationController      *navi;
BOOL                    isShowPMS = NO;
BOOL                    isChangeUser = NO;
@synthesize delegate;

+(PMS *) sharedInstance {
    @synchronized([PMS class]) {
        if(sharedPMS == nil) {
            sharedPMS = [[self alloc] init];
        }
        return sharedPMS;
    }
    return nil;
}

+(id) alloc
{
    @synchronized([PMS class]) {
        NSAssert(sharedPMS == nil, @"Attempted to allocate a second instance of a singleton.");
        sharedPMS = [[super alloc] init];
        return sharedPMS;
    }
    return nil;
}

- (id)init
{
    @try {
        if (sharedPMS == nil) {
            return self;
        }
        self = [super init];
        if (self) {
            [self initalization];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at init : %@", exception);
    }
    return self;
}

#pragma mark - <Inner Method>
- (void)initalization
{
    @try {
        
        [[AppPushDatabase sharedInstance] initDB];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkMain:)
                                                     name:APPPUSH_DEF_NOTI_SHOW_MAIN
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(detectStatusBarChange)
                                                     name:UIApplicationDidChangeStatusBarFrameNotification
                                                   object:nil];
        /*
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(detectOrientationChange)
         name:UIDeviceOrientationDidChangeNotification
         object:nil];
         */
        
        UIDevice *device = [UIDevice currentDevice];
        if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(enterForegroundApp)
                                                         name:UIApplicationWillEnterForegroundNotification
                                                       object:nil];
        }
        
        //ST
        if(mainVC==nil) {
            mainVC = [[AppPushMainViewController alloc] init];
            mainVC.delegate = self;
            navi = [[UINavigationController alloc] initWithRootViewController:mainVC];
            [navi setNavigationBarHidden:YES];
        }
        
        //no more arrangeMsgByExpDate
        //[self arrangeMsgByExpDate];
        if(mainVC!=nil) [mainVC notiUnReadMessage:NO];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS initalization : %@", exception);
    }
}

- (void)initPushToken:(NSData *)argTokenData {
    @try {
        if(argTokenData==nil) {
            [[NSUserDefaults standardUserDefaults] setValue:@"noToken" forKey:APPPUSH_DEF_APNS_TOKEN];
        } else {
            NSMutableString *deviceId = [NSMutableString string];
            const unsigned char* ptr = (const unsigned char*) [argTokenData bytes];
            for(int i = 0 ; i < 32 ; i++)  {
                [deviceId appendFormat:@"%02x", ptr[i]];
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithString:deviceId]
                                                     forKey:APPPUSH_DEF_APNS_TOKEN];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS initPushToken : %@", exception);
    }
}

- (void)initUserId:(NSString *)argUserId {
    @try {
        if(argUserId==nil) return;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *user = [userDefaults valueForKey:APPPUSH_DEF_USER_ID];
        //user_id
        if(user==nil) {
            isChangeUser = YES;
            if(mainVC) mainVC.isChangeUser = YES;
            [userDefaults setValue:argUserId forKey:APPPUSH_DEF_USER_ID];
            [userDefaults setValue:nil forKey:APPPUSH_DEF_USER_CRM];
            
        } else if(![user isEqualToString:argUserId]){
            [userDefaults setValue:user forKey:APPPUSH_DEF_USER_OLD_ID];
            [userDefaults setValue:argUserId forKey:APPPUSH_DEF_USER_ID];
            //[userDefaults removeObjectForKey:APPPUSH_DEF_UNIQUE_DATE];
            [userDefaults setValue:nil forKey:APPPUSH_DEF_USER_CRM];
            isChangeUser = YES;
            if(mainVC) mainVC.isChangeUser = YES;
        }
        
        [userDefaults synchronize];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS initUserId : %@", exception);
    }
}

- (void)initDeviceId:(NSString *)argDeviceId {
    @try {
        if(argDeviceId==nil) return;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:argDeviceId forKey:APPPUSH_DEF_DEVICE_ID];
        [userDefaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS initUserId : %@", exception);
    }
}

- (void)initWaPcId:(NSString *)argWaPcId {
    @try {
        if(argWaPcId==nil) return;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:argWaPcId forKey:APPPUSH_DEF_WA_PC_ID];
        [userDefaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS initUserId : %@", exception);
    }
}

- (void)initAdvrId:(NSString *)argAdvrId {
    @try {
        if(argAdvrId==nil) return;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:argAdvrId forKey:APPPUSH_DEF_GA_ID];
        [userDefaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS initAdvrId : %@", exception);
    }
}


- (void)initPcId:(NSString *)argPcId {
    @try {
        if(argPcId==nil) return;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:argPcId forKey:APPPUSH_DEF_PC_ID];
        [userDefaults synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS argPcId : %@", exception);
    }
}

- (void)initMsgFlag:(BOOL)argIsMsg {
    @try {
        if(mainVC!=nil) {
            [mainVC setMsgFlag:argIsMsg];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS initMsgFlag : %@", exception);
    }
}

- (BOOL)authorize {
    @try {
        // BOOL isAuthReady = [self checkAuthorize];
        if([self checkCertCondition]) {
            if(isChangeUser) {
                isChangeUser = NO;
                
                //                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                //                [userDefault removeObjectForKey:APPPUSH_DEF_UNIQUE_DATE];
                //                [userDefault synchronize];
                
                [self deleteAllData];
            }
            [self authorizeStart];
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS authorize : %@", exception);
        return NO;
    }
}

- (void)authorizeStart {
    @try {
        if(mainVC!=nil) {
            [mainVC deviceCert];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS authorizeStart : %@", exception);
    }
}

- (void)detectStatusBarChange {
    @try {
        //CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        //NSLog(@"window root view heigth : %f",statusBarFrame.size.height);
        if(isShowPMS) {
            //isShowPMS= NO;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            [self showMain];
            [UIView commitAnimations];
        }
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS detectStatusBarChange : %@", exception);
    }
}

- (void)detectOrientationChange {
    @try {
        if(isShowPMS) {
            //isShowPMS= NO;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            [self showMain];
            [UIView commitAnimations];
        }
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS detectOrientationChange : %@", exception);
    }
}

- (void)checkMain:(NSNotification *)notification {
    @try {
        
        //이미 보여지고 있는 경우
        if(isShowPMS) {
            return;
        }
        
        BOOL isClickView = NO;
        if(notification != nil) {
            id object = [notification object];
            if([object isKindOfClass:[NSNumber class]]) {
                if([object intValue]==1) {
                    isClickView = YES;
                }
            }
        }
        if(isClickView) {
            //직접 버튼을 클릭하여 여는 경우
            [self showMain];
        } else if([self.delegate respondsToSelector:@selector(showPMS)] &&
                  [self.delegate showPMS]) {
            //노티를 통해 열리는데, App단에서 허가하는 경우
            [self showMain];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS checkMain : %@", exception);
    }
}

- (void)showMain {
    @try {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if (!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        //이미 보여지고 있는 경우
        /*
         if(isShowPMS) {
         return;
         }
         */
        
        CGRect appFrame = CGRectMake(0.0, STATUSBAR_HEIGHT, APPFULLWIDTH, APPFULLHEIGHT - STATUSBAR_HEIGHT); //[UIScreen mainScreen].bounds;

        
        //CGRect appFrame = [UIScreen mainScreen].applicationFrame;
        
//        NSLog(@"appFrame x: %f",appFrame.origin.x);
//        NSLog(@"appFrame y: %f",appFrame.origin.y);
//        NSLog(@"appFrame width: %f",appFrame.size.width);
//        NSLog(@"appFrame height: %f",appFrame.size.height);
        
        if(backView==nil) {
            backView = [[UIView alloc] init];
            [backView setFrame:appFrame];
            [backView setBackgroundColor:[UIColor whiteColor]];
            [window addSubview:backView];
            [backView addSubview:navi.view];
        } else {
            [backView setFrame:appFrame];
            [backView setHidden:NO];
        }
        
        [navi.view setFrame:CGRectMake(0.0f,
                                       0.0f,
                                       backView.frame.size.width,
                                       backView.frame.size.height)];
        [mainVC.view setFrame:CGRectMake(0.0f,
                                         0.0f,
                                         navi.view.frame.size.width,
                                         navi.view.frame.size.height)];
        
        [navi setNavigationBarHidden:YES];
        
        //
        //        NSLog(@"navi.view x: %f",navi.view.frame.origin.x);
        //        NSLog(@"navi.view y: %f",navi.view.frame.origin.y);
        //        NSLog(@"navi.view width: %f",navi.view.frame.size.width);
        //        NSLog(@"navi.view height: %f",navi.view.frame.size.height);
        //
        //        NSLog(@"mainVC.view x: %f",mainVC.view.frame.origin.x);
        //        NSLog(@"mainVC.view y: %f",mainVC.view.frame.origin.y);
        //        NSLog(@"mainVC.view width: %f",mainVC.view.frame.size.width);
        //        NSLog(@"mainVC.view height: %f",mainVC.view.frame.size.height);
        
        
        
        if(!isShowPMS) {
            backView.transform = CGAffineTransformMakeTranslation(0.0f, appFrame.size.height);
            [window bringSubviewToFront:backView];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(showDidMain1)];
            backView.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
            [UIView commitAnimations];
        } else {
            [window bringSubviewToFront:backView];
        }
        
        isShowPMS = YES;
        if(mainVC!=nil) {
            mainVC.isShowPGS = YES;
        }
        
        [mainVC showMainView];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS showMain : %@", exception);
    }
}

- (void)showDidMain1 {
    @try {
        
        [mainVC pressShow];
        
        //        [UIView beginAnimations:nil context:nil];
        //        [UIView setAnimationDuration:0.1];
        //        [UIView setAnimationDelegate:self];
        //        [UIView setAnimationDidStopSelector:@selector(showDidMain2)];
        //        backView.transform = CGAffineTransformMakeTranslation(10.0f, 0.0f);
        //        [UIView commitAnimations];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS showDidMain1 : %@", exception);
    }
}

- (void)showDidMain2 {
    @try {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        backView.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
        [UIView commitAnimations];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS showDidMain2 : %@", exception);
    }
}

- (void)closeMain {
    @try {
        [AmailActivityView removeView];
        isShowPMS = NO;
        if(mainVC!=nil) {
            mainVC.isShowPGS = NO;
        }
        
        CGRect appFrame = [UIScreen mainScreen].bounds;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(closeDidMain)];
        backView.transform = CGAffineTransformMakeTranslation(0.0f, appFrame.size.height);
        [UIView commitAnimations];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS closeMain : %@", exception);
    }
}

- (void)closeDidMain {
    @try {
        backView.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
        [backView setHidden:YES];
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if (!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        [window sendSubviewToBack:backView];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS closeDidMain : %@", exception);
    }
}

- (void)deleteAllData {
    @try {
        mainVC.isCert = APPPUSH_DEF_CERT_NOT;
        [[AppPushDatabase sharedInstance] truncateMsg];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPush deleteAllData : %@", exception);
    }
}

- (void)receivePush:(NSDictionary *)argDic notiTime:(int)argTime {
    @try {
        
        if(argDic!=nil) {
            if(argTime==PUSH_START) {
                [self performSelectorOnMainThread:@selector(getReceivePushAtStart:) withObject:argDic waitUntilDone:NO];
            } else if(argTime==PUSH_FORE) {
                [self performSelectorOnMainThread:@selector(getReceivePushAtForeground:) withObject:argDic waitUntilDone:NO];
            } else if(argTime==PUSH_BACK){
                [self performSelectorOnMainThread:@selector(getReceivePushAtBackground:) withObject:argDic waitUntilDone:NO];
            } else {
                [self performSelectorOnMainThread:@selector(getReceivePush) withObject:nil waitUntilDone:NO];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS receivePush : %@", exception);
    }
}

- (void)getReceivePush {
    @try {
        [self startProcess:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS getReceivePush : %@", exception);
    }
}

- (void)getReceivePushAtStart:(id)argObject {
    @try {
        [mainVC setNotiDic:argObject notiTime:PUSH_START];
        [self startProcess:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS getReceivePushAtStart : %@", exception);
    }
}
- (void)getReceivePushAtForeground:(id)argObject {
    @try {
        [mainVC setNotiDic:argObject notiTime:PUSH_FORE];
        [self startProcess:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS getReceivePushAtForeground : %@", exception);
    }
}
- (void)getReceivePushAtBackground:(id)argObject {
    @try {
        [mainVC setNotiDic:argObject notiTime:PUSH_BACK];
        [self startProcess:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS getReceivePushAtBackground : %@", exception);
    }
}



- (void)enterForegroundApp {
    @try {
        
        [self startProcess:NO];
        //no more arrangeMsgByExpDate
        //[self arrangeMsgByExpDate];
        if(mainVC!=nil) {
            [mainVC notiUnReadMessage:NO];
            [mainVC checkReadMsg];
            [mainVC checkClickMsg];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS enterForegroundApp : %@", exception);
    }
}

- (void)startProcess:(BOOL)isPush {
    @try {
        if([self checkCertCondition] &&
           (mainVC.isCert != APPPUSH_DEF_CERT_DONE || [self isSessionTimeOver]) &&
           mainVC.isCert != APPPUSH_DEF_CERT_LOADING) {
            [mainVC deviceCert];
        } else if(mainVC.isCert == APPPUSH_DEF_CERT_DONE && isPush){
            [mainVC getNewMsgWithPush];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS startProcess : %@", exception);
    }
}

- (void)initAppPushDelegate:(id<PMSDelegate>)argDelegate {
    @try {
        self.delegate = argDelegate;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS initAppPushDelegate : %@", exception);
    }
}

- (BOOL)checkCertCondition {
    @try {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *strToken = [userDefaults valueForKey:APPPUSH_DEF_APNS_TOKEN];
        //NSString *strUserId = [userDefaults valueForKey:APPPUSH_DEF_USER_ID];
        
        //if(strToken!=nil && strUserId!=nil) {
        if(strToken!=nil) {
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS checkCertCondition : %@", exception);
        return NO;
    }
}

- (BOOL)checkAuthorize {
    @try {
        
        return [self checkCertCondition];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS checkAuthorize : %@", exception);
        return NO;
    }
}

- (NSString *)getUserId {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        return [userDefaults valueForKey:APPPUSH_DEF_USER_ID];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS getUserId : %@", exception);
        return nil;
    }
}

- (NSString *)getAdvrId {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        return [userDefaults valueForKey:APPPUSH_DEF_GA_ID];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS getAdvrId : %@", exception);
        return nil;
    }
}


- (NSString *)getPcID {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        return [userDefaults valueForKey:APPPUSH_DEF_PC_ID];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS getPcID : %@", exception);
        return nil;
    }
}

- (BOOL)getMsgFlag {
    @try {
        if(mainVC!=nil) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *getMsgFlag = [userDefaults valueForKey:APPPUSH_DEF_MSG_FLAG];
            return [@"Y" isEqualToString:getMsgFlag]?YES:NO;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS getMsgFlag : %@", exception);
        return NO;
    }
}

- (void)arrangeMsgByExpDate {
    @try {
        //MSG테이블에서 EXP_DATE가 지난 MSG들 삭제
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        [[AppPushDatabase sharedInstance] deleteMsg:[NSString stringWithFormat:@"WHERE SUBSTR(EXP_DATE,0,9) < '%@'",[df stringFromDate:[NSDate date]]]];
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS arrangeMsgByExpDate : %@", exception);
    }
}

- (BOOL)isSessionTimeOver {
    @try {
        
        NSString *pastTime = [[AppPushNetworkAPI sharedNetworkAPI] getLastSuccessTime];
        if(pastTime==nil) return YES;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *pastDate = [df dateFromString:pastTime];
        NSDate *presentDate = [NSDate date];
        
        int year = [[pastTime substringToIndex:4] intValue];
        NSString *result = [df stringFromDate:pastDate];
        int resultYear = [[result substringToIndex:4] intValue];
        
        if(resultYear==year) {
            //nothing
        } else if(resultYear>year) {
            //크면 빼기
            year -= (resultYear-year);
        } else {
            //작으면 더하기
            year += (year-resultYear);
        }
        NSDate *modifyPastDate = [df dateFromString:[pastTime stringByReplacingCharactersInRange:NSMakeRange(0, 4)
                                                                                      withString:[NSString stringWithFormat:@"%d",year]]];
        
        int diffTerm = (int)[presentDate timeIntervalSinceDate:modifyPastDate];
        
        
        //NSLog(@"pastDate    : %@",[df stringFromDate:modifyPastDate]);
        //NSLog(@"presentDate : %@",[df stringFromDate:presentDate]);
        //NSLog(@"diffTerm    : %d",(int)diffTerm); //초로 환산
        //30분 1800초
        if(diffTerm > (SESSION_TIMEOVER_MINUTE*60)) {
            //마지막 통신(성공000)이후 30분이 경과한 경우 디바이스 인증을 해야한다.
            return YES;
        } else {
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS isSessionTimeOver : %@", exception);
        return YES;
    }
}

- (void)login {
    @try {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *strToken = [userDefaults valueForKey:APPPUSH_DEF_APNS_TOKEN];
        NSString *strUserId = [userDefaults valueForKey:APPPUSH_DEF_USER_ID];
        
        if(strToken!=nil && strUserId!=nil) {
            if(isChangeUser) {
                isChangeUser = NO;
                [self deleteAllData];
            }
            [mainVC startLogin];
        } else {
            if([self.delegate respondsToSelector:@selector(loginPMS:)]) {
                [self.delegate loginPMS:NO];
            }
        }
        
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS login : %@", exception);
    }
}

- (void)logout {
    @try {
        [mainVC startLogout];
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS logout : %@", exception);
    }
}

- (int)getNewMessageCount {
    @try {
        if(mainVC) {
            return [mainVC findUnReadMessage:NO];
        } else {
            return 0;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS getNewMessageCount : %@", exception);
        return 0;
    }
}

- (void)sessionOut {
    @try {
        [mainVC sessionOut];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS sessionOut : %@", exception);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:APPPUSH_DEF_NOTI_SHOW_MAIN
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidChangeStatusBarFrameNotification
                                                  object:nil];
}

#pragma mark - <Class Method>
+ (void)initializePMS {
    [self sharedInstance];
}

+ (void)setPushToken:(NSData *)argTokenData {
    [sharedPMS initPushToken:argTokenData];
}

+ (void)setUserId:(NSString *)argUserId {
    [sharedPMS initUserId:argUserId];
}

+ (void)setDeviceUid:(NSString *)argDeviceUid {
    [sharedPMS initDeviceId:argDeviceUid];
}

+ (void)setWaPcId:(NSString *)argWaPcIdId {
    [sharedPMS initWaPcId:argWaPcIdId];
}

+ (void)setAdvrId:(NSString *)argAdvrId {
    [sharedPMS initAdvrId:argAdvrId];
}

+ (void)setPcId:(NSString *)argPcId {
    [sharedPMS initPcId:argPcId];
}

+ (NSString *)getAdvrId {
    return [sharedPMS getAdvrId];
}

+ (BOOL)authorize {
    return [sharedPMS authorize];
}

+ (void)receivePush:(NSDictionary *)argDic notiTime:(PMSNotiTime)argNotiTime {
    [sharedPMS receivePush:argDic notiTime:(int)argNotiTime];
}

+ (void)setMsgFlag:(BOOL)argIsMsg {
    [sharedPMS initMsgFlag:argIsMsg];
}

+ (void)setPMSDelegate:(id<PMSDelegate>)argDelegate {
    [sharedPMS initAppPushDelegate:argDelegate];
}

+ (void)showMessageBox {
    [sharedPMS showMain];
}

+ (void)closeMessageBox {
    [sharedPMS closeMain];
}

+ (NSString *)getUserId {
    return [sharedPMS getUserId];
}

+ (BOOL)getMsgFlag {
    return [sharedPMS getMsgFlag];
}

+ (void)login {
    [sharedPMS login];
}

+ (void)logout {
    [sharedPMS logout];
}

+ (int)getNewMessageCount {
    return [sharedPMS getNewMessageCount];
}

+ (NSString *)getPushImg:(NSString *)msgId{
    return [sharedPMS getPushImg:msgId];
}

- (NSString *)getPushImg:(NSString *)msgId{
    return [[AppPushDatabase sharedInstance]getPushImg:msgId];
    
}
//+ (void)sessionOut {
//    [sharedPMS sessionOut];
//}

#pragma mark - AppPushMainDelegate
- (void)closePMS {
    @try {
        [self closeMain];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS closePMS : %@", exception);
    }
}

- (void)authorize:(NSString *)argResult {
    @try {
        if([self.delegate respondsToSelector:@selector(authorizePMS:)]) {
            [self.delegate authorizePMS:[APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:argResult]?YES:NO];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS authorize : %@", exception);
    }
}

- (void)login:(NSString *)argResult {
    @try {
        if([self.delegate respondsToSelector:@selector(loginPMS:)]) {
            [self.delegate loginPMS:[APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:argResult]?YES:NO];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS loginPMS : %@", exception);
    }
}

- (void)logout:(NSString *)argResult {
    @try {
        if([self.delegate respondsToSelector:@selector(logoutPMS:)]) {
            [self.delegate logoutPMS:[APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:argResult]?YES:NO];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS logoutPMS : %@", exception);
    }
}

- (void)configMsgResult:(NSString *)argResult msgFlag:(BOOL)argFlag {
    @try {
        if([self.delegate respondsToSelector:@selector(msgFlagPMS:msgFlag:)]) {
            [self.delegate msgFlagPMS:[APPPUSH_NETWORK_SUCCESS_CODE isEqualToString:argResult]?YES:NO msgFlag:argFlag];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS configMsgResult : %@", exception);
    }
}

- (void)updateNewMessageCount:(int)argCount {
    @try {
        if([self.delegate respondsToSelector:@selector(newMessageCount:)]) {
            [self.delegate newMessageCount:argCount];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS updateNewMessageCount : %@", exception);
    }
}

- (void)interlockMain:(NSString *)argLink data:(NSString *)argData {
    @try {
        
        [PMS closeMessageBox];
        if([self.delegate respondsToSelector:@selector(interlockPMS:data:)]) {
            [self.delegate interlockPMS:(argLink==nil || [@"" isEqualToString:argLink])?GSSHOP_HOME_URL:argLink
                                   data:argData];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS interlockPMS : %@", exception);
    }
}
//shawnPMS 추가

- (void)interlockTBTOUCHMain:(NSString *)argLink data:(NSString *)argData {
    @try {
        
        [PMS closeMessageBox];
        if([self.delegate respondsToSelector:@selector(interlockTBTOUCHPMS:data:)]) {
            [self.delegate interlockTBTOUCHPMS:(argLink==nil || [@"" isEqualToString:argLink])?GSSHOP_HOME_URL:argLink
                                          data:argData];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS interlockPMS : %@", exception);
    }
}
//yunsang.jin 추가
- (void)interlockTouchHeader:(NSString *)argLink data:(NSString *)argData {
    @try {
        
        [PMS closeMessageBox];
        if([self.delegate respondsToSelector:@selector(interlockTouchHeader:data:)]) {
            [self.delegate interlockTouchHeader:(argLink==nil || [@"" isEqualToString:argLink])?GSSHOP_HOME_URL:argLink
                                           data:argData];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at PMS interlockPMS : %@", exception);
    }
}

@end

