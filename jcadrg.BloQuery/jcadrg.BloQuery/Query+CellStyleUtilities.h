//
//  Query+CellStyleUtilities.h
//  jcadrg.BloQuery
//
//  Created by Mac on 8/27/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "Query.h"

@interface Query (CellStyleUtilities)

-(NSAttributedString *)queryStringFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle;
-(NSAttributedString *)askerStringFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle;
-(NSAttributedString *)answerCounterFont:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle;

@end
