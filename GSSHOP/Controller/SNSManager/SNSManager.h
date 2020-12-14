//
//  SNSManager.h
//  GSSHOP
//
//  Created by gsshop on 2016. 1. 19..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLDefine.h"
#import "Appdelegate.h"
#import <MessageUI/MessageUI.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MOCHA/Mocha_Alert.h>

@interface SNSManager : NSObject <Mocha_AlertDelegate>


@property (nonatomic, strong) NSString *linkurl;
@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSString *textstring;
@property (nonatomic) CGSize imageSize;

@property (nonatomic, strong) id target;
+ (id)snsPostingWithUrl:(NSString*)url text:(NSString*)ttext imageUrl:(NSString*)timgurl imageSize:(CGSize)size;
- (void)NSNSPosting:(TYPEOFSNS)snstype;
- (void) customAlertView:(UIView*)alert clickedButtonAtIndex:(NSInteger)index;
@end
