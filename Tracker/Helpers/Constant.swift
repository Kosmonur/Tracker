//
//  Constant&Helper.swift
//  Tracker
//
//  Created by Александр Пичугин on 04.08.2023.
//

import Foundation

enum Constant {
    
    // TabBarController
    
    static let trackerTitle = "Трекеры"
    static let rightTabBarTitle = "Статистика"
    
    // TrackersViewController
    
    static let searchPlaceholder = "Поиск"
 //   static let vcTitle = "Трекеры"
    static let futureAlertTitle = "Будущее зависит от того, что вы делаете сегодня"
    static let futureAlertMessage = "Но сегодня нельзя выполнить то, что предстоит сделать завтра…"
    static let actionOk = "Ок"
    static let stubStarText = "Что будем отслеживать?"
    static let stubNotFoundText = "Ничего не найдено"
    
    // TrackerViewCell
    
    static let wordOneDay = "день"
    static let wordDay = "дня"
    static let wordDays = "дней"
    
    // CreateNewTrackerController
    
    static let newHabitButtonTitle = "Привычка"
    static let irregularEventButtonTitle = "Нерегулярное событие"
    static let newTrackerControllerTitle = "Создание трекера"
    
    // CategoryViewController
    
    static let addCategoryButtonTitle = "Добавить категорию"
    static let stubLabelText = "Привычки и события можно \nобъединить по смыслу"
    static let categoryTitle = "Категория"
    
    // ScheduleViewController
    
    static let readyButtonTitle = "Готово"
    static let scheduleTitle = "Расписание"
    
    // NewTrackerViewController
    
    static let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                         "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                         "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    static let newTrackerHeaders = ["Emoji", "Цвет"]
    static let newTrackerNameFieldPlaceholder = "Введите название трекера"
    static let newTrackerResrtictionLabel = "Ограничение 38 символов"
    
}
