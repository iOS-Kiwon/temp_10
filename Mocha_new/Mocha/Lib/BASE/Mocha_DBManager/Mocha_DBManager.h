//
//  Mocha_DBManager.h
//  Mocha
//
//  Created by Hoecheon Kim on 12. 7. 10..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//
 
#import <sqlite3.h>


/**
* @brief sqlite DB,TABLE을 생성하고 편리하게 Insert,Select,Delete,Update 기본쿼리를 관리 싱글톤 객체  
 * sqlite DB,TABLE을 생성하고 편리하게 Insert,Select,Delete,Update 기본쿼리를 관리할 수 있음.
 * 생성된 DB를 Resource로 참조하여 앱 설치시 copybundle하여 사용하는 대신 DB를 직접 생성하거나
 * DB구조가 변경된 경우의 앱 업데이트시 DB버전관리 및 Alter (테이블변환) 기능을 활용할 수 있다.
 * DB파일경로 관리. 
 */
@interface Mocha_DBManager : NSObject {
 
	sqlite3 *database;
 	
}
@property sqlite3 *database;
 
/**
 * Mocha_DBManager 싱글턴 공유 인스턴스 생성 및 반환
 */
+ (Mocha_DBManager *) sharedInstance;
 
/**
 * Mocha_Define 헤더에 메크로 정의된 DB경로및 DB명활용하여 DB 파일이 존재하는지 체크 후 upgrade DB수행 미존재시 DB + Table생성 버전정보insert
 *
 */
- (void)initDB;
/**
 * database 닫기 및 싱글톤 객체인 m_dbInstance release 및 nil처리.
 *
 */
- (void)closeDB;
/**
 * 버전정보에 따라 table ALTER 구문 분기 처리진행 구현부.
 *
 */
- (void)upgradeDB;
/**
 * DB 초기화 테이블 생성 (업데이트가 아닐경우,최초설치시)
 *
 * @param filePath (현재사용되지않음) 추후 파일로부터 초기테이블생성쿼리문 생성시 사용용도.
 */
- (void)createDBTable:(NSString *)filePath;
/**
 * 초기설치시 DB테이블에 초기입력값 insert
 */
- (void)init_insertData;
/**
 *  sql수행후 결과 MutableArray 반환
 *
 * @param sql NSString 수행할 Query 구문 string.
 * @return NSMutableArray
 *
 * @see excuteQuery:sql withParameters:parameters
 */
- (NSMutableArray *)excuteQuery: (NSString *) sql;
- (NSMutableArray *)excuteQuery: (NSString *) sql withParameters: (NSArray *) parameters;
/**
 *  sql수행후 수행결과 성공여부 반환 
 *
 * Update, Delete, Insert SQL문에만 사용할 수 있으며, statement가 없는 경우 사용
 * @param sql NSString 수행할 Query 구문 string.
 * @return BOOL
 *
 * @see executeUpdate:sql withParameters:parameters
 */
 
- (BOOL) executeUpdate: (NSString *) sql;
- (BOOL) executeUpdate: (NSString *) sql withParameters: (NSArray *) parameters;
 
/**
 *  Custom DB Access
 */
 
- (void) updateData:(NSString *)value key:(NSString*)key;
@end
