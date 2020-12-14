//
//  SectionDefaultCell.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 2. 3..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "SectionDefaultCell.h"

#import "AppDelegate.h"

@implementation SectionDefaultCell
@synthesize titleLabel = titleLabel_;
@synthesize authorNameLabel = authorNameLabel_;
@synthesize thumbnailImage = thumbnailImage_;
@synthesize loadingImageURLString = loadingImageURLString_;
//@synthesize imageLoadingOperation = imageLoadingOperation_;

-(void) prepareForReuse {
    [super prepareForReuse];
    self.titleLabel.text = @"";
    self.thumbnailImage.image = nil;
    
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) setCellInfoNDrawData:(NSDictionary*) thisFlickrImage {
    
    self.titleLabel.text = NCS([thisFlickrImage objectForKey:@"title"]);
	self.authorNameLabel.text = NCS([thisFlickrImage objectForKey:@"owner"]);
    self.loadingImageURLString =  NCS([thisFlickrImage objectForKey:@"prdImage"]);
    
    [ImageDownManager blockImageDownWithURL:self.loadingImageURLString responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [self.loadingImageURLString isEqualToString:strInputURL]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache) {
                                                                                   
                                                                                   NSLog(@"Data from cache Image");
                                                                                   self.thumbnailImage.image = fetchedImage;
                                                                               } else {
                                                                                   NSLog(@"Data from None Cached Image");
                                                                                   UIImageView *loadedImageView = [[UIImageView alloc] initWithImage:fetchedImage];
                                                                                   loadedImageView.frame = self.thumbnailImage.frame;
                                                                                   loadedImageView.alpha = 0;
                                                                                   [self.contentView addSubview:loadedImageView];
                                                                                   
                                                                                   [UIView animateWithDuration:0.4
                                                                                                    animations:^
                                                                                    {
                                                                                        loadedImageView.alpha = 1;
                                                                                        self.thumbnailImage.alpha = 0;
                                                                                    }
                                                                                                    completion:^(BOOL finished)
                                                                                    {
                                                                                        self.thumbnailImage.image = fetchedImage;
                                                                                        self.thumbnailImage.alpha = 1;
                                                                                        [loadedImageView removeFromSuperview];
                                                                                    }];
                                                                               }
            });
            
                                                                               
                                                                           }
                                                                       }];
    
    
}

@end
