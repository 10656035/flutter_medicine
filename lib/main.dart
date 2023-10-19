import 'package:flutter/material.dart';
import 'detail.dart';  // 匯入詳細頁面的庫

void main() {
  runApp(
    const MaterialApp(
      title: 'Flutter Tutorial',
      debugShowCheckedModeBanner: false,  // 關閉 debug 標籤
      home: MyBuild(),  // 將 MyBuild 小部件設置為首頁
    ),
  );
}

class MyBuild extends StatefulWidget {
  const MyBuild({Key? key}) : super(key: key);

  @override
  _MyBuildState createState() => _MyBuildState();  // 創建 MyBuild 的狀態
}

class _MyBuildState extends State<MyBuild> {
  PageController _pageController = PageController();  // 頁面控制器，用於處理頁面切換
  int currentPage = 0;  // 當前頁面的索引
  int totalItems = 300;  // 總項目數
  int itemsPerPage = 30;  // 每頁項目數
  List<List<String>> data = [];  // 存儲每頁的項目數據列表

  @override
  void initState() {
    super.initState();
    fetchPageData(currentPage);  // 在初始化時，獲取第一頁的數據
  }

  void fetchPageData(int page) {
    if (data.length <= page) {
      // 創建一個新的頁面數據列表
      List<String> pageData = [];
      int startIndex = page * itemsPerPage + 1;
      int endIndex = (page + 1) * itemsPerPage;
      for (int i = startIndex; i <= endIndex; i++) {
        pageData.add('項目 $i');
      }

      setState(() {
        // 確保 data 列表足夠長，然後設置頁面數據
        while (data.length <= page) {
          data.add([]);
        }
        data[page] = pageData;
      });
    }
  }

  // 處理點擊列表項目後的導航到詳細頁面的方法
  void _navigateToDetailPage(String itemTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(title: itemTitle),  // 將所選列表的標題傳遞到詳細頁面
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext innerContext) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(innerContext).openDrawer();  // 打開抽屜式導航
              },
            );
          },
        ),
        title: const Text('Example title'),  // AppBar 標題
        actions: const [],  // 右側的操作按鈕，這裡是空的
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),  // 上方 10 像素的外邊距
              width: 350,
              padding: EdgeInsets.symmetric(horizontal: 16),  // 左右 16 像素的內邊距
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),  // 設置圓弧形狀
                color: Colors.grey[300],  // 背景顏色
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,  // 沒有邊框
                  hintText: '搜尋',  // 提示文字
                  icon: Icon(Icons.search),  // 搜尋圖示
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: (totalItems / itemsPerPage).ceil(),  // 計算總頁數
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                    if (data.length <= page) {
                      fetchPageData(page);  // 當切換到新頁面時，獲取數據
                    }
                  });
                },
                itemBuilder: (BuildContext context, int page) {
                  if (data.isEmpty ||
                      data.length <= page ||
                      data[page] == null) {
                    return Center(child: CircularProgressIndicator());  // 如果數據尚未加載，顯示進度條
                  }

                  return ListView.builder(
                    itemCount: data[page].length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Icon(Icons.star),
                        title: Text(data[page][index]),
                        subtitle: Text('2023-10-19'),
                        onTap: () {
                          _navigateToDetailPage(data[page][index]);  // 當點擊列表項目時，導航到詳細頁面
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );  // 點擊左箭頭時，切換到上一頁
                  },
                ),
                Text('頁數 ${currentPage + 1}'),  // 顯示當前頁數
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );  // 點擊右箭頭時，切換到下一頁
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('首頁'),  // 選項1的名稱
              onTap: () {
                Navigator.pop(context);  // 關閉抽屜式導航
              },
            ),
            ListTile(
              title: Text('闢謠專區'),  // 選項2的名稱
              onTap: () {
                Navigator.pop(context);  // 關閉抽屜式導航
              },
            ),
            ListTile(
              title: Text('身體安全的新聞'),  // 選項3的名稱
              onTap: () {
                Navigator.pop(context);  // 關閉抽屜式導航
              },
            ),
          ],
        ),
      ),
    );
  }
}