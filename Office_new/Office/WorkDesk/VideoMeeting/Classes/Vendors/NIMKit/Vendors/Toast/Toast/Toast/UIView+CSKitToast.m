//
//  UIView+Toast.m
//  Toast
//
//  Copyright 2014 Charles Scalesse.
//


#import "UIView+CSKitToast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSKitToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat CSKitToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat CSKitToastHorizontalPadding   = 10.0;
static const CGFloat CSKitToastVerticalPadding     = 10.0;
static const CGFloat CSKitToastCornerRadius        = 10.0;
static const CGFloat CSKitToastOpacity             = 0.8;
static const CGFloat CSKitToastFontSize            = 16.0;
static const CGFloat CSKitToastMaxTitleLines       = 0;
static const CGFloat CSKitToastMaxMessageLines     = 0;
static const NSTimeInterval CSKitToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat CSKitToastShadowOpacity       = 0.8;
static const CGFloat CSKitToastShadowRadius        = 6.0;
static const CGSize  CSKitToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    CSKitToastDisplayShadow       = YES;

// display duration
static const NSTimeInterval CSKitToastDefaultDuration  = 3.0;

// image view size
static const CGFloat CSKitToastImageViewWidth      = 80.0;
static const CGFloat CSKitToastImageViewHeight     = 80.0;

// activity
static const CGFloat CSKitToastActivityWidth       = 100.0;
static const CGFloat CSKitToastActivityHeight      = 100.0;
static const NSString * CSKitToastActivityDefaultPosition = @"center";

// interaction
static const BOOL CSKitToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * CSKitToastTimerKey         = @"CSToastTimerKey";
static const NSString * CSKitToastActivityViewKey  = @"CSToastActivityViewKey";
static const NSString * CSKitToastTapCallbackKey   = @"CSToastTapCallbackKey";

// positions
NSString * const CSKitToastPositionTop             = @"top";
NSString * const CSKitToastPositionCenter          = @"center";
NSString * const CSKitToastPositionBottom          = @"bottom";

@interface UIView (CSKitToastPrivate)

- (void)CSKit_hideToast:(UIView *)toast;
- (void)CSKit_toastTimerDidFinish:(NSTimer *)timer;
- (void)CSKit_handleToastTapped:(UITapGestureRecognizer *)recognizer;
- (CGPoint)CSKit_centerPointForPosition:(id)position withToast:(UIView *)toast;
- (UIView *)CSKit_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;
- (CGSize)CSKit_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end


@implementation UIView (CSKitToast)

#pragma mark - Toast Methods

- (void)CSKit_makeToast:(NSString *)message {
    [self CSKit_makeToast:message duration:CSKitToastDefaultDuration position:CSKitToastPositionCenter];
}

- (void)CSKit_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    UIView *toast = [self CSKit_viewForMessage:message title:nil image:nil];
    [self CSKit_showToast:toast duration:duration position:position];
}

- (void)CSKit_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title {
    UIView *toast = [self CSKit_viewForMessage:message title:title image:nil];
    [self CSKit_showToast:toast duration:duration position:position];
}

- (void)CSKit_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position image:(UIImage *)image {
    UIView *toast = [self CSKit_viewForMessage:message title:nil image:image];
    [self CSKit_showToast:toast duration:duration position:position];  
}

- (void)CSKit_makeToast:(NSString *)message duration:(NSTimeInterval)duration  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self CSKit_viewForMessage:message title:title image:image];
    [self CSKit_showToast:toast duration:duration position:position];
}

- (void)CSKit_showToast:(UIView *)toast {
    [self CSKit_showToast:toast duration:CSKitToastDefaultDuration position:nil];
}


- (void)CSKit_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position {
    [self CSKit_showToast:toast duration:duration position:position tapCallback:nil];
    
}


- (void)CSKit_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position
      tapCallback:(void(^)(void))tapCallback
{
    toast.center = [self CSKit_centerPointForPosition:position withToast:toast];
    toast.alpha = 0.0;
    
    if (CSKitToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(CSKit_handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:CSKitToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(CSKit_toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &CSKitToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         objc_setAssociatedObject (toast, &CSKitToastTapCallbackKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}


- (void)CSKit_hideToast:(UIView *)toast {
    [UIView animateWithDuration:CSKitToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)CSKit_toastTimerDidFinish:(NSTimer *)timer {
    [self CSKit_hideToast:(UIView *)timer.userInfo];
}

- (void)CSKit_handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &CSKitToastTimerKey);
    [timer invalidate];
    
    void (^callback)(void) = objc_getAssociatedObject(self, &CSKitToastTapCallbackKey);
    if (callback) {
        callback();
    }
    [self CSKit_hideToast:recognizer.view];
}

#pragma mark - Toast Activity Methods

- (void)CSKit_makeToastActivity {
    [self CSKit_makeToastActivity:CSKitToastActivityDefaultPosition];
}

- (void)CSKit_makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSKitToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CSKitToastActivityWidth, CSKitToastActivityHeight)];
    activityView.center = [self CSKit_centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSKitToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = CSKitToastCornerRadius;
    
    if (CSKitToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = CSKitToastShadowOpacity;
        activityView.layer.shadowRadius = CSKitToastShadowRadius;
        activityView.layer.shadowOffset = CSKitToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &CSKitToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:CSKitToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)CSKit_hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSKitToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:CSKitToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &CSKitToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Helpers

- (CGPoint)CSKit_centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        if([point caseInsensitiveCompare:CSKitToastPositionTop] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + CSKitToastVerticalPadding);
        } else if([point caseInsensitiveCompare:CSKitToastPositionCenter] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    // default to bottom
    return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - CSKitToastVerticalPadding);
}

- (CGSize)CSKit_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (UIView *)CSKit_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;

    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSKitToastCornerRadius;
    
    if (CSKitToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = CSKitToastShadowOpacity;
        wrapperView.layer.shadowRadius = CSKitToastShadowRadius;
        wrapperView.layer.shadowOffset = CSKitToastShadowOffset;
    }

    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSKitToastOpacity];
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CSKitToastHorizontalPadding, CSKitToastVerticalPadding, CSKitToastImageViewWidth, CSKitToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSKitToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = CSKitToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:CSKitToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * CSKitToastMaxWidth) - imageWidth, self.bounds.size.height * CSKitToastMaxHeight);
        CGSize expectedSizeTitle = [self CSKit_sizeForString:title font:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = CSKitToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:CSKitToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * CSKitToastMaxWidth) - imageWidth, self.bounds.size.height * CSKitToastMaxHeight);
        CGSize expectedSizeMessage = [self CSKit_sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = CSKitToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + CSKitToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;

    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSKitToastHorizontalPadding;
        messageTop = titleTop + titleHeight + CSKitToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }

    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (CSKitToastHorizontalPadding * 2)), (longerLeft + longerWidth + CSKitToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSKitToastVerticalPadding), (imageHeight + (CSKitToastVerticalPadding * 2)));
                         
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
        
    return wrapperView;
}

@end
