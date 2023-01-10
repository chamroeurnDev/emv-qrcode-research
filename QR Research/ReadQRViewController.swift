//
//  ReadQRViewController.swift
//  QR Research
//
//  Created by DUCH Chamroeurn on 1/9/23.
//

import UIKit
import MPQRCoreSDK

class ReadQRViewController: UIViewController {

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        let qrcodeSampleEMt = "00020101021130510016A000000677010112011501055230093500202085555890053037645802TH6304A648"
        let qrcodeSampleEMV = "00020101021130510016A000000677010112011501055230093500202085555890053037645802TH6304A648"
        let abaQRCode = "00020101021130450016abaakhppxxx@abaa01090002878110208ABA Bank40390006abaP2P0112CF689424640302090002878115204000053038405802KH5915Cham Roeun DUCH6010Phnom Penh63047F2D"
        let bakongQRCode = "d80c1c8cb952a9321488a343ee285d76|ae49464f67ffe38b1e2d65f60942dbc6740d551ec302989fe79496edfc1cc5cf204b1b7c7bf829b42404a630ce9801f4"
        receive(metadata: qrcodeSampleEMt)
    }
    
    
    func receive(metadata: String) {
        do {
            let payloadData = try MPQRParser.parse(string: metadata)
            
            // Print data in string format
                 print(payloadData.dumpData())

            var maiData: MAIData?
            for value in EMVQRConstants.availableIDTags {
                if let item = try? payloadData.getMAIData(forTagString: value) {
                    maiData = item
                    break
                }
            }

            guard let accountId = maiData?.AID else {
//                restartScan()
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

//            receiveQR(
//                payload: QRPayload(
//                    assetId: assetId,
//                        amount: payloadData.transactionAmount,
//                        description: description,
//                        recipientId: accountId,
//                        merchantName: merchantName,
//                        emvcoValue: metadata))
        } catch {
            print(error)
        }
    }

}
