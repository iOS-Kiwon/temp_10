//
//  DataManager.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetCore_Download.h"

typedef enum {
    downLoadTypeIntro,
    downLoadTypeMovie,
} DownLoadType;

@class MemberDB;
@class LoginData;
@class PushData;

#define imageAlbumThumbSize CGSizeMake(400.0, 400.0)

@interface DataManager : NSObject {
    
    MemberDB *database;
    NSMutableArray *userData;//유저이름, 포인트 받아옴
    
    
    NSMutableArray *searchWordList;//검색어 저장 리스트
    NSString *appVersion;
    NSMutableArray *pushInfoList;
    
    NSString *userName;
    NSString *userPass;
    
    NSInteger updataYN;
    NSString *mainInit;
    NSString *loginYN;
    BOOL helpMsgState;
    
    BOOL cameraFlag;
    NSInteger selectTab;
    UIImage *cameraImage;
    BOOL qrcodeFlag;
    BOOL goodsShowFlag;//상품평에서 단품을 보기 위해 다시 모달뷰를 띄우기 위한 플래그
    
    NSMutableArray *arrMovieQueue;
    double __block movieProgress;
    
    //상품평을 위한 CustNo 저정
    NSString *customerNo;
    
    //SNS처리를 위한 SNSINFO_URL 저장
    NSString *strSNSINFO_URL;
   
    BOOL isIntroRetry;

}
@property (nonatomic,strong)NSMutableArray *userData;
@property (nonatomic,strong)NSMutableArray *searchWordList;
@property (nonatomic,strong)NSString *appVersion;
@property (nonatomic,strong)NSMutableArray *pushInfoList;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userPass;
@property (nonatomic) NSInteger updataYN;
@property (nonatomic,strong) NSString *mainInit;
@property (nonatomic,strong) NSString *loginYN;
@property (nonatomic) BOOL cameraFlag;
@property (nonatomic)NSInteger selectTab;
@property (nonatomic)BOOL helpMsgState;
@property (nonatomic,strong) UIImage *cameraImage;
@property (nonatomic)BOOL qrcodeFlag;
@property (nonatomic)BOOL goodsShowFlag;
//ABTEST
@property (nonatomic,strong) NSString *abBestdealVer;
//@property (nonatomic,strong) NSString *abBestdealObj;
@property (nonatomic,strong) NSString *abBulletVer;
//@property (nonatomic,strong) NSString *abBulletObj; 

@property (nonatomic, assign) unsigned long photoLimit;
@property (nonatomic, assign) unsigned long photoSeletedCount;
@property (nonatomic, strong) NSString *caller; //이미지 동작

@property (nonatomic, assign) unsigned long videoSizeLimit;

@property (nonatomic, strong) NSMutableArray *arrPhotoSeleted;
@property (nonatomic, strong) NSMutableString *appServerVersion;
@property (nonatomic,strong) NSString *imguploadTargetUrlstr;
@property (nonatomic,strong) NSString *imguploadTargetJsFuncstr;
@property (nonatomic,strong) NSString *uploadfiletypestr;

@property (nonatomic,strong) MochaNetworkOperation *movieOperation;
@property (nonatomic,strong) NetCore_Download *movieCore;
@property (nonatomic,strong) NSMutableArray *arrMovieQueue;
@property (nonatomic,assign) double __block movieProgress;
@property (nonatomic,assign) NSTimer *movieProgressTimer;

@property (nonatomic,strong) NSString *customerNo;
@property (nonatomic,strong) NSString *strSNSINFO_URL;
@property (nonatomic,strong) NSString *strPath; //파일저장 경로
@property (nonatomic,strong) NSDictionary *dicIntroInfo; //인트로JSON 정보

@property (nonatomic, strong) LoginData *m_loginData;
@property (nonatomic, strong) PushData  *m_pushData;

@property (nonatomic, weak) id lastSideViewController;
@property (nonatomic,strong) NSMutableArray *arrSideInterestCateNumber;

@property (nonatomic,strong) NSString *strGlobalSound;
@property (nonatomic,strong) NSString *strGlobalSoundForWebPrd;
@property (nonatomic,strong) NSString *strGlobal3GAgree;
@property (nonatomic,assign) BOOL brigCoveAutoPlayYn;
@property (nonatomic,strong) UIImage *imageLastUpload;

+ (DataManager *)sharedManager;
//데이터 파싱 작업
//login data
- (void)GetLoginData;
- (void)updateLoginAuthToken:(NSString *)neoauthToken;
- (void)deleteLoginInfo;

+ (NSString *) getUserNm;
+ (NSString *) getUserGr;
+ (void) setUserInfo:(NSString *)Nm grade:(NSString *)gr;

//Pushinfo
- (void) getPushInfo;
- (void)insertPushInfo:(id)pushinfo;
- (void)deletePushInfo;

-(void)downLoadIntroImages:(NSDictionary *)dicInfo isRetry:(BOOL)retry;
- (void)introUserInfo:(NSDictionary *) dicInfo; //인트로에 노출되는 사용자 등급별 메세지 

-(void)checkAndSaveAsyncFileUrl:(NSString *)strUrl andPath:(NSString *)strSavePath andType:(DownLoadType)type;

// nami0342 - LoginData Save / Load - User Default
+ (LoginData *) loadLoginData;
+ (BOOL) saveLoginData;

// nami0342 - Push data save / load
+ (PushData *) loadPushData;
+ (BOOL) savePushData;

// kiwon : Swift에서 CustomerNo 접근시 사용
-(NSString *) getCustomerNoInSwift;

@end
