//
//  CameraVC.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraVCDelegate: AnyObject {
    func didOutput(_ code: String)
    func didReceiveError(_ error: Error)
}

public class CameraVC: UIViewController {
    weak var delegate: CameraVCDelegate?
    
    lazy var animationImage = UIImage()
    
    /// 動畫樣式
    var animationStyle: ScanAnimationStyle = .default {
        didSet {
            animationImage = imageNamed(animationStyle == .default ? "ScanLine" : "ScanNet")
        }
    }
    
    lazy var scannerColor: UIColor = UIColor.blue_3478FF
    
    public lazy var flashBtn: UIButton = .init(type: .custom)
    
    private var torchMode: TorchMode = .off {
        didSet{
            guard let captureDevice = captureDevice, captureDevice.hasFlash, captureDevice.isTorchModeSupported(torchMode.captureTorchMode) else { return }
            
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.torchMode = torchMode.captureTorchMode
                captureDevice.unlockForConfiguration()
            } catch {}
            
            flashBtn.setImage(torchMode.image, for: .normal)
        }
    }
    
    /// `AVCaptureMetadataOutput` metadata object types.
    var metadata = [AVMetadataObject.ObjectType]()
    
    // MARK: - Video
    
    /// Video preview layer.
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    /// Video capture device. This may be nil when running in Simulator.
    private lazy var captureDevice: AVCaptureDevice? = {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return nil }
        
        // 自動白平衡
        if captureDevice.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.whiteBalanceMode = .continuousAutoWhiteBalance
                captureDevice.unlockForConfiguration()
            } catch {}
        }
        // 自動對焦
        if captureDevice.isFocusModeSupported(.continuousAutoFocus) {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.focusMode = .continuousAutoFocus
                captureDevice.unlockForConfiguration()
            } catch {}
        }
        // 自動曝光
        if captureDevice.isExposureModeSupported(.continuousAutoExposure) {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.exposureMode = .continuousAutoExposure
                captureDevice.unlockForConfiguration()
            } catch {}
        }
        
        return captureDevice
    }()
    /// Capture session.
    private lazy var captureSession = AVCaptureSession()
    
    lazy var scanView = ScanView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scanView.startAnimation()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scanView.stopAnimation()
    }
}

// MARK: - CustomMethod
extension CameraVC {
    func setupUI() {
        view.backgroundColor = .black
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        
        guard let videoPreviewLayer = videoPreviewLayer else { return }
        view.layer.addSublayer(videoPreviewLayer)
        scanView.scanAnimationImage = animationImage
        scanView.scanAnimationStyle = animationStyle
        scanView.cornerColor = scannerColor
        view.addSubview(scanView)
        setupCamera()
        setupTorch()
    }
    
    /// 創建手電筒按鈕
    func setupTorch() {
        let buttonSize: CGFloat = 37
        flashBtn.frame = CGRect(x: screenWidth - 20 - buttonSize, y: statusHeight + 44 + 20, width: buttonSize, height: buttonSize)
        flashBtn.addTarget(self, action: #selector(flashBtnClick), for: .touchUpInside)
        flashBtn.isHidden = true
        view.addSubview(flashBtn)
        view.bringSubviewToFront(flashBtn)
        torchMode = .off
    }
    
    // 設置相機
    func setupCamera() {
        setupSessionInput()
        setupSessionOutput()
    }
    
    // 捕獲設備輸入流
    private  func setupSessionInput() {
        guard !Platform.isSimulator, let device = captureDevice else { return }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: device)
            captureSession.beginConfiguration()
            
            if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
                captureSession.removeInput(currentInput)
            }
            captureSession.addInput(newInput)
            captureSession.commitConfiguration()
        } catch {
            delegate?.didReceiveError(error)
        }
    }
    
    // 捕獲元數數據輸出流
    private func setupSessionOutput() {
        guard !Platform.isSimulator else { return }
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        captureSession.addOutput(videoDataOutput)
        
        let output = AVCaptureMetadataOutput()
        captureSession.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        for type in metadata {
            guard output.availableMetadataObjectTypes.contains(type) else { return }
        }
        
        output.metadataObjectTypes = metadata
        videoPreviewLayer?.session = captureSession
        view.setNeedsLayout()
    }
    
    /// 開始掃描
    func startCapturing() {
        guard !Platform.isSimulator else { return }
        captureSession.startRunning()
    }
    
    /// 停止掃描
    func stopCapturing() {
        guard !Platform.isSimulator else { return }
        captureSession.stopRunning()
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension CameraVC: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let dataStr = object.stringValue else { return }
            self.stopCapturing()
            self.delegate?.didOutput(dataStr)
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let metadataDict = CMCopyDictionaryOfAttachments(allocator: nil,target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        guard let metadata = metadataDict as? [String: Any],
              let exifMetadata = metadata[kCGImagePropertyExifDictionary as String] as? [String: Any],
              let brightnessValue = exifMetadata[kCGImagePropertyExifBrightnessValue as String] as? Double else {
            return
        }
        
        // 判斷光線強弱
        if brightnessValue < -1.0 {
            flashBtn.isHidden = false
        } else {
            flashBtn.isHidden = torchMode == .off
        }
    }
}

// MARK: - Click
extension CameraVC {
    @objc func flashBtnClick(sender: UIButton) {
        torchMode = torchMode.next
    }
}
