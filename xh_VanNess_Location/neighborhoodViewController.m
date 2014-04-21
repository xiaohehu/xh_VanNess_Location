//
//  neighborhoodViewController.m
//  neo1325Boylston
//
//  Created by Xiaohe Hu on 1/13/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "neighborhoodViewController.h"
#import "MapViewAnnotation.h"
#import <MapKit/MapKit.h>
//#import "ebZoomingScrollView.h"
#import "embOverlayScrollView.h"
#import "xhHelpView.h"
#import "embSimpleScrollView.h"
#import "xhanchorPointHotspots.h"
#import "embDrawBezierPath.h"
#import "embBezierPaths.h"
#import "embDirections.h"
#import "embDirectionsHigh.h"
#import "neoHotspotsView.h"

#define METERS_PER_MILE 1609.344

static int numOfCells = 4;
static float container_W = 198.0;  // origial 186
static float kClosedMenu_W = 40.0;
@interface neighborhoodViewController () <embSimpleScrollViewDelegate, embDrawBezierPathDelegate, embOverlayScrollViewDelegate>

@property (nonatomic, strong) contentTableViewController    *contentTableView;
@property (nonatomic, strong) CollapseClickCell             *theCell;

@property (nonatomic, strong) UIImageView                   *uiiv_bgImg;

@property (nonatomic, strong) UIView                        *uiv_collapseContainer;
@property (nonatomic, strong) UIView                        *uiv_closedMenuContainer;
@property (nonatomic, strong) UIView                        *uiv_publicTImg;

@property (nonatomic, strong) UIView                        *uiv_nameLabelContainer;

@property (nonatomic, strong) UIButton                      *uib_city;
@property (nonatomic, strong) UIButton                      *uib_neighborhood;
@property (nonatomic, strong) UIButton                      *uib_closeBtn;
@property (nonatomic, strong) UIButton                      *uib_openBtn;
@property (nonatomic, strong) UIButton                      *uib_greenSpace;
@property (nonatomic, strong) UIButton                      *uib_armyCorp;
@property (nonatomic, strong) UIButton                      *uib_yawKey;
@property (nonatomic, strong) UIButton                      *uib_access;

@property (nonatomic, strong) UILabel                       *uil_cellName;

@property (nonatomic, strong) UIView                        *uiv_leftBar;

@property (nonatomic, strong) NSMutableArray                *arr_cellName;
@property (nonatomic, strong) NSMutableArray                *arr_contentView;

@property (nonatomic, strong) UIView                        *uiv_atIndex0;
@property (nonatomic, strong) UIView                        *uiv_atIndex1;
@property (nonatomic, strong) UIView                        *uiv_atIndex2;
@property (nonatomic, strong) UIView                        *uiv_atIndex3;
@property (nonatomic, strong) UIView                        *uiv_directionContent;

@property (nonatomic, strong) UIButton                      *uib_originalMap;
@property (nonatomic, strong) UIButton                      *uib_appleMap;
@property (nonatomic, strong) UIButton                      *uib_googleMap;
@property (nonatomic, strong) UIButton                      *uib_appleMapToggle;
@property (nonatomic, strong) UIView                        *uiv_mapToggles;

@property (nonatomic, strong) MKMapView                     *mapView;
@property (nonatomic, strong) UIView                        *uiv_mapContainer;

@property (nonatomic, strong) UIView                        *uiv_closeMenuSideBar;
@property (nonatomic, strong) UIView                        *uiv_directionDot;
@property (nonatomic, strong) embOverlayScrollView           *uis_zoomingMap;

@property (nonatomic, strong) NSMutableArray                *arr_helpViews;
@property (nonatomic, strong) xhHelpView                    *helpView1;

@property (nonatomic, strong) UIImageView                   *uiiv_overlays;
@property (strong, nonatomic) embSimpleScrollView			*uis_hotspotImages;

@property (nonatomic, strong) xhanchorPointHotspots         *hotspots;
@property (nonatomic, strong) xhanchorPointHotspots         *vanness_Hotspot;
@property (nonatomic, strong) xhanchorPointHotspots         *vanness_Parking_Hotspot;
@property (nonatomic, strong) NSMutableArray                *arr_hotspotsData;
@property (nonatomic, strong) NSMutableArray                *arr_hotsopts;
@property (nonatomic, strong) NSDictionary                  *dict_hotspots;

@property (nonatomic, strong) embDrawBezierPath				*embDirectionPath;

@property (nonatomic, strong) NSMutableArray                *dirpathsArray;
@property (nonatomic, strong) NSMutableArray				*arr_pathItems;

@property (nonatomic, strong) neoHotspotsView               *tappableHotspots;
@property (nonatomic, strong) NSDictionary                  *dict_hotspotDict;
@property (nonatomic, strong) NSMutableArray                *arr_tapHotspotArray;
@property (nonatomic, strong) NSMutableArray                *arr_tapHotspots;
@end

@implementation neighborhoodViewController
-(UIColor *) chosenBtnColor{
    return [UIColor colorWithRed:60.0/255.0 green:56.0/255.0 blue:52.0/255.0 alpha:1.0];
}
-(UIColor *) normalCellColor{
    return [UIColor colorWithRed:59.0/255.0 green:55.0/255.0 blue:50.0/255.0 alpha:0.9];
}
-(UIColor *) chosenCellColor{
    return [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
}
-(UIColor *) chosenBtnTitleColor{
    return [UIColor colorWithRed:119.0/255.0 green:116.0/255.0 blue:113.0/255.0 alpha:1.0];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path0 = [[NSBundle mainBundle] pathForResource:@"buildingHotsopt" ofType:@"plist"];
    _dict_hotspotDict = [[NSDictionary alloc] initWithContentsOfFile:path0];
    _arr_tapHotspotArray = [[NSMutableArray alloc] initWithArray:[_dict_hotspotDict objectForKey:@"3D"]];
	_arr_tapHotspots = [[NSMutableArray alloc] init];
    
    _arr_helpViews = [[NSMutableArray alloc] init];
    _arr_hotspotsData = [[NSMutableArray alloc] init];
    _arr_hotsopts = [[NSMutableArray alloc] init];
    
    //Prepare hotsopts' data from plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"location_hotspots" ofType:@"plist"];
    _dict_hotspots = [[NSDictionary alloc] initWithContentsOfFile:path];
    
	// Do any additional setup after loading the view, typically from a nib.
    _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"STATIONS", @"PARKING GARAGES", @"SYSTEM", @"RETAIL", @"DINING", @"RESIDENTIAL / HOTELS", @"HOTSPOTS", @"HOTSPOTS2",nil];
    [self initVC];
//    _uiiv_bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_bg.jpg"]];
//    [self.view addSubview: _uiiv_bgImg];
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_collapseContainer.alpha = 1.0;
    }];
    [self.view addSubview:_uiv_collapseContainer];
    [self.view addSubview:_uiv_closedMenuContainer];
    [self initMapToggle];
    [self initBlockBtns];
    [self initAccessBtn];
    
    if (kshowHelpBox) {
        [self addHlepView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAndUnhideHelpViews:) name:@"hideAndUnhideHelp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHelpViews:) name:@"hideHelpView" object:nil];
    if ([@"location" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"valLocationRun"]]) {
        _helpView1.hidden = YES;
    }
    else
    {
        _helpView1.hidden = NO;
    }
}
-(void)hideHelpViews:(NSNotification *)pNotification
{
    for (xhHelpView *tmp in _arr_helpViews) {
        
        tmp.hidden = YES;
    }
}
-(void)hideAndUnhideHelpViews:(NSNotification *)pNotification
{
    for (xhHelpView *tmp in _arr_helpViews) {
        if (tmp.hidden) {
            tmp.hidden = NO;
        }
        else
        {
            tmp.hidden = YES;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setValue:@"location" forKey:@"valLocationRun"];
}
#pragma mark - Add & Remove Help View
-(void)addHlepView
{
    _helpView1 = [[xhHelpView alloc] initWithFrame:CGRectMake(0.0, 600.0, 210.0, 75.0)];
    _helpView1.isTappable = YES;
    _helpView1.dictKey = @"Location";
    _helpView1.delegate = self;
    _helpView1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:243.0/255.0 alpha:1.0];
    _helpView1.alpha = 0.9;
    [_arr_helpViews addObject: _helpView1];
    [self.view insertSubview:_helpView1 aboveSubview:_uis_zoomingMap];
}
-(void)removeAllHelpViews
{
    for (xhHelpView *tmp in _arr_helpViews) {
        tmp.hidden = YES;
    }
}
#pragma mark - Help View Delegate
-(void)removeHelpView:(xhHelpView *)customView
{
    if ([_arr_helpViews count] == 1)
    {
        for (xhHelpView *tmp in _arr_helpViews) {
            tmp.hidden = YES;
        }
    }
    else if ([_arr_helpViews count] > 1)
    {
        return;
    }
}


