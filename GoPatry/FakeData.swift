//
//  FakeData.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

class FakeData {
    
    static let notAppFakeFriends = [ SocialFriend(id: "100000216803653", fname: "Пульхерия", lname: "Анискина", photo: FakeData.getFBPhotoUrl("100000216803653")),
        SocialFriend(id: "100004466080925", fname: "Гуля", lname: "Закалюкина", photo: FakeData.getFBPhotoUrl("100004466080925")),
        SocialFriend(id: "100006431590191", fname: "Мандрагор", lname: "Фектистов", photo: FakeData.getFBPhotoUrl("100006431590191")),
        SocialFriend(id: "100006306007558", fname: "Спиридон", lname: "Ковылякин", photo: FakeData.getFBPhotoUrl("100006306007558")),
        SocialFriend(id: "100000428435008", fname: "Дульсинея", lname: "Гречная", photo: FakeData.getFBPhotoUrl("100000428435008")),
        SocialFriend(id: "100005275532422", fname: "Сфирид", lname: "Окружный", photo: FakeData.getFBPhotoUrl("100005275532422")) ]
    
    static let fakeFIRUIDs = ["1jewkUMz9ZUk89UsPVknbhCLfsv1",
                              "5B5U9aEDo6ZuanYtwXt8WHn7L5x1",
                              "GfGeYqLGsyaKAJllmYjaMX9YT953",
                              "J1lhswtgdoPVOBTp2Jr5x8dvlbz1",
                              "hfUrCzQ5EGcBLCLCIeIhpU6okgO2",
                              "j4kqwjpgSfZ8dDGDpZDU3RAplO92"]
    
    static let fakeEMails = ["esrgearg@gmail.com","fdgerg@gmail.com","hjkuyk@gmail.com","xvcbxdr@gmail.com","qwztjc@gmail.com"]
    
    static let fakePasswords = ["gdrtset","43tagzdf","bzdfb53","43tgrfb54","gzrge54gx"]
    
    static let fakeIds = [ "100000595263382", "1774947190","313827","575045781","737308239","672804771","869470450","1764682292","1696981410","1076180409","1222471715","1679839563","1729312996","1375285342","1237898310","1065551395","1665437400","1610854585","1524340349","1538022357","100000427762117","100001216551129","100000096332148","100001415074072","100001704995029","100004309477176","100002667402239","100002921152719","100001249383604","100003346430423","100001402818874","100002608190346","100002387687244","100000216803653","100004466080925","100006431590191","100006306007558","100000428435008","100005275532422","100003615327415","100003123756518","100001829745954","100000740266551","100000598025430","100000740266551","100000598025430","100006283740201","100003479385676","100004636236057","100006433277546","169045853142188","100004497034687","100006340179443","100001023988219","100006564632810","100006204339026","100006580713448","100002796469578","100006590523350","100002978720906","100001696882636","100003809438136","100006559508371","100001124104090","1006288763124","100006608858354","100006461473664","100002112563276","100001144750438","100000970716351","100001738324533","100006936789414","100004455397786","100004472134583","100007928525977"]
    
    
    
    static func getFakeUsers() -> [User] {
        var result = [User]()
        for i in 0...10 {
            let fbID = fakeIds.randomItem()
            let user = User(key: fbID, nik: fbID, e_mail: fbID, f_name: "FakeU" + String(i), s_name: nil, fb_id: fbID, vk_id: nil, photo_url: getFBPhotoUrl( fbID ) )
            result.append( user )
        }
        
        return result
    }
    static let fakeGroupIds = [ "Group1", "Group2", "Group3", "Group4", "Group5"]
    
    static var fakeCurrentUserUID = "vc4dea"
    static var fakeCurrentUser: User {
        get {
           
            let user = User()
            //user.uid = "vc4dea"
            user.f_name = "Николай"
            user.s_name = "Карновский"
            user.fb_id = "100001738324533"
            user.photo_url = "https://graph.facebook.com/100001738324533/picture?width=100&height=100"
            //user.photo_url = "https://graph.facebook.com/" + String(user.fb_id!) + "/picture?width=100&height=100"
            user.nik = "KarnovNik"
            return user
        }
    }
    
