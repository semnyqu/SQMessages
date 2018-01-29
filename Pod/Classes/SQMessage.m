//
//  SQMessage.m
//  SQMessages
//
//  Created by semny on 17/6/30.
//  Copyright © 2017年 Felix Krause. All rights reserved.
//

#import "SQMessage.h"
#import "SQMessageView.h"
#import <Masonry/Masonry.h>
#import <MarqueeLabel/MarqueeLabel.h>
#import <NSHash/NSString+NSHash.h>

#define kSQMessageDisplayTime 1.5
#define kSQMessageExtraDisplayTimePerPixel 0.04
#define kSQMessageAnimationDuration 0.3

@interface SQMessage ()

/** The queued messages (SQMessageView objects) */
@property (nonatomic, strong) NSMutableArray *messages;

//The always message view
@property (nonatomic, strong) SQMessageView *alwaysMessage;

@end

@implementation SQMessage

+ (SQMessageView *)showNotificationInViewController:(UIViewController *)viewController icon:(UIImage *)icon title:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor duration:(SQMessageNotificationDuration)duration canBeDismissedByUser:(BOOL)canBeDismissedByUser isMarquee:(BOOL)isMarquee
{
    NSString *tempTitle = title;
    if ([tempTitle isKindOfClass:[NSString class]] && tempTitle.length > 0)
    {
        if(isMarquee)
        {
            tempTitle = [tempTitle MD5];
        }
    }
    else
    {
        tempTitle = nil;
    }
    
    SQMessageView *msgView = [[SQMessageView alloc] initWithTitle:tempTitle subtitle:nil image:nil type:SQMessageNotificationTypeMessage duration:duration inViewController:viewController  callback:nil buttonTitle:nil  buttonCallback:nil atPosition:SQMessageNotificationPositionTop canBeDismissedByUser:canBeDismissedByUser];
    CGFloat msgViewH = msgView.frame.size.height;
    CGFloat mainScreenH = [UIScreen mainScreen].bounds.size.height/2.0f;
    if (msgViewH > mainScreenH)
    {
        msgViewH = mainScreenH;
    }
    msgView.frame = CGRectMake(msgView.frame.origin.x, msgView.frame.origin.y, msgView.frame.size.width, msgViewH);
    
    UIView *view = nil;
    if (isMarquee)
    {
        //跑马灯
        view = [self setupMarqueeLabelWithFrame:msgView.bounds icon:icon title:title titleColor:titleColor titleFont:titleFont backgroundColor:backgroundColor];
    }
    else
    {
        //普通可换行
        view = [self setupCustomViewWithFrame:msgView.bounds icon:icon title:title titleColor:titleColor titleFont:titleFont backgroundColor:backgroundColor];
    }
    [msgView addSubview:view];
    
    //常驻的样式调整，调整独立显示
    if (duration == SQMessageNotificationDurationAlways)
    {
        //_alwaysMessage =
    }
    
    [self prepareNotificationToBeShown:msgView];
    return msgView;
}

+ (SQMessageView *)showNotificationInViewController:(UIViewController *)viewController icon:(UIImage *)icon title:(NSString *)title backgroundColor:(UIColor *)backgroundColor duration:(SQMessageNotificationDuration)duration canBeDismissedByUser:(BOOL)canBeDismissedByUser isMarquee:(BOOL)isMarquee
{
    return [self showNotificationInViewController:viewController icon:icon title:title titleFont:[UIFont systemFontOfSize:14.0f] titleColor:[UIColor whiteColor] backgroundColor:backgroundColor duration:duration canBeDismissedByUser:canBeDismissedByUser isMarquee:isMarquee];
}

