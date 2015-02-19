//
//  MasterViewController.m
//  PhotosPicker
//
//  Created by  on 11/26/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import "DLFMasterViewController.h"
#import "DLFDetailViewController.h"
#import <Photos/Photos.h>

@interface DLFMasterViewController () <PHPhotoLibraryChangeObserver>

@property NSMutableArray *objects;

@property (strong) NSArray *collectionsFetchResults;
@property (strong) NSArray *collectionsLocalizedTitles;

@end

@implementation DLFMasterViewController

static NSString * const AllPhotosReuseIdentifier = @"AllPhotosCell";
static NSString * const CollectionCellReuseIdentifier = @"CollectionCell";

static NSString * const AllPhotosSegue = @"showAllPhotos";
static NSString * const CollectionSegue = @"showCollection";

- (void)awakeFromNib
{
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    self.collectionsFetchResults = @[smartAlbums, topLevelUserCollections];
    self.collectionsLocalizedTitles = @[NSLocalizedString(@"Smart Albums", @""), NSLocalizedString(@"Albums", @"")];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    self.title = NSLocalizedString(@"Albums", nil);
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(didTapCancelButton:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)didTapCancelButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(masterViewController:didTapCancelButton:)]) {
        [self.delegate masterViewController:self didTapCancelButton:sender];
    }
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DLFDetailViewController *detailViewController = [[segue.destinationViewController viewControllers] firstObject];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    if ([segue.identifier isEqualToString:AllPhotosSegue]) {
        detailViewController.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        detailViewController.title = NSLocalizedString(@"All Photos", nil);
    } else if ([segue.identifier isEqualToString:CollectionSegue]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PHFetchResult *fetchResult = self.collectionsFetchResults[indexPath.section - 1];
        PHCollection *collection = fetchResult[indexPath.row];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            detailViewController.assetsFetchResults = assetsFetchResult;
            detailViewController.assetCollection = assetCollection;
            detailViewController.title = collection.localizedTitle;
        }
    }
    if (self.delegate) {
        [detailViewController setDelegate:(id)self.delegate];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.collectionsFetchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (section == 0) {
        numberOfRows = 1; // "All Photos" section
    } else {
        PHFetchResult *fetchResult = self.collectionsFetchResults[section - 1];
        numberOfRows = fetchResult.count;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *localizedTitle = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:AllPhotosReuseIdentifier forIndexPath:indexPath];
        localizedTitle = NSLocalizedString(@"All Photos", @"");
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CollectionCellReuseIdentifier forIndexPath:indexPath];
        PHFetchResult *fetchResult = self.collectionsFetchResults[indexPath.section - 1];
        PHCollection *collection = fetchResult[indexPath.row];
        localizedTitle = collection.localizedTitle;
    }
    cell.textLabel.text = localizedTitle;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section > 0) {
        title = self.collectionsLocalizedTitles[section - 1];
    }
    return title;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *updatedCollectionsFetchResults = nil;
        
        for (PHFetchResult *collectionsFetchResult in self.collectionsFetchResults) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            if (changeDetails) {
                if (!updatedCollectionsFetchResults) {
                    updatedCollectionsFetchResults = [self.collectionsFetchResults mutableCopy];
                }
                [updatedCollectionsFetchResults replaceObjectAtIndex:[self.collectionsFetchResults indexOfObject:collectionsFetchResult] withObject:[changeDetails fetchResultAfterChanges]];
            }
        }
        
        if (updatedCollectionsFetchResults) {
            self.collectionsFetchResults = updatedCollectionsFetchResults;
            [self.tableView reloadData];
        }
        
    });
}

@end
