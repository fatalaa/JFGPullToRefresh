//
//  JFGViewController.m
//  JFGPullToRefresh
//
//  Created by Tibor Molnár on 07/17/2015.
//  Copyright (c) 2015 Tibor Molnár. All rights reserved.
//

#import "JFGViewController.h"
#import <JFGPullToRefresh/UIScrollView+JFGPullToRefreshViewExtension.h>
#import <JFGPullToRefreshOptions.h>

@interface JFGViewController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation JFGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary *options = [[NSMutableDictionary alloc] initWithDictionary:[JFGPullToRefreshOptions defaultOptions]];
    options[@"autoStopTime"] = @1.5;
    options[@"imageName"] = @"arrow";
	// Do any additional setup after loading the view, typically from a nib.
    [self.tableView addPullToRefreshWithOptions:[[JFGPullToRefreshOptions alloc] initWithOptions:options] withDelegate:self];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellId";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.textLabel.text = self.data[(NSUInteger) indexPath.row];
    return cell;
}

- (void)pullToRefreshViewDidStartRefreshing
{
    NSLog(@"PullToRefreshView started");
}

-(void)pullToRefreshViewDidFinishRefreshing
{
    NSLog(@"PullToRefreshView ended");
}

#pragma mark - Properties

- (NSArray *)data
{
    if (!_data) {
        _data = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    }
    return _data;
}

@end
