/*
 * JFMinimalNotification
 *
 * Created by Jeremy Fox on 5/4/13.
 * Copyright (c) 2013 Jeremy Fox. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "JFMinimalNotification.h"
#import "JFMinimalNotificationArt.h"
#import "UIView+Round.h"
#import "UIColor+JFMinimalNotificationColors.h"
#import "NSInvocation+Constructors.h"
#import "kColorConstants.h"
#import "kConstants.h"
#import "HelperFunctions.h"

static CGFloat const kNotificationViewHeight = 80.0f;
static CGFloat const kNotificationTitleLabelHeight = 20.0f;
static CGFloat const kNotificationPadding = 20.0f;
static CGFloat const kNotificationAccessoryPadding = 10.0f;

static CGFloat const kNotificationButtonHeight = 40.0f;
static CGFloat const kNotificationButtonWidth = 100.0f;
static CGFloat const kNotificationButtonBorderWidth = 1.0f;
static CGFloat const kNotificationButtonCornerRadius = 5.0f;

static CGFloat const kNotificationViewHeightSubtitleWithButton = (kNotificationViewHeight - 20) + kNotificationButtonHeight;
static CGFloat const kNotificationViewHeightWithButton = kNotificationViewHeight+ kNotificationButtonHeight + 5;

static CGFloat const kNotificationViewHeightLineBuffer = 24;

@interface JFMinimalNotification()

// Configuration
@property (nonatomic, readwrite) JFMinimalNotificationStytle currentStyle;

// Views
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong, readwrite) UILabel* titleLabel;
@property (nonatomic, strong, readwrite) UILabel* subTitleLabel;
@property (nonatomic, strong, readwrite) UIView* leftAccessoryView;
@property (nonatomic, strong, readwrite) UIView* righAccessorytView;
@property (nonatomic, strong) UIView* accessoryView;

@property (nonatomic, strong) UIButton* leftButton;
@property (nonatomic, strong) UIButton* rightButton;

// Constraints for animations
@property (nonatomic, strong) NSArray* notificationVerticalConstraints;
@property (nonatomic, strong) NSArray* notificationHorizontalConstraints;
@property (nonatomic, strong) NSArray* titleLabelHorizontalConsraints;
@property (nonatomic, strong) NSArray* titleLabelVerticalConsraints;
@property (nonatomic, strong) NSArray* subTitleLabelHorizontalConsraints;
@property (nonatomic, strong) NSArray* subTitleLabelVerticalConsraints;

@property (nonatomic, strong) NSArray* leftButtonVerticalConstraints;
@property (nonatomic, strong) NSArray* rightButtonVerticalConstraints;
@property (nonatomic, strong) NSArray* buttonHorizontalConstraints;


@property (nonatomic, strong) UIColor* primaryColor;
@property (nonatomic, strong) UIColor* secondaryColor;

- (BOOL)isReadyToDisplay;

@property (nonatomic) BOOL leftButtonFill;
@property (nonatomic) BOOL rightButtonFill;
@end

@implementation JFMinimalNotification

- (void)dealloc
{
    if ([self.superview.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    _titleLabel                         = nil;
    _subTitleLabel                      = nil;
    _leftAccessoryView                  = nil;
    _rightAccessoryView                 = nil;
    _accessoryView                      = nil;
    _contentView                        = nil;
    _touchHandler                       = nil;
    _notificationVerticalConstraints    = nil;
    _notificationHorizontalConstraints  = nil;
    _titleLabelHorizontalConsraints     = nil;
    _titleLabelVerticalConsraints       = nil;
    _subTitleLabelHorizontalConsraints  = nil;
    _subTitleLabelVerticalConsraints    = nil;
    _dismissalTimer                     = nil;
    
    _leftButtonVerticalConstraints = nil;
    _rightButtonVerticalConstraints = nil;
    _buttonHorizontalConstraints = nil;
}

+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style title:(NSString*)title subTitle:(NSString*)subTitle
{
    return [self notificationWithStyle:style title:title subTitle:subTitle dismissalDelay:0];
}

+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style title:(NSString *)title subTitle:(NSString *)subTitle dismissalDelay:(NSTimeInterval)dismissalDelay
{
    return [self notificationWithStyle:style title:title subTitle:subTitle dismissalDelay:dismissalDelay touchHandler:nil];
}

+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style title:(NSString *)title subTitle:(NSString *)subTitle dismissalDelay:(NSTimeInterval)dismissalDelay touchHandler:(JFMinimalNotificationTouchHandler)touchHandler
{
  /*  JFMinimalNotification* notification = [[JFMinimalNotification alloc] initWithStyle:style title:title subTitle:subTitle];
    
    if (dismissalDelay > 0) {
        notification.dismissalDelay = dismissalDelay;
    }
    
    if (touchHandler) {
        notification.touchHandler = touchHandler;
        UITapGestureRecognizer* tapHandler = [[UITapGestureRecognizer alloc] initWithTarget:notification action:@selector(handleTap)];
        notification.userInteractionEnabled = YES;
        [notification addGestureRecognizer:tapHandler];
    }
    
    return notification; */
    
    return [self notificationCustomStyleWithTitle:title
                                         subTitle:subTitle
                                   dismissalDelay:dismissalDelay
                                     touchHandler:touchHandler
                                   leftButtonText:nil
                                  rightButtonText:nil
                                   leftButtonFill:NO
                                  rightButtonFill:NO
                                     primaryColor:nil
                                   secondaryColor:nil
                                            image:nil];
    
}

