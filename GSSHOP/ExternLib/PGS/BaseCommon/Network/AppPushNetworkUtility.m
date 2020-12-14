#import "AppPushNetworkUtility.h"
#import "AppPushCustomURLConnection.h"
#import "AppPushSecureDataUtil.h"
#import "AmailJSON.h"
#import "AppPushConstants.h"
@implementation AppPushNetworkUtility

@synthesize receivedData;

- (id)init {
    self = [super init];
    @try {
        if(self) {
            arrQueue = [[NSMutableArray alloc] init];
            receivedData = [[NSMutableDictionary alloc] init];
            df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyyMMddHHmmss"];
            jsonParser = [AmailSBJSON new];
            
            //Soulution
            NSString *strUrl = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"PMSApiUrl"];
            apiUrl = [[NSString alloc] initWithString:strUrl!=nil?strUrl:@""];
            
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility init : %@", exception);
    } return self;
}
- (NSString *)getLastSuccessTime {
    @try {
        return successTime;
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility getLastSuccessTime : %@", exception);
        return nil;
    }
}
#pragma mark - JSON Method
- (NSString *)objectToJSON:(id)argData {
    @try {
        if(jsonParser==nil) jsonParser = [AmailSBJSON new];
        NSString *strResult = [jsonParser stringWithObject:argData];
        return strResult!=nil ? strResult : @"";
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility objectToJSON : %@", exception);
        return @"";
    }
}

#pragma mark - queue
- (void)checkQueue {
    @try {
        if(isReCert) return;
        @synchronized(arrQueue) {
            if([arrQueue count] > 0) {
                NSDictionary *dic = [arrQueue objectAtIndex:0];
                [self requestAsyncLoad:[dic valueForKey:@"url"]
                                params:[dic valueForKey:@"params"]
                                  type:[[dic valueForKey:@"type"] intValue]
                                   tag:[dic valueForKey:@"tag"]
                                cipher:[dic valueForKey:@"cipher"]
                                object:[dic valueForKey:@"object"]];
            }
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility checkQueue : %@", exception);
    }
}
- (void)minusQueue {
    @try {
        @synchronized(arrQueue) {
            if([arrQueue count] > 0) {
                [arrQueue removeObjectAtIndex:0];
            }
        }
        [self checkQueue];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility minusQueue : %@", exception);
    }
}
- (void)minusQueue:(NSString *)argTag {
    @try {
        @synchronized(arrQueue) {
            if([arrQueue count] > 0) {
                BOOL isExist = NO;
                int i;
                int arrCount = (int)[arrQueue count];
                for(i = 0 ; i < arrCount ; i++) {
                    NSDictionary *dicTemp = [arrQueue objectAtIndex:i];
                    if([NCS([dicTemp valueForKey:@"tag"]) isEqualToString:argTag]) {
                        isExist = YES;break;
                    }
                }
                if(isExist) [arrQueue removeObjectAtIndex:i];
            }
        }
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility minusQueue arg: %@", exception);
    }
}
- (void)addNetworkQueue:(NSURL*)url
                 params:(NSString *)params
                   type:(int)type
                    tag:(NSString*)tag
                 cipher:(NSString *)argCipher
                 object:(id)argObject {
    @try {
        @synchronized(arrQueue) {
            if(isReCert || [tag isEqualToString:APPPUSH_NOTI_DEVICE]) {
                isCertNetwork = YES;
                [self requestAsyncLoad:url params:params type:type tag:tag cipher:argCipher object:argObject];
            } else {
                [arrQueue addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      url!=nil?url:@"",@"url",
                                      params!=nil?params:@"",@"params",
                                      [NSNumber numberWithInt:type],@"type",
                                      tag!=nil?tag:@"",@"tag",
                                      argCipher!=nil?argCipher:@"",@"cipher",
                                      argObject,@"object",
                                      nil] ];
                
                // nami0342 - Add 큐 후에 전송처리하는 위치로 옮김
                [self checkQueue];
            }
        }
        
        //NSLog(@"arrQueue %@",arrQueue);
        
        //2018.01.03 yunsang.jin 항상체크하도록 수정 
        //if([arrQueue count] < 2 && !isCertNetwork) {
//            [self checkQueue];
        //}
        
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility startAsyncLoad default : %@", exception);
    }
}

