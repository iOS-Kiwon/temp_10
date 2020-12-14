//
//  MochaUIRating.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 10. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//
 
#import "MochaUIRating.h"
#import "MochaUIRatingAbstractCore.h"
 
@interface MochaUIRating ()
- (void) setDefaults;
- (void) calculateRatingAtX:(float) x;
- (IBAction)tapGesture:(UITapGestureRecognizer *)sender;
- (IBAction)swipeGesture:(UIPanGestureRecognizer *)sender;
@end

@implementation MochaUIRating

@dynamic rating;
@dynamic offRatingImage;
@dynamic onRatingImage;
@dynamic halfRatingImage;

@synthesize iconCount;

@synthesize delegate;
@synthesize scale;



#pragma mark Dynamic properties

- (void) setRating:(float) aRating {
	
    
	int maxValue = iconCount * (scale == MochaRatingScaleWhole ? 1: 2);
	if (aRating > maxValue) {
		NSLog(@"Passed rating %f greater than max rating %i, resetting to max.", aRating, maxValue);
		aRating = maxValue;
	} else if (aRating < 0) {
		//Check that the rating is not below zero.
		NSLog(@"Passed rating %f less than  zero, resetting to zero.", aRating);
		aRating = 0;
	}
	
	[scalecore setRating:aRating];
	NSLog(@"Triggering a refresh");
	[self setNeedsDisplay];
}

- (float) rating {
	return [scalecore rating];
}

- (void) setOffRatingImage:(UIImage *) image {
	scalecore.offImage = image;
	[self sizeToFit];
}

- (UIImage *) offRatingImage {
	return scalecore.offImage;
}

- (void) setOnRatingImage:(UIImage *) image {
	scalecore.onImage = image;
}

- (UIImage *) onRatingImage {
	return scalecore.onImage;
}

- (void) setHalfRatingImage:(UIImage *) image {
	scalecore.halfOnImage = image;
}

- (UIImage *) halfRatingImage {
	return scalecore.halfOnImage;
}

#pragma mark -
#pragma mark Property setter overrides

- (void) setIconCount:(int) count {
	 
	if (count == iconCount ) {
		return;
	}
	
	// Range check.
	if (count < 3 || count > 5) {
		NSException * myException = [NSException
                                     exceptionWithName:@"IconCountOutOfBoundsException"
                                     reason:@"An attempt was made to set iconCount to a value <3 or >5."
                                     userInfo:nil];
		@throw myException;
	}
	
	iconCount = count;
	[self sizeToFit];
}

- (void) setScale:(MochaRatingScale) aScale {
	
	//Store
	scale = aScale;
	
	// Get the new strategy.
	NSObject<MochaUIRatingScaleCore> * newStrategy = nil;

			newStrategy = [[MochaUIRatingAbstractCore alloc] init];
		 	
	// Transfer properties.
	newStrategy.offImage = scalecore.offImage;
	newStrategy.onImage = scalecore.onImage;
	newStrategy.halfOnImage = scalecore.halfOnImage;
	[newStrategy setRating:scalecore.rating];

    if (scalecore != nil) {
		scalecore = nil;  
	}
    scalecore = newStrategy;
}

#pragma mark -
#pragma mark Constructors

- (id) initWithFrame:(CGRect) frame {
	NSLog(@"initWithFrame:");
	self = [super initWithFrame:frame];
	if (self) {
		[self setDefaults];
	}
	return self;
}

- (id) initWithCoder:(NSCoder *) decoder {
	NSLog(@"initWithCoder:");
	self = [super initWithCoder:decoder];
	if (self) {
		[self setDefaults];
	}
	return self;
}

- (void) setDefaults {
	
    
	scalecore = [[MochaUIRatingAbstractCore alloc] init];
    
    //3보다크고 6보다 작아야함.
	self.iconCount = 5;
	
	NSLog(@"Adding gesture recognisers");
	UITapGestureRecognizer * tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
	[self addGestureRecognizer:tapRecogniser];
	UIPanGestureRecognizer * swipeRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
	[self addGestureRecognizer:swipeRecogniser];
}

#pragma mark -
#pragma mark Internal messages

- (CGSize) sizeThatFits:(CGSize) size {
	CGSize newSize = CGSizeMake(self.offRatingImage.size.width * self.iconCount, self.offRatingImage.size.height);
	//NSLog(@"sizeThatFits: returning %f x %f", newSize.width, newSize.height);
	return newSize;
}

- (void) calculateRatingAtX:(float) x {
	NSLog(@"x: %f", x);
	
	// Store the current touch X and handle when it's out of the controls range.
	lastTouchX = (int) x;
	lastTouchX = fmin(self.frame.size.width - 1, lastTouchX);
	lastTouchX = fmax(0, lastTouchX);
	NSLog(@"lastTouchX: %i", lastTouchX);
	
	float oldRating = [scalecore rating];
	float newRating = [scalecore calcNewRatingFromTouchX:lastTouchX];
    NSLog(@"변경 rating: %f ======= %f", oldRating, newRating);
	// Only trigger display updates if the rating has changed.
	if (oldRating != newRating) {
		[self setNeedsDisplay];
		
		// Notify the delegate.
		if (self.delegate != nil) {
			NSLog(@"Notifying delegate that rating has changed");
			[self.delegate DidChangePoint:self];
		}
	}
	
}

#pragma mark -
#pragma mark Interactions

- (IBAction) tapGesture:(UITapGestureRecognizer *)sender {
	NSLog(@"Tap gesture handler firing");
	[self calculateRatingAtX:[sender locationInView:self].x];
}

- (IBAction) swipeGesture:(UIPanGestureRecognizer *)sender {
	NSLog(@"Swipe gesture handler firing, state: %li", (unsigned long)sender.state);
	
	// Switch based on the state.
	[self calculateRatingAtX:[sender locationInView:self].x];
//	[self.bubble setValue:[scaleStrategy formattedRating]];
	switch (sender.state) {
			
		case UIGestureRecognizerStateBegan:
			NSLog(@"Starting touch event");
		//	[self.bubble positionAtView:sender.view offset:[sender locationInView:self].x];
	//		self.bubble.hidden = NO;
			break;
		case UIGestureRecognizerStateChanged:
			NSLog(@"Continuing touch event");
	//		[self.bubble positionAtView:sender.view offset:[sender locationInView:self].x];
			break;
		default:
			// Ended.
			NSLog(@"Ending touch event");
	//		self.bubble.hidden = YES;
			break;
	}
	
}

#pragma mark -
#pragma mark Drawing

- (void) drawRect:(CGRect) rect {
	NSLog(@"Drawing rating control: %@", self);
	for (int i = 0; i < self.iconCount; i++) {
		[scalecore drawImageAtIndex:i];
	}
}

- (void) dealloc {
	self.offRatingImage = nil;
	self.onRatingImage = nil;
	self.halfRatingImage = nil;
	self.delegate = nil;
    
    if (scalecore != nil) {
		scalecore = nil;
	}

	//DC_DEALLOC(bubble);
	//DC_DEALLOC(scaleStrategy);
}

@end
