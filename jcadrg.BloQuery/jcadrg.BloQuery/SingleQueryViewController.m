//
//  SingleQueryViewController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 9/9/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "SingleQueryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HexColors.h"
#import "DataSource.h"
#import "Query+CellStyleUtilities.h"
#import "NewAnswer.h"
#import "AnswerTableViewCell.h"
#import "NewAnswerAlertController.h"
#import "UserProfileViewController.h"

@interface SingleQueryViewController () <NewAnswerAlertController, UITableViewDataSource, UITableViewDelegate, AnswerTableViewCellDelegate>

@property (nonatomic, strong) UILabel *queryLabel;
@property (nonatomic, strong) UILabel *askerLabel;
@property (nonatomic, strong) UILabel *answerCounter;
@property (nonatomic, strong) NSString *askerUsername;

@property (nonatomic, strong) UITableView *answersTableView;

@property (nonatomic, strong) Query *singleQuery;

@property (nonatomic, strong) UITapGestureRecognizer *queryUserTapGestureRecognizer;

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
    
    /*NSString *userString = [NSString stringWithFormat:@"%@ asked", self.askerUsername];
     
     [self setTitle:NSLocalizedString(userString, nil)];*/
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comments"] style:UIBarButtonItemStylePlain target:self action:@selector(newAnswerButtonPressed)];
    self.answersTableView.separatorColor = [UIColor colorWithHexString:@"#000000"];
    [self.answersTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"answerCell"];
}

-(id) initWithQuery:(Query *)singleQuery{
    
    self = [super init];
    
    if (self) {
        
        [self retrieveAnswers:singleQuery];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
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
        
        self.answersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        self.answersTableView.delegate = self;
        self.answersTableView.dataSource =self;
        
        [self setSingleQuery:singleQuery];
        
        /*for (UIView *view in @[self.queryLabel, self.askerLabel, self.answerCounter, self.answersTableView]) {
         [self.view addSubview:view];
         }*/
    }
    
    
    
    return self;
}

-(void) retrieveAnswers:(Query *) query{
    [[DataSource sharedInstance] retrieveAnswersForQueries:query withCompletionHandler:^(NSError *error){
        [self addSubviewsToView];
    }];
}


-(void) addSubviewsToView{
    
    for (UIView *view in @[self.queryLabel, self.askerLabel, self.answerCounter, self.answersTableView]) {
        [self.view addSubview:view];
    }
    
    [self.answersTableView registerClass:[AnswerTableViewCell class] forCellReuseIdentifier:@"answerCell"];
    
}




