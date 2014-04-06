//
//  TDDemoViewController.m
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import "TDDemoViewController.h"

//  Libs
#import "TDImageColors.h"

//  ViewControllers
#import "PaletteViewController.h"

@interface TDDemoViewController ()
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture;
@end

@implementation TDDemoViewController

#pragma mark - Private

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture{
    [self performSegueWithIdentifier:@"paletteSegue" sender:self];
}

#pragma mark - Public

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_imageView addGestureRecognizer:tapRecognizer];
    _imageView.userInteractionEnabled = YES;
}

- (IBAction)chooseImageButtonPressed:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"paletteSegue"]){
        PaletteViewController *vc = segue.destinationViewController;
        vc.colors = _colors;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
        TDImageColors *imageColors = [[TDImageColors alloc] initWithImage:image count:64 threshold:0.25f];
        dispatch_group_leave(group);
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSInteger i=0;
            while (i < 5 && i < [imageColors.colors count]){
                UIColor *color = imageColors.colors[i];
                NSUInteger idx = [imageColors.colors indexOfObject:color];
                [_colorViews[idx] setBackgroundColor:color];
                i++;
            }
            
            _colors = imageColors.colors;
        });
    }];
}

@end
