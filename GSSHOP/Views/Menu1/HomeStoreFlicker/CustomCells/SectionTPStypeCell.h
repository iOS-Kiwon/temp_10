//
//  SectionTPSCell.h
//  GSSHOP
//
//  Created by Parksegun on 2016. 5. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionTBViewController.h"

@interface SectionTPStypeCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
{
}

@property (nonatomic, weak) id targettb;
@property (nonatomic, weak) NSArray *articles;      //하위 상품 정보 배열
@property (nonatomic, strong) NSDictionary *momdic; //상품 정보 구조체
@property (nonatomic, strong) IBOutlet UITableView *horizontalTableView;    // 가로 배열 테이블
@property (nonatomic, strong) IBOutlet UILabel *productName;                // 상품영
@property (nonatomic, strong) IBOutlet UILabel *promotionName;              // 프로모션 명



@property (nonatomic, strong) NSString* loadingImageURLString;              // 상품이미지 경로
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation; // 상품 이미지 오퍼레이션

// 상풍 정보 렌더링
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

@end


