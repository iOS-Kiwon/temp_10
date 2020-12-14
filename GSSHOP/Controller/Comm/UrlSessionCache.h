//
//  UrlSessionCache.h
//  GSSHOP
//
//  Created by nami0342 on 08/01/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlSessionCache : NSCache
+ (UrlSessionCache *_Nullable)sharedInstance;            // nami0342 - Singleton 함수

+ (void) setData: (NSData *_Nullable) dValue  forKey : (NSString *_Nullable) strKey isFile:(BOOL) isFile;
+ (void) setData: (NSData *_Nullable) dValue  forKey : (NSString *_Nullable)strKey;              // Store image data to memory.
+ (nullable NSData *) getDataWithKey : (NSString *_Nullable) strKey;                     // Get image data from memory.
+ (nullable NSData *) getDataWithKey : (NSString *_Nonnull) strKey isFile:(BOOL) isFile;     // Get image data from memory.
- (void) deleteAllMemory;
@end
