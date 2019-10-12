//
//  ViewController.m
//  TestDemo
//
//  Created by gaochongyang on 2019/10/12.
//  Copyright © 2019 gaochongyang. All rights reserved.
//

#import "ViewController.h"
#import "ScanTestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-120)/2, ([[UIScreen mainScreen] bounds].size.height-60)/2, 120, 60)];
    [btn setTitle:@"扫码" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}


- (void)onClick:(id)sender
{
    ScanTestViewController *vc = [[ScanTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
