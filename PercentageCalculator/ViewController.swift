//
//  ViewController.swift
//  PercentageCalculator
//
//  Created by 张楚昭 on 10/5/16.
//  Copyright © 2016年 tianxing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //通过滚动条确定输入的值
    @IBOutlet weak var numberSlider: UISlider!
    @IBOutlet weak var numberLabel: UILabel!
    
    //通过滚动条确定计算的百分数
    @IBOutlet weak var percentageSlider: UISlider!
    @IBOutlet weak var percentageLabel: UILabel!
    
    //显示计算结果
    @IBOutlet weak var resultLabel: UILabel!
    
    
    
    //通过滚动条获得不同输入值,同时实时更新计算结果值和界面
    @IBAction func numberValueChanged(sender: AnyObject) {
        numberSlider.setValue(Float(Int(numberSlider.value)), animated: true)
        
        let r = percentage(numberSlider.value, percentageSlider.value)
        updateLabels(numberSlider.value, nil, r)
    }
    
    //通过滚动条获得不同百分数,同时实时计算并更新结果值和界面
    @IBAction func percentageValueChanged(sender: AnyObject) {
        percentageSlider.setValue(Float(Int(percentageSlider.value)), animated: true)
        
        let r = percentage(numberSlider.value, percentageSlider.value)
        updateLabels(nil, percentageSlider.value, r)
    }
    
    //更新界面显示
    func updateLabels(nV: Float?, _ pV: Float?, _ rV: Float) {
        if let v = nV {
            self.numberLabel.text = "\(v)"
        }
        if let v = pV {
            self.percentageLabel.text = "\(v)%"
        }
        
        self.resultLabel.text = "\(rV)"
    }
    
    //计算百分比
    func percentage(value: Float, _ percentage: Float) -> Float {
        return value * (percentage / 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

