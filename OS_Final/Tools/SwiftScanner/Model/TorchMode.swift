//
//  TorchMode.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/26.
//

import AVFoundation
import UIKit

/// Wrapper around `AVCaptureTorchMode`.
public enum TorchMode {
    case on
    case off
    
    /// Returns the next torch mode.
    var next: TorchMode {
        switch self {
        case .on:
            return .off
        case .off:
            return .on
        }
    }
    
    /// Torch mode image.
    var image: UIImage {
        switch self {
        case .on:
            return imageNamed("flashOn")
        case .off:
            return imageNamed("flashOff")
        }
    }
    
    /// Returns `AVCaptureTorchMode` value.
    var captureTorchMode: AVCaptureDevice.TorchMode {
        switch self {
        case .on:
            return .on
        case .off:
            return .off
        }
    }
}
