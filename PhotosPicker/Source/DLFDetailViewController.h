//
//  DetailViewController.h
//  PhotosPicker
//
//  Created by  on 11/26/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

@import UIKit;
@import Photos;

#import "DLFPhotosSelectionManager.h"

@class DLFDetailViewController;

@protocol DLFDetailViewControllerDelegate <NSObject>

@optional
- (void)detailViewController:(DLFDetailViewController *)detailViewController didTapNextButton:(UIButton *)nextButton photos:(NSArray *)photos;

@end

@interface DLFDetailViewController : UICollectionViewController

@property (strong) PHFetchResult *assetsFetchResults;
@property (strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) DLFPhotosSelectionManager *selectionManager;
@property (nonatomic, weak) id<DLFDetailViewControllerDelegate> delegate;

@end
