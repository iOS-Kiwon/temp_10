//
//  CellSubInfoData.h
//  GSSHOP
//
//  Created by gsshop on 2015. 4. 30..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellSubInfoData : NSObject {
    
    NSString *CellViewType;
    NSMutableArray *BCArr;
}

@property (nonatomic,strong) NSString *CellViewType;
@property (nonatomic,strong) NSMutableArray *BCArr;
@end
