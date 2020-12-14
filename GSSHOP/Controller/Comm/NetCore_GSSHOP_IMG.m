//
//  NetCore_GSSHOP_IMG.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "NetCore_GSSHOP_IMG.h"
#import "Common_Util.h"

@implementation NetCore_GSSHOP_IMG

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = NCA(paths)?[paths objectAtIndex:0]:@"";

    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"GSSHOPImages"];
    return cacheDirectoryName;
}

@end