-(void)initVC
{
    isCity = NO;
    
    // Set Zooming Map
    _uiiv_bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"neighborhood_map.jpg"]];
	// _uis_zoomingMap = [[ebZoomingScrollView alloc] initWithFrame:self.view.bounds image:[UIImage imageNamed:@"neighborhood_map.jpg"] shouldZoom:YES];
	_uis_zoomingMap = [[embOverlayScrollView alloc] initWithFrame:self.view.bounds image:[UIImage imageNamed:@"neighborhood_map.jpg"] overlay:nil shouldZoom:YES];
	_uis_zoomingMap.imageToggle = NO;
    [self.view addSubview: _uis_zoomingMap];
    
    // Set Container's Frame
    _uiv_collapseContainer = [[UIView alloc] init];
    _uiv_collapseContainer.frame = CGRectMake(0.0f, (768-kCCHeaderHeight*(numOfCells+1))/2, container_W, kCCHeaderHeight*(numOfCells+1));
    [_uiv_collapseContainer setBackgroundColor:[UIColor clearColor]];
    //    [_uiv_collapseContainer setBackgroundColor:[UIColor colorWithRed:59.0/255.0 green:55.0/255.0 blue:50.0/255.0 alpha:0.9]];
    _uiv_collapseContainer.clipsToBounds = YES;
    
    //Set Collapse View's Frame
    theCollapseClick = [[CollapseClick alloc] initWithFrame:CGRectMake(0.0f, kCCHeaderHeight, container_W, kCCHeaderHeight*numOfCells)];
    //    [theCollapseClick setBackgroundColor:[UIColor blackColor]];
    [theCollapseClick setBackgroundColor:[UIColor clearColor]];
    
    //Set Top Section Buttons
    _uib_city = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uib_city setBackgroundColor:[self chosenBtnColor]];
    [_uib_city setTitle:@"CITY" forState:UIControlStateNormal];
    //    _uib_city.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:12.5];
    [_uib_city .titleLabel setFont:[UIFont fontWithName:@"DINPro-CondBlack" size:16]];
    [_uib_city setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_uib_city setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    CGFloat rightSpace = 12.0;
    CGFloat bottomSpace = 1.0;
    [_uib_city setContentEdgeInsets:UIEdgeInsetsMake(0, 0, bottomSpace, rightSpace)];
    [_uib_city setTitleColor:[self chosenBtnTitleColor] forState:UIControlStateNormal];
    _uib_city.frame = CGRectMake(0.0, 0.0, 55, kCCHeaderHeight);
    [_uib_city addTarget:self action:@selector(cityBtnTapped) forControlEvents:UIControlEventTouchDown];
    _uib_city.userInteractionEnabled = YES;
    
    _uib_neighborhood = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uib_neighborhood setBackgroundColor:[self normalCellColor]];
    [_uib_neighborhood setTitle:@"NEIGHBORHOOD" forState:UIControlStateNormal];
    //    _uib_neighborhood.titleLabel.font = [UIFont boldSystemFontOfSize:11.5];
    [_uib_neighborhood .titleLabel setFont:[UIFont fontWithName:@"DINPro-CondBlack" size:16]];
    _uib_neighborhood.titleLabel.textColor = [UIColor whiteColor];
    _uib_neighborhood.frame = CGRectMake(55.0, 0.0, container_W-55, kCCHeaderHeight);
    CGFloat leftSpacing = 8.0;
    [_uib_neighborhood setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_uib_neighborhood setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [_uib_neighborhood setContentEdgeInsets:UIEdgeInsetsMake(0, leftSpacing, bottomSpace, 0)];
    //    _uib_neighborhood.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    [_uib_neighborhood addTarget:self action:@selector(neighborhoodBtnTapped) forControlEvents:UIControlEventTouchDown];
    _uib_neighborhood.userInteractionEnabled = NO;
    
    //Set Close Button
    _uib_closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uib_closeBtn setBackgroundColor:[UIColor clearColor]];
    [_uib_closeBtn setBackgroundImage:[UIImage imageNamed:@"map_menu_close@2x.png"] forState:UIControlStateNormal];
    _uib_closeBtn.frame = CGRectMake(container_W-29, 0, 30, 30);
    [_uib_closeBtn addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchDown];
    
    //Set Closed Menu Container
    _uiv_closedMenuContainer = [[UIView alloc] initWithFrame:CGRectMake(-40.0, (768-38)/2, kClosedMenu_W, kClosedMenu_W)];
    _uiv_closedMenuContainer.clipsToBounds = NO;
    [_uiv_closedMenuContainer setBackgroundColor:[self normalCellColor]];
    _uib_openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uib_openBtn setBackgroundColor:[UIColor clearColor]];
    [_uib_openBtn setBackgroundImage:[UIImage imageNamed:@"open_btn.jpg"] forState:UIControlStateNormal];
    _uib_openBtn.frame = CGRectMake(0, 0, kClosedMenu_W, kClosedMenu_W);
    [_uib_openBtn addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchDown];
    
    [_uiv_closedMenuContainer insertSubview:_uiv_closeMenuSideBar aboveSubview:_uil_cellName];
    [_uiv_closedMenuContainer addSubview:_uib_openBtn];
    [self initCellNameLabel:nil];
    
    theCollapseClick.CollapseClickDelegate = self;
    [theCollapseClick reloadCollapseClick];
    
    [_uiv_collapseContainer addSubview: _uib_city];
    [_uiv_collapseContainer addSubview: _uib_neighborhood];
    [_uiv_collapseContainer addSubview:theCollapseClick];
    [_uiv_collapseContainer insertSubview:_uib_closeBtn aboveSubview:_uib_neighborhood];
    
    _uiv_collapseContainer.alpha = 0.0;
    
    _contentTableView = [[contentTableViewController alloc] init];
    
    // Init Vanness Logo Hotspot
    _vanness_Hotspot = [[xhanchorPointHotspots alloc] initWithFrame:CGRectMake(455, 349, 100, 100)];
    _vanness_Hotspot.str_hotspotImage = @"grfx_vanness.png";
    _vanness_Hotspot.anchorPosition = AnchorPositionBottomLeft;
    [_uis_zoomingMap.blurView addSubview:_vanness_Hotspot];
    
    //Init Vanness Parking Logo Hotspot
    _vanness_Parking_Hotspot = [[xhanchorPointHotspots alloc] initWithFrame:CGRectMake(455, 320, 100, 100)];
    _vanness_Parking_Hotspot.str_hotspotImage = @"grfx_parking_vanness.png";
    _vanness_Parking_Hotspot.anchorPosition = AnchorPositionBottomLeft;
    [_uis_zoomingMap.blurView addSubview:_vanness_Parking_Hotspot];
    _vanness_Parking_Hotspot.hidden = YES;
}

-(void)initBlockBtns
{
    _uib_greenSpace = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_greenSpace.frame = CGRectMake(760.0, 388.0, 58.0, 58.0);
    [_uib_greenSpace setImage:[UIImage imageNamed:@"view-icon-sq.png"] forState:UIControlStateNormal];
    [_uib_greenSpace addTarget:self action:@selector(greenSpaceTapped) forControlEvents:UIControlEventTouchDown];
    
    _uib_armyCorp = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_armyCorp.frame = CGRectMake(287.0, 370.0, 58.0, 58.0);
    //[_uib_armyCorp setTitle:@"Army Corp Of Engineers" forState:UIControlStateNormal];
    [_uib_armyCorp setImage:[UIImage imageNamed:@"view-icon-sq.png"] forState:UIControlStateNormal];
    [_uib_armyCorp addTarget:self action:@selector(armyCorpTapped) forControlEvents:UIControlEventTouchDown];
    
    _uib_yawKey = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_yawKey.frame = CGRectMake(563.0, 200.0, 58.0, 58.0);
    [_uib_yawKey setImage:[UIImage imageNamed:@"view-icon-sq.png"] forState:UIControlStateNormal];
    [_uib_yawKey addTarget:self action:@selector(fenwayTapped) forControlEvents:UIControlEventTouchDown];
    
    [_uis_zoomingMap.uiv_windowComparisonContainer addSubview: _uib_armyCorp];
    [_uis_zoomingMap.uiv_windowComparisonContainer addSubview: _uib_yawKey];
    [_uis_zoomingMap.uiv_windowComparisonContainer addSubview: _uib_greenSpace];
}

