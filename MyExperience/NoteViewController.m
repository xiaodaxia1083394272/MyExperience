//
//  NoteViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/10.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "NoteViewController.h"

//公用新闻那个Viewcontroller
#import "NewsViewController.h"
#import "FMDatabase.h"
#import "NoteObject.h"


@interface NoteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titlleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) FMDatabase *fmDatabase;
@property (assign, nonatomic) NSInteger dataID;
@property (strong, nonatomic) NoteObject *historyObject;
@property (strong, nonatomic) UILabel *textViewPlaceholderLabel;

@end

@implementation NoteViewController

//0.好啦上面放归纳，明了突出。顺便给自己点个赞，么么哒！


 static int saveId = 1;

- (instancetype)initWithHistoryObject:(NoteObject *)historyObject isShowHistoryObject:(BOOL)isShowHistoryObject{
    self = [super init];
    if (self) {
        self.isShowHistoryObject = isShowHistoryObject;
        self.historyObject = historyObject;
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"笔记";
//    self.navigationController.navigationBar.barTintColor= [UIColor yellowColor];
//    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"目录" style:UIBarButtonItemStylePlain target:self action:@selector(clickNoteHistoryButton)];
    [self setRightBarButton];
    
    self.dataID = saveId;

    
    [self openDataBase];
    
    self.textViewPlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, 60, 17)];
    
    //add上去貌似位置有bug，先不add
//    [self.contentTextView addSubview:self.textViewPlaceholderLabel];
    self.textViewPlaceholderLabel.backgroundColor = [UIColor clearColor];
    
    if(self.isShowHistoryObject) {
        self.titlleTextField.text = self.historyObject.title;
        self.contentTextView.text = self.historyObject.content;
        
        self.textViewPlaceholderLabel.text = @"";
    }else{
        
        self.textViewPlaceholderLabel.text = @"内容记录板";
    }
                                                                   
    // Do any additional setup after loading the view from its nib.
}
- (void)setRightBarButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 100, 30);
    
//    [btn setImage:[UIImage imageNamed:@"rightUp"] forState:UIControlStateNormal];
    
    [btn setTitle:@"笔记历史" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    UIBarButtonItem *rewardItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceItem.width = -15;
    
    [btn addTarget:self action:@selector(clickNoteHistoryButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[spaceItem,rewardItem];
}

- (void)clickNoteHistoryButton{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否保存当前的笔记呢？"preferredStyle:UIAlertControllerStyleAlert];
    //块的写法也比较特别，你说它是参数嘛，我们平时给参数也就单一 ，一种参数，但是用块传参，感觉就像把类型和内容一起传过去，怪？
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
        
        //    //2，查询数据，并把查询到的数据传过去
        //局部数组接收
        NSArray *noteList = [NSArray array];
        noteList = [self searchDatabaseData];
        
        //加这句的意思是，感觉块里面好像都是子线程执行的，并且直接在子线程里面执行，反正跳转的时候，动画不起作用，所以加了个回归主线程才执行操作的GCD，这样跳转能自然一点
//        dispatch_async(dispatch_get_main_queue(),^{
        
            NewsViewController *nvc = [[NewsViewController alloc] initWithStyle:@"note" noteList:noteList];
            [self.navigationController pushViewController:nvc animated:YES];
//        });

    }];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        _dataID++;
        //    //1，添加，或者说是保存数据先
            [self addDataToDatabaseWithDataId:self.dataID];
        NSLog(@"test note %d",_dataID);
        //局部数组接收
        NSArray *noteList = [NSArray array];
        noteList = [self searchDatabaseData];
        
//        dispatch_async(dispatch_get_main_queue(),^{

            NewsViewController *nvc = [[NewsViewController alloc] initWithStyle:@"note" noteList:noteList];
        NSLog(@"note cout %d",[noteList count]);
            [self.navigationController pushViewController:nvc animated:YES];
            
//        });
    }];
    
    [alertController addAction:cancelAction];
    
    [alertController addAction:saveAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    //    //1，添加，或者说是保存数据先
//    [self addDataToDatabaseWithDataId:self.dataID];
//    _dataID++;
//    //2，查询数据，并把查询到的数据传过去
//    [self searchDatabaseData];
//    
//    NewsViewController *nvc = [[NewsViewController alloc] initWithStyle:@"note" noteList:_noteList];
//    [self.navigationController pushViewController:nvc animated:YES];
    
    
}


