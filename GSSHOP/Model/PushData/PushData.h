//
//  PushData.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface PushData : NSCoder {
    NSString *deviceToken;

    NSString * custNo;//고객 번호.
}

@property (nonatomic,strong) NSString *deviceToken;

@property (nonatomic,strong) NSString *custNo;//고객 번호.
@end
