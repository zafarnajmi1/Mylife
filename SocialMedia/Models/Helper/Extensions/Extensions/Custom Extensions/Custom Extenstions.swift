//
//  Extensions.swift
//  Vagabond
//
//  Created by Muneeb ur :: on 01/02/2017.
//  Copyright © 2017 Muneeb-PC. All rights reserved.
//

import UIKit
import CoreData
extension UIFont {
    func myCustomFont(size: CGFloat, fontNameNo: Int) -> UIFont{
        let s = (size*UIScreen.main.bounds.height)/568
        if fontNameNo == 1 {
            return UIFont(name: "Arial", size: s)!
        } else {
            return UIFont(name: "Arial", size: s)!
        }
    }
}

extension UIViewController {
    func displayAlertMessage(_ Usermessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert".localized, message: Usermessage, preferredStyle: UIAlertController.Style.alert);
        myAlert.addAction(UIAlertAction(title:"OK".localized,style: UIAlertAction.Style.default,handler: nil ))
        self.present(myAlert, animated: true, completion:nil);
        
    }
    func convertDate(dateString: Double) -> String{
        
        let date = Date(timeIntervalSince1970: dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
//        let dateUnix = NSDate(timeIntervalSince1970: TimeInterval(dateString))
//        print(dateUnix)
//        let date = Date(timeIntervalSince1970: TimeInterval(dateString))
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "dd-MM-yyyy" //Specify your format that you want
//        let strDate = dateFormatter.string(from: date)
//        print(strDate)
        return strDate
        
    }
    func convertDateTwo(dateString: Double) -> String{

        let date = Date(timeIntervalSince1970: dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)

        return strDate
        
    }
    
}
extension String {
    
    func removeDasches() -> String {
        return self.replace(string: "-", replacement: "")
    }
    
    func removeSlashes() -> String {
        return self.replace(string: "/", replacement: "")
    }
    
    func removeQoute() -> String {
        return self.replace(string: "\"", replacement: "")
    }
}
//extension UIViewController
//{
//    let prefs = UserDefaults.standard
//}
extension UIView {
    func addGrayBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
    }
    func addBlackBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
}

extension UILabel {
    func applyFont(size: CGFloat, fontType: Int) {
        if fontType == 0 { //System Font
            self.font  = UIFont(name: "ChelseaMarket-Regular", size: size*UIScreen.main.bounds.height/568)
        } else if fontType == 1 { //System Font Bold
            self.font  = UIFont(name: "ChelseaMarket-Regular", size: size*UIScreen.main.bounds.height/568)
            
            
        }
    }
}

extension UITextField {
    func applyFont(size: CGFloat, fontType: Int) {
        if fontType == 0 { //System Font
            //self.font = UIFont.systemFont(ofSize: size*UIScreen.main.bounds.height/568)
            self.font =  UIFont(name: "ChelseaMarket-Regular", size: size*UIScreen.main.bounds.height/568)
        } else if fontType == 1 { //System Font Bold
            //self.font = UIFont.boldSystemFont(ofSize: size*UIScreen.main.bounds.height/568)
            self.font  = UIFont(name: "ChelseaMarket-Regular", size: size*UIScreen.main.bounds.height/568)
        }
    }
}

extension UIButton {
    func applyBorders() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 10
    }
}

extension UITextView {
    func applyFont(size: CGFloat, fontType: Int) {
        if fontType == 0 { //System Font
            self.font  = UIFont(name: "ChelseaMarket-Regular", size: size*UIScreen.main.bounds.height/568)
        } else if fontType == 1 { //System Font Bold
            self.font  = UIFont(name: "ChelseaMarket-Regular", size: size*UIScreen.main.bounds.height/568)
        }
    }
}

extension UIView
{
    var screenshot: UIImage
    {
        UIGraphicsBeginImageContext(self.bounds.size);
        let context = UIGraphicsGetCurrentContext();
        self.layer.render(in: context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot!
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}

extension UIColor
{
    
    var hexString:NSString {
        let colorRef = self.cgColor.components
        
        let r:CGFloat = colorRef![0]
        let g:CGFloat = colorRef![1]
        var b:CGFloat = colorRef![2]
        if b < 0 {
            b = b * -1
        }
        return NSString(format: "%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
    
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        if b < 0 {
            b = b * -1
        }
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
}

extension String {
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let newUrl = NSURL(string: url) {
            if let data = NSData(contentsOf: newUrl as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
extension UIViewController {
    func alertMessageOk(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

extension UIViewController
{
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
extension UINavigationController {
    
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
}


