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

@end
