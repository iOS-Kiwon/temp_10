//
//  DataManager.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//


#import "DataManager.h"
#import "MemberDB.h"
#import "LoginData.h"
#import "LatelySearchData.h"
#import "PushData.h"
#import "URLDefine.h"
#import "AppDelegate.h"

@implementation DataManager
@synthesize userData;
@synthesize searchWordList;
@synthesize appVersion;
@synthesize pushInfoList;
@synthesize userName;
@synthesize userPass;
@synthesize updataYN;
@synthesize mainInit;
@synthesize loginYN;
@synthesize cameraFlag;
@synthesize selectTab;
@synthesize cameraImage;
@synthesize helpMsgState;
@synthesize qrcodeFlag;
@synthesize goodsShowFlag;
@synthesize photoLimit;
@synthesize caller;

@synthesize videoSizeLimit;

@synthesize photoSeletedCount;
@synthesize arrPhotoSeleted;
@synthesize imguploadTargetUrlstr;
@synthesize imguploadTargetJsFuncstr;
@synthesize uploadfiletypestr;
@synthesize abBestdealVer,abBulletVer;

@synthesize movieOperation;
@synthesize movieCore;
@synthesize arrMovieQueue;
@synthesize movieProgress;
@synthesize movieProgressTimer;

@synthesize customerNo;
@synthesize strSNSINFO_URL;
@synthesize strPath;
@synthesize dicIntroInfo;
@synthesize lastSideViewController;
@synthesize arrSideInterestCateNumber;

+ (DataManager *)sharedManager {
    static DataManager *singleton = nil;
    if( singleton == nil ) {
        @synchronized( self ) {
            if( singleton == nil ) {
                singleton = [[self alloc] init];
            }
        }
    }
    return singleton;
}

- (id)init {
    self = [super init];
    if(self) {
        database = [[MemberDB alloc]init];
        self.userData = nil;//유저이름, 포인트 받아옴
        self.pushInfoList = nil;
        self.appVersion = nil;
        self.updataYN = 0;
        self.mainInit = @"0";
        self.loginYN = @"N";
        self.cameraFlag = NO;
        self.helpMsgState = NO;
        self.qrcodeFlag = NO;
        self.goodsShowFlag = NO;
        self.arrPhotoSeleted = [[NSMutableArray alloc] init];
        self.imguploadTargetUrlstr = @"";
        self.imguploadTargetJsFuncstr = @"";
        self.uploadfiletypestr = @"";
        self.photoLimit = 0;
        self.caller = @"";
        self.videoSizeLimit = 0;
        self.abBestdealVer = @"A";
        self.abBulletVer = @"A";
        self.movieCore = [[NetCore_Download alloc] initCoreHostName:nil apiPath:nil customHeaderFields:nil];
        self.arrMovieQueue = [[NSMutableArray alloc] init];
        self.movieProgress = 0.0;
        self.strPath = nil;
        self.dicIntroInfo = nil;
        self.lastSideViewController = nil;
        self.arrSideInterestCateNumber = [[NSMutableArray alloc] init];
        self.strGlobalSound = nil;
        self.strGlobal3GAgree = nil;
        self.strGlobalSoundForWebPrd = nil;
        self.brigCoveAutoPlayYn = NO;
        self.imageLastUpload = nil;
        
    }
    return  self;
}


//앱 버전 알기 - Build version
-(NSString *)AppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"build = %@",build);
    return build;
}

// kiwon : Swift에서 CustomerNo 접근시 사용
-(NSString *) getCustomerNoInSwift {
    //현재 서버에서 CustomerNo값을 어디에서는 String으로,
    // 어떤곳에서는 NSNumber로 주고 있으며, 이때 Swift에서 접근시
    // 실제로는 NSNumber인 값을 String으로 가져오면서 오류가 발생한다.
    // Error Msg :
    //      -[__NSCFNumber length]: unrecognized selector sent to instance 0x97efaa8b180765ae
    //      Execution was interrupted, reason: internal ObjC exception breakpoint(-5)..
    return [NSString stringWithFormat:@"%@",[DataManager sharedManager].customerNo];
}

#pragma mark -
#pragma mark LOGINDATA


