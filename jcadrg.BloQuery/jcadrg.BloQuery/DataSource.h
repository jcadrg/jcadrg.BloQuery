//
//  DataSource.h
//  jcadrg.BloQuery
//
//  Created by Mac on 8/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

typedef void (^requestedQueryCompletionBlock)(NSError *error);

@property(nonatomic, strong) NSArray *queryElements;

+(instancetype) sharedInstance;

//-(void) retrieveQueryFromParse;

-(void) retrieveQueryWithCompletionHandler:(requestedQueryCompletionBlock) completionhandler;





@end