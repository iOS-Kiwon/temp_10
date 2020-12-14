#import "AppPushSecureDataUtil.h"
#import "AT_Seed.h"
#import "AT_Base64.h"
//#import "AT_NSData+Zip.h"
#import "AppPushZip.h"
#import "AppPushUtil.h"
#import "AmailPopUpView.h"
#define ENCRYPTION_ENABLE       1
#define SECRET_KEY                          @"Pg-s_E_n_C_k_e_y"
@implementation AppPushSecureDataUtil
+ (NSString *)enCipherStr:(NSString *)argStr
                      key:(NSString *)argKey
            withUrlEncode:(BOOL)argIsEncode {
    @try {
        
        
        argKey = argKey==nil ? SECRET_KEY : argKey;
        //NSLog(@"argKey : %@",argKey);
        
        NSString *resultStr;
#ifdef ENCRYPTION_ENABLE
        NSData *jsonData = [argStr dataUsingEncoding:NSUTF8StringEncoding];
        NSData *gzippedData = [AppPushZip AT_gzipDeflate:jsonData];
        
        NSData *encryptedData = [AT_Seed encryptForBabpi:gzippedData
                                                 userKey:argKey==nil ? SECRET_KEY : argKey];
        resultStr = [AT_Base64 encode:encryptedData];
#else
        NSData *jsonData = [argStr dataUsingEncoding:NSUTF8StringEncoding];
        resultStr = [AT_Base64 encode:jsonData];
#endif
        if(argIsEncode) {
            resultStr = [self urlEncodeString:resultStr];
        }
        return resultStr;
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushSecureDataUtil enCipherStr : %@", exception);
        return nil;
    }
}

+ (NSString *)deCipherParameter:(NSData *)argResponseData key:(NSString *)argKey islog:(BOOL)argIsLog {
    @try {
#ifdef ENCRYPTION_ENABLE
        if(argResponseData==nil) {
            NSLog(@"PMS N Decipher argResponseData error");
            //[AmailPopUpView openCustomPopViewWithString:@"PGS Decipher argResponseData error"];
            return nil;
        }
        NSString *responseString = [[[NSString alloc] initWithData:argResponseData encoding:NSASCIIStringEncoding]
                                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"PMS Decipher Response str: %@",responseString);
        if(responseString==nil) { 
            NSLog(@"PMS N Decipher init string error");
            //[AmailPopUpView openCustomPopViewWithString:@"PGS Decipher init string error"];
            return nil;
        } else if(argIsLog){
            //NSLog(@"PMS N DecipherParameter : %@",responseString);
        }
        responseString = [self urlDecodeString:responseString];
        
        if([responseString isEqualToString:@"105"] ||
           [responseString isEqualToString:@"\"code\":\"105\""] ||
           [responseString rangeOfString:@"\"code\":\"105\""].location != NSNotFound) {
            return @"105";
        }
        
        if([responseString hasPrefix:@"{"]){
            return responseString;
        }
        
        if(responseString==nil) {
            NSLog(@"PMS N Decipher urlDecode error");
            //[AmailPopUpView openCustomPopViewWithString:[NSString stringWithFormat:@"PGS Decipher urlDecode error : %@",responseString]];
            return nil;
        }
        const char *temp_str= [responseString cStringUsingEncoding:0x80000422];
        if(temp_str==nil) {
            NSLog(@"PMS N Decipher charEncoding error");
            //[AmailPopUpView openCustomPopViewWithString:[NSString stringWithFormat:@"PGS Decipher charEncoding error : %@",responseString]];
            return nil;
        }
        NSData *unBase64Data = [AT_Base64 decode:temp_str length:responseString.length];//[AT_Base64 decode:responseString];
        if(unBase64Data==nil) {
            NSLog(@"PMS N Decipher base64 error");
            //[AmailPopUpView openCustomPopViewWithString:[NSString stringWithFormat:@"PGS Decipher base64 error : %@",responseString]];
            return nil;
        }
        NSData *decryptedData = [AT_Seed decryptForBabpi:unBase64Data userKey:argKey==nil ? SECRET_KEY : argKey];
        if(decryptedData==nil) {
            NSLog(@"PMS N Decipher decrypt error");
            //[AmailPopUpView openCustomPopViewWithString:[NSString stringWithFormat:@"PGS Decipher decrypt error : %@",responseString]];
            return nil;
        }
        NSData *uncompressedData = [AppPushZip AT_gzipInflate:decryptedData];
        if(uncompressedData==nil) {
            NSLog(@"PMS N Decipher gzip error");
            //[AmailPopUpView openCustomPopViewWithString:[NSString stringWithFormat:@"PGS Decipher gzip error : %@",responseString]];
            return nil;
        }
        NSString *strResult = [[NSString alloc] initWithData:uncompressedData encoding:NSUTF8StringEncoding];
        if(strResult==nil) {
            NSLog(@"PMS N Decipher result string error");
            //[AmailPopUpView openCustomPopViewWithString:[NSString stringWithFormat:@"PGS Decipher result string error : %@",responseString]];
            return nil;
        }
        return strResult;
#else
        return [[NSString alloc] initWithData:argResponseData encoding:NSUTF8StringEncoding];
#endif
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushSecureDataUtil deCipherParameter : %@", exception);
        return nil;
    }
}
+ (NSString *)urlEncodeString:(NSString *)argStr
{
    @try {
        
        //NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
        //                                                                                          (CFStringRef)argStr,
        //                                                                                          NULL,
        //                                                                                          CFSTR(":/?#[]@!$&’()*+,;="),
        //                                                                                          kCFStringEncodingUTF8));
        
        NSMutableCharacterSet *charset = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [charset removeCharactersInString:@":/?#[]@!$&’()*+,;="];
        NSString *result = [argStr stringByAddingPercentEncodingWithAllowedCharacters:charset];
        
        return result;
    }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushSecureDataUtil urlEncodeString : %@", exception);
        return nil;
    }
}
+ (NSString *)urlDecodeString:(NSString *)argStr
{
    @try {
         NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault,
                                                                                               (CFStringRef)argStr,
                                                                                               CFSTR("")
                                                                                               ));
         return result;
     }@catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushSecureDataUtil urlDecodeString : %@", exception);
        return nil;
    }
}
@end
