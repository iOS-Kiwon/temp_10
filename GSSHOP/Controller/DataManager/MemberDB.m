//
//  MemberDB.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "MemberDB.h"
#import "AppDelegate.h"
#import "LoginData.h"
#import "LatelySearchData.h"
#import "PushData.h"


static sqlite3 *database = nil;

@implementation MemberDB

- (id)init
{
    if((self = [super init]))
    {
        NSLog(@"MemberDB Init");
        NSString *path = [NSString stringWithFormat:@"%@/%@",DOCS_DIR,DBFileName];
        //NSLog(@"path = %@",path);
        if(sqlite3_open([path UTF8String], &database) != SQLITE_OK)
        {
            sqlite3_close(database);
            // NSAssert(0, @"Failed to open database");
        }
    }
    return  self;
}

- (void)dealloc
{
    sqlite3_close(database);
}
#pragma mark -
#pragma mark CREATE TABLE
- (void)CreateDatabase
{
    char *errorMsg;
    
    //"loginId":"로그인아이디",
    //"userName":"사용자명",
    //"customerNumber":"고객번호",
    //"seriesKey":"시리즈키",
    //"authToken":"인증토큰"}
    //"autologin INTEGER,"
    //"saveid INTEGER)";
    
    
    
    
    //AutoLogin table
    NSString *createTokenLoginSQL = @"CREATE TABLE IF NOT EXISTS 'tbl_authtoken' ("
    @"pk INTEGER PRIMARY KEY, "
    @"loginid VARCHAR,"
    //@"username VARCHAR,"
    //@"customernumber VARCHAR,"
    @"serieskey VARCHAR,"
    @"authtoken VARCHAR,"
    @"autologin INTEGER,"
    @"simplelogin INTEGER,"
    @"saveid INTEGER)";
    
    if(sqlite3_exec(database, [createTokenLoginSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"tbl_authtoken = %s", errorMsg);
    }
    
    
    
    
    /*
     //AutoLogin table
     NSString *createAutoLoginSQL = @"CREATE TABLE IF NOT EXISTS 'tbl_logininfo' ("
     @"pk INTEGER PRIMARY KEY, "
     @"username VARCHAR,"
     @"userpass VARCHAR,"
     @"autologin INTEGER,"
     @"saveid INTEGER)";
     
     if(sqlite3_exec(database, [createAutoLoginSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
     {
     sqlite3_close(database);
     NSLog(@"tbl_logininfo = %s", errorMsg);
     }
     */
    
    
    //최근 검색어 리스트
    NSString *createSearchWordSQL = @"CREATE TABLE IF NOT EXISTS 'tbl_searchwordlist' ("
    @"pk INTEGER PRIMARY KEY, "
    @"searchword VARCHAR, "
    @"schtype VARCHAR, "
    @"schtime VARCHAR)";
    
    if(sqlite3_exec(database, [createSearchWordSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"tbl_searchwordlist = %s", errorMsg);
    }
    
    //APP version inof
    NSString *createAppVersionSQL = @"CREATE TABLE IF NOT EXISTS 'tbl_appversion' ("
    @"pk INTEGER PRIMARY KEY, "
    @"version VARCHAR)";
    
    if(sqlite3_exec(database, [createAppVersionSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"tbl_searchwordlist = %s", errorMsg);
    }
    
    
    
    
    //푸시 데이터
    NSString *createPushInfoSQL = @"CREATE TABLE IF NOT EXISTS 'tbl_pushinfo' ("
    @"pk INTEGER PRIMARY KEY, "
    @"deviceToken VARCHAR,"
    @"custNo VARCHAR)";
    
    if(sqlite3_exec(database, [createPushInfoSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        sqlite3_close(database);
        //NSLog(@"tbl_pushinfo = %@", errorMsg);
    }
    
    NSLog(@"DB_Create OK");
    
}
//테이블 유무 판단
-(BOOL)tableExistCheck:(NSString *)checkquery
{
    
    NSLog(@"checkquery = %@",checkquery);
    NSString *query = checkquery;
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK )
    {
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            
            sqlite3_finalize(statement);
            return YES;
        }
        
        sqlite3_finalize(statement);
        return NO;
        
    }
    return  NO;
}
-(void)DropTable:(NSString *)str
{
    NSString *query = [NSString stringWithFormat:@"DROP TABLE IF EXISTS '%@'",str];
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK ) {
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
        }
        sqlite3_finalize(statement);
    }
}
-(void)allTableDrop
{
    [self DropTable:@"tbl_authtoken"];
    [self DropTable:@"tbl_searchwordlist"];
    [self DropTable:@"tbl_pushinfo"];
    [self DropTable:@"tbl_appversion"];
}
#pragma mark -
#pragma mark USER INFO
//get login data
- (NSMutableArray *)getLoginInfo
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *query = @"SELECT * FROM 'tbl_authtoken'";
    sqlite3_stmt *statement;
    
    
    /*
     NSString *createTokenLoginSQL = @"CREATE TABLE IF NOT EXISTS 'tbl_authtoken' ("
     @"pk INTEGER PRIMARY KEY, "
     @"loginid VARCHAR,"
     @"username VARCHAR,"
     @"customernumber VARCHAR,"
     @"serieskey VARCHAR,"
     @"authtoken VARCHAR,"
     @"autologin INTEGER,"
     @"simplelogin INTEGER,"
     @"saveid INTEGER)";
     */
    
    if( sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK ) {
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            LoginData *obj = [DataManager sharedManager].m_loginData;
            
            
            obj.loginid =  [[GSCryptoHelper sharedInstance] decrypt256String:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]];
            //obj.username = [[GSCryptoHelper sharedInstance] decrypt256String:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)]];
            //obj.customernumber = [[GSCryptoHelper sharedInstance] decrypt256String:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)]];
            obj.serieskey = [[GSCryptoHelper sharedInstance] decrypt256String:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)]];
            obj.authtoken = [[GSCryptoHelper sharedInstance] decrypt256String:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)]];
            
            
            obj.autologin = sqlite3_column_int(statement, 4);
            obj.simplelogin = sqlite3_column_int(statement, 5);
            obj.saveid = sqlite3_column_int(statement, 6);
            // NSLog(@"select pk = %d  id=%@ autologin=%d simplelogin=%d saveid=%d",sqlite3_column_int(statement, 0),obj.loginid,obj.autologin,obj.simplelogin, obj.saveid);
            
            [array addObject:obj];
        }
        sqlite3_finalize(statement);
    }
    return array;
    
}
/*
 - (BOOL) isExixtUser : (NSString *)userName
 {
 BOOL bRet = YES;
 
 int DuplicateBooksCount = 0;
	NSString *sql = @"SELECT count(*) FROM 'tbl_authtoken' WHERE username=?";
	sqlite3_stmt *stmt;
 
	if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
 {
 sqlite3_bind_text(stmt, 1, [[[GSCryptoHelper sharedInstance] encrypt256String:userName] UTF8String], -1, NULL);
 if (sqlite3_step(stmt) == SQLITE_ROW)
 {
 DuplicateBooksCount = sqlite3_column_int(stmt, 0);
 //NSLog(@"DuplicateBookcount : %d", DuplicateBooksCount);
 }
	}
	sqlite3_finalize(stmt);
 
	if( DuplicateBooksCount > 0 ) bRet = YES;
	else    bRet = NO;
 
 return bRet;
 }
 */