//可扩展高度的
+ (UIView *)setupCustomViewWithFrame:(CGRect)frame icon:(UIImage *)icon title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:backgroundColor];
    
    //content高度
    CGFloat cHeight  = frame.size.height;
    CGFloat cWidth   = frame.size.width;
    CGFloat cLRSpace = 15.0f;
    //icon
    CGFloat iconW = 18.0f, iconH = 18.0f;
    CGFloat iconX          = cLRSpace;
    CGFloat iconY          = (cHeight - iconH) / 2.0f;
    CGRect iconFrame      = CGRectMake(iconX, iconY, iconW, iconH);
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    [iconView setImage:icon];
    [view addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(iconX);
        // 设置高/宽为1:1
        make.height.mas_equalTo(iconView.mas_width).multipliedBy(1);
        // 设置当前视图的大小
        make.size.mas_equalTo(CGSizeMake(iconW, iconH));
    }];
    
    //title
    CGFloat titleLabelLeftSpace = 5.0f;
    CGFloat titleLabelX            = iconX + iconW + titleLabelLeftSpace;
    CGFloat titleLabelY            = (cHeight - iconH) / 2.0f;
    CGFloat titleLabelW            = cWidth - titleLabelX - cLRSpace;
    CGFloat titleLabelH            = 20.0f;
    CGRect titleLabelFrame        = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    UILabel *titleLabel            = [[UILabel alloc] initWithFrame:titleLabelFrame];
    if (!titleFont)
    {
        titleFont = [UIFont systemFontOfSize:14.0f];
    }
    [titleLabel setFont:titleFont];
    
    if (!titleColor)
    {
        titleColor = [UIColor whiteColor];
    }
    [titleLabel setTextColor:titleColor];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [titleLabel setNumberOfLines:0];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(titleLabelLeftSpace);
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(-cLRSpace);
    }];
    
    return view;
}

//跑马灯
+ (UIView *)setupMarqueeLabelWithFrame:(CGRect)frame icon:(UIImage *)icon title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:backgroundColor];
    
    //content高度
    CGFloat cHeight  = frame.size.height;
    CGFloat cWidth   = frame.size.width;
    CGFloat cLRSpace = 15.0f;
    //icon
    CGFloat iconW = 18.0f, iconH = 18.0f;
    CGFloat iconX          = cLRSpace;
    CGFloat iconY          = (cHeight - iconH) / 2.0f;
    CGRect iconFrame      = CGRectMake(iconX, iconY, iconW, iconH);
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    [iconView setImage:icon];
    [view addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(iconX);
        // 设置高/宽为1:1
        make.height.mas_equalTo(iconView.mas_width).multipliedBy(1);
        // 设置当前视图的大小
        make.size.mas_equalTo(CGSizeMake(iconW, iconH));
    }];
    
    //title
    CGFloat titleLabelLeftSpace = 5.0f;
    CGFloat titleLabelX            = iconX + iconW + titleLabelLeftSpace;
    CGFloat titleLabelY            = (cHeight - iconH) / 2.0f;
    CGFloat titleLabelW            = cWidth - titleLabelX - cLRSpace;
    CGFloat titleLabelH            = 20.0f;
    CGRect titleLabelFrame        = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    MarqueeLabel *titleLabel            = [[MarqueeLabel alloc] initWithFrame:titleLabelFrame];
    if (!titleFont)
    {
        titleFont = [UIFont systemFontOfSize:14.0f];
    }
    [titleLabel setFont:titleFont];
    
    if (!titleColor)
    {
        titleColor = [UIColor whiteColor];
    }
    [titleLabel setTextColor:titleColor];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    //[titleLabel setNumberOfLines:0];
    //去掉跑马灯中显示的字符串的换行符，修复只显示一行的问题
    if ([title isKindOfClass:NSString.class] && title.length > 0)
    {
        NSCharacterSet *whiteAndNewLineSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        title = [title stringByTrimmingCharactersInSet:whiteAndNewLineSet];
        title = [title stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    [titleLabel setText:title];
    //连续滚动
    [titleLabel setMarqueeType:MLContinuous];
    [titleLabel setRate:50.0f];
    [titleLabel setFadeLength:10.f];
    [titleLabel setAnimationDelay:1.f];
    [titleLabel setTrailingBuffer:30.f];
    [view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(titleLabelLeftSpace);
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(-cLRSpace);
    }];
    
    return view;
}

+ (BOOL)dismissActiveNotification
{
    return [self dismissActiveNotificationWithCompletion:nil];
}

