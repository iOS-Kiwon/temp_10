//
//  PushDataRequest.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "PushDataRequest.h"
#import "URLDefine.h"
#import <Mocha/NSDictionary+RequestEncoding.h>

#import <AdSupport/AdSupport.h>


@implementation PushDataRequest

@synthesize delegate;

-(id)init
{
    self = [super init];
    if(self != nil)
    {
    }
    return  self;
}


- (NSData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
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
            NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT];
            [result appendData: DATA(formstring)];
            [result appendData:value];
        }
        else
        {
            // all non-image fields assumed to be strings
            NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
            [result appendData: DATA(formstring)];
            [result appendData:DATA(value)];
        }
        
        NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
    
    NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
}


- (void) sendData:(NSString *)deviceToken  customNo:(NSString *)custNo
{
    
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
   
    
    [post_dict setValue:deviceToken forKey:@"deviceToken"];
    
    // -- start -- 2013.03.22 푸시 서비스 정보 제공시 DEVICEUUID 같이 보낸다. -- start --
    [post_dict setValue:DEVICEUUID forKey:@"deviceId"];
    // -- end -- 2012.03.22 푸시 서비스 정보 제공시 DEVICEUUID 같이 보낸다. -- end --
    
    [post_dict setValue:custNo forKey:@"customerNumber"];
    [post_dict setValue:[Common_Util getSHA256:[NSString stringWithFormat:@"%@_GS",DEVICEUUID]] forKey:@"gsuuid"];       // nami0342 - Add gsuuid
    
    NSString* mediaCode = [Mocha_DeviceInfo getPlatform];
    
    
    
    NSString* wapcidstr = [NSString string];
    NSString* pcidstr = [NSString string];
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if([cookie.name isEqualToString:@"wa_pcid"]){
            wapcidstr = cookie.value;
        }else if ([cookie.name isEqualToString:@"pcid"]){
            pcidstr = cookie.value;
        }
    }
    
    if([wapcidstr length] < 3) {
        wapcidstr = @"";
    }
    
    if([pcidstr length] < 3) {
        pcidstr = @"";
    }

    
    [post_dict setValue:([mediaCode rangeOfString:@"iPad"].location!=NSNotFound)?@"04":@"03" forKey:@"type"];
    // 푸시 서비스 정보 제공시 App version도 함께 보낸다.
    //[post_dict setValue:[NSString stringWithFormat:@"%@:%@",CURRENTAPPVERSION,wapcidstr]   forKey:@"appVersion"];
    
    [post_dict setValue:[NSString stringWithFormat:@"%@",CURRENTAPPVERSION]   forKey:@"appVersion"];
    [post_dict setValue:wapcidstr   forKey:@"waPcid"];
    [post_dict setValue:pcidstr   forKey:@"pcid"];
    
    [post_dict setValue:[[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString forKey:@"aid"];
    [post_dict setValue:@"" forKey:@"admedia"];
    [post_dict setValue:@"" forKey:@"utm"];
    
    
    //동영상 자동재생 값 추가 - by shawn 20151215
    //if ([[[NSUserDefaults standardUserDefaults] valueForKey:BESTDEAL_AUTOPLAYMOVIE] isEqualToString:@"Y"]) {
    
    if([LL(BESTDEAL_AUTOPLAYMOVIE) isEqualToString:@"Y"]){
         [post_dict setValue:@"Y" forKey:@"videoAutoPlayYn"];
    }else {
         [post_dict setValue:@"N" forKey:@"videoAutoPlayYn"];
    }
    

    
    NSLog(@"comm dictionary %%%%%%%% = %@",post_dict);
    
    //new json - binary데이터 what do i do?
    NSData *postData = [[post_dict jsonEncodedKeyValueString] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"json str %@", [post_dict jsonEncodedKeyValueString]);
    
    
    
    
    // Establish the API request. Use upload vs uploadAndPost for skip tweet
    NSString *baseurl = PUSHCUSTINFOURL_NEW;
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

    
    [urlRequest setHTTPMethod: @"POST"];

    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];

    
    
 
    
    // Submit & retrieve results
    // NSError *error;
    // NSHTTPURLResponse *response;
    NSLog(@"Contacting Server....");
    
   
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      if (!result)
                                      {
                                          
                                          NSLog(@"Contacting Server2....");
                                          [self cleanup:[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]];
                                          return;
                                      }else {
                                          NSLog(@"Contacting Server3....");
                                          //응답코드 원래없음
                                          //응답헤더 확인
                                          NSLog(@"push token comm result %@", [response description]);
                                          
                                      }
                                  }];
    [task resume];
    
    /*
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         if (!result)
         {
             
             NSLog(@"Contacting Server2....");
             [self cleanup:[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]];
             return;
         }else {
             NSLog(@"Contacting Server3....");
             //응답코드 원래없음
             //응답헤더 확인
             NSLog(@"push token comm result %@", [response description]);
             
         }
         
         
     }];
    [queue waitUntilAllOperationsAreFinished];
    */
}

- (void) cleanup: (NSString *) output
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(doneRequest:)])
    {
        
        [self.delegate doneRequest:output];
    }
}

@end
