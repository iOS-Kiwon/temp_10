#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <Security/Security.h>


/**
 * @brief GSCryptoHelper
 * 데이터를 암호화 및 복호화함. 단방향 암호화, 양방향 암복호화 지원.
 * AES128, AES256, Hex인/디코딩, MD5,SHA1인코딩포함.
 */
@interface GSCryptoHelper : NSObject
{
	NSData *symmetricKey;
    SecKeyRef publicKey;
}

+ (GSCryptoHelper *)sharedInstance;


//AES128 지원은 하되 사용하지 않음. deprecated
- (NSString*)encryptString:(NSString*)string; //post용 암호화
- (NSString*)encryptString_Local:(NSString*)string;	//로컬용 암호화 : post용과의 차이는 Base64인코딩 여부로 post시에는 base64인코딩을 하지 않는다.
- (NSString*)decryptString:(NSString*)string; //복호화
//-(unsigned int)stringToHex:(NSString *)str;


//AES256

/**
 *  입력받은 string을 AES256 암호화 return
 *
 *   @param string 암호화 대상 string (NSString)
 *   @return NSString
 *
 */
- (NSString*)encrypt256String:(NSString*)string; //post용 암호화

/**
 *  입력받은 string을 AES256 복호화 return
 *
 *   @param string 복호화 대상 string (NSString)
 *   @return NSString
 *
 */
- (NSString*)decrypt256String:(NSString*)string; //복호화

/**
 *  입력받은 string을 Base64 인코딩 후 return
 *
 *   @param string Base64인코딩 대상 string (NSString)
 *   @return NSData
 *
 */
- (NSData*) dataWithBase64EncodedString:(NSString *) string;



//Hex인코딩

/**
 *  입력받은 data를 hex 인코딩 후 return
 *
 *   @param data hex 인코딩 대상 string (NSData)
 *   @return NSString
 *
 */
-(NSString *) hexEncode:(NSData*)data;

/**
 *  입력받은 data를 hex 디코딩 후 return
 *
 *   @param string hex 디코딩 대상 string (NSString)
 *   @return NSData
 *
 */
- (NSData*) hexDecode : (NSString *)hexString;

//Md5 SHA1

/**
 *  입력받은 data를 md5 인코딩 후 return
 *
 *   @param input md5인코딩 대상 string (NSString)
 *   @return NSString
 *
 */
- (NSString *) md5:(NSString *) input;

/**
 *  입력받은 data를 sha1 인코딩 후 return
 *
 *   @param input sha1인코딩 대상 string (NSString)
 *   @return NSString
 *
 */
-(NSString*) sha1:(NSString*)input;


-(NSString*) sha256:(NSString*)input;

-(NSString*) sha256Base64Withsalt:(NSString*)salt   param:(NSString*)parameters;

/**
 *  입력받은 base64Encoding publickey str기반으로 RSA 인코딩 data return
 *
 *   @param string RSA encoding 대상 string (NSString) //java public key object
 *   @param publicKeystr publicKey string (NSString)
 *   @return NSData
 *
 */
- (NSData*) rsaEncryptString:(NSString*)string  withpublicKey:(NSString*) publicKeystr;
@end