//数据库公用路径
- (void)shareDatabase{
    //因为数据库一关闭，路径，数据库需重新加载，直接是打不开的，所以要公用这个方法
    //获取数据库的创建路径
    //NSHomeDirectory();获取手机APP的沙盒路径
    //在沙盒的Documents中存放数据库的路径
    NSString *strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/db01.db"];
    
    //创建并且打开数据库
    //如果路径下面没有数据库，创建指定的数据库
    //如果路径下已经存在数据库，就加载数据库到内存
    _fmDatabase = [FMDatabase databaseWithPath:strPath];
}

//创建打开数据库
- (void) openDataBase{
     //好多操作的第一步
    [self shareDatabase];
    
    if (_fmDatabase != nil) {
        
        NSLog(@"数据库创建成功");
    }
    //打开数据库
    BOOL isOpen = [_fmDatabase open];
    
    if (isOpen) {
        NSLog(@"打开数据库成功");
        
    }
    //将SQL创建语句写到字符串中
    //()是表的id 和类型，还有、、、
//    NSString *strCreateTable = @"create table if not exists stu(id integer primary key,age integer name varchar(20));";
    
    NSString *strCreateTable = @"create table if not exists note(id integer primary key,title varchar(100), content varchar(1000));";
    
    //执行SQL语句,语句要有效
    //执行，返回一个布尔值
    BOOL isCreate = [_fmDatabase executeUpdate:strCreateTable];
    if (isCreate == YES) {
        NSLog(@"创建表成功");
    }
    
    //关闭数据库
    BOOL isClose = [_fmDatabase close];
    if (isClose) {
        NSLog(@"关闭数据库成功");
    }
}

//添加或者叫插入数据库数据
- (void)addDataToDatabaseWithDataId:(NSInteger)dataId{
    
    //先查,判断与原有数据组的id是否重复，重复的话先删除旧数据，然后再保留新的数据

//    NSArray *checkResult = [self searchDatabaseData];
//    for (NoteObject *one in checkResult){
//        
//        if (one.dataID == self.historyObject.dataID){
//            //一样的话，就用原来的id存储，并删掉久的数据
//            [self deleteDataWiteDataId:one.dataID];
//            //确保无重复后再添加
//            dataId = _historyObject.dataID;
//        }
//    }
    
    //特别要注意的是，这里的插入数据是不会覆盖掉的，所有，执行一次就会加入一组新的数据，而且前面的id，不是表的id，而是这组数据的id，所以，插一次数据，id也是要新的喔
    
    
    //好多操作的第一步
    [self shareDatabase];
    
    //确保数据库被加载
    if (_fmDatabase != nil) {
        
        //打开数据库
        if([_fmDatabase open]) {
            //1.貌似经常要打开
            //2.（）这组数据的id，后两个数据直接就是内容来的
            //3.如果把参数直接写死在SQL语句里面的话，而不是以传参的方式，可能用起来很不方便！
            
//            NSString *strInset = @"insert into stu values(1,19,'Jack');";
            
            
            //1. 这里存字符串的貌似是用c来做的，所以，oc里的字符串可能要转成c的格式才能执行啊
//            NSString *strInset = @"insert into note values(1,'self.textfield.text','self.textView.text');";
            
//            BOOL isAdd = [_fmDatabase executeUpdate:strInset];
            
//            BOOL isAdd = [_fmDatabase executeUpdate:@"INSERT INTO note VALUES(?,?,?)",[NSNumber numberWithInteger:dataId],_titlleTextField.text,_contentTextView.text];
            
            BOOL isAdd = [_fmDatabase executeUpdateWithFormat:@"INSERT INTO note VALUES(%ld,%@,%@)",(long)dataId,_titlleTextField.text,_contentTextView.text];


            
            // 转换成字符串示例
//            [db executeUpdateWithFormat:@"INSERT INTO myTable VALUES (@d)", 42];
//            -execute*WithFormat: 这些方法后面都可以接格式字符串参数，以下 % 百分号格式符都是可以识别的：%@, %c, %s, %d, %D, %i, %u, %U, %hi, %hu, %qi, %qu, %f, %g, %ld, %lu, %lld, %llu。使用其他格式符可能会出现不可预知的问题。出于某种原因，可能需要在你的 SQL 语句中使用 % 字符，应该使用百分号转义一下 %%。

            if (isAdd == YES) {
                NSLog(@"添加数据成功");
            }

        }
    }
}

