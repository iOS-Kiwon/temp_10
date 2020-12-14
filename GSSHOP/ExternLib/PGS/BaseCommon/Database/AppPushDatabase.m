#import "AppPushDatabase.h"
#import "AmailFMDatabase.h"
#import "AppPushConstants.h"
@implementation AppPushDatabase
static AppPushDatabase  *sharedDatabase = nil;
AmailFMDatabase *db;
+ (AppPushDatabase *)sharedInstance
{
    //debugshawn
    /*
     if (sharedDatabase == nil)
     {
     @synchronized(self) {
     if (!sharedDatabase)
     {
     sharedDatabase = [[self alloc] init];
     
     
     }
     }
     }
     
     return sharedDatabase;
     */
    
    @synchronized([AppPushDatabase class]) {
        if(sharedDatabase == nil) {
            sharedDatabase = [[self alloc] init];
        }
        return sharedDatabase;
    }
    return nil;
    
}
+ (id)alloc
{
    @synchronized([AppPushDatabase class]) {
        sharedDatabase = [[super alloc] init];
        return sharedDatabase;
    }
    return nil;
}
- (id)init
{
    @try {
        if (sharedDatabase == nil) {
            return self;
        }
        self = [super init];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase init : %@", exception);
    }
    return self;
}
- (void)setDB {
    @try {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dir = [paths objectAtIndex : 0];
        db = [AmailFMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"PMSDatabase.db"]];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase setDB : %@", exception);
    }
}
- (void)initDB {
    @try {
        [self setDB];
        [db open];
        NSLog(@"databasePath : %@",[db databasePath]);
        
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS TBL_MSG_EX (_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,TITLE TEXT,MSG TEXT,MAP1 TEXT,MAP2 TEXT,MAP3 TEXT,MSG_CODE TEXT,MSG_ID TEXT,COMMON_MSG_ID TEXT,MSG_TYPE TEXT,ATTACH_INFO TEXT,READ_YN TEXT,APP_LINK TEXT,ICON_NAME TEXT,EXP_DATE TEXT,REG_DATE TEXT,MSG_UID TEXT,APP_USER_ID TEXT,OWNER_YN TEXT DEFAULT 'N')"];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase initDB : %@",exception);
    }@finally {
        [db close];
        
        // TBL_MSG의 확장 여부 검토
        [self checkForTableMigration];
    }
}

- (void) checkForTableMigration
{
    BOOL migrationComplete = NO;
    @try {
        [self setDB];
        [db open];
        AmailFMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) FROM sqlite_master WHERE name='TBL_MSG'"];
        if([rs next]) {
            // 마이그레이션 대상 판별
            if([[rs objectForColumnIndex:0] intValue] > 0){
                migrationComplete = YES;
            }
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase addMsg : %@",exception);
    }@finally {
        [db close];
        if(migrationComplete){
            [self migrationTable];
        }
    }
}

