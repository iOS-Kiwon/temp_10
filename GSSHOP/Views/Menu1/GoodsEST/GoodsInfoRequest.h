//
//  GoodsInfoRequest.h
//  GSSHOP
//
//  Created by uinnetworks on 11. 7. 25..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsInfo;
@class GSSHOPAppDelegate;

@protocol GoodsInfoRequestDelegate<NSObject>
-(void)doneRequest:(NSString *)status;
@end

@interface GoodsInfoRequest : NSObject {

    UIImage *upImage;
    id<GoodsInfoRequestDelegate> delegate;
}
@property (nonatomic,strong) UIImage *upImage;
@property (nonatomic,strong) id delegate;

- (NSMutableDictionary *)recvDataDic:(NSString *)url;

- (void) sendData:(GoodsInfo *)sendData img:(NSInteger)bImgSend;
- (void)sendDataDic:(NSMutableDictionary *)dic;
- (NSString*) getCustNo;
 
@end
