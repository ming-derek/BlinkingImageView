//
//  ViewController.swift
//  BlinkingImageView
//
//  Created by 张威 on 2018/7/9.
//  Copyright © 2018 MING Labs. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var timer: Timer?
    
    var imgView: UIImageView!
    
    var durationLbl: UILabel!
    
    lazy var intervalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentView = UIView()
        view.addSubview(contentView)
        
        let img = UIImage(named: "wifi")!
        imgView = UIImageView(image: img)
        contentView.addSubview(imgView)
        
        let slider = UISlider()
        contentView.addSubview(slider)
        
        durationLbl = UILabel()
        durationLbl.textColor = .darkGray
        durationLbl.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(durationLbl)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imgView.snp.makeConstraints { make in
            make.size.equalTo(img.size)
            make.top.centerX.equalToSuperview()
        }
        
        slider.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.top.equalTo(imgView.snp.bottom).offset(30)
            make.leading.centerX.equalToSuperview()
        }
        
        durationLbl.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(30)
            make.centerX.bottom.equalToSuperview()
        }
        
        slider.tintColor = UIColor(hex: 0xD94D4B)
        slider.minimumValue = 0.3
        slider.maximumValue = 1.5
        slider.addTarget(self, action: #selector(onSliderValueChanged(_:)), for: .valueChanged)
        
        slider.value = 0.5
        resetTimer(with: 0.5)
    }
    
    @objc func onSliderValueChanged(_ target: UISlider) {
        resetTimer(with: TimeInterval(target.value))
    }
    
    func resetTimer(with interval: TimeInterval) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        if let num = intervalFormatter.string(from: NSNumber(value: interval)) {
            durationLbl.text = "Duration (\(num)s)"
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            let isHidden = self.imgView.isHidden
            let alpha: CGFloat = self.imgView.isHidden ? 1 : 0
            
            if isHidden {
                self.imgView.alpha = 0
                self.imgView.isHidden = false
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.imgView.alpha = alpha
            }, completion: { _ in
                if !isHidden {
                    self.imgView.isHidden = true
                }
            })
        }
    }
}

extension UIColor {
    
    convenience init(hex: UInt) {
        
        let r = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00ff00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000ff) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