- (void) migrationTable {
    // 기존테이블의 ROW를 _EX 테이블로 이동
    NSArray *arrTempMsgList = [self getOldMsgList];
    NSString *appUserId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:APPPUSH_DEF_APP_USER_ID]];
    
    for(NSDictionary* dic in arrTempMsgList){
        [[AppPushDatabase sharedInstance] addMsg:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  [dic valueForKey:AMAIL_MSG_TITLE]!=nil?[dic valueForKey:AMAIL_MSG_TITLE]:@"",
                                                  AMAIL_MSG_TITLE,
                                                  [dic valueForKey:AMAIL_MSG_MSG]!=nil?[dic valueForKey:AMAIL_MSG_MSG]:@"",
                                                  AMAIL_MSG_MSG,
                                                  [dic valueForKey:AMAIL_MSG_MSG_CODE]!=nil?[dic valueForKey:AMAIL_MSG_MSG_CODE]:@"",
                                                  AMAIL_MSG_MSG_CODE,
                                                  [dic valueForKey:AMAIL_MSG_MSG_ID]!=nil?[dic valueForKey:AMAIL_MSG_MSG_ID]:@"",
                                                  AMAIL_MSG_MSG_ID,
                                                  [dic valueForKey:AMAIL_MSG_COMMON_MSG_ID]!=nil?[dic valueForKey:AMAIL_MSG_COMMON_MSG_ID]:@"",
                                                  AMAIL_MSG_COMMON_MSG_ID,
                                                  [dic valueForKey:AMAIL_MSG_MSG_TYPE]!=nil?[dic valueForKey:AMAIL_MSG_MSG_TYPE]:@"",
                                                  AMAIL_MSG_MSG_TYPE,
                                                  [dic valueForKey:AMAIL_MSG_ATTACH_INFO]!=nil?[dic valueForKey:AMAIL_MSG_ATTACH_INFO]:@"",
                                                  AMAIL_MSG_ATTACH_INFO,
                                                  [dic valueForKey:AMAIL_MSG_READ_YN]!=nil?[dic valueForKey:AMAIL_MSG_READ_YN]:@"N",
                                                  AMAIL_MSG_READ_YN,
                                                  [dic valueForKey:AMAIL_MSG_EXP_DATE]!=nil?[dic valueForKey:AMAIL_MSG_EXP_DATE]:@"",
                                                  AMAIL_MSG_EXP_DATE,
                                                  [dic valueForKey:AMAIL_MSG_REG_DATE]!=nil?[dic valueForKey:AMAIL_MSG_REG_DATE]:@"",
                                                  AMAIL_MSG_REG_DATE,
                                                  [dic valueForKey:AMAIL_MSG_MAP1]!=nil?[dic valueForKey:AMAIL_MSG_MAP1]:@"",
                                                  AMAIL_MSG_MAP1,
                                                  [dic valueForKey:AMAIL_MSG_MAP2]!=nil?[dic valueForKey:AMAIL_MSG_MAP2]:@"",
                                                  AMAIL_MSG_MAP2,
                                                  [dic valueForKey:AMAIL_MSG_MAP3]!=nil?[dic valueForKey:AMAIL_MSG_MAP3]:@"",
                                                  AMAIL_MSG_MAP3,
                                                  [dic valueForKey:AMAIL_MSG_APP_LINK]!=nil?[dic valueForKey:AMAIL_MSG_APP_LINK]:@"",
                                                  AMAIL_MSG_APP_LINK,
                                                  [dic valueForKey:AMAIL_MSG_ICON_NAME]!=nil?[dic valueForKey:AMAIL_MSG_ICON_NAME]:@"",
                                                  AMAIL_MSG_ICON_NAME,
                                                  [dic valueForKey:AMAIL_MSG_MSG_ID],
                                                  AMAIL_MSG_UID,
                                                  appUserId,
                                                  AMAIL_MSG_APP_USER_ID,
                                                  @"Y",
                                                  AMAIL_MSG_OWNER,
                                                  nil]];

    }
    
    [self dropOldTable];
}

- (void) dropOldTable {
    @try {
        [self setDB];
        [db open];
        [db executeUpdate:@"DROP TABLE TBL_MSG"];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase addMsg : %@",exception);
    }@finally {
        [db close];
    }
}

#pragma mark - msgGrp msg common
- (void)deleteAllData {
    [self deleteMsg:nil];
}

