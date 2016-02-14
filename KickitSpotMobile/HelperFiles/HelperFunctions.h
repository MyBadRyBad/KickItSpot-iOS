//
//  HelperFunctions.h
//  KickItSpot
//
//  Created by Ryan Badilla on 11/20/14.
//  Copyright (c) 2014 Newdesto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HelperFunctions : NSObject

//////////////////////////////////////////////////////////
// Navigation hairline removal
//////////////////////////////////////////////////////////
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

//////////////////////////////////////////////////////////
// Progress HUD
//////////////////////////////////////////////////////////
+ (void)showProgressHUDWithText:(NSString *)text view:(UIView *)view animated:(BOOL)animated;
+ (void)hideProgressHUDForView:(UIView *)view animated:(BOOL)animated;

//////////////////////////////////////////////////////////
// user data helper methods
//////////////////////////////////////////////////////////
+ (NSString *)dateStringWithDate:(NSDate *)date dateFormatter:(NSDateFormatter *)dateFormatter;

//////////////////////////////////////////////////////////
// date helpers
//////////////////////////////////////////////////////////
+ (NSDate*)dateWithDay:(NSInteger)day time:(NSDate *)time;
+ (NSDate*)dateWithDay:(NSInteger)day timeHour:(NSInteger)timeHour timeMinute:(NSInteger)timeMinute;
+ (NSDate*)datewithDate:(NSDate *)date time:(NSDate *)time;
+ (NSDate *)getPreviousDayFromDecrement:(NSInteger)previousDayDecrement fromDate:(NSDate *)date;
+ (NSDate *)getNextDayFromIncrement:(NSInteger)nextDayIncrement fromDate:(NSDate *)date;
+ (NSArray *)checkForSevenDay:(NSMutableArray *)array;

+ (BOOL)date:(NSDate *)date1 isSameDay:(NSDate *)date2;
+ (BOOL)dateIsToday:(NSDate *)date;
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

//////////////////////////////////////////////////////////
// UIImage helper methods
//////////////////////////////////////////////////////////
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)imageFromText:(NSString *)text font:(UIFont *)font;
+ (UIImage *)blankImage:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;

//////////////////////////////////////////////////////////
// number of lines
//////////////////////////////////////////////////////////
+(NSInteger)getNumberOfLinesInLabelOrTextView:(id)obj;

//////////////////////////////////////////////////////////
// methods for testing
//////////////////////////////////////////////////////////
+ (void)printAvailableFonts;
+ (void)printCGRect:(CGRect)rect title:(NSString*)title;
+ (NSMutableArray *)getArrayOfFixedDatesForDeLoreanStripTesting;


//////////////////////////////////////////////////////////
// methods for testing notifications
//////////////////////////////////////////////////////////
+ (BOOL)notificationServicesEnabled;
@end
