//
//  RNAccountStatementViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAccountStatementViewController.h"
#import "RNConstants.h"
#import "NSDate+Reporting.h"
#import "RNWebService.h"
#import "MBProgressHUD.h"
#import "RNAccountStatement.h"
#import "RNTransaction.h"
#import "RNPointChange.h"
#import "RNAccountStatementDetailView.h"
#import "RNBranding.h"
#import "RNResponse.h"

#define kNumberOfMonthsVisible 4

typedef enum {
    DetailViewTable = 0,
    DetailViewIncrease = 1,
    DetailViewDecrease,
    DetailViewHistory,
    DetailViewOther
} DetailView;

static NSString *RNAccountStatementCell = @"RNAccountStatementCell";

@interface RNAccountStatementViewController ()

@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;
@property (nonatomic, strong) NSDate *firstDay;
@property (nonatomic, strong) NSDate *lastDay;
@property (nonatomic, strong) RNAccountStatement *statement;
@property (nonatomic) DetailView currentState;
@property (nonatomic, strong) NSDate *finalLastDay;
@property (nonatomic, strong) NSDate *finalFirstDay;

@end

#define kTableY 80

@implementation RNAccountStatementViewController

- (void)brand {
    [super brand];
    
    self.pointsAreaView.backgroundColor = self.branding.commonBackgroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstDay = [NSDate firstDayOfCurrentMonth];
    self.lastDay = [NSDate firstDayOfNextMonth];
    self.finalLastDay = _lastDay;
    
    self.finalFirstDay = _firstDay;
    for (NSInteger i = 0; i < kNumberOfMonthsVisible; i++) {
        self.finalFirstDay = [_finalFirstDay firstDayOfPreviousMonth];
    }
    
    self.currentState = DetailViewTable;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTableY, 320, 44*4) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RNAccountStatementCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.innerView addSubview:self.tableView];
    self.displayedDetailView = self.tableView;
    
    [self updateInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UIActions

- (IBAction)backMonth:(id)sender {
    
    self.lastDay = self.firstDay;
    self.firstDay = [self.firstDay firstDayOfPreviousMonth];
    
    [self updateInfo];
}

- (IBAction)forwardMonth:(id)sender {
    self.firstDay = self.lastDay;
    self.lastDay = [self.lastDay firstDayOfNextMonth];
    
    [self updateInfo];
}

- (void)updateControls {
    ///
    /// If the last day is the same as what we set in the beginning, then we can't go any further into the future
    ///
    self.forwardMonthButton.enabled = ![self.lastDay isEqualToDate:self.finalLastDay];
    self.backMonthButton.enabled = ![self.firstDay isEqualToDate:self.finalFirstDay];
}

- (IBAction)swipeRecognized:(UISwipeGestureRecognizer *)sender {
    
    DLog(@"Direction: %d", sender.direction);
    NSInteger change = sender.direction == UISwipeGestureRecognizerDirectionLeft ? 1 : -1;
    
    DLog(@"State: %d", _currentState);
    
    if (_currentState == 0 && change == -1) {
        _currentState = 4;
    } else if (_currentState == 4 && change == 1) {
        _currentState = 0;
    } else {
        _currentState += change;
    }
    
    switch (self.currentState) {
        case DetailViewTable:
        {
            [self showTable:sender.direction];
            break;
        }
        case DetailViewIncrease:
        {
            [self showPointsIncrease:sender.direction];
            break;
        }
        case DetailViewDecrease:
        {
            [self showPointsDecrease:sender.direction];
            break;
        }
        case DetailViewHistory:
        {
            [self showActivityDetail:sender.direction];
            break;
        }
        case DetailViewOther:
        {
            [self showOther:sender.direction];
            break;
        }
        default:
            DLog(@"Unexpected Value: %d", _currentState);
            break;
    }
}

- (void)updateInfo {
    [self updateControls];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    
    self.monthLabel.text = [NSString stringWithFormat:@"%@ Balance", [formatter stringFromDate:self.firstDay]];
    
    [[RNWebService sharedClient] getAccountStatementFrom:self.firstDay to:self.lastDay callback:^(RNResponse *response) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([response wasSuccessful]) {
            self.statement = response.result;
            self.pointsStartLabel.text = [self.statement.pointsBeginning description] == nil ? @"0" : [self.statement.pointsBeginning description];
            self.pointsEndLabel.text = [self.statement.pointsEnd description] == nil ? @"0" : [self.statement.pointsEnd description];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:response.errorString delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        }
    }];
}