-(void)initAccessBtn
{
    _uib_access = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_access.frame = CGRectMake(872, 661, 83.0, 30.0);
    [_uib_access setImage:[UIImage imageNamed:@"grfx_ACCESSIBILITY.png"] forState:UIControlStateNormal];
    [_uib_access addTarget:self action:@selector(accessTapped) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:_uib_access];
}

-(void)initCellNameLabel:(NSString *)cellName
{
    //Init UILabel
    CGFloat padding = 0.0;
    if (cellName)
        padding = 12.0;
    
    [_uil_cellName removeFromSuperview];
    [_uiv_closeMenuSideBar removeFromSuperview];
    
    _uil_cellName = [[UILabel alloc] initWithFrame:CGRectMake(10, 48.0, 30.0, 20.0)];//_uib_openBtn.frame.size.height = 40, space = 8, 40+8=48
    _uil_cellName.layer.anchorPoint = CGPointMake(0, 1.0);
    [_uil_cellName setBackgroundColor:[UIColor clearColor]];
    _uil_cellName.autoresizesSubviews = YES;
    [_uil_cellName setText:cellName];
    _uil_cellName.font = [UIFont fontWithName:@"DINPro-CondBlack" size:16];
    [_uil_cellName setTextColor:[UIColor whiteColor]];
    [_uiv_closedMenuContainer addSubview:_uil_cellName];
    
    // Adjust the frame of label after changing the anchor point
    CGRect frame = _uil_cellName.frame;
    frame.origin.x = _uil_cellName.frame.origin.x - 15;
    frame.origin.y = _uil_cellName.frame.origin.y - (18-padding);
    
    [_uil_cellName setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    _uil_cellName.frame = frame;
    
    [_uil_cellName sizeToFit];
    //Adjust the frame of container according to the height of label
    CGRect containerFrame = _uiv_closedMenuContainer.frame;
    containerFrame.size.height = _uib_openBtn.frame.size.height + padding + _uil_cellName.frame.size.height + padding;
    containerFrame.size.width = kClosedMenu_W;
    containerFrame.origin.y = (768 - containerFrame.size.height)/2;
    containerFrame.origin.x = _uiv_closedMenuContainer.frame.origin.x;
    _uiv_closedMenuContainer.frame = containerFrame;
    
    _uiv_closeMenuSideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, containerFrame.size.height)];
    _uiv_closeMenuSideBar.backgroundColor = [UIColor redColor];
    
    [_uiv_closedMenuContainer insertSubview:_uiv_closeMenuSideBar belowSubview:_uib_openBtn];
}

