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

@interface DataSource : NSObject

typedef void (^requestedQueryCompletionBlock)(NSError *error);
typedef void (^submittedQueryCompletionBlock)(NSError *error);

typedef void (^requestedAnswerCompletionBlock)(NSError *error);
typedef void (^submittedAnswerCompletionBlock)(NSError *error);

@property(nonatomic, strong) NSArray *queryElements;
@property (nonatomic, strong) NSString *configNewQuestion;

+(instancetype) sharedInstance;

//-(void) retrieveQueryFromParse;

-(void) retrieveParseConfig;

-(void) retrieveQueryWithCompletionHandler:(requestedQueryCompletionBlock) completionhandler;
-(void) submitQuery:(NSString *) queryText withCompletionHandler:(submittedAnswerCompletionBlock)completionHandler;

//Dont do this yet
-(void) retrieveAnwerForQuery: (Query *)query withCompletionHandler:(requestedAnswerCompletionBlock)completionHandler;
-(void) submitAnswerForQuery:(NSString *) answerText withCompletionHandler:(submittedAnswerCompletionBlock)completionHandler;






@end