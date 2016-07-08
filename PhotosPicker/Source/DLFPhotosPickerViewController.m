//
//  DLFPhotosPickerViewController.m
//  PhotosPicker
//
//  Created by  on 11/28/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import "DLFPhotosPickerViewController.h"
#import "DLFConstants.h"
#import "DLFMasterViewController.h"
#import "DLFDetailViewController.h"
#import "DLFPhotosSelectionManager.h"
#import "DLFPhotosLibrary.h"
#import "DLFAssetsLayout.h"

@interface DLFPhotosPickerViewController () <DLFMasterViewControllerDelegate, DLFDetailViewControllerDelegate>

@property (nonatomic, strong) UISplitViewController *splitVC;

@end

@implementation DLFPhotosPickerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _multipleSelections = YES;
        
        self.splitVC = [[UISplitViewController alloc] init];
        [self.splitVC setDelegate:self];
        
        DLFMasterViewController *masterVC = [[DLFMasterViewController alloc] initWithStyle:UITableViewStyleGrouped];
        DLFDetailViewController *detailVC = [[DLFDetailViewController alloc] initWithCollectionViewLayout:[[DLFAssetsLayout alloc] init]];
        
        UINavigationController *masterNavVC = [[UINavigationController alloc] initWithRootViewController:masterVC];
        UINavigationController *detailNavVC = [[UINavigationController alloc] initWithRootViewController:detailVC];
        [self.splitVC setViewControllers:@[masterNavVC, detailNavVC]];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _multipleSelections = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISplitViewController *splitVC = self.splitVC;
    [self addChildViewController:splitVC];
    splitVC.view.frame = self.view.bounds;
    [self.view addSubview:splitVC.view];
    [splitVC didMoveToParentViewController:self];
    
    [self performTraitCollectionOverrideForSize:self.view.bounds.size];
    
    [[DLFPhotosSelectionManager sharedManager] removeAllAssets];
    
    if (DLF_IS_IPAD) {
        self.splitVC.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    }
    
    [[DLFPhotosLibrary sharedLibrary] startObserving];
    
    if (self.splitVC.viewControllers.count > 1) {
        UINavigationController *firstVC = [self.splitVC.viewControllers firstObject];
        UINavigationController *secondVC = [self.splitVC.viewControllers lastObject];
        
        DLFMasterViewController *masterVC = [firstVC.viewControllers firstObject];
        DLFDetailViewController *detailVC = [secondVC.viewControllers firstObject];
        
        [masterVC setDelegate:self];
        [detailVC setDelegate:self];
    } else {
        DLFDetailViewController *detailVC = [((UINavigationController *)[self.splitVC.viewControllers lastObject]).viewControllers firstObject];
        [detailVC setDelegate:self];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self performTraitCollectionOverrideForSize:size];
}

- (UISplitViewController *)splitViewController {
    return [self.childViewControllers firstObject];
}

- (void)performTraitCollectionOverrideForSize:(CGSize)size {
    if (!(DLF_IS_IPAD)) {
        return;
    }
    UITraitCollection *trait = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];
    for (UIViewController *vc in self.childViewControllers) {
        [self setOverrideTraitCollection:trait forChildViewController:vc];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[DLFPhotosLibrary sharedLibrary] stopObserving];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
   showDetailViewController:(UINavigationController *)vc
                     sender:(id)sender {
    DLFDetailViewController *controller1 = [vc.viewControllers firstObject];
    controller1.delegate = self;
    return NO;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UINavigationController *)secondaryViewController
  ontoPrimaryViewController:(UINavigationController *)primaryViewController {
    DLFDetailViewController *controller1 = [secondaryViewController.viewControllers firstObject];
    DLFMasterViewController *controller2 = [primaryViewController.viewControllers firstObject];
    controller1.delegate = self;
    controller2.delegate = self;
    return NO;
}

- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController
separateSecondaryViewControllerFromPrimaryViewController:(UINavigationController *)primaryViewController {
    DLFMasterViewController *controller1 = [primaryViewController.viewControllers firstObject];
    controller1.delegate = self;
    return nil;
}

#pragma mark - DLFMasterViewControllerDelegate

- (void)masterViewController:(DLFMasterViewController *)masterViewController didTapCancelButton:(UIButton *)sender {
    if (self.photosPickerDelegate && [self.photosPickerDelegate respondsToSelector:@selector(photosPickerDidCancel:)]) {
        [self.photosPickerDelegate photosPickerDidCancel:self];
    }
}


#pragma mark - DLFDetailViewControllerDelegate

- (void)detailViewController:(DLFDetailViewController *)detailViewController didTapNextButton:(UIButton *)nextButton photos:(NSArray *)photos {
    if (self.photosPickerDelegate && [self.photosPickerDelegate respondsToSelector:@selector(photosPicker:detailViewController:didSelectPhotos:)]) {
        [self.photosPickerDelegate photosPicker:self detailViewController:detailViewController didSelectPhotos:photos];
    }
}

- (void)detailViewController:(DLFDetailViewController *)detailViewController configureCell:(DLFPhotoCell *)cell indexPath:(NSIndexPath *)indexPath asset:(PHAsset *)asset {
    if (self.photosPickerDelegate && [self.photosPickerDelegate respondsToSelector:@selector(photosPicker:detailViewController:configureCell:indexPath:asset:)]) {
        [self.photosPickerDelegate photosPicker:self detailViewController:detailViewController configureCell:cell indexPath:indexPath asset:asset];
    }
}

- (BOOL)multipleSelectionsInDetailViewController:(DLFDetailViewController *)detailViewController {
    return self.multipleSelections;
}
- (void)detailViewController:(DLFDetailViewController *)detailViewController didSelectPhoto:(PHAsset *)photo {
    if (self.photosPickerDelegate && [self.photosPickerDelegate respondsToSelector:@selector(photosPicker:detailViewController:didSelectPhoto:)]) {
        [self.photosPickerDelegate photosPicker:self detailViewController:detailViewController didSelectPhoto:photo];
    }
}

@end
