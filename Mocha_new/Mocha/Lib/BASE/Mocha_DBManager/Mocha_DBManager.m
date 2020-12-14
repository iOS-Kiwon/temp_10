//
//  Mocha_DBManager.m
//  Mocha
//
//  Created by Hoecheon Kim on 12. 7. 10..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "Mocha_DBManager.h"
#import "Mocha_Define.h"
@implementation Mocha_DBManager
@synthesize database;

static Mocha_DBManager* m_dbInstance;

+ (Mocha_DBManager *) sharedInstance
{
	
    if (m_dbInstance == nil)
	{
		@synchronized(self) {
			if (!m_dbInstance)
			{
               m_dbInstance= [[self alloc] init];
                
				[m_dbInstance initDB];
                NSLog(@"Databse ..initDB");
			}
		}
	}
	
	return m_dbInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if (m_dbInstance == nil)
		{
            m_dbInstance = [super allocWithZone:zone];
            return m_dbInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (void)closeDB {
	sqlite3_close(database);
	if(m_dbInstance != nil) {
        m_dbInstance = nil;
	}
    
}


// 버젼 정보에 따라 table ALTER Delete Create구문 분기 처리 진행
- (void) upgradeDB {
    
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    //NSInteger dbVersion = [prefs integerForKey:@"DBVersion"];
    //NSLog(@"upgradeDB..dbVersion: %d", dbVersion);
    
    
    
    //완료 후 DB 버전정보갱신
    [prefs setInteger:DB_VERSION forKey:@"DBVersion"];
    [prefs synchronize];
    NSLog(@"For for the first time, UPGRADED! DBVersion: %ld", (long)[prefs integerForKey:@"DBVersion"]);
    
}


//초기화 테이블생성 (업데이트가 아닐경우. 최초설치시)
- (void)createDBTable:(NSString *)filePath {
    char *errorMsg;
    
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
    
    
    //최근 검색어 리스트 
    NSString *createSearchWordSQL = @"CREATE TABLE IF NOT EXISTS 'tbl_searchwordlist' ("
    @"pk INTEGER PRIMARY KEY, "
    @"schtype VARCHAR, "
    @"searchword VARCHAR)";
    
    if(sqlite3_exec(database, [createSearchWordSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
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

    //이하 커스텀 
    char *sql = "CREATE TABLE MOCHA_CONTENTS \
    (idx INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \
    DeviceToken TEXT, OPTION1 TEXT, OPTION2 TEXT, OPTION3 TEXT); ";
	
	if (sqlite3_exec(database, sql, nil,nil,nil) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Error");
		return;
	}
	else {
        //초기데이터 필요시 입력
		[self init_insertData];
	}	
 
}

//초기화 데이터 insert
- (void) init_insertData {
    char *sql = "INSERT INTO MOCHA_CONTENTS ( DeviceToken, OPTION1, OPTION2, OPTION3 ) VALUES ( '12345678901234567890','field1','field2','field3' );";
    
    int nResult = sqlite3_exec(database, sql, nil,nil,nil);
	NSLog(@"NSResult  --- > : %d", nResult );
	if (nResult != SQLITE_OK) {
		sqlite3_close(database);
		//NSLog(@"Error");
		return;
	}
    
}



- (void)initDB {
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
	 
	NSString *filePath = [DOCS_DIR stringByAppendingPathComponent:kDataBaseName];
	
	
	if ([fileManager fileExistsAtPath:filePath]) {
		NSLog(@"fileExistsAtPath");
		if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
			sqlite3_close(database);
			NSLog(@"Error");
		}
        
        
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        NSInteger dbVersion = [prefs integerForKey:@"DBVersion"];

        if((dbVersion == 0) || (dbVersion != DB_VERSION)) {
        // (Upgradable DB 처리) 디비 파일이 존재하면, 버전 정보에 따른 업그레이드 진행
        Mocha_DBManager* dbManager = [Mocha_DBManager sharedInstance];
        [dbManager upgradeDB];
        }
        //[self upgradeDB];
        
		return;
	}
	
	else {
		NSLog(@"NOT fileExistsAtPath");
        if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
			sqlite3_close(database);
			NSLog(@"Error");
		}
        
        // (Upgradable DB 처리) 디비 파일이 없어, 새로이 디비 초기화, 디비 버전 정보를 최신으로 셋팅
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:DB_VERSION forKey:@"DBVersion"];
        [prefs synchronize];
        NSLog(@"For for the first time, installed! DBVersion: %ld", (long)[prefs integerForKey:@"DBVersion"]);
        
		[self createDBTable:filePath];
        
	}
    
    
}

- (void)bindArguments: (NSArray *) arguments toStatement: (sqlite3_stmt *) statement {
	int expectedArguments = sqlite3_bind_parameter_count(statement);
	NSLog(@"bindArguments: %d", expectedArguments);
    NSLog(@"arguments: %@", arguments);
	NSLog(@"arguments cnt: %lu", (unsigned long)[arguments count]);
    
	int nArgumentsCnt = (unsigned int)[arguments count];
	for (int i = 1; (i <= expectedArguments) && (i <= nArgumentsCnt); i++) {
		id argument = [arguments objectAtIndex:i - 1];
		if([argument isKindOfClass:[NSString class]])
			sqlite3_bind_text(statement, i, [argument UTF8String], -1, SQLITE_TRANSIENT);
		else if([argument isKindOfClass:[NSData class]])
			sqlite3_bind_blob(statement, i, [argument bytes], (unsigned int)[argument length], SQLITE_TRANSIENT);
		else if([argument isKindOfClass:[NSNumber class]])
			sqlite3_bind_double(statement, i, [argument doubleValue]);
		else if([argument isKindOfClass:[NSNull class]])
			sqlite3_bind_null(statement, i);
		else
			sqlite3_finalize(statement);
		
	}
}

- (int)columnTypeToInt: (NSString *) columnType {
	if ([columnType isEqualToString:@"INTEGER"]) {
		return SQLITE_INTEGER;
	}
	else if ([columnType isEqualToString:@"REAL"]) {
		return SQLITE_FLOAT;
	}
	else if ([columnType isEqualToString:@"TEXT"]) {
		return SQLITE_TEXT;
	}
	else if ([columnType isEqualToString:@"BLOB"]) {
		return SQLITE_BLOB;
	}
	else if ([columnType isEqualToString:@"NULL"]) {
		return SQLITE_NULL;
	}
	
	return SQLITE_TEXT;
}

- (int)typeForStatement: (sqlite3_stmt *) statement column: (int) column {
	const char * columnType = sqlite3_column_decltype(statement, column);
	
	if (columnType != NULL) {
		return [self columnTypeToInt: [[NSString stringWithUTF8String: columnType] uppercaseString]];
	}
	return sqlite3_column_type(statement, column);
}


- (NSArray *)columnTypesForStatement: (sqlite3_stmt *) statement {
	int columnCount = sqlite3_column_count(statement);
	
	NSMutableArray *columnTypes = [NSMutableArray array];
	for(int idx = 0; idx < columnCount; idx++) {
		[columnTypes addObject:[NSNumber numberWithInt:[self typeForStatement:statement column:idx]]];
	}
	//NSLog(@"columnTypes=%@",[columnTypes description]);
	return columnTypes;
}
- (NSArray *)columnNamesForStatement: (sqlite3_stmt *) statement {
	int columnCount = sqlite3_column_count(statement);
	
	NSMutableArray *columnNames = [NSMutableArray array];
	for (int idx = 0; idx < columnCount; idx++) {
		[columnNames addObject:[NSString stringWithUTF8String:sqlite3_column_name(statement, idx)]];
	}
    
	return columnNames;
}

- (id)valueFromStatement: (sqlite3_stmt *) statement column: (int) column columnTypes: (NSArray *) columnTypes {	
	int columnType = [[columnTypes objectAtIndex:column] intValue];
	
	if (columnType == SQLITE_INTEGER) {
		return [NSNumber numberWithInt:sqlite3_column_int(statement, column)];
	}
	else if (columnType == SQLITE_FLOAT) {
		return [NSNumber numberWithDouble: sqlite3_column_double(statement, column)];
	}
	else if (columnType == SQLITE_TEXT) {
		const char *text = (const char *) sqlite3_column_text(statement, column);
		if (text != nil) {
			return [NSString stringWithUTF8String: text];
		}
		else {
			return nil;
		}
	}
	else if (columnType == SQLITE_BLOB) {
		return [NSData dataWithBytes:sqlite3_column_blob(statement, column) length:sqlite3_column_bytes(statement, column)];
	}
	else if (columnType == SQLITE_NULL) {
		return nil;
	}
	return nil;
}


- (void)copyValuesFromStatement: (sqlite3_stmt *) statement toRow: (id) row columnTypes: (NSArray *) columnTypes columnNames: (NSArray *) columnNames {
	int columnCount = sqlite3_column_count(statement);
	
	for (int idx = 0; idx < columnCount; idx++) {
		id value = [self valueFromStatement:statement column:idx columnTypes: columnTypes];
		
        if(value != nil) {
			[row setValue: value forKey: [columnNames objectAtIndex:idx]];
        }
	}
}



- (NSMutableArray *)excuteQuery: (NSString *) sql {
	return [self excuteQuery:sql withParameters:nil];
}

- (NSMutableArray *)excuteQuery: (NSString *) sql withParameters: (NSArray *) parameters {	
    
	NSMutableArray *resultArray = [NSMutableArray array]; 
	sqlite3_stmt *statement; 
    //    NSLog(@"%@",sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL));
	if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
		NSLog(@"sqlite ok");
		if (parameters != nil) {
			[self bindArguments: parameters toStatement: statement];
		}
        
		BOOL needsToFetchColumnTypesAndNames = YES;
		NSArray *columnTypes = nil;
		NSArray *columnNames = nil;
		while (sqlite3_step(statement)== SQLITE_ROW) {
            
			if (needsToFetchColumnTypesAndNames) {
				columnTypes = [self columnTypesForStatement: statement];
				columnNames = [self columnNamesForStatement: statement];
				needsToFetchColumnTypesAndNames = NO;
			}
			
			NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
			[self copyValuesFromStatement: statement toRow: row columnTypes: columnTypes columnNames: columnNames];
			[resultArray addObject:row];
		}
		
	}
	sqlite3_finalize(statement);
	
	return resultArray;
	
}

- (BOOL)executeUpdate: (NSString *) sql {
	
	return [self executeUpdate:sql withParameters:nil] ;
	
}


- (BOOL) executeUpdate: (NSString *) sql withParameters: (NSArray *) parameters {
    
	sqlite3_stmt *statement;
    
    NSLog(@"sql = %@", sql);
    
    NSLog(@"parameters = %@", parameters);
	
    int error_num = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
    
    
	//if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
    if (error_num == SQLITE_OK) {
		if (parameters != nil) {
			
			for (int inx=0 ; inx < [parameters count]; inx++) {
				[self bindArguments: [parameters objectAtIndex:inx] toStatement: statement];
				int temp = sqlite3_step(statement);
				if (temp != SQLITE_DONE) {
					NSLog(@" !SQLITE_DONE Error = %d", inx);
					return NO;
				}
				sqlite3_reset(statement);
			}
		} else {
			if (sqlite3_step(statement) != SQLITE_DONE) {
				return NO;
			}
		}
	}
	else {	//Error Code 추가.
		//NSLog(@"Error %@", error_num);
		sqlite3_finalize(statement);
		return NO;
	}
	
	sqlite3_finalize(statement);
    
	return YES;
	
}

- (BOOL) executeOnceQuery:(NSString *) sql {
	char *szErrMsg = nil; // thomas , 2012/01/14 , add for debug
    int result = sqlite3_exec(database, [sql UTF8String], nil,nil,&szErrMsg);
	if (result != SQLITE_OK) {
		NSLog(@"%s Error %d , %s", __func__, result, szErrMsg);
        if (szErrMsg)
            sqlite3_free(szErrMsg); // thomas , 2012/01/14 , add for debug
        
		sqlite3_close(database);
		return NO;
	}
	return YES;
}



//Custom DB
- (void) updateData:(NSString *)value key:(NSString*)key{
     
    
     
		//begin transaction
		sqlite3_exec(database, "BEGIN;", NULL, NULL, NULL);
		// update
        NSString* sql = [NSString stringWithFormat:@"UPDATE MOCHA_CONTENTS SET %@='%@' ", key, value];
    NSLog(@"sql = %@",sql);
		sqlite3_stmt *stmt;
		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
			if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL) != SQLITE_OK){
			} 
		}
		sqlite3_finalize(stmt);
		sqlite3_exec(database, "COMMIT;", NULL, NULL, NULL);
	 
    [self closeDB];
	//sqlite3_close(database);     
        
}

@end
