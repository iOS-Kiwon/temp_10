#import "AppPushNetworkUtility.h"
#import "AppPushConstants.h"

@interface AppPushNetworkAPI : AppPushNetworkUtility

+(AppPushNetworkAPI *)sharedNetworkAPI;

- (void)getGSShopUserInfo:(NSString *)argCustId
                   object:(id)argObject;
- (void)deviceCert:(NSString *)argCustId
          deviceId:(NSString *)argDeviceId
            waPcId:(NSString *)argWaPcId
         pushToken:(NSString *)argPushToken
         osVersion:(NSString *)argOsVer
        appVersion:(NSString *)argAppVer
            device:(NSString *)argDevice
              uuid:(NSString *)argUuid
            appKey:(NSString *)argAppKey
            advrId:(NSString *)argAdvrId
              pcId:(NSString *)argPcId
          userInfo:(NSDictionary *)argUserInfo
            object:(id)argObject;
- (void)getNewMsg:(NSString *)argStandardMsgId
        groupCode:(NSString *)argGroupCode
       courseType:(NSString *)argType
          pageNum:(int)argPageNum
           rowNum:(int)argRowNum
           object:(id)argObject;
- (void)setReadMsg:(NSString *)argReadMsgIds
            object:(id)argObject;
- (void)setClickMsg:(NSString *)argClickParam
             object:(id)argObject;
- (void)setConfig:(BOOL)argMsgFlag;
- (void)login:(NSString *)argCustId userInfo:(NSDictionary *)argUserInfo;
- (void)logout:(NSString *)argCustId;
- (void)sessionOut;

@end

