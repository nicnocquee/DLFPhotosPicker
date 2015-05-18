This is a library to select single photo or multiple photos in iOS 8 or later using iOS Photos framework. I use this library in my app, [Delightful app](http://getdelightfulapp.com).

Features:
--

- Tap and hold a photo to preview (zoom).
- Pinch out a photo to preview (zoom).
- Drag to select multiple photos quickly. Simply drag to left or right to start selecting multiple photos.
- Works on both landscape and portrait.
- Using iOS 8's UISplitViewController for albums and photos. You can see the split view on iPhone 6 plus landscape.
- Quickly clear all selections.
- Selected photos are retained when changing album.

How to use
--

- Use Cocoapods: `pod 'DLFPhotosPicker'` or copy all the files in `Source` folder to your project.
- Present the `DLFPhotosPickerViewController`

		DLFPhotosPickerViewController *picker = [[DLFPhotosPickerViewController alloc] init];
    	[picker setPhotosPickerDelegate:self];
    	[self presentViewController:picker animated:YES completion:nil];

- Implement the delegate methods

		#pragma mark - DLFPhotosPickerViewControllerDelegate

		- (void)photosPickerDidCancel:(DLFPhotosPickerViewController *)photosPicker {
    		[photosPicker dismissViewControllerAnimated:YES completion:nil];
		}

		- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhotos:(NSArray *)photos {
    		NSLog(@"selected %d photos", photos.count);
    		[photosPicker dismissViewControllerAnimated:YES completion:nil];
		}

		- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController configureCell:(DLFPhotoCell *)cell indexPath:(NSIndexPath *)indexPath asset:(PHAsset *)asset {
		        // customize the cell based on index path and asset. For example, to mark if the asset has been uploaded.
		    }

		- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhoto:(PHAsset *)photo {
	    [photosPicker dismissViewControllerAnimated:YES completion:^{
	        [[PHImageManager defaultManager] requestImageForAsset:photo targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
	            NSLog(@"Selected one asset");

	        }];
	    }];
		}

- You can check the `SampleViewController` class.

Properties
--

`multipleSelections`. Default: YES. Set this to NO to only select one photo. When this property is set to NO, delegate's `photosPicker:detailViewController:didSelectPhoto:` will be called. Implement that method to handle selected asset, then dismiss the photos picker.

Screenshots
--

![](https://github.com/nicnocquee/DLFPhotosPicker/raw/master/screenshots/screenshot1.png)

![](https://github.com/nicnocquee/DLFPhotosPicker/raw/master/screenshots/screenshot2.png)

![](https://raw.githubusercontent.com/nicnocquee/DLFPhotosPicker/master/screenshots/screenshot3.png)

![](https://github.com/nicnocquee/DLFPhotosPicker/raw/master/screenshots/screenshot4.png)

Author
--
Nico Prananta [@nicnocquee](http://twitter.com/nicnocquee)

If you use this library in your app, let me know :)

License
-

MIT.
