//
//  FailMark.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/17.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#ifndef FailMark_h
#define FailMark_h


#endif /* FailMark_h */
//http://www.runoob.com/   http://www.w3school.com.cn/
//首先要有比较清晰的基础认识，才能应对变化，直接应对变化，很容易乱头绪?&相似不同&有什么区别呢

//0.证书信息   用户电子邮件地址：1083394272@qq.com 常用名称：xiaodaxia 请求是：存到磁盘

//1.博客的话，有时只看大概的思路即可，因为内容的话可能是错的
//2. 还原模拟器
//3. 在下面的info plist里可以用add row来加行
/*4. 怎么知道这个是个旧的方法：- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
 fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0) __TVOS_PROHIBITED __WATCHOS_PROHIBITED; 
 */
//5. 懒加载和单例的区别
//6. 有时图片写不进去，可能与缓存有关，建议清一下项目的缓存
//7. 字符串前面加叹号是什么意思
//8. viewdidLoad里面把一个Nsstring的属性赋值给label，即使后来string的值变了，如果不刷新label的text，它貌似也不会变。
//9.sql的数据库查询结果不要用一个全局的数组接收，要用一个局部的，否则每查一次，就好重复叠加一次哦
//10.遇到bug先大概想想原因，然后才动手根据相应的反馈进行调节
//11.上架流程 http://www.cnblogs.com/BK-12345/p/5232633.html
//12.合理分配时间，劳逸结合，很重要
//13.图片双击左键点开，然后选文件，导出哪里可以转格式
//14.20pt * 2x = 40像素，记住了吗？
//15. 一个小时就关屏幕吧，否则就要浪费时间了
//16. TCP/IP 详解 http://www.cnblogs.com/fengzanfeng/articles/1339347.html
//17. 不妨来点音乐
//18.http://www.jb51.net/article/83941.htm socket http://blog.csdn.net/potato512/article/details/44001683
//19.注意文件名前面的三角号
//20.微信分享 http://www.cnblogs.com/mancong/p/5807924.html
//21.客人需求优先
//22.太过相信自己能解决不是一件好事。
//23.添加配置时搜前缀。
//24.要把文件托入项目文件中再add，直接拉过来的话貌似找不到。
//25.对眼前的事情走心。
//26.不关乎学历，关键能做到事情
//27.buildsetting  里面要加东西，可能要双击即可。
//28.貌似加个专有名词更加好记。比如“必杀15分钟”,"返回值代码块“,"副将纸笔"，“副将面具”
//29.反推
//30.代码块，复用，值回调
//31.question mark override
//32.继承能很好地处理一些重复原则性的问题
//33.针对这种父类方法有返回值的，直接重写的时候返回就行了，因为调用这种方法本身就会有个返回值
//34.将变的变为不变的，可以预计未果。
//35.xib里的继承更简单，直接在class里填
//36.类没有self的概念吗？
/*37.代码块调用的时候要写类型，名字就不用写了。一般的都不用写.
 37.一，typedef void(^MENetworkResponseHandler)(MENetworkResponse *response);
       responseHandler:(MENetworkResponseHandler)responseHandler
       这种的即使是调用的时候跟下面的那种一毛一样。
 37.二，responseHandler:(void(^)(MENetworkResponse *response))responseHandler  定义时，要返回值，^符并且名字不写，加参数
       responseHandler:^(MENetworkResponse *response) 调用时，缺返回值，其实并不缺，已经参数变成返回值了，^符并且名字括号都不写，括号不写主要是因为少了返回值不用区分了吧，加参数
*/
//38.通知http://www.cnblogs.com/zmloveworld/p/5388810.html
//39.NSuserDefaults https://my.oschina.net/u/1245365/blog/294449
//40.面试http://www.2cto.com/kf/201510/446986.html
//41.程序狗面试题https://github.com/ChenYilong/iOSInterviewQuestions
//42.根本没有什么岁月静好，只是有人在替我们负重前行
//43.脑动。
//44.看一下（或者说学一下也行），特别是遇到非常难理解的，停下一会，对着眼前相对固定静止的事物，然后把刚才想的套进去，或许能悟到，或者能更好地理解，因为万物都逃不出上帝的规则。
//45.iOS开发路线图http://www.cnblogs.com/tgycoder/p/5566892.html
/*46.程序通过URL调用系统自带的应用http://www.cnblogs.com/foxmin/archive/2012/03/17/2402984.html
 url调用一般应用http://www.cnblogs.com/foxmin/archive/2012/03/18/2404727.html
 URL应用程序间传递数据http://www.cnblogs.com/foxmin/archive/2012/03/18/2405067.html
 */
/*47.特定含义：memory内存，host域名，terminate退出，port端口，scheme协议，absoluteString完整字符串
 */
//48.AFNetworking 解释比较好的博客http://blog.csdn.net/jingyipo/article/details/51537865

//49.关于排序的博客，还好http://blog.csdn.net/miscellaner/article/details/41870183
//50.不要刺眼的光，调低亮度，调高刷新率,降低干扰
//51.父类能做到的，子类一定能做到，这是比较不用质疑的
//52.每个项目除了用户名，下一行的那个，project生成后就基本不会变了
//53.有一个关于wsdl2objc比较好的http://www.knowsky.com/883067.html
//54.在类似target里面配置总的话，直接在后面双击就可以输入了
//55.q不最小化不会弹出来
//56.站长工具
//57.office工具拉窄会看不到工具栏的
//58.OS开发之Objective-C与JavaScript交互操作，有点像命令行控制
//59.解释wsdl比较好的博客http://blog.csdn.net/etttttss/article/details/17303315
#pragma mark
