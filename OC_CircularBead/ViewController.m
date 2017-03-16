//
//  ViewController.m
//  OC_CircularBead
//
//  Created by myios on 2017/3/16.
//  Copyright © 2017年 Ashimar. All rights reserved.
//  http://blog.csdn.net/messi_m10/article/details/54377628
//http://www.jianshu.com/p/e97348f42276

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.myTableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    cell.imageView.image = [UIImage imageNamed:@"1"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.detailTextLabel.text = @"哎呦还不错哦";
    
//    第一种方法:通过设置layer的属性
    /* */
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 40, 40)];
//        imageView.image = [UIImage imageNamed:@"1"];
//    imageView.backgroundColor = [UIColor orangeColor];
//    imageView.layer.cornerRadius = 20;
//    imageView.layer.masksToBounds = YES;
//    [cell addSubview:imageView];
    
    
//    第二种方法:使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 40, 40)];
    imageView.image = [UIImage imageNamed:@"1"];
    
    [cell addSubview:imageView];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        //开始对imageView进行画图
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, [UIScreen mainScreen].scale);
        //使用贝塞尔曲线画出一个圆形图
        [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width] addClip];
        [imageView drawRect:imageView.bounds];
        
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        //结束画图
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
        
    });
    
    
//    第三种方法:使用CAShapeLayer和UIBezierPath设置圆角
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 40, 40)];
//    imageView.image = [UIImage imageNamed:@"1"];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//    //设置大小
//    maskLayer.frame = imageView.bounds;
//    //设置图形样子
//    maskLayer.path = maskPath.CGPath;
//    imageView.layer.mask = maskLayer;
//    [cell addSubview:imageView];
    
    
//    1和3 会导致离屏渲染 圆角多会影响页面帧率。 圆角多的时候 2比较好。配合异步+缓存
    return cell;
}

#pragma mark - lazy load

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain  ];
        _myTableView.delegate =self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _myTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
