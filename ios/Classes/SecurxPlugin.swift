import Flutter
import UIKit
import DTTJailbreakDetection
import DTTJailbreakDetection
import ScreenProtectorKit
import CryptoKit
import Security
import CommonCrypto


public class SecurxPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "securx", binaryMessenger: registrar.messenger())
    let instance = SecurxPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let window = UIApplication.shared.windows.first
        let screenProtectorKit = ScreenProtectorKit(window: window)
        screenProtectorKit.configurePreventionScreenshot()
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "isDeviceRooted":
            result(isJailBroken())
        case "isDeviceSafe":
            result(isDeviceSafe())
        case "isDebuggingModeEnable":
            result(false)
        case "isDeveloperModeEnabled":
            result(false)
        case "isEmulator":
            result(isSimulator())
        case "enableScreenshot":
            screenProtectorKit.disablePreventScreenshot()
            result(true)
        case "disableScreenshot":
            screenProtectorKit.enabledPreventScreenshot()
            result(true) // no need to return anything
        case "isDebuggerAttached":
            result(isDebuggerAttached)
        case "isAppCloned":
            result(false)
        case "getAppSignature":
            result(getAppSignature())
        case "setIOSBackgroundProtection":
            handleSetIOSBackgroundProtection(call, result: result, screenProtectorKit: screenProtectorKit)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleSetIOSBackgroundProtection(_ call: FlutterMethodCall, result: @escaping FlutterResult, screenProtectorKit: ScreenProtectorKit) {
        guard let args = call.arguments as? [String: Any],
              let style = args["style"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing style", details: nil))
            return
        }

        switch style {
        case "blur":
            screenProtectorKit.enabledBlurScreen()
        case "color":
            if let colorHex = args["color"] as? String {
                screenProtectorKit.enabledColorScreen(hexColor: colorHex)
            }
        case "image":
            if let imageName = args["assetImage"] as? String {
                screenProtectorKit.enabledImageScreen(named: imageName)
            }
        case "none":
            screenProtectorKit.disableBlurScreen()
            screenProtectorKit.disableColorScreen()
            screenProtectorKit.disableImageScreen()
        default:
            break
        }
        result(nil)
    }

    private func getAppSignature() -> String? {
        var code: SecCode?
        if SecCodeCopySelf([], &code) != errSecSuccess { return nil }
        guard let validCode = code else { return nil }

        var info: CFDictionary?
        if SecCodeCopySigningInformation(validCode, [], &info) != errSecSuccess { return nil }

        guard let validInfo = info as? [String: Any],
              let certificates = validInfo[kSecCodeInfoCertificates as String] as? [SecCertificate],
              let firstCert = certificates.first else {
            return nil
        }

        let data = SecCertificateCopyData(firstCert) as Data
        
        if #available(iOS 13.0, *) {
            let digest = SHA256.hash(data: data)
            return digest.map { String(format: "%02x", $0) }.joined()
        } else {
            // Fallback for iOS 12
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
            }
            return hash.map { String(format: "%02x", $0) }.joined()
        }
    }

    
    private func isDeviceSafe() -> Bool {
        return !isJailBroken()
                && !isDebuggerAttached
                && !isSimulator()
                // !isDeveloperModeEnabled()
    }
    
    private func isSimulator() -> Bool {
    #if targetEnvironment(simulator)
        return true
    #else
        return false
    #endif
    }
    
    private func isJailBroken() -> Bool {
        return DTTJailbreakDetection.isJailbroken()
    }
    
    let isDebuggerAttached: Bool = {
        var debuggerIsAttached = false
    
        var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var info: kinfo_proc = kinfo_proc()
        var info_size = MemoryLayout<kinfo_proc>.size
    
        let success = name.withUnsafeMutableBytes { (nameBytePtr: UnsafeMutableRawBufferPointer) -> Bool in
            guard let nameBytesBlindMemory = nameBytePtr.bindMemory(to: Int32.self).baseAddress else { return false }
            return -1 != sysctl(nameBytesBlindMemory, 4, &info, &info_size, nil, 0)
        }
    
        if !success {
            debuggerIsAttached = false
        }
    
        if !debuggerIsAttached && (info.kp_proc.p_flag & P_TRACED) != 0 {
            debuggerIsAttached = true
        }
    
        return debuggerIsAttached
    }()
}
