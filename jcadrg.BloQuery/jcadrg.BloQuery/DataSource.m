//
//  DataSource.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//
#import <Parse/Parse.h> //Did not import parse

#import "DataSource.h"
#import "User.h"
#import "Query.h"
#import "NewAnswer.h"


@implementation DataSource

+(instancetype) sharedInstance{
    
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype) init{
    self = [super init];
    
    /*if (self) {
        if ([User currentUser]) {
            [self saveQueryToParse];
        }
        
    }
    
    [self retrieveQueryFromParse];*/
    
    
    
    return self;
}

/*-(void) saveQueryToParse{
    
    if ([User currentUser]) {
        Query *test = [Query object];
        test.user = [User currentUser]; //I used object instead of currentUser
        test.answers = @[];
        test.query = @"Can anyone see this question?";
        [test saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Query creation was a success!");
            } else {
                NSLog(@"Query creation failed!");
            }
        }];
        
        Query *test2 = [Query object];
        test2.user = [User currentUser];
        test2.answers = @[];
        test2.query = @"See this question too?";
        [test2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Query creation was a success!");
            } else {
                NSLog(@"Query creation failed!");
            }
        }];
        
    }
}*/

/*-(void) retrieveQueryFromParse{
    
    NSMutableArray *queryArray = [NSMutableArray array];
    
    PFQuery *query =[PFQuery queryWithClassName:@"Query"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error){
            
            NSLog(@"Retrieved %lu queries", (unsigned long)objects.count);
            
            for (PFObject *object in objects){
                
                [queryArray addObject:object];
                
            }
        }else{
            NSLog(@"Error retrieving queries : %@", error);
        }
        
        [DataSource sharedInstance].queryElements =queryArray;
    }];
    
    
    
}*/

#pragma mark - query methods
 
-(void) retrieveQueryWithCompletionHandler:(requestedQueryCompletionBlock) completionhandler{
    
    
    NSMutableArray *queryArray = [NSMutableArray array];
    
    PFQuery *query =[PFQuery queryWithClassName:@"Query"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error){
            
            NSLog(@"Retrieved %lu queries", (unsigned long)objects.count);
            
            for (PFObject *object in objects){
                
                [queryArray insertObject:object atIndex:0];
                
            }
            
            
            
            [DataSource sharedInstance].queryElements = queryArray;
            
            if (completionhandler) {
                completionhandler(nil);
            }
            
        
        }else{
            NSLog(@"Error retrieving queries : %@", error);
        }
        
        /*[DataSource sharedInstance].queryElements =queryArray;
        
        if (completionhandler) {
            completionhandler(nil);
        }*/
    }];
    
}

-(void) submitQuery:(NSString *)queryText withCompletionHandler:(submittedAnswerCompletionBlock)completionHandler{
    
    if ([User currentUser]) {
        Query *newQuestion = [Query object];
        newQuestion.user = [User currentUser];
        newQuestion.answers = @[];
        newQuestion.query = queryText;
        [newQuestion saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                if (completionHandler) {
                    completionHandler(nil);
                }
                
            }else{
                NSLog(@"Queery creation failed");
            }
            
            
        }];
        
    }
}

#pragma mark - answer methods

-(void) submitAnswersForQueries:(Query *)query withText:(NSString *)queryText withCompletionHandler:(submittedQueryCompletionBlock)completionHandler{
    
    if ([User currentUser]) {
        NewAnswer *newAnswer = [NewAnswer object];
        
        newAnswer.username = [User currentUser];
        newAnswer.query = query;
        newAnswer.textAnswer =  queryText;
        
        [newAnswer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                if (completionHandler) {
                    completionHandler(nil);
                }
                
            }else{
                NSLog(@"Answer creation failed");
            }
            
            
        }];
        
    }
    
}

-(void) retrieveAnswersForQueries:(Query *)query withCompletionHandler:(requestedAnswerCompletionBlock)completionHandler{
    
    NSMutableArray *answersArray = [NSMutableArray array];
    
    PFQuery *answer =[PFQuery queryWithClassName:@"NewAnswer"];
    [answer whereKey:@"Query" equalTo:query];
    [answer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error){
            
            NSLog(@"Retrieved %lu answers", (unsigned long)objects.count);
            
            for (PFObject *object in objects){
                
                [answersArray addObject:object];
                
            }

            
            if (completionHandler) {
                completionHandler(nil);
            }
            
            
        }else{
            NSLog(@"Error retrieving queries : %@", error);
        }
        
        /*[DataSource sharedInstance].queryElements =queryArray;
         
         if (completionhandler) {
         completionhandler(nil);
         }*/
    }];
    
}






#pragma mark - Config method

//Method copied from the Parse iOS tutorial

-(void) retrieveParseConfig{
    
    NSLog(@"Getting the latest config...");
    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {
        if (!error) {
            NSLog(@"Yay! Config was fetched from the server.");
        } else {
            NSLog(@"Failed to fetch. Using Cached Config.");
            config = [PFConfig currentConfig];
        }
        
        self.configNewQuestion = config[@"New Question"];
        if (!self.configNewQuestion) {
            self.configNewQuestion = @"Ask your question!";
        }
        
        self.configNewQuestion = config[@"New Answer"];
        if (!self.configNewQuestion) {
            self.configNewQuestion = @"Answer the question!";
        }


    }];
}

@end


