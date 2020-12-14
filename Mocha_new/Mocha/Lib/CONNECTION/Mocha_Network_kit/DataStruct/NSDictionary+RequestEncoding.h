//
//  NSDictionary+RequestEncoding.h
//

/**
 * @brief NSDictionary RequestEncoding
 * NSDictionary 자료형의 REST통신용 request 전문 생성 인코딩 관련 category.
 */
@interface NSDictionary (RequestEncoding)


/**
 *  NSDictionary self객체를 Key=Value 형태의 GET URL형태의 key&value str 문장 생성 반환
 *
 *   @return NSString
 *
 */
-(NSString*) urlEncodedKeyValueString;

/**
 *  NSDictionary self객체를 Key:Value 형태의 JSON request 형태의  str 문장 생성 반환
 *
 *   @return NSString
 *
 */
-(NSString*) jsonEncodedKeyValueString;

/**
 *  NSDictionary self객체를 <Key=Velue> XML 형태의 request str 문장 생성 반환
 *
 *   @return NSString
 *
 */
-(NSString*) plistEncodedKeyValueString;

@end
