//
//  TBCitySBTableViewController.m
//  iCoupon
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBTableViewController.h"
#import "TBCitySBTableViewDataSource.h"
#import "TBCitySBTableViewDelegate.h"
#import "TBCitySBTableViewCell.h"
#import "TBCitySBTableViewItem.h"
#import "TBCitySBCustomizedTableViewItem.h"
#import "TBCitySBListModel.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "TBCitySBListModel.h"
#import "TBCitySBTableViewFactory.h"




@interface TBCitySBTableViewController ()
{
    NSInteger _loadMoreSection;
    
}
/**
 *  不同状态的footerview
 */
@property(nonatomic,strong) UIView* footerViewNoResult;
@property(nonatomic,strong) UIView* footerViewLoading;
@property(nonatomic,strong) UIView* footerViewComplete;
@property(nonatomic,strong) UIView* footerViewEmpty;
@property(nonatomic,strong) UIView* footerViewError;

@end

@implementation TBCitySBTableViewController

@synthesize dataSource = _dataSource;
@synthesize delegate   = _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setters

- (void)setDataSource:(TBCitySBTableViewDataSource*)dataSource
{
    _dataSource = dataSource;
    _dataSource.controller = self;
    self.tableView.dataSource = dataSource;
}

- (void)setDelegate:(TBCitySBTableViewDelegate*)delegate
{
    _delegate = delegate;
    _delegate.controller = self;
    self.tableView.delegate = delegate;
}


- (void)setKeyModel:(TBCitySBListModel *)keyModel
{
    _keyModel = keyModel;
    _loadMoreSection = keyModel.sectionNumber;
}

- (void)setBNeedPullRefresh:(BOOL)bNeedPullRefresh
{
    _bNeedPullRefresh = bNeedPullRefresh;
    
    if (bNeedPullRefresh) {
        
        self.tableView.dataSource = self.dataSource;
        self.tableView.delegate   = self.delegate;
        __weak typeof(self) weakSelf = self;
        [self.tableView addPullToRefreshWithActionHandler:^{
            [weakSelf reload];
        }];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - getters

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.opaque  = YES;
        _tableView.separatorStyle = NO;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
        
    }
    return _tableView;
}


- (TBCitySBTableViewDataSource* )dataSource
{
    if(!_dataSource)
        _dataSource = [[TBCitySBTableViewDataSource alloc]init];
    
    return _dataSource;
}