-(void)initDirectionContentView
{
	_uiv_directionContent = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 124.0)];
    _uiv_directionContent.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
    _uiv_directionContent.tag = 3000;
    
    _uiv_directionDot = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 6.0, 6.0)];
    _uiv_directionDot.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
    
    UIButton *uib_direc1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_direc2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_direc3 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_direc4 = [UIButton buttonWithType:UIButtonTypeCustom];
    
	// INGRESS NORTH / SOUTH
	// EGRESS NORTH / SOUTH
	// INGRESS WEST
	// EGRESS WEST
	
    uib_direc1.frame = CGRectMake(0, 0, container_W, 30);
    uib_direc1.backgroundColor = [UIColor clearColor];
    [uib_direc1 setTitle:@"INGRESS WEST" forState:UIControlStateNormal];
    uib_direc1.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_direc1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_direc1.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_direc1.tag = 5001;
    
    uib_direc2.frame = CGRectMake(0, 31, container_W, 30);
    uib_direc2.backgroundColor = [UIColor clearColor];
    [uib_direc2 setTitle:@"EGRESS WEST" forState:UIControlStateNormal];
    uib_direc2.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_direc2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_direc2.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_direc2.tag = 5002;
    
    uib_direc3.frame = CGRectMake(0, 62, container_W, 30);
    uib_direc3.backgroundColor = [UIColor clearColor];
    [uib_direc3 setTitle:@"INGRESS NORTH / SOUTH" forState:UIControlStateNormal];
    uib_direc3.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_direc3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_direc3.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_direc3.tag = 5003;
    
    uib_direc4.frame = CGRectMake(0, 93, container_W, 30);
    uib_direc4.backgroundColor = [UIColor clearColor];
    [uib_direc4 setTitle:@"EGRESS NORTH / SOUTH" forState:UIControlStateNormal];
    uib_direc4.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_direc4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_direc4.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_direc4.tag = 5004;
    
    UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, _uiv_directionContent.frame.size.height)];
    [uiv_sideBar setBackgroundColor:[UIColor colorWithRed:205.0/255.0 green:35.0/2555.0 blue:35.0/255.0 alpha:1.0]];
    
    [_uiv_directionContent addSubview:uib_direc4];
    [_uiv_directionContent addSubview:uib_direc3];
    [_uiv_directionContent addSubview:uib_direc2];
    [_uiv_directionContent addSubview:uib_direc1];
    [_uiv_directionContent addSubview:uiv_sideBar];
    
    [uib_direc1 addTarget:self action:@selector(directionTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_direc2 addTarget:self action:@selector(directionTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_direc3 addTarget:self action:@selector(directionTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_direc4 addTarget:self action:@selector(directionTapped:) forControlEvents:UIControlEventTouchDown];
}

#pragma mark - DIRECTIONS
-(void)directionTapped:(id)sender
{
    UIButton *tmpBtn = sender;
    [_uiv_directionDot removeFromSuperview];
    [_uiiv_overlays removeFromSuperview];
	
	if (_embDirectionPath) {
		[self directionViewCleanUp];
		NSLog(@"sdssdfdsf");
		return;
	} else {
		
		if (isCity==YES) {
			[self addButtonsForDirections:@"high"];
		} else {
			[self addButtonsForDirections:@"low"];
		}
		[self drawPathsFromBezierClass:tmpBtn];
	}

	
    switch (tmpBtn.tag) {
        case 5001:
        {
            _uiv_directionDot.transform = CGAffineTransformMakeTranslation(20, 15);
            [_uiv_directionContent insertSubview:_uiv_directionDot aboveSubview:tmpBtn];
			// _uiiv_overlays = [[UIImageView alloc] initWithFrame:self.view.bounds];
			// [_uiiv_overlays setImage:[UIImage imageNamed:@"ingress_north.png"]];
			// [_uis_zoomingMap.blurView insertSubview:_uiiv_overlays belowSubview:_uib_armyCorp];
            break;
        }
        case 5002:
        {
            _uiv_directionDot.transform = CGAffineTransformMakeTranslation(20, 45);
            [_uiv_directionContent insertSubview:_uiv_directionDot aboveSubview:tmpBtn];
			// _uiiv_overlays = [[UIImageView alloc] initWithFrame:self.view.bounds];
			// [_uiiv_overlays setImage:[UIImage imageNamed:@""]];
			//  [_uis_zoomingMap.blurView insertSubview:_uiiv_overlays belowSubview:_uib_armyCorp];
            break;
        }
        case 5003:
        {
            _uiv_directionDot.transform = CGAffineTransformMakeTranslation(20, 75);
            [_uiv_directionContent insertSubview:_uiv_directionDot aboveSubview:tmpBtn];
            //_uiiv_overlays = [[UIImageView alloc] initWithFrame:self.view.bounds];
            //[_uiiv_overlays setImage:[UIImage imageNamed:@"ingress_west.png"]];
            //[_uis_zoomingMap.blurView insertSubview:_uiiv_overlays belowSubview:_uib_armyCorp];
            break;
        }
        case 5004:
        {
            _uiv_directionDot.transform = CGAffineTransformMakeTranslation(20, 105);
            [_uiv_directionContent insertSubview:_uiv_directionDot aboveSubview:tmpBtn];
            //_uiiv_overlays = [[UIImageView alloc] initWithFrame:self.view.bounds];
            //[_uiiv_overlays setImage:[UIImage imageNamed:@"egress_west.png"]];
            //[_uis_zoomingMap.blurView insertSubview:_uiiv_overlays belowSubview:_uib_armyCorp];
            break;
        }
        default:
            break;
    }
}

#pragma mark Direction

- (void)addButtonsForDirections:(NSString*)t
{
    //[super viewDidLoad];
	
	if (_dirpathsArray) {
		[_dirpathsArray removeAllObjects];
		_dirpathsArray=nil;
	} else {
		_dirpathsArray = [[NSMutableArray alloc] init];
	}
	
	// grab all bezier paths from
	// embBezierPaths class
	_arr_pathItems = [[NSMutableArray alloc] init];
	embDirectionsHigh *paths;
	embDirections *dirpaths;
	
	if ([t isEqualToString:@"high"]) {
		paths = [[embDirectionsHigh alloc] init];
		_arr_pathItems = paths.bezierPaths;
		
	} else if ([t isEqualToString:@"low"]) {
		dirpaths = [[embDirections alloc] init];
		_arr_pathItems = dirpaths.bezierPaths;
	}
	
	//[self drawPathsFromBezierClass:nil];
}

-(void)drawPathsFromBezierClass:(id)sender
{
	// clean up
	[self removePaths];
	
	// button highlighting
//	for(UIButton *button in [self.view subviews]) {
//		if([button isKindOfClass:[UIButton class]]) {
//			[button setBackgroundColor:[UIColor whiteColor]];
//			NSLog(@"all buttons now unselected");
//		}
//	}
//	
//	UIButton*t = (UIButton*)sender;
//	[self.view insertSubview:t aboveSubview:_embDirectionPath];
//	[t setBackgroundColor:[UIColor lightGrayColor]];
	
	// actual drawpath function
	_embDirectionPath = [[embDrawBezierPath alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
	_embDirectionPath.delegate=self;
	//[_uiv_mapContainer insertSubview:_embDirectionPath atIndex:2];
	
	
	[_uis_zoomingMap.uiv_windowComparisonContainer insertSubview:_embDirectionPath belowSubview:_uib_armyCorp];
	

	
	//[_uis_zoomingMap.blurView addSubview:_embDirectionPath];

	//NSLog(@"%li",(long)currentHeaderIndex);
	
	// loop # paths in a group
	int pathGrouping	= -1;
	int indexStart		= -1;
	
//	if(currentHeaderIndex == 0)
//	{
//		switch ([sender tag]) {
//			case 0:
//				pathGrouping	= 1;
//				indexStart		= 0;
//				break;
//				
//			case 1:
//				pathGrouping	= 1;
//				indexStart		= 1;
//				break;
//				
//			case 2:
//				pathGrouping	= 1;
//				indexStart		= 2;
//				break;
//				
//			case 3:
//				pathGrouping	= 1;
//				indexStart		= 3;
//				break;
//				
//			case 4:
//				pathGrouping	= 1;
//				indexStart		= 4;
//				break;
//				
//			default:
//				break;
//		}
//		
//	} else if (currentHeaderIndex == 2) {
		switch ([sender tag]) {
			case 5001:
				pathGrouping	= 2;
				indexStart		= 0;
				break;
				
			case 5002:
				pathGrouping	= 2;
				indexStart		= 2;
				break;
				
			case 5003:
				pathGrouping	= 2;
				indexStart		= 4;
				break;
				
			case 5004:
				pathGrouping	= 2;
				indexStart		= 6;
				break;
				
			default:
				break;
		}
//	}
	
	for (int i=0; i<pathGrouping; i++) {
		embBezierPathItem *p = _arr_pathItems[indexStart+i];
		_embDirectionPath.myPath = p.embPath;
		_embDirectionPath.animationSpeed = 3.0;
		_embDirectionPath.pathStrokeColor = p.pathColor;
		_embDirectionPath.pathLineWidth = p.pathWidth;
		_embDirectionPath.isTappable = NO;
		[_dirpathsArray addObject:_embDirectionPath]; // for removal later
		[_embDirectionPath startAnimationFromIndex:i afterDelay:0];
	}
}

// clear paths
-(void)removePaths
{
	NSInteger i = 0;
	for(embDrawBezierPath *pathView in _dirpathsArray) {
		if([pathView isKindOfClass:[embDrawBezierPath class]]) {
			UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction;
			[UIView animateWithDuration:.2 delay:((0.05 * i) + 0.2) options:options
							 animations:^{
								 pathView.alpha = 0.0;
							 }
							 completion:^(BOOL finished){
								[pathView embDrawBezierPathShouldRemove];
							 }];
			i += 1;
		}
	}
	[self directionViewCleanUp];
}

-(void)directionViewCleanUp
{
	[_embDirectionPath removeFromSuperview];
	_embDirectionPath=nil;
}

#pragma mark - Hotspots
-(void)initHotspots
{
    //    _hotspots = [[xhanchorPointHotspots alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    for (int i = 0; i < [_arr_hotspotsData count]; i++) {
        NSDictionary *hotspotInfo = [[NSDictionary alloc] initWithDictionary:_arr_hotspotsData[i]];
        
        NSString *str_position = [[NSString alloc] initWithString:[hotspotInfo objectForKey:@"xy"]];
        NSRange range = [str_position rangeOfString:@","];
        NSString *str_x = [str_position substringWithRange:NSMakeRange(0, range.location)];
        NSString *str_y = [str_position substringFromIndex:(range.location + 1)];
        float position_x = [str_x floatValue];
        float position_y = [str_y floatValue];
        _hotspots = [[xhanchorPointHotspots alloc] initWithFrame:CGRectMake(position_x, position_y, 100.0, 100.0)];
        _hotspots.str_hotspotImage = [hotspotInfo objectForKey:@"image"];
        _hotspots.anchorPosition = [[hotspotInfo objectForKey:@"anchorPosition"] intValue];
        [_uis_zoomingMap.blurView addSubview:_hotspots];
        
        [_arr_hotsopts addObject:_hotspots];
    }
}
#pragma mark - Handle Button Actions

-(void)accessTapped
{
    // Set up an Array for Images
    NSMutableArray *arrayofImages = [[NSMutableArray alloc] init];
	[arrayofImages addObject:@"grfx_Access_map.png"];
    [arrayofImages addObject:@"grfx_Access_map_2.png"];
    // Define the Scroll View for Images
    
    _uis_hotspotImages = [[embSimpleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) closeBtnLoc:CGRectMake((self.view.bounds.size.width - 104.0f),20.0f,84.0f,30.0f) btnImg:@"grfx_close_button_2.png" boolBtn:YES bgImg:nil andArray:arrayofImages andTag:150];
    
    [_uis_hotspotImages setDelegate:self];
    _uis_hotspotImages.loopArray = NO;
    _uis_hotspotImages.autoPlay = NO;
    [self.view addSubview: _uis_hotspotImages];
	
	[self removeAllHelpViews];
}

-(void)fenwayTapped
{
	// Set up an Array for Images
    NSMutableArray *arrayofImages = [[NSMutableArray alloc] init];
	[arrayofImages addObject:@"grfx_Yawkey_way.png"];
    [arrayofImages addObject:@"grfx_Yawkey_way2.png"];
    // Define the Scroll View for Images
    
    _uis_hotspotImages = [[embSimpleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) closeBtnLoc:CGRectMake((self.view.bounds.size.width - 104.0f),20.0f,84.0f,30.0f) btnImg:@"grfx_close_button_2.png" boolBtn:YES bgImg:nil andArray:arrayofImages andTag:150];
    
    [_uis_hotspotImages setDelegate:self];
    _uis_hotspotImages.loopArray = NO;
    _uis_hotspotImages.autoPlay = NO;
    [self.view addSubview: _uis_hotspotImages];
	
	[self removeAllHelpViews];
}

-(void)greenSpaceTapped
{
	// Set up an Array for Images
    NSMutableArray *arrayofImages = [[NSMutableArray alloc] init];
	[arrayofImages addObject:@"grfx_Greenspace.png"];
    [arrayofImages addObject:@"IMG_0163.jpg"];
    [arrayofImages addObject:@"IMG_8153.jpg"];
    [arrayofImages addObject:@"IMG_8187.jpg"];
    // Define the Scroll View for Images
    
    _uis_hotspotImages = [[embSimpleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-41.0f) closeBtnLoc:CGRectMake((self.view.bounds.size.width - 104.0f),20.0f,84.0f,30.0f) btnImg:@"grfx_close_button_2.png" boolBtn:YES bgImg:nil andArray:arrayofImages andTag:150];
    
    [_uis_hotspotImages setDelegate:self];
    _uis_hotspotImages.loopArray = NO;
    _uis_hotspotImages.autoPlay = NO;
//    _uis_hotspotImages.showDots = YES;
    [self.view addSubview: _uis_hotspotImages];
	
	[self removeAllHelpViews];
}

-(void)didRemove:(embSimpleScrollView *)customClass
{
    NSLog(@"message received");
    [UIView animateWithDuration:0.33
					 animations:^{
                         customClass.alpha = 0.0f;
                     }
					 completion:^(BOOL  completed){
						 [customClass removeFromSuperview];
                     }];
}


-(void)armyCorpTapped
{
	// Set up an Array for Images
    NSMutableArray *arrayofImages = [[NSMutableArray alloc] init];
	[arrayofImages addObject:@"grfx_Army_corps_1.png"];
	[arrayofImages addObject:@"grfx_Army_corps_2.png"];
    // Define the Scroll View for Images
    
    _uis_hotspotImages = [[embSimpleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) closeBtnLoc:CGRectMake((self.view.bounds.size.width - 104.0f),20.0f,84.0f,30.0f) btnImg:@"grfx_close_button_2.png" boolBtn:YES bgImg:nil andArray:arrayofImages andTag:150];
    
    [_uis_hotspotImages setDelegate:self];
    _uis_hotspotImages.loopArray = NO;
    _uis_hotspotImages.autoPlay = NO;
    [self.view addSubview: _uis_hotspotImages];
    
    [self removeAllHelpViews];
}

-(void)cityBtnTapped
{
    [UIView animateWithDuration:0.2 animations:^{
        _uiv_collapseContainer.alpha = 0.0;
		[self directionViewCleanUp];
    } completion:^(BOOL finished){
        [self citySectionData];
        [self initCellNameLabel:nil];
        [_uib_neighborhood setBackgroundColor:[self chosenBtnColor]];
        _uib_neighborhood.alpha = 1.0;
        [_uib_city setBackgroundColor:[self normalCellColor]];
        _uib_city.alpha = 1.0;
        [_uib_city setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_uib_neighborhood setTitleColor:[self chosenBtnTitleColor] forState:UIControlStateNormal];
        _uiv_closedMenuContainer.frame = CGRectMake(-41.0, (768-36)/2, 41.0, 36);
        [UIView animateWithDuration:0.33 animations:^{
            _uiv_collapseContainer.alpha = 1.0;
        }];
    }];
}

-(void)neighborhoodBtnTapped
{
    [UIView animateWithDuration:0.2 animations:^{
        _uiv_collapseContainer.alpha = 0.0;
		[self directionViewCleanUp];
    }completion:^(BOOL finished){
        [self neighborhoodSectionData];
        [self initCellNameLabel:nil];
        [_uib_city setBackgroundColor:[self chosenBtnColor]];
        _uib_city.alpha = 1.0;
        [_uib_neighborhood setBackgroundColor:[self normalCellColor]];
        _uib_neighborhood.alpha = 1.0;
        [_uib_neighborhood setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_uib_city setTitleColor:[self chosenBtnTitleColor] forState:UIControlStateNormal];
        _uiv_closedMenuContainer.frame = CGRectMake(-41.0, (768-36)/2, 41.0, 36);
        [UIView animateWithDuration:0.33 animations:^{
            _uiv_collapseContainer.alpha = 1.0;
        }];
    }];
}
-(void)closeButtonTapped
{
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_collapseContainer.transform = CGAffineTransformMakeTranslation(-(1+container_W), 0);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.33 animations:^{
            _uiv_closedMenuContainer.transform = CGAffineTransformMakeTranslation(41, 0);
        }];
    }];
}

