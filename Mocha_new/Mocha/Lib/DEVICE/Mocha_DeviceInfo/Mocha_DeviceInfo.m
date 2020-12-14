//
//  Mocha_DeviceInfo.m
//  Mocha
//
//  Created by Hoecheon Kim on 12. 6. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "Mocha_DeviceInfo.h"
#include <sys/sysctl.h>
 

 

@implementation Mocha_DeviceInfo





+ (NSString *) platform {
    return  [[UIDevice currentDevice] platform];
    
}
+ (NSString *) hwmodel {
     return  [[UIDevice currentDevice] hwmodel];
}
+ (NSUInteger) platformType {
    return  [[UIDevice currentDevice] platformType];
}
+ (NSString *) platformString {
     return  [[UIDevice currentDevice] hwmodel];
}



+ (NSUInteger) cpuFrequency {
    return  [[UIDevice currentDevice] cpuFrequency];
}
+ (NSUInteger) busFrequency {
     return  [[UIDevice currentDevice] busFrequency];
}
+ (NSUInteger) totalMemory{
     return  [[UIDevice currentDevice] totalMemory];
}
+ (NSUInteger) userMemory{
     return  [[UIDevice currentDevice] userMemory];
}

+ (NSNumber *) totalDiskSpace{
     return  [[UIDevice currentDevice] totalDiskSpace];
}
+ (NSNumber *) freeDiskSpace{
     return  [[UIDevice currentDevice] freeDiskSpace];
}
+ (NSString *) macaddress{
     return  [[UIDevice currentDevice] macaddress];
    
}

//국가정보
+ (NSString *)getLocationinfo {
    
    NSLocale *locale =[NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    return  countryCode;
}

//언어정보
+ (NSString *)getLocaleinfo {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
    
}

//OS버전
+ (float) getiosversion {

 return [[[UIDevice currentDevice] systemVersion] floatValue];
 
}
 


 
// 멀티태스킹 가능 여부 확인하기]
- (BOOL)isMultitaskingOS
{
    BOOL bgSupport = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])  
        bgSupport=[UIDevice currentDevice].multitaskingSupported;
    
    return bgSupport;
}

// 애플리케이션의 실행 상태 확인하기]
- (BOOL)isForeground
{
    if (![self isMultitaskingOS])
        return YES;
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    //return (state == UIApplicationStateActive || state == UIApplicationStateInactive);
    return (state == UIApplicationStateActive);
}
 



//20140327 수정

