//
//  NSString+MKNetworkKitAdditions.h
//

/**
 * @brief NSString network category
 * NSString  network 관련 encoding,decoding 및 관련 category정리.
 */
@interface NSString (Mocha)


/**
 *  NSString self객체를 MD5 인코딩 변환 후 반환
 *
 *   @return NSString
 *
 */
- (NSString *) md5;



/**
 *  CFUUIDCreateString 을 활용한 unique한 문자열 생성 후 반환.
 *
 *   @return NSString
 *
 */
+ (NSString*) uniqueString;


/**
 *  NSString self객체를 URLEncoding 변환 후 반환
 *
 *   @return NSString
 *
 */
- (NSString*) urlEncodedString;


/**
 *  NSString self객체를 URLDecoding 변환 후 반환
 *
 *   @return NSString
 *
 */
- (NSString*) urlDecodedString;


/**
 *  CGSize sizeWithFont CGSize 반환 - iOS6이상대응
 *
 *   @return NSString
 *
 */

- (CGSize)MochaSizeWithFont:(UIFont *)font
       constrainedToSize:(CGSize)size
           lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end
