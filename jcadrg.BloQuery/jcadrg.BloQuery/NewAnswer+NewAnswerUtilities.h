//
//  NewAnswer+NewAnswerUtilities.h
//  jcadrg.BloQuery
//
//  Created by Mac on 9/2/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "NewAnswer.h"

@interface NewAnswer (NewAnswerUtilities)

-(NSAttributedString *) answerTextWithFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *) paragraphStyle;
-(NSAttributedString *) answerUserWithFont:(UIFont *) font paragraphStyle:(NSParagraphStyle *) paragraphStyle;
-(NSAttributedString *) upVoteCounterWithFont:(UIFont *) font paragraphStyle:(NSParagraphStyle *) paragraphStyle;



@end
