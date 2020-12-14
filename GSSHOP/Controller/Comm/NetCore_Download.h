//
//  NetCore_Download.h
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 18..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import <Mocha/Mocha.h>

typedef void (^ResponseDicBlock)(NSDictionary *respstr);
typedef void (^ResponseStrBlock)(NSString *respstr);

@interface NetCore_Download : MochaNetworkCore


-(MochaNetworkOperation*) downloadFileFrom:(NSString*)remoteURL toFile:(NSString*)filePath;
@end
