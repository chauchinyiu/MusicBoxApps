//
//  PopoverView.m
//  Embark
//
//  Created by Oliver Rickard on 20/08/2012.
//
//

#import "PopoverView.h"
#import <QuartzCore/QuartzCore.h>


@interface PopoverView()
-(NSArray *) createSongList:(NSArray *)stringArray withSelectedIndex:(int) index;
-(float) findSuitablePopupViewWidth:(NSArray*) stringArray;
@end


#pragma mark Constants - Configure look/feel

// BOX GEOMETRY

//Height/width of the actual arrow
#define kArrowHeight 12.f

//padding within the box for the contentView
#define kBoxPadding 5.f

//control point offset for rounding corners of the main popover box
#define kCPOffset 1.8f

//radius for the rounded corners of the main popover box
#define kBoxRadius 5.f

//Curvature value for the arrow.  Set to 0.f to make it linear.
#define kArrowCurvature 6.f

//Minimum distance from the side of the arrow to the beginning of curvature for the box
#define kArrowHorizontalPadding 5.f

//Alpha value for the shadow behind the PopoverView
#define kShadowAlpha 0.4f

//Blur for the shadow behind the PopoverView
#define kShadowBlur 3.f;

//Box gradient bg alpha
#define kBoxAlpha 0.95f

//Padding along top of screen to allow for any nav/status bars
#define kTopMargin 10.0f

//margin along the left and right of the box
#define kHorizontalMargin 10.f

//padding along top of icons/images
#define kImageTopPadding 3.f

//padding along bottom of icons/images
#define kImageBottomPadding 3.f


// DIVIDERS BETWEEN VIEWS

//Bool that turns off/on the dividers
#define kShowDividersBetweenViews NO

//color for the divider fill
#define kDividerColor [UIColor blackColor]


// BACKGROUND GRADIENT

//bottom color white in gradient bg
//#define kGradientBottomColor [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:kBoxAlpha]
#define kGradientBottomColor [UIColor colorWithRed:232.0f/255 green:226.0f /255 blue:196.0f/255 alpha:1]
 

//top color white value in gradient bg
#define kGradientTopColor  [UIColor colorWithRed:170.0f/255 green:155.0f /255 blue:124.0f/255 alpha:1]



// TITLE GRADIENT

//bool that turns off/on title gradient
#define kDrawTitleGradient YES 

//bottom color white value in title gradient bg
//#define kGradientTitleBottomColor [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:kBoxAlpha]
#define kGradientTitleBottomColor [UIColor colorWithRed:69.0f/255 green:61.0f /255 blue:55.0f/255 alpha:1]

//top color white value in title gradient bg
//#define kGradientTitleTopColor [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:kBoxAlpha]
#define kGradientTitleTopColor [UIColor colorWithRed:59.0f/255 green:54.0f/255 blue:49.0f/255 alpha:1]

// FONTS

//normal text font
#define kTextFont [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:22.5f]

//normal text color
#define kTextColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1]

//normal text alignment
#define kTextAlignment NSTextAlignmentCenter //UITextAlignmentCenter

//title font
#define kTitleFont [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:18.0f]

//title text color
//#define kTitleColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1]
#define kTitleColor [UIColor whiteColor]




#pragma mark - Implementation

@implementation PopoverView

@synthesize subviewsArray;
@synthesize contentView;
@synthesize titleView;
@synthesize delegate;


#pragma mark - Static Methods

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withText:(NSString *)text delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withText:text];
    popoverView.delegate = delegate;
    return popoverView;
}

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withText:(NSString *)text delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withTitle:title withText:text];
    popoverView.delegate = delegate;
    return popoverView;
}

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withViewArray:(NSArray *)viewArray delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withViewArray:viewArray];
    popoverView.delegate = delegate;
    return popoverView;
}

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withViewArray:(NSArray *)viewArray delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withTitle:title withViewArray:viewArray];
    popoverView.delegate = delegate;
    return popoverView;
}


+ (PopoverView *) showMusicBoxSongListPopoverAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray withSelectedIndex:(int)index delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    NSArray *viewArray=[popoverView createSongList: stringArray withSelectedIndex:index];
    [popoverView showAtPoint:point inView:view withTitle:title withViewArray:viewArray];
    popoverView.delegate = delegate;
    return popoverView;
}

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withStringArray:(NSArray *)stringArray delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withStringArray:stringArray];
    popoverView.delegate = delegate;
    return popoverView;
}

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withTitle:title withStringArray:stringArray];
    popoverView.delegate = delegate;
    return popoverView;
}


+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withStringArray:(NSArray *)stringArray withImageArray:(NSArray *)imageArray delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withStringArray:stringArray withImageArray:imageArray];
    popoverView.delegate = delegate;
    return popoverView;
}

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray withImageArray:(NSArray *)imageArray delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withTitle:title withStringArray:stringArray withImageArray:imageArray];
    popoverView.delegate = delegate;
    return popoverView;
}

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withContentView:(UIView *)cView delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withTitle:title withContentView:cView];
    popoverView.delegate = delegate;
    return popoverView;
}

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView delegate:(id<PopoverViewDelegate>)delegate {
    PopoverView *popoverView = [[PopoverView alloc] initWithFrame:CGRectZero];
    [popoverView showAtPoint:point inView:view withContentView:cView];
    popoverView.delegate = delegate;
    return popoverView;
}

