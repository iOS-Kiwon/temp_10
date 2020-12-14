//
//  SectionBIMtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 29..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  전체 탭에서 자주사용
//  이미지 전용셀 높이160

#import <UIKit/UIKit.h>

@interface SectionBIMtypeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImage;               //이미지뷰
@property (nonatomic, weak) IBOutlet UIImageView *tvHotIcon;                    //hot 아이콘

@property (nonatomic, strong) NSString* loadingImageURLString;                  //이미지 URL
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;                        //이미지 경로를 포함하고있는 딕셔너리 셋팅

@end