    static func getSetFakeUid( _ amount: Int = 0 ) -> [String] {
        var amountInner = amount
        if amountInner == 0 {
            amountInner = Int( arc4random_uniform( 20 ) + 5 );
        }
        return (fakeFIRUIDs.getSetFrom( amountInner ).map{ $0 })
    }
    
    
    
    static func getFakeCoordinate() -> String {
        var str = ""
        str += String( Int( arc4random_uniform( 9 ) + 1 ) )
        str += String( Int( arc4random_uniform( 9 ) + 1 ) )
        str += "."
        for _ in 1...6{
            str += String( Int( arc4random_uniform( 10 ) ) )
        }
        
        return str
    }
    
    static func getFBPhotoUrl( _ fbID: String ) -> String {
        return "https://graph.facebook.com/\(fbID)/picture?width=100&height=100"
    }
    
    static let vocabularyStr = "Here we insert a new object in to the core data stack through the managedObjectContext that the template function added to AppDelegate for us. This method returns an NSManagedObject which is a generic type of Core Data object that responds to methods like valueForKey. If you don’t quite understand what that means, don’t worry too much about it, it’s not going to prevent you from being able to use Core Data. Let’s keep moving. With an NSManagedObject version of newItem, we could say newItem.valueForKey(“title”) to get the title. But this is not the best approach because it leaves too much opportunity to mis-type an attribute name, or get the wrong object type unexpectedly and have hard crashes trying to access these attributes."
    
    static let vocabulary = vocabularyStr.split(separator: " ");
    
    static func getRandomTextForComment() -> String {
        var str = ""
        for _ in 0...Int( arc4random_uniform( 10 ) ) {
            let index = Int( arc4random_uniform( UInt32(vocabulary.count)  ) )
            str += vocabulary[index] + " "
        }
        return str
    }
    
    static func getFakeFSName() -> ( first: String, second: String) {
        
        let set = Utils.getRandomInRange(10) <= 5 ? fakeFI_m : fakeFI_f
        let first = set.randomItem().split(separator: " ")[1]
        let second = set.randomItem().split(separator: " ")[0]
        
        return (first: first, second: second )
    }
    
    static let fakeFI_m = ["Десятков Савелий",
                         "Жикин Демьян",
                         "Самохин Иосиф",
                         "Лагошин Вячеслав",
                         "Браславец Прокофий",
                         "Яркин Лаврентий",
                         "Терентьев Никанор",
                         "Пирогов Виталий",
                         "Кортнев Агафон",
                         "Мартьянов Харитон",
                         "Голубовский Всеслав",
                         "Тесла Панкратий",
                         "Шалупов Аркадий",
                         "Кашников Святослав",
                         "Дроков Кир",
                         "Стегнов Иннокентий",
                         "Гнездилов Севастьян",
                         "Водопьянов Эрнест",
                         "Русинов Феофан",
                         "Шашков Антон"]
    
    static let fakeFI_f = ["Гандельсмана Софья",
                           "Цехановецкая Розалия",
                           "Лелух Дарья",
                           "Горелова Вероника",
                           "Сарнычева Владислава",
                           "Бруевича Полина",
                           "Жилина Лиана",
                           "Рябкова Ксения",
                           "Педича Мирослава",
                           "Овечкина Диана",
                           "Глазкова Розалия",
                           "Крайнева Инна",
                           "Воробьева Каролина",
                           "Сухарникова Маргарита",
                           "Шубкина Марина",
                           "Ямпольская Стела",
                           "Дурова Лариса",
                           "Манякина Владлена",
                           "Шлыкова Нина",
                           "Капылюшная Рената"]

}
