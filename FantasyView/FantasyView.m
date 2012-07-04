//
//  FantasyView.m
//  FantasyView
//
//  Created by 昕 王 on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FantasyView.h"
#import <QuartzCore/QuartzCore.h>

#define kTableView_Tag                  2199
#define kTableView_ContentView_Tag      1231

@interface FantasyView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    CGSize                      _size;
}

- (void)createTableView;

@end

@implementation FantasyView
@synthesize tableView           = _tableView;
@synthesize dataSource          = _dataSource;
@synthesize delegate            = _delegate;
@synthesize currentIndex        = _currentIndex;
@synthesize pagingEnabled       = _pagingEnabled;

- (void)dealloc{
    self.dataSource = nil;
    self.tableView = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _size = frame.size;
        self.currentIndex = -1;
        [self createTableView];
    }
    return self;
}

#pragma mark - Private Method
- (void)createTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
    tableView.tag = kTableView_Tag;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    self.tableView.frame = CGRectMake(0, 0, _size.width, _size.height);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:tableView];
    [tableView release];

}

#pragma mark - Public Method

- (void)reloadData{
    _size = self.frame.size;
    self.tableView.frame = CGRectMake(0, 0, _size.width, _size.height);

    [self.tableView reloadData];
}

- (void)setPagingEnabled:(BOOL)pagingEnabled{
    if (_pagingEnabled != pagingEnabled) {
        _pagingEnabled = pagingEnabled;
        self.tableView.pagingEnabled = _pagingEnabled;
    }
}

- (UIView *)getViewInFantasyViewWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
    UIView *contentView = [cell viewWithTag:kTableView_ContentView_Tag];
    
    if (contentView) {
        return contentView;
    }
    return nil;
}

- (UITableView *)tableView{
    return (UITableView *)[self viewWithTag:kTableView_Tag];
}

- (void)fantasyViewScrollToIndex:(NSInteger)index animation:(BOOL)animation{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:animation];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource respondsToSelector:@selector(fantasyView:widthForIndex:)]) {
        return [self.dataSource fantasyView:self widthForIndex:indexPath.row];
    }
    else {
        return 0.f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(numberOfIndexForFantasyView:)]) {
        return [self.dataSource numberOfIndexForFantasyView:self];
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"fantasyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.frame = CGRectMake(0, 0, [self.dataSource fantasyView:self widthForIndex:indexPath.row], _size.height);
        cell.contentView.frame = cell.bounds;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *contentView = [self.dataSource fantasyView:self targetRect:cell.contentView.frame ForIndex:indexPath.row];
        if (!contentView) {
            contentView = [[[UIView alloc] initWithFrame:cell.contentView.bounds] autorelease];

        }
        contentView.transform = CGAffineTransformMakeRotation(M_PI/2);
        contentView.frame = CGRectMake(0, 0, cell.contentView.frame.size.height, cell.contentView.frame.size.width);
        contentView.tag = kTableView_ContentView_Tag;
        [cell.contentView addSubview:contentView];
    
    }
    
    cell.frame = CGRectMake(0, 0, [self.dataSource fantasyView:self widthForIndex:indexPath.row], _size.height);
    cell.contentView.frame = cell.bounds;
    UIView *contentView = [cell.contentView viewWithTag:kTableView_ContentView_Tag];
    contentView.frame = CGRectMake(0, 0, cell.contentView.frame.size.height, cell.contentView.frame.size.width);
    [self.dataSource fantasyView:self setContentView:contentView ForIndex:indexPath.row];
    return cell;

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(fantasyView:selectIndex:)]) {
        [self.delegate fantasyView:self selectIndex:indexPath.row];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.pagingEnabled) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int currentPage = floor((scrollView.contentOffset.y - pageWidth/2)/pageWidth)+1;
        if (self.currentIndex != currentPage) {
            if ([self.delegate respondsToSelector:@selector(fantasyView:scrollToIndex:)]) {
                [self.delegate fantasyView:self scrollToIndex:currentPage];
            }
            self.currentIndex = currentPage;
        }
    }
}



@end
