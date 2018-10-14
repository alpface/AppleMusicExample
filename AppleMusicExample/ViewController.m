//
//  ViewController.m
//  AppleMusicExample
//
//  Created by xiaoyuan on 2018/10/18.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "ViewController.h"
#import "XYMusicListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClick:(id)sender {
    
    XYMusicListViewController *vc = [XYMusicListViewController sharedInstance];
    UINavigationController *nac = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nac animated:YES completion:nil];
}

@end
