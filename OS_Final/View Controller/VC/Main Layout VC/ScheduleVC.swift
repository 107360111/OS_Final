//
//  ScheduleVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import AVFoundation
import Lottie
import RealmSwift

class ScheduleVC: NotificationVC {
    @IBOutlet var imageView_backgroundPicture: UIImageView!
    
    @IBOutlet var view_gradient: UIView!
    @IBOutlet var view_main: UIView!
    
    @IBOutlet var label_hint: UILabel!
    @IBOutlet var animated_gif: UIView!
    private var animationView = LottieAnimationView()

    private var clickOnce: Bool = false
    private var scanData = noteData()
    
    private var isSameData: Bool = false
    
    private let DataArray = RealmManager.getData()
        
    // MARK: - Camera Components Defined
    private let CameraVC: CameraVC = .init()
    
    /// 動畫樣式
    public var animationStyle: ScanAnimationStyle = .default { didSet {
            CameraVC.animationStyle = animationStyle
        }
    }
    
    /// 掃描框顏色
    public var scannerColor: UIColor = UIColor.blue_3478FF { didSet {
            CameraVC.scannerColor = scannerColor
        }
    }
    
    public var scannerTips: String = "" { didSet {
           CameraVC.scanView.tips = scannerTips
        }
    }
    
    /// `AVCaptureMetadataOutput` metadata object types.
    public var metadata = AVMetadataObject.ObjectType.metadata { didSet {
            CameraVC.metadata = metadata
        }
    }
    
    public var successBlock: ((String) -> ())?
    public var errorBlock: ((Error) -> ())?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
        notificationInit()
        beginTextLabelInit()
    }
    
    // MARK: - Init
    private func componentsInit() {
        setGradientBackgroundColor(view: view_gradient)
        
        label_hint.isHidden = false
        animated_gif.isHidden = true
        
        view_main.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startScan)))
        animated_gif.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startScan)))
        
        showLabelText()
    }
    
    private func showLabelText() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized { // 權限同意
            tapGifInit()
        } else if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied { // 權限不同意
            label_hint.text = ToastMes.ToastString(title: .restartCamera)
            label_hint.textColor = UIColor.red_E64646
            label_hint.textAlignment = .center
            label_hint.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    func notificationInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAllow), name: NSNotification.Name("Allow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotAllow), name: NSNotification.Name("NotAllow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCloseCamera), name: NSNotification.Name("CloseCamera"), object: nil)
    }
    
    private func beginTextLabelInit() {
        label_hint.text = ToastMes.ToastString(title: .startCamera)
        label_hint.textColor = UIColor.black
        label_hint.textAlignment = .center
        label_hint.font = UIFont.systemFont(ofSize: 20)
    }
    
    private func tapGifInit() {
        clickOnce = true
        label_hint.isHidden = true
        animated_gif.isHidden = false
        
        animationView = .init(name: "hand_tap")

        animationView.frame = CGRect(x: 0, y: 0, width: AppWidth / 2, height: AppWidth / 2)
        animationView.center = self.animated_gif.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.7
        
        animated_gif.addSubview(animationView)
        animationView.play()
    }
        
    private func cameraInit() {        
        // 移除最底層背景
        self.imageView_backgroundPicture.isHidden = true
        // 背景預設為黑色，並將透明度還原
        self.view_main.backgroundColor = .black
        self.view_main.alpha = 1.0
        
        CameraVC.metadata = metadata
        CameraVC.animationStyle = animationStyle
        CameraVC.delegate = self
                
        CameraVC.willMove(toParent: self)
        addChild(CameraVC)
        self.view_main.addSubview(CameraVC.view)
        CameraVC.didMove(toParent: self)
        
        animated_gif.isHidden = true
        
        CameraVC.startCapturing()
    }
    
    // MARK: -Notification
    @objc private func handleAllow() {
        tapGifInit()
    }
    
    @objc private func handleNotAllow() {
        label_hint.text = ToastMes.ToastString(title: .restartCamera)
        label_hint.textColor = UIColor.red_E64646
        label_hint.textAlignment = .center
        label_hint.font = UIFont.systemFont(ofSize: 20)
    }
    
    @objc private func handleCloseCamera() {
        CameraVC.stopCapturing() // 關閉相機
        
        imageView_backgroundPicture.isHidden = false 
        
        view_main.alpha = 0
        animated_gif.isHidden = false
    }
    
    // MARK: - Objc Function
    @objc private func startScan() {
        guard AuthorizationManager.checkCameraPermission(clickedOnce: clickOnce) else { return }
        cameraInit()
    }
    
    // MARK: - Function
    private func sameDataInRealm(invoice_number: String) -> Bool {
        if DataArray?.count == 0 { return false }
        
        for i in 0...((DataArray?.count ?? 1) - 1) {
            if DataArray?[i].type == "cloud" {
                guard let detail: String = DataArray?[i].detail else { return false }
                if invoice_number == detail[detail.index(detail.startIndex, offsetBy: 6)..<detail.index(detail.startIndex, offsetBy: 17)] {
                    return true
                }
            }
        }
        return false
    }
    
    private func strHexToInt(_ strHex: String) -> Int {
        return Int(strHex, radix: 16) ?? 0
    }
    
    private func changeInvoiceNumber(_ invoice_number: String) -> String {
        return "\(String(invoice_number[..<invoice_number.index(invoice_number.startIndex, offsetBy: 2)]))-\(String(invoice_number[invoice_number.index(invoice_number.startIndex, offsetBy: 2)..<invoice_number.index(invoice_number.startIndex, offsetBy: 10)]))"
    }
    
    private func changeInvoiceDate(_ invoice_date: String) -> String {
        let invoice_date_year = String(invoice_date[..<invoice_date.index(invoice_date.startIndex, offsetBy: 3)])
        let invoice_date_month = String(invoice_date[invoice_date.index(invoice_date.startIndex, offsetBy: 3)..<invoice_date.index(invoice_date.startIndex, offsetBy: 5)])
        let invoice_date_day = String(invoice_date[invoice_date.index(invoice_date.startIndex, offsetBy: 5)..<invoice_date.index(invoice_date.startIndex, offsetBy: 7)])
        let new_invoice_date_year = "\((Int(invoice_date_year) ?? 0) + 1911)"
        return "\(new_invoice_date_year)/\(invoice_date_month)/\(invoice_date_day)"
    }
}

