//
//  PercentageCalculatorTests.swift
//  PercentageCalculatorTests
//
//  Created by 张楚昭 on 10/5/16.
//  Copyright © 2016年 tianxing. All rights reserved.
//

import XCTest
import CoreData
@testable import PercentageCalculator

class PercentageCalculatorTests: XCTestCase {
    var viewController:ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //初始化 ViewController 实例
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        viewController = storyboard.instantiateInitialViewController() as! ViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        //回收内存
        self.viewController = nil
    }
    //测试计算百分比函数
    func testPercentage() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let p = self.viewController.percentage(50, 50)
        XCTAssert(p == 25)
    }
    //测试界面更新函数
    func testLabelValueShowedProperly(){
        //通过访问 viewController的 view 属性来触发 viewController初始化,从而接下来方法的调用不会崩溃
        let _ = self.viewController.view
        viewController.updateLabels(Float(80.0), Float(50.0), Float(40.0))
        XCTAssert(viewController.numberLabel.text == "80.0", "numberLabel doesn't show the right text")
        XCTAssert(viewController.percentageLabel.text == "50.0%", "percentageLabel doesn't show the right text")
        XCTAssert(viewController.resultLabel.text == "40.0", "resultLabel doesn't show the right text")
    }
    //测试界面更新函数的性能
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            //通过访问 viewController的 view 属性来触发 viewController初始化,从而接下来方法的调用不会崩溃
            let _ = self.viewController.view
            self.viewController.updateLabels(Float(11.1), Float(22.2), Float(33.3))
        }
    }
    
    //常用 XCTest 断言
    func testAssert(){
        //最基本的断言
        XCTAssert(1 == 1, "等式两边的表达式应该是相等的")
        //Bool 断言测试
        let isTrue:Bool = true
        let isFalse:Bool = false
        XCTAssertTrue(isTrue, "本表达式应该是 true")
        XCTAssertFalse(isFalse, "本表达式应该是 false")
        //相等测试
        let x = 1
        let y = 2
        let z = 1
        XCTAssertEqual(x, z, "这两个表达式应该是相等的")
        XCTAssertNotEqual(x, y, "这两个表达式应该是不相等的")
        //Nil 测试
        let isNil:Bool? = nil
        let noNil = x
        XCTAssertNil(isNil, "本表达式应该是 nil")
        XCTAssertNotNil(noNil, "本表达式应该是非 nil")
        //无条件失败断言
        //XCTFail()
    }
    
    //XCTestExpression异步测试
    func testAsynchronousURLConnection(){
        let url = NSURL(string: "http://www.baidu.com/")!
        //首先是创建一个 expection
        let expectation = expectationWithDescription("GET\(url)")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(NSURLRequest(URL: url), completionHandler: {(data, response, error)in
            //在异步测试剩下的回调函数中告诉 expectation 条件已经满足,如果测试中有多个 expectation, 则每个都必须 fulfill, 否则测试不通过
            expectation.fulfill()
            XCTAssertNotNil(data, "返回数据不应该为空")
            XCTAssertNil(error, "error应该为空")
            
            if response != nil{
                let httpResponse = response as! NSHTTPURLResponse
                XCTAssertEqual((httpResponse.URL!.absoluteString), url, "HTTPResponse 的 URL应该和请求 URL一致")
                XCTAssertEqual(httpResponse.statusCode, 200, "HTTPResponse 的状态码应该是200")
                XCTAssertEqual(httpResponse.MIMEType! as String, "text/html", "HTTPResponse 内容应该是text/html")
            }else{
                XCTFail("返回内容不是 NSHTTPURLResponse 类型")
            }
        })
        task.resume()
        //最后,指定等待超时的时间和指定时间内条件无法满足时执行的闭包
        waitForExpectationsWithTimeout((task.originalRequest?.timeoutInterval)!, handler: { error in
            task.cancel()
        })
    }
    
    //测试中 Mock数据,很多开源库支持 Mock 和 Stub,但都严重依赖于 Object-C运行时.但 Swift 中,类可以定义在一个类的方法中,这一特点允许 mock 自包含的对象,然后 override 必要的方法.
    func testFetchRequestWithMockedManagedObjectContext(){
        class MockNSManagedObjectContext:NSManagedObjectContext{
            private override func executeFetchRequest(request: NSFetchRequest) throws -> [AnyObject] {
                return [["name":"张三", "email":"zhangsan@icloud.com"]]
            }
        }
        let mockContext = MockNSManagedObjectContext()
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email ENDSWITh[cd] %@", "icloud.com")
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        var results:[AnyObject]? = nil
        do{
            try results = mockContext.executeFetchRequest(fetchRequest)
        }catch{
            results = nil
        }
        XCTAssertEqual(results!.count, 1, "fetch request 应该只返回一个结构")
        
        let result = results![0] as! [String:String]
        XCTAssertEqual(result["name"]! as String, "张三", "name 应该是张三")
        XCTAssertEqual(result["email"]! as String, "zhangsan@icloud.com", "email 应该是 zhangsan@icloud.com")
    }
}