+ (instancetype)notificationCustomStyleWithTitle:(NSString*)title
                             subTitle:(NSString*)subTitle
                       dismissalDelay:(NSTimeInterval)dismissalDelay
                         touchHandler:(JFMinimalNotificationTouchHandler)touchHandler
                       leftButtonText:(NSString *)leftButtonText
                                 rightButtonText:(NSString *)rightButtonText
                                  leftButtonFill:(BOOL)leftButtonFill
                                 rightButtonFill:(BOOL)rightButtonFill
                                    primaryColor:(UIColor *)primaryColor
                                  secondaryColor:(UIColor *)secondaryColor
                                           image:(UIImage *)image
{
    JFMinimalNotification* notification = [[JFMinimalNotification alloc] initWithStyle:JFMinimalNotificationStyleCustom title:title subTitle:subTitle primaryColor:primaryColor secondaryColor:secondaryColor image:image leftButtonText:leftButtonText leftButtonFill:leftButtonFill rightButtonText:rightButtonText rightButtonFill:rightButtonFill];
    
    if (dismissalDelay > 0)
    {
        notification.dismissalDelay = dismissalDelay;
    }
    
    if (touchHandler)
    {
        notification.touchHandler = touchHandler;
        UITapGestureRecognizer* tapHandler = [[UITapGestureRecognizer alloc] initWithTarget:notification action:@selector(handleTap)];
        notification.userInteractionEnabled = YES;
        [notification addGestureRecognizer:tapHandler];
    }
    
    return notification;
}

- (instancetype)init
{
    [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use one of the designated initializers like notificationWithStyle:title:subTitle:..." userInfo:nil] raise];
    return nil;
}

- (instancetype)initWithStyle:(JFMinimalNotificationStytle)style title:(NSString*)title subTitle:(NSString*)subTitle primaryColor:(UIColor *)primaryColor secondaryColor:(UIColor *)secondaryColor image:(UIImage *)image leftButtonText:(NSString *)leftButtonText leftButtonFill:(BOOL)leftButtonFill rightButtonText:(NSString *)rightButtonText rightButtonFill:(BOOL)rightButtonFill
{
    if (self = [super init]) {
        
        _leftButtonFill = NO;
        _rightButtonFill = NO;
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        UIView* contentView = _contentView;
        NSDictionary* views = NSDictionaryOfVariableBindings(contentView);
        [self addSubview:_contentView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views]];
        
        _primaryColor = primaryColor;
        _secondaryColor = secondaryColor;
        
        [self setTitle:title withSubTitle:subTitle];
        [self setStyle:style animated:NO customPrimaryColor:primaryColor customSecondaryColor:secondaryColor customImage:nil];
        [self setButtons:leftButtonText rightButtonString:rightButtonText leftButtonFill:leftButtonFill rightButtonFill:rightButtonFill];
        
    }
    return self;
}

#pragma mark ----------------------
#pragma mark UIView Hierarchy
#pragma mark ----------------------

- (void)didMoveToSuperview
{
    if (self.isReadyToDisplay) {
        [self configureInitialNotificationConstraintsForTopPresentation:self.presentFromTop];
    }
}

#pragma mark ----------------------
#pragma mark Presentation
#pragma mark ----------------------

- (BOOL)isReadyToDisplay
{
    return (BOOL)self.superview;
}

