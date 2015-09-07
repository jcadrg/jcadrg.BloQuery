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
@property (nonatomic, strong) UILabel *upVoteCountLabel;
@property (nonatomic, strong) UIButton *upVoteButton;

@property (nonatomic, strong) UITapGestureRecognizer *userAnswerTapGestureRecognizer;

@end

static UIFont *answerFont;
static UIFont *answerUserFont;
static UIFont *upVoteCountFont;

static UIColor *answerColor;
static UIColor *answerUserColor;
static UIColor *upVoteCountColor;

static NSParagraphStyle *paragraphStyle;

@implementation AnswerTableViewCell

+(void) load{
    
    answerFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    answerColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
    answerUserFont = [UIFont fontWithName:@"Georgia" size:12];
    answerUserColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
    upVoteCountFont = [UIFont fontWithName:@"Georgia" size:10];
    upVoteCountColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
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
        
        self.upVoteCountLabel = [[UILabel alloc] init];
        self.upVoteCountLabel.numberOfLines = 1;
        self.upVoteCountLabel.textColor = upVoteCountColor;
        
        self.upVoteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[self.upVoteButton setTitle:@"upVote" forState:UIControlStateNormal];
        [self.upVoteButton addTarget:self action:@selector(upVotePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.userAnswerTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(answerUserTapFired:)];
        self.userAnswerTapGestureRecognizer.delegate = self;
        [self.answerUserLabel addGestureRecognizer:self.userAnswerTapGestureRecognizer];
        self.answerUserLabel.userInteractionEnabled = YES;
        
        for (UIView *view in @[self.answerLabel, self.answerUserLabel, self.upVoteCountLabel, self.upVoteButton]) {
            [self.contentView addSubview:view];
        }
    }
    return self;
}

-(void) upVotePressed:(UIButton *) sender{
    NSLog(@"Up Vote button pressed!");
    [self.delegate didTapupVoteButton:self];
    
}

-(void) setAnswer:(NewAnswer *)answer{
    _answer = answer;
    
    self.answerLabel.attributedText = [self.answer answerTextWithFont:answerFont paragraphStyle:paragraphStyle];
    self.answerUserLabel.attributedText = [self.answer answerUserWithFont:answerUserFont paragraphStyle:paragraphStyle];
    self.upVoteCountLabel.attributedText = [self.answer upVoteCounterWithFont:upVoteCountFont paragraphStyle:paragraphStyle];
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    CGFloat padding = 10;
    CGFloat answerHeight = 40;
    CGFloat answerUserHeight = 10;
    CGFloat answerCountHeight =10;
    
    self.answerLabel.frame = CGRectMake(padding, padding, CGRectGetWidth(self.contentView.bounds)-(2 * padding), answerHeight);
    
    self.answerUserLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.answerLabel.frame)+padding, CGRectGetWidth(self.bounds)-(2 * padding), answerUserHeight);
    self.upVoteCountLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.answerUserLabel.frame) + padding, CGRectGetWidth(self.bounds)/2 - padding, answerCountHeight);
    self.upVoteButton.frame = CGRectMake(CGRectGetMaxX(self.upVoteCountLabel.frame), CGRectGetMaxY(self.answerUserLabel.frame)+padding,CGRectGetWidth(self.bounds)/2 - padding, answerCountHeight);
    
}

-(void) answerUserTapFired:(UIGestureRecognizer *) sender{
    [self.delegate didTapUserAnswerLabel:self];
    NSLog(@"cell tapped!");
}




-(void) setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

-(void) setState:(BOOL)state{
    _state = state;
    if (_state == YES) {
        [self.upVoteButton setTitle:@"UpVoted" forState:UIControlStateNormal];
    }else{
        [self.upVoteButton setTitle:@"UpVote" forState:UIControlStateNormal];
    }
}





@end
