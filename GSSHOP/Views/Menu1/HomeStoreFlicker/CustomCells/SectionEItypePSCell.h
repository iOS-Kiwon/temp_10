//
//  SectionEItypePSCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 25..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  이벤트 탭에서 항상 사용
//  이벤트탭의 핀터레스트 스타일 셀 , 셀 하나로 높이가 다른 N1,N2 타입 대응

#import "PSCollectionViewCell.h"

@interface SectionEItypePSCell : PSCollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *noImageE_N1;                  //이미지뷰 146 높이 noimg
@property (nonatomic, weak) IBOutlet UIImageView *noImageE_N2;                  //이미지뷰 264 높이 noimg

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImage;               //이벤트 이미지

@property (nonatomic, strong) NSString* loadingImageURLString;                  //이미지 url
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;     //이미지 통신 오퍼레이션
@property (nonatomic, strong) IBOutlet UIImageView *imgIconHot;                 //좌상단 작은 아이콘 이미지 핫이슈
@property (nonatomic, strong) IBOutlet UIImageView *imgIconBene;                //좌상단 작은 아이콘 이미지 혜택
@property (nonatomic, strong) IBOutlet UIImageView *imgIconComm;                //좌상단 작은 아이콘 이미지 TV존

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;                        //셀 구성정보를 포함하고있는 딕셔너리 셋팅

@end
