//
//  CMPrd2TableViewCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 12. 20..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#define widthColViewPrd2 (APPFULLWIDTH - 60.0)

static NSString *CMPrd2SubTypeIdentifier = @"CMPrd2SubCell";
@interface CMPrd2TableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) IBOutlet UICollectionView *colviewProduct;
@property (nonatomic,strong) NSArray *arrProducts;
@property (nonatomic,strong) NSDictionary *dicRowInfo;
@property (nonatomic,assign) CGPoint startingScrollingOffset;
@property (nonatomic,strong) IBOutlet UIView *viewDefault;

-(void)setDicRowInfo:(NSDictionary *)rowinfo;
@end
