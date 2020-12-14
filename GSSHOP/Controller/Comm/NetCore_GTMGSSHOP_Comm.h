//
//  NetCore_GTMGSSHOP_Comm.h
//  GSSHOP
//
//  Created by gsshop on 2015. 6. 15..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NetCore_GTMGSSHOP_Comm  : MochaNetworkCore


//리턴 자료형 정의

typedef void (^ResponseDicBlock)(NSDictionary *respstr);
typedef void (^ResponseStrBlock)(NSString *respstr);



//GTM Tracking
-(MochaNetworkOperation*) GTMcallWithParamURL:(NSString*)apiurl
                               isForceReload:(BOOL)isreload
                                onCompletion:(ResponseStrBlock) completionBlock
                                     onError:(MCNKErrorBlock) errorBlock;

@end
