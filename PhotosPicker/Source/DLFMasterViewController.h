//
//  MasterViewController.h
//  PhotosPicker
//
//  Created by  on 11/26/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLFMasterViewController;

@protocol DLFMasterViewControllerDelegate <NSObject>

@optional
- (void)masterViewController:(DLFMasterViewController *)masterViewController didTapCancelButton:(UIButton *)sender;

@end

@interface DLFMasterViewController : UITableViewController

@property (nonatomic, weak) id<DLFMasterViewControllerDelegate> delegate;

@end
