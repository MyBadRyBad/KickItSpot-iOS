//
//  Constants.h
//  KickitSpotMobile
//
//  Created by Irwin Gonzales on 2/3/16.
//  Copyright © 2016 Irwin Gonzales. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#endif /* Constants_h */



//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// Backend Parse definitions
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////

// user class
static NSString* const kParseClassUserKey =         @"User";
static NSString* const kParseUserProfilePictureKey = @"profilePicture";
static NSString* const kParseUserLocationKey =      @"location";
static NSString* const kParseUserFirstNameKey =     @"first_name";
static NSString* const kParseUserLastNameKey =      @"last_name";
static NSString* const kParseUserEmailKey =         @"email";
static NSString* const kParseUserFacebookIDKeySDK = @"id";
static NSString* const kParseUserUsernameKey =      @"username";

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// Font Definitions
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
static NSString* const kDefaultFontName = @"OpenSans";
static NSString* const kDefaultFontNameBold = @"Opensans-Semibold";
static NSString* const kJVFloatLabeledTextFieldPlaceholderFont = @"OpenSans-Semibold";

static CGFloat const kDefaultFontSize = 16.0f;
static CGFloat const kButtonFontSize = 20.0f;

#define DEFAULT_TEXT_COLOR_WELCOME_VIEW         [UIColor whiteColor]
#define DEFAULT_TEXT_TINT_COLOR_WELCOME_VIEW    [UIColor whiteColor]
#define PLACEHOLDER_TEXT_COLOR_WELCOME_VIEW     [UIColor colorWithWhite:0.9 alpha:1.0f]
#define DEFAULT_TEXT_COLOR(ALPHA)               [UIColor whiteColor]
#define DEFAULT_ONBOARDING_BACKGROUND_COLOR     [kColorConstants blueMidnightBlue:1.0f]

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// AlertView Error Definitions
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////

static NSString* const kAlertViewErrorTitle = @"Uh oh!";
static NSString* const kAlertViewErrorCancelButton = @"Ok";

static NSString* const kAlertViewErrorMessage_AccountNeedsLink = @"It looks like you already have an account with KickItSpot. Sign in and then go to Settings to link your Facebook.";
static NSInteger const kErrorCode_AccountNeedsLink = 1650;

static NSString* const kAlertViewErrorMessage_ConnectionFailed = @"The Internet connection appears to be offline.";
static NSString* const kAlertViewErrorMessage_ServerConnection = @"Could not connect to the server.";
static NSString* const kAlertViewErrorMessage_EmailExists = @"Email is already taken.";
static NSString* const kAlertViewErrorMessage_EmailNotFound = @"This email does not exist.";
static NSString* const kAlertViewErrorMessage_EmailPasswordIncorrect = @"Email address could not be found/the password is incorrect.";

static NSString* const kAlertViewErrorMessage_FacebookAccountAlreadyExists = @"We couldn't link your account. Looks like an existing account is already linked.";


//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
// definitions for iphone screens + models
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define IPHONE4_SCREEN_DIFFERENCE 88.0

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) // iPhone and       iPod touch style UI

#define IS_IPHONE_5_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4_AND_OLDER_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)

#define IS_IPHONE_5_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 568.0f)
#define IS_IPHONE_6_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 667.0f)
#define IS_IPHONE_6P_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 736.0f)
#define IS_IPHONE_4_AND_OLDER_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) < 568.0f)

#define IS_IPHONE_5 ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_5_IOS8 : IS_IPHONE_5_IOS7 )
#define IS_IPHONE_6 ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_6_IOS8 : IS_IPHONE_6_IOS7 )
#define IS_IPHONE_6P ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_6P_IOS8 : IS_IPHONE_6P_IOS7 )
#define IS_IPHONE_4_AND_OLDER ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_4_AND_OLDER_IOS8 : IS_IPHONE_4_AND_OLDER_IOS7 )