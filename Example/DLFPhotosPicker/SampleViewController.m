//
//  SampleViewController.m
//  PhotosPicker
//
//  Created by  on 11/28/14.
//  Copyright (c) 2014 Delightful. All rights reserved.
//

#import "SampleViewController.h"
#import "DLFPhotosPickerViewController.h"
#import "DLFPhotoCell.h"

#define OVERLAY_VIEW_TAG 121212121

@interface SampleViewController () <DLFPhotosPickerViewControllerDelegate>
@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapPickPhotos:(id)sender {
    DLFPhotosPickerViewController *photosPicker = [[DLFPhotosPickerViewController alloc] init]; 
    [photosPicker setPhotosPickerDelegate:self];
    [photosPicker setMultipleSelections:self.selectionTypeSelector.selectedSegmentIndex==1];
    [self presentViewController:photosPicker animated:YES completion:nil];
}

- (void)addImagesToScrollView:(NSArray<PHAsset*> *)images {
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGSize imageViewSize = CGSizeMake(self.scrollView.frame.size.height, self.scrollView.frame.size.height);
    CGRect previousRect = CGRectMake(-imageViewSize.width, 0, imageViewSize.width, imageViewSize.height);
    CGFloat maxX = 0;
    for (PHAsset *asset in images) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectOffset(previousRect, imageViewSize.width + 10, 0);
        [self.scrollView addSubview:imageView];
        previousRect = imageView.frame;
        maxX = CGRectGetMaxX(imageView.frame);
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageViewSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            [imageView setImage:result];
        }];
    }
    [self.scrollView setContentSize:CGSizeMake(maxX, imageViewSize.height)];
}

#pragma mark - DLFPhotosPickerViewControllerDelegate

- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhoto:(PHAsset *)photo {
    [photosPicker dismissViewControllerAnimated:YES completion:^{
        [self addImagesToScrollView:@[photo]];
    }];
}

- (void)photosPickerDidCancel:(DLFPhotosPickerViewController *)photosPicker {
    [photosPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhotos:(NSArray *)photos {
    NSLog(@"selected %d photos", (int)photos.count);
    [photosPicker dismissViewControllerAnimated:YES completion:^{
        [self addImagesToScrollView:photos];
    }];
    
}

- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController configureCell:(DLFPhotoCell *)cell indexPath:(NSIndexPath *)indexPath asset:(PHAsset *)asset {
    UIView *overlayView = [cell.contentView viewWithTag:OVERLAY_VIEW_TAG];
    if (indexPath.item%2 == 0) {
        if (!overlayView) {
            overlayView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
            [overlayView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [overlayView setTag:OVERLAY_VIEW_TAG];
            [overlayView setBackgroundColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.300]];
            [cell.contentView addSubview:overlayView];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:overlayView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:overlayView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:overlayView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:overlayView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        }
        [overlayView setHidden:NO];
    } else {
        [overlayView setHidden:YES];
    }
}

@end
