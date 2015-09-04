//
//  QueryTableViewCell.h
//  jcadrg.BloQuery
//
//  Created by Mac on 8/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Query.h"

@class Query;
@class QueryTableViewCell;




@protocol QueryTableViewCellDelegate <NSObject>

-(void) didTapQueryLabel:(QueryTableViewCell *) queryCell;
-(void) didTapAnswerUserLabel:(QueryTableViewCell *) queryCell;

@end

@interface QueryTableViewCell : UITableViewCell

@property (nonatomic, weak) id <QueryTableViewCellDelegate> delegate;
@property (nonatomic, strong) Query *query;

@end
