//
//  RichContentViewController.m
//  SimpleSample Messages
//
//  Created by Ruslan on 9/6/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "RichContentViewController.h"

@interface RichContentViewController () <QBActionStatusDelegate> {
    int imageNumber;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *downloadProgress;

- (IBAction)back:(id)sender;

@end

@implementation RichContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageNumber = 0;
    
    // Download rich content
    for(NSString *fileID in self.message.richContentFilesIDs) {
        [self.downloadProgress startAnimating];
        [QBContent TDownloadFileWithBlobID:[fileID intValue] delegate:self];
    }
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setDownloadProgress:nil];
    [super viewDidUnload];
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result*)result {
            
    // Download rich content result
    if ([result isKindOfClass:[QBCFileDownloadTaskResult class]]) {
        QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
        
        // Success result
        if (res.success) {

            // show image
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageNumber * 420, 320, 420)];
            [imageView setBackgroundColor:[UIColor clearColor]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageWithData:res.file];
             
            [self.scrollView setContentSize:CGSizeMake(320, 420 * (imageNumber + 1))];
            [self.scrollView addSubview:imageView];           
            
            ++imageNumber;
            
            if (imageNumber == [self.message.richContentFilesIDs count]) {
                [self.downloadProgress stopAnimating];
            }
        }
    }
}

@end
