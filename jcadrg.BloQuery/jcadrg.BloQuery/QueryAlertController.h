//
//  QueryAlertController.h
//  jcadrg.BloQuery
//
//  Created by Mac on 8/28/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "SDCAlertController.h"

@class QueryAlertController;

@protocol QueryAlertControllerDelegate <NSObject>

-(void) queryAlertController:(QueryAlertController *) queryAlertController didSubmitQueryText:(NSString *) queryText;

@end

@interface QueryAlertController : SDCAlertController

//@property (nonatomic, strong) UITableViewController *presentAlertToTableViewController;

@property (nonatomic, weak) NSObject <QueryAlertControllerDelegate> *delegate;



@end
