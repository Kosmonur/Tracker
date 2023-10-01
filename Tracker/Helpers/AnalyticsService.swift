//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Александр Пичугин on 01.10.2023.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    
    static let shared = AnalyticsService()
    
    func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "4d2eb361-a307-463b-a637-f045dfe0e722")
        else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func reportEvent(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
