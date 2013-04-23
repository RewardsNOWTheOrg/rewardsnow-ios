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

typedef enum {
    DetailViewTable = 0,
    DetailViewIncrease = 1,
    DetailViewDecrease,
    DetailViewHistory,
    DetailViewOther
} DetailView;

@interface RNAccountStatementViewController ()

@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;
@property (nonatomic, strong) NSDate *firstDay;
@property (nonatomic, strong) NSDate *lastDay;
@property (nonatomic, strong) RNAccountStatement *statement;
@property (nonatomic) DetailView currentState;

@end

@implementation RNAccountStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstDay = [NSDate firstDayOfCurrentMonth];
    self.lastDay = [NSDate firstDayOfNextMonth];
    
    [self updateInfo];
    
    DLog(@"What: %@", self.displayedDetailView);
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

- (IBAction)swipeRecognized:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self showPointsIncrease];
    } else {
        DLog(@"Right");
    }
}

- (void)updateInfo {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    
    self.monthLabel.text = [NSString stringWithFormat:@"%@ Balance", [formatter stringFromDate:self.firstDay]];
    
    [[RNWebService sharedClient] getAccountStatementForTip:@"969000000001099" From:self.firstDay to:self.lastDay callback:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.statement = result;
        self.pointsStartLabel.text = [self.statement.pointsBeginning description];
        self.pointsEndLabel.text = [self.statement.pointsEnd description];
    }];
}


#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *RNAccountStatementCell = @"RNAccountStatementCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RNAccountStatementCell];
    
    cell.textLabel.text = @[@"Points Increased", @"Points Decreased", @"Activity Detail", @"Other"][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:C(235) green:C(235) blue:C(235) alpha:1.0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            [self showPointsIncrease];
            break;
        }
        case 1:
        {
            break;
        }
        case 2:
        {
            break;
        }
        case 3:
        {
            break;
        }
        default:
            break;
    }
}

- (void)showPointsIncrease {
    RNAccountStatementDetailView *details = [[RNAccountStatementDetailView alloc] initWithFrame:CGRectMake(10 + 320, 130, 300, (self.statement.pointsIncrease.count * 40) + 70)];
    details.titleLabel.text = @"Points Increase";

    DLog(@"Info: %@", self.statement);
    
    for (NSInteger i = 0; i < self.statement.pointsIncrease.count; i++) {
        RNPointChange *pc = self.statement.pointsIncrease[i];
        [details addLeftText:pc.statementType rightText:[pc.points description]];
    }
    
    self.scrollView.contentSize = CGSizeMake(320, details.frame.origin.y + details.frame.size.height);
    [self.innerView addSubview:details];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if ([self.displayedDetailView isKindOfClass:[UITableView class]]) {
            self.tableLeftSpace.constant = -320;
            [self.view layoutIfNeeded];
        }
        
        self.displayedDetailView.frame = CGRectMake(-320, self.displayedDetailView.frame.origin.y, self.displayedDetailView.frame.size.width, self.displayedDetailView.frame.size.height);
        details.frame = CGRectMake(details.frame.origin.x - 320, details.frame.origin.y, details.frame.size.width, details.frame.size.height);
    } completion:^(BOOL finished) {
        self.displayedDetailView = details;
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
