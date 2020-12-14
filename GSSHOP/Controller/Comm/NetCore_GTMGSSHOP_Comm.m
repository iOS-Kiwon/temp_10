//
//  NetCore_GTMGSSHOP_Comm.m
//  GSSHOP
//
//  Created by gsshop on 2015. 6. 15..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "NetCore_GTMGSSHOP_Comm.h"
//#import <Mocha/JSON.h>

@implementation NetCore_GTMGSSHOP_Comm



-(MochaNetworkOperation*) GTMcallWithParamURL:(NSString*)apiurl
                               isForceReload:(BOOL)isreload
                                onCompletion:(ResponseStrBlock) completionBlock
                                     onError:(MCNKErrorBlock) errorBlock{
    
  
    
    MochaNetworkOperation *op = [self operationWithPath:apiurl
                                                 params:nil
                                             httpMethod:@"GET"
                                            sloadertype:(MochaNetworkOperationLoadingType)MochaNetworkOperationLINormalExcute];
    
    [self procqueueOperation:op forceReload:isreload hideFailedAlert:YES];
    [op onCompletion:^(MochaNetworkOperation *completedOperation)
     {
         // the completionBlock will be called twice.
         // if you are interested only in new values, move that code within the else block
         
         NSString *valueString = [completedOperation responseString];
        NSLog(@"COMM URL %@ %@", apiurl, valueString);
         
         
         completionBlock(  valueString   );
         
     }onError:^(NSError* error) {
         
         NSLog(@"NET_ERROR - GTMCall error !!!!!!!!  %@", [error localizedDescription]);
         
         errorBlock(error);
     }];
    
    
    
    return op;
}

@end
