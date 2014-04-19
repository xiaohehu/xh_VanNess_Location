//
//  neighborhoodViewController.h
//  neo1325Boylston
//
//  Created by Xiaohe Hu on 1/13/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClick.h"
#import "contentTableViewController.h"
#import <MapKit/MapKit.h>
#import "xhHelpView.h"
@interface neighborhoodViewController : UIViewController <CollapseClickDelegate, UITextFieldDelegate, MKMapViewDelegate, xhHelpViewDelegate, UIGestureRecognizerDelegate>
{
    CollapseClick   *theCollapseClick;
    BOOL            isCity;
}

@end
