//
//  NSData+Base64.h
//  base64
//
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
	const char *inputBuffer,
	size_t length,
	size_t *outputLength);

char *NewBase64Encode(
	const void *inputBuffer,
	size_t length,
	bool separateLines,
	size_t *outputLength);

/**
 * @brief NSdata bas64 Encoding
 * NSData 자료형의 base64 인코딩 관련 category.
 */
@interface NSData (Base64)

/**
 *  aString str인수를 Base64인코딩된 NSData 자료형 반환  
 *
 *   @param aString Base64인코딩 NSData로 반환할 원시 str  (NSString)
 *   @return NSData
 *
 */
+ (NSData *)dataFromBase64String:(NSString *)aString;
/**
 *  [NSData객체 base64EncodeString]형태로사용. self(NSData)객체에서 NSString 자료형의 instance 객체 자료형 반환.
 *
 *   @return NSData
 *
 */
- (NSString *)base64EncodedString;

@end
