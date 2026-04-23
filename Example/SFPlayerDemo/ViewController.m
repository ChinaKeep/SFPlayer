//
//  ViewController.m
//  SFPlayerDemo
//

#import "ViewController.h"
#import <MJExtension/MJExtension.h>
#import <SFPlayer/SFPlayer.h>
#import <SFPlayer/SFVideoCell.h>
#import <SFPlayer/SFVideoModel.h>

#define videoListUrl @"https://c.3g.163.com/nc/video/home/0-10.html"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) SFPlayer *player;

@end

@implementation ViewController

- (NSString *)sf_secureURLString:(NSString *)urlString {
    if (urlString.length == 0) {
        return @"";
    }
    if ([urlString hasPrefix:@"http://"]) {
        return [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }
    return urlString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"视频列表";

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 200.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"SFVideoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SFVideoCell"];
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];

    NSURL *url = [NSURL URLWithString:videoListUrl];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !data) {
            return;
        }
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *videoList = [responseObject isKindOfClass:[NSDictionary class]] ? responseObject[@"videoList"] : nil;
        if (![videoList isKindOfClass:[NSArray class]]) {
            return;
        }
        for (NSDictionary *dict in videoList) {
            [self.videoArray addObject:[SFVideoModel mj_objectWithKeyValues:dict]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [task resume];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0f;
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
    cell.videoImageView.userInteractionEnabled = YES;
    for (UIGestureRecognizer *recognizer in cell.videoImageView.gestureRecognizers.copy) {
        [cell.videoImageView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
    [cell.videoImageView addGestureRecognizer:tap];
    cell.videoImageView.tag = indexPath.row + 100;
    return cell;
}

- (void)showVideoPlayer:(UIGestureRecognizer *)tapGesture {
    [self.player destructPlayer];
    self.player = nil;

    SFVideoModel *videoModel = self.videoArray[tapGesture.view.tag - 100];
    NSString *playURL = videoModel.mp4_url.length > 0 ? videoModel.mp4_url : videoModel.m3u8Hd_url;
    playURL = [self sf_secureURLString:playURL];
    if (playURL.length == 0) {
        return;
    }
    SFVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tapGesture.view.tag - 100 inSection:0]];
    self.player = [[SFPlayer alloc] init];
    self.player.videoURL = playURL;
    self.player.frame = tapGesture.view.bounds;
    self.player.superTableView = self.tableView;
    self.player.currentIndexPath = [NSIndexPath indexPathForRow:tapGesture.view.tag - 100 inSection:0];
    [cell.contentView addSubview:self.player];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        [self.player playingVideoWithSamllWindow:YES];
    }
}

- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

@end