//查找数据
- (NSArray *)searchDatabaseData{
    
    //好多操作的第一步
    [self shareDatabase];
    
//    NSString *searchQuery = @"select *from stu";
    //也可以只查一个，比如@"select name *from stu" 但是遍历结果的时候就要注意了，不能解析出其他字段的内容了，因为没有
    //避免重复叠加,故定义一个局部的数组
    NSMutableArray *noteList = [NSMutableArray array];
    
    NSString *searchQuery = @"select *from note";
    BOOL isOpen = [_fmDatabase open];
    
    if (isOpen) {
        
        //执行查找SQL语句，注意是query而不是update喔
        //2。将查找成功的结果用ResultSet返回
        FMResultSet *result = [_fmDatabase executeQuery:searchQuery];
        
        //遍历所有结果
        //2，或许可以考虑用个类来接这些数据 ,并且最好用数组来接
        
        while ([result next]) {
            
            NoteObject *noteObject = [[NoteObject alloc] init];

            //获取id字段内容
//            NSInteger stuID = [result intForColumn:@"id"];
            noteObject.dataID = [result intForColumn:@"id"];
            
           //也可以通过索引来取值,比如下面，但是要记住，行是预定的了，这个index也就针对这组数据来说
//            NSInteger stuID = [result intForColumnIndex:0];
//            NSString * stuName = [result stringForColumnIndex:1];
//            NSInteger stuAge = [result ForColumnIndex:0];
            
            //获取表中内容了
//            NSString * stuName = [result stringForColumn:@"name"];
//            NSInteger stuAge = [result intForColumn:@"age"];
            
            noteObject.title = [result stringForColumn:@"title"];
            noteObject.content = [result stringForColumn:@"content"];
            
            
            [noteList addObject:noteObject];
            
            
        }
    }
    
    return noteList;

}

//删除数据
- (void)deleteDataWiteDataId:(NSInteger)dataId{
    
    //好多操作的第一步
    [self shareDatabase];
    
//    NSString *strDelete = @"delete from stu where id = 1";//参可变啊！
    
//    [_fmDatabase executeUpdateWithFormat:@"INSERT INTO note VALUES(%ld,%@,%@)",(long)dataId,_titlleTextField.text,_contentTextView.text]];
    BOOL isDelete = [_fmDatabase executeUpdateWithFormat:@"delete from stu where id = %ld",(long)dataId];
    if (isDelete){
        NSLog(@"删除成功");
    }
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [_contentTextView resignFirstResponder];
//    [_titlleTextField resignFirstResponder];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _titlleTextField){
        [textField resignFirstResponder];
    }
    return YES;
}

//UITextFieldDelegate代理里面响应return键的回调:textFieldShouldReturn:。
//但是 UITextView的代理UITextViewDelegate 里面并没有这样的回调。
//但是有别的方法可以实现：
//这个函数的最后一个参数text代表你每次输入的的那个字，所以：
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [_contentTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (_isShowHistoryObject){
        
         _textViewPlaceholderLabel.text = @"";
        
    }else{
        
        if (textView.text.length == 0){
            _textViewPlaceholderLabel.text = @"内容记录板";
        }else{
            _textViewPlaceholderLabel.text = @"";
        }
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
