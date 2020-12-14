#import "AppPushUtil.h"
@implementation AppPushUtil
+(UIImage *) resizeImage:(UIImage *)argImage width:(int)argWidth height:(int)argHeight
{
    @try {
        CGImageRef imageRef = [argImage CGImage];
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
        if (alphaInfo == kCGImageAlphaNone)alphaInfo = kCGImageAlphaNoneSkipLast;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();        
        CGContextRef bitmap = CGBitmapContextCreate(NULL,argWidth,argHeight, 
                                                    8, // CGImageGetBitsPerComponent(imageRef), 
                                                    0, // bytes per row. 0으로 바꾸면 시스템이 알아서 처리.
                                                    colorSpace, //CGImageGetColorSpace(imageRef), 
                                                    alphaInfo);
        CGContextDrawImage(bitmap, CGRectMake(0, 0, argWidth, argHeight), imageRef);
        CGImageRef ref = CGBitmapContextCreateImage(bitmap);
        UIImage *result = [UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationRight];
        CGContextRelease(bitmap);
        CGImageRelease(ref);
        CGColorSpaceRelease(colorSpace);
        return result;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushUtil resizeImage : %@", exception);   
    }
}
static NSDateFormatter *_dateFormatter;
+(NSString *) uniqueNumber
{
    @try {
        if (_dateFormatter == nil) {
            _dateFormatter = [[NSDateFormatter alloc] init];
            [_dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        }
        NSString *dateString = [_dateFormatter stringFromDate:[NSDate date]];
        return dateString;
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushUtil uniqueNumber : %@", exception);   
    }
}

+(UIImage*)resizedImage:(UIImage*)inImage inRect:(CGRect)thumbRect {
    @try {
        // Creates a bitmap-based graphics context and makes it the current context.
        UIGraphicsBeginImageContext(thumbRect.size);
        [inImage drawInRect:thumbRect];
        return UIGraphicsGetImageFromCurrentImageContext();
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushMessageCellView resizedImage : %@", exception);
    }
}

+ (NSString *)calcDate:(NSString *)argDate
          originFormat:(NSString *)argOriginFormat
             newFormat:(NSString *)argNewFormat
                locale:(NSString *)argLocale
              amSymbol:(NSString *)argAmSymbol
              pmSymbol:(NSString *)argPmSymbol {

    if(argDate==nil || argOriginFormat==nil || argNewFormat==nil) return nil;
    
    @try {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:argLocale!=nil?argLocale:@"ko_KR"] ];
        [df setAMSymbol:argAmSymbol!=nil?argAmSymbol:@"오전"];
        [df setPMSymbol:argPmSymbol!=nil?argPmSymbol:@"오후"];
        [df setDateFormat:argOriginFormat];
        
        NSDate *regDate = [df dateFromString:argDate];
        
        NSRange yearRange = [argOriginFormat rangeOfString:@"YYYY"];
        
        if(yearRange.location != NSNotFound) {
            int year = [[argDate substringWithRange:yearRange] intValue];
            [df setDateFormat:@"yyyyMMdd"];
            NSString *result = [df stringFromDate:regDate];
            int resultYear = [[result substringToIndex:4] intValue];
            
            if(resultYear==year) {
                [df setDateFormat:argNewFormat];
                return [df stringFromDate:regDate];
            } else if(resultYear>year) {
                //크면 빼기
                year -= (resultYear-year);
            } else {
                //작으면 더하기
                year += (year-resultYear);
            }
            
            [df setDateFormat:argOriginFormat];
            NSDate *regDate1 = [df dateFromString:[argDate stringByReplacingCharactersInRange:yearRange withString:[NSString stringWithFormat:@"%d",year]]];
            [df setDateFormat:argNewFormat];
            return [df stringFromDate:regDate1];
            
        } else {
            [df setDateFormat:argNewFormat];
            return [df stringFromDate:regDate];
        }
          
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at Util calcDate : %@", exception);   
    }

}

+ (NSMutableArray *)expressRichHtml:(NSString *)argHtml {
    
    @try {
        
        NSMutableArray *arrHtml = [[NSMutableArray alloc] init];
        NSMutableDictionary *dicHtml = [[NSMutableDictionary alloc] init];
        NSString *expression = @"<a[^<]*href[^<]*=[^<]*([\"']*)http[^<]*>";
        //NSString *expression = @"<a\s*href\s*=\s*([\"']*)(http[^'\">\s]+)\1(.*?)>(.*?)</a>";
        
        int linkCount = 1;
        while (1) {
            
            NSRange range = [argHtml rangeOfString:expression options:NSRegularExpressionSearch];
            if(range.location != NSNotFound) {
                
                NSString *str = [argHtml substringWithRange:range];
                NSRange tempRange = [str rangeOfString:@"http" options:NSRegularExpressionSearch];
                
                NSString *str2 = [str substringWithRange:NSMakeRange(tempRange.location, range.length - tempRange.location)];
                [dicHtml setValue:[str2 stringByReplacingOccurrencesOfString:@"['\">< ]"
                                                                  withString:@""
                                                                     options:NSRegularExpressionSearch
                                                                       range:NSMakeRange(0, str2.length)]
                           forKey:[NSString stringWithFormat:@"%d",linkCount]];
                
                argHtml = [argHtml stringByReplacingCharactersInRange:range
                                                           withString:[NSString stringWithFormat:@"<a href=\"%d\">",linkCount]];
            } else {
                break;
            }

            linkCount++;
        }
        
        if([dicHtml count]>0) {
            //NSLog(@"argHtml:%@",argHtml);
            //NSLog(@"dicHtml:%@",dicHtml);
            [arrHtml addObject:argHtml];
            [arrHtml addObject:dicHtml];
            return arrHtml;
        } else {
            return nil;
        }
                
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at Util expressRichHtml : %@", exception);
        return nil;
    }
    
}

//+ (void)expressRichHtml:(NSString *)argHtml {
//    
//    @try {
//        
//        //NSString *expression = @"<a\s*href\s*=\s*([\"']*)(http[^'\">\s]+)\1(.*?)>(.*?)</a>";
//        //NSString *expression = @"<a href=\"http://(.+)\"";
//        NSString *expression = @"<a href=\"http://[^<]*>[^<]*</word>";
//        
//        NSError *error = nil;
//        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:expression
//                                                                                options:0
//                                                                                  error:&error];
//        if(error==nil) {
//            
//            NSTextCheckingResult *match = [regexp firstMatchInString:argHtml options:0 range:NSMakeRange(0, argHtml.length)];
//            
//            NSLog(@"match numbers : %d",match.numberOfRanges);
//            
//            for(int i=0 ; i<match.numberOfRanges ; i++) {
//                NSLog(@"%@",[argHtml substringWithRange:[match rangeAtIndex:i]]);
//            }
//            
//        } else {
//            NSLog(@"error : %@",error);
//        }
//        
//    } @catch (NSException *exception) {
//        NSLog(@"PMS Exception at Util expressRichHtml : %@", exception);   
//    }
//    
//}


@end