#pragma mark - Async

- (void)requestAsyncLoad:(NSURL*)url
                  params:(NSString *)params
                    type:(int)type
                     tag:(NSString*)tag
                  cipher:(NSString *)argCipher
                  object:(id)argObject {
    @try {
        //NSLog(@"url : %@", url);
        //NSLog(@"params : %@", params);
        //NSLog(@"type : %d", type);
        //NSLog(@"tag : %@", tag);
        //NSLog(@"argCipher : %@", argCipher);
        
        //NSString *originParams = params;
        if(params!=nil && params.length>0) {
            if([argCipher isEqualToString:APPPUSH_NETWORK_CIPHER]) {
                params = [AppPushSecureDataUtil enCipherStr:params
                                                        key:[[NSUserDefaults standardUserDefaults] valueForKey:APPPUSH_DEF_NETWORK_KEY]
                                              withUrlEncode:NO];
                //NSLog(@"params : %@",params);
                NSString *baseParam = [NSString stringWithFormat:APPPUSH_NOTI_DEFAULT_ARGS,
                                       [[NSUserDefaults standardUserDefaults] valueForKey:APPPUSH_DEF_APP_USER_ID],
                                       params];
//                NSLog(@"baseParam : %@",baseParam);
                params = [AppPushSecureDataUtil enCipherStr:baseParam key:nil withUrlEncode:YES];
            } else {
                params = [AppPushSecureDataUtil enCipherStr:params key:nil withUrlEncode:YES];
            }
            
            params = [NSString stringWithFormat:@"d=%@", params];
            //NSLog(@"params : %@",params);
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        if(type == 0) {
            [request setHTTPMethod:@"GET"];
        }
        else if(type == 1) {
            [request setHTTPMethod:@"POST"];
            [request addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
            [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
        
        connection = [[AppPushCustomURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:tag object:argObject];
        if (connection) {
            [connection start];
            [receivedData setObject:[NSMutableData alloc] forKey:connection._tag];
        }
        //NSLog(@"=============================");
        NSLog(@"PMS Network start : %@ ",tag);
        //NSLog(@"PMS origin_params : %@", originParams);
        //NSLog(@"PMS N enc_params : %@", params);
        //NSLog(@"=============================");
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility requestAsyncLoad default : %@", exception);
    }
}
- (NSMutableData*)dataForConnection:(AppPushCustomURLConnection*)_connection {
    @try {
        NSMutableData *data = [receivedData objectForKey:_connection._tag];
        return data;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility dataForConnection : %@", exception);
        return nil;
    }
}
- (void)connection:(NSURLConnection *)_connection didReceiveResponse:(NSURLResponse *)response {
    @try {
        NSMutableData *dataForConnection = [self dataForConnection:(AppPushCustomURLConnection*)_connection];
        [dataForConnection setLength:0];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility connection didReceiveResponse : %@", exception);
    }
}
- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data {
    @try {
        NSMutableData *dataForConnection = [self dataForConnection:(AppPushCustomURLConnection*)_connection];
        [dataForConnection appendData:data];
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility connection didReceiveData : %@", exception);
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    @try {
        
        NSMutableData *dataForConnection = [self dataForConnection:(AppPushCustomURLConnection*)_connection];
        NSString *response;
        if(dataForConnection==nil) return;
        BOOL isCert = NO;
        
        response = [AppPushSecureDataUtil deCipherParameter:dataForConnection
                                                        key:[[NSUserDefaults standardUserDefaults] valueForKey:APPPUSH_DEF_NETWORK_KEY]
                                                      islog:isCert];
        
        //        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        //        if([@"105" isEqualToString:[userDefault valueForKey:@"105"]]) {
        //            response = @"105";
        //            [userDefault setValue:@"100" forKey:@"105"];
        //            [userDefault synchronize];
        //        }
        NSDictionary *dictionary;
        if(response!=nil) {
            if([response isEqualToString:@"105"]) {
                
                // 인증인데, 서버에서 받아주지 못해서 실패
                
                isReCert = YES;
                NSLog(@"PMS Network session over");
                //[arrQueue removeAllObjects];
                
                [((AppPushCustomURLConnection*)_connection).timer invalidate];
                [receivedData removeObjectForKey:((AppPushCustomURLConnection*)_connection)._tag];
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:APPPUSH_DEF_NOTI_REDEVICE_CERT
                                                                    object:nil
                                                                  userInfo:nil];
                
                
                return;
                
            } else if(isReCert || [((AppPushCustomURLConnection*)_connection)._tag isEqualToString:APPPUSH_NOTI_DEVICE]) {
                
                NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:response error:NULL];
                if([dic count] > 0) {
                    NSString *code = [dic valueForKey:@"code"];
                    if([code isEqualToString:@"000"]) {
                        //ReCert 성공, 암호키를 다시 설정한다.
                        
                        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[dic valueForKey:@"encKey"]] forKey:APPPUSH_DEF_NETWORK_KEY];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        //NSLog(@"encKey : %@",[[NSUserDefaults standardUserDefaults] valueForKey:APPPUSH_DEF_NETWORK_KEY]);
                        
                    }
                }
            }
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:response, @"response", nil];
        } else {
            dictionary = nil;
            
            // 서버 응답없음이나 기타 에러로 싪패.
        }
        
        [((AppPushCustomURLConnection*)_connection).timer invalidate];
        [receivedData removeObjectForKey:((AppPushCustomURLConnection*)_connection)._tag];
        
        NSString *code = nil;
        if(response!=nil) {
            NSDictionary *dic = (NSDictionary*)[jsonParser objectWithString:response error:NULL];
            if(dic!=nil && [dic count] > 0) {
                code = [dic valueForKey:@"code"];
                if([code isEqualToString:@"000"]) {
                    //통신 성공
                    if(successTime==nil) successTime = [[NSMutableString alloc] init];
                    [successTime setString:[df stringFromDate:[NSDate date]]];
                }
            }
        }
        
        if([((AppPushCustomURLConnection*)_connection)._tag isEqualToString:APPPUSH_NOTI_DEVICE]) {
            isCertNetwork = NO;
        }
        
        if(isReCert && [((AppPushCustomURLConnection*)_connection)._tag isEqualToString:APPPUSH_NOTI_DEVICE]) {
            //재인증의 경우
            isReCert = NO;
            [self checkQueue];
        } else if(!isReCert && ![((AppPushCustomURLConnection*)_connection)._tag isEqualToString:APPPUSH_NOTI_DEVICE]){
            //정상 통신
            [self minusQueue];
        }
        else if(!isReCert)
        {   // nami0342 - 요청이 마무리되면 큐에서 데이터를 제거한다.
            [self minusQueue];
        }
        
        //noti가 최하단인 이유는 네트워크 통신이 종료됨을 알림에 따라 즉각적인 네트워크 통신이 일어날수 있기때문에 그전에 Queue 처리를 해야하기 때문이다.
        NSLog(@"PMS Network done : %@ - %@",((AppPushCustomURLConnection*)_connection)._tag,code!=nil?code:@"none");
        //NSLog(@"PMS Result Data is : %@", response==nil?@"null!":response);
        
        
        //NSLog(@"tag: %@,",((AppPushCustomURLConnection*)_connection)._tag);
        //NSLog(@"object: %@,",((AppPushCustomURLConnection*)_connection).object==nil?@"null":((AppPushCustomURLConnection*)_connection).object);
        //NSLog(@"dictionary : %@,",dictionary);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:((AppPushCustomURLConnection*)_connection)._tag
                                                            object:((AppPushCustomURLConnection*)_connection).object
                                                          userInfo:dictionary];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushNetworkUtility connectionDidFinishLoading : %@", exception);
    }@finally {
//        [(AppPushCustomURLConnection*)_connection release];
    }
}
@end
