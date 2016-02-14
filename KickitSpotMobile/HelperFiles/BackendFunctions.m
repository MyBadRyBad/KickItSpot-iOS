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


#pragma
#pragma mark - Basic User Functions
+ (void)signupUserWithName:(NSString *)username
              WithPassword:(NSString *)password
                  AndEmail:(NSString *)email
              onCompletion:(CompletionWithErrorBlock)onCompletion
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

+ (void)loginUserWithUsername:(NSString *)username
                  AndPassword:(NSString *)password
                 onCompletion:(CompletionWithErrorBlock)onCompletion
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

#pragma
#pragma mark - Basic Spot Query

+ (void)arrayQuery:(ArrayReturnBlock)returnArray
{
    PFQuery *spotQuery = [PFQuery queryWithClassName:@"Cypher"];
    [spotQuery selectKeys:@[@"name",@"photo",@"permalink"]];
    [spotQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"NO ERROR");
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
        returnArray(objects,error);
    }];
}

+ (void)searchSpotQueryWithSpotName:(NSString *)spotName
                            inArray:(ArrayReturnBlock)returnArray
{
    PFQuery *spotQuery = [PFQuery queryWithClassName:@"Cypher"];
    [spotQuery whereKey:@"Name" equalTo:spotName];
    [spotQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"NO ERROR");
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
        returnArray(objects,error);
    }];
}

#pragma
#pragma mark - Basic Chat Query & Save

+ (void)chatQueryWithSpotId:(NSString *)spotId
                      inArray:(ArrayReturnBlock)returnArray
{
    PFObject *chatObject = [PFObject objectWithClassName:@"ChatWidget"];
    
    PFQuery *chatWidgetQuery = [PFQuery queryWithClassName:@"ChatWidget"];
    [chatWidgetQuery whereKey:chatObject[@"objectId"] equalTo:spotId];
    [chatWidgetQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"NO ERROR");
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
        }
        returnArray(objects, error);
    }];
}

+ (void)saveChatMessageWithText:(NSString *)message
                       withUser:(NSDictionary *)user
                      andSpotId: (NSDictionary *)spot
{
 /*   user = [PFUser user];
    spot = [PFObject objectWithClassName:@"Cypher"];
    PFObject *chatMessage = [PFObject objectWithClassName:@"ChatWidget"];
    
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        
        if (!error && succeeded)
        {
            chatMessage[@"sender"] = user.objectId;
            chatMessage[@"cypher"] = spot.objectId;
            chatMessage[@"message"] = message;
        }
        else
        {
            NSLog(@"YOU SHALL NOT PASS %@",error.localizedDescription);
        }
        
    }]; */
}

#pragma
#pragma mark - Basic News Query/Save

+ (void)newsQueryWithSpotId:(NSString *)spotId
                    inArray:(ArrayReturnBlock)returnArray
{
    PFObject *newsObject = [PFObject objectWithClassName:@"NewsWidget"];
    
    PFQuery *newsWidgetQuery = [PFQuery queryWithClassName:@"NewsWidget"];
    [newsWidgetQuery whereKey:newsObject[@"cypher"] equalTo:spotId];
    [newsWidgetQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"YOU PASSED SPONGEBOB");
        }
        else
        {
            NSLog(@"YOU SHALL NOT PASS! %@", error.localizedDescription);
        }
        returnArray(objects,error);
    }];
}

+ (void)saveNewsMessageWithText:(NSString *)message
                       withUser:(NSDictionary *)user
                      andSpotId:(NSDictionary *)spot
{
 /*   user = [PFUser user];
    spot = [PFObject objectWithClassName:@"Cypher"];
    PFObject *newsMessage = [PFObject objectWithClassName:@"NewsWidget"];
    
    [newsMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (!error && succeeded)
        {
            [newsMessage setObject:user forKey:@"creator"];
            newsMessage[@"cypher"] = spot.objectId;
            newsMessage[@"content"] = message;
        }
        else
        {
            NSLog(@"YOU SHALL NOT PASS %@",error.localizedDescription);
        }
    }]; */
}


@end
