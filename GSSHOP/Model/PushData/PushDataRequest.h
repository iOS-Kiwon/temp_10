//
//  PushDataRequest.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol SendPushCustDelegate<NSObject>
-(void)doneRequest:(NSString *)status;
@end

@interface PushDataRequest : NSObject {
    
    id<SendPushCustDelegate> delegate;
}

@property (nonatomic,strong) id delegate;
- (void) sendData:(NSString *)deviceToken customNo:(NSString *)custNo;
- (void) cleanup: (NSString *) output;
@end
