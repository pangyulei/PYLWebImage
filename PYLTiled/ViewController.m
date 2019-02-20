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
#import <pthread.h>
#import "PYLImageDownloader.h"
#import "PYLImageDownloader.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) UITableView *tb;
@property (nonatomic) NSMutableArray *models;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    return [self fetchAvatarUrls];
    
    
    _tb = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_tb];
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [_tb registerClass:[CardCell class] forCellReuseIdentifier:@"cc"];
    _models = @[].mutableCopy;
//    PYLFPSLabel *label = [[PYLFPSLabel alloc] initWithFrame:CGRectMake(130, 10, 0, 0)];
//    [self.view addSubview:label];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"avatar_urls" ofType:@""];
        NSData *d = [NSData dataWithContentsOfFile:path];
        NSArray *urls = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableLeaves error:nil];
        NSAssert(urls.count, @"url 解析失败");
        for (int i = 0;i<urls.count;i++) {
            CardModel *c = [CardModel new];
            NSString *url = urls[i];
            c.url = [NSURL URLWithString:url];
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

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
//    NSArray *indexPaths = [tableView indexPathsForVisibleRows];
//    NSIndexPath *first = indexPaths.firstObject;
//    NSIndexPath *last = indexPaths.lastObject;
//
//    //预加载前后5个
//    CardModel *model = _models[indexPath.item];
//    [[PYLImageDownloader shared] cancelDownloadImageURL:model.url];
}

//- (void)fetchAvatarUrls {
//    dispatch_semaphore_t download_sema = dispatch_semaphore_create(10); //同时下载 N 个
//    pthread_mutex_t lock;
//    pthread_mutex_init(&lock, NULL);
//
//    double c = 10000;
//    NSMutableDictionary *urls = @{}.mutableCopy;
//    NSURLSessionConfiguration * conf = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf];
//    while (urls.count < c) {
//        dispatch_semaphore_wait(download_sema, DISPATCH_TIME_FOREVER);
//        [[session dataTaskWithURL:[NSURL URLWithString:@"https://source.unsplash.com/random/80x80"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            dispatch_semaphore_signal(download_sema);
//
//            NSString *str = response.URL.absoluteString;
//            if (!str.length || error) {
//                NSLog(@"download error: %@", error);
//
//            } else if (urls[str]) {
//                //重复的不算
//            } else {
//                pthread_mutex_lock(&lock);
//                if (urls.count < c) {
//                    urls[str] = @"";
//                    NSLog(@"%ld %@", urls.count, str);
//                }
//                pthread_mutex_unlock(&lock);
//            }
//
//        }] resume];
//    }
//    pthread_mutex_destroy(&lock);
//
//    NSMutableArray *a = @[].mutableCopy;
//    for (int i = 0;i<urls.allKeys.count;i++) {
//        [a addObject:urls.allKeys[i]];
//    }
//
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *filePath = [documentPath stringByAppendingPathComponent:@"avatar_urls"];
//    NSLog(@"%@", filePath);
//    NSError *e;
//    NSData *data = [NSJSONSerialization dataWithJSONObject:a options:NSJSONWritingPrettyPrinted error:&e];
//    NSAssert(!e, @" json -> data 失败");
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        BOOL r = [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
//        NSAssert(r, @"写硬盘失败");
//    } else {
//        [data writeToFile:filePath options:NSDataWritingAtomic error:&e];
//        NSAssert(!e, @"写硬盘失败");
//    }
//    NSLog(@"写硬盘成功");
//}

@end