- (void)show
{
    if (self.isReadyToDisplay) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(willShowNotification:)]) {
            [self.delegate willShowNotification:self];
        }
        
        [self.superview removeConstraints:self.notificationVerticalConstraints];
        UIView* superview = self.superview;
        UIView* notification = self;
        NSDictionary* views = NSDictionaryOfVariableBindings(superview, notification);
     //   NSDictionary* metrics = @{@"height": @(kNotificationViewHeight)};
        
        CGFloat viewHeight;
        
        if (_leftButton || _rightButton)
        {
            if (_titleLabel && _subTitleLabel)
                viewHeight = kNotificationViewHeightWithButton;
            else
                viewHeight = kNotificationViewHeightSubtitleWithButton;
        }
        else
            viewHeight = kNotificationViewHeight;
        
        if (_subTitleLabel)
        {
            NSInteger numberOfLines = [HelperFunctions getNumberOfLinesInLabelOrTextView:_subTitleLabel];
            viewHeight = viewHeight + (kNotificationViewHeightLineBuffer * (numberOfLines - 1));
        }
        
        NSDictionary* metrics = @{@"height": @(viewHeight)};
        
        NSString* verticalConstraintString;
        if (self.presentFromTop) {
            verticalConstraintString = @"V:|[notification(==height)]";
        } else {
            verticalConstraintString = @"V:[notification(==height)]|";
        }
        
        self.notificationVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintString options:0 metrics:metrics views:views];
        [self.superview addConstraints:self.notificationVerticalConstraints];
        
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.3f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            if (self.dismissalDelay > 0) {
                NSInvocation* dismissalInvocation = [NSInvocation invocationWithTarget:self selector:@selector(dismiss)];
                self.dismissalTimer = [NSTimer scheduledTimerWithTimeInterval:self.dismissalDelay invocation:dismissalInvocation repeats:NO];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didShowNotification:)]) {
                [self.delegate didShowNotification:self];
            }
        }];
    } else {
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must have a superview before calling show" userInfo:nil] raise];
    }
}

- (void)dismiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willDisimissNotification:)]) {
        [self.delegate willDisimissNotification:self];
    }
    
    if (self.dismissalTimer) {
        [self.dismissalTimer invalidate];
        self.dismissalTimer = nil;
    }
    
    [self configureInitialNotificationConstraintsForTopPresentation:self.presentFromTop];
    
    [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissNotification:)]) {
            [self.delegate didDismissNotification:self];
        }
    }];
}

- (void)configureInitialNotificationConstraintsForTopPresentation:(BOOL)topPresentation
{
    if (self.notificationVerticalConstraints.count > 0) {
        [self.superview removeConstraints:self.notificationVerticalConstraints];
    }
    if (self.notificationHorizontalConstraints.count > 0) {
        [self.superview removeConstraints:self.notificationHorizontalConstraints];
    }
    UIView* superview = self.superview;
    UIView* notification = self;
    NSDictionary* views = NSDictionaryOfVariableBindings(superview, notification);
    //   NSDictionary* metrics = @{@"height": @(kNotificationViewHeight)};
    CGFloat viewHeight;
    if (_leftButton || _rightButton)
    {
        if (_titleLabel && _subTitleLabel)
            viewHeight = kNotificationViewHeightWithButton;
        else
            viewHeight = kNotificationViewHeightSubtitleWithButton;
    }
    else
        viewHeight = kNotificationViewHeight;
    
    if (_subTitleLabel)
    {
        NSInteger numberOfLines = [HelperFunctions getNumberOfLinesInLabelOrTextView:_subTitleLabel];
        viewHeight = viewHeight + (kNotificationViewHeightLineBuffer * (numberOfLines - 1));
    }
    
    NSDictionary* metrics = @{@"height": @(viewHeight)};
    
    NSString* verticalConstraintString;
    if (topPresentation) {
        verticalConstraintString = @"V:[notification(==height)][superview]";
    } else {
        verticalConstraintString = @"V:[superview][notification(==height)]";
    }
    
    self.notificationVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintString options:0 metrics:metrics views:views];
    [self.superview addConstraints:self.notificationVerticalConstraints];
    
    self.notificationHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[notification]|" options:0 metrics:metrics views:views];
    [self.superview addConstraints:self.notificationHorizontalConstraints];
}

#pragma mark ----------------------
#pragma mark Setters / Configuration
#pragma mark ----------------------


- (void)setPresentFromTop:(BOOL)presentFromTop
{
    _presentFromTop = presentFromTop;
    [self configureInitialNotificationConstraintsForTopPresentation:_presentFromTop];
}

