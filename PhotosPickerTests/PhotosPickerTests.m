//
//  PhotosPickerTests.m
//  PhotosPickerTests
//
//  Created by  on 11/26/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "DLFPhotosPickerViewController.h"
#import "DLFMasterViewController.h"
#import "DLFDetailViewController.h"
#import "DLFAssetsLayout.h"
#import "DLFPhotosSelectionManager.h"
#import "DLFPhotoCell.h"

@interface PickerDelegate : NSObject <DLFPhotosPickerViewControllerDelegate>
@property (nonatomic, copy) void (^didSelectPhoto)(PHAsset *photo);
@property (nonatomic, copy) void (^didSelectPhotos)(NSArray *photos);
@property (nonatomic, copy) void (^didSelectCancel)(BOOL result);
@property (nonatomic, copy) void (^configureCell)(DLFPhotoCell *cell, NSIndexPath *indexPath, PHAsset *asset);
@end

@interface DLFPhotosPickerViewController (Testable)
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture;
- (void)didTapNextButton:(id)sender;
- (void)toggleSelectedIndexPath:(NSIndexPath *)indexPath;
@end

@interface DLFMasterViewController (Testable)
- (void)didTapCancelButton:(id)sender;
@end

@interface DLFDetailViewController (Testable)
- (NSCache *)imagesCache;
@end

@interface DLFPhotosSelectionManager (Testable)
- (id)initWithView:(UIView *)view;
@end

@interface PhotosPickerTests : XCTestCase
@end

@implementation PhotosPickerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    DLFPhotosPickerViewController *photos = [[DLFPhotosPickerViewController alloc] init];
    XCTAssertNotNil(photos);
    XCTAssertTrue(photos.multipleSelections);
    XCTAssertNotNil(photos.splitVC);
    XCTAssertEqual(photos.splitVC.viewControllers.count, 2);
}

- (void)testMasterInit {
    DLFMasterViewController *master = [[DLFMasterViewController alloc] initWithStyle:UITableViewStyleGrouped];
    XCTAssertNotNil(master);
}

- (void)testDetailInit {
    DLFDetailViewController *detail = [[DLFDetailViewController alloc] initWithCollectionViewLayout:[[UICollectionViewLayout alloc] init]];
    XCTAssertNotNil(detail);
}

- (void)testLayout {
    DLFAssetsLayout *layout = [[DLFAssetsLayout alloc] init];
    XCTAssertNotNil(layout);
    XCTAssertTrue([layout isKindOfClass:[UICollectionViewFlowLayout class]]);
}

