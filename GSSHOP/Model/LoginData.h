//
//  LoginData.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 @"loginId VARCHAR,"
 @"userName VARCHAR,"
 @"customerNumber VARCHAR,"
 @"seriesKey VARCHAR,"
 @"authToken VARCHAR,"
 @"autologin INTEGER,"
 @"saveid INTEGER)";
 */

@interface LoginData : NSCoder {
    NSString * loginid;
    //NSString * username;
    //NSString * customernumber;
    NSString * serieskey;
    NSString * authtoken;
    NSString * snsTyp;
    NSInteger autologin;
    NSInteger simplelogin;
    NSInteger saveid;
}
@property (nonatomic,copy) NSString * loginid;
//@property (nonatomic,copy) NSString * username;
//@property (nonatomic,copy) NSString * customernumber;
@property (nonatomic,copy) NSString * serieskey;

@property (nonatomic,copy) NSString * authtoken;

@property (nonatomic,copy) NSString * snsTyp;

@property (nonatomic) NSInteger autologin;
@property (nonatomic) NSInteger simplelogin;
@property (nonatomic) NSInteger saveid;
- (id)initWithLogin:(LoginData *)login;
@end
