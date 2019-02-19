//
//  ViewController.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/18.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "ViewController.h"
#import "CardCell.h"
#import "PYLFPSLabel.h"
#import "CardModel.h"
#import "CardCellLayout.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) UITableView *tb;
@property (nonatomic) NSMutableArray *models;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tb = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_tb];
    _tb.delegate = self;
    _tb.dataSource = self;
    [_tb registerClass:[CardCell class] forCellReuseIdentifier:@"cc"];
    _models = @[].mutableCopy;
    PYLFPSLabel *label = [[PYLFPSLabel alloc] initWithFrame:CGRectMake(16, 100, 0, 0)];
    [self.view addSubview:label];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0;i<10000;i++) {
            CardModel *c = [CardModel new];
            [c layout];
            [self.models addObject:c];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tb reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cc"];
    [cell configWithModel:_models[indexPath.item]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardModel *model = _models[indexPath.item];
    return model.layout.cellHeight;
}

@end
