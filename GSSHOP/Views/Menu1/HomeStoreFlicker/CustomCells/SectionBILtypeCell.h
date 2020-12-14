//
//  SectionBILtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 24..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  전체 탭에서 가끔사용
//  이미지 전용셀 높이240

#import <UIKit/UIKit.h>

@interface SectionBILtypeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImage;               //이미지뷰

@property (nonatomic, strong) NSString* loadingImageURLString;                  //이미지 URL
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;     //이미지 통신 오퍼레이션
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;                        //이미지 경로를 포함하고있는 딕셔너리 셋팅

@end