-(void)openMenu
{
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_closedMenuContainer.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.33 animations:^{
            _uiv_collapseContainer.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }];
}

#pragma mark - Init Data For 2 Sections
-(void)citySectionData
{
    isCity = YES;
    for (UIView *tmp in _arr_hotsopts) {
        [tmp removeFromSuperview];
    }
    [_uiiv_overlays removeFromSuperview];
    for (UIView *tmp in _arr_tapHotspots) {
        [tmp removeFromSuperview];
    }
    [_arr_tapHotspots removeAllObjects];
    
    [_uis_zoomingMap resetScroll];
    CGRect frame = _vanness_Hotspot.frame;
    frame.origin.x = 343;
    frame.origin.y = 356;
    _vanness_Hotspot.frame = frame;
    
    [_uib_greenSpace removeFromSuperview];
    [_uib_armyCorp removeFromSuperview];
    [_uib_yawKey removeFromSuperview];
    _uib_armyCorp = nil;
    _uib_greenSpace = nil;
    _uib_yawKey = nil;
    
    [_uib_greenSpace removeFromSuperview];
    [_uib_armyCorp removeFromSuperview];
    _uib_armyCorp = nil;
    _uib_greenSpace = nil;
    
    UIImage * toMap = [UIImage imageNamed:@"city_map.png"];
	[UIView transitionWithView:self.view
					  duration:0.33f
					   options:UIViewAnimationOptionTransitionCrossDissolve
					animations:^{
                        _uis_zoomingMap.blurView.image = toMap;
					} completion:NULL];
    
    [theCollapseClick closeCollapseClickCellsWithIndexes:_arr_cellName animated:NO];
    [theCollapseClick closeCellResize];
    [_arr_cellName removeAllObjects];
    _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"PUBLIC TRANSIT", @"COLLEGES / UNIVERSITIES", nil];
    theCollapseClick.CollapseClickDelegate = self;
    [theCollapseClick reloadCollapseClick];
    _uib_city.userInteractionEnabled = NO;
    _uib_neighborhood.userInteractionEnabled = YES;
}

-(void)neighborhoodSectionData
{
    isCity = NO;
    for (UIView *tmp in _arr_hotsopts) {
        [tmp removeFromSuperview];
    }
    
    [_uiiv_overlays removeFromSuperview];
    
    for (UIView *tmp in _arr_tapHotspots) {
        [tmp removeFromSuperview];
    }
    [_arr_tapHotspots removeAllObjects];
    
    [_uis_zoomingMap resetScroll];
    CGRect frame = _vanness_Hotspot.frame;
    frame.origin.x = 455;
    frame.origin.y = 349;
    _vanness_Hotspot.frame = frame;
    
    [self initBlockBtns];
    
    UIImage * toMap = [UIImage imageNamed:@"neighborhood_map.jpg"];
	[UIView transitionWithView:self.view
					  duration:0.33f
					   options:UIViewAnimationOptionTransitionCrossDissolve
					animations:^{
                        _uis_zoomingMap.blurView.image = toMap;
					} completion:NULL];
    
    [theCollapseClick closeCollapseClickCellsWithIndexes:_arr_cellName animated:NO];
    [theCollapseClick closeCellResize];
    [_arr_cellName removeAllObjects];
    _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"STATIONS", @"PARKING GARAGES", @"SYSTEM", @"RETAIL", @"DINING", @"RESIDENTIAL/HOTELS", @"HOTSPOTS", @"HOTSPOTS2", nil];
    theCollapseClick.CollapseClickDelegate = self;
    [theCollapseClick reloadCollapseClick];
    _uib_city.userInteractionEnabled = YES;
    _uib_neighborhood.userInteractionEnabled = NO;
}

-(void)resizeCollapseContainer:(int)numOfCell
{
    _uiv_collapseContainer.frame = CGRectMake(0.0f, (768-kCCHeaderHeight*(numOfCell+1))/2, container_W, kCCHeaderHeight*(numOfCell+1));
    theCollapseClick.frame = CGRectMake(0.0f, kCCHeaderHeight, container_W, kCCHeaderHeight*numOfCell);
    theCollapseClick.originalFrameSize = theCollapseClick.frame.size;
}

