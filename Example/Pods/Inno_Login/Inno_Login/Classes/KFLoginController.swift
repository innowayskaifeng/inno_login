//
//  KFLoginController.swift
//  CONSULTANT_swift
//
//  Created by Innoer_kf on 2017/6/27.
//  Copyright © 2017年 ZerOnes. All rights reserved.
//

import UIKit
import IBAnimatable
import BiometricAuthentication


let USERDEFAULT = UserDefaults.standard

let FULLNAME = "kffullName"
let USERNAME = "kfusername"
let PASSWORD = "kfpassword"
let HEADERURL = "kfheaderUrl"
let HEADERDATA = "kfheaderData"
let ISTOUCHIDLOGIN = "kfisTouchIDLogin"
let ISREMEMBERPASSWORD = "kfisRememberPassword"



let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width


//return : ture 会保存用户名密码
@objc public protocol KFLoginControlerDelagete :NSObjectProtocol {
    
    //marking Box change
    @objc optional func markingBoxDidChange(select:Bool)
    
    //点击登陆返回用户名和密码
    @objc optional func loginResponse(username:String, password:String)->Bool
    
   //用户名和密码认证状态
    @objc optional func accountAuthenticationStatus(status:Bool)
    
    @objc optional func fotgotPasswordResponse(username:String)
}

public class KFLoginController: UIViewController,KFLoginControlerDelagete,KFForgotPasswordViewControllerDelegate,KFPraviryViewDelegate{
    
    @objc public weak var delegate:KFLoginControlerDelagete?
    
    
    //logo比例  高度固定，设置宽高比例
    public var logoImageAspect:CGFloat? {
        didSet{
            if let _ = logoAspect{
                logoAspect = logoAspect.setMultiplier(multiplier: logoImageAspect!)
            }
        }
    }
    
    @objc public var logoThemeImage:UIImage?{//设置logo
        didSet{
            if UIDevice.current.userInterfaceIdiom != .phone {
                if let _ = logoImage {
                    logoImage.image = logoThemeImage
                }
            }
        }
    }
    
    @objc public var headerImage:UIImage? {//头像，不设置显示默认
        didSet{
            if let _ = headerPicture {
                if headerImage != nil {
                    
//                    let headerData = UIImagePNGRepresentation(headerImage!)
//                    USERDEFAULT.set(headerData, forKey: HEADERDATA)
//                    USERDEFAULT.synchronize()
//                   headerPicture.image = headerImage
                    headerPicture.image = headerImage
                }
            }
        }
    }
    
    public var headerImageURL:String? {//头像，如果有值，headerImage本地图片设置会失效
        didSet{
            USERDEFAULT.set(headerImageURL, forKey: HEADERURL)
            if let _ = headerPicture {
                
                getImage(aURL: headerImageURL!, asyncImage: { (image) in
                    DispatchQueue.main.async {
                        self.headerPicture.image = image!
                    }
                })
            }
        }
    }
    
   
    public var rememberTouchIDTextColor:UIColor? {//remember,touchId response 字体颜色
        didSet{
            if let _ = rememberMoButton, let _ = userTouchIDButton {
                rememberMoButton.setTitleColor(rememberTouchIDTextColor, for: .normal)
                userTouchIDButton.setTitleColor(rememberTouchIDTextColor, for: .normal)
            }
        }
    }
    
    public var promptSubtitleTextColor:UIColor?{
        didSet{
            if let _ =  selectTitleLabel{
                selectTitleLabel.textColor = promptSubtitleTextColor
            }
        }
    }
    
    
    
    @objc public var rememberTouchIDTextColorHighlighted:UIColor?{//remember,touchId response 字体高亮颜色
        didSet{
            if let _ = rememberMoButton, let _ = userTouchIDButton {
                rememberMoButton.setTitleColor(rememberTouchIDTextColorHighlighted, for: .selected)
                userTouchIDButton.setTitleColor(rememberTouchIDTextColorHighlighted, for: .selected)
            }
        }
    }
    
    public var fotgotPasswordHidden:Bool? {
        didSet{
            if let _ = fotgotPassword {
                fotgotPassword.isHidden = fotgotPasswordHidden ?? false
            }
        }
    }
    
    @objc public var fotgotPasswordTextColor:UIColor? {
        didSet{
            if let _ = fotgotPassword {
                fotgotPassword.setTitleColor(fotgotPasswordTextColor, for: .normal)
            }
        }
    }
    
