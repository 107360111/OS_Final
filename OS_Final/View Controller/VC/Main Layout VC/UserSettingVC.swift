//
//  UserSettingVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import UITextView_Placeholder

class UserSettingVC: NotificationVC {

    @IBOutlet var view_gradient: UIView!
    @IBOutlet var view_date: UIView!
    @IBOutlet var view_costWay: UIView!
    @IBOutlet var view_type: UIView!
    @IBOutlet var view_typeIcon: UIView!
    @IBOutlet var view_cost: UIView!
    @IBOutlet var view_checkbox: UIView!
    @IBOutlet var view_textView_background: UIView!
    
    @IBOutlet var textField_date: UITextField!
    @IBOutlet var textField_cost: UITextField!
    @IBOutlet var textView_detail: UITextView!
    
    @IBOutlet var segmentedControl_costway: UISegmentedControl!
    
    @IBOutlet var imageView_icon: UIImageView!
    @IBOutlet var imageView_checkbox: UIImageView!
    
    @IBOutlet var view_date_top: NSLayoutConstraint!
    @IBOutlet var textView_Bottom: NSLayoutConstraint!
    
    private var datePickerView: UIDatePicker = UIDatePicker()
    private var costPickerView: UIPickerView = UIPickerView()
    
    private var costWayIndex: Int = 0
    private var openDetail: Bool = false
    private var chooseTextView: Bool = true
    
    private var IconURLArr = [String]()
    private var IconNameArr = [String]()
    private var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
    }
    
    override func KeyboardWillShow(duration: Double, height: CGFloat) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopScrolling"), object: nil)
        if chooseTextView {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: []) {
                if AppHeight < 600 {
                    self.view_date_top.constant = -(height - 50)
                }
                
                if let window = UIApplication.shared.windows.first {
                    self.textView_Bottom.constant = (height - window.safeAreaInsets.bottom) - 50
                } else {
                    self.textView_Bottom.constant = height - 50
                }
            }
        }
    }
    
    override func KeyboardWillHide(duration: Double) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContinuneScrolling"), object: nil)
        if chooseTextView {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: []) {
                self.view_date_top.constant = 10
                self.textView_Bottom.constant = 10
            }
        }
    }
    
    private func componentsInit() {
        imageView_icon.image = UIImage(named: UserDefaultManager.getPayoutIconFromVC())
       
        arrayInit()
        textFieldInit()
        textViewInit()
        datePickerInit()
        costPickerInit()
        viewInit()
    }
    
    private func arrayInit() {
        if costWayIndex == 0 {
            IconURLArr.append(contentsOf: locatedManager.array_payOutURL.map { $0 })
            IconNameArr.append(contentsOf: locatedManager.array_payOut.map { $0 })
        } else {
            IconURLArr.append(contentsOf: locatedManager.array_payInURL.map { $0 })
            IconNameArr.append(contentsOf: locatedManager.array_payIn.map { $0 })
        }
    }
        
    private func textFieldInit() {
        textField_date.text = DateManager.currentDate()
        textField_cost.placeholder = "金額"
    }
    
    private func textViewInit() {
        textView_detail.placeholder = "備註說明記帳..."
        textView_detail.placeholderColor = UIColor.lightGray
        textView_detail.inputAccessoryView = dateKeyboardInputAccessoryView()
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
        let numberKeyboard = numberKeyboard(frame: CGRect(x: 0, y: 0, width: AppWidth, height: (AppHeight / 3) < 300 ? (AppHeight / 3) : 300 ))
    numberKeyboard.delegate = self
    
    textField_cost.inputAccessoryView = dateKeyboardInputAccessoryView()
    textField_cost.inputView = numberKeyboard
}
    
    private func viewInit() {
        setGradientBackgroundColor(view: view_gradient)
        
        view_type.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeIconDidTap)))
        view_checkbox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkboxDidTap)))
        
        segmentedControl_costway.addTarget(self, action: #selector(UserSettingVC.onChange(sender:)), for: .valueChanged)
    }
    
    private func arraySelected() {
        IconURLArr = []
        IconNameArr = []
        if costWayIndex == 0 {
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
        chooseTextView = false
        textView_detail.isUserInteractionEnabled = false
        if (textFiled == textField_date) {
            datePickerView.datePickerMode = .date
            if #available(iOS 13.4, *) {
                datePickerView.preferredDatePickerStyle = .wheels
                datePickerView.sizeToFit()
            }
        }
    }
    
    @IBAction func uploadData(_ sender: Any) {
        self.killKeyboard()
        
        guard textField_cost.text?.count != 0 else {
            textField_cost.borderColor = UIColor.red_E64646
            self.view.makeToast(ToastMes.ToastString(title: .inputCost))
            return
        }
        
        var costStr: String = textField_cost.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
        if costStr.count >= 7 {
            costStr = "1000000"
        }
        guard let cost: Int = Int(costStr) else { return }
        
        let data = noteData()
        data.date = textField_date.text ?? ""
        data.ways = IconNameArr.getObject(at: selectedIndex) ?? ""
        data.type = costWayIndex == 0 ? UserDefaultManager.getPayoutIconFromVC() : UserDefaultManager.getPayinIconFromVC()
        data.cost = cost
        data.detail = textView_detail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        RealmManager.saveData(data: data)
        
        UserDefaultManager.setCost(cost: cost, type: data.type, costType: .set)
        
        self.view.makeToast(ToastMes.ToastString(title: .canAssign), duration: ShortTime)
        
        textField_date.text = DateManager.currentDate()
        datePickerView.date = Date()
        textField_cost.text = ""
        textView_detail.text = ""
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendData"), object: nil)
    }
    
    @objc private func onChange(sender: UISegmentedControl) {
        costWayIndex = sender.selectedSegmentIndex
        arraySelected()
        if (costWayIndex == 0) {
            imageView_icon.image = UIImage(named: UserDefaultManager.getPayoutIconFromVC())
        } else {
            imageView_icon.image = UIImage(named: UserDefaultManager.getPayinIconFromVC())
        }
    }
    
    @objc private func scrollDatePicker() {
        textField_date.text = DateManager.dateToString(date: datePickerView.date)
    }
    
    @objc private func typeIconDidTap() {
        arraySelected()
        let popverVC = setPopoverWithCell(cell: "\(iconTypeTableViewCell.self)",isAutoLayout: false, cellLimit: IconNameArr.count > 5 ? 5 : IconNameArr.count, width: Int(view_typeIcon.frame.width))
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
        
        imageView_checkbox.image = UIImage(named: !openDetail ? "checkbox_checked" : "checkbox")
        textView_detail.isHidden = openDetail
        view_textView_background.isHidden = openDetail
        openDetail = !openDetail
    }
    
    @objc private func killKeyboard() {
        chooseTextView = true
        textView_detail.isUserInteractionEnabled = true
        if textField_cost.text?.count != 0 {
            textField_cost.borderColor = UIColor.gray_C4C4C4
        }
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
        if textField_cost.text?.count != 0 {
            textField_cost.borderColor = UIColor.gray_C4C4C4
        }
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
            selectedIndex = indexPath.row
            if costWayIndex == 0 {
                UserDefaultManager.setPayoutIconFromVC(str: icon)
            } else {
                UserDefaultManager.setPayinIconFromVC(str: icon)
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