#pragma mark
#pragma mark - Collapse Click Delegate
// Required Methods
-(int)numberOfCellsForCollapseClick {
    if (isCity == YES) {
        //        _uiv_collapseContainer.frame = CGRectMake(0.0f, (768-kCCHeaderHeight*(numOfCells+1))/2, container_W, kCCHeaderHeight*(numOfCells+1));
        [_uiv_collapseContainer setBackgroundColor:[UIColor clearColor]];
        [self resizeCollapseContainer:3];
        return (int)_arr_cellName.count;
    }
    else{
        //        _uiv_collapseContainer.frame = CGRectMake(0.0f, (768-kCCHeaderHeight*(3+1))/2, container_W, kCCHeaderHeight*(3+1));
        [self resizeCollapseContainer:9];
        [_uiv_collapseContainer setBackgroundColor:[UIColor clearColor]];
        return (int)_arr_cellName.count;
    }
    return 4;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    NSString *str_cellName = [[NSString alloc] init];
    str_cellName = [_arr_cellName objectAtIndex:index];
    return str_cellName;
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:{
            if (isCity) {
//                return nil;
				UIImageView *tmpImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 194)];
                [tmpImgeView setImage:[UIImage imageNamed:@"grfx_city_transit.png"]];
                UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, tmpImgeView.frame.size.height)];
                [uiv_sideBar setBackgroundColor: [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0]];
                [tmpImgeView addSubview: uiv_sideBar];
                return tmpImgeView;
            }
            [self initDirectionContentView];
            return _uiv_directionContent;
            break;
        }
        case 1:{
            if (isCity) {
//                UIImageView *tmpImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 194)];
//                [tmpImgeView setImage:[UIImage imageNamed:@"grfx_city_transit.png"]];
//                UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, tmpImgeView.frame.size.height)];
//                [uiv_sideBar setBackgroundColor: [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0]];
//                [tmpImgeView addSubview: uiv_sideBar];
//                return tmpImgeView;
            }
            return nil;
            break;

        }
        case 2:{
//            _uiv_publicTImg = [[UIView alloc] init];
//            for (UIView *tmp in [_uiv_publicTImg subviews]) {
//                [tmp removeFromSuperview];
//            }
//            UIImageView *uiiv_parking = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_transit.jpg"]];
//            uiiv_parking.frame = CGRectMake(0.0, 0.0, container_W, 50);
//            _uiv_publicTImg.frame = uiiv_parking.frame;
//            [_uiv_publicTImg addSubview:uiiv_parking];
            
//            return _uiv_publicTImg;
            return nil;
            break;
        }
        case 3:{
//            _uiv_atIndex0 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 120.0)];
//            _uiv_atIndex0.backgroundColor = [UIColor greenColor];
//            _uiv_atIndex0.tag = 3000;
//            _uiv_atIndex0.clipsToBounds = NO;
//            return _uiv_atIndex0;
            return nil;
            break;
        }
        case 4:{
//            _uiv_atIndex1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 78.0)];
//            _uiv_atIndex1.backgroundColor = [UIColor redColor];
//            _uiv_atIndex1.tag = 3001;
//            _uiv_atIndex1.clipsToBounds = NO;
//            return _uiv_atIndex1;
            return nil;
            break;
        }
        case 5:{
//            _uiv_atIndex2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 78.0)];
//            _uiv_atIndex2.backgroundColor = [UIColor redColor];
//            _uiv_atIndex2.tag = 3002;
//            _uiv_atIndex2.clipsToBounds = NO;
//            return _uiv_atIndex2;
            return nil;
            break;
        }
        case 6:{
//            _uiv_atIndex3 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 120.0)];
//            _uiv_atIndex3.backgroundColor = [UIColor redColor];
//            _uiv_atIndex3.tag = 3003;
//            _uiv_atIndex3.clipsToBounds = NO;
//            return _uiv_atIndex3;
            return nil;
            break;
        }
        default:
            return nil;
            break;
    }
}
-(UIColor *)colorForTitleSideBarAtIndex:(int)index
{
    switch (index) {
//        case 0: //Driving Direciton
//            return [UIColor colorWithRed:205.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
//            break;
//        case 1: //Parking
//        {
//            if (isCity) {
//                return [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
//            }
//            else{
//                return [UIColor colorWithRed:107.0/255.0 green:96.0/255.0 blue:245.0/255.0 alpha:1.0];
//            }
//            break;
//        }
		case 0: //Driving Direciton
				//            return [UIColor colorWithRed:205.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
				//            break;
			if (isCity) {
                return [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
            }
            else{
                return [UIColor colorWithRed:205.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
            }
            break;
        case 1: //Parking
        {
			//            if (isCity) {
			//                return [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
			//            }
			//            else{
			return [UIColor colorWithRed:107.0/255.0 green:96.0/255.0 blue:245.0/255.0 alpha:1.0];
			//            }
            break;
        }
        case 2: //Public Transit
        {
            if (isCity) {
                return [UIColor colorWithRed:220.0/255.0 green:74.0/255.0 blue:101.0/255.0 alpha:1.0];
            }
            else {
                return [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
            }
            break;
        }
        case 3: //Retail
        {
            if (isCity) {
                return [UIColor colorWithRed:217.0/255.0 green:202.0/255.0 blue:40.0/255.0 alpha:1.0];
            }
            else {
                return [UIColor colorWithRed:220.0/255.0 green:74.0/255.0 blue:101.0/255.0 alpha:1.0];
            }
            break;
        }
        case 4: //Dining
            return [UIColor colorWithRed:232.0/255.0 green:169.0/255.0 blue:49.0/255.0 alpha:1.0];
            break;
        case 5: //Residential&Hotels
            return [UIColor colorWithRed:217.0/255.0 green:202.0/255.0 blue:40.0/255.0 alpha:1.0];
            break;
        default:
            return [UIColor greenColor];
            break;
    }
}
-(UIColor *)colorForTitleLabelAtIndex:(int)index
{
    switch (index) {
        case 0: //Driving Direciton
//            return [UIColor colorWithRed:205.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
//            break;
			if (isCity) {
                return [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
            }
            else{
                return [UIColor colorWithRed:205.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
            }
            break;
        case 1: //Parking
        {
//            if (isCity) {
//                return [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
//            }
//            else{
                return [UIColor colorWithRed:107.0/255.0 green:96.0/255.0 blue:245.0/255.0 alpha:1.0];
//            }
            break;
        }
        case 2: //Public Transit
        {
            if (isCity) {
                return [UIColor colorWithRed:220.0/255.0 green:74.0/255.0 blue:101.0/255.0 alpha:1.0];
            }
            else {
                return [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0];
            }
            break;
        }
        case 3: //Retail
        {
            if (isCity) {
                return [UIColor colorWithRed:217.0/255.0 green:202.0/255.0 blue:40.0/255.0 alpha:1.0];
            }
            else {
                return [UIColor colorWithRed:220.0/255.0 green:74.0/255.0 blue:101.0/255.0 alpha:1.0];
            }
            break;
        }
        case 4: //Dining
            return [UIColor colorWithRed:232.0/255.0 green:169.0/255.0 blue:49.0/255.0 alpha:1.0];
            break;
        case 5: //Residential&Hotels
            return [UIColor colorWithRed:217.0/255.0 green:202.0/255.0 blue:40.0/255.0 alpha:1.0];
            break;
        default:
            return [UIColor greenColor];
            break;
    }
}
-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open;
{
	if (isCity) {
        _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"city_map.png"];
    }
    else
    {
        _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"neighborhood_map.jpg"];
    }
    for (UIView *tmp in _arr_hotsopts) {
        [tmp removeFromSuperview];
    }
    
    [_uiv_directionDot removeFromSuperview];
    [_uiiv_overlays removeFromSuperview];
    [self reloadTableViewAtIndex:index];
    [_arr_hotspotsData removeAllObjects];
    [_arr_hotsopts removeAllObjects];
	[self directionViewCleanUp];

    for (UIView *tmp in _arr_tapHotspots) {
        [tmp removeFromSuperview];
    }
    [_arr_tapHotspots removeAllObjects];
    
    //Check if is in city?
    //Load different overlays..!
    
    NSString *test = [[NSString alloc] initWithString:[_arr_cellName objectAtIndex:index]];
    if (open == NO) {
        _uiv_closedMenuContainer.frame = CGRectMake(-41.0, (768-36)/2, 41.0, 38);
        _uiv_closeMenuSideBar.backgroundColor = [UIColor clearColor];
        [_uil_cellName removeFromSuperview];
        _uib_greenSpace.hidden = NO;
        _uib_yawKey.hidden = NO;
        _uib_armyCorp.hidden = NO;
    }
    else
    {
        _uib_greenSpace.hidden = YES;
        _uib_yawKey.hidden = YES;
        _uib_armyCorp.hidden = YES;
        
        if ((index == 6) || (index == 7)) {
            [_uis_zoomingMap zoomToPoint:self.view.center withScale:1.0 animated:YES];
        }
        
        _uiv_closedMenuContainer.frame = CGRectMake(-41.0, _uiv_collapseContainer.frame.origin.y, 41.0, _uiv_collapseContainer.frame.size.height);
        [self initCellNameLabel:test];
        _uiv_closeMenuSideBar.backgroundColor = [self colorForTitleSideBarAtIndex:index];
        _uil_cellName.textColor = [self colorForTitleSideBarAtIndex:index];
        
        if (isCity) {
            switch (index) {
//                case 0:
//                {
//                    _vanness_Hotspot.hidden = NO;
//                    _vanness_Parking_Hotspot.hidden = YES;
//                    NSLog(@"The tapped index is %i", index);
//                    break;
//                }
                case 0:
                {
                    _vanness_Hotspot.hidden = NO;
                    _vanness_Parking_Hotspot.hidden = YES;
                    _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"city_T_lines.jpg"];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 1:
                {
                    _vanness_Hotspot.hidden = NO;
                    _vanness_Parking_Hotspot.hidden = YES;
                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"universities"] ];
                    [self initHotspots];
                    [_uis_zoomingMap resetPinSize];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 2:
                {
                    _vanness_Hotspot.hidden = NO;
                    _vanness_Parking_Hotspot.hidden = YES;
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 3:
                {
                    _vanness_Hotspot.hidden = NO;
                    _vanness_Parking_Hotspot.hidden = YES;
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                default:
                    break;
            }
            
        }
        
        if (!isCity) {
            switch (index) {
                case 0:
                {
                    _vanness_Hotspot.hidden = NO;
                    _vanness_Parking_Hotspot.hidden = YES;
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 1:
                {
                    _vanness_Hotspot.hidden = YES;
                    _vanness_Parking_Hotspot.hidden = NO;
                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"parking"] ];
                    [self initHotspots];
                    [_uis_zoomingMap resetPinSize];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 2:
                {
                    _vanness_Hotspot.hidden = NO;
                    _vanness_Parking_Hotspot.hidden = YES;
                    _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"location_T_lines.jpg"];
                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"transit"] ];
                    [self initHotspots];
                    [_uis_zoomingMap resetPinSize];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 3:
                {
                    _vanness_Hotspot.hidden = NO;
                    _vanness_Parking_Hotspot.hidden = YES;
                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"retail"] ];
                    [self initHotspots];
                    [_uis_zoomingMap resetPinSize];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 4:
                {
                    _vanness_Hotspot.hidden = NO;
                    _vanness_Parking_Hotspot.hidden = YES;
                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"dining"] ];
                    [self initHotspots];
                    [_uis_zoomingMap resetPinSize];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 5:
                {
                    _vanness_Hotspot.hidden = NO;
                    _vanness_Parking_Hotspot.hidden = YES;
                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"residential"] ];
                    [self initHotspots];
                    [_uis_zoomingMap resetPinSize];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 6:
                {
                    [self initTappleHotspots];
                    CGPoint point = CGPointMake(500, 600);
                    double delayInSeconds1 = 0.5f;
                    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds1 * NSEC_PER_SEC);
                    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                        [_uis_zoomingMap zoomToPoint:point withScale:2.0 animated:YES];
                    });
                    [_uis_zoomingMap resetPinSize];
                    break;
                }
                case 7:
                {
                    NSLog(@"The last one is tapped");
                    [self initTappleHotspots];
                    CGPoint point = CGPointMake(200, 200);
                    double delayInSeconds1 = 0.5f;
                    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds1 * NSEC_PER_SEC);
                    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                        [_uis_zoomingMap zoomToPoint:point withScale:2.0 animated:YES];
                    });
                    [_uis_zoomingMap resetPinSize];
                    break;
                }

                default:
                    break;
            }
        }
    }
    
    [self removeAllHelpViews];
}

