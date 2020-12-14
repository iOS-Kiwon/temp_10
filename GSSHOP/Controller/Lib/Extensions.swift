//
//  Extensions.swift
//  GSSHOP
//
//  Created by Kiwon on 29/05/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit


// MARK:- String
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
    
    var convertKoreanURL: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) ?? self
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    var localized: String {
        let language = "ko"
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        return NSLocalizedString(self, bundle: bundle, comment: "")//NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
    
    func isThisValidWithZeroStr() -> Bool {
        //nil체크
        if self.isEmpty { return false }
        do {
            let regex = try NSRegularExpression(pattern: "[0-9]", options: .caseInsensitive)
            let numberOfMatches = regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.count) )
            if numberOfMatches == self.count, self.isInt {
                return true
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
        }
        return false
    }
    
    /// HexChacker
    func isValidHexNumber() -> Bool {
        if self.isEmpty { return false }
        do {
            let pattern = "[0-9a-f]"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex.numberOfMatches(in: self.lowercased(), options: [], range: NSRange(location: 0, length: self.count))
            if matches == self.count {
                return true
            }
        }
        catch (let error){
            print("Vaild Hex Error : \(error.localizedDescription)")
            return false
        }
        return false
    }
    
    /// 사용자 ID 별표 표시
    func getIDMask() -> String {
        
        let userIdArr = self.components(separatedBy: "@")
        if userIdArr.count == 2, let userId = userIdArr.first, let email = userIdArr.last {
            // 이메일 형식
            
            if userId.count >= 2, userId.count <= 3 {
                // 2~3자 인 경우 : 앞 1자리만 노출
                let maskStartIndex = userId.index(userId.startIndex, offsetBy: 1)
                let maskStr = userId[maskStartIndex...]
                let starStr = String(repeating: "*", count: maskStr.count)
                
                let maskResultStr = userId.replacingOccurrences(of: maskStr, with: starStr)
                
                return maskResultStr + "@" + email
                
            } else if userId.count >= 4 {
                // 4자 이상인 경우 : 앞 2자리만 노출
                let maskStartIndex = userId.index(userId.startIndex, offsetBy: 2)
                let maskStr = userId[maskStartIndex...]
                let starStr = String(repeating: "*", count: maskStr.count)
                
                let maskResultStr = userId.replacingOccurrences(of: maskStr, with: starStr)
                
                return maskResultStr + "@" + email
            } else {
                // 나머지 (1자리인 이메일이 있는가..?) : *@gmail.com
                return "*@" + email
            }
            
        } else {
            // 일반 ID
            if self.count >= 4, self.count <= 5 {
                // 4~5자리 인 경우 : 뒤에 3자리만 마스킹
                let maskStartIndex = self.index(self.startIndex, offsetBy: self.count - 3)
                let maskStr = self[maskStartIndex...]
                let starStr = String(repeating: "*", count: maskStr.count)
                
                let maskResultStr = self.replacingOccurrences(of: maskStr, with: starStr)
                
                return maskResultStr
            } else if self.count >= 6 {
                // 6자리 인 경우 : 앞 3자리만 노출
                let maskStartIndex = self.index(self.startIndex, offsetBy: 3)
                let maskStr = self[maskStartIndex...]
                let starStr = String(repeating: "*", count: maskStr.count)
                
                let maskResultStr = self.replacingOccurrences(of: maskStr, with: starStr)
                
                return maskResultStr
            } else {
                // 나머지 : 무조건 3자리 마스킹
                return "***"
            }
            
        }
    }
}


extension NSMutableAttributedString {
    /// AttributeString에 최소 높이값 설정
    func setMinimumLineHeight(_ value: CGFloat) {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = value
        self.addAttribute(
            .paragraphStyle, value: style,
            range: NSRange(location:0,
                           length: self.length))
    }
}


// MARK:- Int
extension Int {
    var toString: String {
        return String(self)
    }
}

// MARK:- Date
extension Date {
    func secondsFromBeginningOfTheDay() -> TimeInterval {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!
        return TimeInterval(dateSeconds)
    }

    func timeOfDayInterval(toDate date: Date) -> TimeInterval {
        let date1Seconds = self.secondsFromBeginningOfTheDay()
        let date2Seconds = date.secondsFromBeginningOfTheDay()
//        if date2Seconds > date1Seconds {
//            return date2Seconds - date1Seconds
//        } else {
            return date1Seconds -  date2Seconds
//        }
    }
}

// MARK:- TimeInterval
extension TimeInterval {
    
