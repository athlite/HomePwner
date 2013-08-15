//
//  DetailViewController.m
//  HomePwner
//
//  Created by Thomas Eng on 14.05.13.
//  Copyright (c) 2013 Thomas Eng. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];

    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
    NSString *imageKey = [item imageKey];
    if(imageKey) {
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        [imageView setImage:imageToDisplay];
    } else {
        [imageView setImage:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
    
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)setItem:(BNRItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.allowsEditing = YES;
    
    // If your device has a camera, we want to take a picture, otherwise, we just pick from photo library.
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    // Warning, ignore
    [imagePicker setDelegate:self];
    
    // place picker on screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction)clearImage:(id)sender {
    [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
    [imageView setImage:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSLog(@"%@", info);
    
    NSString *oldKey = [item imageKey];
    if(oldKey) {
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    //Put it on the screen in image view
    [imageView setImage:image];
    
    // UUID object
    CFUUIDRef newUniqID = CFUUIDCreate(kCFAllocatorDefault);
    
    CFStringRef newUniqIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqID);
    NSString *key = (__bridge NSString*)newUniqIDString;

    [item setImageKey:key];
    [[BNRImageStore sharedStore] setImage:image forKey: [item imageKey]];
    
    CFRelease(newUniqIDString);
    CFRelease(newUniqID);
    
    // Take image picker off the screen -
    // you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
