//
//  RootViewController.m
//  FantasyView
//
//  Created by 昕 王 on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "FantasyView.h"
#import <QuartzCore/QuartzCore.h>


@interface RootViewController () <FantasyViewDataSource, FantasyViewDelegate> {
    UIInterfaceOrientation _orientation;
}
@property (nonatomic, retain) FantasyView *fantasyView;
@property (nonatomic, retain) UIImageView *imagView;
@end

@implementation RootViewController
@synthesize fantasyView     = _fantasyView;
@synthesize imagView        = _imagView;

- (void)dealloc{
    self.fantasyView = nil;
    self.imagView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    [super loadView];
    FantasyView *fantasyView = [[FantasyView alloc] initWithFrame:self.view.bounds];
    fantasyView.dataSource = self;
    fantasyView.delegate = self;
    fantasyView.backgroundColor = [UIColor clearColor];
    fantasyView.pagingEnabled = YES;
    self.fantasyView = fantasyView;
    [fantasyView release];
    [self.view addSubview:self.fantasyView];
    
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self.fantasyView reloadData];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(30, 30, 100, 100);
    [btn setTitle:@"GO" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)action{
    [self.fantasyView fantasyViewScrollToIndex:12 animation:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    _orientation = toInterfaceOrientation;
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        self.fantasyView.frame = CGRectMake(0, 0, 768, 1024);
    }
    else {
        self.fantasyView.frame = CGRectMake(0, 0, 1024, 768);
    }
    [self.fantasyView reloadData];
    [self.fantasyView fantasyViewScrollToIndex:self.fantasyView.currentIndex animation:NO];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
}

- (CGFloat)fantasyView:(FantasyView *)fanView widthForIndex:(NSInteger)index{
    if (UIInterfaceOrientationIsPortrait(_orientation)) {
        return 768.f;
    }
    else {
        return 1024.f;
    }
}

- (NSInteger)numberOfIndexForFantasyView:(FantasyView *)fanView{
    return 100;
}

- (void)fantasyView:(FantasyView *)fanView setContentView:(UIView *)contentView ForIndex:(NSInteger)index{
    if ([contentView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)contentView;
        if (index % 2 == 0) {
            imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"abc" ofType:@"jpeg"]];
            
        }
        else {
            imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cba" ofType:@"jpeg"]];
            
        }
        UILabel *label = (UILabel *)[imageView viewWithTag:123];
        label.text =[NSString stringWithFormat:@"%d", index];
    }
}

- (UIView *)fantasyView:(FantasyView *)fanView targetRect:(CGRect)targetRect ForIndex:(NSInteger)index{
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:targetRect] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:imageView.bounds] autorelease];
    label.font = [UIFont systemFontOfSize:50.f];
    label.tag = 123;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [imageView addSubview:label];
    return imageView;
}

- (void)fantasyView:(FantasyView *)fanView scrollToIndex:(NSInteger)index{
    NSLog(@"%d", index);
}


@end