+ (BOOL)dismissActiveNotificationWithCompletion:(void (^)())completion
{
    return [self dismissActiveNotificationWithCompletion:completion inViewController:nil];
}

+ (BOOL)dismissActiveNotificationWithCompletion:(void (^)())completion inViewController:(UIViewController *)viewController
{
    return [self dismissActiveNotificationWithCompletion:completion inViewController:nil force:NO];
}

+ (BOOL)dismissActiveNotificationWithCompletion:(void (^)())completion inViewController:(UIViewController *)viewController force:(BOOL)force
{
    if ([[SQMessage sharedMessage].messages count] == 0)
        return NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[SQMessage sharedMessage].messages count] == 0)
            return;
        SQMessageView *currentMessage = [[SQMessage sharedMessage].messages objectAtIndex:0];
        BOOL currentFlag              = YES;
        if (viewController && currentMessage.viewController != viewController)
        {
            currentFlag = NO;
        }
        BOOL flag = currentMessage.messageIsFullyDisplayed && currentFlag;
        if (force && flag)
        {
            [[SQMessage sharedMessage] fadeOutNotification:currentMessage animationFinishedBlock:completion];
        }
        else if (currentMessage.duration != SQMessageNotificationDurationAlways && flag)
        {
            [[SQMessage sharedMessage] fadeOutNotification:currentMessage animationFinishedBlock:completion];
        }
    });
    return YES;
}

+ (BOOL)dismissActiveNotificationForAlwaysMessageWithCompletion:(void (^)())completion inViewController:(UIViewController *)viewController force:(BOOL)force
{
    SQMessageView *messageView = [SQMessage sharedMessage].alwaysMessage;
    return [self dismissActiveNotificationWithMessageView:messageView completion:completion inViewController:viewController force:force];
}

+ (BOOL)dismissActiveNotificationWithMessageView:(SQMessageView*)messageView  completion:(void (^)())completion inViewController:(UIViewController *)viewController force:(BOOL)force
{
    if (!messageView) return NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!messageView) return;
        SQMessageView *currentMessage = messageView;
        BOOL currentFlag              = YES;
        if (viewController && currentMessage.viewController != viewController)
        {
            currentFlag = NO;
        }
        BOOL flag = currentMessage.messageIsFullyDisplayed && currentFlag;
        if (force && flag)
        {
            [[SQMessage sharedMessage] fadeOutNotification:currentMessage animationFinishedBlock:completion];
        }
        else if (currentMessage.duration != SQMessageNotificationDurationAlways && flag)
        {
            [[SQMessage sharedMessage] fadeOutNotification:currentMessage animationFinishedBlock:completion];
        }
    });
    return YES;
}
#pragma mark - Old SQMessage

static SQMessage *sharedMessage;
static BOOL notificationActive;

static BOOL _useiOS7Style;

__weak static UIViewController *_defaultViewController;

+ (SQMessage *)sharedMessage
{
    if (!sharedMessage)
    {
        sharedMessage = [[[self class] alloc] init];
    }
    return sharedMessage;
}

#pragma mark Public methods for setting up the notification

+ (void)showNotificationWithTitle:(NSString *)title
                             type:(SQMessageNotificationType)type
{
    [self showNotificationWithTitle:title
                           subtitle:nil
                               type:type];
}

