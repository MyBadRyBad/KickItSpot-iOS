//
//  KickItSpotMainBox.m
//  KickitSpot
//
//  Created by Ryan Badilla on 2/28/16.
//  Copyright © 2016 Newdesto. All rights reserved.
//

#import "KickItSpotMainBox.h"
#import "HelperFunctions.h"
#import "kColorConstants.h"
#import "kConstants.h"
#import "GRKGradientView.h"

@interface KickItSpotMainBox()

@property (nonatomic, strong) GRKGradientView *gradientView;

@end

@implementation KickItSpotMainBox

#pragma mark -
#pragma mark - Initialization
- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setupView];
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setupView];
    }
    
    return self;
}

#pragma mark -
#pragma mark - setup
- (void)setupView
{
    [self addSubview:[self backgroundImage]];
    [self addSubview:[self gradientView]];
    [self addSubview:[self kickItSpotNameLabel]];
    [self addSubview:[self aboutLabel]];
    [self addSubview:[self subscribeButton]];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_backgroundImage, _kickItSpotNameLabel, _aboutLabel, _subscribeButton, _gradientView);
    NSDictionary *metrics = @{@"nameHeight": @(kKickItSpotMainBoxFontSize + 2),
                              @"aboutHeight" : @(kKickItSpotAboutFontSize + 2),
                              @"subscribeButtonHeight" : @(35),
                              @"subscribeButtonWidth" : @(90),
                              @"gradientViewHeight" : @(40)};
    
    // add vertical constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImage]|" options:0 metrics:metrics views:viewsDictionary]];
    
   // [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_gradientView(gradientViewHeight)]|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_gradientView]|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_kickItSpotNameLabel(nameHeight)]-[_aboutLabel(aboutHeight)]-|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_subscribeButton(subscribeButtonHeight)]" options:0 metrics:metrics views:viewsDictionary]];
    
    // add horizontal constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImage]|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_gradientView]|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_kickItSpotNameLabel]-|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_aboutLabel]-|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_subscribeButton(subscribeButtonWidth)]-|" options:0 metrics:metrics views:viewsDictionary]];
}


#pragma mark -
#pragma mark - getter methods
- (UIImageView *)backgroundImage
{
    if (!_backgroundImage)
    {
        _backgroundImage = [[UIImageView alloc] init];
        _backgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIColor *randomColor = [HelperFunctions randomFlatUIColor];
        [_backgroundImage setImage:[HelperFunctions imageWithColor:randomColor]];
    }
    
    return _backgroundImage;
}

- (UILabel *)kickItSpotNameLabel
{
    if (!_kickItSpotNameLabel)
    {
        _kickItSpotNameLabel = [[UILabel alloc] init];
        _kickItSpotNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _kickItSpotNameLabel.textColor = [UIColor whiteColor];
        _kickItSpotNameLabel.font = [UIFont fontWithName:kDefaultFontName size:kKickItSpotAboutFontSize];
    }
    
    return _kickItSpotNameLabel;
}

- (UILabel *)aboutLabel
{
    if (!_aboutLabel)
    {
        _aboutLabel = [[UILabel alloc] init];
        _aboutLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _aboutLabel.textColor = [UIColor whiteColor];
        _aboutLabel.font = [UIFont fontWithName:kDefaultFontName size:kKickItSpotMainBoxFontSize];
    }
    
    return _aboutLabel;
}

- (UIButton *)subscribeButton
{
    if (!_subscribeButton)
    {
        _subscribeButton = [[UIButton alloc] init];
        _subscribeButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _subscribeButton;
}


- (GRKGradientView *)gradientView
{
    if (!_gradientView)
    {
        _gradientView = [[GRKGradientView alloc] init];
        _gradientView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _gradientView.backgroundColor = [UIColor clearColor];
        _gradientView.opaque = YES;
        
        _gradientView.gradientOrientation = GRKGradientOrientationUp;
        _gradientView.gradientColors = [NSArray arrayWithObjects:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f], [UIColor clearColor], nil];
    }
    
    return _gradientView;
}

@end