extension ScheduleVC: CameraVCDelegate {
    func didOutput(_ code: String) {
        successBlock?(code)
        if code.isEmpty { return CameraVC.startCapturing() }

        if let listCode = code.components(separatedBy: ":").first {
            if listCode.count != 77 { // 發票既定位元數77
                self.view.makeToast("格式錯誤")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.CameraVC.startCapturing()
                }
                return
            } else {
                var invoice_number = String(listCode[..<listCode.index(listCode.startIndex, offsetBy: 10)])
                var invoice_date = String(listCode[listCode.index(listCode.startIndex, offsetBy: 10)..<listCode.index(listCode.startIndex, offsetBy: 17)])
                let invoice_cost = strHexToInt(String(listCode[listCode.index(listCode.startIndex, offsetBy: 29)..<listCode.index(listCode.startIndex, offsetBy: 37)]))
                
                invoice_number = changeInvoiceNumber(invoice_number)
                invoice_date = changeInvoiceDate(invoice_date)

                if sameDataInRealm(invoice_number: invoice_number) {
                    self.view.makeToast(ToastMes.ToastString(title: .sameData))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.CameraVC.startCapturing()
                    }
                } else {
                    let data = noteData()
                    data.date = invoice_date
                    data.ways = "掃描輸入"
                    data.type = "cloud"
                    data.cost = invoice_cost
                    data.detail = "發票號碼: \(invoice_number)\n共有\(code.components(separatedBy: ":")[2])款品項"
                    
                    scanData = data
                    showFixDataDialogVC(title: .scanIn, data: data, isScan: true)
                }
            }
        } else {
            self.view.makeToast(ToastMes.ToastString(title: .noData))
        }
    }
    
    func didReceiveError(_ error: Error) {
        errorBlock?(error)
        self.view.makeToast(ToastMes.ToastString(title: .appError))
    }
}

extension ScheduleVC: FixDataDialogVCDelegate {
    func chooseDelete() {
        self.CameraVC.startCapturing()
    }
    
    func chooseFix() {
        RealmManager.saveData(data: scanData)

        UserDefaultManager.setCost(cost: scanData.cost, type: scanData.type, costType: .set)
        
        self.view.makeToast(ToastMes.ToastString(title: .canAssign))
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendData"), object: nil)
        
        scanData = noteData() // 發票登入後歸零
        
        CameraVC.stopCapturing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            guard let parentVC = self.parent as? ViewController else { return self.CameraVC.startCapturing()}
            parentVC.scroll(to: 1, animated: true)
            // 跳轉至list主頁
        }
    }
}
