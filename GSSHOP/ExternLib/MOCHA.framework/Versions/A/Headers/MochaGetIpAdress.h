//
//  MochaGetIpAdress.h
//  Mocha
//
//  Created by KIM HOECHEON on 2014. 8. 12..
//
//


#import <Foundation/Foundation.h>

@interface MochaGetIpAdress : NSObject


+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSDictionary *)getIPAddresses;
@end
