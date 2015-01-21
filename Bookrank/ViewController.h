//
//  ViewController.h
//  Bookrank
//
//  Created by Anas Ahmad Faris on 2015-01-18.
//  Copyright (c) 2015 Anas Ahmad Faris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UILabel *bookTitle;
@property (strong, nonatomic) IBOutlet UILabel *ratingByN;
@property (strong, nonatomic) IBOutlet UILabel *bookAuthors;
@property (strong, nonatomic) IBOutlet UILabel *bookrank;

@property (strong, nonatomic) IBOutlet UILabel *five;
@property (strong, nonatomic) IBOutlet UILabel *four;
@property (strong, nonatomic) IBOutlet UILabel *three;
@property (strong, nonatomic) IBOutlet UILabel *two;
@property (strong, nonatomic) IBOutlet UILabel *one;
@property (strong, nonatomic) IBOutlet UIImageView *bookImg;

@end

