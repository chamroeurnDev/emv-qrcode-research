//
//  ScanQRViewController.swift
//  QR Research
//
//  Created by DUCH Chamroeurn on 1/9/23.
//

import MPQRScanSDK

class ScanQRViewController : UIViewController, QRCodeReaderDelegate {

  lazy var reader: QRCodeReaderViewController = {
    return QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        let readerView = $0.readerView

        // Setup overlay view
        let overlayView = readerView.getOverlay()
        overlayView.cornerColor = UIColor.purple
        overlayView.cornerWidth = 6
        overlayView.cornerLength = 75
        overlayView.indicatorSize = CGSize(width: 250, height: 250)

        // Setup scanning region
        $0.scanRegionSize = CGSize(width: 250, height: 250)

        // Hide torch button provided by the default view
        $0.showTorchButton = false

        // Hide cancel button provided by the default view
        $0.showCancelButton = false

        // Don't start scanning when this view is loaded i.e initialized
        $0.startScanningAtLoad = false


    })
  }()

  override func viewDidLoad() {
      super.viewDidLoad()

      reader.delegate = self

      self.addChild(reader)
      self.view.insertSubview(reader.view, at: 0)

      let viewDict = ["reader" : reader.view as Any]
      self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[reader]|", options: [], metrics: nil, views: viewDict))
      self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[reader]|", options: [], metrics: nil, views: viewDict))

      reader.didMove(toParent: self)
      
      
      reader.startScanning()
  }

  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      reader.stopScanning()
  }

  // MARK:- Actions
  @IBAction func toggleTorch(_ sender: Any) {
      reader.codeReader!.toggleTorch()
  }

  func reader(_ reader: QRCodeReaderViewController, didScanResult result: String) {
      reader.stopScanning()
  }

  func readerDidCancel(_ reader: QRCodeReaderViewController) {
      reader.stopScanning()
  }
}

