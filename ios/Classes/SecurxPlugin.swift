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

    private lazy var screenProtectorKit: ScreenProtectorKit = {
        let window = UIApplication.shared.windows.first
        let kit = ScreenProtectorKit(window: window)
        kit.configurePreventionScreenshot()
        return kit
    }()

    private var currentProtectionStyle: String = "none"
    private var currentProtectionArgs: [String: Any]?

    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func appWillResignActive() {
        applyProtection()
    }

    @objc func appDidBecomeActive() {
        removeProtection()
    }

    private func applyProtection() {
        switch currentProtectionStyle {
        case "blur":
            screenProtectorKit.enabledBlurScreen()
        case "color":
            if let args = currentProtectionArgs, let colorHex = args["color"] as? String {
                screenProtectorKit.enabledColorScreen(hexColor: colorHex)
            }
        case "image":
            if let args = currentProtectionArgs, let imageName = args["assetImage"] as? String {
                screenProtectorKit.enabledImageScreen(named: imageName)
            }
        default:
            break
        }
    }

    private func removeProtection() {
        screenProtectorKit.disableBlurScreen()
        screenProtectorKit.disableColorScreen()
        screenProtectorKit.disableImageScreen()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
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
            handleSetIOSBackgroundProtection(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleSetIOSBackgroundProtection(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let style = args["style"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing style", details: nil))
            return
        }

        currentProtectionStyle = style
        currentProtectionArgs = args
        
        // If style is none, remove immediately
        if style == "none" {
            removeProtection()
        }
        
        result(nil)
    }

    private func getAppSignature() -> String? {
        guard let provisionPath = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: provisionPath)) else {
            return nil
        }
        
        // The mobileprovision file is a CMS signed message.
        // We can try to find the plist content.
        // A simple heuristic is to look for <?xml and </plist>
        
        let string = String(data: data, encoding: .isoLatin1) ?? ""
        guard let startRange = string.range(of: "<?xml"),
              let endRange = string.range(of: "</plist>") else {
            return nil
        }
        
        let plistString = String(string[startRange.lowerBound..<endRange.upperBound]) + "</plist>"
        guard let plistData = plistString.data(using: String.Encoding.utf8) else { return nil }
        
        guard let plist = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any],
              let certificates = plist["DeveloperCertificates"] as? [Data],
              let firstCertData = certificates.first else {
            return nil
        }
        
        // Hash the certificate data
        if #available(iOS 13.0, *) {
            let digest = SHA256.hash(data: firstCertData)
            return digest.map { String(format: "%02x", $0) }.joined()
        } else {
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            firstCertData.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress, CC_LONG(firstCertData.count), &hash)
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