    func getPlayerLeftTime(videoType type: VideoType, isFullScreen: Bool = false) -> String {
        let leftTime = type == .live ? "00:00:00" : "0:00"
        
        if self.isNaN || self.isInfinite {
            return leftTime
        }
        
        let nf1 = NumberFormatter()
        nf1.paddingCharacter = "0"
        if isFullScreen {
            nf1.minimumIntegerDigits = 2
        } else {
            nf1.minimumIntegerDigits = 1
        }
        
        let nf2 = NumberFormatter()
        nf2.paddingCharacter = "0"
        nf2.minimumIntegerDigits = 2
        
        if self <= 0 {
            return leftTime
        }
        
        let hours = Int(self / 60.0 / 60.0)
        var minutes = Int(self / 60.0) % 60
        let seconds = Int(self) % 60
        
        if type == .brightCove || type == .mp4 {
            
            if Int(hours) > 0 {
                minutes = minutes + (Int(hours) * 60)
            }
            
            if let minutesStr = nf1.string(from: NSNumber(value: minutes)),
                let secondsStr = nf2.string(from: NSNumber(value: seconds)) {
                
                return "\(minutesStr):\(secondsStr)"
            }
        } else {
            if let hourStr = nf2.string(from: NSNumber(value: hours)),
                let minutesStr = nf2.string(from: NSNumber(value: minutes)),
                let secondsStr = nf2.string(from: NSNumber(value: seconds)) {
                return "\(hourStr):\(minutesStr):\(secondsStr)"
            }
        }
        
        return leftTime
    }
}

// MARK:- Collection
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK:- UIColor
extension UIColor {
    /// HEX  투명도 지원합니다 0a투명도 111111 색상 0a111111
    @objc static func getColor(_ hex: String, alpha: CGFloat = 1.0, defaultColor: UIColor = .black) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if !cString.isValidHexNumber() {
            return defaultColor
        }
        
        if ((cString.count) == 6) {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha
            )
        }
        else if ((cString.count) == 8) {
            var argbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&argbValue)
            
            return UIColor(
                red: CGFloat((argbValue & 0x00FF0000) >> 16) / 255.0,
                green: CGFloat((argbValue & 0x0000FF00) >> 8) / 255.0,
                blue: CGFloat(argbValue & 0x000000FF) / 255.0,
                alpha: CGFloat((argbValue & 0xFF000000) >> 24) / 255.0
            )
        }
        else {
            return defaultColor
        }
    }
  
}

// MARK:- NSObject
extension NSObject {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
    
    static var className: String {
        return self.reusableIdentifier
    }
    
    
    func getAttributedString(withPrdTextInfo textInfo: PrdTextInfo, fontSize: CGFloat? = nil) -> NSMutableAttributedString {
        var size: CGFloat = .zero
        if fontSize != nil {
            size = fontSize!
        } else {
            size = CGFloat( NSString(string: textInfo.fontSize).floatValue)
        }
        let attrString = NSMutableAttributedString(
            string: textInfo.textValue,
            attributes: [
                .font : UIFont.systemFont(ofSize: size, weight: "Y" == textInfo.boldYN ? .bold : .regular),
                .foregroundColor : UIColor.getColor(textInfo.textColor, defaultColor: .black)
        ])
        
        return attrString
    }
    
    /// 텍스트속 가장 큰 폰트 높이를 찾는다.
    func findMinimumLineHeight(_ textList: [PrdTextInfo]) -> CGFloat {
        var rSize:CGFloat = .zero
        for text in textList {
            if text.textValue.isEmpty {
                continue
            }
            let fontsize = CGFloat( NSString(string: text.fontSize).floatValue)
            if fontsize > rSize {
                rSize = fontsize
            }
        }
        return rSize
    }
    
    /// 높이 기준으로 너비값을 비율로 계산하여 반환한다.
    func makeRadioWidth(_ imgSize:CGSize, standardHeigth:CGFloat) -> CGFloat {
        let imgW = imgSize.width/2
        let imgH = imgSize.height/2
        // 높이고정 폭 변동 처리 로직
        let logoWidth = imgH >= standardHeigth ? imgW * (standardHeigth/imgH) : imgW
        return logoWidth
    }
    
    var applicationDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

// MARK:- UIButton
extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
    
    /// 찜 버튼 설정
    func setZzim(data: Module) {
        if let value = data.isWish {
            self.isHidden = false
            self.isAccessibilityElement = true
            
            if value {
                self.isSelected = true
                self.accessibilityLabel = Const.Text.zzim_off.name
            } else {
                self.isSelected = false
                self.accessibilityLabel = Const.Text.zzim_on.name
            }
        } else {
            self.isHidden = true
            self.isAccessibilityElement = false
        }
    }
    