    @objc public var switchUserTextColor:UIColor?{ //switch User 字体颜色
        didSet{
            if let _ = switchUser {
                switchUser.setTitleColor(switchUserTextColor, for: .normal)
            }
        }
    }
    
    public var signinTextColor:UIColor?{//登录字体颜色
        didSet{
            if let _ = sigInButton {
                sigInButton.setTitleColor(signinTextColor, for: .normal)
            }
        }
    }
    @objc public var signinBackgroundColor:UIColor?{//登录背景颜色
        didSet{
            if let _ = sigInButton {
                sigInButton.backgroundColor = signinBackgroundColor
            }
        }
    }
    
    public var signinBackgroundImage:UIImage?{//登录背景按钮
        didSet{
            if let _ = sigInButton {
                sigInButton.setBackgroundImage(signinBackgroundImage, for: .normal)
            }
        }
    }
    
    //安全提示感叹号
    @objc public var exclamationBackgroundImage:UIImage? {
        didSet{
            if let _ = exclamationImage{
                exclamationImage.image = exclamationBackgroundImage
            }
        }
    }
    //安全提示删除按钮
    @objc public var x_safeBackgroundImage:UIImage? {
        didSet{
            if let _ = x_safeButton{
                x_safeButton.setImage(x_safeBackgroundImage, for: .normal)
            }
        }
    }
    
    public var backgroundImage:UIImage?{ //背景图片
        didSet{
            if UIDevice.current.userInterfaceIdiom != .phone {
                if let _ =  backgroundView{
                    backgroundView.image = backgroundImage
                }
            }
        }
    }
    
    //用户名认证状态
    public var authentication = {(status:Bool, andfullName:String)  in }
    
    public var turnOnPrivary:Bool = false
    
    public var privaryTitleText:String?
    public var privaryContentText:String?
    public var privaryCompanyText:String?
    
    //Privary背景颜色
    public var privaryAgreeBackgroundColor:UIColor? {
        didSet{
            if let _ = praviryView.agreeOutlet {
                praviryView.agreeOutlet.setBackgroundImage(generateImageWith(privaryAgreeBackgroundColor!, andFrame: CGRect(x: 0, y: 0, width: 20, height: 20)), for: .selected)
                
                 praviryView.agreeOutlet.setBackgroundImage(generateImageWith(UIColor.gray, andFrame: CGRect(x: 0, y: 0, width: 20, height: 20)), for: .normal)
            }
        }
    }
    
    
    private var logoName:String?
    private var downloadTask: URLSessionDownloadTask!
    private var session: URLSession!
    private var arrStaff: NSArray!
    private var arrUsername = NSMutableArray()
    private var arrPassword = NSMutableArray()
    private var isLogout = Bool()
    private var isSelectUserTouchID:Bool! = false
    private var lastDate:Date = Date(); var speed = "0"
    
    let praviryView:KFPraviryView = KFPraviryView.loadFormNib()
    private let fotgotController = KFForgotPasswordViewController()
    
    @IBOutlet var logoImage: UIImageView!//
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var sigInButton: AnimatableButton!
    @IBOutlet weak var switchUser: UIButton!
    @IBOutlet weak var safeView: AnimatableView!
    @IBOutlet weak var headerPicture: UIImageView!
    @IBOutlet weak var userNameTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    @IBOutlet weak var rememberMoButton: UIButton!
    @IBOutlet weak var userTouchIDButton: UIButton!
    @IBOutlet weak var userBackground: UIView!//
    @IBOutlet weak var selectButton: AnimatableButton!
    @IBOutlet weak var selectTitleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var exclamationImage: UIImageView!
    @IBOutlet weak var x_safeButton: UIButton!
    
    @IBOutlet weak var headerRightView: UIView!
    @IBOutlet weak var selectView: AnimatableView!
    
    /**
     *背景高度
     *
     */
    @IBOutlet weak var loginBackHeight: NSLayoutConstraint!
    
    /**
     *用户名输入框顶部距离  用户隐藏和显示控制
     *
     */
    @IBOutlet weak var userNameTextMarginTopHeight: NSLayoutConstraint!
    /**
     *用户名输入框高度  用户隐藏和显示控制
     *
     */
    @IBOutlet weak var userNameTextHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headerCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var logoAspect: NSLayoutConstraint!
    
