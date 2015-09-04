//
//  AnswerTableViewCell.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/31/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import "HexColors.h"
#import <QuartzCore/QuartzCore.h>
#import "NewAnswer+NewAnswerUtilities.h"

@interface AnswerTableViewCell()

@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UILabel *answerUserLabel;

@property (nonatomic, strong) UITapGestureRecognizer *userAnswerTapGestureRecognizer;

@end

static UIFont *answerFont;
static UIFont *answerUserFont;

static UIColor *answerColor;
static UIColor *answerUserColor;

static NSParagraphStyle *paragraphStyle;

@implementation AnswerTableViewCell

+(void) load{
    
    answerFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    answerColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
    answerUserFont = [UIFont fontWithName:@"Georgia" size:12];
    answerUserColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
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
        
        self.answerLabel = [[UILabel alloc] init];
        self.answerLabel.numberOfLines = 2;
        self.answerLabel.textColor = answerColor;
        self.answerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.answerUserLabel = [[UILabel alloc] init];
        self.answerUserLabel.numberOfLines =1;
        self.answerUserLabel.textColor = answerUserColor;
        
        self.userAnswerTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(answerUserTapFired:)];
        self.userAnswerTapGestureRecognizer.delegate = self;
        [self.answerUserLabel addGestureRecognizer:self.userAnswerTapGestureRecognizer];
        self.answerUserLabel.userInteractionEnabled = YES;
        
        for (UIView *view in @[self.answerLabel, self.answerUserLabel]) {
            [self.contentView addSubview:view];
        }
    }
    return self;
}

-(void) setAnswer:(NewAnswer *)answer{
    _answer = answer;
    
    self.answerLabel.attributedText = [self.answer answerTextWithFont:answerFont paragraphStyle:paragraphStyle];
    self.answerUserLabel.attributedText = [self.answer answerUserWithFont:answerUserFont paragraphStyle:paragraphStyle];
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    CGFloat padding = 10;
    CGFloat answerHeight = 40;
    CGFloat answerUserHeight = 10;
    
    self.answerLabel.frame = CGRectMake(padding, padding, CGRectGetWidth(self.contentView.bounds)-(2 * padding), answerHeight);
    
    self.answerUserLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.answerLabel.frame)+padding, CGRectGetWidth(self.bounds)-(2 * padding), answerUserHeight);
    
}

-(void) answerUserTapFired:(UIGestureRecognizer *) sender{
    [self.delegate didTapUserAnswerLabel:self];
    NSLog(@"cell tapped!");
}




-(void) setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}





@end
