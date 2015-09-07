//
//  NewAnswer.h
//  jcadrg.BloQuery
//
//  Created by Mac on 8/28/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Query.h"

@class User;
@class Query;

@interface NewAnswer : PFObject <PFSubclassing>

@property (nonatomic, strong) User *username;
@property (nonatomic, strong) Query *query;
@property (nonatomic, strong) NSString *textAnswer;
@property (nonatomic, strong) NSMutableArray *userupVoteList;
@property (nonatomic, assign) NSUInteger *upVoteCounter;




//@property (nonatomic, assign) NSInteger *upVote;
    
@end