#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RNAccountStatementCell];
    
    cell.textLabel.text = @[@"Points Increased", @"Points Decreased", @"Activity Detail", @"Other"][indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = self.branding.backgroundColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            [self showPointsIncrease:UISwipeGestureRecognizerDirectionLeft];
            break;
        }
        case 1:
        {
            [self showPointsDecrease:UISwipeGestureRecognizerDirectionLeft];
            break;
        }
        case 2:
        {
            [self showActivityDetail:UISwipeGestureRecognizerDirectionLeft];
            break;
        }
        case 3:
        {
            [self showOther:UISwipeGestureRecognizerDirectionLeft];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Swiping Methods

- (void)showTable:(UISwipeGestureRecognizerDirection)direction {
    
    UITableView *aTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 121, 320, 44*4) style:UITableViewStylePlain];
    [aTable registerClass:[UITableViewCell class] forCellReuseIdentifier:RNAccountStatementCell];
    aTable.delegate = self;
    aTable.dataSource = self;
    aTable.scrollEnabled = NO;
    
    [self scrollDetailView:direction toView:aTable];
}

- (void)showPointsIncrease:(UISwipeGestureRecognizerDirection)direction {
    
    RNAccountStatementDetailView *details = [[RNAccountStatementDetailView alloc] initWithFrame:CGRectMake(10, kTableY, 300, (self.statement.pointsIncrease.count * 40) + 70)];
    details.titleLabel.text = @"Points Increase";

    DLog(@"Info: %@", self.statement);
    
    for (NSInteger i = 0; i < self.statement.pointsIncrease.count; i++) {
        RNPointChange *pc = self.statement.pointsIncrease[i];
        [details addLeftText:pc.statementType rightText:[pc.points description]];
    }
    
    [self scrollDetailView:direction toView:details];
}

- (void)showPointsDecrease:(UISwipeGestureRecognizerDirection)direction {
    
    RNAccountStatementDetailView *details = [[RNAccountStatementDetailView alloc] initWithFrame:CGRectMake(10, kTableY, 300, (self.statement.pointsDecrease.count * 40) + 70)];
    details.titleLabel.text = @"Points Decrease";
    
    for (NSInteger i = 0; i < self.statement.pointsDecrease.count; i++) {
        RNPointChange *pc = self.statement.pointsDecrease[i];
        [details addLeftText:pc.statementType rightText:[pc.points description]];
    }
    
    [self scrollDetailView:direction toView:details];
    
}

- (void)showActivityDetail:(UISwipeGestureRecognizerDirection)direction {
    RNAccountStatementDetailView *details = [[RNAccountStatementDetailView alloc] initWithFrame:CGRectMake(10, kTableY, 300, (self.statement.history.count * 40) + 70)];
    details.titleLabel.text = @"Activity Detail";
    
    for (NSInteger i = 0; i < self.statement.history.count; i++) {
        RNTransaction *transaction = self.statement.history[i];
        [details addLeftText:transaction.transactionDescription rightText:[transaction.points description]];
    }
    
    [self scrollDetailView:direction toView:details];
}

- (void)showOther:(UISwipeGestureRecognizerDirection)direction {
    
    RNAccountStatementDetailView *details = [[RNAccountStatementDetailView alloc] initWithFrame:CGRectMake(10, kTableY, 300, 300)];
    details.titleLabel.text = @"Other";

    [self scrollDetailView:direction toView:details];
}

- (void)scrollDetailView:(UISwipeGestureRecognizerDirection)direction toView:(UIView *)aView {
    
    aView.backgroundColor = self.branding.backgroundColor;
    
    CGFloat modifier = direction == UISwipeGestureRecognizerDirectionLeft ? 320 : -320;
    
    aView.frame = CGRectMake(aView.frame.origin.x + modifier, aView.frame.origin.y, aView.frame.size.width, aView.frame.size.height);
    [self.innerView addSubview:aView];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.displayedDetailView.frame = CGRectMake(-(modifier), self.displayedDetailView.frame.origin.y, self.displayedDetailView.frame.size.width, self.displayedDetailView.frame.size.height);
        aView.frame = CGRectMake(aView.frame.origin.x - (modifier), aView.frame.origin.y, aView.frame.size.width, aView.frame.size.height);
        
    } completion:^(BOOL finished) {
        self.displayedDetailView = aView;
        self.scrollView.contentSize = CGSizeMake(320, self.displayedDetailView.frame.origin.y + self.displayedDetailView.frame.size.height);
    }];
}

#pragma mark - Helper Method

- (NSInteger)nextMonth {
    _currentMonth++;
    if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
    }
    return _currentMonth;
}

- (NSInteger)previousMonth {
    _currentMonth--;
    if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
    }
    return _currentMonth;
}


@end
