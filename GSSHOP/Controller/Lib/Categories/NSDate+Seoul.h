//
//  NSDate+NSDate_Seoul.h
//  GSSHOP
//
//  Created by nami0342 on 2016. 10. 6..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_Seoul)


+(NSDate *) getSeoulDateTime;
+(NSDate *) getDateWithTimeZoneName : (NSString *) strName;


@end