- (TBCitySBTableViewDelegate* )delegate
{
    if(!_delegate)
        _delegate = [[TBCitySBTableViewDelegate alloc]init];

    return _delegate;
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
    
        self = [self init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
        _clearItemsWhenModelReload = YES;
        _loadmoreAutomatically = YES;
        _bNeedPullRefresh      = NO;
        _bNeedLoadMore         = NO;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.footerViewNoResult = [TBCitySBTableViewFactory getNormalFooterView:CGRectMake(0, 0, self.view.frame.size.width, 44) Text:@"没有结果"];
    self.footerViewLoading = [TBCitySBTableViewFactory getLoadingFooterView:CGRectMake(0, 0, self.view.frame.size.width, 44) Text:@"努力加载中..."];
    self.footerViewError   = [TBCitySBTableViewFactory getErrorFooterView:CGRectMake(0, 0, self.view.frame.size.width, 44) Text:@"加载失败"];
    self.footerViewEmpty   = [TBCitySBTableViewFactory getNormalFooterView:CGRectMake(0, 0, self.view.frame.size.width, 1) Text:@""];
    self.footerViewComplete = [TBCitySBTableViewFactory getNormalFooterView:CGRectMake(0, 0, self.view.frame.size.width, 1) Text:@""];
}
- (void)viewDidLoad
{
    [super viewDidLoad];


    [self.view addSubview:self.tableView];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //SBMVC => 1.1 : 低内存问题
#if __should_handle_memory_warning__
    
    if ([self shouldHandleMemoryWarning]) {
        _receiveMemoryWarning = true;
    }
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


////////////////////////////////////////////////////////////////////
#pragma mark - TBCitySBViewController

- (void)load
{
    NSAssert(_keyModel != nil,  @"至少需要指定一个keymodel");
    
#if __should_handle_memory_warning__
    
    // SBMVC => 1.1 : 处理5.0以下memorywarning
    if([self shouldHandleMemoryWarning])
    {
        if (!_receiveMemoryWarning) {
            [super load];
        }
        _receiveMemoryWarning = false;
    }
    else
        _receiveMemoryWarning = false;
#else
    
    [super load]

#endif
    
}

- (void)reload
{
    NSAssert(_keyModel != nil, @"至少需要指定一个keymodel");
    
    if (self.clearItemsWhenModelReload) {
       
        [self.dataSource removeAllItems];
        [self reloadTableView];
    }
    [super reload];
}

- (void)loadMore
{
    if (self.bNeedLoadMore) {
        
        NSAssert(_keyModel != nil, @"至少需要指定一个keymodel");
        
        if ([self.keyModel hasMore]) {
            
            if (self.loadmoreAutomatically) {
                [self.keyModel loadMore];
            }
            else
                [self showLoadMoreFooterView];
            
        }
    }
}

- (void)didLoadModel:(TBCitySBListModel *)model
{
    //SBMVC => 1.1 : 多个model注册同一个section，只有keymodel才能被加载
    NSInteger section = self.keyModel.sectionNumber;
    
    if (model.sectionNumber == section) {
        
        if (model == self.keyModel ) {
            [self.dataSource tableViewControllerDidLoadModel:model ForSection:model.sectionNumber];
        }
        else
        {
            //@discussion:
            //对于非keymodel请求带回来的数据，是否要缓存在datasource中
        }
    }
    else
         [self.dataSource tableViewControllerDidLoadModel:model ForSection:model.sectionNumber];
    
   
}

- (BOOL)canShowModel:(TBCitySBListModel *)model
{
    if (![super canShowModel:model]) {
        return NO;
    }
    
    NSInteger numberOfRows = 0;
    NSInteger numberOfSections = 0;
    
    numberOfSections = [self.dataSource numberOfSectionsInTableView:self.tableView];
    
    if (!numberOfSections) {
        return NO;
    }
    
    numberOfRows = [self.dataSource tableView:self.tableView numberOfRowsInSection:model.sectionNumber];
    
    if (!numberOfRows) {
        return NO;
    }
    else
    {
        //SBMVC => 1.1 : 多个model注册同一个section，只有keymodel才能被show出来
        if (numberOfSections == 1) {
            
            if (model == _keyModel) {
                return YES;
            }
            else
                return NO;
        }
    }
    return YES;
}


- (void)showEmpty:(TBCitySBListModel *)model
{
    SBLog(@"[%@]-->showEmpty:{key:%@,section:%d}",[self class],model.key,model.sectionNumber);
  
    [super showEmpty:model];
    
    [self endRefreshing];
    [self showNoResult:model];
}

//默认loading 样式
- (void)showLoading:(TBCitySBListModel *)model
{
    SBLog(@"[%@]-->showLoading:{key:%@,section:%d}",[self class],model.key,model.sectionNumber);
    
    if (model == _keyModel) {
        
        //SBMVC => 1.1:解决低网速下两个菊花的问题
        if(self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading)
        {
            //SBMVC => 1.1 : 单个section的情况
            if (model.sectionNumber == 0) {
               self.tableView.tableFooterView = self.footerViewEmpty;
            }
            else
                self.tableView.tableFooterView = self.footerViewLoading;
        }
        
        else
            self.tableView.tableFooterView = self.footerViewLoading;
    }
    else
    {
        //SBMVC => 1.1:解决注册了同一个section的不同model的状态的问题
        if (model.sectionNumber != _keyModel.sectionNumber) {
            
            //show loading for seciton
            NSInteger section = model.sectionNumber;
            //创建一个loading item
            TBCitySBTableViewItem* item = [TBCitySBTableViewItem new];
            item.itemType = kItem_Loading;
            item.itemHeight = 44;
            [self.dataSource setItems:@[item] ForSection:section];
            [self reloadTableView];
        }
    
    }
}

- (void)showModel:(TBCitySBListModel *)model
{
    SBLog(@"[%@]-->showModel:{key:%@,section:%d}",[self class],model.key,model.sectionNumber);
    
    [super showModel:model];
    
    //SBMVC => 1.1:
    [self reloadTableView];
    
    //SBMVC => 1.1 : reset footer view
    self.tableView.tableFooterView = self.footerViewComplete;
    
    //SBMVC 1.1 => 处理SVPullRefresh 和 iOS 5.0的bug
    [self endRefreshing];

}

- (void)showError:(NSError *)error withModel:(TBCitySBListModel *)model
{
    SBLog(@"[%@]-->showError:{key:%@,section:%d}",[self class], model.key,model.sectionNumber);
   
    [self endRefreshing];
    
    if (model == _keyModel) {
       
        //SBMVC => 1.1 : 兼容statusHandler
        if (!model.itemList.array.count > 0) {
    
            //SBMVC => 1.1 : 单个section没数据
            if (model.sectionNumber == 0) {
                
                #if __buildForMTOP__
                    self.footerViewError.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.tableView.bounds));
                    self.tableView.tableFooterView = [self.statusHandler showViewforError:error inView:self.footerViewError frame:CGRectMake(0, 0, CGRectGetWidth(self.footerViewError.bounds), CGRectGetHeight(self.footerViewError.bounds))];
                #else
                    self.footerViewError.bounds = CGRectMake(0, 0, CGRectGetWidth(self.footerViewError.bounds), 44);
                    self.tableView.tableFooterView = self.footerViewError;
                #endif
            }
            //SBMVC => 1.1 : 多个section没数据
            else
            {
                self.footerViewError.bounds = CGRectMake(0, 0, CGRectGetWidth(self.footerViewError.bounds), 44);
                self.tableView.tableFooterView = self.footerViewError;
            }
       
        } else {
            
            //SBMVC => 1.1 : 翻页出错的时候底部展示错误内容
            self.footerViewError.bounds = CGRectMake(0, 0, CGRectGetWidth(self.footerViewError.bounds), 44);
            self.tableView.tableFooterView = self.footerViewError;
        }
    }
    else
    {
        //SBMVC => 1.1:解决注册了同一个section的不同model的状态的问题
        if (model.sectionNumber != _keyModel.sectionNumber)
        {
            //show loading for seciton
            NSInteger section = model.sectionNumber;
            //创建一个error item
            TBCitySBCustomizedTableViewItem* item = [TBCitySBCustomizedTableViewItem new];
            item.itemType = kItem_Error;
            item.text = error.localizedDescription;
            item.itemHeight = 44;
            [self.dataSource setItems:@[item] ForSection:section];
            [self reloadTableView];
        }
    }
    
}
////////////////////////////////////////////////////////////////////
#pragma mark - private

