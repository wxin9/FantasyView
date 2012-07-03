//
//  FantasyView.h
//  FantasyView
//
//  Created by 昕 王 on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol FantasyViewDataSource;
@protocol FantasyViewDelegate;

@interface FantasyView : UIView

@property (nonatomic, retain) UITableView                       *tableView;
@property (nonatomic, assign) id<FantasyViewDataSource>         dataSource;
@property (nonatomic, assign) id<FantasyViewDelegate>           delegate;
@property (nonatomic, assign) NSInteger                         currentIndex;
@property (nonatomic, assign) BOOL                              pagingEnabled;

- (void)reloadData;
- (void)fantasyViewScrollToIndex:(NSInteger)index animation:(BOOL)animation;
- (UIView *)getViewInFantasyViewWithIndex:(NSInteger)index;

@end

@protocol FantasyViewDelegate <NSObject>

@optional
- (void)fantasyView:(FantasyView *)fanView selectIndex:(NSInteger)index;
- (void)fantasyView:(FantasyView *)fanView scrollToIndex:(NSInteger)index;

@end

@protocol FantasyViewDataSource <NSObject>

@required
- (CGFloat)fantasyView:(FantasyView *)fanView widthForIndex:(NSInteger)index;
- (NSInteger)numberOfIndexForFantasyView:(FantasyView *)fanView;
- (void)fantasyView:(FantasyView *)fanView setContentView:(UIView *)contentView ForIndex:(NSInteger)index;
- (UIView *)fantasyView:(FantasyView *)fanView targetRect:(CGRect)targetRect ForIndex:(NSInteger)index;

@end