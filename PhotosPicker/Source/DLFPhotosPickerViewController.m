//
//  DLFPhotosPickerViewController.m
//  PhotosPicker
//
//  Created by  on 11/28/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import "DLFPhotosPickerViewController.h"

#import "DLFMasterViewController.h"
#import "DLFDetailViewController.h"

@interface DLFPhotosPickerViewController () <DLFMasterViewControllerDelegate>

@end

@implementation DLFPhotosPickerViewController

- (void)awakeFromNib {
    self.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
         showViewController:(UIViewController *)vc
                     sender:(id)sender {
    NSLog(@"showing master");
    return NO;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
   showDetailViewController:(UIViewController *)vc
                     sender:(id)sender {
    NSLog(@"showing detail");
    return NO;
}

- (UIViewController *)primaryViewControllerForCollapsingSplitViewController:(UISplitViewController *)splitViewController {
    NSLog(@"returning primary view controller");
    return nil;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UINavigationController *)secondaryViewController
  ontoPrimaryViewController:(UINavigationController *)primaryViewController {
    UIViewController *controller1 = [secondaryViewController.viewControllers firstObject];
    DLFMasterViewController *controller2 = [primaryViewController.viewControllers firstObject];
    controller2.delegate = self;
    NSLog(@"collapseSecondaryViewController %@ primaryviewcontroller %@", NSStringFromClass(controller1.class), NSStringFromClass(controller2.class));
    return NO;
}

- (UIViewController *)primaryViewControllerForExpandingSplitViewController:(UISplitViewController *)splitViewController {
    NSLog(@"primaryViewControllerForExpandingSplitViewController");
    return nil;
}

- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController
separateSecondaryViewControllerFromPrimaryViewController:(UINavigationController *)primaryViewController {
    DLFMasterViewController *controller1 = [primaryViewController.viewControllers firstObject];
    controller1.delegate = self;
    return nil;
}

#pragma mark - DLFMasterViewControllerDelegate

- (void)masterViewController:(DLFMasterViewController *)masterViewController didTapCancelButton:(UIButton *)sender {
    NSLog(@"tap on cancel");
    
    if (self.photosPickerDelegate && [self.photosPickerDelegate respondsToSelector:@selector(photosPickerDidCancel:)]) {
        [self.photosPickerDelegate photosPickerDidCancel:self];
    }
}

@end
