//
//  ViewController.m
//  NetworkTesting
//
//  Created by Matthew Mould on 10/12/2016.
//  Copyright © 2016 Matthew Mould. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)button:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = @"Awaiting response";
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)button:(id)sender {
#if UITESTS
    self.label.text = @"uitests";
#elif DEBUG
    self.label.text = @"debug";
#else

    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    if (environment[@"isUITest"]) {
        self.label.text = @"hello";
    }
    else {
        NSURL *url = [NSURL URLWithString:@"https://www.bbc.co.uk"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.label.text =  [NSString stringWithFormat:@"Response code: %ld",(long)[httpResponse statusCode]];
            });
        }];
        
        [dataTask resume];
    }
    #endif
}

@end