+ (void)showNotificationWithTitle:(NSString *)title
                         subtitle:(NSString *)subtitle
                             type:(SQMessageNotificationType)type
{
    [self showNotificationInViewController:[self defaultViewController]
                                     title:title
                                  subtitle:subtitle
                                      type:type];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                    type:(SQMessageNotificationType)type
                                duration:(NSTimeInterval)duration
{
    [self showNotificationInViewController:viewController
                                     title:title
                                  subtitle:subtitle
                                     image:nil
                                      type:type
                                  duration:duration
                                  callback:nil
                               buttonTitle:nil
                            buttonCallback:nil
                                atPosition:SQMessageNotificationPositionTop
                      canBeDismissedByUser:YES];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                    type:(SQMessageNotificationType)type
                                duration:(NSTimeInterval)duration
                    canBeDismissedByUser:(BOOL)dismissingEnabled
{
    [self showNotificationInViewController:viewController
                                     title:title
                                  subtitle:subtitle
                                     image:nil
                                      type:type
                                  duration:duration
                                  callback:nil
                               buttonTitle:nil
                            buttonCallback:nil
                                atPosition:SQMessageNotificationPositionTop
                      canBeDismissedByUser:dismissingEnabled];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                    type:(SQMessageNotificationType)type
{
    [self showNotificationInViewController:viewController
                                     title:title
                                  subtitle:subtitle
                                     image:nil
                                      type:type
                                  duration:SQMessageNotificationDurationAutomatic
                                  callback:nil
                               buttonTitle:nil
                            buttonCallback:nil
                                atPosition:SQMessageNotificationPositionTop
                      canBeDismissedByUser:YES];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                   image:(UIImage *)image
                                    type:(SQMessageNotificationType)type
                                duration:(NSTimeInterval)duration
                                callback:(void (^)())callback
                             buttonTitle:(NSString *)buttonTitle
                          buttonCallback:(void (^)())buttonCallback
                              atPosition:(SQMessageNotificationPosition)messagePosition
                    canBeDismissedByUser:(BOOL)dismissingEnabled
{
    // Create the SQMessageView
    SQMessageView *v = [[SQMessageView alloc] initWithTitle:title
                                                   subtitle:subtitle
                                                      image:image
                                                       type:type
                                                   duration:duration
                                           inViewController:viewController
                                                   callback:callback
                                                buttonTitle:buttonTitle
                                             buttonCallback:buttonCallback
                                                 atPosition:messagePosition
                                       canBeDismissedByUser:dismissingEnabled];
    [self prepareNotificationToBeShown:v];
}

+ (void)prepareNotificationToBeShown:(SQMessageView *)messageView
{
    NSString *title    = messageView.title;
    NSString *subtitle = messageView.subtitle;
    
    for (SQMessageView *n in [SQMessage sharedMessage].messages)
    {
        if (([n.title isEqualToString:title] || (!n.title && !title)) && ([n.subtitle isEqualToString:subtitle] || (!n.subtitle && !subtitle)))
        {
            return; // avoid showing the same messages twice in a row
        }
    }
    
    CGFloat duration = messageView.duration;
    //常驻的样式调整，调整独立显示
    if (duration == SQMessageNotificationDurationAlways)
    {
        [SQMessage sharedMessage].alwaysMessage = messageView;
        
        if (!notificationActive)
        {
            [[SQMessage sharedMessage] fadeInCurrentNotificationWith:messageView];
        }
    }
    else
    {
        //其他的消息，包括动态的，手动点击的
        [[SQMessage sharedMessage].messages addObject:messageView];
        if (!notificationActive)
        {
            [[SQMessage sharedMessage] fadeInCurrentNotification];
        }
    }
}

#pragma mark Fading in/out the message view

- (id)init
{
    if ((self = [super init]))
    {
        _messages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)fadeInCurrentNotificationWith:(SQMessageView *)currentView
{
    if (!currentView)
        return;
    
    UIViewController *currentViewController = currentView.viewController;
    BOOL navFlag                            = [currentViewController isKindOfClass:[UINavigationController class]];
    BOOL pNavFlag                            = [currentViewController.parentViewController isKindOfClass:[UINavigationController class]];
    //判断是否为nav vc
    BOOL isViewIsUnderStatusBar = NO;
    UINavigationController *currentNavigationController = nil;
    if (navFlag)
    {
        currentNavigationController = (UINavigationController *)currentViewController;
    }
    else if (pNavFlag)
    {
        currentNavigationController = (UINavigationController *)currentViewController.parentViewController;
    }
    
    __block CGFloat verticalOffset                 = 0.0f;
    void (^addStatusBarHeightToVerticalOffset)() = ^void() {
        
        if (currentView.messagePosition == SQMessageNotificationPositionNavBarOverlay)
        {
            return;
        }
        CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
        verticalOffset += MIN(statusBarSize.width, statusBarSize.height);
    };
    
    //使用message的vc
    if (navFlag || pNavFlag)
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
        isViewIsUnderStatusBar = [[[currentNavigationController childViewControllers] firstObject] wantsFullScreenLayout];
#else
        isViewIsUnderStatusBar = !currentViewController.extendedLayoutIncludesOpaqueBars && ((currentViewController.edgesForExtendedLayout & UIRectEdgeTop) == UIRectEdgeTop);
#endif
        
        if (!navFlag)
        {
            //当前vc非nv
            [currentViewController.view addSubview:currentView];
            //判断是否隐藏nav bar
            if ([SQMessage isNavigationBarInNavigationControllerHidden:currentNavigationController])
            {
                addStatusBarHeightToVerticalOffset();
            }
        }
        else
        {
            if (!isViewIsUnderStatusBar && currentNavigationController.parentViewController == nil)
            {
                isViewIsUnderStatusBar = ![SQMessage isNavigationBarInNavigationControllerHidden:currentNavigationController]; // strange but true
            }
            
            if (![SQMessage isNavigationBarInNavigationControllerHidden:currentNavigationController] && currentView.messagePosition != SQMessageNotificationPositionNavBarOverlay)
            {
                [currentNavigationController.view insertSubview:currentView
                                                   belowSubview:[currentNavigationController navigationBar]];
                verticalOffset = [currentNavigationController navigationBar].bounds.size.height;
                if (([SQMessage iOS7StyleEnabled] || isViewIsUnderStatusBar))
                {
                    addStatusBarHeightToVerticalOffset();
                }
            }
            else
            {
                [currentViewController.view addSubview:currentView];
                if (([SQMessage iOS7StyleEnabled] || isViewIsUnderStatusBar))
                {
                    addStatusBarHeightToVerticalOffset();
                }
            }
        }
    }
    else
    {
        [currentViewController.view addSubview:currentView];
        if ([SQMessage iOS7StyleEnabled])
        {
            addStatusBarHeightToVerticalOffset();
        }
    }
    
    CGPoint toPoint;
    if (currentView.messagePosition != SQMessageNotificationPositionBottom)
    {
        CGFloat navigationbarBottomOfViewController = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageLocationOfMessageView:)])
        {
            navigationbarBottomOfViewController = [self.delegate messageLocationOfMessageView:currentView];
        }
        
        toPoint = CGPointMake(currentView.center.x,
                              navigationbarBottomOfViewController + verticalOffset + CGRectGetHeight(currentView.frame) / 2.0);
    }
    else
    {
        CGFloat y = currentViewController.view.bounds.size.height - CGRectGetHeight(currentView.frame) / 2.0;
        if (!currentViewController.navigationController.isToolbarHidden)
        {
            y -= CGRectGetHeight(currentViewController.navigationController.toolbar.bounds);
        }
        toPoint = CGPointMake(currentView.center.x, y);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customizeMessageView:)])
    {
        [self.delegate customizeMessageView:currentView];
    }
    
    dispatch_block_t animationBlock = ^{
        currentView.center = toPoint;
        if (![SQMessage iOS7StyleEnabled])
        {
            currentView.alpha = SQMessageViewAlpha;
        }
    };
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
        currentView.messageIsFullyDisplayed = YES;
    };
    
    if (![SQMessage iOS7StyleEnabled])
    {
        [UIView animateWithDuration:kSQMessageAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:animationBlock
                         completion:completionBlock];
    }
    else
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        [UIView animateWithDuration:kSQMessageAnimationDuration + 0.1
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.f
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:animationBlock
                         completion:completionBlock];