#pragma mark - Tappable Hotspots Setting
-(void)initTappleHotspots{
    for (UIView *tmp in _arr_tapHotspots) {
        [tmp removeFromSuperview];
    }
    [_arr_tapHotspots removeAllObjects];
    
    for (int i = 0; i < [_arr_tapHotspotArray count]; i++) {
        NSDictionary *hotspotItem = _arr_tapHotspotArray[i];
        //Get the position
        NSString *str_position = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"xy"]];
        NSRange range = [str_position rangeOfString:@","];
        NSString *str_x = [str_position substringWithRange:NSMakeRange(0, range.location)];
        NSString *str_y = [str_position substringFromIndex:(range.location + 1)];
        float hs_x = [str_x floatValue];
        float hs_y = [str_y floatValue];
        _tappableHotspots = [[neoHotspotsView alloc] initWithFrame:CGRectMake(hs_x, hs_y, 17, 17)];
        _tappableHotspots.delegate = self;
        NSString *str_bgName = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"background"]];
        _tappableHotspots.hotspotBgName = str_bgName;
        _tappableHotspots.withCaption = YES;
        NSString *str_caption = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"caption"]];
        _tappableHotspots.str_labelText = str_caption;
        //            _bldHotspots.labelAlignment = CaptionAlignmentLeft;
        [_tappableHotspots.uil_caption setTextColor:[UIColor whiteColor]];
        _tappableHotspots.uil_caption.frame = CGRectMake(-160, 0, 150, 17);
        [_tappableHotspots.uil_caption setTextAlignment:NSTextAlignmentRight];
        if ((i == 0) || (i == 3)) {
            _tappableHotspots.uil_caption.frame = CGRectMake(_tappableHotspots.uiiv_hsImgView.frame.size.width+10, 0, 150, 17);
            [_tappableHotspots.uil_caption setTextAlignment:NSTextAlignmentLeft];
            _tappableHotspots.frame = CGRectMake(hs_x, _tappableHotspots.frame.origin.y, _tappableHotspots.frame.size.width+160, _tappableHotspots.frame.size.height);
            _tappableHotspots.uiiv_hsImgView.frame = CGRectMake(0.0, 0.0, 17, 17);
        }
        if ((i != 0) && (i != 3)) {
            _tappableHotspots.frame = CGRectMake(hs_x-160, hs_y, _tappableHotspots.frame.size.width+160+17, _tappableHotspots.frame.size.height);
            _tappableHotspots.uil_caption.frame = CGRectMake(0, 0, 150, 17);
            [_tappableHotspots.uil_caption setTextAlignment:NSTextAlignmentRight];
            _tappableHotspots.uiiv_hsImgView.frame = CGRectMake(160, 0, 17, 17);
        }

        NSString *str_type = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"type"]];
        _tappableHotspots.str_typeOfHs = str_type;
        _tappableHotspots.uil_caption.drawOutline = YES;
        _tappableHotspots.tagOfHs = i+500;
        [_arr_tapHotspots addObject: _tappableHotspots];
        [_uis_zoomingMap.blurView addSubview: _tappableHotspots];
    }
}

