//
//  kStringConstants.h
//  KickitSpot
//
//  Created by Ryan Badilla on 2/27/16.
//  Copyright © 2016 Newdesto. All rights reserved.
//

#ifndef kStringConstants_h
#define kStringConstants_h


#endif /* kStringConstants_h */

#import <UIKit/UIKit.h>

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
// Tab Bar strings
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////
static NSString* const kTabBarTextSpots = @"Spots";
static NSString* const kTabBarTextSubscribed = @"Subscribed";
static NSString* const kTabBarTextSettings = @"Settings";