#pragma mark - View Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        self.titleView = nil;
        self.contentView = nil;
        
        showDividerRects = kShowDividersBetweenViews;
    }
    return self;
}

- (void)dealloc {
    
    if(dividerRects) {
        dividerRects = nil;
    }
    
    
}



#pragma mark - Display methods

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withText:(NSString *)text {
    UIFont *font = kTextFont;
    
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - kHorizontalMargin*4.f, 1000.f) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    textView.backgroundColor = [UIColor clearColor];
    textView.userInteractionEnabled = NO;
    [textView setNumberOfLines:0]; //This is so the label word wraps instead of cutting off the text
    textView.font = font;
    textView.textAlignment = kTextAlignment;

    textView.textColor = [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1];
    textView.text = text;
    
    [self showAtPoint:point inView:view withViewArray:[NSArray arrayWithObject:textView]];
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withText:(NSString *)text {
    UIFont *font = kTextFont;
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - kHorizontalMargin*4.f, 1000.f) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    textView.backgroundColor = [UIColor clearColor];
    textView.userInteractionEnabled = NO;
    [textView setNumberOfLines:0]; //This is so the label word wraps instead of cutting off the text
    textView.font = font;
    textView.textAlignment = kTextAlignment;
    textView.textColor = [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1];
    textView.text = text;
    
    [self showAtPoint:point inView:view withTitle:title withViewArray:[NSArray arrayWithObject:textView]];
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withViewArray:(NSArray *)viewArray {
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    
    float totalHeight = 0.f;
    float totalWidth = 0.f;
    
    int i = 0;
    
    //Position each view the first time, and identify which view has the largest width that controls
    //the sizing of the popover.
    for(UIView *view in viewArray) {
        
        view.frame = CGRectMake(0, totalHeight, view.frame.size.width, view.frame.size.height);
        
        //Only add padding below the view if it's not the last item
        float padding = (i == viewArray.count-1) ? 0 : kBoxPadding;
        
        totalHeight += view.frame.size.height + padding;
        
        if(view.frame.size.width > totalWidth) {
            totalWidth = view.frame.size.width;
        }
        
        [container addSubview:view];
        
        i++;
    }
    
    //If dividers are enabled, then we allocate the divider rect array.  This will hold NSValues
    if(kShowDividersBetweenViews) {
        dividerRects = [[NSMutableArray alloc] initWithCapacity:viewArray.count-1];
    }
    
    container.frame = CGRectMake(0, 0, totalWidth, totalHeight);
    
    i = 0;
    
    totalHeight = 0;
    
    //Now we actually change the frame element for each subview, and center the views horizontally.
    for(UIView *view in viewArray) {
        if([view autoresizingMask] == UIViewAutoresizingFlexibleWidth) {
            //Now make sure all flexible views are the full width
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, totalWidth, view.frame.size.height);
        } else {
            //If the view is not flexible width, then we position it centered in the view
            //without stretching it.
            view.frame = CGRectMake(floorf(CGRectGetMinX(boxFrame) + totalWidth*0.5f - view.frame.size.width*0.5f), view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
        
        //and if dividers are enabled, we record their position for the drawing methods
        if(kShowDividersBetweenViews && i != viewArray.count-1) {
            CGRect dividerRect = CGRectMake(view.frame.origin.x, floorf(view.frame.origin.y + view.frame.size.height + kBoxPadding*0.5f), view.frame.size.width, 0.5f);
         
            
            [((NSMutableArray *)dividerRects) addObject:[NSValue valueWithCGRect:dividerRect]];
        }
        
        //Only add padding below the view if it's not the last item
        float padding = (i == viewArray.count-1) ? 0.f : kBoxPadding;
        
        totalHeight += view.frame.size.height + padding;
        
        i++;
    }
    
    self.subviewsArray = viewArray;
    
    [self showAtPoint:point inView:view withContentView:container];
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withViewArray:(NSArray *)viewArray {
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Create a label for the title text.
    CGSize titleSize = [title sizeWithFont:kTitleFont];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, titleSize.width, titleSize.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = kTitleFont;
    titleLabel.textAlignment = kTextAlignment;
    titleLabel.textColor = kTitleColor;
    titleLabel.text = title;
    
    //Make sure that the title's label will have non-zero height.  If it has zero height, then we don't allocate any space
    //for it in the positioning of the views.
   // float titleHeightOffset =(titleSize.height > 0.f ? kBoxPadding : 0.f);
    
    float totalHeight =  titleSize.height; //  +  titleHeightOffset    ;
    float totalWidth = titleSize.width;
    
    int i = 0;
    
    //Position each view the first time, and identify which view has the largest width that controls
    //the sizing of the popover.
    for(UIView *view in viewArray) {
        
        view.frame = CGRectMake(0, totalHeight, view.frame.size.width, view.frame.size.height);
        
        //Only add padding below the view if it's not the last item.
        float padding = (i == viewArray.count-1) ? 0.f : kBoxPadding;
        
        totalHeight += view.frame.size.height + padding;
        
        if(view.frame.size.width > totalWidth) {
            totalWidth = view.frame.size.width;
        }
        
        [container addSubview:view];
        
        i++;
    }
    
    //If dividers are enabled, then we allocate the divider rect array.  This will hold NSValues
    if(kShowDividersBetweenViews) {
        dividerRects = [[NSMutableArray alloc] initWithCapacity:viewArray.count-1];
    }
    
    i = 0;
    
    for(UIView *view in viewArray) {
        if([view autoresizingMask] == UIViewAutoresizingFlexibleWidth) {
            //Now make sure all flexible views are the full width
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, totalWidth, view.frame.size.height);
        } else {
            //If the view is not flexible width, then we position it centered in the view
            //without stretching it.
            view.frame = CGRectMake(floorf(CGRectGetMinX(boxFrame) + totalWidth*0.5f - view.frame.size.width*0.5f), view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
        
        //and if dividers are enabled, we record their position for the drawing methods
        if(kShowDividersBetweenViews && i != viewArray.count-1) {
            CGRect dividerRect = CGRectMake(view.frame.origin.x, floorf(view.frame.origin.y + view.frame.size.height + kBoxPadding*0.5f), view.frame.size.width, 0.5f);
            
            [((NSMutableArray *)dividerRects) addObject:[NSValue valueWithCGRect:dividerRect]];
        }
        
        i++;
    }
    
    titleLabel.frame = CGRectMake(floorf(totalWidth*0.5f - titleSize.width*0.5f), 0, titleSize.width, titleSize.height);
    
    //Store the titleView as an instance variable if it is larger than 0 height (not an empty string)
    if(titleSize.height > 0) {
        self.titleView = titleLabel;
    }
    
    UIImageView *titleDecoLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_left_bg"]];
    UIImageView *titleDecoRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_right_bg"]];
    titleDecoLeft.center = CGPointMake(titleLabel.center.x-10 -titleLabel.frame.size.width/2 - titleDecoLeft.frame.size.width/2, titleLabel.center.y);
   titleDecoRight.center = CGPointMake(titleLabel.center.x +10+ titleLabel.frame.size.width/2 + titleDecoRight.frame.size.width/2, titleLabel.center.y);
    [container addSubview:titleLabel];
     [container addSubview:titleDecoLeft];
     [container addSubview:titleDecoRight];
    container.frame = CGRectMake(0, 0, totalWidth, totalHeight+ kBoxPadding +10);
    
    self.subviewsArray = viewArray;
    
    [self showAtPoint:point inView:view withContentView:container];
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withStringArray:(NSArray *)stringArray {
    NSMutableArray *labelArray = [[NSMutableArray alloc] initWithCapacity:stringArray.count];
    
    UIFont *font = kTextFont;
    
    for(NSString *string in stringArray) {
        CGSize textSize = [string sizeWithFont:font];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.textAlignment = kTextAlignment;
        label.textColor = kTextColor;
        label.text = string;
        label.layer.cornerRadius = 4.f;
        
        [labelArray addObject:label];
    }
    
    [self showAtPoint:point inView:view withViewArray:labelArray];
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray {
    NSMutableArray *labelArray = [[NSMutableArray alloc] initWithCapacity:stringArray.count];
    
    UIFont *font = kTextFont;
    
    for(NSString *string in stringArray) {
        CGSize textSize = [string sizeWithFont:font];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.textAlignment = kTextAlignment;
        label.textColor = kTextColor;
        label.text = string;
        label.layer.cornerRadius = 4.f;
        
        [labelArray addObject:label];
    }
    
    [self showAtPoint:point inView:view withTitle:title withViewArray:labelArray];
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withStringArray:(NSArray *)stringArray withImageArray:(NSArray *)imageArray {
    //Here we do something pretty similar to the stringArray method above.
    //We create an array of subviews that contain the image centered above a label.
    
    NSAssert((stringArray.count == imageArray.count), @"stringArray.count should equal imageArray.count");
    
    NSMutableArray *tempViewArray = [[NSMutableArray alloc] initWithCapacity:stringArray.count];
    
    UIFont *font = kTextFont;
    
    for(int i = 0; i < stringArray.count; i++) {
        NSString *string = [stringArray objectAtIndex:i];
        
        
        //First we build a label for the text to set in.
        CGSize textSize = [string sizeWithFont:font];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.textAlignment = kTextAlignment;
        label.textColor = kTextColor;
        label.text = string;
        label.layer.cornerRadius = 4.f;
        
        //Now we grab the image at the same index in the imageArray, and create
        //a UIImageView for it.
        UIImage *image = [imageArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        //Take the larger of the two widths as the width for the container
        float containerWidth = MAX(imageView.frame.size.width, label.frame.size.width);
        float containerHeight = label.frame.size.height + kImageTopPadding + kImageBottomPadding + imageView.frame.size.height;
        
        //This container will hold both the image and the label
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerWidth, containerHeight)];
        
        //Now we do the frame manipulations to put the imageView on top of the label, both centered
        imageView.frame = CGRectMake(floorf(containerWidth*0.5f - imageView.frame.size.width*0.5f), kImageTopPadding, imageView.frame.size.width, imageView.frame.size.height);
        label.frame = CGRectMake(floorf(containerWidth*0.5f - label.frame.size.width*0.5f), imageView.frame.size.height + kImageBottomPadding + kImageTopPadding, label.frame.size.width, label.frame.size.height);
        
        [containerView addSubview:imageView];
        [containerView addSubview:label];
        
        
        [tempViewArray addObject:containerView];
    }
    
    [self showAtPoint:point inView:view withViewArray:tempViewArray];
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray withImageArray:(NSArray *)imageArray {
    //This method is identical to the one above except for the last line where it calls
    //the appropriate show...withTitle:withViewArray: selector
    
    NSAssert((stringArray.count == imageArray.count), @"stringArray.count should equal imageArray.count");
    
    NSMutableArray *tempViewArray = [[NSMutableArray alloc] initWithCapacity:stringArray.count];
    
    UIFont *font = kTextFont;
    
    for(int i = 0; i < stringArray.count; i++) {
        NSString *string = [stringArray objectAtIndex:i];
        
        
        //First we build a label for the text to set in.
        CGSize textSize = [string sizeWithFont:font];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.textAlignment = kTextAlignment;
        label.textColor = kTextColor;
        label.text = string;
        label.layer.cornerRadius = 4.f;
        
        //Now we grab the image at the same index in the imageArray, and create
        //a UIImageView for it.
        UIImage *image = [imageArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        //Take the larger of the two widths as the width for the container
        float containerWidth = MAX(imageView.frame.size.width, label.frame.size.width);
        float containerHeight = label.frame.size.height + kImageTopPadding + kImageBottomPadding + imageView.frame.size.height;
        
        //This container will hold both the image and the label
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerWidth, containerHeight)];
        
        //Now we do the frame manipulations to put the imageView on top of the label, both centered
        imageView.frame = CGRectMake(floorf(containerWidth*0.5f - imageView.frame.size.width*0.5f), kImageTopPadding, imageView.frame.size.width, imageView.frame.size.height);
        label.frame = CGRectMake(floorf(containerWidth*0.5f - label.frame.size.width*0.5f), imageView.frame.size.height + kImageBottomPadding + kImageTopPadding, label.frame.size.width, label.frame.size.height);
        
        [containerView addSubview:imageView];
        [containerView addSubview:label];
        
        
        [tempViewArray addObject:containerView];
    }
    
    [self showAtPoint:point inView:view withTitle:title withViewArray:tempViewArray];
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withContentView:(UIView *)cView {
    [self showAtPoint:point inView:view withTitle:title withViewArray:[NSArray arrayWithObject:cView]];
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView {
    
    //NSLog(@"point:%f,%f", point.x, point.y);
    
    self.contentView = cView;
    
    parentView = view;
    
    //Locate the view at the top fo the view stack.
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    topView = [[window subviews] objectAtIndex:0];
    
    CGPoint topPoint = [topView convertPoint:point fromView:view];
    
    arrowPoint = topPoint;
    
    //NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);
    
    CGRect topViewBounds = topView.bounds;
    
    float contentHeight = contentView.frame.size.height;
    float contentWidth = contentView.frame.size.width;
    
    float padding = kBoxPadding;
    
    float boxHeight = contentHeight + 2.f*padding;
    float boxWidth = contentWidth + 2.f*padding;
    
    float xOrigin = 0.f;
    
    //Make sure the arrow point is within the drawable bounds for the popover.
    if(arrowPoint.x + kArrowHeight > topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding) {//Too far to the right
        arrowPoint.x = topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding - kArrowHeight;
        //NSLog(@"Correcting Arrow Point because it's too far to the right");
    } else if(arrowPoint.x - kArrowHeight < kHorizontalMargin + kBoxRadius + kArrowHorizontalPadding) {//Too far to the left
        arrowPoint.x = kHorizontalMargin + kArrowHeight + kBoxRadius + kArrowHorizontalPadding;
        //NSLog(@"Correcting Arrow Point because it's too far to the left");
    }
    
    //NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);
    
    xOrigin = floorf(arrowPoint.x - boxWidth*0.5f);
    
    //Check to see if the centered xOrigin value puts the box outside of the normal range.
    if(xOrigin < CGRectGetMinX(topViewBounds) + kHorizontalMargin) {
        xOrigin = CGRectGetMinX(topViewBounds) + kHorizontalMargin;
    } else if(xOrigin + boxWidth > CGRectGetMaxX(topViewBounds) - kHorizontalMargin) {
        //Check to see if the positioning puts the box out of the window towards the left
        xOrigin = CGRectGetMaxX(topViewBounds) - kHorizontalMargin - boxWidth;
    }
    
    float arrowHeight = kArrowHeight;
    
    float topPadding = kTopMargin;
    
    above = YES;
    
    if(topPoint.y - contentHeight - arrowHeight - topPadding < CGRectGetMinY(topViewBounds)) {
        //Position below because it won't fit above.
        above = NO;
        
        boxFrame = CGRectMake(xOrigin, arrowPoint.y + arrowHeight, boxWidth, boxHeight);
    } else {
        //Position above.
        above = YES;
        
        boxFrame = CGRectMake(xOrigin, arrowPoint.y - arrowHeight - boxHeight, boxWidth, boxHeight);
    }
    
    //NSLog(@"boxFrame:(%f,%f,%f,%f)", boxFrame.origin.x, boxFrame.origin.y, boxFrame.size.width, boxFrame.size.height);
    
    CGRect contentFrame = CGRectMake(boxFrame.origin.x + padding, boxFrame.origin.y + padding, contentWidth, contentHeight);
    contentView.frame = contentFrame;
    [self addSubview:contentView];
    
    //We set the anchorPoint here so the popover will "grow" out of the arrowPoint specified by the user.
    //You have to set the anchorPoint before setting the frame, because the anchorPoint property will
    //implicitly set the frame for the view, which we do not want.
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / topViewBounds.size.width, arrowPoint.y / topViewBounds.size.height);
    self.frame = topViewBounds;
    [self setNeedsDisplay];
    
    [topView addSubview:self];
    
    //Add a tap gesture recognizer to the large invisible view (self), which will detect taps anywhere on the screen.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tap.cancelsTouchesInView = NO; // Allow touches through to a UITableView or other touchable view, as suggested by Dimajp.
    [self addGestureRecognizer:tap];
    
    self.userInteractionEnabled = YES;
    
    //Make the view small and transparent before animation
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    //animate into full size
    //First stage animates to 1.05x normal size, then second stage animates back down to 1x size.
    //This two-stage animation creates a little "pop" on open.
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationCurveEaseInOut animations:^{
        self.alpha = 1.f;
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)layoutAtPoint:(CGPoint)point inView:(UIView *)view{
    
    self.alpha = 0.f;
    
    CGPoint topPoint = [topView convertPoint:point fromView:view];
    
    arrowPoint = topPoint;
    
    //NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);
    
    CGRect topViewBounds = topView.bounds;
    
    float contentHeight = contentView.frame.size.height;
    float contentWidth = contentView.frame.size.width;
    
    float padding = kBoxPadding;
    
    float boxHeight = contentHeight + 2.f*padding;
    float boxWidth = contentWidth + 2.f*padding;
    
    float xOrigin = 0.f;
    
    //Make sure the arrow point is within the drawable bounds for the popover.
    if(arrowPoint.x + kArrowHeight > topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding) {//Too far to the right
        arrowPoint.x = topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding - kArrowHeight;
        //NSLog(@"Correcting Arrow Point because it's too far to the right");
    } else if(arrowPoint.x - kArrowHeight < kHorizontalMargin + kBoxRadius + kArrowHorizontalPadding) {//Too far to the left
        arrowPoint.x = kHorizontalMargin + kArrowHeight + kBoxRadius + kArrowHorizontalPadding;
        //NSLog(@"Correcting Arrow Point because it's too far to the left");
    }
    
    //NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);
    
    xOrigin = floorf(arrowPoint.x - boxWidth*0.5f);
    
    //Check to see if the centered xOrigin value puts the box outside of the normal range.
    if(xOrigin < CGRectGetMinX(topViewBounds) + kHorizontalMargin) {
        xOrigin = CGRectGetMinX(topViewBounds) + kHorizontalMargin;
    } else if(xOrigin + boxWidth > CGRectGetMaxX(topViewBounds) - kHorizontalMargin) {
        //Check to see if the positioning puts the box out of the window towards the left
        xOrigin = CGRectGetMaxX(topViewBounds) - kHorizontalMargin - boxWidth;
    }
    
    float arrowHeight = kArrowHeight;
    
    float topPadding = kTopMargin;
    
    above = YES;
    
    if(topPoint.y - contentHeight - arrowHeight - topPadding < CGRectGetMinY(topViewBounds)) {
        //Position below because it won't fit above.
        above = NO;
        
        boxFrame = CGRectMake(xOrigin, arrowPoint.y + arrowHeight, boxWidth, boxHeight);
    } else {
        //Position above.
        above = YES;
        
        boxFrame = CGRectMake(xOrigin, arrowPoint.y - arrowHeight - boxHeight, boxWidth, boxHeight);
    }
    
    //NSLog(@"boxFrame:(%f,%f,%f,%f)", boxFrame.origin.x, boxFrame.origin.y, boxFrame.size.width, boxFrame.size.height);
    
    CGRect contentFrame = CGRectMake(boxFrame.origin.x + padding, boxFrame.origin.y + padding, contentWidth, contentHeight);
    contentView.frame = contentFrame;
    
    //We set the anchorPoint here so the popover will "grow" out of the arrowPoint specified by the user.
    //You have to set the anchorPoint before setting the frame, because the anchorPoint property will
    //implicitly set the frame for the view, which we do not want.
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / topViewBounds.size.width, arrowPoint.y / topViewBounds.size.height);
    self.frame = topViewBounds;
    [self setNeedsDisplay];
    
    self.userInteractionEnabled = YES;
    
    //animate into full size
    //First stage animates to 1.05x normal size, then second stage animates back down to 1x size.
    //This two-stage animation creates a little "pop" on open.
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationCurveEaseInOut animations:^{
        self.alpha = 1.f;
    } completion:nil];
}



#pragma mark - Activity Indicator

//Animates in a progress indicator, and removes
- (void)showActivityIndicatorWithMessage:(NSString *)msg {
    if([titleView isKindOfClass:[UILabel class]]) {
        ((UILabel *)titleView).text = msg;
    }
    
    if(subviewsArray && (subviewsArray.count > 0)) {
        [UIView animateWithDuration:0.2f animations:^{
            for(UIView *view in subviewsArray) {
                view.alpha = 0.f;
            }
        }];
        
        if(showDividerRects) {
            showDividerRects = NO;
            [self setNeedsDisplay];
        }
    }
    
    if(activityIndicator) {
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
    }
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(CGRectGetMidX(contentView.bounds) - 10.f, CGRectGetMidY(contentView.bounds) - 10.f + 20.f, 20.f, 20.f);
    [contentView addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
}

- (void)hideActivityIndicatorWithMessage:(NSString *)msg {
    if([titleView isKindOfClass:[UILabel class]]) {
        ((UILabel *)titleView).text = msg;
    }
    
    [activityIndicator stopAnimating];
    [UIView animateWithDuration:0.1f animations:^{
        activityIndicator.alpha = 0.f;
    } completion:^(BOOL finished) {
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
    }];
}

- (void)showImage:(UIImage *)image withMessage:(NSString *)msg {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.alpha = 0.f;
    imageView.frame = CGRectMake(floorf(CGRectGetMidX(contentView.bounds) - image.size.width*0.5f), floorf(CGRectGetMidY(contentView.bounds) - image.size.height*0.5f + ((self.titleView) ? 20 : 0.f)), image.size.width, image.size.height);
    imageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [contentView addSubview:imageView];
    
    if(subviewsArray && (subviewsArray.count > 0)) {
        [UIView animateWithDuration:0.2f animations:^{
            for(UIView *view in subviewsArray) {
                view.alpha = 0.f;
            }
        }];
        
        if(showDividerRects) {
            showDividerRects = NO;
            [self setNeedsDisplay];
        }
    }
    
    if(msg) {
        if([titleView isKindOfClass:[UILabel class]]) {
            ((UILabel *)titleView).text = msg;
        }
    }
    
    [UIView animateWithDuration:0.2f delay:0.2f options:UIViewAnimationCurveEaseOut animations:^{
        imageView.alpha = 1.f;
        imageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //[imageView removeFromSuperview];
    }];
}

- (void)showError {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    imageView.alpha = 0.f;
    imageView.frame = CGRectMake(CGRectGetMidX(contentView.bounds) - 20.f, CGRectGetMidY(contentView.bounds) - 20.f + ((self.titleView) ? 20 : 0.f), 40.f, 40.f);
    imageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [contentView addSubview:imageView];
    
    if(subviewsArray && (subviewsArray.count > 0)) {
        [UIView animateWithDuration:0.1f animations:^{
            for(UIView *view in subviewsArray) {
                view.alpha = 0.f;
            }
        }];
        
        if(showDividerRects) {
            showDividerRects = NO;
            [self setNeedsDisplay];
        }
    }
    
    [UIView animateWithDuration:0.1f delay:0.1f options:UIViewAnimationCurveEaseOut animations:^{
        imageView.alpha = 1.f;
        imageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //[imageView removeFromSuperview];
    }];
    
}

- (void)showSuccess {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    imageView.alpha = 0.f;
    imageView.frame = CGRectMake(CGRectGetMidX(contentView.bounds) - 20.f, CGRectGetMidY(contentView.bounds) - 20.f + ((self.titleView) ? 20 : 0.f), 40.f, 40.f);
    imageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [contentView addSubview:imageView];
    
    if(subviewsArray && (subviewsArray.count > 0)) {
        [UIView animateWithDuration:0.1f animations:^{
            for(UIView *view in subviewsArray) {
                view.alpha = 0.f;
            }
        }];
        
        if(showDividerRects) {
            showDividerRects = NO;
            [self setNeedsDisplay];
        }
    }
    
    [UIView animateWithDuration:0.1f delay:0.1f options:UIViewAnimationCurveEaseOut animations:^{
        imageView.alpha = 1.f;
        imageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //[imageView removeFromSuperview];
    }];
    
}



#pragma mark - User Interaction

- (void)tapped:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:contentView];
    
    //NSLog(@"point:(%f,%f)", point.x, point.y);
    
    BOOL found = NO;
    
    //NSLog(@"subviewsArray:%@", subviewsArray);
    
    for(int i = 0; i < subviewsArray.count && !found; i++) {
        UIView *view = [subviewsArray objectAtIndex:i];
        
        //NSLog(@"Rect:(%f,%f,%f,%f)", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        
        if(CGRectContainsPoint(view.frame, point)) {
            //The tap was within this view, so we notify the delegate, and break the loop.
            
            found = YES;
            
            //NSLog(@"Tapped subview:%d", i);
            
            if([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)view;
                label.backgroundColor = [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1];
                label.textColor = [UIColor whiteColor];
                
                //                [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.05f];
            }
            
            if(delegate && [delegate respondsToSelector:@selector(popoverView:didSelectItemAtIndex:)]) {
                [delegate popoverView:self didSelectItemAtIndex:i];
            }
            
            break;
        }
    }
    
    if(!found && CGRectContainsPoint(contentView.bounds, point)) {
        found = YES;
        //NSLog(@"popover box contains point, ignoring user input");
    }
    
    if(!found) {
        [self dismiss];
    }
    
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.1f;
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(popoverViewDidDismiss:)]) {
            [delegate popoverViewDidDismiss:self];
        }
    }];
}

