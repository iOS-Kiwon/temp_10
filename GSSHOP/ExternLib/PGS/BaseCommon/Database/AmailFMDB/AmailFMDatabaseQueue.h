//
//  AmailFMDatabasePool.h
//  AmailFMdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class AmailFMDatabase;

@interface AmailFMDatabaseQueue : NSObject {
    NSString            *_path;
    dispatch_queue_t    _queue;
    AmailFMDatabase          *_db;
}

@property (atomic, retain) NSString *path;

+ (id)databaseQueueWithPath:(NSString*)aPath;
- (id)initWithPath:(NSString*)aPath;
- (void)close;

- (void)inDatabase:(void (^)(AmailFMDatabase *db))block;

- (void)inTransaction:(void (^)(AmailFMDatabase *db, BOOL *rollback))block;
- (void)inDeferredTransaction:(void (^)(AmailFMDatabase *db, BOOL *rollback))block;

#if SQLITE_VERSION_NUMBER >= 3007000
// NOTE: you can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock.
// If you need to nest, use AmailFMDatabase's startSavePointWithName:error: instead.
- (NSError*)inSavePoint:(void (^)(AmailFMDatabase *db, BOOL *rollback))block;
#endif

@end

