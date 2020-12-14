#import "AppPushNetworkAPI.h"
@implementation AppPushNetworkAPI

+ (AppPushNetworkAPI *)sharedNetworkAPI {
    static AppPushNetworkAPI *networkAPI = nil;
    if (networkAPI == nil) {
        @synchronized(self) {
            if (networkAPI == nil) {
                networkAPI = [[self alloc] init];
            }
        }
    }
    return networkAPI;
}

#pragma mark - GSShop
- (void)getGSShopUserInfo:(NSString *)argCustId object:(id)argObject {
    @try {
        
        NSString *strUrl = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"GSShopApiUrl"];
        
        [self addNetworkQueue:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", strUrl,argCustId]]
                       params:nil
                         type:0
                          tag:APPPUSH_NOTI_GSSHOP
                       cipher:APPPUSH_NETWORK_UNCIPHER
                       object:argObject];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility getGSShopUserInfo : %@", exception);
    }
}

#pragma mark - Device Cert
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
            object:(id)argObject {
    @try {
        
        NSString * params;
        if(argUserInfo!=nil) {
            
            NSString *strUserInfo = [self objectToJSON:argUserInfo];
            
            if([@"" isEqualToString:strUserInfo]) {
                params = [NSString stringWithFormat:APPPUSH_DEVICE_PARAM_ARGS,
                          argCustId,
                          argDeviceId,
                          argWaPcId,
                          argPushToken,
                          argOsVer,
                          argAppVer,
                          argDevice,
                          argUuid,
                          argAppKey,
                          argAdvrId,
                          argPcId];
            } else {
                params = [NSString stringWithFormat:APPPUSH_DEVICE_PARAM_USER_INFO_ARGS,
                          argCustId,
                          argDeviceId,
                          argWaPcId,
                          argPushToken,
                          argOsVer,
                          argAppVer,
                          argDevice,
                          argUuid,
                          argAppKey,
                          strUserInfo,
                          argAdvrId,
                          argPcId];
            }
            
        } else {
            params = [NSString stringWithFormat:APPPUSH_DEVICE_PARAM_ARGS,
                      argCustId,
                      argDeviceId,
                      argWaPcId,
                      argPushToken,
                      argOsVer,
                      argAppVer,
                      argDevice,
                      argUuid,
                      argAppKey,
                      argAdvrId,
                      argPcId];
        }
        
        //        NSLog(@"param : %@",params);
        
        [self addNetworkQueue:[NSURL URLWithString:[NSString stringWithFormat:@"%@/deviceCert.m", apiUrl]]
                       params:params
                         type:1
                          tag:APPPUSH_NOTI_DEVICE
                       cipher:APPPUSH_NETWORK_UNCIPHER
                       object:argObject];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility deviceCert : %@", exception);
    }
}
#pragma mark - New Message
- (void)getNewMsg:(NSString *)argStandardMsgId
        groupCode:(NSString *)argGroupCode
       courseType:(NSString *)argType
          pageNum:(int)argPageNum
           rowNum:(int)argRowNum
           object:(id)argObject {
    @try {
        
        NSString *dataParams = [NSString stringWithFormat:APPPUSH_NOTI_NEW_MESSAGE_PARAM_ARGS,
                                argType==nil?@"N":argType,
                                argStandardMsgId==nil?@"-1":argStandardMsgId,
                                argGroupCode==nil?@"-1":argGroupCode,
                                argPageNum,
                                argRowNum];
        
        //NSLog(@"getNewMsg dataParams : %@",dataParams);
        
        [self addNetworkQueue:[NSURL URLWithString:[NSString stringWithFormat:@"%@/newMsg.m", apiUrl]]
                       params:dataParams
                         type:1
                          tag:APPPUSH_NOTI_NEW_MESSAGE
                       cipher:APPPUSH_NETWORK_CIPHER
                       object:argObject];
        
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility getNewMessage : %@", exception);
    }
}


