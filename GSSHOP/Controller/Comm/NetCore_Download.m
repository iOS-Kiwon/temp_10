//
//  NetCore_Download.m
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 18..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "NetCore_Download.h"

@implementation NetCore_Download

-(MochaNetworkOperation*) downloadFileFrom:(NSString*)remoteURL toFile:(NSString*)filePath
{
    
    MochaNetworkOperation *op = [self operationWithURLString:remoteURL
                                                      params:nil
                                                  httpMethod:@"GET"
                                                 sloadertype:(MochaNetworkOperationLoadingType)MochaNetworkOperationLINormalExcute];
    
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                            append:YES]];
    
    [self procqueueOperation:op];
    return op;
    
    
    NSLog(@"op = %@",op);
    
}

@end
