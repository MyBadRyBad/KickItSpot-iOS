//
//  HelperFunctions.m
//  ThriveSync
//
//  Created by Ryan Badilla on 11/20/14.
//  Copyright (c) 2014 ThriveStreams. All rights reserved.
//

#import "HelperFunctions.h"
#import "MBProgressHUD.h"
#import "NSDate+Utilities.h"
#import "kConstants.h"
#import "kColorConstants.h"
#import "MBProgressHUD.h"
//#import <AppboyKit.h>

#define SUNDAY      1
#define MONDAY      2
#define TUESDAY     3
#define WEDNESDAY   4
#define THURSDAY    5
#define FRIDAY      6
#define SATURDAY    7

@implementation HelperFunctions

#pragma mark -
#pragma mark - navigation hairline removal
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark - keyboard Input Accessory


#pragma mark -
#pragma mark - progress hud helper methods
+ (void)showProgressHUDWithText:(NSString *)text view:(UIView *)view animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.color = [kColorConstants defaultNavigationColor:1.0f];
    hud.labelFont = [UIFont fontWithName:kDefaultFontName size:kDefaultFontSize];
    hud.labelText = text;
}

+ (void)hideProgressHUDForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:animated];
}


+ (NSString *)dateStringWithDate:(NSDate *)date dateFormatter:(NSDateFormatter *)dateFormatter
{
    NSString *dateString;
    
    if (dateFormatter == nil)
        dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDateComponents *componentsToday = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *componentsDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger day = [componentsToday day] - [componentsDate day];
    //   if (dayDiff == 0)
    if (day == 0)
    {
        [dateFormatter setDateFormat:@"MM/dd/yy"];
        dateString = [NSString stringWithFormat:@"Today - %@", [dateFormatter stringFromDate:date]];
    }
    //   else if (dayDiff == -1)
    else if (day == 1)
    {
        [dateFormatter setDateFormat:@"MM/dd/yy"];
        dateString = [NSString stringWithFormat:@"Yesterday - %@", [dateFormatter stringFromDate:date]];
    }
    else
    {
        [dateFormatter setDateFormat:@"EEEE '-' MM/dd/yy"];
        dateString = [dateFormatter stringFromDate:date];
    }
    
    
    return dateString;
}


+(NSDictionary *)getWeekStartAndEndDates:(NSDate *)startDate
{
    // Calculate first day in week
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:startDate];
    
    //calcuate number of days to substract from today, in order to get the first day of the week. In this case, the first day of the week is monday. This is represented by adding 2 to the setDay.
    //Sunday = 1, Monday = 2, Tuesday = 3, Wednesday = 4, Thursday = 5, Friday = 6 and Saturday = 7. By adding more to this integers, you will go into the next week.
    NSDateComponents *componentsToSubtract  = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: (0 - [weekdayComponents weekday]) + 1];
    [componentsToSubtract setHour: 0 - [weekdayComponents hour]];
    [componentsToSubtract setMinute: 0 - [weekdayComponents minute]];
    [componentsToSubtract setSecond: 0 - [weekdayComponents second]];
    
    //Create date for first day in week
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:startDate options:0];
    
    //By adding 6 to the date of the first day, we can get the last day, in our example Sunday.
    NSDateComponents *componentsToAdd = [gregorian components:NSCalendarUnitDay fromDate:beginningOfWeek];
    [componentsToAdd setDay:6];
    
    NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:beginningOfWeek options:0];
    
    
    NSDictionary *days = [[NSDictionary alloc] initWithObjects:@[beginningOfWeek, endOfWeek] forKeys:@[@"head", @"tail"]];
    return days;
}


#pragma mark -
#pragma mark - Date helpers
+ (NSDate*)dateWithDay:(NSInteger)day time:(NSDate *)time
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setLocale:[NSLocale currentLocale]];
    
    NSDateComponents *nowComponents = [gregorian components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:time];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    [nowComponents setWeekday:day]; // 1 is sunday, 2 monday...
    [nowComponents setWeekOfMonth:[nowComponents weekOfMonth]]; //current week
    [nowComponents setHour:hour];
    [nowComponents setMinute:minute];
    [nowComponents setSecond:0];
    
    NSDate *newDate = [gregorian dateFromComponents:nowComponents];
    
    return newDate;
}
+ (NSDate*)dateWithDay:(NSInteger)day timeHour:(NSInteger)timeHour timeMinute:(NSInteger)timeMinute
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setLocale:[NSLocale currentLocale]];
    
    NSDateComponents *nowComponents = [gregorian components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
    
    [nowComponents setWeekday:day]; // 1 is sunday, 2 monday...
    [nowComponents setWeekOfMonth:[nowComponents weekOfMonth]]; //current week
    [nowComponents setHour:timeHour];
    [nowComponents setMinute:timeMinute];
    [nowComponents setSecond:0];
    
    NSDate *newDate = [gregorian dateFromComponents:nowComponents];
    
    return newDate;
}

