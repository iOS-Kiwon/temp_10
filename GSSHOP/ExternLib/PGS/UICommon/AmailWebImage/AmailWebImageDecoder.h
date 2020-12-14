#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol AmailWebImageDecoderDelegate;
@interface AmailWebImageDecoder : NSObject
{
    NSOperationQueue *imageDecodingQueue;
}
+ (AmailWebImageDecoder *)sharedImageDecoder;
- (void)decodeImage:(UIImage *)image withDelegate:(id <AmailWebImageDecoderDelegate>)delegate userInfo:(NSDictionary *)info;
@end
@protocol AmailWebImageDecoderDelegate <NSObject>
- (void)imageDecoder:(AmailWebImageDecoder *)decoder didFinishDecodingImage:(UIImage *)image userInfo:(NSDictionary *)userInfo;
@end
@interface UIImage (ForceDecode)
+ (UIImage *)decodedImageWithImage:(UIImage *)image;
@end