-(void)neoHotspotsView:(neoHotspotsView *)hotspot didSelectItemAtIndex:(NSInteger)index{
    // Set up an Array for Images
    NSMutableArray *arrayofImages = [[NSMutableArray alloc] init];
    [arrayofImages addObject:@"Roof_Terrace.jpg"];
    [arrayofImages addObject:@"Office.jpg"];
    [arrayofImages addObject:@"Terrace.jpg"];
    [arrayofImages addObject:@"grfx_Office_facts.png"];
    [arrayofImages addObject:@"Lobby.jpg"];
    // Define the Scroll View for Images
    
    _uis_hotspotImages = [[embSimpleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) closeBtnLoc:CGRectMake((self.view.bounds.size.width - 104.0f),20.0f,84.0f,30.0f) btnImg:@"grfx_close_button_2.png" boolBtn:YES bgImg:nil andArray:arrayofImages andTag:150];
    
    [_uis_hotspotImages setDelegate:self];
    _uis_hotspotImages.loopArray = NO;
    _uis_hotspotImages.autoPlay = NO;
    [_uis_hotspotImages openScrollViewAtPage:(int)(index-500)];
    [self.view addSubview: _uis_hotspotImages];
    return;

}

#pragma mark - Reload Tableview According to the index
-(void)reloadTableViewAtIndex:(int)index
{
    
    NSString *path;
    UIView *tmp;
    
    if (index == 3) {
        path = @"hotspotList";
        tmp = _uiv_atIndex0;
    }
    else if (index == 4) {
        path = @"hotspotLis";
        tmp = _uiv_atIndex1;
    }
    else if (index == 5) {
        path = @"hotspotLis";
        tmp = _uiv_atIndex2;
    }
    else if (index == 6) {
        path = @"hotspotList";
        tmp = _uiv_atIndex3;
    }
    
    NSString *tmpp = [[NSBundle mainBundle] pathForResource:path ofType:@"plist"];
    _contentTableView.arr_tableData = [[NSMutableArray alloc] initWithContentsOfFile:tmpp];
    
    [self performSelector:@selector(changeview:) withObject:tmp afterDelay:0.25];
}

-(void)changeview: (UIView *)tmpView
{
    [_contentTableView.tableView reloadData];
    _contentTableView.tableView.frame = tmpView.frame;
    [tmpView addSubview:_contentTableView.tableView];
    
}

#pragma mark - Init Map kit Btns & Views
-(void)initMapToggle
{
    _uiv_mapToggles = [[UIView alloc] initWithFrame:CGRectMake(880.0f, 20.0f, 120.0f, 80.0f)];
//    _uiv_mapToggles.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
    
    _uib_originalMap = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_originalMap.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    _uib_originalMap.backgroundColor = [UIColor clearColor];
    [_uib_originalMap setBackgroundImage:[UIImage imageNamed:@"map_neo-OFF.png"] forState:UIControlStateNormal];
    [_uib_originalMap setBackgroundImage:[UIImage imageNamed:@"map_neo-ON.png"] forState:UIControlStateSelected];
    [_uib_originalMap addTarget:self action:@selector(showOriginalMap) forControlEvents:UIControlEventTouchDown];
    [_uib_originalMap setSelected:YES];
    [_uiv_mapToggles addSubview: _uib_originalMap];
    
    _uib_appleMap = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_appleMap.frame = CGRectMake(40.0, 0.0, 40.0, 40.0);
    _uib_appleMap.backgroundColor = [UIColor clearColor];
    [_uib_appleMap setBackgroundImage:[UIImage imageNamed:@"map_apple-OFF.png"] forState:UIControlStateNormal];
    [_uib_appleMap setBackgroundImage:[UIImage imageNamed:@"map_apple-ON.png"] forState:UIControlStateSelected];
    [_uib_appleMap addTarget:self action:@selector(showAppleMap) forControlEvents:UIControlEventTouchDown];
    [_uiv_mapToggles addSubview: _uib_appleMap];
    
    _uib_googleMap = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_googleMap.frame = CGRectMake(80.0, 0.0, 40.0, 40.0);
    _uib_googleMap.backgroundColor = [UIColor clearColor];
    [_uib_googleMap setBackgroundImage:[UIImage imageNamed:@"map_google-OFF.png"] forState:UIControlStateNormal];
    [_uib_googleMap setBackgroundImage:[UIImage imageNamed:@"map_google-ON.png"] forState:UIControlStateSelected];
    [_uib_googleMap addTarget:self action:@selector(loadGoogleEarth) forControlEvents:UIControlEventTouchDown];
    [_uiv_mapToggles addSubview: _uib_googleMap];
    
    _uib_appleMapToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_appleMapToggle.frame = CGRectMake(0.0, 40.0, 120.0, 40.0);
    _uib_appleMapToggle.backgroundColor = [UIColor clearColor];
    [_uib_appleMapToggle setBackgroundImage:[UIImage imageNamed:@"map_apple-Toggle.png"] forState:UIControlStateNormal];
    [_uib_appleMapToggle setTitle:@"Satellite" forState:UIControlStateNormal];
    _uib_appleMapToggle.hidden = YES;
    [_uib_appleMapToggle addTarget:self action:@selector(changeMapType) forControlEvents:UIControlEventTouchDown];
    [_uiv_mapToggles addSubview:_uib_appleMapToggle];
    
    [self.view insertSubview:_uiv_mapToggles aboveSubview:_uiiv_bgImg];
}

-(void)initMapView
{
    _uiv_mapContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    
    [_uiv_mapContainer addSubview: _mapView];
    [self.view insertSubview:_uiv_mapContainer belowSubview:_uiv_mapToggles];
}


#pragma  mark - Deal With Maps
-(void)showOriginalMap
{
    [_uib_appleMap setSelected:NO];
    [_uib_originalMap setSelected:YES];
    [_uib_googleMap setSelected:NO];
    
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_collapseContainer.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished){  }];
    [_uiv_mapContainer removeFromSuperview];
    _uiv_mapContainer = nil;
    _uib_appleMapToggle.hidden = YES;
    [_uib_appleMapToggle setTitle:@"Satellite" forState:UIControlStateNormal];
    _uib_appleMap.userInteractionEnabled = YES;
}
-(void)loadGoogleEarth
{
    NSURL *urlApp = [NSURL URLWithString:@"comgoogleearth://"];
	BOOL canOpenApp = [[UIApplication sharedApplication] canOpenURL:urlApp];
	printf("\n canOpenGoogleEarth:%i \n",canOpenApp);
	
	if (canOpenApp) {
		[[UIApplication sharedApplication] canOpenURL:urlApp];
		NSString *stringURL = @"comgoogleearth://";
		NSURL *url = [NSURL URLWithString:stringURL];
		[[UIApplication sharedApplication] openURL:url];
	} else {
		UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Sorry!"
								   message: @"You need Google Earth installed."
								  delegate: self
						 cancelButtonTitle: @"Cancel"
						 otherButtonTitles: @"Install",nil];
		[alert show];
	}
}
- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
    NSLog(@"foobage! %i", (int)buttonIndex);
	if (buttonIndex==1) {
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://itunes.apple.com/us/app/google-earth/id293622097?mt=8"]];
	}
}
-(void)showAppleMap
{
    _uib_appleMapToggle.hidden = NO;
    
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_collapseContainer.transform = CGAffineTransformMakeTranslation(-(1+container_W), 0);
    } completion:^(BOOL finished){  }];
    
    [_uib_appleMap setSelected:YES];
    [_uib_originalMap setSelected:NO];
    [_uib_googleMap setSelected:NO];
    _uib_appleMap.userInteractionEnabled = NO;
    [self initMapView];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.344518;
    zoomLocation.longitude= -71.099107;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:NO];
    
    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"1325 Boylston Ave" andCoordinate:zoomLocation];
    [self.mapView addAnnotation:newAnnotation];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region;
	if (isCity) {
        region = MKCoordinateRegionMakeWithDistance([mp coordinate], 2500, 2500);
    }
    else {
        region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
    }
	[mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate =
	userLocation.location.coordinate;
}

-(void)changeMapType
{
    NSLog(@"chnagemaptype");
	if (_mapView.mapType == MKMapTypeStandard)
	{
		_mapView.mapType = MKMapTypeSatellite;
		[_uib_appleMapToggle setTitle:@"Hybrid" forState:UIControlStateNormal];
    } else if (_mapView.mapType == MKMapTypeSatellite)
	{
		_mapView.mapType = MKMapTypeHybrid;
		[_uib_appleMapToggle setTitle:@"Standard" forState:UIControlStateNormal];
	} else if (_mapView.mapType == MKMapTypeHybrid)
	{
		_mapView.mapType = MKMapTypeStandard;
		[_uib_appleMapToggle setTitle:@"Satellite" forState:UIControlStateNormal];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