    //MARK: Cirle life
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clearUserPassword()
        
    }
    
    private var authenticationStatus:Bool = false;
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        configUI()
        
        touchIDLoinVerification()
        
        //认证成功 后者失败在做操作。
        authentication = { status, fullName in
            
            self.authenticationStatus = status
            if fullName.count > 0 {
                USERDEFAULT.setValue(fullName, forKey: FULLNAME)
            }
            
            if status && self.isShowPrivary() {
                self.showPriviry()
            }else{
                if (self.delegate != nil) && (self.delegate?.responds(to: #selector(KFLoginControlerDelagete.accountAuthenticationStatus(status:))))!{
                    self.delegate?.accountAuthenticationStatus!(status: self.authenticationStatus)
                }
            }
        }
    }
    
    func isShowPrivary()->Bool{
         let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if !USERDEFAULT.bool(forKey: version! + self.userNameTextField.text!) &&
            self.turnOnPrivary && self.userNameTextField.text!.count > 0{
            return true
        }else{
            return false
        }
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if turnOnPrivary {
            praviryView.delegate = self
            praviryView.privaryTitleText = privaryTitleText
            praviryView.privaryContentText = privaryContentText
            praviryView.privaryCompantName = privaryCompanyText
            praviryView.backgroundColor = UIColor.white
            
            if let _ = privaryAgreeBackgroundColor {
                praviryView.agreeOutlet.setBackgroundImage(generateImageWith(privaryAgreeBackgroundColor!, andFrame: CGRect(x: 0, y: 0, width: 20, height: 20)), for: .selected)
                
                praviryView.agreeOutlet.setBackgroundImage(generateImageWith(UIColor.gray, andFrame: CGRect(x: 0, y: 0, width: 20, height: 20)), for: .normal)
            }
        }
}
    
    @objc func showPriviry(){
        
        view.addSubview(praviryView)
        praviryView.animate(.fade(way: .in), duration: 0.5, damping: 1, velocity: 2, force: 1)
        
    }
    
    func exitApplication() {
        
        let aWindow = UIApplication.shared.delegate?.window
        if let _ = aWindow {
            UIView.animate(withDuration: 0.5, animations: {
                aWindow!?.alpha = 0;
                aWindow!?.frame = CGRect(x: 0, y: SCREEN_WIDTH, width: 0, height: 0)
            }) { (finished) in
                exit(0)
            }
        }
    }
    
    func loadImage(name:String)->UIImage?{
        let podBundle = Bundle(for: KFLoginController.self)
        let bundleURL = podBundle.url(forResource: "Inno_Login", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        let path = bundle.path(forResource: name, ofType: "png")
        let image = UIImage(contentsOfFile: path!)
        return image
    }
    
   class func aGetBundle() -> Bundle{
        let podBundle = Bundle(for: KFLoginController.self)
        let bundleURL = podBundle.url(forResource: "Inno_Login", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        return bundle
    }
    
    public init() {
        
        let podBundle = Bundle(for: KFLoginController.self)
        let bundleURL = podBundle.url(forResource: "Inno_Login", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            super.init(nibName: "LoginControlleriPhone", bundle: bundle)
        }else
        {
            super.init(nibName: "LoginControlleriPad", bundle: bundle)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //用户名密码框至空
    public func clearUserPassword(){
        
        if !USERDEFAULT.bool(forKey: ISREMEMBERPASSWORD) {
            userNameTextField.text = ""
        }
        
        passwordTextField.text = ""
    }
    
    //MARK: response
    
    @IBAction func selectedPasswordResponse(_ sender: Any) {
        
        let sendBtn = sender as! AnimatableButton
        if isSelectUserTouchID {
            sendBtn.isSelected = !USERDEFAULT.bool(forKey: ISTOUCHIDLOGIN)
            USERDEFAULT.set(sendBtn.isSelected, forKey: ISTOUCHIDLOGIN)
        }else
        {
            sendBtn.isSelected = !USERDEFAULT.bool(forKey: ISREMEMBERPASSWORD)
            USERDEFAULT.set(sendBtn.isSelected, forKey: ISREMEMBERPASSWORD)
        }
        if sendBtn.isSelected {
            sendBtn.animate(.flip(along: .x), duration: 0.5, damping: 1, velocity: 2, force: 1)
        }else
        {
            sendBtn.animate(.flip(along: .x), duration: 0.5, damping: 1, velocity: 2, force: 1)
        }
    }
    
    @IBAction func switchUser(_ sender: Any) {
       
        USERDEFAULT.removeObject(forKey: USERNAME)
        USERDEFAULT.removeObject(forKey: PASSWORD)
        USERDEFAULT.removeObject(forKey: FULLNAME)
        USERDEFAULT.removeObject(forKey: HEADERURL)
        configUI()
        
    }
    
    @IBAction func remeberMe(_ sender: Any) {
        
        if !isSelectUserTouchID {
            return
        }
        isSelectUserTouchID = false
        rememberMoButton.isSelected = true
        userTouchIDButton.isSelected = false
        selectTitleLabel.text = "Remember me."
        selectButton.isSelected = USERDEFAULT.bool(forKey: ISREMEMBERPASSWORD)
        
        selectView.animate(.squeeze(way: .in, direction: .left), duration: 1, damping: 1, velocity: 2, force: 1)
        
        //Wkf19920821
    }
    
    @IBAction func userTouchID(_ sender: Any) {
        if isSelectUserTouchID {
            return
        }
        isSelectUserTouchID = true
        rememberMoButton.isSelected = false
        userTouchIDButton.isSelected = true
        selectTitleLabel.text = "When Touch ID is enabled,you can sign in using any fingerprints stored in the device."
        selectButton.isSelected = USERDEFAULT.bool(forKey: ISTOUCHIDLOGIN)
        selectView.animate(.squeeze(way: .in, direction: .right), duration: 1, damping: 1, velocity: 2, force: 1)
        touchIDLoinVerification()
    }
    
    @IBOutlet weak var fotgotPassword: UIButton!
    @IBAction func fotgotPassword(_ sender: Any) {
        
        fotgotController.delegate = self
        fotgotController.siginButtonBackgroundColor = fotgotPassword.titleLabel?.textColor
        
        
        if navigationController == nil {
            let nav = UINavigationController(rootViewController: fotgotController)
            self.present(nav, animated: true, completion: nil)
        }else
        {
            self.navigationController?.pushViewController(fotgotController, animated: true)
        }
    }
    @IBAction func x_safeView(_ sender: Any) {
        
        let sen = sender as! UIButton
        sen.isHidden = true
        safeView.animate(.fade(way: .out), duration: 1, damping: 1, velocity: 2, force: 1)
        
    }
    //touchID 登录
    func touchIDLogin(){
        
        if self.delegate != nil && (self.delegate?.responds(to: #selector(KFLoginControlerDelagete.loginResponse(username:password:))))! {
            let isMatchis = self.delegate?.loginResponse!(username: USERDEFAULT.string(forKey: USERNAME)!, password: USERDEFAULT.string(forKey: PASSWORD)!)
            if isMatchis! {
                print("user pass error")
            }
        }
    }
    
    @IBAction func sigInAction(_ sender: Any) {
         passwordTextField.resignFirstResponder()
        if self.delegate != nil && (self.delegate?.responds(to: #selector(KFLoginControlerDelagete.loginResponse(username:password:))))! {
            let isMatchis = self.delegate?.loginResponse!(username: userNameTextField.text!, password: passwordTextField.text!)
            if isMatchis! {
                if (userNameTextField.text?.count)! > 0 {
                    USERDEFAULT.set(userNameTextField.text!, forKey: USERNAME)
                }
                if (passwordTextField.text?.count)! > 0 {
                    USERDEFAULT.set(passwordTextField.text!, forKey: PASSWORD)
                }
            }
        }
    }
    
    func configUI(){
        
        //初始化样式
        
        if let _ = USERDEFAULT.object(forKey: HEADERDATA) {
            headerPicture.image = UIImage(data: USERDEFAULT.object(forKey: HEADERDATA) as! Data)
        }else if let _ = headerImage {
            headerPicture.image = headerImage
        } else {
            headerPicture.image = loadImage(name: "User")
        }
        
        if  (USERDEFAULT.bool(forKey: ISREMEMBERPASSWORD) &&
            (USERDEFAULT.string(forKey: HEADERURL) != nil)) &&
            (USERDEFAULT.string(forKey: HEADERURL)?.count)! > 0 {
            
            getImage(aURL:  USERDEFAULT.string(forKey: HEADERURL)!, asyncImage: { (image) in
                DispatchQueue.main.async {
                    self.headerPicture.image = image!
                }
            })
        }
        
        if USERDEFAULT.bool(forKey: ISREMEMBERPASSWORD) &&
            USERDEFAULT.string(forKey: USERNAME) != nil &&
            (USERDEFAULT.string(forKey: USERNAME)?.count)! > 0 &&
            USERDEFAULT.string(forKey: FULLNAME) != nil &&
            (USERDEFAULT.string(forKey: FULLNAME)?.count)! > 0
            {
            userFullName.text = USERDEFAULT.string(forKey: FULLNAME)
        }else{
            userFullName.text = "User";
        }
        
        if let _ = rememberTouchIDTextColor{
            rememberMoButton.setTitleColor(rememberTouchIDTextColor, for: .normal)
            userTouchIDButton.setTitleColor(rememberTouchIDTextColor, for: .normal)
        }else {
            rememberMoButton.setTitleColor(UIColor.black, for: .normal)
            userTouchIDButton.setTitleColor(UIColor.black, for: .normal)
        }
        
        if let _ = promptSubtitleTextColor {
            selectTitleLabel.textColor = promptSubtitleTextColor
        }else{
            selectTitleLabel.textColor = UIColor.aColorLightBlack
        }
        
        if  let _ = rememberTouchIDTextColorHighlighted {
            rememberMoButton.setTitleColor(rememberTouchIDTextColorHighlighted, for: .selected)
            userTouchIDButton.setTitleColor(rememberTouchIDTextColorHighlighted, for: .selected)
        }else {
            rememberMoButton.setTitleColor(UIColor.aColorMain, for: .selected)
            userTouchIDButton.setTitleColor(UIColor.aColorMain, for: .selected)
        }
        
        if let _ = fotgotPasswordTextColor {
            fotgotPassword.setTitleColor(fotgotPasswordTextColor, for: .normal)
        }else{
            fotgotPassword.setTitleColor(UIColor.aColorMain, for: .normal)
        }
        
        if let _ = switchUserTextColor {
            switchUser.setTitleColor(switchUserTextColor, for: .normal)
        }else  {
            switchUser.setTitleColor(UIColor.aColorMain, for: .normal)
        }
        
        if let _ = signinTextColor {
            sigInButton.setTitleColor(signinTextColor, for: .normal)
        }else {
            sigInButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        if let _ = signinBackgroundColor {
            sigInButton.backgroundColor = signinBackgroundColor
        }else{
            sigInButton.backgroundColor = UIColor.aColorMain
        }
        
        if let _ = signinBackgroundImage {
            sigInButton.setImage(signinBackgroundImage, for: .normal)
        }
        
        if let _ = exclamationBackgroundImage {
            exclamationImage.image = exclamationBackgroundImage
        }
        
        if let _ = x_safeBackgroundImage {
            x_safeButton.setImage(x_safeBackgroundImage, for: .normal)
        }
        
        if let _ = fotgotPasswordHidden {
            fotgotPassword.isHidden = fotgotPasswordHidden ?? false
        }
        
        if let _ = logoImageAspect {
            if UIDevice.current.userInterfaceIdiom == .pad{
                logoAspect = logoAspect.setMultiplier(multiplier: logoImageAspect!)
            }
        }
        
        if UIDevice.current.userInterfaceIdiom != .phone {
            if let _ = logoThemeImage {
                logoImage.image = logoThemeImage
            }else{
                logoImage.image = loadImage(name: "image002")
            }
            
            if let _ = backgroundImage {
                backgroundView.image = backgroundImage
            }else{
                backgroundView.image = loadImage(name: "bg")
            }
        }
        
        /******/
        
        if (USERDEFAULT.bool(forKey:ISREMEMBERPASSWORD) &&
            USERDEFAULT.string(forKey: USERNAME) != nil &&
            (USERDEFAULT.string(forKey: USERNAME)?.count)! > 0) {
            hiddenUsernameText()
        }else
        {
            showUsernameText()
        }
        
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            loginBackHeight.constant = SCREEN_HEIGHT-64 < 603 ? 603 : SCREEN_HEIGHT-64
        }else
        {
            loginBackHeight.constant = (SCREEN_HEIGHT-84)
        }
        
        selectButton.isSelected = USERDEFAULT.bool(forKey: ISREMEMBERPASSWORD)
        
        userNameTextField.placeholder = "Username"
        
        passwordTextField.placeholder = "Password"
        
        selectButton.setImage(loadImage(name: "unselect_01"), for: .normal)
        selectButton.setImage(loadImage(name: "loginselect"), for: .selected)
        
        safeView.layer.cornerRadius = 5.0;
        safeView.layer.borderColor = signinBackgroundColor?.cgColor
        safeView.layer.borderWidth = 1.0;
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String  {
            versionLabel.text = String(format: "Version %@", version)
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
extension UIViewController {
    
    func setTitle(title:String, selectImage:UIImage, normalImage:UIImage){
        self.tabBarItem.title = title
        self.tabBarItem.image = normalImage
        self.tabBarItem.selectedImage = selectImage
    }
}

extension KFLoginController {
    
    //MARK: 忘记密码Delegate
    public func fotgotPasswordResponse(username: String) {
        if self.delegate != nil && self.delegate!.responds(to: #selector(KFLoginControlerDelagete.fotgotPasswordResponse(username:))) {
            self.delegate!.fotgotPasswordResponse!(username: username)
        }
    }
    
    
    //MARK: PrivaryDelegate
    public func markingBoxDidSelected(select:Bool) {
        if self.delegate != nil && self.delegate!.responds(to: #selector(KFLoginControlerDelagete.markingBoxDidChange(select:))){
            self.delegate!.markingBoxDidChange!(select: select)
        }
    }
    
    public func confirmDidResponse() {
        praviryView.animate(.fade(way: .out), duration: 1.0, damping: 1, velocity: 2.0, force: 1)
        self.perform(#selector(removePraviry), with: nil, afterDelay: 1.0)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String  {
            if userNameTextField.text!.count > 0 {
                USERDEFAULT.set(true, forKey: version + userNameTextField.text!)
            }
        }
        
        //-------------
        if (self.delegate != nil) && (self.delegate?.responds(to: #selector(KFLoginControlerDelagete.accountAuthenticationStatus(status:))))!{
            self.delegate?.accountAuthenticationStatus!(status: self.authenticationStatus)
        }
    }
    
    
    @objc func removePraviry(){
        praviryView.removeFromSuperview()
    }
    
    //MARK: 显示和隐藏用户名输入框
    func showUsernameText(){
        userNameTextHeight.constant = 45
        userNameTextMarginTopHeight.constant = 15
        headerCenterX.constant = 0
         userNameTextField.alpha = 1
        userNameTextField.animate(.squeeze(way: .in, direction: .right), duration: 1.0, damping: 1, velocity: 2, force: 1)
        
        switchUser.isHidden = true
        headerRightView.isHidden = true
        
        userNameTextField.text = ""
        
        if let _ = USERDEFAULT.data(forKey: HEADERDATA) {
            headerPicture.image = UIImage(data: USERDEFAULT.data(forKey: HEADERDATA)!)
        }else{
            headerPicture.image = loadImage(name: "User")
        }
        
        
    }
    func hiddenUsernameText(){
        userNameTextHeight.constant = 0
        userNameTextMarginTopHeight.constant = 0
        if UIDevice.current.userInterfaceIdiom == .phone {
            headerCenterX.constant = -(SCREEN_WIDTH/5)
        }else
        {
            headerCenterX.constant = -(400/5)
        }
        
         userNameTextField.alpha = 0
        switchUser.isHidden = false
        headerRightView.isHidden = false
        
        if let _ = USERDEFAULT.string(forKey: USERNAME) {
             userNameTextField.text = USERDEFAULT.string(forKey: USERNAME)
            
            if let _ = USERDEFAULT.string(forKey: FULLNAME){
                userFullName.text = USERDEFAULT.string(forKey: FULLNAME)
            }else{
                userFullName.text = "User"
            }
            
        }else
        {
            userFullName.text = "User"
        }
        
        if let _ =  USERDEFAULT.string(forKey: HEADERURL){
            
            getImage(aURL: USERDEFAULT.string(forKey: HEADERURL)!, asyncImage: { (image) in
                DispatchQueue.main.async {
                    self.headerPicture.image = image!
                }
                
            })
        }else if USERDEFAULT.object(forKey: HEADERDATA) != nil {
            headerPicture.image = UIImage(data: USERDEFAULT.object(forKey: HEADERDATA) as! Data)
        } else {
            headerPicture.image = loadImage(name: "User")
        }
    }
    
    func getImage(aURL:String, asyncImage:@escaping(_ image:UIImage?)->()){
        //1. 本地取图片
        let imageName = (aURL as NSString).components(separatedBy: "/").last
        let path =  (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first)! as NSString
        let imageURL = path.appendingPathComponent( imageName!)
        let imageLocal = NSData(contentsOfFile: imageURL)
        if let _ = imageLocal {
            
            let image1 = UIImage(data: imageLocal! as Data)
            if let _ = image1 {
                asyncImage(image1)
            }else{
                 asyncImage(self.loadImage(name:"User"))
            }
            
        }else {
            //本地失败 先返回默认，加载完成再返回正确图片
            DispatchQueue.global().async {
                print("kaishi")
                let imageData = NSData(contentsOf: NSURL(string: aURL)! as URL)
                if let _ = imageData {
                    let match = imageData?.write(toFile: imageURL, atomically: true)
                    if match! {
                        let image1 = UIImage(data: imageData! as Data)
                      
                        if let _ = image1 {
                            asyncImage(image1)
                        }else{
                            asyncImage(self.loadImage(name:"User"))
                        }
                    }
                }else{
                    asyncImage(self.loadImage(name:"User"))
                }
            }
            
             asyncImage(self.loadImage(name:"User"))
        }
    }
    
    func generateImageWith(_ color: UIColor, andFrame frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        // 设置填充颜色
        context?.setFillColor(color.cgColor)
        // 使用填充颜色填充区域
        context?.fill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK: 指纹登录
    func touchIDLoinVerification(){
        
        let istouch = USERDEFAULT.bool(forKey:ISTOUCHIDLOGIN) && USERDEFAULT.bool(forKey: ISREMEMBERPASSWORD)
        let username = USERDEFAULT.string(forKey: USERNAME)
        let password = USERDEFAULT.string(forKey: PASSWORD)
        
        let  isContais = username != nil && username!.count > 0 && password != nil && password!.count > 0
        if !isContais {
            return
        }
        
        if istouch {
            
            passwordTextField.resignFirstResponder()
            
            let touchView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            touchView.backgroundColor = UIColor.white
            touchView.alpha = 0
            self.view.addSubview(touchView)
            
            UIView.animate(withDuration: 0.5, animations: {
                touchView.alpha = 1.0
            })
            
            
            BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
                self.touchIDLogin()
                
                UIView.animate(withDuration: 0.5, animations: {
                    touchView.alpha = 0
                }, completion: { (finish) in
                    touchView.removeFromSuperview()
                })
                
            }) { (error) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    touchView.alpha = 0
                }, completion: { (finish) in
                    touchView.removeFromSuperview()
                })
                
                // do nothing on canceled
                if error == .canceledByUser || error == .canceledBySystem {
                    return
                }
                    
                    // device does not support biometric (face id or touch id) authentication
                else if error == .biometryNotAvailable {
                    BioMetricAuthenticator.authenticateWithPasscode(reason: error.message(), success: {
                        // passcode authentication success
                         self.touchIDLogin()
                    }) { (error) in

                    }
                    
                }
                    // show alternatives on fallback button clicked
                else if error == .fallback {
                    // here we're entering username and password
                }
                    
                    // No biometry enrolled in this device, ask user to register fingerprint or face
                else if error == .biometryNotEnrolled {
                    
                }
                    // Biometry is locked out now, because there were too many failed attempts.
                    // Need to enter device passcode to unlock.
                else if error == .biometryLockedout {
                    BioMetricAuthenticator.authenticateWithPasscode(reason: error.message(), success: {
                        // passcode authentication success
                        self.touchIDLogin()
                    }) { (error) in
                        
                    }
                    
                } else {

                }
                
            }
                
            
        }
    }
}

extension NSLayoutConstraint {
    func setMultiplier(multiplier:CGFloat)->NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(item: firstItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
        
    }
    
}

extension Data{
    func hex(separator:String = "") -> String {
        return (self.map { String(format: "%02X", $0) }).joined(separator: separator)
    }
}

