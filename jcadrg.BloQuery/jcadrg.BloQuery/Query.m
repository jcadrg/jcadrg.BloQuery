//
//  Query.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "Query.h"
#import <Parse/PFObject+Subclass.h>

@implementation Query

@dynamic user;
@dynamic query;
@dynamic answerCount;
@dynamic answersList;

//These 2 methods are the same as the tutorial in parse documentation

+(void) load{
    [Query registerSubclass];
}

+(NSString *) parseClassName{
    return @"Query";
}

@end
