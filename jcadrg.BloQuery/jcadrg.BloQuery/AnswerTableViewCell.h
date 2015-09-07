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
@class AnswerTableViewCell;

@protocol AnswerTableViewCellDelegate <NSObject>

-(void) didTapUserAnswerLabel:(AnswerTableViewCell *)answerCell;
-(void) didTapupVoteButton:(AnswerTableViewCell *)answerCell;


@end

@interface AnswerTableViewCell : UITableViewCell

@property (nonatomic, weak) id<AnswerTableViewCellDelegate> delegate;
@property (nonatomic, strong) NewAnswer *answer;

@property (nonatomic, assign) BOOL state;

@end
