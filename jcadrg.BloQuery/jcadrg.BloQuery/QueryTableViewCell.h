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

@protocol QueryTableViewCellDelegate <NSObject>

//No methods for now

@end

@interface QueryTableViewCell : UITableViewCell

@property (nonatomic, weak) id <QueryTableViewCellDelegate> delegate;
@property (nonatomic, strong) Query *query;

@end
