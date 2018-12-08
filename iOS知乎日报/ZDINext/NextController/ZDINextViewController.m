//
//  ZDINextViewController.m
//  iOS知乎日报
//
//  Created by 涂强尧 on 2018/11/18.
//  Copyright © 2018 涂强尧. All rights reserved.
//

#import "ZDINextViewController.h"
#import "ZDINextManger.h"
#import "ZDINextView.h"
#import <Masonry.h>
#import "ZDICommentsViewController.h"

@interface ZDINextViewController ()
@property(nonatomic, assign) BOOL isLoading;
@end

@implementation ZDINextViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[WKWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50));
    }];
    NSString *urlString = [NSString stringWithFormat:@"https://daily.zhihu.com/story/%@", _idNumber];
    NSURL *url = [NSURL URLWithString:urlString];
    _webView.scrollView.delegate = self;
    [self->_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    _nextView = [[ZDINextView alloc] init];
    [self.view addSubview:_nextView];
    [_nextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50.0));
    }];
    [_nextView nextViewInit];
    
    [_nextView.backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [_nextView.xiangxiaButton addTarget:self action:@selector(clickXiangxiaButton:) forControlEvents:UIControlEventTouchUpInside];
    [_nextView.dianzanButton addTarget:self action:@selector(clickDianzanButton:) forControlEvents:UIControlEventTouchUpInside];
    [_nextView.fenxiangButton addTarget:self action:@selector(clickFenxiangButton:) forControlEvents:UIControlEventTouchUpInside];
    [_nextView.pinglunButton addTarget:self action:@selector(clickPinglunButton:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
  
}

- (void)clickBackButton:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickXiangxiaButton:(UIButton *)button {
    _row++;
    NSArray *array = [NSMutableArray arrayWithArray:_allIdnumberMutableArray[_section]];
    if (_row > [array count] - 1) {
        _row = 0;
        _section++;
    }
    NSString *urlString = [NSString stringWithFormat:@"https://daily.zhihu.com/story/%@", _allIdnumberMutableArray[_section][_row]];
    NSURL *url = [NSURL URLWithString:urlString];
    [self->_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)clickDianzanButton:(UIButton *)button {
    
}

- (void)clickFenxiangButton:(UIButton *)button {
    
}

- (void)clickPinglunButton:(UIButton *)button {
    ZDICommentsViewController *nextView = [[ZDICommentsViewController alloc] init];
    NSString *idNumberString = [[NSString alloc] init];
    idNumberString = _allIdnumberMutableArray[_section][_row];
    nextView.idNumber = idNumberString;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nextView];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + [UIScreen mainScreen].bounds.size.height - 50 > scrollView.contentSize.height && scrollView.contentSize.height != 0 ) {
        if (self.isLoading) {
            return;
        } else {
            [self updateWkWebView];
        }
    }
}

- (void)updateWkWebView {
    self.isLoading = YES;
    _row++;
    NSArray *array = [NSMutableArray arrayWithArray:_allIdnumberMutableArray[_section]];
    if (_row > [array count] - 1) {
        _row = 0;
        _section++;
    }
    NSString *urlString = [NSString stringWithFormat:@"https://daily.zhihu.com/story/%@", _allIdnumberMutableArray[_section][_row]];
    NSURL *url = [NSURL URLWithString:urlString];
    [self->_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self->_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (self.webView.estimatedProgress == 1) {
        self.isLoading = NO;
    }
}
@end
