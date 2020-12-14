#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MOCHA/Mocha_Alert.h>
#import "AppPushMessageViewController.h"
#import "AppPushMessageRichViewController.h"
#import <sys/sysctl.h>

#import "AppDelegate.h"

#define APPPUSH_CLICK_LINK              @"APPPUSH_CLICK_LINK"
@protocol AppPushMainDelegate<NSObject>
- (void)closePMS;
- (void)login:(NSString *)argResult;
- (void)logout:(NSString *)argResult;
- (void)configMsgResult:(NSString *)argResult msgFlag:(BOOL)argFlag;
- (void)authorize:(NSString *)argResult;
- (void)updateNewMessageCount:(int)argCount;
- (void)interlockMain:(NSString *)argLink data:(NSString *)argData;
//shawnPMS 추가
- (void)interlockTBTOUCHMain:(NSString *)argLink data:(NSString *)argData;
//yunsang.jin 추가
- (void)interlockTouchHeader:(NSString *)argLink data:(NSString *)argData;
@end

@interface AppPushMainViewController : UIViewController <AppPushMessageDelegate, AppPushMessageRichDelegate, Mocha_AlertDelegate>{
    AppPushMessageViewController            *vcMsg;
    AppPushMessageRichViewController        *vcMsgRich;
    UIImageView                             *ivTitle;
    UILabel                                 *lblTitle;
    UIButton                                *btnClose;
    
    UIImageView                             *ivNoti;
    UILabel                                 *lblNoti1;
    UILabel                                 *lblNoti2;

//    id<AppPushMainDelegate>                 delegate;
    int                                     isCert;
    int                                     currentPageNum;
    
    BOOL                                    isMsgFlag;
    BOOL                                    isTempMsgFlag;
    BOOL                                    isFirstNewMsg;
    BOOL                                    isPopUp;
    BOOL                                    isShowPGS;
    BOOL                                    isChangeUser;
    
    NSString                                *curGroupCode;
    
    NSMutableDictionary                     *dicRead;
    int                                     readCount;
    
    //SystemSoundID                           soundIDNoti;
    NSMutableDictionary                     *dicNoti;
    NSMutableDictionary                     *dicMsg;
    int                                     notiTime;
    NSArray                                 *arrMsgTempList;
    
}
@property(nonatomic, retain) AppPushMessageViewController  *vcMsg;
@property(nonatomic, assign) id<AppPushMainDelegate> delegate;
@property(nonatomic, assign) int isCert;
@property(nonatomic, assign) BOOL isShowPGS;
@property(nonatomic, assign) BOOL isChangeUser;
@property(nonatomic, retain) NSString *curGroupCode;
- (id)init;
- (void)setNotiDic:(NSDictionary *)argDic notiTime:(int)argNotiTime;
- (void)showMainView;
- (void)getNewMsg:(NSString *)argStandardMsgId
          msgCode:(NSString *)argMsgCode
       courseType:(NSString *)argType;
- (void)getNewMsgWithPush;
- (void)notiUnReadMessage:(BOOL)argIsCert;
- (void)deviceCert;
- (void)pressShow;
- (void)setMsgFlag:(BOOL)argIsMsg;
- (void)startLogin;
- (void)startLogout;
- (void)checkClickMsg;
- (void)checkReadMsg;
- (int)findUnReadMessage:(BOOL)argIsCert;

- (void)sessionOut;

- (NSString *)getPushImg:(NSString *)msgId;

@end