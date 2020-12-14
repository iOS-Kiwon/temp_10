//
//  AttachInfoRequest.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 12. 22..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AttachInfo.h"
@class GSSHOPAppDelegate;

@protocol AttachInfoRequestDelegate<NSObject>
-(void)doneRequest:(NSString *)status;
- (void)doneimgRequest:(NSString *)status;
@end

@interface AttachInfoRequest : NSObject {
    
    BOOL isThereImg;
    id<AttachInfoRequestDelegate> delegate;
}
@property (nonatomic, strong) AttachInfo *tAttachInfo;
@property (nonatomic,strong) UIImage *upImage;
@property (nonatomic,strong) id delegate;
 

- (void) sendData:(AttachInfo *)sendData;
- (void) imgsendData:(NSMutableDictionary*)sresult;
- (BOOL) deleteMessageData:(NSMutableDictionary*)sresult;

- (void) imgsendData_n:(NSDictionary*)sresult;
@end
