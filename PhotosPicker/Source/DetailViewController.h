//
//  DetailViewController.h
//  PhotosPicker
//
//  Created by  on 11/26/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

@import UIKit;
@import Photos;

@interface DetailViewController : UICollectionViewController

@property (strong) PHFetchResult *assetsFetchResults;
@property (strong) PHAssetCollection *assetCollection;

@end
