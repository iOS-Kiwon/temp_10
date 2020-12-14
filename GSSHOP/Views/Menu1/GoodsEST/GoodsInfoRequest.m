//
//  GoodsInfoRequest.m
//  GSSHOP
//
//  Created by uinnetworks on 11. 7. 25..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  상품평 쓰기

#import "GoodsInfoRequest.h"
#import "AppDelegate.h"
#import "GoodsInfo.h"
#import <Mocha/NSDictionary+RequestEncoding.h>
#import "URLDefine.h"
#import "PushData.h"

@implementation GoodsInfoRequest

@synthesize upImage;
@synthesize delegate;


- (void) cleanup: (NSString *) output {
    self.upImage = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(doneRequest:)]) {
        [self.delegate doneRequest:output];
    }
}

- (NSString*) getCustNo {
    return NCS([[DataManager sharedManager] customerNo]);
}

- (NSMutableDictionary *)recvDataDic:(NSString *)goodsurl {
    // EC통합재구축 20140108 -Youngmin Jin Start
    NSString *urlString;
    NSString *custNo = [self getCustNo];
    if (goodsurl != nil && [goodsurl length] > 0) {
            custNo = [NSString stringWithFormat:@"&appCustNo=%@",custNo];
    }
    else {
            custNo = [NSString stringWithFormat:@"appCustNo=%@",custNo];
    }

    //20170907 배포 상품평 파라메터 추가
    NSString *strParams = [NSString stringWithFormat:@"%@&appVersion=%@&appCode=%@&appGB=%@",custNo,USERAGENTCUSTOMVERSION,USERAGENTCODE,USERAGENTAPPGB];
    
    if(goodsurl != nil && [[goodsurl componentsSeparatedByString:@"&"] count] > 0 && [[[[goodsurl componentsSeparatedByString:@"&"] objectAtIndex:0] componentsSeparatedByString:@"="] count] > 0 && [[[[[goodsurl componentsSeparatedByString:@"&"] objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:0] isEqualToString:@"messageId"] == NO) {
        urlString = GSRECVGOODSINFOURL(goodsurl,strParams);
    }
    else {
        urlString = GSRECVGOODSINFOURL_MOD(goodsurl,strParams);
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSLog(@"requestrequest = %@",request);
    NSURLResponse *response;
    NSError *ierror = nil;
    NSData *responseData = [NSURLSession sendSessionSynchronousRequest:request returningResponse:&response error:&ierror];
    // nami0342 - JSON
    return [responseData JSONtoValue];
    // EC통합재구축 20140108 -Youngmin Jin End
}



- (NSMutableData*)generateFormDataFromPostDictionary:(NSDictionary*)dict {
    //NSStringEncoding EUCKR = -2147482590;
    id boundary = @"------------0x0x0x0x0x0x0x0x";
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
    
    int imageCount = 0;
    
    for(int i = 0; i < [keys count]; i++) {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        if ([value isKindOfClass:[NSData class]]) {
            [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            // handle image data
            NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT];
            [result appendData: DATA(formstring)];
            [result appendData:value];
            imageCount++;
            NSLog(@"formstring = %@, value = %@",formstring,([Mocha_Util strContain:@"prdrevwBody" srcstring:formstring])?[Mocha_Util strReplace:@"\n" replace:@"<br>" string:(NSString*)value ]:value);
            [result appendData:DATA(@"\r\n")];
        }
        else if ([value isKindOfClass:[NSArray class]]) { //배열일경우 이미지 첨부 전용임 다른경우는 또 만들어야함
            NSArray *arrImage = (NSArray *)value;
            for(int j=0; j<[arrImage count]; j++) {
                if([[arrImage objectAtIndex:j] isKindOfClass:[NSData class]]) {
                    [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    // handle image data
                    NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT_MULTI,imageCount];
                    [result appendData: DATA(formstring)];
                    [result appendData:[arrImage objectAtIndex:j]];
                    imageCount++;
                    NSLog(@"formstring = %@",formstring);
                    [result appendData:DATA(@"\r\n")];
                }
            }//for
        }
        else {
            [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            // all non-image fields assumed to be strings
            NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
            [result appendData: DATA(formstring)];

            if([Mocha_Util strContain:@"prdrevwBody" srcstring:formstring]) {
                [result appendData:[[NSString stringWithFormat:@"%@",[Mocha_Util strReplace:@"\n" replace:@"<br>" string:(NSString*)value ]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else {
                [result appendData:[[NSString stringWithFormat:@"%@",value] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            NSLog(@"formstring = %@, value = %@",formstring,([Mocha_Util strContain:@"prdrevwBody" srcstring:formstring])?[Mocha_Util strReplace:@"\n" replace:@"<br>" string:(NSString*)value ]:value);
            [result appendData:DATA(@"\r\n")];
        }
    }
    NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
}


//도큐맨트에 파일 삭제하기/ 존재여부 확인후 삭제
- (BOOL)docFileDelete {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [DOCS_DIR stringByAppendingPathComponent:@"image.jpg"];
    NSLog(@"file = %@",writableDBPath);
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
    if (dbexits) {//존재하면 삭제
        return YES;
    }
    return NO;
}

- (void)sendDataDic:(NSMutableDictionary *)dic {
    NSMutableDictionary* resultdic = dic;
    NSString *baseurl;
    if([dic valueForKey:@"prdRevw.prdrevwId"] == nil) {
        baseurl = GSSENDGOODSINFOURL;
    }
    else {
        baseurl = GSSENDGOODSINFOURL_MOD;
    }
    if(NCA([dic objectForKey:@"prdRevwImageArr"])) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for(int i=0; i<[(NSArray *)[dic objectForKey:@"prdRevwImageArr"] count]; i++) {
            [arr addObject:UIImageJPEGRepresentation((UIImage *)[[dic objectForKey:@"prdRevwImageArr"] objectAtIndex:i],0.7f)];
        }
        [resultdic setObject:arr forKey:@"prdRevwImage"];
        [dic setObject:@"2" forKey:@"prdRevw.atachFileGbn"];
    }
    // Create the post data from the post dictionary
    NSMutableData *postData = [self generateFormDataFromPostDictionary:resultdic];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    [urlRequest addValue:MULTIPART forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    // Submit & retrieve results
    NSError *error;
    NSURLResponse *response;
    NSLog(@"Contacting Server....");
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(!result) {
        [self cleanup:[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]];
        return;
    }
    // Return results
    NSString *outstring = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    [self cleanup: outstring];
}

- (void) sendData:(GoodsInfo *)sendData img:(NSInteger)bImgSend {
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
    //39개
    [post_dict setObject:sendData.bbsId forKey:@"bbsId"];
    [post_dict setObject:sendData.brandName forKey:@"brandName"];
    [post_dict setObject:@"10 " forKey:@"contBytes"];
    if(bImgSend == NO) {//이미지 없다.
        [post_dict setObject:@"1" forKey:@"contentsFlag"]; //이미지 없으면 1, 이미지 있으면 2
    }
    else {
        [post_dict setObject:@"2" forKey:@"contentsFlag"]; //이미지 없으면 1, 이미지 있으면 2
    }
    [post_dict setObject:sendData.masterId forKey:@"masterId"]; //0 이상이면 수정 , 0이면 쓰기
    [post_dict setObject:sendData.dbsts forKey:@"dbsts"];
    [post_dict setObject:sendData.ecuserid forKey:@"ecuserid"];
    [post_dict setObject:sendData.eshopid forKey:@"eshopid"];
    [post_dict setObject:sendData.evalName1 forKey:@"evalName1"];
    [post_dict setObject:sendData.evalName2 forKey:@"evalName2"];
    [post_dict setObject:sendData.evalName3 forKey:@"evalName3"];
    [post_dict setObject:sendData.evalName4 forKey:@"evalName4"];
    [post_dict setObject:sendData.evalValue1 forKey:@"evalValue1"];
    [post_dict setObject:sendData.evalValue2 forKey:@"evalValue2"];
    [post_dict setObject:sendData.evalValue3 forKey:@"evalValue3"];
    [post_dict setObject:sendData.evalValue4 forKey:@"evalValue4"];
    [post_dict setObject:sendData.happyTesterId forKey:@"happyTesterId"];
    [post_dict setObject:sendData.hidden_name_0 forKey:@"hidden_name_0"];
    [post_dict setObject:sendData.hidden_path_0 forKey:@"hidden_path_0"];
    [post_dict setObject:sendData.save_root forKey:@"save_root"];
    [post_dict setObject:sendData.messageDscr forKey:@"messageDscr"];
    [post_dict setObject:sendData.messageId forKey:@"messageId"];
    [post_dict setObject:sendData.messageLevel forKey:@"messageLevel"];
    [post_dict setObject:sendData.ordOption1Nm forKey:@"ordOption1Nm"];
    [post_dict setObject:sendData.ordOption2Nm forKey:@"ordOption2Nm"];
    [post_dict setObject:sendData.ordOptionDispYn forKey:@"ordOptionDispYn"];
    [post_dict setObject:sendData.orderNum forKey:@"orderNum"];
    [post_dict setObject:sendData.pleinPrd forKey:@"pleinPrd"];
    [post_dict setObject:sendData.promoNum forKey:@"promoNum"];
    [post_dict setObject:sendData.isSetPrd forKey:@"isSetPrd"];
    [post_dict setObject:sendData.prdImg forKey:@"prdImg"];
    if(sendData.prdName == nil) {
        
    }
    else {
        [post_dict setObject:sendData.prdName forKey:@"prdname"];
    }
    [post_dict setObject:sendData.prdTypeCd forKey:@"prdTypeCd"];
    [post_dict setObject:sendData.prdid forKey:@"prdid"];
    [post_dict setObject:sendData.promo_num forKey:@"promo_num"];
    [post_dict setObject:sendData.remark forKey:@"remark"];
    [post_dict setObject:sendData.setPrdid forKey:@"setPrdid"];
    [post_dict setObject:sendData.testerId forKey:@"testerId"];
    [post_dict setObject:sendData.title forKey:@"title"];
    
    if([self docFileDelete]) {
        //image send
        NSString *path;
        path = [NSString stringWithFormat:@"%@/image.jpg",DOCS_DIR];
        UIImage *a = [[UIImage alloc]initWithContentsOfFile:path];
        [post_dict setObject:UIImageJPEGRepresentation(a, 0.75f) forKey:@"media"];
    }
    // Create the post data from the post dictionary
    
    //old
    NSData *postData = [self generateFormDataFromPostDictionary:post_dict];
    //사용하지 않는 메서드임
    
    // Establish the API request. Use upload vs uploadAndPost for skip tweet
    NSString *baseurl = GSSENDGOODSINFOURL;
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:MULTIPART forHTTPHeaderField: @"Content-Type"];
    [urlRequest setHTTPBody:postData];
    // Submit & retrieve results
    NSError *error;
    NSURLResponse *response;
    NSLog(@"Contacting Server....");
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(!result) {
        [self cleanup:[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]];
        return;
    }
    
    // Return results
    NSString *outstring = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    [self cleanup: outstring];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
}

@end