    /// 장바구니 버튼 설정
    func setBasket(data: Module) {
        if !data.basket.url.isEmpty {
            self.isHidden = false
            self.isAccessibilityElement = true
            self.accessibilityLabel = Const.Text.basket_add.name
        } else {
            self.isHidden = true
            self.isAccessibilityElement = false
            self.accessibilityLabel = ""
        }
    }
}

// MAKR:- UILabel
extension UILabel {
    func getLinesArrayOfString() -> [String] {
        
        /// An empty string's array
        var linesArray = [String]()
        
        guard let text = self.text, let font = self.font else {return linesArray}
        
        let rect = self.frame
        
        let myFont: CTFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: myFont, range: NSRange(location: 0, length: attStr.length))
        
        let frameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path: CGMutablePath = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: 100000), transform: .identity)
        
        let frame: CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        guard let lines = CTFrameGetLines(frame) as? [Any] else {return linesArray}
        
        for line in lines {
            let lineRef = line as! CTLine
            let lineRange: CFRange = CTLineGetStringRange(lineRef)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString: String = (text as NSString).substring(with: range)
            linesArray.append(lineString)
        }
        return linesArray
    }
    
    /// 순위 설정
    func setRank(data: Module) {
        if let badgeLT = data.imgBadgeCorner.LT.first {
            self.isHidden = false
            self.text = badgeLT.text
        }
    }
    
    /// 판매가격 설정
    func setSalePrice(data: Module, priceFontSize: CGFloat = 19.0, exposeFontSize: CGFloat = 14.0,  exposeBaseOffset: CGFloat = 0.5) {
        var preText:String = ""
        var priceText:String = ""
        var won:String = ""       
        
        // R 렌탈, A,U 숙박, T 여행, S,U 시공
        if (data.deal == true && (data.productType == "R" || data.productType == "T" || data.productType == "U" || data.productType == "S"))
        || (data.deal == false && data.productType == "R") { //렌탈
             //항목1 무언가 써있으면???
            if data.productType == "R", data.rentalText.isEmpty == false {
                //항목1에 "월 렌탈료"가 써있으면 -> "월"로 변경 , 월 일경우에도 추가
                if data.rentalText == "월 렌탈료" || data.rentalText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "월" {
                    preText = "월"
                    //"월" + 항목2(rRentalPrice) 값이 있으면 뿌린다
                    if data.mnlyRentCostVal.isEmpty == false && !data.mnlyRentCostVal.hasPrefix("0") {
                        preText = preText + " "
                        priceText = data.mnlyRentCostVal
                    }
                    else { //렌탈이지만 "월 렌탈료"가 안써있으면 다 우지고 "상담 전용 상품입니다." 세긴다.
                        //상담전용상품
                        preText = Const.Text.advice_only.name
                    }
                }
                else {//rentalText 비어있음
                    //렌탈인데 월이 아니면,
                    if data.mnlyRentCostVal.isEmpty == false && !data.mnlyRentCostVal.hasPrefix("0") {
                        priceText = data.mnlyRentCostVal
                    }
                    else { //"월" 을 지우고, "상담 전용 상품입니다." 세긴다.
                        preText = Const.Text.advice_only.name
                    }
                }
            }
            else if data.mnlyRentCostVal.isEmpty == false && !data.mnlyRentCostVal.hasPrefix("0") {
                priceText = data.mnlyRentCostVal
            }
            else {//렌탈이지만 "월 렌탈료"가 안써있으면 다 우지고 "상담 전용 상품입니다." 세긴다.
                preText = Const.Text.advice_only.name
            }
        }
        else if data.productType == "I" {
            ////보험일때, 계속 추가 할게요
            //가격 비노출
            preText = ""
            priceText = ""
        }
        else {
            //정상일때
            //preText = data.valueText.isEmpty ? "" : data.valueText + " "
            priceText = data.salePrice
            won = data.exposePriceText
        }
        
        let rentalString = NSMutableAttributedString(string: preText, attributes: [
            .font: UIFont.systemFont(ofSize: 16.0, weight: .bold),
            .foregroundColor: UIColor.getColor("111111"),
            .baselineOffset: 0.5
            ])
        
        let attributedString = NSMutableAttributedString(string: priceText, attributes: [
            .font: UIFont.systemFont(ofSize: priceFontSize, weight: .bold),
            .foregroundColor: UIColor.getColor("111111")
            ])
        
        if !won.isEmpty {
            let lastString = NSMutableAttributedString(string: won, attributes: [
                    .font: UIFont.systemFont(ofSize: exposeFontSize),
                    .baselineOffset: exposeBaseOffset,
                    .foregroundColor: UIColor.getColor("111111")
                    ])
            attributedString.append(lastString)
        }
        
        attributedString.insert(rentalString, at: 0)
        
        self.attributedText = attributedString
    }
    
    
    /// 판매가격 + 할인율 + 기존가격 통합 설정
    func setSalePriceAndRate(data: Module, labelWidth: CGFloat) {
        
        var preText:String = ""
        var priceText:String = ""
        var won:String = ""
        if (data.deal == true && (data.productType == "R" || data.productType == "T" || data.productType == "U" || data.productType == "S"))
            || (data.deal == false && data.productType == "R") { //렌탈
            //항목1 무언가 써있으면???
            if data.productType == "R", data.rentalText.isEmpty == false {
                //항목1에 "월 렌탈료"가 써있으면 -> "월"로 변경
                if data.rentalText == "월 렌탈료" || data.rentalText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "월" {
                    preText = "월"
                    //"월" + 항목2(rRentalPrice) 값이 있으면 뿌린다
                    if data.mnlyRentCostVal.isEmpty == false && !data.mnlyRentCostVal.hasPrefix("0") {
                        preText = preText + " "
                        priceText = data.mnlyRentCostVal
                    }
                    else { //렌탈이지만 "월 렌탈료"가 안써있으면 다 우지고 "상담 전용 상품입니다." 세긴다.
                        //상담전용상품
                        preText = Const.Text.advice_only.name
                    }
                }
                else {//rentalText 비어있음
                    //렌탈인데 월이 아니면,
                    if data.mnlyRentCostVal.isEmpty == false && !data.mnlyRentCostVal.hasPrefix("0") {
                        priceText = data.mnlyRentCostVal
                    }
                    else { //"월" 을 지우고, "상담 전용 상품입니다." 세긴다.
                        preText = Const.Text.advice_only.name
                    }
                }
            }
            else {//렌탈이지만 "월 렌탈료"가 안써있으면 다 우지고 "상담 전용 상품입니다." 세긴다.
                preText = Const.Text.advice_only.name
            }
        }
        else if data.productType == "I" {
            ////보험일때, 계속 추가 할게요
            //가격 비노출
            preText = ""
            priceText = ""
        }
        else {
            //정상일때
            //preText = data.valueText.isEmpty ? "" : data.valueText + " "
            priceText = data.salePrice
            won = data.exposePriceText
        }
        
        let rentalString = NSMutableAttributedString(string: preText, attributes: [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .bold),
            .foregroundColor: UIColor.getColor("111111"),
            .baselineOffset: 0.5
            ])
        
        let attributedString = NSMutableAttributedString(string: priceText, attributes: [
            .font: UIFont.systemFont(ofSize: 19.0, weight: .bold),
            .foregroundColor: UIColor.getColor("111111")
            ])
        
        if !won.isEmpty {
            let lastString = NSMutableAttributedString(string: won, attributes: [
                .font: UIFont.systemFont(ofSize: 14.0),
                .baselineOffset: 0.5,
                .foregroundColor: UIColor.getColor("111111")
                ])
            attributedString.append(lastString)
        }
        
        attributedString.insert(rentalString, at: 0)
        
        
        // ------------------
        // 이하 글자 길이 계산 로직
        // Default Label
        let defaultLbl = UILabel(frame: self.frame)
        
        // 글자 총 길이
        var textWidth: CGFloat = 0.0
        
        // 가격
        let priceDefaultString = NSMutableAttributedString.init(attributedString: attributedString)
        
        // 3pt 마진 생성을 위한 임시 String
        let spaceString = NSMutableAttributedString(string: " ", attributes: [
            .font: UIFont.systemFont(ofSize: 10.0),
            .foregroundColor: UIColor.clear])
        
        // 할인율
        var rateDefaultString = NSMutableAttributedString.init()
        var baseDefaultString = NSMutableAttributedString.init()
        if data.discountRate > 0 {
            rateDefaultString = NSMutableAttributedString(string: "\(data.discountRate)%", attributes: [
                .font: UIFont.systemFont(ofSize: 12.0, weight: .bold),
                .foregroundColor: UIColor.getColor("ee1f60"),
                .baselineOffset: 2.5
                ])
            
            // 3pt 마진
            priceDefaultString.append(spaceString)
            
            // 할인율 추가
            priceDefaultString.append(rateDefaultString)
            
            // 3pt 마진
            priceDefaultString.append(spaceString)
            
            // 기본가격
            baseDefaultString = NSMutableAttributedString(string: data.basePrice + data.exposePriceText, attributes: [
                .font: UIFont.systemFont(ofSize: 12.0),
                .foregroundColor: UIColor.getColor("111111",alpha: 0.48),
                .baselineOffset: 2.5,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                ])
            priceDefaultString.append(baseDefaultString)
        }
        
        defaultLbl.attributedText = priceDefaultString
        textWidth = defaultLbl.intrinsicContentSize.width
        
        
        if data.productType == "R" || labelWidth > textWidth {
            let attributeStr = NSMutableAttributedString(attributedString: defaultLbl.attributedText ?? .init())
            self.numberOfLines = 1
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.lineBreakMode = .byCharWrapping
            style.maximumLineHeight = 23.0
            attributeStr.addAttribute(
                .paragraphStyle, value: style, range: NSRange(location:0,
                                                              length: attributeStr.length))
            self.attributedText = attributeStr
        } else {
            self.numberOfLines = 2
            let newPriceDefaultString = NSMutableAttributedString.init(attributedString: attributedString)
            self.attributedText = newPriceDefaultString
            let priceString = self.text ?? ""
            
            let enterString = NSMutableAttributedString(string: "\n", attributes: [
                .font: UIFont.systemFont(ofSize: 19.0, weight: .bold),
                .foregroundColor: UIColor.getColor("111111")])
            newPriceDefaultString.append(enterString)
            newPriceDefaultString.append(rateDefaultString)
            newPriceDefaultString.append(spaceString) // 3pt 마진
            newPriceDefaultString.append(baseDefaultString)
            
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.minimumLineHeight = 23.0
            style.maximumLineHeight = 45.0
            newPriceDefaultString.addAttribute(
                .paragraphStyle, value: style, range: NSRange(location:0,
                                                              length: newPriceDefaultString.length))
            newPriceDefaultString.addAttribute(
                .baselineOffset, value: 0.0, // 3.5,
                range: NSRange(location: priceString.count,
                               length: newPriceDefaultString.length - priceString.count))
            
            self.attributedText = newPriceDefaultString
        }
    }
    
    /// Objc용
    @objc func setSalePriceAndRate(dic: Dictionary<String, Any>) -> NSAttributedString {
        guard let prdData = Module(JSON: dic) else { return NSAttributedString() }
        // 127 : 이미지뷰, 16*2 : 양쪽여백, 12 : 이미지와 라벨사이
        let width = CGFloat( getAppFullWidth() - 127 - (16 * 2) - 12)
        let label = UILabel()
        
        label.setSalePriceAndRate(data: prdData, labelWidth: width)
        return self.attributedText ?? NSAttributedString()
    }
    
    
    /// 할인율 설정
    func setDiscountRate(withBaseLabel baseLabel: UILabel, data: Module, fontSize: CGFloat = 12.0) {
        // 할인율이 0% 초과인 경우만 노출
        if data.discountRate > 0 {
            // 할인율
            let rateAttributedString = NSMutableAttributedString(string: data.discountRate.toString + "%", attributes: [
                .font: UIFont.boldSystemFont(ofSize: fontSize),
                .foregroundColor: UIColor.getColor("ee1f60")
                ])
            self.attributedText = rateAttributedString
            
            // Base 가격
            let attributedString = NSMutableAttributedString(string: data.basePrice + data.exposePriceText, attributes: [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: UIColor.getColor("111111",alpha: 0.48),
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .baselineOffset: 0 //iOS 10.3.* 버전에서 이값이 같이 설정되어 있지 않으면 위에 strike 설정이 되지 않는다.
                ])
            
            baseLabel.attributedText = attributedString
        }
    }
    
    /// 상품명 설정
    func setProductName(data: Module, isShowTF: Bool = true, fontSize: CGFloat = 16.0) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        let attributeString = NSMutableAttributedString(string: (isShowTF ? data.brandNm + (data.brandNm.isEmpty ? "":" ") : "") + data.productName, attributes: [
        //let attributeString = NSMutableAttributedString(string: data.productName, attributes: [
            .font: UIFont(name: "HelveticaNeue", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.getColor("111111"),
            .paragraphStyle: paragraphStyle,
            ])
            if isShowTF {
                attributeString.addAttributes([
                    .font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.heavy),
                    .foregroundColor: UIColor.getColor("111111")
                    ], range: NSRange(location: 0, length: data.brandNm.count))
            }
        self.attributedText = attributeString
        
        // line Break 설정
        self.lineBreakMode = .byTruncatingTail
    }
    
    
    /// 혜택 설정
    func setBenefit(data: Module, labelWidth: CGFloat, lineLimit: Int = 2) {
        // TV상품(구, TV쇼핑 문구)
        self.attributedText = Common_Util.attributedBenefitString(data.toJSON(), widthLimit: labelWidth, lineLimit: lineLimit)
    }
    
    /// 상품 평점 설정
    func setReviewAverage(data: Module) {
        self.textColor = UIColor.getColor("111111", alpha: 0.64)
        
        if data.addTextLeft.isEmpty {
            self.isHidden = true // 이걸 여기서 하는게 맞는지 의문이긴함. 편해서 넣음
            self.text = ""
        }
        else {
            self.isHidden = false
            self.text = data.addTextLeft
        }
    }
    
    /// 구매개수 설정
    func setReviewCount(data: Module) {
        if data.addTextRight.isEmpty {
            self.text = ""
            self.isHidden = true
            return
        }
        self.isHidden = false
        self.textColor = UIColor.getColor("111111", alpha: 0.48)
        self.text = data.addTextRight
    }
    
    /// 프로모션 캐로셀 타이틀 라벨 설정
    func setPromotionTitle(data: Module) {
        let attributedString = NSMutableAttributedString(string: data.productName)
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.minimumLineHeight = 29.0
        style.maximumLineHeight = 58.0
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 20.0, weight: .semibold),
            .foregroundColor: UIColor.getColor("514846"),
            .paragraphStyle : style
            ], range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    /// 프로모션 캐로셀 서브 타이틀 라벨 설정
    func setPromotionSubTitle(data: Module) {
        let attributedString = NSMutableAttributedString(string: data.productName)
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.minimumLineHeight = 20.0
        style.maximumLineHeight = 40.0
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 16.0, weight: .regular),
            .foregroundColor: UIColor.getColor("514846"),
            .paragraphStyle : style
            ], range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    /// 프로모션 캐로셀 Brand형 타이틀 라벨 설정
    func setPromotionBrandTitle(data: Module) {
        self.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        self.textAlignment = .left
        self.textColor = .white
        self.numberOfLines = 1
        self.text = data.productName
    }
    
    
    /// 타이틀 & 서브타이틀 설정
    func setTitle(_ titleStr: String, withSubTitle subStr: String) {
        let totalAttributedStr = NSMutableAttributedString(string: titleStr)
        totalAttributedStr.addAttributes([
            .font: UIFont.systemFont(ofSize: 17.0, weight: .bold),
            .foregroundColor: UIColor.getColor("111111")
            ], range: NSMakeRange(0, totalAttributedStr.length))
        
        let spaceAttributedStr = NSMutableAttributedString(string: "  ")
        if subStr.isEmpty == false {
            spaceAttributedStr.addAttributes([
                .font: UIFont.systemFont(ofSize: 15.0, weight: .regular)
            ], range:  NSMakeRange(0, 1))
            totalAttributedStr.append(spaceAttributedStr)
            
            let subAttributedStr = NSMutableAttributedString(string: subStr)
            subAttributedStr.addAttributes([
                .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                .foregroundColor: UIColor.getColor("111111", alpha: 0.64),
                .baselineOffset: 1.5
                ], range: NSMakeRange(0, subAttributedStr.length))
            totalAttributedStr.append(subAttributedStr)
        }
        
        self.attributedText = totalAttributedStr
    }
    
    /// 제한된 width에 나타나는 Label높이값 계산
    func getAttributedHeight(limiteWidth width: CGFloat) -> CGFloat {
        let baseFrame = CGRect(x: 0, y: 0, width: width, height: 0.0)
        let baseLabel = UILabel(frame: baseFrame)
        
        if let attrStr = self.attributedText {
            baseLabel.attributedText = attrStr
            return baseLabel.intrinsicContentSize.height
        }
        
        baseLabel.text = self.text
        return baseLabel.intrinsicContentSize.height
        
    }
    
    /// 현재 Label에서 Line수 가져오기
    func getLines() -> Int {
        let heightFixSize = CGSize(width: CGFloat(Float.infinity), height: frame.size.height)
        var lineHeight: CGFloat = .zero
        
        if let attrString = self.attributedText {
            lineHeight = attrString.boundingRect(with: heightFixSize, options: .usesLineFragmentOrigin, context: nil).height
        } else if let text = self.text {
            lineHeight = text.boundingRect(with: heightFixSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).height
        } else {
            return .zero
        }
        
        if lineHeight >= heightFixSize.height {
            return 1
        }
        
        // 소수점 버림
        let lineCount = Int(trunc(frame.height / lineHeight))
        return lineCount
    }
    
    /// 글짜에 그림자 설정
    func setFontShadow(color: UIColor, alpha: Float = 1.0, x: CGFloat = 0, y: CGFloat = 0, blur: CGFloat = 0, spread: CGFloat = 0) {
        self.layer.shadowColor = color.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shadowRadius = blur / 2.0
        self.layer.shadowOpacity = alpha
        
        if spread == 0 {
            self.layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    //특정 키워드 색상 변경
    @objc func changeAllOccurrence(entireString: String, searchString: String ){
            let attrStr = NSMutableAttributedString(string: entireString)
            let entireLength = entireString.count
            var range = NSRange(location: 0, length: entireLength)
            var rangeArr = [NSRange]()
            
            while (range.location != NSNotFound) {
                
                range = (attrStr.string as NSString).range(of: searchString, options: .caseInsensitive, range: range)
                rangeArr.append(range)

                if (range.location != NSNotFound) {
                    range = NSRange(location: range.location + range.length, length: entireString.count - (range.location + range.length))
                    
                }
                
            }
            rangeArr.forEach { (range) in
                attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.getColor("111111"), range: range)
                attrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .heavy), range: range)
            }
            self.attributedText = attrStr
    }
}

