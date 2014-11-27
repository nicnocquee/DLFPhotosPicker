//
//  PhotosSelectionManager.m
//  PhotosPicker
//
//  Created by  on 11/27/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import "DLFPhotosSelectionManager.h"

#define SELECTED_PHOTOS_VIEW_HEIGHT 84

NSString *assetKey = @"assetKey";
NSString *indexPathKey = @"indexPathKey";

@interface DLFPhotosSelectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@interface DLFPhotosSelectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *numberOfPhotosLabel;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UIButton *clearSelectionButton;

- (void)addAssetWithIndexPath:(NSDictionary *)assetWithIndexPath;

- (void)removeAssetWithIndexPath:(NSIndexPath *)indexPath;

- (void)removeAllAssets;

@end

@interface DLFPhotosSelectionManager ()

@property (nonatomic, strong) DLFPhotosSelectionView *selectedPhotosView;

@property (nonatomic, strong) NSMutableDictionary *items;

@end

@implementation DLFPhotosSelectionManager

- (id)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        self.selectedPhotosView = [[DLFPhotosSelectionView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - SELECTED_PHOTOS_VIEW_HEIGHT, view.frame.size.width, SELECTED_PHOTOS_VIEW_HEIGHT)];
        [self.selectedPhotosView setHidden:YES];
        [view addSubview:self.selectedPhotosView];
        [self.selectedPhotosView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        
        self.items = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addSelectedImage:(UIImage *)asset atIndexPath:(NSIndexPath *)indexPath {
    [self.items setObject:asset forKey:indexPath];
    [self.selectedPhotosView addAssetWithIndexPath:@{assetKey:asset, indexPathKey:indexPath}];
    
    [self.selectedPhotosView setHidden:NO];
}

- (void)removeAssetAtIndexPath:(NSIndexPath *)indexPath {
    [self.items removeObjectForKey:indexPath];
    [self.selectedPhotosView removeAssetWithIndexPath:indexPath];
    
    if (self.items.count == 0) {
        [self.selectedPhotosView setHidden:YES];
    }
}

- (void)removeAllAssets {
    [self.items removeAllObjects];
    [self.selectedPhotosView removeAllAssets];
    [UIView animateWithDuration:0.3 animations:^{
        [self.selectedPhotosView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.selectedPhotosView setHidden:YES];
        [self.selectedPhotosView setAlpha:1];
    }];
    
}

@end

@implementation DLFPhotosSelectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clearSelectionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.clearSelectionButton setTitle:NSLocalizedString(@"Clear", nil) forState:UIControlStateNormal];
        [self.clearSelectionButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.clearSelectionButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.clearSelectionButton setBackgroundColor:[UIColor clearColor]];
        [self.clearSelectionButton sizeToFit];
        [self addSubview:self.clearSelectionButton];
        self.clearSelectionButton.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        self.clearSelectionButton.frame = ({
            CGRect selectionFrame = self.clearSelectionButton.frame;
            selectionFrame.origin.x = frame.size.width - CGRectGetWidth(selectionFrame) - 10;
            selectionFrame;
        });
        [self.clearSelectionButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width - CGRectGetWidth(self.clearSelectionButton.frame) - 20, frame.size.height-20) collectionViewLayout:layout];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView setAlwaysBounceHorizontal:YES];
        [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self.collectionView setContentInset:UIEdgeInsetsMake(0, 10, 10, 10)];
        [self.collectionView registerClass:[DLFPhotosSelectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self addSubview:self.collectionView];
        
        self.numberOfPhotosLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.collectionView.frame.size.height)];
        [self addSubview:self.numberOfPhotosLabel];
        [self.numberOfPhotosLabel setTextColor:[UIColor whiteColor]];
        [self.numberOfPhotosLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
        [self.numberOfPhotosLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [self.numberOfPhotosLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
        
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)addAssetWithIndexPath:(NSDictionary *)assetWithIndexPath {
    NSInteger index = [self.items indexOfObjectPassingTest:^BOOL(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if (obj[indexPathKey] == assetWithIndexPath[indexPathKey]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if (index == NSNotFound) {
        [self.items addObject:assetWithIndexPath];
        NSIndexPath *ind = [NSIndexPath indexPathForItem:self.items.count-1 inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[ind]];
        
        [self setNumberOfPhotosText];
    }
}

- (void)removeAssetWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self.items indexOfObjectPassingTest:^BOOL(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if (obj[indexPathKey] == indexPath) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if (index != NSNotFound) {
        [self.items removeObjectAtIndex:index];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
        [self setNumberOfPhotosText];
    }
}

- (void)removeAllAssets {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i<self.items.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    [self.items removeAllObjects];
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
}

- (void)setNumberOfPhotosText {
    self.numberOfPhotosLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%1$d %2$@ selected", nil), (int)self.items.count, (self.items.count==1)?NSLocalizedString(@"photo", nil):NSLocalizedString(@"photos", nil)];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DLFPhotosSelectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImage *asset = [[self.items objectAtIndex:indexPath.item] objectForKey:assetKey];
    
    [cell.imageView setImage:asset];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.frame.size.height-10;
    return CGSizeMake(width, width);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

@end

@implementation DLFPhotosSelectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.imageView];
        [self.imageView.layer setMasksToBounds:YES];
    }
    return self;
}

@end
