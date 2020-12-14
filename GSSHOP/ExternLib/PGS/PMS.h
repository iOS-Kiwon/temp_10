//
//  PMS Lib ver. 1.2.1
//

enum {
    PMSNotiStart = 1,
    PMSNotiForeground = 2,
    PMSNotiBackground = 3
};
typedef NSUInteger PMSNotiTime;

@protocol PMSDelegate<NSObject>
@optional
- (BOOL)showPMS;
- (void)authorizePMS:(BOOL)argResult;
- (void)loginPMS:(BOOL)argResult;
- (void)logoutPMS:(BOOL)argResult;
- (void)newMessageCount:(int)argCount;
- (void)msgFlagPMS:(BOOL)argResult msgFlag:(BOOL)argFlag;
- (void)interlockPMS:(NSString *)argLinkNew
                data:(NSString *)argData;
//shawnPMS 추가
- (void)interlockTBTOUCHPMS:(NSString *)argLinkNew
                       data:(NSString *)argData;
//yunsang.jin 추가
- (void)interlockTouchHeader:(NSString *)argLinkNew
                        data:(NSString *)argData;
@end

@interface PMS: NSObject {
    //    id<PMSDelegate> delegate;
}

@property(nonatomic, assign) id<PMSDelegate> delegate;

#pragma mark - PMS UI Method
+ (void)showMessageBox;
+ (void)closeMessageBox;

#pragma mark - PMS Base Method
+ (void)initializePMS;
+ (void)setPMSDelegate:(id<PMSDelegate>)argDelegate;
+ (void)setPushToken:(NSData *)argTokenData;
+ (void)setUserId:(NSString *)argUserId;
+ (void)setDeviceUid:(NSString *)argDeviceUid;
+ (void)setWaPcId:(NSString *)argWaPcIdId;
+ (void)setAdvrId:(NSString *)argAdvrId;
+ (void)setPcId:(NSString *)argPcId;

+ (NSString *)getUserId;
+ (NSString *)getAdvrId;
+ (BOOL)getMsgFlag;
+ (int)getNewMessageCount;

//PMS network setting (result PMSDelegate)
+ (BOOL)authorize;
+ (void)login;
+ (void)logout;
+ (void)setMsgFlag:(BOOL)argIsMsg;
+ (void)receivePush:(NSDictionary *)argDic notiTime:(PMSNotiTime)argNotiTime;

+ (NSString *)getPushImg:(NSString *)msgId;


@end

