//
//  QueryTableViewCell.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "QueryTableViewCell.h"
#import "Query.h"

@interface QueryTableViewCell ()

@property (nonatomic, strong) UILabel *queryLabel;
@property (nonatomic, strong) UILabel *askerLabel;
@property (nonatomic, strong) UILabel *answerCounter;

@end

static UIFont *askerAndQueryLabelFont;
static UIColor *askerAndQueryLabelColor;

static UIFont *answerCounterFont;
static UIColor *answerCounterColor;


static NSParagraphStyle *paragraphStyle;



@implementation QueryTableViewCell

+(void)load{
    
    askerAndQueryLabelFont = [UIFont fontWithName:@"Helvetica-Neue" size:14];
    askerAndQueryLabelColor =[UIColor whiteColor];
    
    answerCounterFont = [UIFont fontWithName:@"Georgia" size:11];
    answerCounterColor = [UIColor whiteColor];
    
    
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        mutableParagraphStyle.headIndent = 20.0;
        mutableParagraphStyle.firstLineHeadIndent = 20.0;
        mutableParagraphStyle.tailIndent = -20.0;
        mutableParagraphStyle.paragraphSpacingBefore = 5;
    
        paragraphStyle = mutableParagraphStyle;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.queryLabel = [[UILabel alloc] init];
        self.queryLabel.numberOfLines = 0;
        self.askerLabel = [[UILabel alloc] init];
        self.askerLabel.numberOfLines =0;
        self.answerCounter = [[UILabel alloc] init];
        self.answerCounter.numberOfLines =0;
        
        for (UIView *view in @[self.queryLabel, self.askerLabel, self.answerCounter]) {
            [self.contentView addSubview:view];
        }
    
        
        
    }
    return self;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    CGFloat padding = 10;
    CGFloat queryLabelHeight = 50;
    CGFloat askerLabelHeight = 15;
    CGFloat answerCounterLabelHeight = 15;
    
    self.queryLabel.frame = CGRectMake(padding, padding, CGRectGetWidth(self.contentView.bounds)-padding, queryLabelHeight);
    self.askerLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.queryLabel.frame)+padding, CGRectGetWidth(self.bounds), askerLabelHeight);
    self.answerCounter.frame = CGRectMake(padding, CGRectGetMaxY(self.askerLabel.frame)+padding, CGRectGetWidth(self.bounds), answerCounterLabelHeight);
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.bounds));
}

-(void) setQuery:(Query *)query{
    _query =query;
    
    self.queryLabel.text = _query.query;
    self.askerLabel.text =_query.user.username;
    self.answerCounter.text = @"2 answers!";
}



/*- (void)awakeFromNib { Not using this method since im not using storyboards to build cells into
    // Initialization code
}*/

/*- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}*/

@end
