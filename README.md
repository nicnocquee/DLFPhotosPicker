This is a library to select multiple photos in iOS 8 or later using iOS Photos framework. I use this library in my app, [Delightful app](http://getdelightfulapp.com).

Features:
-

- Tap and hold a photo to preview (zoom).
- Pinch out a photo to preview (zoom).
- Drag to select multiple photos quickly. Simply drag to left or right to start selecting multiple photos.
- Works on both landscape and portrait.
- Using iOS 8's UISplitViewController for albums and photos. You can see the split view on iPhone 6 plus landscape.
- Quickly clear all selections.
- Selected photos are retained when changing album.

How to use
-

- Copy all the files in `Source` folder **and** `PhotosPicker.storyboard` inside Base.lproj to your project.
- Present the `DLFPhotosPickerViewController`

		DLFPhotosPickerViewController *picker = [[UIStoryboard storyboardWithName:@"PhotosPicker" bundle:nil] instantiateInitialViewController];
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

- You can check the `SampleViewController` class.
		
Cocoapods
-

Coming soon. As soon as I figure out how to include `PhotosPicker.storyboard` in the pod. Anybody knows how to do this?

Screenshots
-

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