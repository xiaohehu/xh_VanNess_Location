//
//  xhHelpView.h
//  xhHelpView
//
//  Created by Xiaohe Hu on 2/5/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class xhHelpView;
@protocol xhHelpViewDelegate
@optional
-(void)removeHelpView:(xhHelpView *)customView;
@end

@interface xhHelpView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString          *dictKey;
@property (nonatomic)         BOOL              isTappable;
@property (nonatomic, strong) UIView            *uiv_detailInfo;
@property (nonatomic, strong) NSString          *str_helpText;
@property (nonatomic, weak) id <xhHelpViewDelegate> delegate;

-(void)setIsTappable:(BOOL)tappable;
@end
