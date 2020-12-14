//
//  PushData.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//


#import "PushData.h"

@implementation PushData

@synthesize deviceToken;

@synthesize custNo;





- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.deviceToken     = [decoder decodeObjectForKey:@"obj_deviceToken"];
        self.custNo          = [decoder decodeObjectForKey:@"obj_custNo"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.deviceToken forKey:@"obj_deviceToken"];
    [encoder encodeObject:self.custNo forKey:@"obj_custNo"];
}


@end