+ (LoginData *) loadLoginData {
    
    // 메모리에 있는지 판단
    if([DataManager sharedManager].m_loginData.loginid != nil && [DataManager sharedManager].m_loginData.loginid.length > 0)
        return [DataManager sharedManager].m_loginData;
    
    @synchronized ([DataManager sharedManager].m_loginData) {
        
        NSData *data = LL(@"UD_LOGINDATA");
        [DataManager sharedManager].m_loginData = (LoginData *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([DataManager sharedManager].m_loginData == nil)
        {
            [DataManager sharedManager].m_loginData = [[LoginData alloc] init];
            [DataManager sharedManager].m_loginData.loginid = @"";
            [DataManager sharedManager].m_loginData.serieskey = @"";
            [DataManager sharedManager].m_loginData.authtoken = @"";
            [DataManager sharedManager].m_loginData.simplelogin = 0;
            [DataManager sharedManager].m_loginData.autologin = 0;
            [DataManager sharedManager].m_loginData.saveid = 0;
        }
        return [DataManager sharedManager].m_loginData;
    }
}

//[DataManager setUserInfo:[result objectForKey:@"custNm"] grade:[result valueForKey:@"grade"]];
//[[DataManager sharedManager]setUserName:[result objectForKey:@"custNm"]];
+ (NSString *) getUserNm {
    NSLog(@"UNM: %@     %@",LL(@"UNM"), [NSKeyedUnarchiver unarchiveObjectWithData:LL(@"UNM")]);
    return NCS((NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:LL(@"UNM")]);
}

+ (NSString *) getUserGr {
    NSLog(@"UGR: %@     %@",LL(@"UGR"), [NSKeyedUnarchiver unarchiveObjectWithData:LL(@"UGR")]);
    return NCS((NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:LL(@"UGR")]);
}

+ (void) setUserInfo:(NSString *)Nm grade:(NSString *)gr {
    NSData *EncodedObject = [NSKeyedArchiver archivedDataWithRootObject:Nm];
    SL(EncodedObject, @"UNM");
    NSData *EncodedObject2 = [NSKeyedArchiver archivedDataWithRootObject:gr];
    SL(EncodedObject2, @"UGR");
}





+ (BOOL) saveLoginData {
    
    @synchronized ([DataManager sharedManager].m_loginData) {
        if([DataManager sharedManager].m_loginData != nil) {
            NSData *EncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[DataManager sharedManager].m_loginData];
            SL(EncodedObject, @"UD_LOGINDATA");
            return YES;
        }
        else {
            SL(nil, @"UD_LOGINDATA");
            return YES;
        }
        return  NO;
    }
}



- (void) GetLoginData {
    // nami0342 - UserDefault에 로그인 데이터가 있는지 체크
    [DataManager loadLoginData];
}


- (void)updateLoginAuthToken:(NSString *)neoauthToken {
    @synchronized ([DataManager sharedManager].m_loginData) {
        [DataManager sharedManager].m_loginData.authtoken = neoauthToken;
    }
    [DataManager saveLoginData];    
}


- (void)deleteLoginInfo {
    @synchronized ([DataManager sharedManager].m_loginData) {
        [DataManager sharedManager].m_loginData = nil;
    }
    [DataManager saveLoginData];
    
    if(database != nil) {
        [database deleteLoginInfo];
    }
    
    SL(nil, @"UNM");
    SL(nil, @"UGR");
    
    [[Common_Util sharedInstance] saveToLocalData];
    
}




#pragma mark -
#pragma mark Push Info


+ (PushData *) loadPushData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"UD_PUSHDATA"];
    [DataManager sharedManager].m_pushData = (PushData *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if([DataManager sharedManager].m_pushData == nil)
    {
        [DataManager sharedManager].m_pushData = [[PushData alloc] init];
        [DataManager sharedManager].m_pushData.custNo = @"";
        [DataManager sharedManager].m_pushData.deviceToken  = @"";
    }
    
    return [DataManager sharedManager].m_pushData;
}





+ (BOOL) savePushData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([DataManager sharedManager].m_pushData != nil)
    {
        NSData *EncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[DataManager sharedManager].m_pushData];
        [userDefaults setObject:EncodedObject forKey:@"UD_PUSHDATA"];
        [userDefaults synchronize];
        return YES;
    }
    else
    {
        [userDefaults removeObjectForKey:@"UD_PUSHDATA"];
        [userDefaults synchronize];
        return YES;
    }
    
    return  NO;
}


- (void) getPushInfo
{
    // nami0342 - UserDefault에 push 데이터가 있는지 체크
    [DataManager loadPushData];
    
    if([self.m_pushData.deviceToken isEqualToString:@""] == YES)
    {
        if(database == nil)
        {
            // Pass
        }
        else
        {
            self.pushInfoList = [database getPushInfo];
            if([self.pushInfoList count] == 0)
            {   // DB는 있는데, push 정보가 없을 경우
                // Pass
            }
            else
            {   // DB에 push 정보가 있는 경우 로컬에 저장
                [DataManager savePushData];
            }
        }
    }
    else
    {
    }    


}


