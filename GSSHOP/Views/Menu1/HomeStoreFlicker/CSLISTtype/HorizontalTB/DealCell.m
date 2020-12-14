//
//  DealCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 3. 16..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "DealCell.h"
#import "HztbGlobalVariables.h"


@implementation DealCell


@synthesize thumbnail = _thumbnail;
@synthesize titleLabel = _titleLabel;
@synthesize priceLabel = _priceLabel;

@synthesize loadingImageURLString = loadingImageURLString_;
@synthesize imageLoadingOperation = imageLoadingOperation_;

#pragma mark - View Lifecycle



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding/2, kArticleCellVerticalInnerPadding, kCellWidth-kArticleCellHorizontalInnerPadding, kCellWidth-kArticleCellHorizontalInnerPadding)];
        self.thumbnail.opaque = NO;
        
        UIImageView *imgBG = [[UIImageView alloc] initWithFrame:self.thumbnail.frame];
        imgBG.image = [UIImage imageNamed:@"noimg_280.png"];
        [self.contentView addSubview:imgBG];
        [self.contentView addSubview:self.thumbnail];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.thumbnail.frame.size.height+6  , self.thumbnail.frame.size.width,40)];
        self.titleLabel.opaque = YES;
        self.titleLabel.textColor = [Mocha_Util getColor:@"444444"];
        self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.numberOfLines = 2;
        [self.thumbnail addSubview:self.titleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.thumbnail.frame.size.height+46  , self.thumbnail.frame.size.width,20)];
        self.priceLabel.opaque = YES;
        self.priceLabel.textColor = [Mocha_Util getColor:@"111111"];
        self.priceLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.priceLabel.font = [UIFont boldSystemFontOfSize:17];
        self.priceLabel.numberOfLines = 1;
        [self.thumbnail addSubview:self.priceLabel];
        //원= bold 없음 fontsize=14 111111
        
        self.wonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.thumbnail.frame.size.height+46  , self.thumbnail.frame.size.width,20)];
        self.wonLabel.opaque = YES;
        self.wonLabel.textColor = [Mocha_Util getColor:@"111111"];
        self.wonLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.wonLabel.font = [UIFont systemFontOfSize:14];
        self.wonLabel.numberOfLines = 1;
        [self.thumbnail addSubview:self.wonLabel];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.thumbnail.frame];
        self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    }
    return self;
}





-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    
    if([NCS([rowinfoArr objectForKey:@"imageUrl"]) length] > 0) {
        self.loadingImageURLString =  NCS([rowinfoArr objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:self.loadingImageURLString responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [self.loadingImageURLString isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(isInCache) {
                        self.thumbnail.image = fetchedImage;
                    }
                    else {
                        self.thumbnail.alpha = 0;
                        self.thumbnail.image = fetchedImage;
                        // nami0342 - main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.thumbnail.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                       }];
                        });
                  }
                });
            }
      }];
    }
    else {
        
    }
}





- (NSString *)reuseIdentifier {
    return @"DealCell";
}



#pragma mark - Memory Management

- (void)dealloc {
    self.thumbnail = nil;
    self.titleLabel = nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.thumbnail.image = nil;
    self.titleLabel.text = @"";
}

@end
