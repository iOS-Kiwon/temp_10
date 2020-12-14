//
//  URLParser.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 13. 12. 30..
//  Copyright (c) 2013년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject {
    NSArray *variables;
}

@property (nonatomic, strong) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end