- (void)setStyle:(JFMinimalNotificationStytle)style animated:(BOOL)animated customPrimaryColor:(UIColor *)customPrimaryColor customSecondaryColor:(UIColor *)customSecondaryColor customImage:(UIImage *)customImage
{
    UIImage* image;
    self.accessoryView = nil;
    self.accessoryView = [UIView new];
    self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.currentStyle = style;
    switch (style) {
        case JFMinimalNotificationStyleCustom: {
            
            self.primaryColor = (customPrimaryColor) ? customPrimaryColor : [UIColor notificationBlueColor];
            self.secondaryColor = (customSecondaryColor) ? customSecondaryColor : [UIColor notificationWhiteColor];
            self.contentView.backgroundColor = self.primaryColor;
            self.titleLabel.textColor = self.secondaryColor;
            self.subTitleLabel.textColor = self.secondaryColor;
            image = customImage;
            self.accessoryView.backgroundColor = self.secondaryColor;
            break;
        }
        case JFMinimalNotificationStyleError: {
            self.primaryColor = [UIColor notificationRedColor];
            self.secondaryColor = [UIColor notificationWhiteColor];
            self.contentView.backgroundColor = self.primaryColor;
            self.titleLabel.textColor = self.secondaryColor;
            self.subTitleLabel.textColor = self.secondaryColor;
            image = [JFMinimalNotificationArt imageOfCrossWithColor:self.primaryColor];
            self.accessoryView.backgroundColor = self.secondaryColor;
            break;
        }
            
        case JFMinimalNotificationStyleSuccess: {
            self.primaryColor = [UIColor notificationGreenColor];
            self.secondaryColor = [UIColor notificationWhiteColor];
            self.contentView.backgroundColor = self.primaryColor;
            self.titleLabel.textColor = self.secondaryColor;
            self.subTitleLabel.textColor = self.secondaryColor;
            image = [JFMinimalNotificationArt imageOfCheckmarkWithColor:self.primaryColor];
            self.accessoryView.backgroundColor = self.secondaryColor;
            break;
        }
            
        case JFMinimalNotificationStyleInfo: {
            self.primaryColor = [UIColor notificationOrangeColor];
            self.secondaryColor = [UIColor notificationWhiteColor];
            self.contentView.backgroundColor = self.primaryColor;
            self.titleLabel.textColor = self.secondaryColor;
            self.subTitleLabel.textColor = self.secondaryColor;
            image = [JFMinimalNotificationArt imageOfInfoWithColor:self.primaryColor];
            self.accessoryView.backgroundColor = self.secondaryColor;
            break;
        }
            
        case JFMinimalNotificationStyleWarning: {
            self.primaryColor = [UIColor notificationYellowColor];
            self.secondaryColor = [UIColor notificationBlackColor];
            self.contentView.backgroundColor = self.primaryColor;
            self.titleLabel.textColor = self.secondaryColor;
            self.subTitleLabel.textColor = self.secondaryColor;
            image = [JFMinimalNotificationArt imageOfWarningWithBGColor:self.primaryColor forgroundColor:self.secondaryColor];
            self.accessoryView.backgroundColor = self.secondaryColor;
            break;
        }
            
        case JFMinimalNotificationStyleDefault:
        default: {
            self.primaryColor = [UIColor notificationBlueColor];
            self.secondaryColor = [UIColor notificationWhiteColor];
            self.contentView.backgroundColor = self.primaryColor;
            self.titleLabel.textColor = self.secondaryColor;
            self.subTitleLabel.textColor = self.secondaryColor;
            image = [JFMinimalNotificationArt imageOfInfoWithColor:self.primaryColor];
            self.accessoryView.backgroundColor = self.secondaryColor;
            break;
        }
    }

    if (image)
    {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.accessoryView addSubview:imageView];
        NSDictionary* views = NSDictionaryOfVariableBindings(imageView);
        NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
        [self.accessoryView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.accessoryView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
        [self.accessoryView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.accessoryView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
        [self.accessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(<=30)]" options:0 metrics:metrics views:views]];
        [self.accessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(<=30)]" options:0 metrics:metrics views:views]];
        [self setLeftAccessoryView:self.accessoryView animated:animated];
    }
    else
    {
        [self setLeftAccessoryView:nil animated:animated];
    }
}

- (void)setTitle:(NSString*)title withSubTitle:(NSString*)subTitle
{
    BOOL hasButtons = (_leftButton || _rightButton);
    BOOL titleLabelCreatedNew = NO;
    
    if (title && title.length > 0)
    {
        if (!self.titleLabel)
        {
            self.titleLabel = [UILabel new];
            self.titleLabel.adjustsFontSizeToFitWidth = NO;
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:self.titleLabel];
            [self setTitleColor:_secondaryColor];
            
            UIView* titleLabel = self.titleLabel;
            NSDictionary* views = NSDictionaryOfVariableBindings(titleLabel);
            NSDictionary* metrics = @{@"labelHeight": @(kNotificationTitleLabelHeight),
                                      @"buttonHeight": @(kNotificationButtonHeight),
                                      @"buttonWidth": @(kNotificationButtonWidth),
                                      @"padding": @(kNotificationPadding),
                                      @"padding2x":@(kNotificationPadding * 2)};
        
            // removeConstraints if necessary
            if (self.titleLabelVerticalConsraints.count > 0)
            {
                [self.contentView removeConstraints:self.titleLabelVerticalConsraints];
            }
            
            if (self.leftButtonVerticalConstraints.count > 0)
            {
                [self.contentView removeConstraints:self.leftButtonVerticalConstraints];
                self.leftButtonVerticalConstraints = nil;
            }
            
            if (self.rightButtonVerticalConstraints.count > 0)
            {
                [self.contentView removeConstraints:self.rightButtonVerticalConstraints];
                self.rightButtonVerticalConstraints = nil;
            }
            
            if (hasButtons)
            {
                NSDictionary* views;
                
                if (_rightButton)
                {
                    views = NSDictionaryOfVariableBindings(_titleLabel, _leftButton, _rightButton);
                    self.rightButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-[_rightButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.rightButtonVerticalConstraints];
                }
                else
                {
                    views = NSDictionaryOfVariableBindings(_titleLabel, _leftButton);
                }
                
                self.titleLabelVerticalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-[_leftButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
            }
            else
            {
                self.titleLabelVerticalConsraints = @[[NSLayoutConstraint
                                                       constraintWithItem:self.titleLabel
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self.contentView
                                                       attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.f
                                                       constant:0.f]];
            }
            
            self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[titleLabel]-padding-|" options:0 metrics:metrics views:views];
            
            [self.contentView addConstraints:self.titleLabelVerticalConsraints];
            [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
            
            titleLabelCreatedNew = YES;
        }
        
        self.titleLabel.text = title;
        [self.titleLabel sizeToFit];
    }
    
    else
    {
        [self.titleLabel removeFromSuperview];
        self.titleLabel = nil;
    }
    
    if (subTitle && subTitle.length > 0)
    {
        if (!self.subTitleLabel || titleLabelCreatedNew)
        {
            self.subTitleLabel = [UILabel new];
            self.subTitleLabel.text = subTitle;
            self.subTitleLabel.numberOfLines = 0;
            self.subTitleLabel.adjustsFontSizeToFitWidth = NO;
            self.subTitleLabel.backgroundColor = [UIColor clearColor];
            self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:self.subTitleLabel];
            [self setSubTitleColor:_secondaryColor];
            
            NSDictionary* views;
            NSDictionary* metrics = @{@"labelHeight": @(kNotificationTitleLabelHeight),
                                      @"buttonHeight": @(kNotificationButtonHeight),
                                      @"buttonWidth": @(kNotificationButtonWidth),
                                      @"padding": @(kNotificationPadding),
                                      @"padding2x":@(kNotificationPadding * 2)};
            
            if (self.titleLabelVerticalConsraints.count > 0)
            {
                [self.contentView removeConstraints:self.titleLabelVerticalConsraints];
            }
            if (self.subTitleLabelVerticalConsraints.count > 0)
            {
                [self.contentView removeConstraints:self.subTitleLabelVerticalConsraints];
            }
            
            if (self.leftButtonVerticalConstraints.count > 0)
            {
                [self.contentView removeConstraints:self.leftButtonVerticalConstraints];
                self.leftButtonVerticalConstraints = nil;
            }
            
            if (self.rightButtonVerticalConstraints.count > 0)
            {
                [self.contentView removeConstraints:self.rightButtonVerticalConstraints];
                self.rightButtonVerticalConstraints = nil;
            }
            
            if (_titleLabel)
            {
                if (hasButtons)
                {
                    
                    if (_rightButton)
                    {
                        views = NSDictionaryOfVariableBindings(_titleLabel, _subTitleLabel, _leftButton, _rightButton);
                        self.rightButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_subTitleLabel]-[_rightButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
                        [self.contentView addConstraints:self.rightButtonVerticalConstraints];
                    }
                    else
                    {
                        views = NSDictionaryOfVariableBindings(_titleLabel, _subTitleLabel, _leftButton);
                    }
                    
                    self.subTitleLabelVerticalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel(>=labelHeight)][_subTitleLabel]-[_leftButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
                }
                else
                {
                    views = NSDictionaryOfVariableBindings(_titleLabel, _subTitleLabel);
                    self.subTitleLabelVerticalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel(>=labelHeight)][_subTitleLabel(>=labelHeight)]-padding-|" options:0 metrics:metrics views:views];
                }
            }
            else
            {
                if (hasButtons)
                {
                    if (_rightButton)
                    {
                        views = NSDictionaryOfVariableBindings(_subTitleLabel, _leftButton, _rightButton);
                        self.rightButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_subTitleLabel]-[_rightButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
                        [self.contentView addConstraints:self.rightButtonVerticalConstraints];
                    }
                    else
                    {
                        views = NSDictionaryOfVariableBindings(_subTitleLabel, _leftButton);
                    }
        
                    self.subTitleLabelVerticalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_subTitleLabel]-[_leftButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
                }
                else
                {
                    views = NSDictionaryOfVariableBindings(_subTitleLabel);
                    self.subTitleLabelVerticalConsraints = @[[NSLayoutConstraint constraintWithItem:self.subTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
                }
            }
            
            
            self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_subTitleLabel]-padding-|" options:0 metrics:metrics views:views];
            
            [self.contentView addConstraints:self.subTitleLabelVerticalConsraints];
            [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
        }
        
        self.subTitleLabel.text = subTitle;
        [self.subTitleLabel sizeToFit];
    }
    
    else
    {
        [self.subTitleLabel removeFromSuperview];
        self.subTitleLabel = nil;
    }
    
    if (self.isReadyToDisplay)
    {
        [self configureInitialNotificationConstraintsForTopPresentation:self.presentFromTop];
    }

}

- (void)setButtons:(NSString *)leftButtonString rightButtonString: (NSString *)rightButtonString leftButtonFill:(BOOL)leftButtonFill rightButtonFill:(BOOL)rightButtonFill
{
    BOOL needsLeftButton = (leftButtonString && leftButtonString.length > 0);
    BOOL needsRightButton = (rightButtonString && rightButtonString.length > 0);
    
    
    if (needsLeftButton)
    {
        BOOL needsToReInitialize = (needsLeftButton && _leftButton == nil) || (needsRightButton && _rightButton == nil);
        
        if (needsToReInitialize)
        {
            if (_leftButton == nil)
            {
                _leftButton = [self setupButton:leftButtonString buttonFill:leftButtonFill tag:kJFMinimalNotificationLeftButtonTag];
                [self.contentView addSubview:_leftButton];
            }
            
            if (needsRightButton && _rightButton == nil)
            {
                _rightButton = [self setupButton:rightButtonString buttonFill:rightButtonFill tag:kJFMinimalNotificationRightButtonTag];
                [self.contentView addSubview:_rightButton];
            }
            else
            {
                // remove rightButton
                if (_rightButton)
                {
                    [_rightButton removeFromSuperview];
                    _rightButton = nil;
                    _rightButtonFill = NO;
                }
            }
            
            // remove constraints if necessary
            if (self.leftButtonVerticalConstraints.count > 0)
            {
                [self.contentView removeConstraints:self.leftButtonVerticalConstraints];
                self.leftButtonVerticalConstraints = nil;
            }
            
            if (self.rightButtonVerticalConstraints.count > 0)
            {
                [self.contentView removeConstraints:self.rightButtonVerticalConstraints];
                self.rightButtonVerticalConstraints = nil;
            }
            
            if (self.buttonHorizontalConstraints.count > 0)
            {
                [self.contentView removeConstraints:self.buttonHorizontalConstraints];
                self.buttonHorizontalConstraints = nil;
            }
            
            if (self.titleLabelVerticalConsraints.count > 0)
            {
                [self.contentView removeConstraints:self.titleLabelVerticalConsraints];
                self.titleLabelVerticalConsraints = nil;
            }
            if (self.subTitleLabelVerticalConsraints.count > 0)
            {
                [self.contentView removeConstraints:self.subTitleLabelVerticalConsraints];
                self.subTitleLabelVerticalConsraints = nil;
            }
            
            NSDictionary* views;
            NSDictionary* metrics = @{@"labelHeight": @(kNotificationTitleLabelHeight),
                                      @"buttonHeight": @(kNotificationButtonHeight),
                                      @"buttonWidth": @(kNotificationButtonWidth),
                                      @"padding": @(kNotificationPadding),
                                      @"padding2x":@(kNotificationPadding * 2)};
            
            // title and subtitle both exist
            if (_titleLabel && _subTitleLabel)
            {
                if (needsRightButton)
                {
                    views = NSDictionaryOfVariableBindings(_titleLabel, _subTitleLabel, _leftButton, _rightButton);
                    
                    self.rightButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_subTitleLabel]-[_rightButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
                }
                else
                {
                    views = NSDictionaryOfVariableBindings(_titleLabel, _subTitleLabel, _leftButton);
                }
                
                self.leftButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel][_subTitleLabel]-[_leftButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
    
            }
            
            // only title exists
            else if (_titleLabel && !_subTitleLabel)
            {
                if (needsRightButton)
                {
                    views = NSDictionaryOfVariableBindings(_titleLabel, _leftButton, _rightButton);
                    
                    self.rightButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-[_rightButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
                }
                else
                {
                    views = NSDictionaryOfVariableBindings(_titleLabel, _leftButton);
                }
                
                self.leftButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel(>=labelHeight)]-[_leftButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
            }
            
            // only subtitle exists
            else if (!_titleLabel && _subTitleLabel)
            {
                if (needsRightButton)
                {
                    views = NSDictionaryOfVariableBindings(_subTitleLabel, _leftButton, _rightButton);
                    
                    self.rightButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_subTitleLabel]-[_rightButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
                    
                }
                
                self.leftButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_subTitleLabel]-[_leftButton(buttonHeight)]-padding-|" options:0 metrics:metrics views:views];
            }
            // none exists
            else
            {
                if (needsRightButton)
                {
                    views = NSDictionaryOfVariableBindings(_leftButton, _rightButton);
                    
                    self.rightButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_rightButton(buttonHeight)]-|" options:0 metrics:metrics views:views];
                }
                views = NSDictionaryOfVariableBindings(_leftButton, _rightButton);
                self.leftButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_leftButton(buttonHeight)]-|" options:0 metrics:metrics views:views];
            }
            
            if (needsRightButton)
            {
                self.buttonHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_leftButton(==_rightButton)]-[_rightButton]-padding-|" options:0 metrics:metrics views:views];
            }
            else
            {
                // add a constraint for the leftButton
                self.buttonHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_leftButton]-padding-|" options:0 metrics:metrics views:views];
            }
            
            [self.contentView addConstraints:self.leftButtonVerticalConstraints];
            [self.contentView addConstraints:self.buttonHorizontalConstraints];
            
            if (needsRightButton)
            {
                [self.contentView addConstraints:self.rightButtonVerticalConstraints];
            }
            
        }
        
        [_leftButton setTitle:leftButtonString forState:UIControlStateNormal];
        if (needsRightButton)
        {
            [_rightButton setTitle:rightButtonString forState:UIControlStateNormal];
        }
    }
    
    // all nil
    else
    {
        [_leftButton removeFromSuperview];
        [_rightButton removeFromSuperview];
        _leftButton = nil;
        _rightButton = nil;
        _leftButtonFill = NO;
        _rightButtonFill = NO;
        
    }
    
    if (self.isReadyToDisplay)
    {
        [self configureInitialNotificationConstraintsForTopPresentation:self.presentFromTop];
    }

}

