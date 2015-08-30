//
//  NewAnswer.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/28/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "NewAnswer.h"
#import <Parse/PFObject+Subclass.h>

@implementation NewAnswer

@dynamic username;
@dynamic query;
@dynamic textAnswer;
//@dynamic likeCount;

+(void) load{
    [self registerSubclass];
}

+(NSString *) parseClassName{
    return @"NewAnswer";
}

@end
