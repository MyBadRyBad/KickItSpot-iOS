//
//  BackendFunctions.m
//  
//
//  Created by Irwin Gonzales on 2/2/16.
//
//

#import "BackendFunctions.h"
#import <Parse/Parse.h>

@implementation BackendFunctions

+ (void)signupUserWithName:(NSString *)username WithPassword:(NSString *)password AndEmail:(NSString *)email onCompletion:(CompletionWithErrorBlock)onCompletion
{
    if ([PFUser user]) [PFUser logOut];
    PFUser *user = [PFUser new];
    user.username = username;
    user.password = password;
    user.email = email;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"It Works!");
        }
        else
        {
            NSLog(@"It Broke %@",error.localizedDescription);
        }
        
        onCompletion(succeeded,error);
    }];
}

+ (void)loginUserWithUsername:(NSString *)username AndPassword:(NSString *)password onCompletion:(CompletionWithErrorBlock)onCompletion
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"It Works!");
        }
        else
        {
            NSLog(@"It Broke %@",error.localizedDescription);
        }
        onCompletion(user,error);
    }];
}

+ (void)logOut
{
    [PFUser logOut];
}

+ (BOOL)userIsLoggedIn
{
    PFUser *currentUser = [PFUser currentUser];
    return (currentUser) ? YES : NO;
}

@end
