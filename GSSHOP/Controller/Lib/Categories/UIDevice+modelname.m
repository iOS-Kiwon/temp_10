//
//  UIDevice+modelname.m
//  GSSHOP
//
//  Created by nami0342 on 2020/06/11.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

#import "UIDevice+modelname.h"
#include <sys/sysctl.h>

@implementation UIDevice(modelname)


- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}



// nami0342 -
- (NSString *) deviceModelName
{
    NSString *platform = [self getSysInfoByName:"hw.machine"];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])    return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max Global";
    if ([platform isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"])    return @"iPhone SE 2nd Gen";
    
//    if ([platform isEqualToString:@""])    return @"";
    
  
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch (6 Gen)";   // 아마도
    if ([platform isEqualToString:@"iPod9,1"])      return @"iPod Touch (7 Gen)";
//    if ([platform isEqualToString:@""])    return @"";
    
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    
    if ([platform isEqualToString:@"iPad6,11"])    return @"iPad (2017)";
    if ([platform isEqualToString:@"iPad6,12"])    return @"iPad (2017)";
    if ([platform isEqualToString:@"iPad7,1"])    return @"iPad Pro 2nd Gen (WiFi)";
    if ([platform isEqualToString:@"iPad7,2"])    return @"iPad Pro 2nd Gen (WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad7,3"])    return @"iPad Pro 10.5-inch";
    if ([platform isEqualToString:@"iPad7,4"])    return @"iPad Pro 10.5-inch";
    if ([platform isEqualToString:@"iPad7,5"])    return @"iPad 6th Gen (WiFi)";
    if ([platform isEqualToString:@"iPad7,6"])    return @"iPad 6th Gen (WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad7,11"])    return @"iPad 7th Gen 10.2-inch (WiFi)";
    if ([platform isEqualToString:@"iPad7,12"])    return @"iPad 7th Gen 10.2-inch (WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad8,1"])    return @"iPad Pro 11 inch (WiFi)";
    if ([platform isEqualToString:@"iPad8,2"])    return @"iPad Pro 11 inch (1TB, WiFi)";
    if ([platform isEqualToString:@"iPad8,3"])    return @"iPad Pro 11 inch (WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad8,4"])    return @"iPad Pro 11 inch (1TB, WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad8,5"])    return @"iPad Pro 12.9 inch 3rd Gen (WiFi)";
    if ([platform isEqualToString:@"iPad8,6"])    return @"iPad Pro 12.9 inch 3rd Gen (1TB, WiFi)";
    if ([platform isEqualToString:@"iPad8,7"])    return @"iPad Pro 12.9 inch 3rd Gen (WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad8,8"])    return @"iPad Pro 12.9 inch 3rd Gen (1TB, WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad8,9"])    return @"iPad Pro 11 inch 2nd Gen (WiFi)";
    if ([platform isEqualToString:@"iPad8,10"])    return @"iPad Pro 11 inch 2nd Gen (WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad8,11"])    return @"iPad Pro 12.9 inch 4th Gen (WiFi)";
    if ([platform isEqualToString:@"iPad8,12"])    return @"iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)";
    if ([platform isEqualToString:@"iPad11,1"])    return @"iPad mini 5th Gen (WiFi)";
    if ([platform isEqualToString:@"iPad11,2"])    return @"iPad mini 5th Gen";
    if ([platform isEqualToString:@"iPad11,3"])    return @"iPad Air 3rd Gen (WiFi)";
    if ([platform isEqualToString:@"iPad11,4"])    return @"iPad Air 3rd Gen";
//    if ([platform isEqualToString:@""])    return @"";
     
    
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return @"unknown iphone";
}
@end
