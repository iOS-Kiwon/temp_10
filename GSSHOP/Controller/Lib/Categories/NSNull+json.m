//
//  NSNull+json.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 10. 30..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "NSNull+json.h"

@implementation NSNull (json)

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    NSLog(@"found <null>");
    return 0;
}

-(id) valueForKey:(NSString *)key
{
    NSLog(@"found <null>");
    return nil;
}

-(id) valueForKeyPath:(NSString *)keyPath
{
    NSLog(@"found <null>");
    return nil;
}

- (NSUInteger)count
{
    NSLog(@"found <null>");
    return 0;
}

- (id)objectForKey:(id)aKey
{
    NSLog(@"found <null>");
    return nil;
}

- (NSEnumerator *)keyEnumerator
{
    NSLog(@"found <null>");
    return nil;
}

- (id)objectAtIndex:(NSUInteger)index
{
    NSLog(@"found <null>");
    return nil;
}

- (NSUInteger)length
{
    NSLog(@"found <null>");
    return 0;
}

- (char)charValue
{
    NSLog(@"found <null>");
    return 0;
}

- (unsigned char)unsignedCharValue
{
    NSLog(@"found <null>");
    return 0;
}

- (short)shortValue
{
    NSLog(@"found <null>");
    return 0;
}

- (unsigned short)unsignedShortValue
{
    NSLog(@"found <null>");
    return 0;
}
- (int)intValue;
{
    NSLog(@"found <null>");
    return 0;
}
- (unsigned int)unsignedIntValue
{
    NSLog(@"found <null>");
    return 0;
}
- (long)longValue;
{
    NSLog(@"found <null>");
    return 0;
}
- (unsigned long)unsignedLongValue
{
    NSLog(@"found <null>");
    return 0;
}
- (long long)longLongValue
{
    NSLog(@"found <null>");
    return 0;
}
- (unsigned long long)unsignedLongLongValue
{
    NSLog(@"found <null>");
    return 0;
}
- (float)floatValue
{
    NSLog(@"found <null>");
    return 0;
}
- (double)doubleValue
{
    NSLog(@"found <null>");
    return 0;
}
- (BOOL)boolValue
{
    NSLog(@"found <null>");
    return 0;
}
- (NSInteger)integerValue NS_AVAILABLE(10_5, 2_0)
{
    NSLog(@"found <null>");
    return 0;
}
- (NSUInteger)unsignedIntegerValue NS_AVAILABLE(10_5, 2_0)
{
    NSLog(@"found <null>");
    return 0;
}

- (NSString *)stringValue
{
    NSLog(@"found <null>");
    return 0;
}

- (NSComparisonResult)compare:(NSNumber *)otherNumber
{
    NSLog(@"found <null>");
    return 0;
}

- (BOOL)isEqualToNumber:(NSNumber *)number
{
    NSLog(@"found <null>");
    return 0;
}

- (NSString *)descriptionWithLocale:(id)locale
{
 //   NSLog(@"found <null>");
    return nil;
}


- (BOOL)isEqualToString:(NSString *)aString {
    return NO;
}

//아래 isEqual 사용 금지!! MPMoviePlayer 영향있음.
/*
- (BOOL)isEqual:(id)object {
    return NO;
}
*/
- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet{
      NSRange ndd = NSMakeRange( 0,  0);
    return ndd;
}
- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    return @"";
}
@end