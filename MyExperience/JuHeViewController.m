//
//  JuHeViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/26.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "JuHeViewController.h"

@interface JuHeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *DataTableView;

@end

@implementation JuHeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

@end
