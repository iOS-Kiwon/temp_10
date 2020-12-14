//
//  MobileLiveProduct.h
//  GSSHOP
//
//  Created by nami0342 on 15/02/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MobileLiveProductDelegate<NSObject>
- (void) MobileLiveProduct_DirectOrderClick : (_Nullable id) sender;
- (void) MobileLiveProduct_Preview : (_Nullable id) sender;
@optional
@end

@interface MobileLiveProduct : UIView

@property (nonatomic, weak, nullable) id <MobileLiveProductDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView  * _Nullable m_imgProduct;
@property (nonatomic, strong) IBOutlet UILabel      * _Nullable m_lbProductTitle;
//@property (nonatomic, strong) IBOutlet UILabel      * _Nullable m_lbProductOriginalPrice;
@property (nonatomic, strong) IBOutlet UILabel      * _Nullable m_lbSalePrice;
//@property (nonatomic, strong) IBOutlet UIView       * _Nullable m_vDash;
@property (nonatomic, strong) IBOutlet UIButton     * _Nullable m_btnDirectOrder;
@property (nonatomic, strong) NSString              * _Nullable m_strDirectOrderURL;
@property (nonatomic, strong) NSString              * _Nullable m_strPreviewURL;
@property (nonatomic, assign) double                            m_dblDateOfEnd;             // 상품별 방송 종료 시간. 인덱스 계산을 위해 뽑아 냄 -> 나중에 사용할 것


- (void) setData : (NSDictionary *_Nullable) dicData;
- (IBAction) click_directOrder:( _Nullable id)sender;

@end