- (void)testSelectSinglePhotoDelegate {
    XCTestExpectation *expect = [self expectationWithDescription:@"didSelectPhoto"];
    
    // mock gesture
    id mockGesture = OCMClassMock([UITapGestureRecognizer class]);
    OCMStub([mockGesture locationInView:[OCMArg any]]).andReturn(CGPointZero);
    
    // mock collection view for detail view controller
    id mockCollectionView = OCMClassMock([UICollectionView class]);
    OCMStub([mockCollectionView indexPathForItemAtPoint:CGPointZero]).andReturn([NSIndexPath indexPathForItem:0 inSection:0]);
    
    // create photos picker controller
    DLFPhotosPickerViewController *photos = [[DLFPhotosPickerViewController alloc] init];
    photos.multipleSelections = NO;
    PickerDelegate *delegate = [[PickerDelegate alloc] init];
    [delegate setDidSelectPhoto:^(PHAsset *asset) {
        XCTAssertNotNil(asset);
        XCTAssertTrue([asset.localIdentifier isEqualToString:@"hello"]);
        [expect fulfill];
    }];
    [photos setPhotosPickerDelegate:delegate];
    
    DLFDetailViewController *detail = (DLFDetailViewController *)[((UINavigationController *)[photos.splitVC.viewControllers lastObject]).viewControllers lastObject];
    XCTAssertNotNil(detail);
    [detail setDelegate:photos];
    
    id photosDetailMock = OCMPartialMock(detail);
    OCMStub([photosDetailMock collectionView]).andReturn(mockCollectionView);
    
    id mockAsset = OCMClassMock([PHAsset class]);
    OCMStub([mockAsset localIdentifier]).andReturn(@"hello");
    id mockFetchResult = OCMClassMock([PHFetchResult class]);
    OCMStub([mockFetchResult objectAtIndexedSubscript:0]).andReturn(mockAsset);
    OCMStub([photosDetailMock assetsFetchResults]).andReturn(mockFetchResult);
    
    [photosDetailMock handleTapGesture:mockGesture];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

- (void)testSelectMultiplePhotosDelegate {
    XCTestExpectation *expect = [self expectationWithDescription:@"didSelectPhotos"];
    
    // mock gesture
    id mockGesture = OCMClassMock([UITapGestureRecognizer class]);
    OCMStub([mockGesture locationInView:[OCMArg any]]).andReturn(CGPointZero);
    id mockGesture2 = OCMClassMock([UITapGestureRecognizer class]);
    OCMStub([mockGesture2 locationInView:[OCMArg any]]).andReturn(CGPointMake(10, 10));
    
    // mock collection view for detail view controller
    id mockCollectionView = OCMClassMock([UICollectionView class]);
    OCMStub([mockCollectionView indexPathForItemAtPoint:CGPointZero]).andReturn([NSIndexPath indexPathForItem:0 inSection:0]);
    OCMStub([mockCollectionView indexPathForItemAtPoint:CGPointMake(10, 10)]).andReturn([NSIndexPath indexPathForItem:1 inSection:0]);
    
    // create photos picker controller
    DLFPhotosPickerViewController *photos = [[DLFPhotosPickerViewController alloc] init];
    photos.multipleSelections = YES;
    PickerDelegate *delegate = [[PickerDelegate alloc] init];
    [delegate setDidSelectPhotos:^(NSArray *assets) {
        XCTAssertNotNil(assets);
        XCTAssertEqual(assets.count, 2);
        [expect fulfill];
    }];
    [photos setPhotosPickerDelegate:delegate];
    
    DLFDetailViewController *detail = (DLFDetailViewController *)[((UINavigationController *)[photos.splitVC.viewControllers lastObject]).viewControllers lastObject];
    XCTAssertNotNil(detail);
    [detail setDelegate:photos];
    
    id photosDetailMock = OCMPartialMock(detail);
    OCMStub([photosDetailMock collectionView]).andReturn(mockCollectionView);
    
    id selectionManagerMock = OCMClassMock([DLFPhotosSelectionManager class]);
    id mockAsset1 = OCMClassMock([PHAsset class]);
    OCMStub([mockAsset1 localIdentifier]).andReturn(@"hello");
    id mockAsset2 = OCMClassMock([PHAsset class]);
    OCMStub([mockAsset1 localIdentifier]).andReturn(@"hello 2");
    NSArray *returnedAssets = @[mockAsset1, mockAsset2];
    OCMStub([selectionManagerMock selectedAssets]).andReturn(returnedAssets);
    OCMStub([photosDetailMock selectionManager]).andReturn(selectionManagerMock);
    [photosDetailMock didTapNextButton:nil];
    
    [photosDetailMock handleTapGesture:mockGesture];
    OCMVerify([photosDetailMock toggleSelectedIndexPath:[OCMArg any]]);
    [photosDetailMock handleTapGesture:mockGesture];
    OCMVerify([photosDetailMock toggleSelectedIndexPath:[OCMArg any]]);
   
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

- (void)testCancelDelegate {
    XCTestExpectation *expect = [self expectationWithDescription:@"didCancel"];
    
    DLFPhotosPickerViewController *photos = [[DLFPhotosPickerViewController alloc] init];
    photos.multipleSelections = YES;
    PickerDelegate *delegate = [[PickerDelegate alloc] init];
    [delegate setDidSelectCancel:^(BOOL cancel) {
        XCTAssertTrue(cancel);
        [expect fulfill];
    }];
    [photos setPhotosPickerDelegate:delegate];
    
    DLFMasterViewController *master = (DLFMasterViewController *)[((UINavigationController *)[photos.splitVC.viewControllers firstObject]).viewControllers lastObject];
    [master setDelegate:photos];
    [master didTapCancelButton:nil];
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

- (void)testConfigureCell {
    XCTestExpectation *expect = [self expectationWithDescription:@"configureCell"];
    
    DLFPhotosPickerViewController *photos = [[DLFPhotosPickerViewController alloc] init];
    photos.multipleSelections = YES;
    PickerDelegate *delegate = [[PickerDelegate alloc] init];
    [delegate setConfigureCell:^(DLFPhotoCell *cell, NSIndexPath *indexPath, PHAsset *asset) {
        XCTAssertNotNil(cell);
        XCTAssertNotNil(indexPath);
        XCTAssertNotNil(asset);
        
        [expect fulfill];
    }];
    [photos setPhotosPickerDelegate:delegate];
    DLFDetailViewController *detail = (DLFDetailViewController *)[((UINavigationController *)[photos.splitVC.viewControllers lastObject]).viewControllers lastObject];
    XCTAssertNotNil(detail);
    [detail setDelegate:photos];
    
    // mock collection view for detail view controller
    id mockCell = OCMClassMock([DLFPhotoCell class]);
    
    id mockCollectionView = OCMClassMock([UICollectionView class]);
    OCMStub([mockCollectionView dequeueReusableCellWithReuseIdentifier:[OCMArg any] forIndexPath:[OCMArg any]]).andReturn(mockCell);
    
    id photosDetailMock = OCMPartialMock(detail);
    OCMStub([photosDetailMock collectionView]).andReturn(mockCollectionView);
    
    id mockAsset = OCMClassMock([PHAsset class]);
    OCMStub([mockAsset localIdentifier]).andReturn(@"hello");
    id mockFetchResult = OCMClassMock([PHFetchResult class]);
    OCMStub([mockFetchResult objectAtIndexedSubscript:0]).andReturn(mockAsset);
    OCMStub([photosDetailMock assetsFetchResults]).andReturn(mockFetchResult);
    
    id mockCache = OCMClassMock([NSCache class]);
    id mockImage = OCMClassMock([UIImage class]);
    OCMStub([mockCache objectForKey:[OCMArg any]]).andReturn(mockImage);
    OCMStub([photosDetailMock imagesCache]).andReturn(mockCache);
    
    [photosDetailMock collectionView:mockCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

- (void)testSelectionManager {
    DLFPhotosSelectionManager *manager = [[DLFPhotosSelectionManager alloc] initWithView:nil];
    
    //id mockSelectedPhotosView = OCMClassMock([DLFPhotosSelectionView class]);
    id mockManager = OCMPartialMock(manager);
    OCMStub([mockManager selectedPhotosView]).andReturn(nil);
    
    XCTAssertNotNil(manager);
    XCTAssertEqual([manager count], 0);
    
    id mockAsset = OCMClassMock([PHAsset class]);
    OCMStub([mockAsset localIdentifier]).andReturn(@"hello");
    [mockManager addSelectedAsset:mockAsset];
    XCTAssertEqual([manager count], 1);
    
    [mockManager removeAsset:mockAsset];
    XCTAssertEqual([manager count], 0);
    
    OCMStub([mockAsset localIdentifier]).andReturn(@"hello2");
    [mockManager addSelectedAsset:mockAsset];
    BOOL contain = [mockManager containsAsset:mockAsset];
    XCTAssertTrue(contain);
    
    id mockAsset3 = OCMClassMock([PHAsset class]);
    OCMStub([mockAsset3 localIdentifier]).andReturn(@"hello3");
    [mockManager addSelectedAsset:mockAsset3];
    
    id mockAsset4 = OCMClassMock([PHAsset class]);
    OCMStub([mockAsset4 localIdentifier]).andReturn(@"hello4");
    [mockManager addSelectedAsset:mockAsset4];
    
    XCTAssertEqual([manager count], 3);
    
    NSArray *selectedAssets = [manager selectedAssets];
    XCTAssertEqual(selectedAssets.count, 3);
    
    [manager removeAllAssets];
    XCTAssertEqual([manager count], 0);
}

@end

@implementation PickerDelegate

- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhoto:(PHAsset *)photo {
    self.didSelectPhoto(photo);
}

- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhotos:(NSArray *)photos {
    self.didSelectPhotos(photos);
}

- (void)photosPickerDidCancel:(DLFPhotosPickerViewController *)photosPicker {
    self.didSelectCancel(true);
}

- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController  configureCell:(DLFPhotoCell *)cell indexPath:(NSIndexPath *)indexPath asset:(PHAsset *)asset {
    self.configureCell(cell, indexPath, asset);
}


@end