- (void)insertPushInfo:(id)pushinfo
{
    self.m_pushData = pushinfo;
    [DataManager savePushData];

}


- (void)deletePushInfo
{
    [DataManager sharedManager].m_pushData = nil;
    [DataManager savePushData];
    
    if(database != nil)
        [database deletePushInfo];
    
}



-(void)downLoadIntroImages:(NSDictionary *)dicInfo isRetry:(BOOL)retry{

    NSString *strImageUrl = [dicInfo objectForKey:@"imageUrl"];
    
#if DEBUG
//    strImageUrl = @"https://upload.wikimedia.org/wikipedia/commons/0/05/01E_May_15_2013_1750Z.jpg";
#endif
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = NCA(paths)?[paths objectAtIndex:0]:@"";
    
    isIntroRetry = retry;
    self.dicIntroInfo = dicInfo;
    
    if ([NCS(strImageUrl) length] > 0 ) {
        [self checkAndSaveAsyncFileUrl:strImageUrl andPath:documentsDirectory andType:downLoadTypeIntro];
    }
    else {
        //인트로일경우 기존파일이 동일한 이름으로 존재할경우 삭제하고 진행
        if ([NCS([dicInfo objectForKey:@"modiDate"]) length] == 0 || [NCS([dicInfo objectForKey:@"endDate"]) length] == 0 || [NCS([dicInfo objectForKey:@"imageUrl"]) length] == 0) {
            NSFileManager *manager = [NSFileManager defaultManager];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dicSplash = [userDefaults objectForKey:DIC_SPLASH];
            
            if (dicSplash != nil) {
                NSLog(@"[userDefaults objectForKey:DIC_SPLASH] = %@",[userDefaults objectForKey:DIC_SPLASH]);
                
                if ([manager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory,[dicSplash objectForKey:@"imageName"]]]) {
                    [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory,[dicSplash objectForKey:@"imageName"]] error:nil];
                }
                
                [userDefaults removeObjectForKey:DIC_SPLASH];
                [userDefaults synchronize];

                NSLog(@"[userDefaults objectForKey:DIC_SPLASH] = %@",[userDefaults objectForKey:DIC_SPLASH]);
            }

        }
        
    }
   
}

- (void)introUserInfo:(NSDictionary *) dicInfo {
    // 별도로 등급 문구 저장한다
    //appIntroTxt
    NSArray *infoTxtList = [dicInfo objectForKey:DIC_SPLASH_TXT];
    
    NSMutableDictionary *splachInfoText = [[NSMutableDictionary alloc] init];
    for (NSDictionary *infoDic in infoTxtList) {
        [splachInfoText setObject:infoDic forKey:[infoDic objectForKey:@"grade"]];
    }
    
    
    NSUserDefaults *spl = [NSUserDefaults standardUserDefaults];
    
    @synchronized (spl) {
        if (NCO(splachInfoText)) {
            [spl setValue:splachInfoText forKey:DIC_SPLASH_TXT];
        }
        else {
            [spl removeObjectForKey:DIC_SPLASH_TXT];
        }
        [spl synchronize];
    }
//
//    if (NCO(splachInfoText)) {
//        SL(splachInfoText,DIC_SPLASH_TXT);
//    }
//    else {
//        SL(nil,DIC_SPLASH_TXT);
//    }
}