- (UIButton *)setupButton:(NSString *)buttonText buttonFill:(BOOL)buttonFill tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tag = tag;
    
    if (tag == kJFMinimalNotificationLeftButtonTag)
        _leftButtonFill = buttonFill;
    else
        _rightButtonFill = buttonFill;
    
    button.layer.borderColor = self.secondaryColor.CGColor;
    button.layer.borderWidth = kNotificationButtonBorderWidth;;
    
    if (buttonFill)
    {
        
        button.backgroundColor = _secondaryColor;
        [button setTitleColor:_primaryColor forState:UIControlStateNormal];
        [button setTitleColor:[_primaryColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    }
    else
    {
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:_secondaryColor forState:UIControlStateNormal];
        [button setTitleColor:[_secondaryColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    }
    
    button.layer.cornerRadius = kNotificationButtonCornerRadius;
    button.titleLabel.font = [UIFont fontWithName:kDefaultFontName size:kDefaultFontSize - 2];
    [button setTitle:buttonText forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}

- (void)setTitleFont:(UIFont*)font
{
    if (self.titleLabel)
        [self.titleLabel setFont:font];
}

- (void)setSubTitleFont:(UIFont*)font
{
    if (self.subTitleLabel)
        [self.subTitleLabel setFont:font];
}

- (void)setTitleColor:(UIColor*)color
{
    if (self.titleLabel)
        [self.titleLabel setTextColor:color];
}

- (void)setSubTitleColor:(UIColor*)color
{
    if (self.subTitleLabel)
        [self.subTitleLabel setTextColor:color];
}

- (void)setLeftAccessoryView:(UIView*)view animated:(BOOL)animated
{
    NSTimeInterval animationDuration = (animated) ? 0.3f : 0.0f;
    if (view) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.leftAccessoryView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (![view isEqual:self.leftAccessoryView]) {
                [self.leftAccessoryView removeFromSuperview];
                _leftAccessoryView = view;
                _leftAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
                self.leftAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
                self.leftAccessoryView.alpha = 0.0f;
                [self.contentView addSubview:self.leftAccessoryView];
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* rightView = self.rightAccessoryView;
                UIView* leftView = self.leftAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                
                views = NSDictionaryOfVariableBindings(leftView);
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftAccessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftView(==60)]" options:0 metrics:nil views:views]];
                
                if (titleLabel) {
                    if (rightView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, leftView, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, leftView);
                    }
                    [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                    self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                }
                
                if (subTitleLabel) {
                    if (rightView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, leftView, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, leftView);
                    }
                    [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                    self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                }
                
                [self layoutIfNeeded];
                [self.leftAccessoryView makeRound];
                [UIView animateWithDuration:animationDuration animations:^{
                    self.leftAccessoryView.alpha = 1.0f;
                }];
            }
        }];
    } else {
        if ([self.contentView.subviews containsObject:self.leftAccessoryView]) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.leftAccessoryView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.leftAccessoryView.subviews enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL *stop) {
                    [subview removeFromSuperview];
                }];
                
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* rightView = self.rightAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                
                if (titleLabel) {
                    if (rightView) {
                        visualFormat = @"H:|-padding-[titleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[titleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel);
                    }
                    [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                    self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                }
                
                if (subTitleLabel) {
                    if (rightView) {
                        visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel);
                    }
                    [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                    self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                }
                
                [UIView animateWithDuration:animationDuration animations:^{
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [_leftAccessoryView removeFromSuperview];
                    _leftAccessoryView = nil;
                }];
            }];
        }
    }
}