+ (NSDate*) datewithDate:(NSDate *)date time:(NSDate *)time
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:date];
    NSDateComponents *timeComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:time];
    
    NSDateComponents *newComponents = [[NSDateComponents alloc]init];
//    newComponents.timeZone = [NSTimeZone systemTimeZone];
    [newComponents setYear:[dateComponents year]];
    [newComponents setMonth:[dateComponents month]];
    [newComponents setDay:[dateComponents day]];
    [newComponents setHour:[timeComponents hour]];
    [newComponents setMinute:[timeComponents minute]];
    [newComponents setSecond:[timeComponents second]]; 
    
    NSDate *combDate = [calendar dateFromComponents:newComponents];
    
    // safety check to see if the days match

    NSInteger differenceInDays = [combDate distanceInDaysToDate:date];
    [combDate dateByAddingDays:differenceInDays];
    return combDate;
}

+ (NSDate *)getPreviousDayFromDecrement:(NSInteger)previousDayDecrement fromDate:(NSDate *)date
{
    // force a negative
    if (previousDayDecrement > 0)
        previousDayDecrement = (previousDayDecrement * -1);
    
    return [HelperFunctions getNextDayFromIncrement:previousDayDecrement fromDate:date];
}


+ (NSDate *)getNextDayFromIncrement:(NSInteger)nextDayIncrement fromDate:(NSDate *)date;
{
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:nextDayIncrement];
    
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *newDay = [gregorian dateByAddingComponents:components toDate:date options:0];
    
    return newDay;
}



+ (NSArray *)checkForSevenDay:(NSMutableArray *)array
{
    return nil;
}

+ (BOOL)date:(NSDate *)date1 isSameDay:(NSDate *)date2
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date1];
    NSDate *firstDate = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date2];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([firstDate isEqualToDate:otherDate])
        return true;
    else
        return false;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    NSInteger result = [difference day];
    
    if (result < 0)
        result = result * -1;
    
    return result;
}

+ (BOOL)dateIsToday:(NSDate *)date
{
    return [HelperFunctions date:[NSDate date] isSameDay:date];
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *beginDateComponents = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:beginDate];
    NSDateComponents *endDateComponents = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:endDate];
    
    NSDateComponents *dateComponents = [cal components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSComparisonResult beginDateComparison = [[cal dateFromComponents:dateComponents] compare:[cal dateFromComponents:beginDateComponents]];
    
    NSComparisonResult endDateComparison = [[cal dateFromComponents:dateComponents] compare:[cal dateFromComponents:endDateComponents]];
    
    if (beginDateComparison == NSOrderedAscending)
        return NO;
    
    if (endDateComparison == NSOrderedDescending)
        return NO;
    
    return YES;
}


#pragma mark -
#pragma mark - uiimage helpers
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)imageFromText:(NSString *)text font:(UIFont *)font
{
    // set the font type and size
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];

    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (/* DISABLES CODE */ (&UIGraphicsBeginImageContextWithOptions) != NULL)
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    
    // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
    //
    // CGContextRef ctx = UIGraphicsGetCurrentContext();
    // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
    
    // draw in context, you can use also drawInRect:withFont:
    [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:@{NSFontAttributeName: font}];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)blankImage:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blank;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark -
#pragma mark - helper methods
+ (NSInteger)getNumberOfLinesInLabelOrTextView:(id)obj
{
    NSInteger lineCount = 0;
    if([obj isKindOfClass:[UILabel class]])
    {
        UILabel *label = (UILabel *)obj;
        
        CGSize maxSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
        
        
        CGRect labelRect = [label.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
        
        int charSize = label.font.leading;
        if (charSize == 0) charSize = kDefaultFontSize + 1;
        int rHeight = labelRect.size.height;
        
        lineCount = rHeight/charSize;
    }
    else if ([obj isKindOfClass:[UITextView class]])
    {
        UITextView *textView = (UITextView *)obj;
        lineCount = textView.contentSize.height / textView.font.leading;
    }
    
    return lineCount;
}

+ (void)printAvailableFonts
{
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

+ (void)printCGRect:(CGRect)rect title:(NSString*)title
{
    CGFloat originX = rect.origin.x;
    CGFloat originY = rect.origin.y;
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    NSLog(@"%@ - \nOriginX: %f\nOriginY: %f\nWidth: %f\nHeight: %f", title, originX, originY, width, height);
}

+ (NSMutableArray *)getArrayOfFixedDatesForDeLoreanStripTesting
{
    NSMutableArray *arrayOfDates = [[NSMutableArray alloc] init];
    NSDate *todayDate = [NSDate date];
    
    for (int index = 0; index < 7; index++)
    {
        NSDate *newDate = [todayDate dateBySubtractingDays:(index + 1)];
        [arrayOfDates addObject:newDate];
    }
    
    
    return arrayOfDates;
}

+ (BOOL)notificationServicesEnabled
{
    BOOL isEnabled = NO;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){
        UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (!notificationSettings || (notificationSettings.types == UIUserNotificationTypeNone)) {
            isEnabled = NO;
        } else {
            isEnabled = YES;
        }
    } else {
        isEnabled = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    
    return isEnabled;
}


@end
