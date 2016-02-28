//
//  BackendFunctions.h
//  
//
//  Created by Irwin Gonzales on 2/2/16.
//
//

#import <Foundation/Foundation.h>
#import "UIAlertController+Window.h"

@interface BackendFunctions : NSObject

/////////////////////////////
// block definitions
/////////////////////////////
typedef void (^SuccessCompletionBlock)(BOOL success);
typedef void (^CompletionWithErrorBlock)(BOOL success, NSError *error);
typedef void (^CompletionWithDictionaryBlock)(NSDictionary *dictionary, NSError *error);
typedef void (^CompletionWithArrayBlock)(NSArray *array, NSError *error);
typedef void (^ArrayReturnBlock)(NSArray *array, NSError *error);

#pragma
#pragma mark - Basic User Functions
+ (void)signupUserWithName:(NSString *)username
              WithPassword:(NSString *)password
                  AndEmail:(NSString *)email
              onCompletion:(CompletionWithErrorBlock)onCompletion;

+ (void)loginUserWithUsername:(NSString *)username
                  AndPassword:(NSString *)password
                 onCompletion:(CompletionWithErrorBlock)onCompletion;

+ (void)logOut;

+ (BOOL)userIsLoggedIn;

#pragma
#pragma mark - Spot Query

+ (void)queryAllSpots:(ArrayReturnBlock)onCompletion;

+ (void)searchSpotQueryWithSpotName:(NSString *)spotName
                            inArray:(ArrayReturnBlock)returnArray;

#pragma
#pragma mark - Basic Chat Query/Save

+ (void)chatQueryWithSpotId:(NSString *)spotId
                    inArray:(ArrayReturnBlock)returnArray;

+ (void)saveChatMessageWithText:(NSString *)message
                       withUser:(NSDictionary *)user
                      andSpotId: (NSDictionary *)spot;

#pragma 
#pragma mark - Basic News Query/Save

+ (void)newsQueryWithSpotId:(NSString *)spotId
                    inArray:(ArrayReturnBlock)returnArray;

+ (void)saveNewsMessageWithText:(NSString *)message
                       withUser:(NSDictionary *)user
                      andSpotId:(NSDictionary *)spot;

+ (UIAlertController *)alertControllerForError:(NSError *)error;

@end
