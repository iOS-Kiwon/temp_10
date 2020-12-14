//
//  LatelySearchData.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LatelySearchData : NSObject {
    
    NSString *searchWord;
    NSString *searchType;
    NSString *searchTime;
}

@property (nonatomic,strong) NSString *searchWord;
@property (nonatomic,strong) NSString *schType;
@property (nonatomic,strong) NSString *schTime;
@end

