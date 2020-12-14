#import "AT_Seed.h"
@implementation AT_Seed
+(NSData *) encryptForBabpi:(NSData *)argInputData userKey:(NSString *)argUserKey;
{
    DWORD pdwRoundKey[32];
    BYTE pbData[16];
    BYTE pbReceivedKey[17];
    NSMutableData *outputData = [[NSMutableData alloc] initWithCapacity:[argInputData length] + 32];
    [argUserKey getCString:(char *)pbReceivedKey maxLength:17 encoding:NSASCIIStringEncoding];
    AT_SeedRoundKey(pdwRoundKey, pbReceivedKey);
    int len;
    for (int pos=0; pos<[argInputData length]; pos += 16) {
        memset(pbData, 0, 16);
        len = (int)[argInputData length] - pos;
        if (len > 16) len = 16;
        [argInputData getBytes:(void *)pbData range:NSMakeRange(pos, len)];
        AT_SeedEncrypt(pbData, pdwRoundKey);
        [outputData appendBytes:(const void *)pbData length:16];
    }
    return outputData;
}
+(NSData *) decryptForBabpi:(NSData *)argInputData userKey:(NSString *)argUserKey;
{
    DWORD pdwRoundKey[32];
    BYTE pbData[16];
    BYTE pbReceivedKey[17];
    NSMutableData *outputData = [[NSMutableData alloc] initWithCapacity:[argInputData length] + 32];
    [argUserKey getCString:(char *)pbReceivedKey maxLength:17 encoding:NSASCIIStringEncoding];
    AT_SeedRoundKey(pdwRoundKey, pbReceivedKey);
    int len;
    for (int pos=0; pos<[argInputData length]; pos += 16) {
        memset(pbData, 0, 16);
        len = (int)[argInputData length] - pos;
        if (len > 16) len = 16;
        [argInputData getBytes:(void *)pbData range:NSMakeRange(pos, len)];
        AT_SeedDecrypt(pbData, pdwRoundKey);
        [outputData appendBytes:(const void *)pbData length:16];
    }
    return outputData;
}
@end
