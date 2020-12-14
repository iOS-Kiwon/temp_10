//
//  NSDate+NSDate_Seoul.m
//  GSSHOP
//
//  Created by nami0342 on 2016. 10. 6..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "NSDate+Seoul.h"

@implementation NSDate (NSDate_Seoul)

+(NSDate *) getSeoulDateTime
{
    NSDate *curDate = [NSDate date];
    NSDateFormatter *dfTime = [[NSDateFormatter alloc] init];
    [dfTime setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
    [dfTime setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strSeoulTime = [dfTime stringFromDate:curDate];
    
    NSDateFormatter *dfSeoul = [[NSDateFormatter alloc] init];
    [dfSeoul setDateFormat:@"yyyyMMddHHmmss"];
    [dfSeoul setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    
    
    NSDate *dtSeoul = [dfSeoul dateFromString:strSeoulTime];
    return dtSeoul;
}


+(NSDate *) getDateWithTimeZoneName : (NSString *) strName
{
    NSDate *curDate = [NSDate date];
    NSDateFormatter *dfTime = [[NSDateFormatter alloc] init];
    [dfTime setTimeZone:[NSTimeZone timeZoneWithName:strName]];
    [dfTime setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strSeoulTime = [dfTime stringFromDate:curDate];
    return [dfTime dateFromString:strSeoulTime];
}


@end
