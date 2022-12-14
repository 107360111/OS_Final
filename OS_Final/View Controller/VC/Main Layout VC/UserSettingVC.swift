//
//  UserSettingVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import UITextView_Placeholder
import Realm

@objc protocol UserSettingVCDelegate {
    
}

class UserSettingVC: NotificationVC {
    
    @IBOutlet var view_gradient: UIView!
    @IBOutlet var view_date: UIView!
    @IBOutlet var view_costWay: UIView!
    @IBOutlet var view_type: UIView!
    @IBOutlet var view_typeIcon: UIView!
    @IBOutlet var view_cost: UIView!
    @IBOutlet var view_checkbox: UIView!
    
    @IBOutlet var textField_date: UITextField!
    @IBOutlet var textField_cost: UITextField!
    @IBOutlet var textView_detail: UITextView!
    
    @IBOutlet var segmentedControl_costway: UISegmentedControl!
    
    @IBOutlet var imageView_icon: UIImageView!
    @IBOutlet var imageView_checkbox: UIImageView!
    
    private var datePickerView: UIDatePicker = UIDatePicker()
    private var costPickerView: UIPickerView = UIPickerView()
    
    private var costWayIndex: Int = 0
    private var openDetail: Bool = true
    
    private var IconURLArr = [String]()
    private var IconNameArr = [String]()
    
    weak var delegate: UserSettingVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
    }
    
    private func componentsInit() {
        textView_detail.placeholder = "備註說明記帳..."

        imageView_icon.image = UIImage(named: UserDefaultManager.getPayOutIcon())
       
        textView_detail.placeholderColor = UIColor.lightGray
        textFieldInit()
        datePickerInit()
        costPickerInit()
        viewInit()
    }
        
    private func textFieldInit() {
        textField_date.text = DateManager.currentDate()
        textField_cost.placeholder = "金額"
    }
    
    private func datePickerInit() {
        datePickerView.backgroundColor = .clear
        datePickerView.frame = CGRect(x: 0, y: 0, width: AppWidth, height: 220)
        datePickerView.locale = Locale(identifier: "zh_TW") // 本地化
//        datePickerView.maximumDate = Date() // 限制不能紀錄未來的帳
        datePickerView.addTarget(self, action: #selector(scrollDatePicker), for: .valueChanged)
        
        textField_date.inputAccessoryView = dateKeyboardInputAccessoryView()
        textField_date.inputView = datePickerView
    }
    
    private func costPickerInit() {
    let numberKeyboard = numberKeyboard(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 300))
    numberKeyboard.delegate = self
    
    textField_cost.inputView = numberKeyboard
}
    
    private func viewInit() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.blue_A8CEFA.cgColor, UIColor.blue_AAC1DC.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: view_gradient.bounds.size.height)
        view_gradient.layer.insertSublayer(gradient, at: 0)
        
        view_gradient.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        view_type.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeIconDidTap)))
        view_checkbox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkboxDidTap)))
    }
    
    private func arraySelected() {
        IconURLArr = []
        IconNameArr = []
        if (costWayIndex == 0) {
            IconURLArr.append(contentsOf: locatedManager.array_payOutURL.map { $0 })
            IconNameArr.append(contentsOf: locatedManager.array_payOut.map { $0 })
        } else {
            IconURLArr.append(contentsOf: locatedManager.array_payInURL.map { $0 })
            IconNameArr.append(contentsOf: locatedManager.array_payIn.map { $0 })
        }
    }
    
    private func dateKeyboardInputAccessoryView() -> UIToolbar {
        let toolBar: UIToolbar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(killKeyboard))
        doneButton.accessibilityLabel = "keyboardDone"
        
        let space: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        var itemsArr = [UIBarButtonItem]()
        itemsArr.append(space)
        itemsArr.append(doneButton)
        
        
        toolBar.setItems(itemsArr, animated: false)
        
        return toolBar
    }

    @IBAction func textFieldDidClick(_ textFiled: UITextField) {
        if (textFiled == textField_date) {
            datePickerView.datePickerMode = .date
            if #available(iOS 13.4, *) {
                datePickerView.preferredDatePickerStyle = .wheels
                datePickerView.sizeToFit()
            }
        }
    }
        
    @IBAction func changedCostWays(_ sender: UISegmentedControl) {
        IconURLArr = []
        IconNameArr = []
        costWayIndex = sender.selectedSegmentIndex
        if (costWayIndex == 0) {
            imageView_icon.image = UIImage(named: UserDefaultManager.getPayOutIcon())
        } else {
            imageView_icon.image = UIImage(named: UserDefaultManager.getPayInIcon())
        }
    }
        
    @objc private func scrollDatePicker() {
        textField_date.text = DateManager.dateToString(date: datePickerView.date)
    }
    
    @objc private func typeIconDidTap() {
        arraySelected()
        let popverVC = setPopoverWithCell(cell: "\(iconTypeTableViewCell.self)",isAutoLayout: false, cellLimit: (IconNameArr.count > 5) ? 5 : IconNameArr.count, width: Int(view_typeIcon.frame.width))
        popverVC.tableView.backgroundColor = UIColor.white_FFFFFF
        popverVC.tableView.delegate = self
        popverVC.tableView.dataSource = self
        popverVC.tableView.tag = 1
        
        if let popover = popverVC.popoverPresentationController {
            popover.delegate = self
            popover.sourceView = view_typeIcon
            popover.sourceRect = CGRect(origin: CGPoint(x: (view_typeIcon.frame.width / 2) - 32, y: 5), size: view_typeIcon.frame.size)
        }
        present(popverVC, animated: true, completion: nil)
    }
    
    @objc private func checkboxDidTap() {
        self.killKeyboard()
        
        imageView_checkbox.image = UIImage(named: (openDetail) ? "checkbox_checked" : "checkbox")
        textView_detail.isHidden = !openDetail
        openDetail = !openDetail
    }
    
    @objc private func killKeyboard() {
        self.view.endEditing(true)
    }
}

extension UserSettingVC: numberKeyboardDelegate {
    func numberButtonDidTap(tag: String) {
        textField_cost.insertText(String(tag))
    }
    
    func clearButtonDidTap() {
        textField_cost.text = ""
    }
    
    func deleteButtonDiaTap() {
        textField_cost.deleteBackward()
    }
    
    func finishButtonDidTap() {
        self.killKeyboard()
    }
    
}

extension UserSettingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IconNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? iconTypeTableViewCell else { return iconTypeTableViewCell() }
        cell.setCell(icon: IconURLArr[indexPath.row], name: IconNameArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let icon = IconURLArr.getObject(at: indexPath.row) {
            if (costWayIndex == 0) {
                UserDefaultManager.setPayOutIcon(str: icon)
            } else {
                UserDefaultManager.setPayInIcon(str: icon)
            }
            imageView_icon.image = UIImage(named: icon)
            presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

extension UserSettingVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension UserSettingVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.killKeyboard()
    }
}
