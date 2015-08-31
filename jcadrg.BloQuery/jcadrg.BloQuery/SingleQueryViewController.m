//
//  SingleQueryViewController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/26/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "SingleQueryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HexColors.h"
#import "Query+CellStyleUtilities.h"
#import "DataSource.h"
#import "NewAnswerAlertController.h"
#import "User.h"


@interface SingleQueryViewController ()<NewAnswerAlertController>

@property (nonatomic, strong) UILabel *queryLabel;
@property (nonatomic, strong) UILabel *askerLabel;
@property (nonatomic, strong) UILabel *answerCounter;
@property (nonatomic, strong) NSString *askerUsername;


@end

@implementation SingleQueryViewController

static UIFont *queryFont;
static UIFont *askerFont;
static UIFont *answerCounterFont;

static UIColor *queryColor;
static UIColor *askerColor;
static UIColor *answerCounterColor;

static NSParagraphStyle *paragraphStyle;

/*- (void)viewDidLoad {
    [super viewDidLoad];
    // There's no need of using reuse identifiers since i only want one cell here.
    
    if (self) {
        
        self.queryLabel = [[UILabel alloc] init];
        self.queryLabel.numberOfLines = 0;
        self.askerLabel = [[UILabel alloc] init];
        self.askerLabel.numberOfLines =0;
        self.answerCounter = [[UILabel alloc] init];
        self.answerCounter.numberOfLines =0;
        
        self.queryLabel.text = self.singleQuery.query;
        self.askerLabel.text =self.singleQuery.user.username;
        self.answerCounter.text = @"2 answers!";
        
        
        
        for (UIView *view in @[self.queryLabel, self.askerLabel, self.answerCounter]) {
            [self.view addSubview:view];
        }
        
        
    }

    
}*/

+(void) load{
    
    queryFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    queryColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
    askerFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    queryColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    
    answerCounterFont = [UIFont fontWithName:@"Georgia" size:12];
    queryColor = [UIColor colorWithHexString:@"#000000"];
    
    
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 10.0;
    mutableParagraphStyle.firstLineHeadIndent = 10.0;
    mutableParagraphStyle.tailIndent = -10.0;
    mutableParagraphStyle.paragraphSpacingBefore = 1;
    
    paragraphStyle = mutableParagraphStyle;

    
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    NSString *userString = [NSString stringWithFormat:@"%@ asked", self.askerUsername];
    
    [self setTitle:NSLocalizedString(userString, nil)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Answer", nil) style:UIBarButtonItemStylePlain target:self action:@selector(newAnswerButtonPressed)];
}

-(id) init{
    
    self = [super init];
    
    if (self) {
        
        self.queryLabel = [[UILabel alloc] init];
        self.queryLabel.numberOfLines =2;
        self.queryLabel.textColor = queryColor;
        self.queryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.askerLabel = [[UILabel alloc] init];
        self.askerLabel.numberOfLines =1;
        self.askerLabel.textColor = askerColor;
        
        self.answerCounter=[[UILabel alloc] init];
        self.answerCounter.numberOfLines =1;
        self.answerCounter.textColor =answerCounterColor;
        
        for (UIView *view in @[self.queryLabel, self.askerLabel, self.answerCounter]) {
            [self.view addSubview:view];
        }
    }
    
    
    
    return self;
}


-(void) setSingleQuery:(Query *)singleQuery{
    
    _singleQuery = singleQuery;
    
    self.queryLabel.attributedText = [self.singleQuery queryStringFont:queryFont paragraphStyle:paragraphStyle];
    self.askerLabel.attributedText = [self.singleQuery askerStringFont:askerFont paragraphStyle:paragraphStyle];
    self.answerCounter.attributedText = [self.singleQuery answerCounterFont:answerCounterFont paragraphStyle:paragraphStyle];
    
    self.askerUsername = _singleQuery.user.username; //trying to get the username of the user that asked and stored it into a property
    
}
    
    


-(void) viewWillLayoutSubviews{
    
    CGFloat padding = 10;
    CGFloat queryLabelHeight = 50;
    CGFloat askerLabelHeight = 15;
    CGFloat answerCounterLabelHeight = 15;
    CGFloat navigation = 80;
    
    self.queryLabel.frame = CGRectMake(padding, navigation, CGRectGetWidth(self.view.bounds), queryLabelHeight);
    self.askerLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.queryLabel.frame)+padding, CGRectGetWidth(self.view.bounds), askerLabelHeight);
    self.answerCounter.frame = CGRectMake(padding, CGRectGetMaxY(self.askerLabel.frame)+padding, CGRectGetWidth(self.view.bounds), answerCounterLabelHeight);
    
    self.queryLabel.backgroundColor = [UIColor whiteColor];
    self.askerLabel.backgroundColor = [UIColor whiteColor];
    self.answerCounter.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - new answer button pressed

-(void) newAnswerButtonPressed{
    
    NewAnswerAlertController *newAnswer = [NewAnswerAlertController alertControllerWithTitle:NSLocalizedString(@"Answer the question!", nil) message:NSLocalizedString(@"Type your answer!", nil) preferredStyle:SDCAlertControllerStyleAlert];
    
    newAnswer.query = self.singleQuery;
    
    newAnswer.delegate = self;
    
    [newAnswer presentWithCompletion:nil];
}

#pragma mark - answer alert controller delegate

-(void) newAnswerAlertController:(NewAnswerAlertController *)answerController didSubmitAnswer:(NSString *)answer{
    [[DataSource sharedInstance] submitAnswersForQueries:self.singleQuery withText:answer withCompletionHandler:^(NSError *error){
        [[DataSource sharedInstance] retrieveAnswersForQueries:self.singleQuery withCompletionHandler:^(NSError *error){
            
        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




    
    
    


@end
