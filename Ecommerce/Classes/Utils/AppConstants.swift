//
//  AppConstants.swift


import Foundation
import UIKit


@available(iOS 13.0, *)
enum ConstantVariables {
    static let AppName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    static let SCREEN_WIDTH = UIScreen.main.bounds.height
}

enum ConstantAlertMsgs {
    static let InternertErrMsg = "Please check your internet connection."
    static let OtherErrMsg = "Oops! Something went wrong. Please try again later."
    static let NoData = "No data available."
}

enum CustomError: Error {
    case internetError
    case otherError
}