- (void)setRightAccessoryView:(UIView*)view animated:(BOOL)animated
{
    NSTimeInterval animationDuration = (animated) ? 0.3f : 0.0f;
    if (view) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.rightAccessoryView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (![view isEqual:self.rightAccessoryView]) {
                [self.rightAccessoryView removeFromSuperview];
                _rightAccessoryView = view;
                _rightAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
                [self.contentView addSubview:self.rightAccessoryView];
                UIView* rightView = self.rightAccessoryView;
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightAccessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
                self.rightAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
                self.rightAccessoryView.alpha = 0.0f;
                
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* leftView = self.leftAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                
                if (titleLabel) {
                    if (leftView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, leftView, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[titleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, rightView);
                    }
                    [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                    self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rightView(==60)]" options:0 metrics:nil views:views]];
                }
                
                if (subTitleLabel) {
                    if (leftView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, leftView, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, rightView);
                    }
                    [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                    self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                }
                
                [self layoutIfNeeded];
                [self.rightAccessoryView makeRound];
                [UIView animateWithDuration:animationDuration animations:^{
                    self.rightAccessoryView.alpha = 1.0f;
                }];
            }
        }];
    } else {
        if ([self.contentView.subviews containsObject:self.rightAccessoryView]) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.rightAccessoryView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.rightAccessoryView.subviews enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL *stop) {
                    [subview removeFromSuperview];
                }];
                
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* leftView = self.leftAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                
                if (titleLabel) {
                    if (leftView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, leftView);
                    } else {
                        visualFormat = @"H:|-padding-[titleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel);
                    }
                    [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                    self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                }
                
                if (subTitleLabel) {
                    if (leftView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, leftView);
                    } else {
                        visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel);
                    }
                    [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                    self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                }
                
                [UIView animateWithDuration:animationDuration animations:^{
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [_rightAccessoryView removeFromSuperview];
                    _rightAccessoryView = nil;
                }];
            }];
        }
    }
}


