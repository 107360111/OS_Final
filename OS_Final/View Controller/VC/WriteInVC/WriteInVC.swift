//
//  WriteInVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/10.
//

import UIKit
import UITextView_Placeholder

class WriteInVC: NotificationVC {
    @IBOutlet var view_topGradient: UIView!
    
    @IBOutlet var view_gradient: UIView!
    @IBOutlet var view_date: UIView!
    @IBOutlet var view_costWay: UIView!
    @IBOutlet var view_type: UIView!
    @IBOutlet var view_typeIcon: UIView!
    @IBOutlet var view_cost: UIView!
    @IBOutlet var view_checkbox: UIView!
    @IBOutlet var view_textView_background: UIView!
    @IBOutlet var view_back: UIView!
    
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
    
    private var payOutIcon: String = "food"
    private var payInIcon: String = "salary"
    
    private var costWayIndex: Int = 0
    private var openDetail: Bool = false
    private var chooseTextView: Bool = true
    
    private var selectedIndex: Int = 0
    private var IconURLArr = [String]()
    private var IconNameArr = [String]()
    
    private var originalCost: Int = 0
    private var data = noteData()
    
    convenience init(data: noteData) {
        self.init()
        self.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataSetInit()
    }
    
    override func KeyboardWillShow(duration: Double, height: CGFloat) {
        if chooseTextView {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0) { [weak self] in
                self?.view_date_top.constant = AppHeight < 600 ? -(height - 100) : -((AppHeight / 2) - height)
                self?.textView_Bottom.constant = AppHeight < 600 ? (height - 100) : (AppHeight / 2) - height
            }
        }
    }
    
    override func KeyboardWillHide(duration: Double) {
        if chooseTextView {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0) { [weak self] in
                self?.view_date_top.constant = 10
                self?.textView_Bottom.constant = 10
            }
        }
    }
    
    private func componentsInit() {
        textFieldInit()
        textViewInit()
        datePickerInit()
        costPickerInit()
        viewInit()
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
        let numberKeyboard = numberKeyboard(frame: CGRect(x: 0, y: 0, width: AppWidth, height: 300))
        numberKeyboard.delegate = self
        textField_cost.inputAccessoryView = dateKeyboardInputAccessoryView()
        textField_cost.inputView = numberKeyboard
    }
                
    private func viewInit() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.blue_A8CEFA.cgColor, UIColor.blue_AAC1DC.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
        view_topGradient.layer.insertSublayer(gradient, at: 0)
        
        setGradientBackgroundColor(view: view_gradient)

        view_type.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeIconDidTap)))
        view_checkbox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkboxDidTap)))
        view_back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backDidTap)))
        
        segmentedControl_costway.addTarget(self, action: #selector(WriteInVC.onChange(sender:)), for: .valueChanged)
    }
    
    private func dataSetInit() {
        originalCost = data.cost
        textField_date.text = data.date
        datePickerView.date = DateManager.stringToDate(string: data.date)
        
        if locatedManager.array_payIn.filter({ $0.contains(data.ways) }).count > 0 {
            payInIcon = data.type
            segmentedControl_costway.selectedSegmentIndex = 1
            costWayIndex = 1
        } else {
            payOutIcon = data.type
            segmentedControl_costway.selectedSegmentIndex = 0
            costWayIndex = 0
        }
        arraySelected()
        
        imageView_icon.image = UIImage(named: data.type)
                
        textField_cost.text = String(format: "%2d", Int(data.cost))
        
        if data.detail.count > 0 {
            checkboxDidTap()
            textView_detail.text = data.detail
        }
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
    
    @IBAction func updateData(_ sender: Any) {
        self.killKeyboard()
        
        guard textField_cost.text?.count != 0 else {
            textField_cost.borderColor = UIColor.red_E64646
            self.view.makeToast("請輸入金額")
            return
        }
        
        let costStr: String = textField_cost.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
        guard let cost: Int = Int(costStr) else { return }
        
        let data = noteData()
        data.id_key = self.data.id_key // 記錄此帳本的編號
        data.date = textField_date.text ?? ""
        data.ways = IconNameArr.getObject(at: selectedIndex) ?? ""
        data.type = costWayIndex == 0 ? payOutIcon : payInIcon
        data.cost = cost
        data.detail = textView_detail.text ?? ""
        
        self.data = data
        self.showFixDataDialogVC(title: .check, data: data, isUpdate: true)
    }
    
    @objc private func onChange(sender: UISegmentedControl) {
        costWayIndex = sender.selectedSegmentIndex
        arraySelected()
        if (costWayIndex == 0) {
            imageView_icon.image = UIImage(named: payOutIcon)
        } else {
            imageView_icon.image = UIImage(named: payInIcon)
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
        imageView_checkbox.image = UIImage(named: !openDetail ? "checkbox_checked" : "checkbox")
        textView_detail.isHidden = openDetail
        view_textView_background.isHidden = openDetail
        openDetail = !openDetail
    }
    
    @objc private func backDidTap() {
        navigationController?.popViewController(animated: true)
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

extension WriteInVC: numberKeyboardDelegate {
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

extension WriteInVC: FixDataDialogVCDelegate {
    func chooseDelete() {
    }
    
    func chooseFix() {
        RealmManager.updateData(data: data)
        self.view.makeToast("修改成功", duration: 0.3)
        let average_cost: Int = originalCost - data.cost
        if costWayIndex == 0 { // 支出
            if average_cost < 0 { // 調整後價錢上升
                UserDefaultManager.setPayOutCost(cost: abs(average_cost))
            } else if average_cost > 0 { // 調整後價錢下降
                UserDefaultManager.setDeletePayOutCost(cost: abs(average_cost))
            }
        } else { // 收入
            if average_cost < 0 { // 調整後價錢上升
                UserDefaultManager.setPayInCost(cost: abs(average_cost))
            } else if average_cost > 0 { // 調整後價錢下降
                UserDefaultManager.setDeletePayInCost(cost: abs(average_cost))
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendData"), object: nil)
        navigationController?.popViewController(animated: true)
    }
}

extension WriteInVC: UITableViewDelegate, UITableViewDataSource {
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
            if (costWayIndex == 0) {
                payOutIcon = icon
            } else {
                payInIcon = icon
            }
            imageView_icon.image = UIImage(named: icon)
            presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

extension WriteInVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension WriteInVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.killKeyboard()
    }
}
