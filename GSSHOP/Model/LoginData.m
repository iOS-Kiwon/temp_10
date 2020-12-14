//
//  LoginData.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "LoginData.h"


@implementation LoginData


@synthesize loginid;
@synthesize serieskey;
@synthesize authtoken;

@synthesize autologin;
@synthesize simplelogin;
@synthesize saveid;
@synthesize snsTyp;

- (id)initWithLogin:(LoginData *)login
{
    if((self = [super init]))
    {
        self.loginid = login.loginid;
        self.serieskey = login.serieskey;
        self.authtoken = login.authtoken;
        
        self.autologin = login.autologin;
        
        self.simplelogin = login.simplelogin;
        self.saveid = login.saveid;
        self.snsTyp = login.snsTyp;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.loginid            = [decoder decodeObjectForKey:@"obj_loginid"];
        self.serieskey          = [decoder decodeObjectForKey:@"obj_serieskey"];
        self.authtoken          = [decoder decodeObjectForKey:@"obj_authtoken"];
        self.snsTyp             = [decoder decodeObjectForKey:@"obj_snsType"];
        self.simplelogin        = [[decoder decodeObjectForKey:@"obj_simplelogin"] integerValue];
        self.autologin          = [[decoder decodeObjectForKey:@"obj_autologin"] integerValue];
        self.saveid             = [[decoder decodeObjectForKey:@"obj_saveid"] integerValue];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.loginid forKey:@"obj_loginid"];
    [encoder encodeObject:self.serieskey forKey:@"obj_serieskey"];
    [encoder encodeObject:self.authtoken forKey:@"obj_authtoken"];
    [encoder encodeObject:self.snsTyp forKey:@"obj_snsType"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.simplelogin] forKey:@"obj_simplelogin"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.autologin] forKey:@"obj_autologin"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.saveid] forKey:@"obj_saveid"];

}

@end
