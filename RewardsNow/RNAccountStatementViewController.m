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

static NSString *RNAccountStatementCell = @"RNAccountStatementCell";

@interface RNAccountStatementViewController ()

@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;
@property (nonatomic, strong) NSDate *firstDay;
@property (nonatomic, strong) NSDate *lastDay;
@property (nonatomic, strong) RNAccountStatement *statement;
@property (nonatomic, strong) NSDate *finalLastDay;
@property (nonatomic, strong) NSDate *finalFirstDay;

@property (nonatomic, copy) NSArray *internalStatement;

@end

#define kTableY 80
#define kTableHeaderHeight 30
#define kSectionTitles @[@"Points Increased", @"Points Decreased", @"Activity Detail"]

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
    
    [self updateInfo];
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
            
            self.internalStatement = @[_statement.pointsIncrease, _statement.pointsDecrease, _statement.history];
            
            self.pointsStartLabel.text = [self.statement.pointsBeginning description] == nil ? @"0" : [self.statement.pointsBeginning description];
            self.pointsEndLabel.text = [self.statement.pointsEnd description] == nil ? @"0" : [self.statement.pointsEnd description];
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:response.errorString delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        }
    }];
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _internalStatement.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [_internalStatement[section] count];
    if (rows == 0) {
        rows = 1;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RNAccountStatementCell];
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:17];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    NSString *titleText;
    NSString *detailText;
    
    if ([_internalStatement[indexPath.section] count] > 0) {
        if (indexPath.section == 2) {
            RNTransaction *trans = _internalStatement[indexPath.section][indexPath.row];
            titleText = trans.transactionDescription;
            detailText = [trans formattedStringFromNumber:trans.points];
        } else {
            RNPointChange *pointChange = _internalStatement[indexPath.section][indexPath.row];
            titleText = pointChange.statementType;
            detailText = [pointChange formattedStringFromNumber:pointChange.points];
        }
    } else {
        titleText = @"None";
    }
    
    cell.textLabel.text = titleText;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerSection = [[UIView alloc] init];
    
    CMLabel *title = [[CMLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTableHeaderHeight)];
    title.backgroundColor = self.branding.pointsColor;
    title.text = kSectionTitles[section];
    [headerSection addSubview:title];
    
    return headerSection;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.backgroundColor = self.branding.pointsColor;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableHeaderHeight;
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