- (int)getAllNewMsgCntMsg {
    int unReadCount = 0;
    @try {
        [self setDB];
        [db open];
        AmailFMResultSet *results = [db executeQuery:@"SELECT COUNT(_ID) FROM TBL_MSG_EX WHERE READ_YN = 'N'"];
        if([results next]) {
            unReadCount = [[results objectForColumnIndex:0] intValue];
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getAllNewMsgCntMsgGrp : %@",exception);
        unReadCount = 0;
    }@finally {
        [db close];
    }
    return unReadCount;
}

#pragma mark - msg
- (void)addMsg:(NSDictionary *)argDic {
    if(argDic==nil) return;
    //NSLog(@"argDic : %@",argDic);
    @try {
        
        [self setDB];
        [db open];
        [db executeUpdate:@"INSERT INTO TBL_MSG_EX ( TITLE, MSG, MAP1, MAP2, MAP3, MSG_CODE, MSG_ID, COMMON_MSG_ID, MSG_TYPE, ATTACH_INFO, APP_LINK, ICON_NAME, READ_YN, EXP_DATE, REG_DATE, MSG_UID, APP_USER_ID, OWNER_YN) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
         [argDic objectForKey:AMAIL_MSG_TITLE],
         [argDic objectForKey:AMAIL_MSG_MSG],
         [argDic objectForKey:AMAIL_MSG_MAP1],
         [argDic objectForKey:AMAIL_MSG_MAP2],
         [argDic objectForKey:AMAIL_MSG_MAP3],
         [argDic objectForKey:AMAIL_MSG_MSG_CODE],
         [argDic objectForKey:AMAIL_MSG_MSG_ID],
         [argDic objectForKey:AMAIL_MSG_COMMON_MSG_ID],
         [argDic objectForKey:AMAIL_MSG_MSG_TYPE],
         [argDic objectForKey:AMAIL_MSG_ATTACH_INFO],
         [argDic objectForKey:AMAIL_MSG_APP_LINK],
         [argDic objectForKey:AMAIL_MSG_ICON_NAME],
         [argDic objectForKey:AMAIL_MSG_READ_YN],
         [argDic objectForKey:AMAIL_MSG_EXP_DATE],
         [argDic objectForKey:AMAIL_MSG_REG_DATE],
         [argDic objectForKey:AMAIL_MSG_UID],
         [argDic objectForKey:AMAIL_MSG_APP_USER_ID],
         [argDic objectForKey:AMAIL_MSG_OWNER]];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase addMsg : %@",exception);
    }@finally {
        [db close];
    }
}

- (NSMutableArray *)getMsgList:(NSString*)argMsgId
                      rowCount:(int)argRowCount {
    NSMutableArray* items = [NSMutableArray array];
    @try {
        [self setDB];
        [db open];
        NSString *str_sql;
        if(argMsgId==nil) {
            str_sql = [NSString stringWithFormat:@"SELECT _ID,TITLE,MSG,MAP1,MAP2,MAP3,MSG_CODE,MSG_ID,COMMON_MSG_ID,MSG_TYPE,ATTACH_INFO,READ_YN,APP_LINK,ICON_NAME,EXP_DATE,REG_DATE FROM TBL_MSG_EX ORDER BY REG_DATE DESC,CAST(MSG_ID AS INTEGER) DESC "];
        } else {
            str_sql = [NSString stringWithFormat:@"SELECT _ID,TITLE,MSG,MAP1,MAP2,MAP3,MSG_CODE,MSG_ID,COMMON_MSG_ID,MSG_TYPE,ATTACH_INFO,READ_YN,APP_LINK,ICON_NAME,EXP_DATE,REG_DATE FROM TBL_MSG_EX WHERE CAST(MSG_ID AS INTEGER) < %@ ORDER BY REG_DATE DESC,CAST(MSG_ID AS INTEGER) DESC ",argMsgId];
        }
        
        //NSLog(@"str_sql : %@",str_sql);
        AmailFMResultSet *results = [db executeQuery:str_sql];
        while ([results next]) {
            [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              [[results objectForColumnIndex:0] stringValue],   AMAIL_MSG_ID,
                              [results objectForColumnIndex:1]!=nil?[results objectForColumnIndex:1]:@"",                 AMAIL_MSG_TITLE,
                              [results objectForColumnIndex:2]!=nil?[results objectForColumnIndex:2]:@"",                 AMAIL_MSG_MSG,
                              [results objectForColumnIndex:3]!=nil?[results objectForColumnIndex:3]:@"",                 AMAIL_MSG_MAP1,
                              [results objectForColumnIndex:4]!=nil?[results objectForColumnIndex:4]:@"",                 AMAIL_MSG_MAP2,
                              [results objectForColumnIndex:5]!=nil?[results objectForColumnIndex:5]:@"",                 AMAIL_MSG_MAP3,
                              [results objectForColumnIndex:6]!=nil?[results objectForColumnIndex:6]:@"",                 AMAIL_MSG_MSG_CODE,
                              [results objectForColumnIndex:7]!=nil?[results objectForColumnIndex:7]:@"",                 AMAIL_MSG_MSG_ID,
                              [results objectForColumnIndex:8]!=nil?[results objectForColumnIndex:8]:@"",                 AMAIL_MSG_COMMON_MSG_ID,
                              [results objectForColumnIndex:9]!=nil?[results objectForColumnIndex:9]:@"",                 AMAIL_MSG_MSG_TYPE,
                              [results objectForColumnIndex:10]!=nil?[results objectForColumnIndex:10]:@"",                AMAIL_MSG_ATTACH_INFO,
                              [results objectForColumnIndex:11]!=nil?[results objectForColumnIndex:11]:@"",                AMAIL_MSG_READ_YN,
                              [results objectForColumnIndex:12]!=nil?[results objectForColumnIndex:12]:@"",                AMAIL_MSG_APP_LINK,
                              [results objectForColumnIndex:13]!=nil?[results objectForColumnIndex:13]:@"",                AMAIL_MSG_ICON_NAME,
                              [results objectForColumnIndex:14]!=nil?[results objectForColumnIndex:14]:@"",                AMAIL_MSG_EXP_DATE,
                              [results objectForColumnIndex:15]!=nil?[results objectForColumnIndex:15]:@"",                AMAIL_MSG_REG_DATE,
                              nil]];
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getMsgList : %@",exception);
        items = nil;
    }@finally {
        [db close];
    }
    return items;
}

- (NSMutableArray *)getOldMsgList
{
    NSMutableArray* items = [NSMutableArray array];
    @try {
        [self setDB];
        [db open];
        NSString *str_sql = [NSString stringWithFormat:@"SELECT _ID,TITLE,MSG,MAP1,MAP2,MAP3,MSG_CODE,MSG_ID,COMMON_MSG_ID,MSG_TYPE,ATTACH_INFO,READ_YN,APP_LINK,ICON_NAME,EXP_DATE,REG_DATE FROM TBL_MSG ORDER BY REG_DATE DESC,CAST(MSG_ID AS INTEGER) DESC "];
        
        //NSLog(@"str_sql : %@",str_sql);
        AmailFMResultSet *results = [db executeQuery:str_sql];
        while ([results next]) {
            [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              [[results objectForColumnIndex:0] stringValue],   AMAIL_MSG_ID,
                              [results objectForColumnIndex:1]!=nil?[results objectForColumnIndex:1]:@"",AMAIL_MSG_TITLE,
                              [results objectForColumnIndex:2]!=nil?[results objectForColumnIndex:2]:@"",AMAIL_MSG_MSG,
                              [results objectForColumnIndex:3]!=nil?[results objectForColumnIndex:3]:@"",AMAIL_MSG_MAP1,
                              [results objectForColumnIndex:4]!=nil?[results objectForColumnIndex:4]:@"",AMAIL_MSG_MAP2,
                              [results objectForColumnIndex:5]!=nil?[results objectForColumnIndex:5]:@"",AMAIL_MSG_MAP3,
                              [results objectForColumnIndex:6]!=nil?[results objectForColumnIndex:6]:@"",AMAIL_MSG_MSG_CODE,
                              [results objectForColumnIndex:7]!=nil?[results objectForColumnIndex:7]:@"",AMAIL_MSG_MSG_ID,
                              [results objectForColumnIndex:8]!=nil?[results objectForColumnIndex:8]:@"",AMAIL_MSG_COMMON_MSG_ID,
                              [results objectForColumnIndex:9]!=nil?[results objectForColumnIndex:9]:@"",AMAIL_MSG_MSG_TYPE,
                              [results objectForColumnIndex:10]!=nil?[results objectForColumnIndex:10]:@"",AMAIL_MSG_ATTACH_INFO,
                              [results objectForColumnIndex:11]!=nil?[results objectForColumnIndex:11]:@"",AMAIL_MSG_READ_YN,
                              [results objectForColumnIndex:12]!=nil?[results objectForColumnIndex:12]:@"",AMAIL_MSG_APP_LINK,
                              [results objectForColumnIndex:13]!=nil?[results objectForColumnIndex:13]:@"",AMAIL_MSG_ICON_NAME,
                              [results objectForColumnIndex:14]!=nil?[results objectForColumnIndex:14]:@"",AMAIL_MSG_EXP_DATE,
                              [results objectForColumnIndex:15]!=nil?[results objectForColumnIndex:15]:@"",AMAIL_MSG_REG_DATE,
                              nil]];
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getMsgList : %@",exception);
        items = nil;
    }@finally {
        [db close];
    }
    return items;
}

- (NSArray *)getMsgCodeListFromMsg:(NSString *)argWhere {
    NSMutableArray* items = [NSMutableArray array];
    @try {
        [self setDB];
        [db open];
        AmailFMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT MSG_CODE FROM TBL_MSG_EX %@",argWhere!=nil?argWhere:@""]];
        while ([results next]) {
            [items addObject:[results objectForColumnIndex:0]];
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getMsgListHaveNewMsgCnt : %@",exception);
        items = nil;
    }@finally {
        [db close];
    }
    return items;
}

- (BOOL)isMsg:(NSString*)argWhere {
    if(argWhere==nil) return NO;
    BOOL isMsg = NO;
    @try {
        [self setDB];
        [db open];
        NSString *str_sql = [NSString stringWithFormat:@"SELECT _ID FROM TBL_MSG_EX %@",argWhere];
        //NSLog(@"str_sql : %@",str_sql);
        AmailFMResultSet *results = [db executeQuery:str_sql];
        if([results next]) {
            isMsg = YES;
        }
        
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getMsg : %@",exception);
    }@finally {
        [db close];
    }
    //NSLog(@"isMsg :%@",isMsg?@"YES":@"NO");
    return isMsg;
}

- (NSDictionary *)checkDistinctMsgUid:(NSString*)msgUid
{
    NSMutableDictionary *distinctResult = nil;
    @try {
        [self setDB];
        [db open];
        AmailFMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT _ID,APP_USER_ID,OWNER_YN FROM TBL_MSG_EX WHERE MSG_UID = '%@'", msgUid]];
        if([results next]) {
            distinctResult = [NSMutableDictionary new];
            [distinctResult setValue:[results objectForColumnIndex:0] forKey:AMAIL_MSG_ID];
            [distinctResult setValue:[results objectForColumnIndex:1] forKey:AMAIL_MSG_APP_USER_ID];
            [distinctResult setValue:[results objectForColumnIndex:2] forKey:AMAIL_MSG_OWNER];
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getAllNewMsgCntMsgGrp : %@",exception);
        distinctResult = nil;
    }@finally {
        [db close];
    }
    return distinctResult;
}

- (NSDictionary *)getMsg:(NSString*)argWhere {
    if(argWhere==nil) return nil;
    NSMutableDictionary* item = [NSMutableDictionary dictionary];
    @try {
        [self setDB];
        [db open];
        NSString *str_sql = [NSString stringWithFormat:@"SELECT TITLE,MSG,MAP1,MAP2,MAP3,MSG_CODE,MSG_ID,COMMON_MSG_ID,MSG_TYPE,ATTACH_INFO,READ_YN,EXP_DATE,REG_DATE,APP_LINK FROM TBL_MSG_EX %@",argWhere];
        //NSLog(@"str_sql : %@",str_sql);
        AmailFMResultSet *results = [db executeQuery:str_sql];
        while ([results next]) {
            [item setDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [results objectForColumnIndex:0]!=nil?[results objectForColumnIndex:0]:@"",     AMAIL_MSG_TITLE,
                                 [results objectForColumnIndex:1]!=nil?[results objectForColumnIndex:1]:@"",     AMAIL_MSG_MSG,
                                 [results objectForColumnIndex:2]!=nil?[results objectForColumnIndex:2]:@"",     AMAIL_MSG_MAP1,
                                 [results objectForColumnIndex:3]!=nil?[results objectForColumnIndex:3]:@"",     AMAIL_MSG_MAP2,
                                 [results objectForColumnIndex:4]!=nil?[results objectForColumnIndex:4]:@"",     AMAIL_MSG_MAP3,
                                 [results objectForColumnIndex:5]!=nil?[results objectForColumnIndex:5]:@"",     AMAIL_MSG_MSG_CODE,
                                 [results objectForColumnIndex:6]!=nil?[results objectForColumnIndex:6]:@"",     AMAIL_MSG_MSG_ID,
                                 [results objectForColumnIndex:7]!=nil?[results objectForColumnIndex:7]:@"",     AMAIL_MSG_COMMON_MSG_ID,
                                 [results objectForColumnIndex:8]!=nil?[results objectForColumnIndex:8]:@"",     AMAIL_MSG_MSG_TYPE,
                                 [results objectForColumnIndex:9]!=nil?[results objectForColumnIndex:9]:@"",     AMAIL_MSG_ATTACH_INFO,
                                 [results objectForColumnIndex:10]!=nil?[results objectForColumnIndex:10]:@"",    AMAIL_MSG_READ_YN,
                                 [results objectForColumnIndex:11]!=nil?[results objectForColumnIndex:11]:@"",    AMAIL_MSG_EXP_DATE,
                                 [results objectForColumnIndex:12]!=nil?[results objectForColumnIndex:12]:@"",    AMAIL_MSG_REG_DATE,
                                 [results objectForColumnIndex:13]!=nil?[results objectForColumnIndex:13]:@"",    AMAIL_MSG_APP_LINK,
                                 nil]];
        }
        
        if([item count]==0) {
            item = nil;
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getMsg : %@",exception);
        item = nil;
    }@finally {
        [db close];
    }
    return item;
}

- (int)getMsgCount:(NSString*)argWhere {
    int msgCount = 0;
    @try {
        [self setDB];
        [db open];
        NSString *str_sql = [NSString stringWithFormat:@"SELECT SUM(_ID) FROM TBL_MSG_EX %@",argWhere==nil?@"":argWhere];
        AmailFMResultSet *results = [db executeQuery:str_sql];
        if([results next]) {
            msgCount = [[results objectForColumnIndex:0] intValue];
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getMsgCount : %@",exception);
        msgCount = 0;
    }@finally {
        [db close];
    }
    return msgCount;
    
}

- (void)setMsgReadY:(NSString *)argMsgIds {
    if(argMsgIds==nil) return;
    
    @try {
        
        [self setDB];
        [db open];
        NSString *str_sql = [NSString stringWithFormat:@"UPDATE TBL_MSG_EX SET READ_YN = 'Y' WHERE MSG_ID IN (%@)",argMsgIds];
        //NSLog(@"str_sql : %@",str_sql);
        [db executeUpdate:str_sql];
        
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase setMsgReadY : %@",exception);
    }@finally {
        [db close];
    }
}

- (void)deleteMsg:(NSString *)argWhere {
    @try {
        [self setDB];
        [db open];
        NSString *str_sql = [NSString stringWithFormat:@"DELETE FROM TBL_MSG_EX %@",argWhere!=nil?argWhere:@""];
        [db executeUpdate:str_sql];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase deleteMsg : %@",exception);
    }
    @finally {
        [db close];
    }
}

- (void)truncateMsg {
    @try {
//        NSLog(@"truncateMsg called");
        [self setDB];
        [db open];
        //        [db executeUpdate:@"DELETE FROM TBL_MSG"];
        //        [db executeUpdate:@"DELETE FROM sqlite_sequence WHERE name = 'TBL_MSG'"];
        [db executeUpdate:@"DELETE FROM TBL_MSG_EX"];
        [db executeUpdate:@"DELETE FROM sqlite_sequence WHERE name = 'TBL_MSG_EX'"];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase deleteMsg : %@",exception);
    }
    @finally {
        [db close];
    }
}


- (NSString *)getMsgId:(NSString *)argWhere {
    if(argWhere==nil) return nil;
    NSString *msgId;
    @try {
        [self setDB];
        [db open];
        NSString *str_sql = [NSString stringWithFormat:@"SELECT MSG_ID FROM TBL_MSG_EX %@",argWhere];
        AmailFMResultSet *results = [db executeQuery:str_sql];
        if([results next]) {
            msgId =  [results objectForColumnIndex:0]!=nil?[results objectForColumnIndex:0]:@"";
        } else {
            msgId = nil;
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getMsgCount : %@",exception);
        msgId = nil;
    }@finally {
        [db close];
    }
    return msgId;
}


#pragma mark - for lotte.com

- (int)getMinMsgCode {
    
    int item = 0;
    @try {
        [self setDB];
        [db open];
        NSString *str_sql = [NSString stringWithFormat:@"SELECT MSG_CODE FROM TBL_MSG_EX ORDER BY CAST(MSG_CODE AS INTEGER) LIMIT 1"];
        //NSLog(@"str_sql : %@",str_sql);
        AmailFMResultSet *results = [db executeQuery:str_sql];
        while ([results next]) {
            item = [[results objectForColumnIndex:0] intValue];
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getMinMsgCode : %@",exception);
        item = 0;
    }@finally {
        [db close];
    }
    return item;
}

#pragma mark - for GS

- (NSString *)getPushImg:(NSString *)msgId{
    NSString *pushImg;
    @try {
        [self setDB];
        [db open];
        NSString *str_sql = [NSString stringWithFormat:@"SELECT MAP3 FROM TBL_MSG_EX where MSG_ID = %@",msgId];
        
        AmailFMResultSet *results = [db executeQuery:str_sql];
        if ([results next]) {
            pushImg = [results objectForColumnIndex:0]!=nil?[results objectForColumnIndex:0]:@"";
        }else{
            pushImg = nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at ChatDatabase getPushImg : %@",exception);
    }
    @finally {
        [db close];
    }
    return pushImg;
}

@end