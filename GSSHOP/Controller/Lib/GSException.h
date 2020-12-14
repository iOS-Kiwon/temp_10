//
//  GSException.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 9. 20..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSException : NSObject

@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSMutableArray *callStackSymbols;
@property (nonatomic,strong) NSMutableDictionary *userInfo;

- (id) initWithException : (NSException *) ex addString:(NSString *)strToAdd;

@end
