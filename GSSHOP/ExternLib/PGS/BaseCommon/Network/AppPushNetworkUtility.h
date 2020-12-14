#import <Foundation/Foundation.h>
#import "AppPushCustomURLConnection.h"
#import "AppPushSecureDataUtil.h"
#import "AmailJSON.h"
#import "AppPushConstants.h"
#import "AppPushUtil.h"

@interface AppPushNetworkUtility : NSObject  <NSURLConnectionDataDelegate> {
    NSMutableDictionary *receivedData;
    AppPushCustomURLConnection *connection;
    NSMutableArray      *arrQueue;
    BOOL                isReCert;
    BOOL                isCertNetwork;
    
    AmailSBJSON         *jsonParser;
    NSMutableString     *successTime;
    NSDateFormatter     *df;
    NSString            *apiUrl;
}
@property (nonatomic, retain) NSMutableDictionary *receivedData;

- (id)init;
- (NSString *)objectToJSON:(id)argData;
- (void)checkQueue;
- (void)minusQueue;
- (void)minusQueue:(NSString *)argTag;
- (void)addNetworkQueue:(NSURL*)url
                 params:(NSString *)params
                   type:(int)type
                    tag:(NSString*)tag
                 cipher:(NSString *)argCipher
                 object:(id)argObject;
- (NSString *)getLastSuccessTime;
@end