//사용하지 않음  - update아닌 삭제하는걸루
- (void) clearAutoLogin
{
    
    NSString* zeroPassword = @"";
    char *update = "UPDATE 'tbl_authtoken' SET autologin=?, userpass=? WHERE autologin=?";
    sqlite3_stmt *stmt;
    if( sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK )
    {
        int zeroVal = 0, oneVal = 1;
        sqlite3_bind_int(stmt, 1, zeroVal);
        sqlite3_bind_text(stmt, 2, [zeroPassword UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 3, oneVal);
        NSLog(@"하임 update = %s",update);
    }
    if( sqlite3_step(stmt) != SQLITE_DONE ){
//        NSAssert1( 0, @"Error updating table: %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt);
    
}


- (BOOL)insertLoginInfo:(id)loginInfo
{
    BOOL bRet = TRUE;
    
    
    LoginData *newData = (LoginData *)loginInfo;
    char *update = "INSERT INTO 'tbl_authtoken' (loginid, serieskey, authtoken, autologin, simplelogin, saveid) VALUES (?, ?, ?, ?, ?, ?)";
    sqlite3_stmt *stmt;
    if( sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK )
    {
        sqlite3_bind_text(stmt, 1, ((int)[newData autologin]==1)?[[[GSCryptoHelper sharedInstance] encrypt256String:newData.loginid] UTF8String]:"", -1, NULL);
        
        
        //sqlite3_bind_text(stmt, 2, ((int)[newData autologin]==1)?[[[GSCryptoHelper sharedInstance] encrypt256String:newData.username] UTF8String]:"", -1, NULL);
        
        //sqlite3_bind_text(stmt, 3, ((int)[newData autologin]==1)?[[[GSCryptoHelper sharedInstance] encrypt256String:newData.customernumber] UTF8String]:"", -1, NULL);
        
        sqlite3_bind_text(stmt, 2, ((int)[newData autologin]==1)?[[[GSCryptoHelper sharedInstance] encrypt256String:newData.serieskey] UTF8String]:"", -1, NULL);
        
        sqlite3_bind_text(stmt, 3, ((int)[newData autologin]==1)?[[[GSCryptoHelper sharedInstance] encrypt256String:newData.authtoken] UTF8String]:"", -1, NULL);
        
        sqlite3_bind_int(stmt, 4, (int)[newData autologin]);
        sqlite3_bind_int(stmt, 5, (int)[newData simplelogin]);
        sqlite3_bind_int(stmt, 6, (int)[newData saveid]);
        // NSLog(@"insert = newData.userName = %@,newData.userPass=%@",newData.userName,newData.userPass);
        NSLog(@"insert Data");
    }
    else
    {
        NSLog(@"database insert error");
        
        bRet = FALSE;
    }
    //NSLog(@"insert = %s",update);
    if( sqlite3_step(stmt) != SQLITE_DONE )
    {
//        NSAssert1( 0, @"Error insert data table: %s", sqlite3_errmsg(database) );
        
        bRet = FALSE;
    }
    sqlite3_finalize(stmt);
    
    return bRet;
}
- (void)deleteLoginInfo
{
    //	char *errorMsg;
    char *sql = "DELETE FROM 'tbl_authtoken'";
    
    sqlite3_stmt *stmt;
    if( sqlite3_prepare_v2(database, sql, -1, &stmt, nil) == SQLITE_OK ) {
        //sqlite3_bind_int(stmt, 1, (int)[group gid]);
        NSLog(@"delete from ");
    }
    if( sqlite3_step(stmt) != SQLITE_DONE ){
//        NSAssert1( 0, @"Error updating table: %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt);
}

- (void)updateLoginAuthToken:(NSString *)neoauthToken
{   
    char *update = "UPDATE 'tbl_authtoken' SET authtoken=? ";
    sqlite3_stmt *stmt;
    if( sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK )
    {
        sqlite3_bind_text(stmt, 1, [[[GSCryptoHelper sharedInstance] encrypt256String:neoauthToken] UTF8String], -1, NULL);
        NSLog(@"update = %s",update);
    }
    if( sqlite3_step(stmt) != SQLITE_DONE ){
//        NSAssert1( 0, @"Error updating table: %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt);
}


#pragma mark -
#pragma mark 최근검색어
- (NSMutableArray *)getSearchWordList
{
    //NSLog(@"getMainIconList");
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM 'tbl_searchwordlist' order by pk desc"];
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK ) {
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            LatelySearchData *obj = [[LatelySearchData alloc]init];
            obj.searchWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,1)];
            obj.schType = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,2)];
            obj.schTime = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,3)];
            [array addObject:obj];
        }
        sqlite3_finalize(statement);
    }
    
    return array;
    
    
}


