 //
//  ForgotPasswordViewController.swift
//  Pods
//
//  Created by Innoer_kf on 2017/7/26.
//
//

import UIKit

@objc public protocol KFForgotPasswordViewControllerDelegate :NSObjectProtocol {
    
    @objc optional func fotgotPasswordResponse(username:String)->()
}

class KFForgotPasswordViewController: UIViewController {
    
    public weak var delegate:KFForgotPasswordViewControllerDelegate?
    public var siginButtonBackgroundColor:UIColor?
    
    
    @IBOutlet weak var sigInButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Forgotten your details"
        
        usernameTextField.layer.cornerRadius = 4.0
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.borderColor = UIColor.init(white: 0.92, alpha: 1.0).cgColor
        usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        usernameTextField.leftViewMode = .always
        usernameTextField.placeholder = "Username"
        
        if let _ = siginButtonBackgroundColor {
            sigInButton.backgroundColor = siginButtonBackgroundColor
        }
        
        
        sigInButton.layer.cornerRadius = 5.0
        
        let item = UIBarButtonItem(title: "X", style: .done, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = item

    }
    @objc func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    public init() {
        let podBundle = Bundle(for: KFForgotPasswordViewController.self)
        let bundleURL = podBundle.url(forResource: "Inno_Login", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        super.init(nibName: "ForgotPasswordViewController", bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func siginButton(_ sender: Any) {
        
        if usernameTextField.text!.count <= 0 {
            return;
        }
        if self.delegate != nil && self.delegate!.responds(to: #selector(KFForgotPasswordViewControllerDelegate.fotgotPasswordResponse(username:))) {
            self.delegate!.fotgotPasswordResponse!(username: usernameTextField.text!)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
