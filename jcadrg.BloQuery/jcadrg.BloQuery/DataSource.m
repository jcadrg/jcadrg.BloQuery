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
 
-(void) retrieveQueryWithCompletionHandler:(requestedQueryCompletionBlock) completionhandler{
    
    
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
        
        if (completionhandler) {
            completionhandler(nil);
        }
    }];
    
    
    
    
}

@end


