//
//  KickItSpotMainTableViewCell.m
//  KickitSpot
//
//  Created by Ryan Badilla on 2/28/16.
//  Copyright © 2016 Newdesto. All rights reserved.
//

#import "KickItSpotMainTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation KickItSpotMainTableViewCell


#pragma mark -
#pragma mark - initializers
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupTableViewCell];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupTableViewCell];
    }
    
    return self;
}

#pragma mark -
#pragma mark - setup

- (void)setupTableViewCell
{
    [self.contentView addSubview:[self kickItSpotSubview]];
    
    [self setupConstraints];
    
}

- (void)setupConstraints
{
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_kickItSpotSubview);
    NSDictionary *metrics = @{@"hBuffer" : @(12)};
    
    // setup vertical constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_kickItSpotSubview]-|" options:0 metrics:metrics views:viewsDictionary]];
    
    // setup horizontal constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hBuffer-[_kickItSpotSubview]-hBuffer-|" options:0 metrics:metrics views:viewsDictionary]];
}

#pragma mark -
#pragma mark - getter method
- (KickItSpotMainBox *)kickItSpotSubview
{
    if (!_kickItSpotSubview)
    {
        _kickItSpotSubview = [[KickItSpotMainBox alloc] init];
        _kickItSpotSubview.translatesAutoresizingMaskIntoConstraints = NO;
        
        _kickItSpotSubview.layer.cornerRadius = 10.0f;
        _kickItSpotSubview.layer.masksToBounds = YES;
    }
    
    return _kickItSpotSubview;
}


@end
