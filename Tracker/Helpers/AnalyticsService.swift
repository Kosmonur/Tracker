//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Александр Пичугин on 01.10.2023.
//

import Foundation
import YandexMobileMetrica

struct Event {
    let name: String
    let screen: String
    let item: String
}

struct AnalyticsService {
    
    static let shared = AnalyticsService()
    
    func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "4d2eb361-a307-463b-a637-f045dfe0e722")
        else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func reportEvent(_ event: Event) {
        let params = event.item != "" ? ["screen": event.screen, "item": event.item] : ["screen": event.screen]
        YMMYandexMetrica.reportEvent(event.name,
                                     parameters: params as [AnyHashable : Any],
                                     onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