#pragma mark -
#pragma mark async file down load
-(void)checkAndSaveAsyncFileUrl:(NSString *)strUrl andPath:(NSString *)strSavePath andType:(DownLoadType)type{

    NSString *strMoviePath = nil;
    NSString *realSavePath = nil;
    
    NSString *strFileName = [[strUrl componentsSeparatedByString:@"/"] lastObject];
    
    
    if (strSavePath != nil) {
        self.strPath = strSavePath;
    }else{
        self.strPath = [ApplicationDelegate.gsshop_img_core cacheDirectoryName];
    }
    
    
    realSavePath = [NSString stringWithFormat:@"%@/%@",self.strPath,strFileName];

    NSLog(@"realSavePath = %@",realSavePath);
    
    NSFileManager *manager = [NSFileManager defaultManager];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if (type == downLoadTypeIntro && realSavePath != nil) {
        
        NSLog(@"[userDefaults objectForKey:DIC_SPLASH] = %@",[userDefaults objectForKey:DIC_SPLASH]);
        
        if ([manager fileExistsAtPath:realSavePath]) {
            [manager removeItemAtPath:realSavePath error:nil];
        }
        
        [userDefaults removeObjectForKey:DIC_SPLASH];
        [userDefaults synchronize];
        
        NSLog(@"[userDefaults objectForKey:DIC_SPLASH] = %@",[userDefaults objectForKey:DIC_SPLASH]);
    }
    
    
    if ([manager fileExistsAtPath:realSavePath]){
        strMoviePath = realSavePath;
    
        return;
    }else{

        
        NSString *strTempFile = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),strFileName];
        
        if ([manager fileExistsAtPath:strTempFile]) {
            [manager removeItemAtPath:strTempFile error:nil];
        }
        
        NSLog(@"strTempFile = %@",strTempFile);
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        [urlRequest setHTTPMethod:@"GET"];
        
        //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
        

        [NSURLSession Async_sendSessionRequest:urlRequest timeout:TIMEOUT_INTERVAL_REQUEST returnBlock:^(NSData *taskData, NSURLResponse *response, NSError *error) {
            NSData *data = taskData;
            if (data != nil) {
                [data writeToFile:strTempFile atomically:YES];
                
                if([manager moveItemAtPath:strTempFile toPath:realSavePath error:&error]){
                    NSLog(@"file moved to %@",realSavePath);
                    
                    if (type == downLoadTypeIntro) {
                        NSMutableDictionary *dicSave = [NSMutableDictionary dictionary];
                        [dicSave addEntriesFromDictionary:self.dicIntroInfo];
                        [dicSave setObject:strFileName forKey:@"imageName"];
                        
                        //테스트용
                        //[dicSave setObject:@"20160208235959" forKey:@"endDate"];
                        [userDefaults setObject:dicSave forKey:DIC_SPLASH];
                        [userDefaults synchronize];
                    }
                }else{
                    NSLog(@"file move failed : %@", error.localizedDescription);
                }
            } else {
                // 1차 시도 실패시, 어떻게 해야할까요...ㅠ
                [NSURLSession Async_sendSessionRequest:urlRequest timeout:TIMEOUT_INTERVAL_REQUEST returnBlock:^(NSData *taskData, NSURLResponse *response, NSError *error) {
                    NSData *data = taskData;
                    if (data != nil) {
                        [data writeToFile:strTempFile atomically:YES];
                        
                        if([manager moveItemAtPath:strTempFile toPath:realSavePath error:&error]){
                            NSLog(@"file moved to %@",realSavePath);
                            
                            if (type == downLoadTypeIntro) {
                                NSMutableDictionary *dicSave = [NSMutableDictionary dictionary];
                                [dicSave addEntriesFromDictionary:self.dicIntroInfo];
                                [dicSave setObject:strFileName forKey:@"imageName"];
                                
                                //테스트용
                                //[dicSave setObject:@"20160208235959" forKey:@"endDate"];
                                
                                [userDefaults setObject:dicSave forKey:DIC_SPLASH];
                                [userDefaults synchronize];
                            }
                        }
                        else{
                            NSLog(@"file move failed : %@", error.localizedDescription);
                        }
                    }
                }];
            }
        }];
    }
}
-(void)checkNextDownLoad{
    [self.movieOperation cancel];
    self.movieOperation = nil;
    
    NSLog(@"movieOperation = %@",self.movieOperation);
    NSLog(@"arrMovieQueue = %@",self.arrMovieQueue);
    
    if ([arrMovieQueue count] > 0 ) {
        
        DownLoadType type;
        if (self.dicIntroInfo == nil) {
            type = downLoadTypeMovie;
        }else{
            type = downLoadTypeIntro;
        }
        
        [self checkAndSaveAsyncFileUrl:[arrMovieQueue objectAtIndex:0] andPath:self.strPath andType:type];
        
        
        [arrMovieQueue removeObjectAtIndex:0];

    }else{
        self.dicIntroInfo = nil;
    }
    
}

-(void)checkMovieProgress:(NSTimer *)sender{
    
    NSNumber *numBeforeProgress = sender.userInfo;
    
    double beforeProgress = [numBeforeProgress doubleValue];
    
    NSLog(@"beforeProgress = %f",beforeProgress);
    NSLog(@"movieProgress = %f",movieProgress);
    
    
    if ([self.movieProgressTimer isValid]) {
        [self.movieProgressTimer invalidate];
        self.movieProgressTimer = nil;
    }
    
    if (beforeProgress == movieProgress) {
        
        NSLog(@"movieProgress = %f",movieProgress);
        
        if ((int)movieProgress != 100 && isIntroRetry) {
            
            [self.movieOperation cancel];
            self.movieOperation = nil;
            [self downLoadIntroImages:self.dicIntroInfo isRetry:NO];

            
            
        }else{
            [self checkNextDownLoad];
        }
        
    }else{
        self.movieProgressTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkMovieProgress:) userInfo:[NSNumber numberWithDouble:movieProgress] repeats:NO];
    }
    
    
    
    
}


@end
