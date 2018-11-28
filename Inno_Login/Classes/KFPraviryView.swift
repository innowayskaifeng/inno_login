//
//  KFPraviryView.swift
//  Alamofire
//
//  Created by Innoer_kf on 2018/6/7.
//

import UIKit
import IBAnimatable

@objc public enum PraviryType:Int {
    case disAgree
    case agree
}


@objc public protocol KFPraviryViewDelegate :NSObjectProtocol {
    
    @objc optional func confirmDidResponse()
    
    @objc optional func markingBoxDidSelected(select:Bool)->()
    
}

class KFPraviryView: AnimatableView {
    
    @objc public weak var delegate:KFPraviryViewDelegate?
    
    
    @IBOutlet weak var scrollerHeight: NSLayoutConstraint!
    
    var privaryTitleText:String?{
        didSet{
            
        }
        
    }
    var privaryContentText:String?{
        didSet{
            
        }
    }
    
    var privaryCompantName:String?{
        didSet{
            
        }
    }
    
    @IBOutlet weak var privaryText: UILabel!
    
    @IBOutlet weak var agreeOutlet: UIButton!
    
    @IBOutlet weak var privaryBoxButton: UIButton!
    
    @IBOutlet weak var privaryBoxLabel: UILabel!
    
    @IBOutlet weak var markingBoxLabel: UILabel!
    
    @IBOutlet weak var markingBoxButton: UIButton!
    
    class func loadFormNib() -> KFPraviryView {
        let podBundle = Bundle(for: KFPraviryView.self)
        let bundleURL = podBundle.url(forResource: "Inno_Login", withExtension: "bundle")
        let bund = Bundle(url: bundleURL!)!
        
        let view = bund.loadNibNamed("KFPraviryView", owner: nil, options: nil)?.first as! KFPraviryView
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return view
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        markingBoxButton.setImage(loadImage(name: "checkbox-unchecked@2x"), for: .normal)
        markingBoxButton.setImage(loadImage(name: "checkbox-partial@2x"), for: .selected)
        
        privaryBoxButton.setImage(loadImage(name: "checkbox-unchecked@2x"), for: .normal)
        privaryBoxButton.setImage(loadImage(name: "checkbox-partial@2x"), for: .selected)
        
        privaryBoxButton.addTarget(self, action: #selector(privaryBoxAction), for: .touchUpInside)
        
        markingBoxButton.addTarget(self, action: #selector(markingBoxAction), for: .touchUpInside)
        
        agreeOutlet.isSelected = privaryBoxButton.isSelected
        agreeOutlet.isUserInteractionEnabled = agreeOutlet.isSelected
        
        setText()
    }
    
    @objc func privaryBoxAction(_ button:UIButton){
        button.isSelected = !button.isSelected
        agreeOutlet.isSelected = privaryBoxButton.isSelected
        agreeOutlet.isUserInteractionEnabled = agreeOutlet.isSelected
        
    }
    
    @objc func markingBoxAction(_ button:UIButton){
        button.isSelected = !button.isSelected
        
        if self.delegate != nil &&
            (self.delegate?.responds(to: #selector(KFPraviryViewDelegate.markingBoxDidSelected(select:))))!{
            self.delegate?.markingBoxDidSelected!(select: markingBoxButton.isSelected)
        }
        
    }
    
    func loadImage(name:String)->UIImage?{
        let podBundle = Bundle(for: KFPraviryView.self)
        let bundleURL = podBundle.url(forResource: "Inno_Login", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        let path = bundle.path(forResource: name, ofType: "png")
        let image = UIImage(contentsOfFile: path!)
        return image
    }
    
    func setText(){
        
        var title = ""
        var content = ""
        var company = "i-RMS"
        
        if let _ = privaryTitleText {
            title = privaryTitleText! + "\n"
        }
        
        if let _ = privaryContentText {
            content = privaryContentText!
        }
        
        if let _ = privaryCompantName {
            company = privaryCompantName!
        }
        
        let attriStr = title + content
        
        if attriStr.count <= 0 {
            return
        }
        
        //标题
        let paragraphTitle = NSMutableParagraphStyle()
        paragraphTitle.alignment = NSTextAlignment.center
        paragraphTitle.lineSpacing = 15
        
        //内容
        let paragraphContent = NSMutableParagraphStyle()
        paragraphContent.lineSpacing = 3 //段落行间距
        paragraphContent.paragraphSpacing = 7 //段落间距
        paragraphContent.firstLineHeadIndent = 35 //首行缩进
        paragraphContent.headIndent = 8
        
        let attributeString = NSMutableAttributedString(string: attriStr)
        
        attributeString.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18.0),NSAttributedString.Key.foregroundColor:UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0),NSAttributedString.Key.paragraphStyle:paragraphTitle], range: NSMakeRange(0, title.count))//设置标题字体大小
        
        attributeString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.0),NSAttributedString.Key.foregroundColor:UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0),NSAttributedString.Key.paragraphStyle:paragraphContent], range: NSMakeRange(title.count, attriStr.count - title.count))//设置内容
        
        privaryText.attributedText = attributeString
        
        let size = privaryText.sizeThatFits(CGSize(width: SCREEN_WIDTH-32, height: CGFloat(MAXFLOAT)))
        
        scrollerHeight.constant = size.height
        
        // check box
        let paragraphCompany = NSMutableParagraphStyle()
        paragraphCompany.alignment = NSTextAlignment.left
        
        let privaryBoxText = "I agree to " + company + "’s privacy policy and understand that the use of my personal data is required to conduct authorized services."
        let attributePrivary = NSMutableAttributedString(string:privaryBoxText)
        attributePrivary.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12.0),NSAttributedString.Key.foregroundColor : UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0),NSAttributedString.Key.paragraphStyle:paragraphTitle], range: NSMakeRange(11, company.count))
        
        let markingBoxText = "I do not wish to receive any marketing materials from " + company + " at this time."
        let attributemarking = NSMutableAttributedString(string:markingBoxText)
        attributemarking.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12.0),NSAttributedString.Key.foregroundColor : UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0),NSAttributedString.Key.paragraphStyle:paragraphTitle], range: NSMakeRange(54, company.count))
        
        privaryBoxLabel.attributedText = attributePrivary
        markingBoxLabel.attributedText = attributemarking
        
    }
    
    
    @IBAction func agree(_ sender: Any) {
        if (self.delegate != nil) && (self.delegate?.responds(to: #selector(KFPraviryViewDelegate.confirmDidResponse)))! {
            self.delegate?.confirmDidResponse!()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addConstraints()
    }
    
    func addConstraints(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: self as Any, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0)
        addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: self as Any, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0)
        addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: self as Any, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
        addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: self as Any, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
        addConstraint(constraint)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
}
































