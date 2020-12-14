//
//  BrandNameData.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 10. 30..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandNameData : NSObject{
    NSString *brandname;
    NSString *brandurl;
}
@property (nonatomic,strong) NSString* brandname;
@property (nonatomic,strong) NSString* brandurl;
@end
