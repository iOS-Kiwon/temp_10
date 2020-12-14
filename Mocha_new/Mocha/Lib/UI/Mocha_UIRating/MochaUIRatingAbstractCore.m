//
//  MochaUIRatingAbstractCore.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 10. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "MochaUIRatingAbstractCore.h"

@implementation MochaUIRatingAbstractCore
 
@synthesize rating;
@synthesize onImage;
@synthesize halfOnImage;
@dynamic offImage;

-(void) setOffImage:(UIImage *) image {
	offImage = image;
    
	// Setup common values.
	if (offImage != nil) {
		imageWidth = (int)offImage.size.width;
		NSLog(@"Image width: %i", imageWidth);
        
		// Calculate a fuzz factor around the users touch position.
		zeroAreaWidth = [self calcZeroAreaWidth];
		NSLog(@"Zero area width: %i", zeroAreaWidth);
	}
}

-(UIImage*) offImage {
	return offImage;
}

-(void) drawImageAtIndex:(int) index{
    
    
	[[self imageForIndex:index] drawAtPoint:CGPointMake(index * imageWidth, 0)];
}

-(float) calcNewRatingFromTouchX:(int) touchX{
	self.rating = [self calcRatingFromTouchX:touchX];
	return self.rating;
}

-(int) calcZeroAreaWidth {
	return imageWidth / 3;
}

-(UIImage *) imageForIndex:(int) index {
	if (index < self.rating) {
		NSLog(@"Drawing full rating at %i", index * imageWidth);
		return self.onImage;
	} else {
		NSLog(@"Drawing inactive rating at %i", index * imageWidth);
		return self.offImage;
	}
}
 
//별 한개이상표시되야하기에 1
-(float) calcRatingFromTouchX:(int) touchX{
	return touchX < zeroAreaWidth ? 1 : ceilf(((float)touchX + 1) / (float)imageWidth);
}

-(NSString *) formattedRating{
    
	return [NSString stringWithFormat:@"%i", (int)self.rating];
}

- (void)dealloc {
	// Use DC_DEALLOC to avoid setter.
	self.offImage = nil;
}


@end
