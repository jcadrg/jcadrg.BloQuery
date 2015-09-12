//
//  DataSource.h
//  jcadrg.BloQuery
//
//  Created by Mac on 8/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Query.h"

@class Query;
@class User;
@class NewAnswer;

@interface DataSource : NSObject

typedef void (^requestedQueryCompletionBlock)(NSError *error);
typedef void (^submittedQueryCompletionBlock)(NSError *error);

typedef void (^requestedAnswerCompletionBlock)(NSError *error);
typedef void (^submittedAnswerCompletionBlock)(NSError *error);

typedef void (^upVoteCounterChangeCompletionBlock)(NSError *error);

//typedef void (^retrieveUserProfileImageCompletionBlock)(NSError *error);

typedef void (^UploadImageForUserCompletionBlock)(NSError *error);

typedef void (^UpdateUserCompletionBlock)(NSError *error);

@property(nonatomic, strong) NSArray *queryElements;
@property (nonatomic, strong) NSString *configNewQuestion;
@property (nonatomic, strong) NSString *configNewAnswer;

+(instancetype) sharedInstance;

//-(void) retrieveQueryFromParse;

-(void) retrieveParseConfig;

//Query methods
-(void) retrieveQueryWithCompletionHandler:(requestedQueryCompletionBlock) completionhandler;
-(void) submitQuery:(NSString *) queryText withCompletionHandler:(submittedQueryCompletionBlock)completionHandler;

//Answer methods
-(void) submitAnswersForQueries:(Query *)query withText:(NSString *) queryText withCompletionHandler:(submittedQueryCompletionBlock)completionHandler;
-(void) retrieveAnswersForQueries:(Query *) query withCompletionHandler:(requestedAnswerCompletionBlock)completionHandler;

//User profile method
//-(void) retrieveUserProfile:(User *)user withCompletionHandler:(retrieveUserProfileImageCompletionBlock) completionHandler;

//Update count of upVotes
-(void) updateupVoteCounter:(NewAnswer *) answer withCompletionHandler:(upVoteCounterChangeCompletionBlock) completionHandler;

//Upvote status
-(BOOL) upvoteCurrentState:(NewAnswer *)answer;

//Upload method
-(void) uploadImage:(UIImage *)image ForUser:(User *)user WithCompletionHandler:(UploadImageForUserCompletionBlock)completionHandler;

//Update user
-(void) updateUser:(User *)user WithCompletionHandler:(UpdateUserCompletionBlock)completionHandler;







@end