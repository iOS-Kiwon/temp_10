//
//  SectionSPCtypeSubCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 20..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//  TV쇼핑 탭에서만 사용 , 지금은 거의 사용안함
//  SPC 셀 속에있는 테이블 뷰에서 호출해서 쓰는 셀

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SectionSPCtypeSubCell : UITableViewCell 

@property (nonatomic, strong) IBOutlet UIView *view_Default;                    //베이스뷰
@property (nonatomic, strong) IBOutlet UIImageView *imageContents;              //방송 이미지
@property (nonatomic, strong) IBOutlet UILabel *lblWeek;                        //방송 요일
@property (nonatomic, strong) IBOutlet UILabel *lblTime;                        //방송 시간
@property (nonatomic, strong) IBOutlet UIButton *btnCell;                       //셀 버튼

@property (nonatomic, strong) NSDictionary *row_dic;                            //셀 전체를 구성할때 사용하는 데이터
@property (nonatomic, strong) NSString* loadingImageURLString;                  //이미지 주소
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;     //이미지 로딩 오퍼레이션

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic;                        //셀 구성정보를 포함하고있는 딕셔너리 셋팅

@end
