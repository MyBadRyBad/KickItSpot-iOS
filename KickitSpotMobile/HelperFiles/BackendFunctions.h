//
//  BackendFunctions.h
//  
//
//  Created by Irwin Gonzales on 2/2/16.
//
//

#import <Foundation/Foundation.h>


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
#pragma mark - Basic Spot Query

+ (void)arrayQuery:(ArrayReturnBlock)returnArray;

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

@end
