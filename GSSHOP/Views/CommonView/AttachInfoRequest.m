//
//  AttachInfoRequest.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 12. 22..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "AttachInfoRequest.h"
#import "AppDelegate.h"
#import "GoodsInfo.h"
//#import <Mocha/JSON.h>
#import <Mocha/NSDictionary+RequestEncoding.h>
#import "URLDefine.h"

@implementation AttachInfoRequest

@synthesize tAttachInfo, delegate;

#define MBDContentstr @"cmd"

//1차 텍스트 메세지 전송후 결과
- (void) cleanup: (NSString *) output
{
    if(output == nil) {
        //네트워크 에러
        if (self.delegate && [self.delegate respondsToSelector:@selector(doneRequest:)])
        {
            tAttachInfo =nil;
            [self.delegate doneRequest:nil];
            [ApplicationDelegate.gactivityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
            
        }
        return;
    }
    
    // nami0342 - JSON
    NSDictionary *result = [output JSONtoValue];
    
    NSLog(@"status = %@  ==== %@",output, [result objectForKey:@"error_code"]);
    NSString* drs = [NSString stringWithFormat:@"%@", [result objectForKey:@"error_code"]];
    
    
    if([drs isEqualToString:@"0"]){
        if([tAttachInfo.arruploadimg count] < 1 ){
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(doneRequest:)])
            {
                tAttachInfo =nil;
                [self.delegate doneRequest:output];
                
                
                [ApplicationDelegate.gactivityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
                
            }
            
        }else {
            //2차 이미지 전송 시도
            // nami0342 - image
            [self imgsendData_n:result];
            
            
        }
    }
    else {
        //에러코드를 돌려받은 에러의경우
        tAttachInfo =nil;
        [self.delegate doneRequest:output];
        [ApplicationDelegate.gactivityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
        
        
    }
    
    
    
    
    
    
}



- (NSMutableData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
{
    //NSStringEncoding EUCKR = -2147482590;
    id boundary = @"------------0x0x0x0x0x0x0x0x";
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
    
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([value isKindOfClass:[NSData class]])
        {
            // handle image data
            NSString *formstring = [NSString stringWithFormat:EVTIMAGE_CONTENT];
            [result appendData: DATA(formstring)];
            [result appendData:value];
        }
        else
        {
            // all non-image fields assumed to be strings
            NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
            [result appendData: DATA(formstring)];
            
            if([Mocha_Util strContain:MBDContentstr srcstring:formstring]){
                [result appendData:[[NSString stringWithFormat:@"%@",[Mocha_Util strReplace:@"\n" replace:@"<br>" string:(NSString*)value ]] dataUsingEncoding:NSUTF8StringEncoding]];
            }else {
                
                [result appendData:[[NSString stringWithFormat:@"%@",value] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            NSLog(@"formstring = %@, value = %@",formstring,([Mocha_Util strContain:MBDContentstr srcstring:formstring])?[Mocha_Util strReplace:@"\n" replace:@"<br>" string:(NSString*)value ]:value);
        }
        
        NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
    
    NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
}


//도큐맨트에 파일  존재여부 확인
- (BOOL)docFileExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *writableDBPath = [DOCS_DIR stringByAppendingPathComponent:@"eventimage.jpg"];
    NSLog(@"file = %@",writableDBPath);
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
    
    if (dbexits) //존재하면 삭제
    {
        
        return YES;
    }
    
    return NO;
}
- (void) sendData:(AttachInfo *)sendData {
    self.tAttachInfo = sendData;
    //JSON 데이터 구성
    
    URLParser *sparser = [[URLParser alloc] initWithURLString: [[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString] ];
    NSLog(@"dddddcaller = %@ \n uploadUrl = %@ \n returnUrl = %@ ", [sparser valueForVariable:@"domain_id"], [sparser valueForVariable:@"service_type"], [sparser valueForVariable:@"node_id"]);
    
    NSMutableDictionary* jpost_dict = [[NSMutableDictionary alloc] init];
    [jpost_dict setValue:@"TalkStart" forKey:@"command"];
    [jpost_dict setValue:[sparser valueForVariable:@"domain_id"] forKey:@"domain_id"];
    [jpost_dict setValue:[sparser valueForVariable:@"service_type"] forKey:@"service_type"];
    [jpost_dict setValue:[sparser valueForVariable:@"ref_talk_id"] forKey:@"ref_talk_id"];
    [jpost_dict setValue:[sparser valueForVariable:@"node_id"] forKey:@"node_id"];
    [jpost_dict setValue:[sparser valueForVariable:@"in_channel_id"] forKey:@"in_channel_id"];
    [jpost_dict setValue:[sparser valueForVariable:@"customer_id"] forKey:@"customer_id"];
    [jpost_dict setValue:[sparser valueForVariable:@"customer_name"] forKey:@"customer_name"];
    
    NSString * tggString = [NSString stringWithFormat: @"%@", tAttachInfo.contentstr];
    [jpost_dict setValue:tggString  forKey:@"message"];
    NSString * turlString = [[NSString stringWithFormat: @"%@", [[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"uuuuurrrrr str %@", turlString);
    NSString *strToEncode = [jpost_dict JSONtoString];
    NSString *strJson = [strToEncode urlEncodedString];
    NSString *strPost = [NSString stringWithFormat:@"%@=%@",MBDContentstr,strJson];
    NSData *postData = [strPost dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString:turlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    NSLog(@"urlRequest allHTTPHeaderFields = %@",urlRequest.allHTTPHeaderFields);
    NSLog(@"urlRequest %@",urlRequest);
    // Submit & retrieve results
    NSError *error;
    NSURLResponse *response;
    NSLog(@"Contacting Server....");
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(!result) {
        NSLog(@"Server Error.... %@",[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]);
        [self cleanup:nil];
        return;
    }
    // Return results
    NSString *outstring = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    [self cleanup: outstring];
}




- (void) imgsendData:(NSMutableDictionary*)sresult {
    int j = 0;
    for (id oneObject in tAttachInfo.arruploadimg) {
        if ([oneObject isKindOfClass:[UIImage class]]) {
            j++;
            NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
            //JSON 데이터 구성
            URLParser *sparser = [[URLParser alloc] initWithURLString: [[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString] ];
            NSLog(@"dddddcaller = %@ \n uploadUrl = %@ \n returnUrl = %@ ", [sparser valueForVariable:@"domain_id"], [sparser valueForVariable:@"service_type"], [sparser valueForVariable:@"node_id"]);
            NSMutableDictionary* jpost_dict = [[NSMutableDictionary alloc] init];
            [jpost_dict setValue:@"TalkSend" forKey:@"command"];
            [jpost_dict setValue:[sparser valueForVariable:@"domain_id"] forKey:@"domain_id"];
            [jpost_dict setValue:[sparser valueForVariable:@"service_type"] forKey:@"service_type"];
            [jpost_dict setValue:[sparser valueForVariable:@"customer_id"] forKey:@"customer_id"];
            [jpost_dict setValue:@"" forKey:@"message"];
            [jpost_dict setValue:[[sresult objectForKey:@"data"] objectForKey:@"talk_id"] forKey:@"talk_id"];
            NSMutableArray* tarr = [[sresult objectForKey:@"data"] objectForKey:@"messages"];
            int tsidx = 0;
            
            for (int i=0; i<[tarr count]; i++) {
                if([[tarr objectAtIndex:i] objectForKey:@"seq"] != nil && [[[tarr objectAtIndex:i] objectForKey:@"seq"] isKindOfClass:[NSNull class]] == NO) {
                    if( tsidx < [[[tarr objectAtIndex:i] objectForKey:@"seq"] intValue] ) {
                        tsidx =[[[tarr objectAtIndex:i] objectForKey:@"seq"] intValue];
                    }
                    NSLog(@" %d", [[[tarr objectAtIndex:i] objectForKey:@"seq"] intValue]  );
                }
            }
            
            //증가 (j-1) 더해주기 빼쟈
            [jpost_dict setValue:[NSString stringWithFormat:@"%d", tsidx+1+(j-1)]  forKey:@"seq"];
            NSData *jpostData = [[jpost_dict jsonEncodedKeyValueString] dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"sendjson strd  %@, %@",[NSString stringWithFormat:@"%d", tsidx+1+(j-1)] ,  [jpost_dict jsonEncodedKeyValueString]);
            NSString *secondString = [[NSString alloc] initWithData:jpostData encoding:NSUTF8StringEncoding];
            NSString * turlString = [[NSString stringWithFormat: @"%@", [[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString]]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSLog(@"uuuuurrrrr str %@", [[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString]);
            NSURL *url = [NSURL URLWithString:turlString];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
            //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
            NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
            [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
            [urlRequest setHTTPMethod: @"POST"];
            [urlRequest setValue:MULTIPART forHTTPHeaderField:@"Content-Type"];
            [post_dict setObject:secondString forKey:@"cmd"];
            [post_dict setObject:UIImageJPEGRepresentation((UIImage*)oneObject, 0.75f) forKey:@"file"];
            NSLog(@"  %%%%%%%% = %@",post_dict);
            // Create the post data from the post dictionary
            NSData *postData = [self generateFormDataFromPostDictionary:post_dict];
            [urlRequest setHTTPBody: postData];
            // Submit & retrieve results
            NSError *error;
            NSURLResponse *response;
            NSLog(@"Contacting Server....");
            NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
            
            if(!result) {
                self.tAttachInfo =nil;
                [self.delegate doneRequest:nil];
                [ApplicationDelegate.gactivityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
            }
            else {
                
                // nami0342 - JSON
                NSDictionary *resultj = [result JSONtoValue];
                
                NSString* drs = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"error_code"]];
                if([drs isEqualToString:@"0"]) {
                    //마지막에만
                    if(j == [tAttachInfo.arruploadimg count]) {
                        NSString* err_str;
                        if ([NCS([resultj objectForKey:@"error_message"]) length] >0) {
                            NSLog(@"errMstr=1:%@", [resultj objectForKey:@"error_message"]);
                            err_str= [[resultj objectForKey:@"error_message"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                            err_str =  [Mocha_Util strReplace:@"\n" replace:@"<br>" string:err_str];
                            NSLog(@"errMstr=2:%@", err_str);
                        }
                        
                        NSString *talk_id_str ;
                        //20161021 parksegun 예외처리 추가
                        if (NCO([sresult objectForKey:@"data"])  && NCO([[sresult objectForKey:@"data"] objectForKey:@"talk_id"]) &&[ [[sresult objectForKey:@"data"] objectForKey:@"talk_id"] length] > 0) {
                            talk_id_str= [[sresult objectForKey:@"data"] objectForKey:@"talk_id"];
                        }
                        else {
                            talk_id_str = @"null";
                        }
                        
                        NSString* strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\")",[tAttachInfo.urlreqparser valueForVariable:@"callback"],   talk_id_str, NCS([resultj objectForKey:@"error_code"]), err_str ];
                        NSLog(@"최종 정상등록이거나 에러거나 callback호출, %@", strjs);
                        //이미지 전송 성공
                        if (self.delegate && [self.delegate respondsToSelector:@selector(doneimgRequest:)]) {
                            tAttachInfo =nil;
                            [self.delegate doneimgRequest:strjs];
                            [ApplicationDelegate.gactivityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
                        }
                    }
                }
                else {
                    //0이아니면 중도 실패
                    self.tAttachInfo =nil;
                    [self.delegate doneRequest:nil];
                    [ApplicationDelegate.gactivityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
                }
            }
        }
    }
}


// nami0342 - mutable
- (void) imgsendData_n:(NSDictionary*)sresult {
    int j = 0;
    for (id oneObject in tAttachInfo.arruploadimg) {
        if ([oneObject isKindOfClass:[UIImage class]]) {
            j++;
            NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
            //JSON 데이터 구성
            URLParser *sparser = [[URLParser alloc] initWithURLString: [[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString] ];
            NSLog(@"dddddcaller = %@ \n uploadUrl = %@ \n returnUrl = %@ ", [sparser valueForVariable:@"domain_id"], [sparser valueForVariable:@"service_type"], [sparser valueForVariable:@"node_id"]);
            NSMutableDictionary* jpost_dict = [[NSMutableDictionary alloc] init];
            [jpost_dict setValue:@"TalkSend" forKey:@"command"];
            [jpost_dict setValue:[sparser valueForVariable:@"domain_id"] forKey:@"domain_id"];
            [jpost_dict setValue:[sparser valueForVariable:@"service_type"] forKey:@"service_type"];
            [jpost_dict setValue:[sparser valueForVariable:@"customer_id"] forKey:@"customer_id"];
            [jpost_dict setValue:@"" forKey:@"message"];
            [jpost_dict setValue:[[sresult objectForKey:@"data"] objectForKey:@"talk_id"] forKey:@"talk_id"];
            NSMutableArray* tarr = [[sresult objectForKey:@"data"] objectForKey:@"messages"];
            int tsidx = 0;
            
            for (int i=0; i<[tarr count]; i++) {
                if([[tarr objectAtIndex:i] objectForKey:@"seq"] != nil && [[[tarr objectAtIndex:i] objectForKey:@"seq"] isKindOfClass:[NSNull class]] == NO) {
                    if( tsidx < [[[tarr objectAtIndex:i] objectForKey:@"seq"] intValue] ) {
                        tsidx =[[[tarr objectAtIndex:i] objectForKey:@"seq"] intValue];
                    }
                    NSLog(@" %d", [[[tarr objectAtIndex:i] objectForKey:@"seq"] intValue] );
                }
            }
            
            //증가 (j-1) 더해주기 빼쟈
            [jpost_dict setValue:[NSString stringWithFormat:@"%d", tsidx+1+(j-1)]  forKey:@"seq"];
            NSData *jpostData = [[jpost_dict jsonEncodedKeyValueString] dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"sendjson strd  %@, %@",[NSString stringWithFormat:@"%d", tsidx+1+(j-1)] ,  [jpost_dict jsonEncodedKeyValueString]);
            NSString *secondString = [[NSString alloc] initWithData:jpostData encoding:NSUTF8StringEncoding];
            NSString * turlString = [[NSString stringWithFormat: @"%@", [[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSLog(@"uuuuurrrrr str %@", [[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString]);
            NSURL *url = [NSURL URLWithString:turlString];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
            //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
            NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
            [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
            [urlRequest setHTTPMethod: @"POST"];
            [urlRequest setValue:MULTIPART forHTTPHeaderField:@"Content-Type"];
            [post_dict setObject:secondString forKey:@"cmd"];
            [post_dict setObject:UIImageJPEGRepresentation((UIImage*)oneObject, 0.75f) forKey:@"file"];
            NSLog(@"  %%%%%%%% = %@",post_dict);
            // Create the post data from the post dictionary
            NSData *postData = [self generateFormDataFromPostDictionary:post_dict];
            [urlRequest setHTTPBody: postData];
            // Submit & retrieve results
            NSError *error;
            NSURLResponse *response;
            NSLog(@"Contacting Server....");
            NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
            
            if(!result) {
                self.tAttachInfo =nil;
                [self.delegate doneRequest:nil];
                [ApplicationDelegate.gactivityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
            }
            else {
                // nami0342 - JSON
                NSDictionary  *resultj =  [result JSONtoValue];
                NSString* drs = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"error_code"]];
                if([drs isEqualToString:@"0"]) {
                    //마지막에만
                    if(j == [tAttachInfo.arruploadimg count]) {
                        NSString* err_str;
                        //20161021 parksegun 예외처리 추가
                        if ([NCS([resultj objectForKey:@"error_message"]) length] > 0) {
                            NSLog(@"errMstr=1:%@", [resultj objectForKey:@"error_message"]);
                            err_str= [[resultj objectForKey:@"error_message"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                            err_str =  [Mocha_Util strReplace:@"\n" replace:@"<br>" string:err_str];
                            NSLog(@"errMstr=2:%@", err_str);
                        }
                        
                        NSString *talk_id_str ;
                        if (NCO([sresult objectForKey:@"data"]) && NCO([[sresult objectForKey:@"data"] objectForKey:@"talk_id"]) && [ NCS([[sresult objectForKey:@"data"] objectForKey:@"talk_id"]) length] > 0) {
                            talk_id_str= [[sresult objectForKey:@"data"] objectForKey:@"talk_id"];
                        }
                        else {
                            talk_id_str = @"null";
                        }
                        
                        NSString* strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\")",[tAttachInfo.urlreqparser valueForVariable:@"callback"],   talk_id_str, NCS([resultj objectForKey:@"error_code"]), err_str ];
                        NSLog(@"최종 정상등록이거나 에러거나 callback호출, %@", strjs);
                        //이미지 전송 성공
                        if (self.delegate && [self.delegate respondsToSelector:@selector(doneimgRequest:)]) {
                            tAttachInfo =nil;
                            [self.delegate doneimgRequest:strjs];
                            [ApplicationDelegate.gactivityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
                        }
                    }
                    
                    
                }
                else {
                    //0이아니면 중도 실패
                    self.tAttachInfo =nil;
                    [self.delegate doneRequest:nil];
                    [ApplicationDelegate.gactivityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
                }
            }
        }
    }
}








- (BOOL) deleteMessageData:(NSMutableDictionary*)sresult
{
    //JSON 데이터 구성
    
    URLParser *sparser = [[URLParser alloc] initWithURLString: [[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString] ];
    
    
    
    NSMutableDictionary* jpost_dict = [[NSMutableDictionary alloc] init];
    [jpost_dict setValue:@"TalkDelete" forKey:@"command"];
    [jpost_dict setValue:[sparser valueForVariable:@"domain_id"] forKey:@"domain_id"];
    [jpost_dict setValue:[sparser valueForVariable:@"service_type"] forKey:@"service_type"];
    [jpost_dict setValue:[sparser valueForVariable:@"customer_id"] forKey:@"customer_id"];
    [jpost_dict setValue:[[sresult objectForKey:@"data"] objectForKey:@"talk_id"]    forKey:@"talk_id"];
    
    NSData *jpostData = [[jpost_dict jsonEncodedKeyValueString] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"sendjson str %@", [jpost_dict jsonEncodedKeyValueString]);
    
    NSString *secondString = [[NSString alloc] initWithData:jpostData encoding:NSUTF8StringEncoding];
    NSString *poststr =[NSString stringWithFormat:@"%@=%@",MBDContentstr,secondString];
    NSData *postData = [poststr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    
    NSLog(@"uuuuurrrrr str %@", [[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString]);
    NSURL *url = [NSURL URLWithString:[[tAttachInfo.urlreqparser valueForVariable:@"uploadUrl"] urlDecodedString]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:URLENCODEDFORMHEAD forHTTPHeaderField:@"Content-Type"];
    
    
    
    NSLog(@"delete snd data::  %@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    
    [urlRequest setHTTPBody: postData];
    
    
    NSError *error;
    NSURLResponse *response;
    NSLog(@"Contacting Server....");
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    
    if (!result)
    {
        return NO;
    }else {
        // nami0342 - JSON
        NSDictionary *resultj = [result JSONtoValue];
        
        NSString* drs = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"error_code"]];
        if([drs isEqualToString:@"0"]){
            return YES;
        }else {
            return NO;
        }
    }
    
    return NO;
    
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
}
@end
