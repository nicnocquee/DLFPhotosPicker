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

@class DLFPhotoCell;
@class DLFDetailViewController;

@protocol DLFDetailViewControllerDelegate <NSObject>

@optional
- (BOOL)multipleSelectionsInDetailViewController:(DLFDetailViewController *)detailViewController;
- (void)detailViewController:(DLFDetailViewController *)detailViewController didSelectPhoto:(PHAsset *)photo;
- (void)detailViewController:(DLFDetailViewController *)detailViewController didTapNextButton:(UIButton *)nextButton photos:(NSArray *)photos;
- (void)detailViewController:(DLFDetailViewController *)detailViewController configureCell:(DLFPhotoCell *)cell indexPath:(NSIndexPath *)indexPath asset:(PHAsset *)asset;

@end

@interface DLFDetailViewController : UICollectionViewController

@property (strong) PHFetchResult *assetsFetchResults;
@property (strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) DLFPhotosSelectionManager *selectionManager;
@property (nonatomic, weak) id<DLFDetailViewControllerDelegate> delegate;

@end
