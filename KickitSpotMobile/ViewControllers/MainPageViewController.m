//
//  FrontPageViewController.m
//  KickitSpotMobile
//
//  Created by Ryan Badilla on 2/7/16.
//  Copyright © 2016 Newdesto. All rights reserved.
//

#import "MainPageViewController.h"
#import "kColorConstants.h"
#import "kConstants.h"
#import <UIScrollView+InfiniteScroll.h>

@interface MainPageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *spotDataArray;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - setup
- (void)setupData
{
    if (_dataSource == DataSourceLocalTest)
    {
        _spotDataArray = [NSMutableArray new];
    }
}


- (void)setupViewController
{
    [self.view addSubview:[self tableView]];
    
    [self setupNavigationBar];
    [self setupConstraints];
}

- (void)setupNavigationBar
{
    
}

- (void)setupConstraints
{
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView);
    NSDictionary *metrics = nil;
    
    // add vertical constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:metrics views:viewsDictionary]];
    
    // add horizontal constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:metrics views:viewsDictionary]];
}

#pragma mark -
#pragma mark - tableView delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return -1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return -1;
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_spotDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellID = [NSString stringWithFormat:@"cellID-%ld", (long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return -1;
}


#pragma mark -
#pragma mark - getter methods
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.tableFooterView = nil;
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
        [_tableView setBackgroundView:nil];
        _tableView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0];
        
        
        // change indicator view style to white
        _tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhite;
        
        // setup infinite scroll
        [_tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
            //
            // fetch your data here, can be async operation,
            // just make sure to call finishInfiniteScroll in the end
            //
            
            // make sure you reload tableView before calling -finishInfiniteScroll
            [tableView reloadData];
            
            // finish infinite scroll animation
            [tableView finishInfiniteScroll];
        }];
        
    }
    
    return _tableView;
}

@end
