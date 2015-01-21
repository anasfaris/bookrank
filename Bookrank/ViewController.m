//
//  ViewController.m
//  Bookrank
//
//  Created by Anas Ahmad Faris on 2015-01-18.
//  Copyright (c) 2015 Anas Ahmad Faris. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperation.h"
#import "XMLDictionary.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Add tap to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    self.titleTextField.delegate = self;
    
    // Bring button on top of table view
    [self.view bringSubviewToFront:self.titleTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.titleTextField resignFirstResponder];
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    self.titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    
    //Next button was pressed
    //Push some viewcontroller here
    NSString *inputTitle = self.titleTextField.text;
    inputTitle = [inputTitle stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    NSString *urlString = [NSString stringWithFormat:@"https://www.goodreads.com/book/title.xml?key=kBazth7oKanhPg34zY7Dyg&title=%@", inputTitle];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:result];
    NSLog(@"%@",xmlDoc);
    
    NSString *title = [xmlDoc valueForKeyPath:@"book.title"];
    NSString *avgRating = [xmlDoc valueForKeyPath:@"book.average_rating"];
    NSString *nReaders = [xmlDoc valueForKeyPath:@"book.ratings_count"];
    NSString *ratingByNString = [NSString stringWithFormat:@"%@ by %@ readers", avgRating, nReaders];
    NSString *authorString;
    
    if ([[xmlDoc valueForKeyPath:@"book.authors.author.name"] isKindOfClass:[NSArray class]]) {
        NSArray *authors = [xmlDoc valueForKeyPath:@"book.authors.author.name"];
        authorString = @"";
        
        for (id author in authors) {
            if (![authorString  isEqual: @""])
                authorString = [NSString stringWithFormat:@"%@, %@", authorString, author];
            else
                authorString = author;
        }
    } else {
        authorString = [xmlDoc valueForKeyPath:@"book.authors.author.name"];
    }
    
    NSLog(@"Title: %@", title);
    NSLog(@"Average Rating: %@ by %@ readers", avgRating, nReaders);
    NSLog(@"Authors: %@", authorString);
    
    self.bookTitle.text = title;
    self.ratingByN.text = ratingByNString;
    self.bookAuthors.text = authorString;
    
    NSString *allRating = [xmlDoc valueForKeyPath:@"book.work.rating_dist"];
    NSLog(@"%@", allRating);
    NSArray *listItems = [allRating componentsSeparatedByString:@"|"];
    NSLog(@"listItems: %@", listItems);
    
    double s1 = 0.0, s2 = 0.0, s3 = 0.0, s4 = 0.0, s5 = 0.0;
    for (id e in listItems) {
        NSArray *d = [e componentsSeparatedByString:@":"];
        if ([d[0] isEqualToString:@"1"]) s1 = [d[1] doubleValue];
        else if ([d[0] isEqualToString:@"2"]) s2 = [d[1] doubleValue];
        else if ([d[0] isEqualToString:@"3"]) s3 = [d[1] doubleValue];
        else if ([d[0] isEqualToString:@"4"]) s4 = [d[1] doubleValue];
        else if ([d[0] isEqualToString:@"5"]) s5 = [d[1] doubleValue];
    }
    
    self.five.text = [NSString stringWithFormat:@"5 | %.0f", s5];
    self.four.text = [NSString stringWithFormat:@"4 | %.0f", s4];
    self.three.text = [NSString stringWithFormat:@"3 | %.0f", s3];
    self.two.text = [NSString stringWithFormat:@"2 | %.0f", s2];
    self.one.text = [NSString stringWithFormat:@"1 | %.0f", s1];

    NSString *bookImgPath = [xmlDoc valueForKeyPath:@"book.image_url"];
    NSURL *url = [[NSURL alloc] initWithString:bookImgPath];
    NSData *imgData = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:imgData];
    [self.bookImg setImage:img];
    
    double bookrankFloat = [self getBookRank:nReaders];
    NSString *bookrankString = [NSString stringWithFormat:@"Bookrank: %.2f", bookrankFloat];
    self.bookrank.text = bookrankString;
    
//    [self.titleTextField selectAll:nil];
    
    return YES;
}

-(double)getBookRank:(NSString *)nReaders {
    double readerScore = 0.0;
//    double ratingScore = 0.0;
    double numberOfReaders = [nReaders doubleValue];
    
    if (numberOfReaders < 10) readerScore = 0.75;
    else if (numberOfReaders < 100) readerScore = 1.00;
    else if (numberOfReaders < 1000) readerScore = 1.01;
    else if (numberOfReaders < 10000) readerScore = 1.02;
    else if (numberOfReaders < 100000) readerScore = 1.03;
    else if (numberOfReaders < 1000000) readerScore = 1.04;
    else readerScore = 1.05;
    
    return readerScore;
}

@end
