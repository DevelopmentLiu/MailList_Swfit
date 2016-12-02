//
//  ListTableViewController.swift
//  MailList_Swfit
//
//  Created by jyLiu on 2016/11/29.
//  Copyright © 2016年 JY_L. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    //联系人数组
    var personList = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData { (list) in
            print(list)
            //拼接数组， 闭包中定义好的代码在需要的时候执行。需要self，指定语境
            self.personList += list
            self.tableView.reloadData()
        }
        
    }
    
    //MARK:模拟异步，利用闭包回调  @escaping闭包逃逸 在函数执行完以后再执行
    private func loadData(completion:@escaping (_ list:[Person])->()) -> (){
        DispatchQueue.global().async {
            print("正在努力开发中....")
            //设置加载的时间
            Thread.sleep(forTimeInterval: 3)
            //创建对象数组
            var arrayM = [Person]()
            
            for i in 0..<20{
                let p = Person()
                //顺序输出
                p.name = "王二狗 - \(i)"
                //创建号码随机数
                p.phone = "1502" + String(format:"%06d",arc4random_uniform(1000000))
                p.title = "Boss"
                
                arrayM.append(p)
            }
            //主线程回调
            DispatchQueue.main.async(execute:{
                //执行，回调闭包
                completion(arrayM)
            })
        }
    }
    
    //MARK:数据源
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        cell.textLabel?.text = personList[indexPath.row].name
        cell.detailTextLabel?.text = personList[indexPath.row].phone
        return cell
        
    }
    //MARK:代理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //执行segue
        performSegue(withIdentifier: "list2detail", sender: indexPath)
    }
    //MARK:新建按钮
    @IBAction func newPerson(_ sender: Any) {
        performSegue(withIdentifier: "list2detail", sender:nil)
    }
    
    //MARK:控制器跳转方法
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //类型转换as.
        //Swfit中String之外。多数使用as 需要 ？/ !
        //as! / as?直接根据前面的返回值来决定
        //if let / guard let 判断空语句。一律使用  as?
        let vc = segue.destination as? DeatilViewController
        if let indexPath = sender as? IndexPath{
            //indexPath一定有值
            vc?.person = personList[indexPath.row]
            vc?.completionCallBack = {
                //刷新指定行
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } else {
            //新建个人记录
            vc?.completionCallBack = { [weak vc] in
                //获取明细，判断person
                guard let per = vc?.person else {
                    return
                }
                //插入数据
                self.personList.insert(per, at: 0)
                //刷新表格
                self.tableView.reloadData()
            }
        }
    }
    
    
}
