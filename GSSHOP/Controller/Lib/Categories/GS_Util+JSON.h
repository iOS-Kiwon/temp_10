//
//  GS_Util+JSON.h
//  Mocha
//
//  Created by 임성남 on 2016. 2. 11..
//
//

#import <Foundation/Foundation.h>


@interface NSString (GS_JSON)
- (nullable id) JSONtoValue;
@end

@interface NSArray (GS_JSON)
- (nullable NSString *)JSONtoString;          // Arrary -> JSON string
@end


@interface NSDictionary (GS_JSON)
- (nullable NSString *)JSONtoString;          // NSDictionary -> JSON string
@end


@interface NSData (GS_JSON)
- (nullable NSString *)JSONtoString;          // NSData -> JSON String
- (nullable id) JSONtoValue;                  // JSON Data -> Object (NSArray or NSDictionary)
- (nullable NSString *)base16Encoding;       //Base16 Encode
@end

@interface NSString (swizzle)
- (nullable NSString *) swizzleStringByReplacingCharactersInRange:(NSRange) range withString:(NSString *_Nullable) strReplace;

+ (void) load;
@end





