//
//  NewAnswer+NewAnswerUtilities.m
//  jcadrg.BloQuery
//
//  Created by Mac on 9/2/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "NewAnswer+NewAnswerUtilities.h"

@implementation NewAnswer (NewAnswerUtilities)

-(NSAttributedString *) answerTextWithFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle{
    
    NSString *string = [NSString stringWithFormat:@"%@", (self.textAnswer)];
    NSMutableAttributedString *answerTextString =[[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle}];
    
    return answerTextString;
    
    
}

-(NSAttributedString *) answerUserWithFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle{
    
    NSString *string = [NSString stringWithFormat:@"%@", (self.username.username)];
    
    NSMutableAttributedString *answerUserString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle}];
    
    return answerUserString;

}
@end
