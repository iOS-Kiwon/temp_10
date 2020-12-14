//
//  GSException.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 9. 20..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "GSException.h"

@implementation GSException
@synthesize description, callStackSymbols, userInfo , name;

- (id) initWithException : (NSException *) ex addString:(NSString *)strToAdd;
{
    self = [super init];
    
    self.callStackSymbols = [NSMutableArray arrayWithArray:(NCA(ex.callStackSymbols)?ex.callStackSymbols:[[NSArray alloc] init])];
    
    if ([NCS(strToAdd) length] > 0) {
        self.description = [NSString stringWithFormat:@"%@_%@",strToAdd,ex.description];
    }else{
        self.description = ex.description;
    }
    
    self.userInfo = [NSMutableDictionary dictionaryWithDictionary:(NCO(ex.userInfo)?ex.userInfo:[[NSDictionary alloc] init])];
    
    self.name = NCS(ex.name);

    return self;
}



@end
