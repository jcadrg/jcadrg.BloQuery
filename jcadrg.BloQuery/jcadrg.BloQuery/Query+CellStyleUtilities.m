//
//  Query+CellStyleUtilities.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/27/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "Query+CellStyleUtilities.h"

@implementation Query (CellStyleUtilities)

-(NSAttributedString *) queryStringFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle{
    
    NSString *string = [NSString stringWithFormat:@"%@", (self.query)];
    NSMutableAttributedString *queryString =[[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
    
    return queryString;
}

-(NSAttributedString *) askerStringFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle{
    NSString *string = [NSString stringWithFormat:@"%@", (self.user.username)];
    NSMutableAttributedString *askerString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
    
    return askerString;
}

-(NSAttributedString *) answerCounterFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle{
    //NSString *string = [NSString stringWithFormat:@"2 answers"];
    NSString *string = [NSString stringWithFormat:@"%lu answers", (unsigned long)(self.answersList.count)];
    NSMutableAttributedString *answerCountString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
    
    return answerCountString;
}

@end
