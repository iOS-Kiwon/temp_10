//
//  MemberDB.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "sqlite3.h"


#define DBFileName @"GSShop2000.sqlite"
@class AppDelegate;
@interface MemberDB : NSObject {
    
}

- (void)createEditableCopyOfDatabaseIfNeeded;   // nami0342 - 번들에서 로컬로 DB 파일 복사하는 것 appdelegate에서 여기로 이동
-(void)CreateDatabase;
-(void)allTableDrop;
-(BOOL)tableExistCheck:(NSString *)checkquery;
-(void)DropTable:(NSString *)str;
//login data
- (NSMutableArray *)getLoginInfo;           // nami0342 - 구 버전 마이그레이션 때문에 남겨놓음
//
//- (void) clearAutoLogin;
//- (BOOL)insertLoginInfo:(id)loginInfo;  // Modify void => BOOL
//- (void)updateLoginAuthToken:(NSString *)neoauthToken;
- (void)deleteLoginInfo;                    // nami0342 - 구 버전 마이그레이션 때문에 남겨놓음
//
////searchword list
//- (NSMutableArray *)getSearchWordList;
//- (void)insertSearchWordList:(id)iconlist;
//- (void)deleteSearchWordList;
//- (void)deleteSearchWordListName:(NSString *)name;
//
////AppVersion
//- (NSString *)getAppVerInfo;//select
//- (void)insertAppVerInfo:(NSString *)iconList;
//- (void)deleteAppVerInfo;
//
//
////pushData
////AppVersion
- (NSMutableArray *)getPushInfo;            // nami0342 - 구 버전 마이그레이션 때문에 남겨놓음
//- (void)insertPushInfo:(id)pushinfo;
- (void)deletePushInfo;                     // nami0342 - 구 버전 마이그레이션 때문에 남겨놓음

@end
