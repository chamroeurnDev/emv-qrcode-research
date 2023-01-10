//
//  ViewController.swift
//  QR Research
//
//  Created by DUCH Chamroeurn on 1/4/23.
//

import UIKit
import MPQRScanSDK
import MPQRCoreSDK
import AVFoundation

class ViewController: UIViewController, QRCodeReaderDelegate {

    @IBAction func scanAction(_ sender: AnyObject) {
        guard QRCodeReader.isAvailable() && QRCodeReader.supportsQRCode() else {
            return
        }
        // Presents the readerVC
        checkCameraPermission { [weak self] in
            guard let strongSelf = self else {
                return
            }

            var reader:QRCodeReader?

            let qrVC = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
                $0.startScanningAtLoad = false
                reader = $0.reader
            })

            //block to read the result
            reader?.setCompletionWith({ result in
                if let stringVal = result {
                    self?.receive(metadata: stringVal)
                }
                reader?.stopScanning()
                self?.dismiss(animated: true, completion: nil)
            })
            
            qrVC.modalPresentationStyle = .overFullScreen

            //block when cancel is pressed
            qrVC.setCompletionWith({ result in
                reader?.stopScanning()
                self?.dismiss(animated: true, completion: nil)
            })

            // Retrieve the QRCode content via delegate
            qrVC.delegate = strongSelf

            strongSelf.present(qrVC, animated: true, completion: {
                /* starting capture session */
                    DispatchQueue.global(qos: .background).async {
                        qrVC.startScanning()
                    }
               
            })
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    // Check camera permissions
    func checkCameraPermission(completion: @escaping () -> Void) {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)

        switch cameraAuthorizationStatus {
        case .denied:
            showAlert(title: "Error", message: "Camera permissions are required for scanning QR. Please turn on Settings -> MasterpassQR Demo -> Camera")
            break
        case .restricted:
            showAlert(title: "Error", message: "Camera permissions are restricted for scanning QR")
            break
        case .authorized:
            completion()
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { [weak self] granted in
                guard let strongSelf = self else { return }

                DispatchQueue.main.async {
                    if granted {
                        completion()
                    } else {
                        strongSelf.showAlert(title: "Error", message: "Camera permissions are required for scanning QR. Please turn on Settings -> MasterpassQR Demo -> Camera")
                    }
                }
            }
        @unknown default:
            fatalError()
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }


    
    func receive(metadata: String) {
        do {
            let payloadData = try MPQRParser.parse(string: metadata)
            
            // Print data in string format
                 print(payloadData.dumpData())
            
            print("Payload = ", payloadData)

            var maiData: MAIData?
            for value in EMVQRConstants.availableIDTags {
                if let item = try? payloadData.getMAIData(forTagString: value) {
                    maiData = item
                    break
                }
            }

            guard let accountId = maiData?.AID else {

                return
            }

            var assetId: String?
            if let codeString = payloadData.transactionCurrencyCode,
                let code = Int16(codeString) {
                let asset: CurrencyType.Type = CurrencyFactory.from(iso: code)
                assetId = asset.assetId
            }

            var description: String?

            let trimSet = CharacterSet(charactersIn: " ")
            let merchantName = payloadData.merchantName ?? EMVQRConstants.merchantDefaultName
            if let purpose = payloadData.additionalData?.purpose,
                !purpose.trimmingCharacters(in: trimSet).isEmpty {
                description = purpose
            }

            if let billNumber = payloadData.additionalData?.billNumber?.trimmingCharacters(in: trimSet) {
                if (description ?? "").isEmpty {
                    description = billNumber
                } else {
                    description?.append(contentsOf: " \(billNumber)")
                }
            }

            print("\(assetId) , \(payloadData.transactionAmount), \(description), \(accountId) , \(merchantName), \(metadata)")
        } catch {
            print(error)
        }
    }
    


}

