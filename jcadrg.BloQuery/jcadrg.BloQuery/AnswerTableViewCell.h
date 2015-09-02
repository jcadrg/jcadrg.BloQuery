//
//  AnswerTableViewCell.h
//  jcadrg.BloQuery
//
//  Created by Mac on 8/31/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewAnswer.h"

@class NewAnswer;

@interface AnswerTableViewCell : UITableViewCell

@property (nonatomic, strong) NewAnswer *answer;

@end
