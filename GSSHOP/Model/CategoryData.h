//
//  CategoryData.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryData : NSObject {
    NSString *next;
    NSString *groupId;
    NSString *sectName;
    NSMutableArray *childarray;
    NSString *cateicon; 
    
}

@property (nonatomic,strong) NSString *next;
@property (nonatomic,strong)NSString *groupId;
@property (nonatomic,strong)NSString *sectName;
@property (nonatomic,strong)NSMutableArray *childarray;
@property (nonatomic) int level;
@property (nonatomic) BOOL directlink;
@property (nonatomic) BOOL expanded;
@property (nonatomic) BOOL existchild;
@property (nonatomic,strong) NSString *cateicon;
@end

