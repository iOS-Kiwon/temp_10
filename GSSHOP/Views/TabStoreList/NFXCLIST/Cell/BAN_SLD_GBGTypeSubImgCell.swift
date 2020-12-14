//
//  BAN_SLD_GBGTypeSubImgCell.swift
//  GSSHOP
//
//  Created by neocyon MacBook on 2020/08/21.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class BAN_SLD_GBGTypeSubImgCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backGdView: UIImageView!
    private var aTarget: BAN_SLD_GBGTypeCell?
    /// indexPath
    private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 6.0
        self.backGdView.layer.cornerRadius = 6.0
        //그림자
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 4.0)
        self.layer.shadowRadius = 8.0/2.0
        self.layer.shadowOpacity = 0.12
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil;
    }

    func setData(_ module: Module,  indexPath: IndexPath ,target: BAN_SLD_GBGTypeCell) {

        self.aTarget = target
        self.indexPath = indexPath
        
        let imageUrl = module.imageUrl
        if imageUrl.hasPrefix("http") {
            ImageDownManager.blockImageDownWithURL(imageUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                if error == nil, imageUrl == strInputURL, let fImg = fetchedImage {
                    DispatchQueue.main.async {

                        self.imageView.image = fImg
                        
                    }//dispatch
                }
            }
        }
        
        self.layoutIfNeeded()
    }
    
    @IBAction func onClickImgCollection (_ sender : UIButton){
        if let vc = self.aTarget ,
            let path = self.indexPath {
            vc.onBtnImgCollection(path)
        }
    }

    /*
    - (void) setCellInfoNDrawData:(NSDictionary *) rowDic {
        self.objDic = rowDic;
        [self setImageView:self.imageView withURL:NCS([rowDic objectForKey:@"imageUrl"])];
        
        // 접근성 설정
        NSString *accessStr = NCS([rowDic objectForKey:@"title"]);
        if (accessStr.length > 0) {
            self.btnImage.accessibilityLabel = accessStr;
        }
        //그라데이션 - 20190426 디자이너 요청으로 그라데이션 제거
    //    gradient = [CAGradientLayer layer];
    //    gradient.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //    gradient.colors = @[(id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0].CGColor, (id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5].CGColor];
    //    [self.imageView.layer addSublayer:gradient];
    }

    - (void) setImageView:(UIImageView *)imgView withURL:(NSString *)imageURL {
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if(error == nil  && [imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        imgView.image = fetchedImage;
                    }
                    else {
                        imgView.alpha = 0;
                        imgView.image = fetchedImage;
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             imgView.alpha = 1;
                                         }
                                         completion:^(BOOL finished) {
                                         }];
                    }
                });
            }
        }];
    }
    - (IBAction)btnDown:(id)sender {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformScale(self.transform, 0.96, 0.96);
        }];
    }
    - (IBAction)btnCancel:(id)sender {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformScale(self.transform, 1.04, 1.04);
        }];
    }
    - (IBAction)btnClick:(id)sender {
        [self btnCancel:sender];
        if ([self.target respondsToSelector:@selector(goWebviewWithStringUrl:)]) {
            [self.target goWebviewWithStringUrl:NCS([self.objDic objectForKey:@"linkUrl"])];
        }
    }
    */
}
