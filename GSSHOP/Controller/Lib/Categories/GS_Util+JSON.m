//
//  GS_Util+JSON.m
//  Mocha
//
//  Created by 임성남 on 2016. 2. 11..
//
//

#import "GS_Util+JSON.h"



@implementation NSString (GS_JSON)
- (nullable id) JSONtoValue
{
    NSData *data;
    
    if([self canBeConvertedToEncoding:NSUTF8StringEncoding] == YES)
    {
        data = [self dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if([self canBeConvertedToEncoding:NSUTF16StringEncoding] == YES)
    {
        data = [self dataUsingEncoding:NSUTF16StringEncoding];
    }
    
    
    NSError *error;
    id idReturn = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    return idReturn;
}
@end



@implementation NSArray (GS_JSON)
// Arrary -> JSON string
- (nullable NSString *)JSONtoString
{
    if (!self || ![NSJSONSerialization isValidJSONObject:self])
        return nil;
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self  options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strReturn = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return strReturn;
}
@end



@implementation NSDictionary (GS_JSON)
// NSDictionary -> JSON string
- (nullable NSString *)JSONtoString
{
    if (!self || ![NSJSONSerialization isValidJSONObject:self])
        return nil;
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self  options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strReturn = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return strReturn;
}
@end



@implementation NSData (GS_JSON)
// NSData -> JSON String
- (nullable NSString *)JSONtoString
{
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self  options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strReturn = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return strReturn;
}


// JSON Data -> Object (NSArray or NSDictionary)
- (nullable id) JSONtoValue
{
    NSError *error;
    id idReturn = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
   
    return idReturn;
}

- (NSString *)base16Encoding
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */

    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];

    if (!dataBuffer)
    {
        return [NSString string];
    }

    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];

    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }

    return [NSString stringWithString:hexString];
}
@end



// nami0342 - Swizzle nsstring
@implementation NSString (swizzle)

// nami0342 - 방어로직 포함된 swizzle
- (nullable NSString *) swizzleStringByReplacingCharactersInRange:(NSRange) range withString:(NSString *_Nullable) strReplace
{
    NSString *strReturn;
    
    if(strReplace == nil)
    {
        strReturn = self;
    }
    else
    {
        strReturn = [self swizzleStringByReplacingCharactersInRange:range withString:strReplace];
        NSLog(@"11111 - %@", strReturn);
    }
    
    return strReturn;
}


// nami0342 - NSString class에서 method instance를 교체
+ (void) load
{
    
    // nami0342 - swizzle
   if (@available(iOS 13.1, *))
   {
        static dispatch_once_t once_token;
        
        dispatch_once(&once_token, ^{
            Method swizzleMethod = class_getInstanceMethod([self class], @selector(swizzleStringByReplacingCharactersInRange:withString:));
            
            Method originalMethod = class_getInstanceMethod([self class], @selector(stringByReplacingCharactersInRange:withString:));
            
            if(class_addMethod([self class], @selector(swizzleStringByReplacingCharactersInRange:withString:), method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod)))
            {
                
                SEL originalSelector = @selector(stringByReplacingCharactersInRange:withString:);
                
                class_replaceMethod([self class], originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
            }
            else
            {
                method_exchangeImplementations(originalMethod, swizzleMethod);
            }
        });
   }
    
}

@end

