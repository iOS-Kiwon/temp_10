#import "GSCryptoHelper.h"
#import "NSData+Base64.h"

#define LOGGING_FACILITY(X, Y)	\
if(!(X)) {			\
NSLog(Y);		\
}

#define LOGGING_FACILITY1(X, Y, Z)	\
if(!(X)) {				\
NSLog(Y, Z);		\
}

@interface GSCryptoHelper(Private)
- (NSData *)doCipher:(NSData *)plainText key:(NSData *)theSymmetricKey context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7;
- (NSString *)base64EncodeData:(NSData*)dataToConvert;
- (NSData*)base64DecodeString:(NSString *)string;

//AES256
- (NSData *)AES256EncryptWithKey:(NSData *)key;
- (NSData *)AES256DecryptWithKey:(NSData *)key;
@end


@implementation GSCryptoHelper

static GSCryptoHelper *MyCryptoHelper = nil;
//AES128Key
const uint8_t kKeyBytes[] = "GS_HomeS_ENCRYPT"; // Must be 16 bytes - 123456789abcdef
//AES256Key
const NSString *key256 = @"GS_HomeS_ENCRYPT";

static CCOptions pad = 0;

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSString*)encryptString:(NSString*)string
{
	NSData *plainText = [string dataUsingEncoding:NSUTF8StringEncoding];
	
	NSData *encryptedResponse = [self doCipher:plainText key:symmetricKey context:kCCEncrypt padding:&pad];
	
	NSString *turn = [NSString stringWithFormat:@"%@",encryptedResponse];
	turn = [turn stringByReplacingOccurrencesOfString:@"<" withString:@""];
	turn = [turn stringByReplacingOccurrencesOfString:@">" withString:@""];
	turn = [turn stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	return turn;
}
- (NSString*)encryptString_Local:(NSString*)string
{
	NSData *plainText = [string dataUsingEncoding:-2147481280];
	NSData *encryptedResponse = [self doCipher:plainText key:symmetricKey context:kCCEncrypt padding:&pad];
    NSString* ttt= [self hexEncode:encryptedResponse];
	NSData *plainddd = [ttt dataUsingEncoding:-2147481280];
	return [self base64EncodeData:plainddd];
}




- (NSString*)decryptString:(NSString*)string
{
    
    NSData *debasestr= [self base64DecodeString:string];
    NSString *tmpdebasestr = [[NSString alloc] initWithData:debasestr encoding:NSUTF8StringEncoding];
    NSData *dehexdestr = [self hexDecode:tmpdebasestr];
    NSData *decryptedResponse = [self doCipher:dehexdestr key:symmetricKey context:kCCDecrypt padding:&pad];
    return [NSString stringWithCString:[decryptedResponse bytes] encoding:-2147481280];
}
#pragma mark -
#pragma mark Base64 Encode/Decoder
- (NSString *)base64EncodeData:(NSData*)dataToConvert
{
	if ([dataToConvert length] == 0)
		return @"";
	
    char *characters = malloc((([dataToConvert length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [dataToConvert length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [dataToConvert length])
			buffer[bufferLength++] = ((char *)[dataToConvert bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';
	}
	
	return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

- (NSData*)base64DecodeString:(NSString *)string
{
	if (string == nil)
    //[NSException raise:NSInvalidArgumentException format:nil];
    [NSException raise:NSInvalidArgumentException format: (@"string should be non-null ")];
	if ([string length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
	{
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
	}
	
	const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
		return nil;
	char *bytes = malloc((([string length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (YES)
	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
		{
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
			{
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
		{
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	realloc(bytes, length);
	
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSData *)doCipher:(NSData *)plainText key:(NSData *)theSymmetricKey context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7
{
	CCCryptorStatus ccStatus = kCCSuccess;
	// Symmetric crypto reference.
	CCCryptorRef thisEncipher = NULL;
	// Cipher Text container.
	NSData * cipherOrPlainText = nil;
	// Pointer to output buffer.
	uint8_t * bufferPtr = NULL;
	// Total size of the buffer.
	size_t bufferPtrSize = 0;
	// Remaining bytes to be performed on.
	size_t remainingBytes = 0;
	// Number of bytes moved to buffer.
	size_t movedBytes = 0;
	// Length of plainText buffer.
	size_t plainTextBufferSize = 0;
	// Placeholder for total written.
	size_t totalBytesWritten = 0;
	// A friendly helper pointer.
	uint8_t * ptr;
	
	// Initialization vector; dummy in this case 0's.
	uint8_t iv[kCCBlockSizeAES128];
	memset((void *) iv, 0x0, (size_t) sizeof(iv));
	
	LOGGING_FACILITY(plainText != nil, @"PlainText object cannot be nil." );
	LOGGING_FACILITY(theSymmetricKey != nil, @"Symmetric key object cannot be nil." );
	//LOGGING_FACILITY(pkcs7 != NULL, @"CCOptions * pkcs7 cannot be NULL." );
	//LOGGING_FACILITY([theSymmetricKey length] == kCCKeySizeAES128, @"Disjoint choices for key size." );
	
	plainTextBufferSize = [plainText length];
	
	LOGGING_FACILITY(plainTextBufferSize > 0, @"Empty plaintext passed in." );
	
	// We don't want to toss padding on if we don't need to
	if(encryptOrDecrypt == kCCEncrypt)
	{
		
		if(*pkcs7 != kCCOptionECBMode)
		{
			if((plainTextBufferSize % kCCBlockSizeAES128) == 0)
			{
				*pkcs7 = 0x0000;
			}
			else
			{
				*pkcs7 = kCCOptionPKCS7Padding;
			}
		}
	}
	else if(encryptOrDecrypt != kCCDecrypt)
	{
		LOGGING_FACILITY1( 0, @"Invalid CCOperation parameter [%d] for cipher context.", *pkcs7 );
	}
	
	// Create and Initialize the crypto reference.
	ccStatus = CCCryptorCreate(	encryptOrDecrypt,
							   kCCAlgorithmAES128,
							   kCCOptionPKCS7Padding | kCCOptionECBMode,
							   (const void *)[theSymmetricKey bytes],
							   kCCKeySizeAES128,
							   (const void *)iv,
							   &thisEncipher
							   );
	
	LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem creating the context, ccStatus == %d.", ccStatus );
	
	// Calculate byte block alignment for all calls through to and including final.
	bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
	
	// Allocate buffer.
	bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
	
	// Zero out buffer.
	memset((void *)bufferPtr, 0x0, bufferPtrSize);
	
	// Initialize some necessary book keeping.
	
	ptr = bufferPtr;
	
	// Set up initial size.
	remainingBytes = bufferPtrSize;
	
	// Actually perform the encryption or decryption.
	ccStatus = CCCryptorUpdate( thisEncipher,
							   (const void *) [plainText bytes],
							   plainTextBufferSize,
							   ptr,
							   remainingBytes,
							   &movedBytes
							   );
	
	LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem with CCCryptorUpdate, ccStatus == %d.", ccStatus );
	totalBytesWritten += movedBytes;
    /*
     // Handle book keeping.
     ptr += movedBytes;
     remainingBytes -= movedBytes;
     
     
     // Finalize everything to the output buffer.
     ccStatus = CCCryptorFinal(	thisEncipher,
     ptr,
     remainingBytes,
     &movedBytes
     );
     */
	
	totalBytesWritten += movedBytes;
	
	if(thisEncipher)
	{
		(void) CCCryptorRelease(thisEncipher);
		thisEncipher = NULL;
	}
	
	//LOGGING_FACILITY1( ccStatus == kCCSuccess, @"Problem with encipherment ccStatus == %d", ccStatus );
	
	cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
	
    
    
    
	if(bufferPtr) free(bufferPtr);
	
	return cipherOrPlainText;
	
	/*
	 Or the corresponding one-shot call:
	 
	 ccStatus = CCCrypt(	encryptOrDecrypt,
	 kCCAlgorithmAES128,
	 typeOfSymmetricOpts,
	 (const void *)[self getSymmetricKeyBytes],
	 kChosenCipherKeySize,
	 iv,
	 (const void *) [plainText bytes],
	 plainTextBufferSize,
	 (void *)bufferPtr,
	 bufferPtrSize,
	 &movedBytes
	 );
	 
	 ccStatus = CCCrypt(	encryptOrDecrypt,
	 kCCAlgorithmAES128,
	 0,
	 symmetricKey,
	 kCCKeySizeAES128,
	 iv,
	 (const void *) [plainText bytes],
	 plainTextBufferSize,
	 (void *)bufferPtr,
	 bufferPtrSize,
	 &movedBytes
	 );
	 
	 */
}

#pragma mark -
#pragma mark Singleton methods
- (id)init
{
	if(self = [super init])
	{
		symmetricKey = [NSData dataWithBytes:kKeyBytes length:sizeof(kKeyBytes)];
	}
	return self;
}

+ (GSCryptoHelper*)sharedInstance
{
    @synchronized(self)
	{
        if (MyCryptoHelper == nil)
		{
            MyCryptoHelper =  [[self alloc] init];
        }
    }
    return MyCryptoHelper;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if (MyCryptoHelper == nil)
		{
            MyCryptoHelper = [super allocWithZone:zone];
            return MyCryptoHelper;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}








-(NSString *) hexEncode:(NSData*)data{
    NSMutableString *hex = [NSMutableString string];
    unsigned char *bytes = (unsigned char *)[data bytes];
    char temp[3];
    NSUInteger i = 0;
    
    for (i = 0; i < [data length]; i++)
	{
		temp[0] = temp[1] = temp[2] = 0;
		(void)sprintf(temp, "%02x", bytes[i]);
		[hex appendString:[NSString stringWithUTF8String:temp]];
	}
    return hex;
}


- (NSData*) hexDecode:(NSString *)hexString
{
    unsigned long tlen = [hexString length]/2;
    
    char tbuf[tlen];
    int i,k,h,l;
    bzero(tbuf, sizeof(tbuf));
    
    for(i=0,k=0;i<tlen;i++)
    {
        h=[hexString characterAtIndex:k++];
        l=[hexString characterAtIndex:k++];
        h=(h >= 'A') ? h-'A'+10 : h-'0';
        l=(l >= 'A') ? l-'A'+10 : l-'0';
        tbuf[i]= ((h<<4)&0xf0)| (l&0x0f);
    }
    
    return [NSData dataWithBytes:tbuf length:tlen];
}






- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes,(unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}




-(NSString*) sha256:(NSString*)input {
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    //uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    
    CC_SHA256(data.bytes, (unsigned int)data.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"hash====================%@",hash);
    // NSLog(@"ha len ============%d",[hash length]);
    return hash;
    
    
    
}



-(NSString*) sha256Base64Withsalt:(NSString*)salt   param:(NSString*)parameters {
    
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    
    return [self base64EncodeData:hash];
    
}






- (NSString*)encrypt256String:(NSString*)string {
    NSData *data = [string dataUsingEncoding: NSUTF8StringEncoding];
    data = [self AES256EncryptWithKey:data];
    NSString *result = [self base64EncodeData:data];
    return result;
}
- (NSString*)decrypt256String:(NSString*)string{
    NSData *decodedData = [self dataWithBase64EncodedString:string];
    decodedData = [self AES256DecryptWithKey:decodedData];
    NSString *result = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return result;
    
}


- (NSData *)AES256EncryptWithKey:(NSData *)key
{
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key256 getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [key length];
	
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [key bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	}
    
	free(buffer); //free the buffer;
	return nil;
}

- (NSData *)AES256DecryptWithKey:(NSData *)key
{
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key256 getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [key length];
	
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [key bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
	
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
	}
	
	free(buffer); //free the buffer;
	return nil;
}

- (NSData*) dataWithBase64EncodedString:(NSString *) string {
	NSMutableData *mutableData = nil;
    
	if( string ) {
		unsigned long ixtext = 0;
		unsigned long lentext = 0;
		unsigned char ch = 0;
		//unsigned char inbuf[4], outbuf[3];
        unsigned char inbuf[4] = {};
        unsigned char outbuf[3];
        
		short i = 0, ixinbuf = 0;
		BOOL flignore = NO;
		BOOL flendtext = NO;
		NSData *base64Data = nil;
		const unsigned char *base64Bytes = nil;
        
		// Convert the string to ASCII data.
		base64Data = [string dataUsingEncoding:NSASCIIStringEncoding];
		base64Bytes = [base64Data bytes];
		mutableData = [NSMutableData dataWithCapacity:[base64Data length]];
		lentext = [base64Data length];
        
		while( YES ) {
			if( ixtext >= lentext ) break;
			ch = base64Bytes[ixtext++];
			flignore = NO;
            
			if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
			else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
			else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
			else if( ch == '+' ) ch = 62;
			else if( ch == '=' ) flendtext = YES;
			else if( ch == '/' ) ch = 63;
			else flignore = YES;
            
			if( ! flignore ) {
				short ctcharsinbuf = 3;
				BOOL flbreak = NO;
                
				if( flendtext ) {
					if( ! ixinbuf ) break;
					if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
					else ctcharsinbuf = 2;
					ixinbuf = 3;
					flbreak = YES;
				}
                
				inbuf [ixinbuf++] = ch;
                
				if( ixinbuf == 4 ) {
					ixinbuf = 0;
					outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
					outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
					outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
                    
					for( i = 0; i < ctcharsinbuf; i++ )
						[mutableData appendBytes:&outbuf[i] length:1];
				}
                
				if( flbreak )  break;
			}
		}
	}
    
	return mutableData;
}



- (NSData*) rsaEncryptString:(NSString*) string  withpublicKey:(NSString*) publicKeystr{
    SecKeyRef key = nil;
    
    if ([self setPublicKey:publicKeystr]) {
        key = publicKey;
    }else {
        NSLog(@"wrong key!");
        return  nil;
    }
    
    
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    NSData *stringBytes = [string dataUsingEncoding:NSUTF8StringEncoding];
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([stringBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<blockCount; i++) {
        int bufferSize =(unsigned int)MIN(blockSize,[stringBytes length] - i * blockSize);
        NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes],
                                        [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) free(cipherBuffer);
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    NSLog(@"Encrypted text (%lu bytes): %@", (unsigned long)[encryptedData length], [encryptedData description]);
    NSLog(@"Encrypted text base64: %@",  [encryptedData base64EncodedString]);
    
    
    /*
     //[encryptedData base64EncodedString]
     
     NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[encryptedData base64EncodedString],@"encStr", nil];
     
     NSMutableData *postData = [self generateFormDataFromPostDictionary:dic];
     
     //NSString *strBefore = [[NSString alloc] initWithData:postData encoding:EUCKR];
     NSLog(@"[data length]=%d", [postData length]);
     //[post_dict release];
     //   NSLog(@"encodig dic = %@", [[[NSString alloc] initWithData:postData encoding:EUCKR] autorelease] );
     
     // Establish the API request. Use upload vs uploadAndPost for skip tweet
     NSString *baseurl = @"http://mt.gsshop.com/apis/v2.6/simple/decrypt";
     
     
     
     
     
     
     NSURL *url = [NSURL URLWithString:baseurl];
     NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
     //if (!urlRequest) NOTIFY_AND_LEAVE(@"Error creating the URL Request");
     
     NSLog(@"baseurl = %@",baseurl);
     
     [urlRequest setHTTPMethod: @"POST"];
     [urlRequest addValue:MULTIPART forHTTPHeaderField:@"Content-Type"];
     [urlRequest setHTTPBody:postData];
     
     
     
     // Submit & retrieve results
     NSError *error;
     NSURLResponse *response;
     NSLog(@"Contacting Server.... %@",baseurl);
     NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
     if (!result)
     {
     NSLog(@"리졀트 없음");
     
     }
     
     
     // Return results
     NSString *outstring = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
     NSLog(@"outstring = %@",outstring);
     
     */
    
    
    
    return encryptedData;
}


- (BOOL) setPublicKey: (NSString *) keyAsBase64 {
    
    /* First decode the Base64 string */
    //Base64 * b64 = [[Base64 alloc] init];
    //NSData * rawFormattedKey = [b64 base64decode:[keyAsBase64 UTF8String] length:[keyAsBase64 length]];
    
    
    NSData * rawFormattedKey = [NSData dataFromBase64String:keyAsBase64];
    
    
    /* Now strip the uncessary ASN encoding guff at the start */
    unsigned char * bytes = (unsigned char *)[rawFormattedKey bytes];
    size_t bytesLen = [rawFormattedKey length];
    
    /* Strip the initial stuff */
    size_t i = 0;
    if (bytes[i++] != 0x30)
        return FALSE;
    
    /* Skip size bytes */
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    
    if (i >= bytesLen)
        return FALSE;
    
    if (bytes[i] != 0x30)
        return FALSE;
    
    /* Skip OID */
    i += 15;
    
    if (i >= bytesLen - 2)
        return FALSE;
    
    if (bytes[i++] != 0x03)
        return FALSE;
    
    /* Skip length and null */
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    
    if (i >= bytesLen)
        return FALSE;
    
    if (bytes[i++] != 0x00)
        return FALSE;
    
    if (i >= bytesLen)
        return FALSE;
    
    /* Here we go! */
    NSData * extractedKey = [NSData dataWithBytes:&bytes[i] length:bytesLen - i];
    
    /* Load as a key ref */
    OSStatus error = noErr;
    CFTypeRef persistPeer = NULL;
    
    char *key = "ditto";
    
    NSData * refTag = [[NSData alloc] initWithBytes:key length:strlen(key)];
    NSMutableDictionary * keyAttr = [[NSMutableDictionary alloc] init];
    
    [keyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [keyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyAttr setObject:refTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    /* First we delete any current keys */
    SecItemDelete((__bridge CFDictionaryRef) keyAttr);
    
    [keyAttr setObject:extractedKey forKey:(__bridge id)kSecValueData];
    [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];
    
    error = SecItemAdd((__bridge CFDictionaryRef) keyAttr, (CFTypeRef *)&persistPeer);
    
    if (persistPeer == nil || ( error != noErr && error != errSecDuplicateItem)) {
        // NSLog(@"Problem adding public key to keychain");
        return FALSE;
    }
    
    CFRelease(persistPeer);
    
    //publicKeyRef = nil;
    
    /* Now we extract the real ref */
    [keyAttr removeAllObjects];
    /*
     [keyAttr setObject:(id)persistPeer forKey:(id)kSecValuePersistentRef];
     [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
     */
    [keyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [keyAttr setObject:refTag forKey:(__bridge id)kSecAttrApplicationTag];
    [keyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    // Get the persistent key reference.
    error = SecItemCopyMatching((__bridge CFDictionaryRef)keyAttr, (CFTypeRef *)&publicKey);
    
    if (publicKey == nil || ( error != noErr && error != errSecDuplicateItem)) {
        NSLog(@"Error retrieving public key reference from chain");
        return FALSE;
    }else{
        NSLog(@"publicKey = %@",publicKey);
    }
    
    
    return TRUE;
}
@end
