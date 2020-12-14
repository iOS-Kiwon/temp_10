//
//  SectionTPSACell.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 5. 31..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionTBViewController.h"

@interface SectionTPSAtypeCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
{
}

@property (nonatomic, weak) id targettb;
@property (nonatomic, weak) NSArray *articles;      //하위 상품 정보 배열
@property (nonatomic, strong) NSDictionary *momdic; //상품 정보 구조체
@property (nonatomic, strong) IBOutlet UITableView *horizontalTableView;    // 가로 배열 테이블
@property (nonatomic, strong) IBOutlet UILabel *productName;                // 상품영
@property (nonatomic, strong) IBOutlet UIImageView *imgArrow;                // 이미지꺽쇠



@property (nonatomic, strong) NSString* loadingImageURLString;              // 상품이미지 경로

// 상풍 정보 렌더링
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

@end