- (void)setPrimaryColor:(UIColor *)primaryColor
{
    if (primaryColor)
    {
        _primaryColor = primaryColor;
        self.contentView.backgroundColor = _primaryColor;
    }
}
- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    if (secondaryColor)
    {
        _secondaryColor = secondaryColor;
        if (_titleLabel) self.titleLabel.textColor = _secondaryColor;
        if (_subTitleLabel) self.subTitleLabel.textColor = _secondaryColor;
        if (_accessoryView) self.accessoryView.backgroundColor = _secondaryColor;
        if (_leftButton)
        {
            _leftButton.layer.borderColor = _secondaryColor.CGColor;
            
            if (_leftButtonFill)
            {
                _leftButton.backgroundColor = _secondaryColor;
                [_leftButton setTitleColor:_primaryColor forState:UIControlStateNormal];
                [_leftButton setTitleColor:[_primaryColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
            }
            else
            {
                _leftButton.backgroundColor = [UIColor clearColor];
                [_leftButton setTitleColor:_secondaryColor forState:UIControlStateNormal];
                [_leftButton setTitleColor:[_secondaryColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
            }
        }
        if (_rightButton)
        {
            _rightButton.layer.borderColor = _secondaryColor.CGColor;
            
            if (_rightButtonFill)
            {
                _rightButton.backgroundColor = _secondaryColor;
                [_rightButton setTitleColor:_primaryColor forState:UIControlStateNormal];
                [_rightButton setTitleColor:[_primaryColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
            }
            else
            {
                _rightButton.backgroundColor = [UIColor clearColor];
                [_rightButton setTitleColor:_secondaryColor forState:UIControlStateNormal];
                [_rightButton setTitleColor:[_secondaryColor colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
            }
        }
    }
}

#pragma mark ----------------------
#pragma mark Touch Handler
#pragma mark ----------------------

- (void)handleTap
{
    if (self.touchHandler)
    {
        self.touchHandler();
    }
}

- (void)handleButtonTap:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JFMinimalNotification:didTapButton:)]) {
        [self.delegate JFMinimalNotification:self didTapButton:button];
    }
}

@end