#pragma mark - Read Message
- (void)setReadMsg:(NSString *)argReadMsgIds object:(id)argObject {
    
    @try {
        
        if(argReadMsgIds==nil) return;
        
        NSString *dataParams = [NSString stringWithFormat:APPPUSH_NOTI_READ_MESSAGE_PARAM_ARGS,
                                argReadMsgIds];
        
        [self addNetworkQueue:[NSURL URLWithString:[NSString stringWithFormat:@"%@/readMsg.m", apiUrl]]
                       params:dataParams
                         type:1
                          tag:APPPUSH_NOTI_READ_MESSAGE
                       cipher:APPPUSH_NETWORK_CIPHER
                       object:argObject];
        
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility getNewMessage : %@", exception);
    }
    
}

#pragma mark - Click Message

- (void)setClickMsg:(NSString *)argClickParam object:(id)argObject {
    
    @try {
        
        if(argClickParam!=nil && argClickParam.length>0) {
            
            NSString *dataParams = [NSString stringWithFormat:APPPUSH_NOTI_CLICK_MESSAGE_PARAM_ARGS,argClickParam];
            //NSLog(@"dataParams :%@",dataParams);
            
            [self addNetworkQueue:[NSURL URLWithString:[NSString stringWithFormat:@"%@/clickMsg.m", apiUrl]]
                           params:dataParams
                             type:1
                              tag:APPPUSH_NOTI_CLICK_MESSAGE
                           cipher:APPPUSH_NETWORK_CIPHER
                           object:argObject];
            
        }
        
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility getNewMessage : %@", exception);
    }
    
}

#pragma mark - set Config
- (void)setConfig:(BOOL)argMsgFlag {
    @try {
        NSString *params = [NSString stringWithFormat:APPPUSH_NOTI_SET_CONFIG_PARAM_ARGS, argMsgFlag==YES?@"Y":@"N", argMsgFlag==YES?@"Y":@"N"];
        [self addNetworkQueue:[NSURL URLWithString:[NSString stringWithFormat:@"%@/setConfig.m",apiUrl]]
                       params:params
                         type:1
                          tag:APPPUSH_NOTI_SET_CONFIG
                       cipher:APPPUSH_NETWORK_CIPHER
                       object:nil];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility setConfig : %@", exception);
    }
}

#pragma mark - Log In

- (void)login:(NSString *)argCustId userInfo:(NSDictionary *)argUserInfo {
    @try {
        
        NSString *params;
        if(argUserInfo!=nil && [argUserInfo count]>0) {
            NSString *strUserInfo = [self objectToJSON:argUserInfo];
            if([@"" isEqualToString:strUserInfo]) {
                params = [NSString stringWithFormat:APPPUSH_NOTI_LOGIN_PARAM_ARGS, argCustId];
            } else {
                params = [NSString stringWithFormat:APPPUSH_NOTI_LOGIN_PARAM_USER_INFO_ARGS, argCustId, strUserInfo];
            }
            
        } else {
            params = [NSString stringWithFormat:APPPUSH_NOTI_LOGIN_PARAM_ARGS, argCustId];
            
        }
        
        //NSLog(@"params : %@",params);
        
        [self addNetworkQueue:[NSURL URLWithString:[NSString stringWithFormat:@"%@/loginPms.m",apiUrl]]
                       params:params
                         type:1
                          tag:APPPUSH_NOTI_LOGIN
                       cipher:APPPUSH_NETWORK_CIPHER
                       object:nil];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility login : %@", exception);
    }
}

#pragma mark - Log Out
- (void)logout:(NSString *)argCustId {
    @try {
        NSString *params = [NSString stringWithFormat:APPPUSH_NOTI_LOGOUT_PARAM_ARGS, argCustId];
        [self addNetworkQueue:[NSURL URLWithString:[NSString stringWithFormat:@"%@/logoutPms.m",apiUrl]]
                       params:params
                         type:1
                          tag:APPPUSH_NOTI_LOGOUT
                       cipher:APPPUSH_NETWORK_CIPHER
                       object:nil];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility logout : %@", exception);
    }
}

#pragma mark - Session out
- (void)sessionOut {
    @try {
        NSString *params = APPPUSH_NOTI_SESSION_OUT_PARAM_ARGS;
        [self addNetworkQueue:[NSURL URLWithString:[NSString stringWithFormat:@"%@/sessionErrorTest.m",apiUrl]]
                       params:params
                         type:1
                          tag:APPPUSH_NOTI_SESSION_OUT
                       cipher:APPPUSH_NETWORK_CIPHER
                       object:nil];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility setssionOut : %@", exception);
    }
}

@end

