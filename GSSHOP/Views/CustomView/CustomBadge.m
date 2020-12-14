/*
 CustomBadge.m
 
 *** Description: ***
 With this class you can draw a typical iOS badge indicator with a custom text on any view.
 Please use the allocator customBadgeWithString to create a new badge.
 In this version you can modfiy the color inside the badge (insetColor),
 the color of the frame (frameColor), the color of the text and you can
 tell the class if you want a frame around the badge.
 
 *** License & Copyright ***
 Created by Sascha Marc Paulus www.spaulus.com on 04/2011. Version 2.0
 This tiny class can be used for free in private and commercial applications.
 Please feel free to modify, extend or distribution this class.
 If you modify it: Please send me your modified version of the class.
 A commercial distribution of this class is not allowed.
 
 I would appreciate if you could refer to my website www.spaulus.com if you use this class.
 
 If you have any questions please feel free to contact me (open@spaulus.com).
 */
#import "CustomBadge.h"

@interface CustomBadge()

@property (nonatomic, assign)   CGFloat     defaultWidthHeight;

@end


@implementation CustomBadge
@synthesize badgeBackimg;
@synthesize badgeLabel;
@synthesize badgeText;
@synthesize badgeTextColor;
@synthesize badgeInsetColor;
@synthesize badgeFrameColor;
@synthesize badgeFrame;
@synthesize badgeCornerRoundness;
@synthesize badgeScaleFactor;
@synthesize badgeShining;
@synthesize defaultWidthHeight;


- (id) initWithString:(NSString *)badgeString
{
    self = [super init];
    if(self!=nil) {
        
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        badgeString = [badgeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        self.frame = CGRectMake(0, 0, 20, 20);
        self.badgeBackimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"custom_badge_bg.png"]];
        self.badgeBackimg.frame = self.frame;
        
        
        [self addSubview:self.badgeBackimg];
        
        

        
        self.badgeText = badgeString;
        self.badgeTextColor = [Mocha_Util getColor:@"ffffff"];
        
        self.badgeLabel = [[UILabel alloc] init];
        self.badgeLabel.text = self.badgeText;
        self.badgeLabel.textAlignment = NSTextAlignmentCenter;
        
        self.badgeLabel.font = [UIFont boldSystemFontOfSize:([badgeString length] == 1)?12:10];
        self.badgeLabel.backgroundColor = [UIColor clearColor];
        self.badgeLabel.textColor = self.badgeTextColor;
        [self.badgeLabel setFrame:self.frame];
        [self addSubview:self.badgeLabel];
    }
    return self;
}

// Creates a Badge with a given Text
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString
{
    return [[self alloc] initWithString:badgeString];
}

@end