+ (NSString *)getPlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
 
    
    if ([sDeviceModel isEqual:@"iPhone1,1"]) return @"iPhone1G";
    if ([sDeviceModel isEqual:@"iPhone1,2"]) return @"iPhone3G";
    if ([sDeviceModel isEqual:@"iPhone2,1"]) return @"iPhone3GS";
    if ([sDeviceModel isEqual:@"iPhone3,1"]) return @"iPhone4";
    if ([sDeviceModel isEqual:@"iPhone3,2"]) return @"iPhone4";
    if ([sDeviceModel isEqual:@"iPhone3,3"]) return @"iPhone4";
    if ([sDeviceModel isEqual:@"iPhone4,1"]) return @"iPhone4S";
    if ([sDeviceModel isEqual:@"iPhone5,1"]) return @"iPhone5"; //(GSM)
    if ([sDeviceModel isEqual:@"iPhone5,2"]) return @"iPhone5"; // (GSM+CDMA)
    if ([sDeviceModel isEqual:@"iPhone5,3"]) return @"iPhone5c"; //(GSM)
    if ([sDeviceModel isEqual:@"iPhone5,4"]) return @"iPhone5c"; // (GSM+CDMA)
    if ([sDeviceModel isEqual:@"iPhone6,1"]) return @"iPhone5s"; //(GSM)
    if ([sDeviceModel isEqual:@"iPhone6,2"]) return @"iPhone5s"; // (GSM+CDMA)
    if ([sDeviceModel isEqual:@"iPhone7,1"]) return @"iphone6Plus";
    if ([sDeviceModel isEqual:@"iPhone7,2"]) return @"iphone6";
    
    
    if ([sDeviceModel isEqual:@"iPod1,1"])  return @"iPod1G";
    if ([sDeviceModel isEqual:@"iPod2,1"])  return @"iPod2G";
    if ([sDeviceModel isEqual:@"iPod3,1"])  return @"iPod3G";
    if ([sDeviceModel isEqual:@"iPod4,1"])  return @"iPod4G";
    if ([sDeviceModel isEqual:@"iPod5,1"])  return @"iPod5G";
    
    if ([sDeviceModel isEqual:@"iPad1,1"])  return @"iPad";
    if ([sDeviceModel isEqual:@"iPad2,1"])  return @"iPad2"; //(WiFi)
    if ([sDeviceModel isEqual:@"iPad2,2"])  return @"iPad2"; //(GSM)
    if ([sDeviceModel isEqual:@"iPad2,3"])  return @"iPad2"; //(CDMA)
    if ([sDeviceModel isEqual:@"iPad2,4"])  return @"iPad2"; //(WiFi)
    if ([sDeviceModel isEqual:@"iPad2,5"])  return @"iPadMini"; //(WiFi)
    if ([sDeviceModel isEqual:@"iPad2,6"])  return @"iPadMini"; //(GSM)
    if ([sDeviceModel isEqual:@"iPad2,7"])  return @"iPadMini"; //(GSM+CDMA)
    if ([sDeviceModel isEqual:@"iPad3,1"])  return @"iPad3"; //(WiFi)
    if ([sDeviceModel isEqual:@"iPad3,2"])  return @"iPad3"; // (GSM+CDMA)
    if ([sDeviceModel isEqual:@"iPad3,3"])  return @"iPad3"; //(GSM)
    if ([sDeviceModel isEqual:@"iPad3,4"])  return @"iPad4"; //(WiFi)
    if ([sDeviceModel isEqual:@"iPad3,5"])  return @"iPad4"; //(GSM)
    if ([sDeviceModel isEqual:@"iPad3,6"])  return @"iPad4"; //(WiFi)
    if ([sDeviceModel isEqual:@"iPad4,1"])  return @"iPadAir"; //(WiFi)
    if ([sDeviceModel isEqual:@"iPad4,2"])  return @"iPadAir"; //(Cellular)
    
    if ([sDeviceModel isEqual:@"iPad4,4"])  return @"iPadmini2G"; //(WiFi)
    if ([sDeviceModel isEqual:@"iPad4,5"])  return @"iPadmini2G"; // (Cellular)
    
    if ([sDeviceModel isEqual:@"iPad4,7"])  return @"iPadmini3G"; // (WiFi)
    if ([sDeviceModel isEqual:@"iPad4,8"])  return @"iPadmini3G"; // (Cellular)
    if ([sDeviceModel isEqual:@"iPad4,9"])  return @"iPadmini3G"; // (Cellular)
    
    
    if ([sDeviceModel isEqual:@"iPad5,3"])  return @"iPadAir2"; //(WiFi)
    if ([sDeviceModel isEqual:@"iPad5,4"])  return @"iPadAir2"; //(Cellular)
    
    if ([sDeviceModel isEqual:@"i386"])   return @"Simulator";
    if ([sDeviceModel isEqual:@"x86_64"])  return @"Simulator";
    
    NSLog(@"모델 FUULL NAME: %@", sDeviceModel);
    
    NSString *aux = [[sDeviceModel componentsSeparatedByString:@","] objectAtIndex:0];
    
    //If a newer version exist
    if ([aux rangeOfString:@"iPhone"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] intValue];
        if (version == 3) return @"iPhone4";
        if (version == 4) return @"iPhone4s";
        if (version == 5) return @"iPhone5";
        if (version == 6) return @"iPhone5s";
        if (version > 6) return @"iPhone6";
        
    }
    if ([aux rangeOfString:@"iPod"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPod" withString:@""] intValue];
        if (version > 5) return @"iPod6G";
    }
    if ([aux rangeOfString:@"iPad"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPad" withString:@""] intValue];
        if (version > 5) return @"iPadAir3";
    }
    //If none was found, send the original string
    return sDeviceModel;
}

/*
+ (NSString *)getPlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);                              
    if ([sDeviceModel isEqual:@"i386"])      return @"Simulator";  //iPhone Simulator
    if ([sDeviceModel isEqual:@"iPhone1,1"]) return @"iPhone1G";   //iPhone 1G
    if ([sDeviceModel isEqual:@"iPhone1,2"]) return @"iPhone3G";   //iPhone 3G
    if ([sDeviceModel isEqual:@"iPhone2,1"]) return @"iPhone3GS";  //iPhone 3GS
    if ([sDeviceModel isEqual:@"iPhone3,1"]) return @"iPhone4";  //iPhone 4 - AT&T
    if ([sDeviceModel isEqual:@"iPhone3,2"]) return @"iPhone4";  //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone3,3"]) return @"iPhone4";    //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone4,1"]) return @"iPhone4S";   //iPhone 4S
    if ([sDeviceModel isEqual:@"iPod1,1"])   return @"iPod1stGen"; //iPod Touch 1G
    if ([sDeviceModel isEqual:@"iPod2,1"])   return @"iPod2ndGen"; //iPod Touch 2G
    if ([sDeviceModel isEqual:@"iPod3,1"])   return @"iPod3rdGen"; //iPod Touch 3G
    if ([sDeviceModel isEqual:@"iPod4,1"])   return @"iPod4thGen"; //iPod Touch 4G
    if ([sDeviceModel isEqual:@"iPad1,1"])   return @"iPadWiFi";   //iPad Wifi
    if ([sDeviceModel isEqual:@"iPad1,2"])   return @"iPad3G";     //iPad 3G
    if ([sDeviceModel isEqual:@"iPad2,1"])   return @"iPad2";      //iPad 2 (WiFi)
    if ([sDeviceModel isEqual:@"iPad2,2"])   return @"iPad2";      //iPad 2 (GSM)
    if ([sDeviceModel isEqual:@"iPad2,3"])   return @"iPad2";      //iPad 2 (CDMA)
    NSLog(@"모델 FUULL NAME: %@", sDeviceModel);
    
    NSString *aux = [[sDeviceModel componentsSeparatedByString:@","] objectAtIndex:0];
    
    //If a newer version exist
    if ([aux rangeOfString:@"iPhone"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] intValue];
        if (version == 3) return @"iPhone4";
        if (version >= 4) return @"iPhone4s";
        
    }
    if ([aux rangeOfString:@"iPod"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPod" withString:@""] intValue];
        if (version >=4) return @"iPod4thGen";
    }
    if ([aux rangeOfString:@"iPad"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPad" withString:@""] intValue];
        if (version ==1) return @"iPad3G";
        if (version >=2) return @"iPad2";
    }
    //If none was found, send the original string
    return sDeviceModel;
}
*/
 
@end
