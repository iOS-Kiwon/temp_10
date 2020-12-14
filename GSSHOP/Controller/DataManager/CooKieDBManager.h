//
//  CooKieDBManager.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 9. 18..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CooKieDBManager : NSObject

+(NSMutableArray*) getRecentKeywordCK;
+(BOOL) deleteOneKeyRecentKeywordCK:(NSString*)tgval;
+(BOOL) deleteAllRecentKeywordCK;

+(NSString*) getCartCountstr;
+(NSString*) getMartDeliFlag;
+(void) deleteLogoutCookies;
+(void)printSharedCookies;
@end
