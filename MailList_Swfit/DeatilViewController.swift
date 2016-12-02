//
//  DeatilViewController.swift
//  MailList_Swfit
//
//  Created by jyLiu on 2016/11/29.
//  Copyright © 2016年 JY_L. All rights reserved.
//

import UIKit

class DeatilViewController: UITableViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var titleTetx: UITextField!
    var person:Person?
    //定义闭包的属性
    var completionCallBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        //判断person是否有值
        if person != nil{
            nameText.text = person?.name
            phoneText.text = person?.phone
            titleTetx.text = person?.title
        }

    }
    
    //MARK:
    @IBAction func saveBtn(_ sender: Any) {
        
        //1、判断person 是否为nil。如果是就新建
        if person == nil{
            person = Person()
        }
        person?.name = nameText.text
        person?.phone = phoneText.text
        person?.title = titleTetx.text
        //调用闭包. 
        // !强行解包。 ？可选解包（如果闭包为nil,就什么也不做）
        completionCallBack?()
        
        //返回上级界面 
        //_可以省略一切不关心的内容
        _ = navigationController?.popViewController(animated: true)
    }


    
}
