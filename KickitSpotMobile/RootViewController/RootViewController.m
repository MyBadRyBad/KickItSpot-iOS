//
//  RootViewController.m
//  KickitSpot
//
//  Created by Ryan Badilla on 2/7/16.
//  Copyright © 2016 Newdesto. All rights reserved.
//

#import "RootViewController.h"
#import "KITabBarController.h"
#import <IonIcons.h>
#import "MainPageViewController.h"
#import "SettingsViewController.h"
#import "SubscribedSpotViewController.h"
#import "kColorConstants.h"
#import "kStringConstants.h"
#import "HelperFunctions.h"
#import "kConstants.h"
#import <objc/runtime.h>

@interface RootViewController ()

@property (nonatomic, strong) ZCDuangLabel *kickItSpotLabel;

@end

@implementation RootViewController

#pragma mark -
#pragma mark - ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
    
    [HelperFunctions printAvailableFonts];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self animateLogoLabelAndLaunch];
}




#pragma mark - 
#pragma mark - setup
- (void)setupViewController
{
   [self.view addSubview:[self kickItSpotLabel]];
    
   // [self setupConstraints];
    
}

- (void)setupConstraints
{
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_kickItSpotLabel);
    NSDictionary *metrics = @{@"labelHeight" : @(80)};
    
    // vertical constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_kickItSpotLabel(labelHeight)]" options:0 metrics:metrics views:viewsDictionary]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_kickItSpotLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    // horizontal constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_kickItSpotLabel]-|" options:0 metrics:metrics views:viewsDictionary]];
}

#pragma mark -
#pragma mark - View Controller Launch
- (void)animateLogoLabelAndLaunch
{
    _kickItSpotLabel.text = @"KickItSpot";
    _kickItSpotLabel.animationDuration = 0.50f;
    _kickItSpotLabel.animationDelay = 0.25f;
    _kickItSpotLabel.onlyDrawDirtyArea = YES;
    _kickItSpotLabel.layerBased = NO;
    
    UIColor *greyColor = [UIColor colorWithRed:67.0f/255.0f green:74.0f/255.0f blue:84.0f/255.0f alpha:1.0f];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *mutableString = [[[NSAttributedString alloc] initWithString:_kickItSpotLabel.text attributes:@{NSFontAttributeName : [UIFont fontWithName:kLogoFontName size:45.0f], NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor blackColor]}] mutableCopy];
    [mutableString addAttribute:NSForegroundColorAttributeName value:greyColor range:[mutableString.string rangeOfString:@"KickIt"]];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[kColorConstants blueCharizard:1.0f] range:[mutableString.string rangeOfString:@"Spot"]];
    
    _kickItSpotLabel.attributedString = mutableString;
    
    [_kickItSpotLabel startAppearAnimation];
    [self performSelector:@selector(setupViewAndLaunch) withObject:nil afterDelay:4.0f];
}

- (void)setupViewAndLaunch
{
    // initialize tab bar images
    UIImage *spotsImageSelected = [IonIcons imageWithIcon:ion_android_radio_button_off size:30.0f color:[kColorConstants purpleWisteria:1.0f]];
    UIImage *subscribedImageSelected = [IonIcons imageWithIcon:ion_android_favorite_outline size:30.0f color:[kColorConstants purpleWisteria:1.0f]];
    UIImage *settingsImageSelected = [IonIcons imageWithIcon:ion_android_menu size:30.0f color:[kColorConstants purpleWisteria:1.0f]];
    
    UIImage *spotsImage = [IonIcons imageWithIcon:ion_android_radio_button_off size:30.0f color:[kColorConstants greyConcrete:1.0f]];
    UIImage *subscribedImage = [IonIcons imageWithIcon:ion_android_favorite_outline size:30.0f color:[kColorConstants greyConcrete:1.0f]];
    UIImage *settingsImage = [IonIcons imageWithIcon:ion_android_menu size:30.0f color:[kColorConstants greyConcrete:1.0f]];
    
    MainPageViewController *mainPageViewController = [[MainPageViewController alloc] init];
    SubscribedSpotViewController *subscribedSpotViewController = [[SubscribedSpotViewController alloc] init];
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    
    KITabBarController *tabBarController = [[KITabBarController alloc] init];
    tabBarController.tabBar.tintColor = [kColorConstants purpleWisteria:1.0f];

    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] initWithObjects:mainPageViewController, subscribedSpotViewController, settingsViewController, nil];
    
    // setup tab bar and tabBarItems
    [tabBarController setViewControllers:tabViewControllers];
    
    mainPageViewController.tabBarItem =[[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBarTextSpots, nil) image:spotsImage selectedImage:spotsImageSelected];
    
    subscribedSpotViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBarTextSubscribed, nil) image:subscribedImage selectedImage:subscribedImageSelected];
    
    settingsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(kTabBarTextSettings, nil) image:settingsImage selectedImage:settingsImageSelected];
    
    
    // setup navigation bar
    UINavigationController *navigationBarController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    
    // present
    [self presentViewController:navigationBarController animated:YES completion:nil];
}


#pragma mark -
#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedButton:(id)sender
{
    [_kickItSpotLabel setNeedsDisplay];
    [_kickItSpotLabel startAppearAnimation];
}

#pragma mark -
#pragma mark - getter methods
- (ZCDuangLabel *)kickItSpotLabel
{
    if (!_kickItSpotLabel)
    {

        _kickItSpotLabel = [[ZCDuangLabel alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.height * 0.5) - 45, self.view.frame.size.width - 40, 90)];
    }
    
    return _kickItSpotLabel;
}


@end
