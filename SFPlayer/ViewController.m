//
//  ViewController.m
//  SFPlayer
//
//  Created by apple on 2020/7/31.
//  Copyright © 2020 随风流年. All rights reserved.
//

#import "ViewController.h"
#import "SFSlider.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "SFVideoModel.h"
#import "SFVideoCell.h"
#import "SFPlayer.h"

#define videoListUrl @"http://c.3g.163.com/nc/video/home/0-10.html"


@interface ViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong)           UITableView         *tableView;
@property (nonatomic, strong)           NSMutableArray      *videoArray;
@property (nonatomic, strong)           SFPlayer            *player;
@property (nonatomic, assign)           NSInteger           currentIndexPath;
@property (nonatomic, assign)           CGRect              currentPlayCellRect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
    self.navigationItem.title = @"视频列表";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SFVideoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SFVideoCell"];
    self.tableView.estimatedRowHeight = 200;
    [self.view addSubview:self.tableView];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:videoListUrl parameters:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary *dict in responseObject[@"videoList"]) {
            [self.videoArray addObject:[SFVideoModel mj_objectWithKeyValues:dict]];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFVideoCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SFVideoCell" owner:self options:nil].lastObject;
    }
    SFVideoModel *model = self.videoArray[indexPath.row];
    cell.videoModel = model;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
    [cell.videoImageView addGestureRecognizer:tap];
    cell.videoImageView.tag = indexPath.row + 100;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    XLVideoItem *item = self.videoArray[indexPath.row];
//    VideoDetailViewController *videoDetailViewController = [[VideoDetailViewController alloc] init];
//    videoDetailViewController.videoTitle = item.title;
//    videoDetailViewController.mp4_url = item.mp4_url;
//    [self.navigationController pushViewController:videoDetailViewController animated:YES];
}
- (void)showVideoPlayer:(UIGestureRecognizer *)tapGesture{
    [self.player destructPlayer];
    self.player = nil;
    
    SFVideoModel *videoModel = self.videoArray[tapGesture.view.tag - 100];
    SFVideoCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tapGesture.view.tag - 100 inSection:0]];
    self.player = [[SFPlayer alloc]init];
    self.player.videoURL = videoModel.mp4_url;
    self.player.frame = tapGesture.view.bounds;
    [cell.contentView addSubview:self.player];
    
}
- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

@end
