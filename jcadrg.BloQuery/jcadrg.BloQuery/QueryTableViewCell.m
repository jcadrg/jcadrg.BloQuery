//
//  QueryTableViewCell.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "QueryTableViewCell.h"
#import "Query+CellStyleUtilities.h"
#import "HexColors.h"

#import <QuartzCore/QuartzCore.h>  

@interface QueryTableViewCell ()

@property (nonatomic, strong) UILabel *queryLabel;
@property (nonatomic, strong) UILabel *askerLabel;
@property (nonatomic, strong) UILabel *answerCounter;

@end

static UIFont *queryFont;
static UIFont *askerFont;
static UIFont *answerCounterFont;

static UIColor *queryColor;
static UIColor *askerColor;
static UIColor *answerCounterColor;


static NSParagraphStyle *paragraphStyle;



@implementation QueryTableViewCell




+(void)load{
    
    /*askerAndQueryLabelFont = [UIFont fontWithName:@"Helvetica-Neue" size:14];
    askerAndQueryLabelColor =[UIColor whiteColor];
    
    answerCounterFont = [UIFont fontWithName:@"Georgia" size:11];
    answerCounterColor = [UIColor whiteColor];*/
    
    queryFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    queryColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
    askerFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    queryColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
    answerCounterFont = [UIFont fontWithName:@"Georgia" size:12];
    queryColor = [UIColor colorWithHexString:@"#000000"];
    
    
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        mutableParagraphStyle.headIndent = 10.0;
        mutableParagraphStyle.firstLineHeadIndent = 5.0;
        mutableParagraphStyle.tailIndent = -10.0;
        mutableParagraphStyle.paragraphSpacingBefore = 1;
    
        paragraphStyle = mutableParagraphStyle;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.queryLabel = [[UILabel alloc] init];
        self.queryLabel.numberOfLines = 5;
        self.queryLabel.textColor = queryColor;
        self.queryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.askerLabel = [[UILabel alloc] init];
        self.askerLabel.numberOfLines =1;
        self.askerLabel.textColor = askerColor;
        
        
        self.answerCounter = [[UILabel alloc] init];
        self.answerCounter.numberOfLines =1;
        self.answerCounter.textColor = answerCounterColor;
        
        for (UIView *view in @[self.queryLabel, self.askerLabel, self.answerCounter]) {
            [self.contentView addSubview:view];
        }
    
        
        
    }
    return self;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    CGFloat padding = 10;
    CGFloat queryLabelHeight = 40;
    CGFloat askerLabelHeight = 10;
    CGFloat answerCounterLabelHeight = 10;
    
    self.queryLabel.frame = CGRectMake(padding, padding, CGRectGetWidth(self.contentView.bounds)-(2 * padding), queryLabelHeight);
    self.askerLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.queryLabel.frame)+padding, CGRectGetWidth(self.bounds)-(2 * padding), askerLabelHeight);
    self.answerCounter.frame = CGRectMake(padding, CGRectGetMaxY(self.askerLabel.frame)+padding, CGRectGetWidth(self.bounds)-(2 * padding), answerCounterLabelHeight);
    
}

-(void) setQuery:(Query *)query{
    _query =query;
    
    self.queryLabel.attributedText = [self.query queryStringFont:queryFont paragraphStyle:paragraphStyle ];
    self.askerLabel.attributedText = [self.query askerStringFont:askerFont paragraphStyle:paragraphStyle];
    self.answerCounter.attributedText = [self.query answerCounterFont:answerCounterFont paragraphStyle:paragraphStyle];
}



/*- (void)awakeFromNib { Not using this method since im not using storyboards to build cells into
    // Initialization code
}*/

/*- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}*/

@end