#endif
    }
    CGFloat tempDuration = currentView.duration;
    if (tempDuration == SQMessageNotificationDurationAutomatic)
    {
        currentView.duration = kSQMessageAnimationDuration + kSQMessageDisplayTime + currentView.frame.size.height * kSQMessageExtraDisplayTimePerPixel;
    }
    
    if (tempDuration != SQMessageNotificationDurationEndless && tempDuration != SQMessageNotificationDurationAlways)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(fadeOutNotification:)
                       withObject:currentView
                       afterDelay:currentView.duration];
        });
    }
}

- (void)fadeInCurrentNotification
{
    if ([self.messages count] == 0)
        return;
    
    notificationActive = YES;
    
    SQMessageView *currentView = [self.messages objectAtIndex:0];
    [self fadeInCurrentNotificationWith:currentView];
}

/**
 - (void)fadeInCurrentNotification
 {
 if ([self.messages count] == 0)
 return;
 
 notificationActive = YES;
 
 SQMessageView *currentView = [self.messages objectAtIndex:0];
 
 __block CGFloat verticalOffset = 0.0f;
 
 void (^addStatusBarHeightToVerticalOffset)() = ^void() {
 
 if (currentView.messagePosition == SQMessageNotificationPositionNavBarOverlay)
 {
 return;
 }
 
 CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
 verticalOffset += MIN(statusBarSize.width, statusBarSize.height);
 };
 
 if ([currentView.viewController isKindOfClass:[UINavigationController class]] || [currentView.viewController.parentViewController isKindOfClass:[UINavigationController class]])
 {
 UINavigationController *currentNavigationController;
 
 if ([currentView.viewController isKindOfClass:[UINavigationController class]])
 currentNavigationController = (UINavigationController *)currentView.viewController;
 else
 currentNavigationController = (UINavigationController *)currentView.viewController.parentViewController;
 
 BOOL isViewIsUnderStatusBar = [[[currentNavigationController childViewControllers] firstObject] wantsFullScreenLayout];
 if (!isViewIsUnderStatusBar && currentNavigationController.parentViewController == nil)
 {
 isViewIsUnderStatusBar = ![SQMessage isNavigationBarInNavigationControllerHidden:currentNavigationController]; // strange but true
 }
 if (![SQMessage isNavigationBarInNavigationControllerHidden:currentNavigationController] && currentView.messagePosition != SQMessageNotificationPositionNavBarOverlay)
 {
 [currentNavigationController.view insertSubview:currentView
 belowSubview:[currentNavigationController navigationBar]];
 verticalOffset = [currentNavigationController navigationBar].bounds.size.height;
 if ([SQMessage iOS7StyleEnabled] || isViewIsUnderStatusBar)
 {
 addStatusBarHeightToVerticalOffset();
 }
 }
 else
 {
 [currentView.viewController.view addSubview:currentView];
 if ([SQMessage iOS7StyleEnabled] || isViewIsUnderStatusBar)
 {
 addStatusBarHeightToVerticalOffset();
 }
 }
 }
 else
 {
 [currentView.viewController.view addSubview:currentView];
 if ([SQMessage iOS7StyleEnabled])
 {
 addStatusBarHeightToVerticalOffset();
 }
 }
 
 CGPoint toPoint;
 if (currentView.messagePosition != SQMessageNotificationPositionBottom)
 {
 CGFloat navigationbarBottomOfViewController = 0;
 
 if (self.delegate && [self.delegate respondsToSelector:@selector(messageLocationOfMessageView:)])
 {
 navigationbarBottomOfViewController = [self.delegate messageLocationOfMessageView:currentView];
 }
 
 toPoint = CGPointMake(currentView.center.x,
 navigationbarBottomOfViewController + verticalOffset + CGRectGetHeight(currentView.frame) / 2.0);
 }
 else
 {
 CGFloat y = currentView.viewController.view.bounds.size.height - CGRectGetHeight(currentView.frame) / 2.0;
 if (!currentView.viewController.navigationController.isToolbarHidden)
 {
 y -= CGRectGetHeight(currentView.viewController.navigationController.toolbar.bounds);
 }
 toPoint = CGPointMake(currentView.center.x, y);
 }
 
 if (self.delegate && [self.delegate respondsToSelector:@selector(customizeMessageView:)])
 {
 [self.delegate customizeMessageView:currentView];
 }
 
 dispatch_block_t animationBlock = ^{
 currentView.center = toPoint;
 if (![SQMessage iOS7StyleEnabled])
 {
 currentView.alpha = SQMessageViewAlpha;
 }
 };
 void (^completionBlock)(BOOL) = ^(BOOL finished) {
 currentView.messageIsFullyDisplayed = YES;
 };
 
 if (![SQMessage iOS7StyleEnabled])
 {
 [UIView animateWithDuration:kSQMessageAnimationDuration
 delay:0.0
 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
 animations:animationBlock
 completion:completionBlock];
 }
 else
 {
 #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
 [UIView animateWithDuration:kSQMessageAnimationDuration + 0.1
 delay:0
 usingSpringWithDamping:0.8
 initialSpringVelocity:0.f
 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
 animations:animationBlock
 completion:completionBlock];
 #endif
 }
 CGFloat tempDuration = currentView.duration;
 if (tempDuration == SQMessageNotificationDurationAutomatic)
 {
 currentView.duration = kSQMessageAnimationDuration + kSQMessageDisplayTime + currentView.frame.size.height * kSQMessageExtraDisplayTimePerPixel;
 }
 
 if (tempDuration != SQMessageNotificationDurationEndless && tempDuration != SQMessageNotificationDurationAlways)
 {
 dispatch_async(dispatch_get_main_queue(), ^{
 [self performSelector:@selector(fadeOutNotification:)
 withObject:currentView
 afterDelay:currentView.duration];
 });
 }
 }
 */