-(void) setSingleQuery:(Query *)singleQuery{
    
    _singleQuery = singleQuery;
    
    self.queryLabel.attributedText = [self.singleQuery queryStringFont:queryFont paragraphStyle:paragraphStyle];
    self.askerLabel.attributedText = [self.singleQuery askerStringFont:askerFont paragraphStyle:paragraphStyle];
    self.answerCounter.attributedText = [self.singleQuery answerCounterFont:answerCounterFont paragraphStyle:paragraphStyle];
    
    self.askerUsername = _singleQuery.user.username; //trying to get the username of the user that asked and stored it into a property
    
    self.queryUserTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(queryUserTapFired:)];
    [self.askerLabel addGestureRecognizer:self.queryUserTapGestureRecognizer];
    self.askerLabel.userInteractionEnabled = YES;
    
    NSString *userString = [NSString stringWithFormat:@"%@ asked", self.askerUsername];
    [self setTitle:NSLocalizedString(userString, nil)];
    
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
    
    self.answersTableView.frame = CGRectMake(padding, CGRectGetMaxY(self.answerCounter.frame)+ padding, CGRectGetWidth(self.view.bounds)-(2*padding), CGRectGetHeight(self.view.bounds)- CGRectGetMaxY(self.answerCounter.frame)-(2*padding));
    
    if ([self.answersTableView respondsToSelector:@selector(layoutMargins)]) {
        self.answersTableView.layoutMargins = UIEdgeInsetsZero;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - new answer button pressed

-(void) newAnswerButtonPressed{
    
    NewAnswerAlertController *newAnswer = [NewAnswerAlertController alertControllerWithTitle:NSLocalizedString(@"Answer the question!", @"Answer the question!") message:NSLocalizedString(@"Type your answer!", @"Type your answer!") preferredStyle:SDCAlertControllerStyleAlert];
    
    newAnswer.query = self.singleQuery;
    
    newAnswer.delegate = self;
    
    [newAnswer presentWithCompletion:nil];
}

#pragma mark - answer alert controller delegate

-(void) newAnswerAlertController:(NewAnswerAlertController *)answerController didSubmitAnswer:(NSString *)answer{
    
    [[DataSource sharedInstance] submitAnswersForQueries:self.singleQuery withText:answer withCompletionHandler:^(NSError *error){
        NSLog(@"answer saved");
        [[DataSource sharedInstance] retrieveAnswersForQueries:self.singleQuery withCompletionHandler:^(NSError *error){
            [self.answersTableView reloadData];
            _singleQuery = self.singleQuery;
            [self setSingleQuery:_singleQuery];
        }];
        
    }];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.singleQuery.answersList.count;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AnswerTableViewCell *answerCell = [tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
    
    if (answerCell) {
        answerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([answerCell respondsToSelector:@selector(layoutMargins)]) {
            answerCell.layoutMargins = UIEdgeInsetsZero;
        }
        answerCell.delegate = self;
        NewAnswer *answer = self.singleQuery.answersList[indexPath.row];
        answerCell.answer = answer;
        answerCell.state = [[DataSource sharedInstance] upvoteCurrentState:answer];
        
        
    }
    
    return answerCell;
}


-(void) didTapUserAnswerLabel:(AnswerTableViewCell *)answerCell{
    
    NSLog(@"Got here!");
    
    ////[self.navigationController performSegueWithIdentifier:@"showProfile" sender:self];
    UserProfileViewController *profileVC = [[UserProfileViewController alloc] initWithUser:answerCell.answer.username];
    [self.navigationController pushViewController:profileVC animated:YES];
    
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


#pragma mark - Tap fired method

-(void)queryUserTapFired:(UITapGestureRecognizer *) sender{
    UserProfileViewController *profileVC = [[UserProfileViewController alloc] initWithUser:self.singleQuery.user];
    [self.navigationController pushViewController:profileVC animated:YES];
}

-(void) didTapupVoteButton:(AnswerTableViewCell *)answerCell{
    [[DataSource sharedInstance] updateupVoteCounter:answerCell.answer withCompletionHandler:^(NSError *error){
        //[self.answersTableView reloadData];
        answerCell.answer = answerCell.answer;
        answerCell.state = [[DataSource sharedInstance] upvoteCurrentState:answerCell.answer];
        [self reorderCell:answerCell];
    }];
}

-(void)reorderCell:(AnswerTableViewCell *) answerCell{
    
    NSUInteger previousIndex = [self.singleQuery.answersList indexOfObject:answerCell.answer];
    [self.singleQuery.answersList sortUsingComparator:^NSComparisonResult(NewAnswer *object1, NewAnswer *object2){
        return [@(object2.upVoteCounter) compare:@(object1.upVoteCounter)];
    }];
    
    NSUInteger postIndex = [self.singleQuery.answersList indexOfObject:answerCell.answer];
    [self.answersTableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:previousIndex inSection:0] toIndexPath:[NSIndexPath indexPathForRow:postIndex inSection:0]];
    
}

/*-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
 NewAnswer *answer = [self.singleQuery.answersList objectAtIndex:sourceIndexPath.row];
 [self.singleQuery.answersList removeObjectAtIndex:sourceIndexPath.row];
 [self.singleQuery.answersList insertObject:answer atIndex:destinationIndexPath.row];
 }*/


/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */





@end