- (void)animateRotationToNewPoint:(CGPoint)point inView:(UIView *)view withDuration:(NSTimeInterval)duration {
    [self layoutAtPoint:point inView:view];
    
}



#pragma mark - Drawing Routines

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Build the popover path
    CGRect frame = boxFrame;
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    float radius = kBoxRadius; //Radius of the curvature.
    
    float cpOffset = kCPOffset; //Control Point Offset.  Modifies how "curved" the corners are.
    
    
    /*
     LT2            RT1
     LT1⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝RT2
     |               |
     |    popover    |
     |               |
     LB2⌞_______________⌟RB1
     LB1           RB2
     
     Traverse rectangle in clockwise order, starting at LT1
     L = Left
     R = Right
     T = Top
     B = Bottom
     1,2 = order of traversal for any given corner
     
     */
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + radius)];//LT1
    [popoverPath addCurveToPoint:CGPointMake(xMin + radius, yMin) controlPoint1:CGPointMake(xMin, yMin + radius - cpOffset) controlPoint2:CGPointMake(xMin + radius - cpOffset, yMin)];//LT2
    
    //If the popover is positioned below (!above) the arrowPoint, then we know that the arrow must be on the top of the popover.
    //In this case, the arrow is located between LT2 and RT1
    if(!above) {
        [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin) controlPoint2:arrowPoint];//actual arrow point
        [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
    }
    
    [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];//RT1
    [popoverPath addCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint1:CGPointMake(xMax - radius + cpOffset, yMin) controlPoint2:CGPointMake(xMax, yMin + radius - cpOffset)];//RT2
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];//RB1
    [popoverPath addCurveToPoint:CGPointMake(xMax - radius, yMax) controlPoint1:CGPointMake(xMax, yMax - radius + cpOffset) controlPoint2:CGPointMake(xMax - radius + cpOffset, yMax)];//RB2
    
    //If the popover is positioned above the arrowPoint, then we know that the arrow must be on the bottom of the popover.
    //In this case, the arrow is located somewhere between LB1 and RB2
    if(above) {
        [popoverPath addLineToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMax)];//right side
        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMax) controlPoint2:arrowPoint];//arrow point
        [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMax) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMax)];
    }
    
    [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];//LB1
    [popoverPath addCurveToPoint:CGPointMake(xMin, yMax - radius) controlPoint1:CGPointMake(xMin + radius - cpOffset, yMax) controlPoint2:CGPointMake(xMin, yMax - radius + cpOffset)];//LB2
    [popoverPath closePath];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:kShadowAlpha];
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = kShadowBlur;
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)kGradientTopColor.CGColor,
                               (id)kGradientBottomColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    
    //These floats are the top and bottom offsets for the gradient drawing so the drawing includes the arrows.
    float bottomOffset = (above ? kArrowHeight : 0.f);
    float topOffset = (!above ? kArrowHeight : 0.f);
    
    //Draw the actual gradient and shadow.
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [popoverPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) + bottomOffset), 0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    
    //Draw the title background
    if(kDrawTitleGradient) {
        //Calculate the height of the title bg
        float titleBGHeight = -1;
        
        //NSLog(@"titleView:%@", titleView);
        
        if(titleView != nil) {
            titleBGHeight = kBoxPadding*2.f + titleView.frame.size.height;
        }
        
        
        //Draw the title bg height, but only if we need to.
        if(titleBGHeight > 0.f) {
            CGPoint startingPoint = CGPointMake(xMin, yMin + titleBGHeight);
            CGPoint endingPoint = CGPointMake(xMax, yMin + titleBGHeight);
            
            UIBezierPath *titleBGPath = [UIBezierPath bezierPath];
            [titleBGPath moveToPoint:startingPoint];
            [titleBGPath addLineToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + radius)];//LT1
            [titleBGPath addCurveToPoint:CGPointMake(xMin + radius, yMin) controlPoint1:CGPointMake(xMin, yMin + radius - cpOffset) controlPoint2:CGPointMake(xMin + radius - cpOffset, yMin)];//LT2
            
            //If the popover is positioned below (!above) the arrowPoint, then we know that the arrow must be on the top of the popover.
            //In this case, the arrow is located between LT2 and RT1
            if(!above) {
                [titleBGPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
                [titleBGPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin) controlPoint2:arrowPoint];//actual arrow point
                [titleBGPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
            }
            
            [titleBGPath addLineToPoint:CGPointMake(xMax - radius, yMin)];//RT1
            [titleBGPath addCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint1:CGPointMake(xMax - radius + cpOffset, yMin) controlPoint2:CGPointMake(xMax, yMin + radius - cpOffset)];//RT2
            [titleBGPath addLineToPoint:endingPoint];
            [titleBGPath addLineToPoint:startingPoint];
            [titleBGPath closePath];
            
            //// General Declarations
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            //// Gradient Declarations
            NSArray* gradientColors = [NSArray arrayWithObjects:
                                       (id)kGradientTitleTopColor.CGColor,
                                       (id)kGradientTitleBottomColor.CGColor, nil];
            CGFloat gradientLocations[] = {0, 1};
            CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
            
            
            //These floats are the top and bottom offsets for the gradient drawing so the drawing includes the arrows.
            float topOffset = (!above ? kArrowHeight : 0.f);
            
            //Draw the actual gradient and shadow.
            CGContextSaveGState(context);
            CGContextBeginTransparencyLayer(context, NULL);
            [titleBGPath addClip];
            CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) + titleBGHeight), 0);
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
            
            UIBezierPath *dividerLine = [UIBezierPath bezierPathWithRect:CGRectMake(startingPoint.x, startingPoint.y, (endingPoint.x - startingPoint.x), 0.5f)];
            [[UIColor colorWithRed:0.741 green:0.741 blue:0.741 alpha:0.5f] setFill];
            [dividerLine fill];
            
            //// Cleanup
            CGGradientRelease(gradient);
            CGColorSpaceRelease(colorSpace);
        }
    }
    
    
    
    //Draw the divider rects if we need to
    {
        if(kShowDividersBetweenViews && showDividerRects) {
            if(dividerRects && dividerRects.count > 0) {
                for(NSValue *value in dividerRects) {
                    CGRect rect = value.CGRectValue;
                    rect.origin.x += contentView.frame.origin.x;
                    rect.origin.y += contentView.frame.origin.y;
                    
                    UIBezierPath *dividerPath = [UIBezierPath bezierPathWithRect:rect];
                    [kDividerColor setFill];
                    [dividerPath fill];
                }
            }
        }
    }
}