+ (BOOL)isNavigationBarInNavigationControllerHidden:(UINavigationController *)navController
{
    if ([navController isNavigationBarHidden])
    {
        return YES;
    }
    else if ([[navController navigationBar] isHidden])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)fadeOutNotification:(SQMessageView *)currentView
{
    [self fadeOutNotification:currentView animationFinishedBlock:nil];
}

- (void)fadeOutNotification:(SQMessageView *)currentView animationFinishedBlock:(void (^)())animationFinished
{
    currentView.messageIsFullyDisplayed = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(fadeOutNotification:)
                                               object:currentView];
    
    CGPoint fadeOutToPoint;
    if (currentView.messagePosition != SQMessageNotificationPositionBottom)
    {
        fadeOutToPoint = CGPointMake(currentView.center.x, -CGRectGetHeight(currentView.frame) / 2.f);
    }
    else
    {
        fadeOutToPoint = CGPointMake(currentView.center.x,
                                     currentView.viewController.view.bounds.size.height + CGRectGetHeight(currentView.frame) / 2.f);
    }
    
    [UIView animateWithDuration:kSQMessageAnimationDuration
                     animations:^{
                         currentView.center = fadeOutToPoint;
                         if (![SQMessage iOS7StyleEnabled])
                         {
                             currentView.alpha = 0.f;
                         }
                     }
                     completion:^(BOOL finished) {
                         [currentView removeFromSuperview];
                         
                         if ([self.messages count] > 0)
                         {
                             [self.messages removeObjectAtIndex:0];
                         }
                         
                         notificationActive = NO;
                         
                         if ([self.messages count] > 0)
                         {
                             [self fadeInCurrentNotification];
                         }
                         
                         if (animationFinished)
                         {
                             animationFinished();
                         }
                     }];
}

#pragma mark Customizing SQMessages

+ (void)setDefaultViewController:(UIViewController *)defaultViewController
{
    _defaultViewController = defaultViewController;
}

+ (void)setDelegate:(id<SQMessageViewProtocol>)delegate
{
    [SQMessage sharedMessage].delegate = delegate;
}

+ (void)addCustomDesignFromFileWithName:(NSString *)fileName
{
    [SQMessageView addNotificationDesignFromFile:fileName];
}

#pragma mark Other methods

+ (BOOL)isNotificationActive
{
    return notificationActive;
}

+ (NSArray *)queuedMessages
{
    return [SQMessage sharedMessage].messages;
}

+ (UIViewController *)defaultViewController
{
    __strong UIViewController *defaultViewController = _defaultViewController;
    
    if (!defaultViewController)
    {
        defaultViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return defaultViewController;
}

+ (BOOL)iOS7StyleEnabled
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Decide wheter to use iOS 7 style or not based on the running device and the base sdk
        BOOL iOS7SDK = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        iOS7SDK = YES;
#endif
        
        _useiOS7Style = !(TS_SYSTEM_VERSION_LESS_THAN(@"7.0") || !iOS7SDK);
    });
    return _useiOS7Style;
}

@end

