#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AppPushDatabase : NSObject
+ (AppPushDatabase *)sharedInstance;
- (id)init;
- (void)initDB;

//MSG_GRP,MSG COMMON
- (void)deleteAllData;
- (void)truncateMsg;

//MSG
- (int)getAllNewMsgCntMsg;
- (void)addMsg:(NSDictionary *)argDic;
- (NSMutableArray *)getMsgList:(NSString*)argMsgId
                      rowCount:(int)argRowCount;
- (BOOL)isMsg:(NSString*)argWhere;
- (NSDictionary *)getMsg:(NSString*)argWhere;
- (int)getMsgCount:(NSString*)argWhere;
//- (void)setMsgReadY:(NSDictionary *)argDicMsg;
- (void)setMsgReadY:(NSString *)argMsgIds;
- (NSArray *)getMsgCodeListFromMsg:(NSString *)argWhere;
- (void)deleteMsg:(NSString *)argWhere;
- (int)getMinMsgCode;
- (NSString *)getMsgId:(NSString *)argWhere;

- (NSString *)getPushImg:(NSString *)msgId;
- (NSDictionary *)checkDistinctMsgUid:(NSString*)msgUid;
@end