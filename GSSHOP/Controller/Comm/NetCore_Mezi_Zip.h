//
//  NetCore_Mezi_Zip.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 11. 15..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCore_GSSHOP_Comm.h"
@interface NetCore_Mezi_Zip : MochaNetworkCore

 
//리턴 자료형 정의

-(MochaNetworkOperation*) downloadFatAssFileFrom:(NSString*) remoteURL toFile:(NSString*) fileName;
-(MochaNetworkOperation*) gsOptionInfo:(ResponseDicBlock) completionBlock
                               onError:(MCNKErrorBlock) errorBlock;
@end
