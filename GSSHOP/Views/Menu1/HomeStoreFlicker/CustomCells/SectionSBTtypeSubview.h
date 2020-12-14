//
//  SectionSBTtypeSubview.h
//  GSSHOP
//
//  Created by Parksegun on 2016. 7. 11..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionSBTtypeSubview : UIView
{
    
}

@property (nonatomic, weak) id target;                              //클릭시 이벤트를 보낼 타겟
@property (nonatomic, strong) IBOutlet UIImageView *productImage;   //상품 이미지
@property (nonatomic, strong) IBOutlet UIImageView *noImage;   //상품 이미지
@property (nonatomic, strong) IBOutlet UIImageView *playIcon;       // 동영상 플레이 아이콘
@property (nonatomic, strong) IBOutlet UILabel *productName;        // 상품 명
@property (nonatomic, strong) IBOutlet UIButton *clickButton;        // 상품 클릭 버튼

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation; //이미지 통신 오퍼레이션
@property (nonatomic, strong) NSString *imageURL;                           //이미지 url

- (IBAction)cellClick:(id)sender;
- (void) setCellInfoNDrawData:(NSDictionary*) infoDic;
@end
