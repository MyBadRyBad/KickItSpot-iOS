//
//  kColorConstants.m
//  ThriveSync
//
//  Created by Ryan Badilla on 2/25/15.
//  Copyright (c) 2015 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kColorConstants.h"
#import "kConstants.h"

@implementation kColorConstants

#pragma mark -
#pragma mark - colors
+ (UIColor *)bodyTextColor:(float)alpha
{
    return [kColorConstants greyAsbestos:1.0f];
}
+ (UIColor *)progressHUDColor:(float)alpha
{
    return [self greenNephritisColor:alpha];
}

+ (UIColor *)defaultNavigationColor:(float)alpha
{
    return [UIColor whiteColor];
}

+(UIColor *)concreteColor
{
    return [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1.0];
}

+(UIColor *)redErrorColor
{
    return [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
}

+(UIColor *)facebookBlue:(float)alpha
{
    return [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:alpha];
}

+(UIColor *)greenTurquoiseColor:(float)alpha
{
    return [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:alpha];
}

+(UIColor *)greenEmeraldColor:(float)alpha
{
    return [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:alpha];
}

+(UIColor *)greenGreenSeaColor:(float)alpha
{
    return [UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:alpha];
}

+(UIColor *)greenNephritisColor:(float)alpha
{
    return [UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:alpha];
}

+(UIColor *)yellowSunflower:(float)alpha
{
    return [UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:alpha];
}

+(UIColor *)orangeOrange:(float)alpha
{
    return [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:alpha];
}

+(UIColor *)orangeCarrot:(float)alpha
{
    return [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:alpha];
}

+(UIColor *)orangePumpkin:(float)alpha
{
    return [UIColor colorWithRed:211.0/255.0 green:84.0/255.0 blue:0.0/255.0 alpha:alpha];
}

+(UIColor *)redAlizarin:(float)alpha
{
    return [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:alpha];
}

+(UIColor *)redPomegranate:(float)alpha
{
    return [UIColor colorWithRed:192.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:alpha];
}

//blue
+(UIColor *)bluePeterRiver:(float)alpha
{
    return [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:alpha];
}

+(UIColor *)blueBelizeHole:(float)alpha
{
    return [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:alpha];
}

//darkblue?
+(UIColor *)blueWetAsphalt:(float)alpha
{
    return [UIColor colorWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:alpha];
}

+(UIColor *)blueMidnightBlue:(float)alpha
{
    return [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:alpha];
}

//grey
+(UIColor *)greyClouds:(float)alpha
{
    return [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:alpha];
}

+(UIColor *)greyConcrete:(float)alpha
{
    return [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:alpha];
}

+(UIColor *)greySilver:(float)alpha
{
    return [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:alpha];
}

+(UIColor *)greyAsbestos:(float)alpha
{
    return [UIColor colorWithRed:127.0/255.0 green:140.0/255.0 blue:141.0/255.0 alpha:alpha];
}

+(UIColor *)purpleAmethyst:(float)alpha
{
    return [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:alpha];
}

+(UIColor *)purpleWisteria:(float)alpha
{
    return [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:alpha];
}


#pragma mark - flatuicolorpicker.com colors

//red
+(UIColor *)redChestnutRose:(float)alpha;
{
    return [UIColor colorWithRed:210.0/255.0 green:77.0/255.0 blue:87.0/255.0 alpha:alpha];
}

+(UIColor *)redPomegranate2:(float)alpha
{
    return [UIColor colorWithRed:242.0/255.0 green:38.0/255.0 blue:19.0/255.0 alpha:alpha];
}

+(UIColor *)redRed:(float)alpha
{
    return [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:alpha];
}

+(UIColor *)redThunderbird:(float)alpha
{
    return [UIColor colorWithRed:217.0/255.0 green:30.0/255.0 blue:24.0/255.0 alpha:alpha];
}

+(UIColor *)redOldBrick:(float)alpha
{
    return [UIColor colorWithRed:150.0/255.0 green:40.0/255.0 blue:27.0/255.0 alpha:alpha];
}

+(UIColor *)redFlamingo:(float)alpha
{
    return [UIColor colorWithRed:239.0/255.0 green:72.0/255.0 blue:54.0/255.0 alpha:alpha];
}

+(UIColor *)redValencia:(float)alpha
{
    return [UIColor colorWithRed:214.0/255.0 green:69.0/255.0 blue:65.0/255.0 alpha:alpha];
}

+(UIColor *)redTallPoppy:(float)alpha
{
    return [UIColor colorWithRed:192.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:alpha];
}

+(UIColor *)redMonza:(float)alpha
{
    return [UIColor colorWithRed:207.0/255.0 green:0.0/255.0 blue:15.0/255.0 alpha:alpha];
}

+(UIColor *)redCinnabar:(float)alpha
{
    return [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:alpha];
}

// pink
+(UIColor *)pinkRazzmatazz:(float)alpha
{
    return [UIColor colorWithRed:219.0/255.0 green:10.0/255.0 blue:91.0/255.0 alpha:alpha];
}

+(UIColor *)pinkDerby:(float)alpha
{
    return [UIColor colorWithRed:255.0/255.0 green:236.0/255.0 blue:219.0/255.0 alpha:alpha];
}

+(UIColor *)pinkSunsetOrange:(float)alpha
{
    return [UIColor colorWithRed:246.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:alpha];
}

+(UIColor *)pinkWaxFlower:(float)alpha
{
    return [UIColor colorWithRed:241.0/255.0 green:169.0/255.0 blue:160.0/255.0 alpha:alpha];
}

+(UIColor *)pinkCabaret:(float)alpha
{
    return [UIColor colorWithRed:210.0/255.0 green:82.0/255.0 blue:127.0/255.0 alpha:alpha];
}

+(UIColor *)pinkNewYorkPink:(float)alpha
{
    return [UIColor colorWithRed:224.0/255.0 green:130.0/255.0 blue:131.0/255.0 alpha:alpha];
}

+(UIColor *)pinkRadicalRed:(float)alpha
{
    return [UIColor colorWithRed:246.0/255.0 green:36.0/255.0 blue:89.0/255.0 alpha:alpha];
}

+(UIColor *)pinkSunglo:(float)alpha
{
    return [UIColor colorWithRed:226.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:alpha];
}

+(UIColor *)navigationBarColor:(float)alpha
{
  //  return [UIColor colorWithRed:39.9/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:alpha];
  //  return [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:alpha];
    return [self purpleAmethyst:1.0f];
}

+(UIColor *)tabBarColor:(float)alpha
{
    return [self greySilver:1.0f];
  //  return [UIColor colorWithRed:187.0 /255.0 green:222.0/255.0 blue:251.0/255.0 alpha:alpha];
    
 /*   CGFloat red = 255.0f - 44.0f;
    CGFloat green = 255.0f - 62.0f;
    CGFloat blue = 255.0 - 80.0f;
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha]; */
}

// background color
+ (UIColor *)backgroundColor
{
    //return [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0];
    return [self purpleAmethyst:1.0f];
}



@end
