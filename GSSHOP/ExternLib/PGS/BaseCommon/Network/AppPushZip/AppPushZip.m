#import "AppPushZip.h"
#include <zlib.h>
@implementation AppPushZip
+ (NSData *)AT_gzipInflate:(NSData *)argData
{
	if ([argData length] == 0) return argData;
	unsigned full_length = (int)[argData length];
	unsigned half_length = (int)[argData length] / 2;
	NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
	BOOL done = NO;
	int status;
	z_stream strm;
	strm.next_in = (Bytef *)[argData bytes];
	strm.avail_in = (int)[argData length];
	strm.total_out = 0;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
	while (!done){
		if (strm.total_out >= [decompressed length])
			[decompressed increaseLengthBy: half_length];
		strm.next_out = [decompressed mutableBytes] + strm.total_out;
		strm.avail_out = (int)[decompressed length] - (int)strm.total_out;
		status = inflate (&strm, Z_SYNC_FLUSH);
		if (status == Z_STREAM_END) done = YES;
		else if (status != Z_OK) break;
	}
	if (inflateEnd (&strm) != Z_OK) return nil;
	if (done){
		[decompressed setLength: strm.total_out];
		return [NSData dataWithData: decompressed];
	}
	else return nil;
}

+ (NSData *)AT_gzipDeflate:(NSData *)argData
{
	if ([argData length] == 0) return argData;
	z_stream strm;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	strm.total_out = 0;
	strm.next_in=(Bytef *)[argData bytes];
	strm.avail_in = (int)[argData length];
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
	NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
	do {
		if (strm.total_out >= [compressed length])
			[compressed increaseLengthBy: 16384];
		strm.next_out = [compressed mutableBytes] + strm.total_out;
		strm.avail_out = (int)[compressed length] - (int)strm.total_out;
		deflate(&strm, Z_FINISH);  
	} while (strm.avail_out == 0);
	deflateEnd(&strm);
	[compressed setLength: strm.total_out];
	return [NSData dataWithData:compressed];
}
@end