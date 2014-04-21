//
//  ViewController.m
//  xh_VanNess_Location
//
//  Created by Xiaohe Hu on 4/19/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"
#import "neighborhoodViewController.h"
@interface ViewController ()

@property   UIView                          *uiv_btnContainer;
@property   UIButton                        *uib_backBtn;
@property   UIButton                        *uib_loadBtn;
@property   neighborhoodViewController      *locationVC;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControlBtns];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)initControlBtns
{
    _uiv_btnContainer = [[UIView alloc] initWithFrame:CGRectMake(412.0, 728.0, 200.0, 40.0)];
    _uiv_btnContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview: _uiv_btnContainer];
    
    _uib_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_backBtn.frame = CGRectMake(0.0, 0.0, 90.0, 40.0);
    _uib_backBtn.backgroundColor = [UIColor blackColor];
    [_uib_backBtn setTitle:@"BACK" forState:UIControlStateNormal];
    [_uib_backBtn addTarget:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
    
    _uib_loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_loadBtn.frame = CGRectMake(110.0, 0.0, 90.0, 40.0);
    _uib_loadBtn.backgroundColor = [UIColor redColor];
    [_uib_loadBtn setTitle:@"LOAD" forState:UIControlStateNormal];
    [_uib_loadBtn addTarget:self action:@selector(loadMapView) forControlEvents:UIControlEventTouchUpInside];
    
    [_uiv_btnContainer addSubview: _uib_loadBtn];
    [_uiv_btnContainer addSubview: _uib_backBtn];
}

-(void)backToRoot {
    NSLog(@"Back to the root");
    [_locationVC removeFromParentViewController];
    [_locationVC.view removeFromSuperview];
    _uib_loadBtn.userInteractionEnabled = YES;
}

-(void)loadMapView {
    NSLog(@"Load the map view");
    _locationVC = [[neighborhoodViewController alloc] initWithNibName:@"neighborhoodViewController" bundle:nil];
    [self addChildViewController:_locationVC];
    [self.view insertSubview:_locationVC.view belowSubview:_uiv_btnContainer];
    _uib_loadBtn.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
