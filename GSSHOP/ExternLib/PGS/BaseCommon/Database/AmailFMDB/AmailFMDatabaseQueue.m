//
//  AmailFMDatabasePool.m
//  AmailFMdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "AmailFMDatabaseQueue.h"
#import "AmailFMDatabase.h"

/*
 
 Note: we call [self retain]; before using dispatch_sync, just incase 
 AmailFMDatabaseQueue is released on another thread and we're in the middle of doing
 something in dispatch_sync
 
 */
 
@implementation AmailFMDatabaseQueue

@synthesize path = _path;

+ (id)databaseQueueWithPath:(NSString*)aPath {
    
    AmailFMDatabaseQueue *q = [[self alloc] initWithPath:aPath];
    
    AmailFMDBAutorelease(q);
    
    return q;
}

- (id)initWithPath:(NSString*)aPath {
    
    self = [super init];
    
    if (self != nil) {
        
        _db = [AmailFMDatabase databaseWithPath:aPath];
        AmailFMDBRetain(_db);
        
        if (![_db open]) {
            NSLog(@"Could not create database queue for path %@", aPath);
            AmailFMDBRelease(self);
            return 0x00;
        }
        
        _path = AmailFMDBReturnRetained(aPath);
        
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"AmailFMdb.%@", self] UTF8String], NULL);
    }
    
    return self;
}

- (void)dealloc {
    
    AmailFMDBRelease(_db);
    AmailFMDBRelease(_path);
    
    if (_queue) {
        AmailFMDBDispatchQueueRelease(_queue);
        _queue = 0x00;
    }
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)close {
    AmailFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        [_db close];
        AmailFMDBRelease(_db);
        _db = 0x00;
    });
    AmailFMDBRelease(self);
}

- (AmailFMDatabase*)database {
    if (!_db) {
        _db = AmailFMDBReturnRetained([AmailFMDatabase databaseWithPath:_path]);
        
        if (![_db open]) {
            NSLog(@"AmailFMDatabaseQueue could not reopen database for path %@", _path);
            AmailFMDBRelease(_db);
            _db  = 0x00;
            return 0x00;
        }
    }
    
    return _db;
}

- (void)inDatabase:(void (^)(AmailFMDatabase *db))block {
    AmailFMDBRetain(self);
    
    dispatch_sync(_queue, ^() {
        
        AmailFMDatabase *db = [self database];
        block(db);
        
        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [AmailFMDatabaseQueue inDatabase:]");
        }
    });
    
    AmailFMDBRelease(self);
}


- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(AmailFMDatabase *db, BOOL *rollback))block {
    AmailFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        BOOL shouldRollback = NO;
        
        if (useDeferred) {
            [[self database] beginDeferredTransaction];
        }
        else {
            [[self database] beginTransaction];
        }
        
        block([self database], &shouldRollback);
        
        if (shouldRollback) {
            [[self database] rollback];
        }
        else {
            [[self database] commit];
        }
    });
    
    AmailFMDBRelease(self);
}

- (void)inDeferredTransaction:(void (^)(AmailFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block];
}

- (void)inTransaction:(void (^)(AmailFMDatabase *db, BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block];
}

#if SQLITE_VERSION_NUMBER >= 3007000
- (NSError*)inSavePoint:(void (^)(AmailFMDatabase *db, BOOL *rollback))block {
    
    static unsigned long savePointIdx = 0;
    __block NSError *err = 0x00;
    AmailFMDBRetain(self);
    dispatch_sync(_queue, ^() { 
        
        NSString *name = [NSString stringWithFormat:@"savePoint%ld", savePointIdx++];
        
        BOOL shouldRollback = NO;
        
        if ([[self database] startSavePointWithName:name error:&err]) {
            
            block([self database], &shouldRollback);
            
            if (shouldRollback) {
                [[self database] rollbackToSavePointWithName:name error:&err];
            }
            else {
                [[self database] releaseSavePointWithName:name error:&err];
            }
            
        }
    });
    AmailFMDBRelease(self);
    return err;
}
#endif

@end