// Music box customized needs

-(NSArray *) createSongList:(NSArray *)stringArray withSelectedIndex:(int) index{
    NSMutableArray *viewsarray =  [[NSMutableArray alloc] init];
    float width = [self findSuitablePopupViewWidth: stringArray];
    for(int i=0; i<[stringArray count] ; i++){
        UIView *tmpview = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , width+ 2*kBoxPadding, 30)];
        if(i==index){
            if(_redpin == nil){
                _redpin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_pin"]];
            }
          [_redpin setFrame:CGRectMake(-kBoxPadding, tmpview.center.y, _redpin.frame.size.width, _redpin.frame.size.width)];
           [tmpview addSubview:_redpin];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 ,width, 25)];
        [label setText: [stringArray objectAtIndex:i]];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;//Dynamic
        label.textColor = kTextColor;
        label.backgroundColor = [UIColor clearColor];
        label.font = kTextFont;
        [label setFrame:CGRectMake(10, tmpview.center.y, label.frame.size.width, label.frame.size.height)];
        
        UIView *baseline = [[UIView alloc] initWithFrame:CGRectMake(0, 10+tmpview.frame.size.height, width+kBoxPadding, 1)];
        [baseline setBackgroundColor:[UIColor brownColor]];
        [tmpview addSubview:baseline];
   
        [tmpview addSubview:label];

        
        [viewsarray addObject:tmpview];
    }
    return viewsarray;
    
}

-(float) findSuitablePopupViewWidth:(NSArray*) stringArray{
    
    float result = 0;
    for(int i=0; i<[stringArray count] ; i++){
        CGSize theStringSize = [[stringArray objectAtIndex:i] sizeWithFont:kTextFont
                                   constrainedToSize:CGSizeMake(300, 25) 
                                       lineBreakMode:NSLineBreakByWordWrapping];
        if(theStringSize.width >result){
            result = theStringSize.width;
            NSLog(@" the length %f",result);
        }
    }
    return result;
}

-(void) moveRedPinAnimationfromIndex:(int)from  toIndex:(int)to{
    [UIView animateWithDuration:0.50f delay:0.0 options:0
                     animations:^{
                         int i =  to -from;
                         float tmpviewheight = 30.0f+ kBoxPadding;
                        
                         _redpin.center = CGPointMake(_redpin.center.x, _redpin.center.y + i*tmpviewheight);
                     }
                     completion:nil];

}
 

@end
