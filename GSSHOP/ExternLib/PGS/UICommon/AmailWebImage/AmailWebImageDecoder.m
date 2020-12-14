#import "AmailWebImageDecoder.h"
#define AMAIL_DECOMPRESSED_IMAGE_KEY @"decompressedImage"
#define AMAIL_DECODE_INFO_KEY @"decodeInfo"
#define AMAIL_IMAGE_KEY @"image"
#define AMAIL_DELEGATE_KEY @"delegate"
#define AMAIL_USER_INFO_KEY @"userInfo"
@implementation AmailWebImageDecoder
static AmailWebImageDecoder *sharedInstance;
- (void)notifyDelegateOnMainThreadWithInfo:(NSDictionary *)dict
{
    NSDictionary *decodeInfo = [dict objectForKey:AMAIL_DECODE_INFO_KEY];
    UIImage *decodedImage = [dict objectForKey:AMAIL_DECOMPRESSED_IMAGE_KEY];
    id <AmailWebImageDecoderDelegate> delegate = [decodeInfo objectForKey:AMAIL_DELEGATE_KEY];
    NSDictionary *userInfo = [decodeInfo objectForKey:AMAIL_USER_INFO_KEY];
    [delegate imageDecoder:self didFinishDecodingImage:decodedImage userInfo:userInfo];
}
- (void)decodeImageWithInfo:(NSDictionary *)decodeInfo
{
    UIImage *image = [decodeInfo objectForKey:AMAIL_IMAGE_KEY];
    UIImage *decompressedImage = [UIImage decodedImageWithImage:image];
    if (!decompressedImage)
    {
        // If really have any error occurs, we use the original image at this moment
        decompressedImage = image;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          decompressedImage, AMAIL_DECOMPRESSED_IMAGE_KEY,
                          decodeInfo, AMAIL_DECODE_INFO_KEY, nil];
    [self performSelectorOnMainThread:@selector(notifyDelegateOnMainThreadWithInfo:) withObject:dict waitUntilDone:NO];
}
- (id)init
{
    if ((self = [super init]))
    {
        // Initialization code here.
        imageDecodingQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}
- (void)decodeImage:(UIImage *)image withDelegate:(id<AmailWebImageDecoderDelegate>)delegate userInfo:(NSDictionary *)info
{
    NSDictionary *decodeInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                image, AMAIL_IMAGE_KEY,
                                delegate, AMAIL_DELEGATE_KEY,
                                info, AMAIL_USER_INFO_KEY, nil];
    NSOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(decodeImageWithInfo:) object:decodeInfo];
    [imageDecodingQueue addOperation:operation];
}

+ (AmailWebImageDecoder *)sharedImageDecoder
{
    if (!sharedInstance)
    {
        sharedInstance = [[AmailWebImageDecoder alloc] init];
    }
    return sharedInstance;
}
@end
@implementation UIImage (ForceDecode)
+ (UIImage *)decodedImageWithImage:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 CGImageGetWidth(imageRef),
                                                 CGImageGetHeight(imageRef),
                                                 8,
                                                 // Just always return width * 4 will be enough
                                                 CGImageGetWidth(imageRef) * 4,
                                                 // System only supports RGB, set explicitly
                                                 colorSpace,
                                                 // Makes system don't need to do extra conversion when displayed.
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little); 
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    CGRect rect = (CGRect){CGPointZero, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)};
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *decompressedImage = [[UIImage alloc] initWithCGImage:decompressedImageRef];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}
@end