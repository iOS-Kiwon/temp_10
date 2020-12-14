//
//  NetCore_Mezi_Zip.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 11. 15..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "NetCore_Mezi_Zip.h"
#import "URLDefine.h"
#import <Mocha/JSON.h>

@implementation NetCore_Mezi_Zip

-(MochaNetworkOperation*) downloadFatAssFileFrom:(NSString*) remoteURL toFile:(NSString*) filePath {
    
    MochaNetworkOperation *op = [self operationWithURLString:remoteURL
                                                      params:nil
                                                  httpMethod:@"GET"
                                                 sloadertype:(MochaNetworkOperationLoadingType)MochaNetworkOperationLINormalExcute];
    
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                            append:YES]];
    
    [self procqueueOperation:op];
    return op;
}




//옵션정보체크
-(MochaNetworkOperation*) gsOptionInfo:(ResponseDicBlock) completionBlock
                               onError:(MCNKErrorBlock) errorBlock {
    
    MochaNetworkOperation *op = [self operationWithPath:GSOPTIONINFOURL
                                                 params:nil
                                             httpMethod:@"GET"
                                            sloadertype:(MochaNetworkOperationLoadingType)MochaNetworkOperationLINormalExcute];
    
    [self procqueueOperation:op];
    [op onCompletion:^(MochaNetworkOperation *completedOperation)
     {
         // the completionBlock will be called twice.
         // if you are interested only in new values, move that code within the else block
         
         //NSString *valueString = [[[completedOperation responseString] componentsSeparatedByString:@","] objectAtIndex:1];
         
         NSDictionary *valueString = [completedOperation responseJSON];
         NSLog(@"value %@", valueString);
         
         if([completedOperation isCachedResponse]) {
             //NSLog(@"Data from cache %@", [completedOperation responseJSON]);
         }
         else {
             //NSLog(@"Data from server %@", [completedOperation responseString]);
         }
         
         completionBlock(valueString );
         
     }onError:^(NSError* error) {
         
         errorBlock(error);
     }];
    
    
    
    return op;
}


@end


