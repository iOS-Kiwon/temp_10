//
//  SectionSBTtypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2016. 7. 12..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SectionSBTtypeSubview;

@interface SectionSBTtypeCell : UITableViewCell
{

    SectionSBTtypeSubview *subview01;
    SectionSBTtypeSubview *subview02;
    SectionSBTtypeSubview *subview03;
    
}

@property (nonatomic, weak) id target;
@property (nonatomic, weak) UIColor *backColor;
@property (nonatomic, strong) NSArray *subArr;                      // 카테고리를 구성할 배열값
@property (weak, nonatomic) IBOutlet UIView *defaultView;           // 서브뷰를 넣을 기본 뷰

@property (strong, nonatomic) NSIndexPath *indexPath;               //테이블뷰 속의 인덱스 패스
@property (strong, nonatomic) UIImage *imgSeleted;                  //선택된 셀의 이미지 주소

@property (strong, nonatomic) IBOutlet UIView *viewBottomLine;               //셀의 하단 라인

-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andIndexPath:(NSIndexPath *)path;
- (void)clickProduct:(id)sender withProductImage:(UIImage *)image;
@end
