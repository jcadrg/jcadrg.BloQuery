//
//  NewAnswerAlertController.h
//  jcadrg.BloQuery
//
//  Created by Mac on 8/30/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "SDCAlertController.h"
#import "Query.h"//Importing this, because an answer must be related to a question.

@class NewAnswerAlertController;

@protocol NewAnswerAlertController <NSObject>

-(void) newAnswerAlertController:(NewAnswerAlertController *) answerController didSubmitAnswer:(NSString *)answer;

@end

@interface NewAnswerAlertController : SDCAlertController

@property (nonatomic, strong) Query *query;
@property (nonatomic, weak) NSObject <NewAnswerAlertController> *delegate;


@end
