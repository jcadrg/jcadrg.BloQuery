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
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import <QuartzCore/QuartzCore.h>  

@interface QueryTableViewCell ()

@property (nonatomic, strong) UILabel *queryLabel;
@property (nonatomic, strong) UILabel *askerLabel;
@property (nonatomic, strong) UILabel *answerCounter;

@property (nonatomic, strong) PFImageView *userProfileImageView;

@property (nonatomic, strong) UITapGestureRecognizer *queryTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *userTapGestureRecognizer;

@property (nonatomic, strong) NSLayoutConstraint *imageWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *imageHeightConstraint;

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
    
    
    queryFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:15];
    queryColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
    askerFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    askerColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
    answerCounterFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    answerCounterColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
    
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        mutableParagraphStyle.headIndent = 0;
        mutableParagraphStyle.firstLineHeadIndent = 0;
        mutableParagraphStyle.tailIndent = 0;
        mutableParagraphStyle.paragraphSpacingBefore = 0;
    
        paragraphStyle = mutableParagraphStyle;
}

+(CGFloat) heightForQuery:(Query *)query width:(CGFloat)width{
    QueryTableViewCell *layout = [[QueryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layout"];
    layout.query = query;
    
    layout.frame = CGRectMake(0, 0,width,  CGRectGetHeight(layout.frame));
    
    [layout setNeedsLayout];
    [layout layoutIfNeeded];
    
    return CGRectGetMaxY(layout.answerCounter.frame) + 20;
}

-(CGSize) getLabelHeight:(UILabel *) label{
    
    CGFloat maxLabelWidth = 100;
    CGSize neededSize = [label sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    
    return neededSize;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.queryLabel = [[UILabel alloc] init];
        self.queryLabel.numberOfLines = 0;
        self.queryLabel.textColor = queryColor;

        self.queryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        self.userProfileImageView = [[PFImageView alloc] init];
        if (self.userProfileImageView == nil) {
            self.userProfileImageView.image = [UIImage imageNamed:@"11.png"];
        }
        
        self.askerLabel = [[UILabel alloc] init];
        self.askerLabel.numberOfLines =1;
        self.askerLabel.textColor = askerColor;
        
        
        self.answerCounter = [[UILabel alloc] init];
        self.answerCounter.numberOfLines =1;
        self.answerCounter.textColor = answerCounterColor;
        
        self.queryTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(queryTapFired:)];
        self.queryTapGestureRecognizer.delegate = self;
        [self.queryLabel addGestureRecognizer:self.queryTapGestureRecognizer];
        self.queryLabel.userInteractionEnabled = YES;
        
        self.userTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapFired:)];
        self.userTapGestureRecognizer.delegate = self;
        [self.askerLabel addGestureRecognizer:self.userTapGestureRecognizer];
        self.askerLabel.userInteractionEnabled = YES;
        
        for (UIView *view in @[self.queryLabel, self.askerLabel, self.answerCounter, self.userProfileImageView]) {
            [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
    
        [self createConstraints];
        
    }
    return self;
}





-(void) createConstraints{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_userProfileImageView,_askerLabel,_queryLabel,_answerCounter);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_userProfileImageView]-8-[_askerLabel]"
                                                                             options:NSLayoutFormatAlignAllTop
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_userProfileImageView]-8-[_queryLabel]"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_userProfileImageView]-8-[_answerCounter]"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_userProfileImageView]"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_askerLabel][_queryLabel][_answerCounter]"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    self.imageWidthConstraint = [NSLayoutConstraint constraintWithItem:_userProfileImageView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.contentView
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:0.15
                                                              constant:0];
    
    self.imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_userProfileImageView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_userProfileImageView
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1
                                                               constant:0];
    
    [self.contentView addConstraints:@[self.imageWidthConstraint, self.imageHeightConstraint]];
}

-(void) setQuery:(Query *)query{
    _query =query;
    
    self.userProfileImageView.file = (PFFile *)self.query.user.profileImage;
    [self.userProfileImageView loadInBackground];
    
    self.queryLabel.attributedText = [self.query queryStringFont:queryFont paragraphStyle:paragraphStyle ];
    self.askerLabel.attributedText = [self.query askerStringFont:askerFont paragraphStyle:paragraphStyle];
    self.answerCounter.attributedText = [self.query answerCounterFont:answerCounterFont paragraphStyle:paragraphStyle];
}

#pragma mark - Gesture tap methods

-(void) queryTapFired:(UITapGestureRecognizer *) sender{
    [self.delegate didTapQueryLabel:self];
}

-(void) userTapFired:(UITapGestureRecognizer *) sender{
    [self.delegate didTapAnswerUserLabel:self];
}



/*- (void)awakeFromNib { Not using this method since im not using storyboards to build cells into
    // Initialization code
}*/

/*- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}*/

@end