- (void)insertSearchWordList:(id)iconlist
{
    LatelySearchData *newData = (LatelySearchData *)iconlist;
    char *update = "INSERT INTO 'tbl_searchwordlist' (searchword, schtype, schtime) VALUES (?, ?, ?)";
    sqlite3_stmt *stmt;
    NSLog(@"insertIconVersion _ OK = %@",newData.searchWord);
    if( sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK )
    {
        sqlite3_bind_text(stmt,1, [newData.searchWord UTF8String], -1, NULL);
        sqlite3_bind_text(stmt,2, [newData.schType UTF8String], -1, NULL);
        sqlite3_bind_text(stmt,3, [newData.schTime UTF8String], -1, NULL);
    }
    else
    {
        NSLog(@"database insert error");
    }
    
    if( sqlite3_step(stmt) != SQLITE_DONE ){
//        NSAssert1( 0, @"Error insert data table: %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt);
}
- (void)deleteSearchWordList
{
    char *update = "DELETE FROM 'tbl_searchwordlist'";
    sqlite3_stmt *stmt;
    if( sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK )
    {
        NSLog(@"deleteSearchWordList DELETE OK");
    }
    else
    {
        NSLog(@"database insert error");
    }
    
    if( sqlite3_step(stmt) != SQLITE_DONE ){
//        NSAssert1( 0, @"Error insert data table: %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt);
}
- (void)deleteSearchWordListName:(NSString *)word
{
    char *update = "DELETE FROM 'tbl_searchwordlist' WHERE searchword = ?";
    sqlite3_stmt *stmt;
    if( sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK )
    {
        sqlite3_bind_text(stmt, 1, [word UTF8String], -1, NULL);
        NSLog(@"deleteMainIconList title = %@ DELETE OK",word);
    }
    else
    {
        NSLog(@"database insert error");
    }
    if( sqlite3_step(stmt) != SQLITE_DONE ){
//        NSAssert1( 0, @"Error insert data table: %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt);
}

#pragma mark -
#pragma mark App Version
- (NSString *)getAppVerInfo
{
    NSString *result = nil;
    NSString *query = @"SELECT * FROM 'tbl_appversion'";
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK ) {
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            result = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,1)];
        }
        sqlite3_finalize(statement);
    }
    if(result==nil)
        return @"";
    return result;
}
- (void)insertAppVerInfo:(NSString *)appversion
{
    char *update = "INSERT INTO 'tbl_appversion' (version) VALUES (?)";
    sqlite3_stmt *stmt;
    
    if( sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK )
    {
        sqlite3_bind_text(stmt,1, [appversion UTF8String], -1, NULL);
        NSLog(@"insertappVersion _ OK = %@",appversion);
    }
    else
    {
        NSLog(@"database insert error");
    }
    
    if( sqlite3_step(stmt) != SQLITE_DONE ){
//        NSAssert1( 0, @"Error insert data table: %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt);
}
- (void)deleteAppVerInfo
{
    char *update = "DELETE FROM 'tbl_appversion'";
    sqlite3_stmt *stmt;
    if( sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK )
    {
        NSLog(@"deleteAppVersion DELETE OK");
    }
    else
    {
        NSLog(@"database appversion row delete query error");
    }
    
    if( sqlite3_step(stmt) != SQLITE_DONE ){
//        NSAssert1( 0, @"Error insert data table: %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt);
}

#pragma mark -
#pragma mark pushdata
- (NSMutableArray *)getPushInfo
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *query = @"SELECT * FROM 'tbl_pushinfo'";
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK ) {
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            PushData *obj = [[PushData alloc]init];
            obj.deviceToken = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
            obj.custNo = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
            [result addObject:obj];
        }
        sqlite3_finalize(statement);
    }
    return result;
}
- (void)insertPushInfo:(id)pushinfo
{
    char *update = "INSERT INTO 'tbl_pushinfo' (deviceToken,custNo) VALUES (?,?)";
    sqlite3_stmt *stmt;
    
    PushData *newData = (PushData *)pushinfo;
    if( sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK )
    {
        sqlite3_bind_text(stmt,1, [newData.deviceToken UTF8String], -1, NULL);
        sqlite3_bind_text(stmt,2, [newData.custNo UTF8String], -1, NULL);//고객번호
        NSLog(@"insert // deviceToken = %@ custNo=%@",newData.deviceToken, newData.custNo);
    }
    else
    {
        NSLog(@"database insert error");
    }
    
    if( sqlite3_step(stmt) != SQLITE_DONE ){
//        NSAssert1( 0, @"Error insert data table: %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt);
}
- (void)deletePushInfo
{
    char *update = "DELETE FROM 'tbl_pushinfo'";
    sqlite3_stmt *stmt;
    if( sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK )
    {
        NSLog(@"deletepushInfo DELETE OK");
    }
    else
    {
        NSLog(@"database insert error");
    }
    
    if( sqlite3_step(stmt) != SQLITE_DONE ){
//        NSAssert1( 0, @"Error insert data table: %s", sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt);
}


//db file copy bundle -> documents
- (void)createEditableCopyOfDatabaseIfNeeded {
    NSLog(@"DB start");
    // First, test for existence - we don't want to wipe out a user's DB
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [DOCS_DIR stringByAppendingPathComponent:DBFileName];
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
    
    
    if (!dbexits)
    {
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath]
                                   stringByAppendingPathComponent:DBFileName];
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:defaultDBPath
                                            toPath:writableDBPath error:&error];
        if (!success) {
            
            
//            Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"database_init_errormsg") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
//            malert.tag = 555;
//            [self.window addSubview:malert];
        }
    }
    
    NSLog(@"DB end");
    
}

@end
