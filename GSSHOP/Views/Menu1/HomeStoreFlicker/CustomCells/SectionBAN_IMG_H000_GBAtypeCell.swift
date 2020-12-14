//
//  SectionBAN_IMG_H000_GBAtypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/06/25.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionBAN_IMG_H000_GBAtypeCell: UITableViewCell {
    
    @IBOutlet weak var imgBanner: UIImageView!
    
    @IBOutlet weak var noImg: UIImageView!

    @objc var aTarget: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imgBanner.image = nil
        self.accessibilityLabel = ""
        self.aTarget = nil
        self.noImg.isHidden = false
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    func setData(_ product: Module, indexPath: IndexPath) {
        
        self.accessibilityTraits = .button
        
        if product.productName.isEmpty == false {
            self.accessibilityLabel = product.productName
        } else if product.name.isEmpty == false {
            self.accessibilityLabel = product.name
        } else {
            self.accessibilityLabel = "이미지 배너 입니다."
        }
        
        ImageDownManager.blockImageDownWithURL(product.imageUrl as NSString) { (statusCode, image, strInputURL, isInCache, error) in
            if error != nil || statusCode == 0  || image == nil {
                return
            }
            
            if let fetchedImage = image, fetchedImage.size.height != 0, product.calcHeight == 0 {
                let height: CGFloat = Common_Util.imageRatio(forHeight: fetchedImage.size, fullWidthSize: getAppFullWidth())
                if let vc = self.aTarget as? SectionTBViewController {
                    vc.tableCellReload(forHeight: "\(height)", indexPath: indexPath)
                } else if let vc = self.aTarget as? NFXCListViewController {
                    vc.tableCellReloadForHeight("\(height)", indexPath: indexPath)
                } else if let vc = self.aTarget as? SUPListTableViewController {
                    vc.tableCellReload(forHeight: "\(height)", indexPath: indexPath)
                }
                return
            }
            
            if isInCache.boolValue {
                self.imgBanner.image = image
            } else {
                self.imgBanner.alpha = 0.0
                self.imgBanner.image = image
                
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.imgBanner.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>, position indexPath: IndexPath) {
        guard let product = Module(JSON: rowinfoDic) else {
            return
        }
        
        self.setData(product, indexPath: indexPath)
    }

   

     /*
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        if(error == nil && [imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //높이를 계산후 테이블 높이 변경요청
                if (NCO(self.targetTableView) && [self.targetTableView respondsToSelector:@selector(tableCellReloadForHeight:cellIndex:)] && !NCO([rowinfo objectForKey:CALCCELLHEIGHT]) ) {
                    CGFloat h = [Common_Util imageRatioForHeight:fetchedImage.size fullWidthSize:APPFULLWIDTH];
                    [self.targetTableView tableCellReloadForHeight:[NSString stringWithFormat:@"%f",h] cellIndex:path.row];
                    return;
                } else if (NCO(self.targetTableView) && [self.targetTableView respondsToSelector:@selector(tableCellReloadForHeight:indexPath:)] && !NCO([rowinfo objectForKey:CALCCELLHEIGHT]) ){
                    CGFloat h = [Common_Util imageRatioForHeight:fetchedImage.size fullWidthSize:APPFULLWIDTH];
                    [self.targetTableView tableCellReloadForHeight:[NSString stringWithFormat:@"%f",h] indexPath:path];
                    return;
                }
                if(isInCache) {
                    imgBanner.image = fetchedImage;
                }
                else {
                    imgBanner.alpha = 0;
                    imgBanner.image = fetchedImage;
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         imgBanner.alpha = 1;
                                     }
                                     completion:^(BOOL finished) {
                                         
                                     }
                     ];
                }
            });
        } else {
        }
    }];
 */
}
