//
//  FrontPageViewController.m
//  KickitSpotMobile
//
//  Created by Ryan Badilla on 2/7/16.
//  Copyright © 2016 Newdesto. All rights reserved.
//

#import "MainPageViewController.h"
#import "MBProgressHUD.h"
#import "BackendFunctions.h"
#import "kColorConstants.h"
#import "kDictionaryKeyConstants.h"
#import "kConstants.h"
#import "HelperFunctions.h"
#import "KickItSpotMainTableViewCell.h"
#import "UIScrollView+InfiniteScroll.h"
#import "UIAlertController+Window.h"

@interface MainPageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *spotDataArray;

@end

@implementation MainPageViewController

#pragma mark -
#pragma mark - View Controller lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupData];
}

#pragma mark -
#pragma mark - didReceiveMemoryWarning
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
        
        for (int index = 0; index < 10; index++)
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            NSString *spotName = [NSString stringWithFormat:@"Kick It Spot %d", index];
            
            [dictionary setObject:spotName forKey:kSpotNameKey];
            [_spotDataArray addObject:dictionary];
            
            [_tableView reloadData];
        }
        
    }
    else
    {
        [BackendFunctions queryAllSpots:^(NSArray *array, NSError *error) {
            if (!error)
            {
                _spotDataArray = [[NSMutableArray alloc] initWithArray:array];
                [_tableView reloadData];
            }
            else
                [[BackendFunctions alertControllerForError:error] show];
        }];
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
    
    NSString *cellID = [NSString stringWithFormat:@"cellID-%ld-%ld", (long)indexPath.row, (long)indexPath.section];
    KickItSpotMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[KickItSpotMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    
    }
    
    NSDictionary *spotData = [_spotDataArray objectAtIndex:indexPath.row];
    
    cell.kickItSpotSubview.kickItSpotNameLabel.text = spotData[kSpotNameKey];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
        [_tableView setBackgroundView:nil];
        _tableView.backgroundColor = [UIColor whiteColor];
        
        
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