- (void)reloadTableView
{
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate   = self.delegate;
    [self.tableView reloadData];

}


////////////////////////////////////////////////////////////////////
#pragma mark - public

/**
 * 加载某个section的model
 */
- (void)loadModelForSection:(NSInteger)section
{
    //load model
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        TBCitySBListModel* model = (TBCitySBListModel*)obj;
        
        if (section == model.sectionNumber) {
            [model load];
        }
    }];
}
/**
 * 重新加载某个section的model
 */
- (void)reloadModelForSection:(NSInteger)section
{
    //load model
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        TBCitySBListModel* model = (TBCitySBListModel*)obj;
        
        if (section == model.sectionNumber) {
            
            [self.dataSource removeItemsForSection:section];
            [self reloadTableView];
            [model reload];
        }
    }];
}
/**
 *  根据model的key来加载model
 *  
 *  SBMVC => 1.1
 *
 *  @param key
 */
- (void)loadModelByKey:(NSString* )targetKey
{
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        TBCitySBListModel* model = (TBCitySBListModel*)obj;
        
        if ([key isEqualToString : targetKey]) {
            [model load];
        }
    }];
}
/**
 *  根据model的key来加载model
 *
 *  SBMVC => 1.1
 *
 *  @param key
 */
- (void)reloadModelByKey:(NSString*)targetKey
{
    [_modelDictInternal enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        TBCitySBListModel* model = (TBCitySBListModel*)obj;
        
        if ([key isEqualToString : targetKey]) {
            
            [self.dataSource removeAllItems];
            [self reloadTableView];
            [model reload];
        }
    }];
}
/**
 * 显示下拉刷新
 */
- (void)beginRefreshing
{
    [self.tableView.pullToRefreshView startAnimating];
}
/**
 * 隐藏下拉刷新
 */
- (void)endRefreshing
{
    [self.tableView.pullToRefreshView stopAnimating];

}

@end

@implementation TBCitySBTableViewController(Subclassing)

- (void)showNoResult:(TBCitySBListModel *)model
{
    SBLog(@"[%@]-->showNoResult:{key:%@,section:%d}",[self class],model.key,model.sectionNumber);
    
    [self endRefreshing];
    
    
    if (model == _keyModel) {
        
        #if __buildForMTOP__
            //SBMVC => 1.1 : 兼容statusHandler
            self.footerViewNoResult.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.tableView.bounds));
            self.tableView.tableFooterView = [self.statusHandler showEmptyViewInView:self.footerViewNoResult frame:CGRectMake(0, 0, CGRectGetWidth(self.footerViewNoResult.bounds), CGRectGetHeight(self.footerViewNoResult.bounds))];
        #else
            self.tableView.tableFooterView = self.footerViewNoResult;
        #endif

    }
    else
    {
        //SBMVC => 1.1:解决注册了同一个section的不同model的状态的问题
        if (model.sectionNumber != _keyModel.sectionNumber) {
            
            NSInteger section = model.sectionNumber;
            //创建一个customized item
            TBCitySBCustomizedTableViewItem* item = [TBCitySBCustomizedTableViewItem new];
            item.itemType = kItem_Customize;
            item.text = @"没有结果";
            item.itemHeight = 44;
            [self.dataSource setItems:@[item] ForSection:section];
            [self reloadTableView];
        }
    }
    
}
- (void)showComplete:(TBCitySBListModel *)model
{
    SBLog(@"[%@]-->showComplete:{section:%d}",[self class],model.sectionNumber);
    
    if (model == _keyModel) {
        self.tableView.tableFooterView =  self.footerViewComplete;
    }
    else
    {
        //todo:
    }
}
- (void)showLoadMoreFooterView
{
    SBLog(@"[%@]-->showLoadMoreFooterView",self.class);
    
    if (self.tableView.tableFooterView == self.footerViewLoading) {
        return;
    }
 
    self.tableView.tableFooterView = [TBCitySBTableViewFactory getClickableFooterView:CGRectMake(0, 0, self.tableView.frame.size.width, 44)Text:@"点一下加载更多" Target:self Action:@selector(onLoadMoreClicked:) ];
}

- (void)onLoadMoreClicked:(id)sender
{
    [self.keyModel loadMore];
}

@end

@implementation TBCitySBTableViewController(UITableView)

/*
 * tableView的相关操作
 */
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary*)bundle
{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPat
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
