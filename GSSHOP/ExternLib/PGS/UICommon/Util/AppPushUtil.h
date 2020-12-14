#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface AppPushUtil : NSObject 
//+(void) alertWithTitle:(NSString *)argTitle message:(NSString *)argMessage;
+(UIImage *) resizeImage:(UIImage *)argImage width:(int)argWidth height:(int)argHeight;
+(NSString *) uniqueNumber;
+(UIImage*)resizedImage:(UIImage*)inImage inRect:(CGRect)thumbRect;
+ (NSString *)calcDate:(NSString *)argDate
          originFormat:(NSString *)argOriginFormat
             newFormat:(NSString *)argNewFormat
                locale:(NSString *)argLocale
              amSymbol:(NSString *)argAmSymbol
              pmSymbol:(NSString *)argPmSymbol;
+ (NSMutableArray *)expressRichHtml:(NSString *)argHtml;
@end