// MARK:- UIImageView
extension UIImageView {
    /// 이미지 설정
    func setImgView(adultImg: UIImage?, data: Module, isBorder: Bool = true) {
        // 테두리
        if isBorder {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.getColor("000000", alpha: 0.06).cgColor
        }        
        
        //19금 처리
        if data.adultCertYn == "Y", Common_Util.isthisAdultCerted() == false {
            self.image = adultImg
            return
        }
        
        // 이미지 설정
        ImageDownManager.blockImageDownWithURL(data.imageUrl as NSString) { (httpStatusCode, fetchedImage, imageUrl, isInCache, error) in
            if error == nil, data.imageUrl == imageUrl, let image = fetchedImage {
                DispatchQueue.main.async {
                    if isInCache == true {
                        self.image = image
                    }
                    else {
                        self.alpha = 0
                        self.image = image
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                            self.alpha = 1
                        })
                    }
                }//dispatch
            }//if
        }
    }
    
    /// PMO_T1_PREVIEW_B의 이미지 설정
    func setImgView(downloadUrl urlStr: String, defaultImg: UIImage?) {
        // 이미지 설정
        ImageDownManager.blockImageDownWithURL(urlStr as NSString) { (httpStatusCode, fetchedImage, imageUrl, isInCache, error) in
            if error == nil, urlStr == imageUrl, let image = fetchedImage {
                DispatchQueue.main.async {
                    if isInCache == true {
                        self.image = image
                    }
                    else {
                        self.alpha = 0
                        self.image = image
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                            self.alpha = 1
                        })
                    }
                }//dispatch
            } else {
                if let defaultImage = defaultImg {
                    self.image = defaultImage
                }
            }
        }
    }
    
    /// 재생이미지 설정
    func setPlayImgView( data: Module) {
        if data.hasVod {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
}

extension UIView {
    
    func setShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = blur / 2.0
        if spread != 0 {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func setCorner(radius: CGFloat? = nil) {
        if let value = radius {
            self.layer.cornerRadius = value
        } else {
            self.layer.cornerRadius = self.frame.height / 2
        }
        self.clipsToBounds = true
    }
    
    
    func setCorner(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @objc func setBorder(width: CGFloat = 1.0, color: String = "000000") {
        self.setBorder(width: width, color: color, alpha: 0.06)
    }
    
    @objc func setBorder(width: CGFloat = 1.0, color: String = "000000", alpha: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor =  UIColor.getColor(color, alpha: alpha).cgColor
    }
    
    /// 일시품절 설정
    func setSoldOut(viewHeightConstraint: NSLayoutConstraint, data: Module, height: CGFloat = 24.0) {
        if data.imageLayerFlag == "SOLD_OUT" {
            self.isHidden = false
            viewHeightConstraint.constant = height
        } else {
            self.isHidden = true
            viewHeightConstraint.constant = 0.0
        }
    }
    
    /// 방송시간 설정
    func setBroadTime(withLabel label: UILabel,
                          viewHeightConstraint: NSLayoutConstraint, data: Module, height: CGFloat =  24.0) {
        if !data.broadTimeText.isEmpty {
            self.isHidden = false
            label.font = UIFont.systemFont(ofSize: 13.0)
            label.textColor = .white
            label.text = data.broadTimeText
            viewHeightConstraint.constant = height
        } else {
            self.isHidden = true
            label.text = ""
            viewHeightConstraint.constant = 0.0
        }
    }
    
    /// 방송중 구매가능 설정
    func setBroadBuy( viewHeightConstraint: NSLayoutConstraint, data: Module, height: CGFloat =  24.0) {
        if data.imageLayerFlag == "AIR_BUY" {
            self.isHidden = false
            viewHeightConstraint.constant = height
        } else {
            self.isHidden = true
            viewHeightConstraint.constant = 0.0
        }
    }
    
    func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}

extension UIFont {
    static func appleSDGothicNeoBold(size: CGFloat) -> UIFont {
        guard let font =  UIFont.init(name: Const.Font.AppleSDGothicNeoBold.name, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    static func appleSDGothicNeoLight(size: CGFloat) -> UIFont {
        guard let font =  UIFont.init(name: Const.Font.AppleSDGothicNeoLight.name, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .light)
        }
        return font
    }
    
    static func appleSDGothicNeoMedium(size: CGFloat) -> UIFont {
        guard let font =  UIFont.init(name: Const.Font.AppleSDGothicNeoMedium.name, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        return font
    }
    
    static func appleSDGothicNeoRegular(size: CGFloat) -> UIFont {
        guard let font =  UIFont.init(name: Const.Font.AppleSDGothicNeoRegular.name, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
    
    static func appleSDGothicNeoSemiBold(size: CGFloat) -> UIFont {
        guard let font =  UIFont.init(name: Const.Font.AppleSDGothicNeoSemiBold.name, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        return font
    }
    
    static func AppleSDGothicNeoThin(size: CGFloat) -> UIFont {
        guard let font =  UIFont.init(name: Const.Font.AppleSDGothicNeoThin.name, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .thin)
        }
        return font
    }
    
    static func appleSDGothicNeoUltraLight(size: CGFloat) -> UIFont {
        guard let font =  UIFont.init(name: Const.Font.AppleSDGothicNeoUltraLight.name, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .ultraLight)
        }
        return font
    }
    

    func sizeOfString (string: String, constrainedToSize size: CGSize) -> CGSize {
        return NSString(string: string).boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: self],
            context: nil).size
    }

}


extension UIImage {
    func aspectFillToWidth(withSize size: CGSize) -> UIImage? {

        let imgAspect: CGFloat = self.size.width / self.size.height
        
        // increase width, crop height
        let scaledSize = CGSize(width: size.width, height: size.width / imgAspect);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.clip(to: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        
        if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return resizedImage
        }
        
         return nil
    }
}

extension UIViewController {
    func getStoryBoard(name storyBard: Const.StoryBoard) -> UIStoryboard {
        return UIStoryboard(name: storyBard.name, bundle: nil)
    }
}

extension Data {
    func base16EncodeSwift() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension UICollectionView {
    func getFullVisibleCells() -> Array<UICollectionViewCell>{
        var vCells = self.visibleCells
        vCells = vCells.filter({ cell -> Bool in
            let cellRect = self.convert(cell.frame, to: self.superview)
            return self.frame.contains(cellRect)
        })
        return vCells
    }
}

/*  Kiwon : 아직 사용하지 않는 enum type : MOCHA 작업시 사용예정
// MARK:- UIImage
    static func tagimageWithtype(_ type: String) -> UIImage? {
        
        guard let tagType = TagImageType.init(rawValue: type) else {
            return nil
        }
        
        return UIImage(named: tagType.name)
    }
}

 MARK:- Date
extension Date {
    static func getSWSeoulDateTime() -> Date {
        
        let curDate = Date()
        let dfTime = DateFormatter()
        dfTime.timeZone = TimeZone(identifier: "Asia/Seoul")
        dfTime.dateFormat = "yyyyMMddHHmmss"
        
        let strSeoulTime = dfTime.string(from: curDate)
        
        let dfSeoult = DateFormatter()
        dfSeoult.dateFormat = "yyyyMMddHHmmss"
        dfSeoult.locale = Locale(identifier: "ko_KR")
        
        let dtSeoul = dfSeoult.date(from: strSeoulTime)
        return dtSeoul!
    }
}
*/
