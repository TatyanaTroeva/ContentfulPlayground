/*:
[Previous](@previous)

Before running this, please build the "ContentfulPlayground" scheme to build the SDK.
The following is some Playground specific setup. */
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: As a first step, you have to create a client object again.

import Contentful

let client = Client(spaceIdentifier: "cfexampleapi", accessToken: "b4c0n73n7fu1")

/*: You can fetch all entries from a space. 
 
 Each method for fetching data returns a tuple. The first result is an optional `NSURLSessionDataTask` which allows you to cancel the request and the second result is a Signal. */

let (task, signal) = client.fetchEntries()

//: The signal represents a stream of values over time, you can react to the eventual result of an array of entries:

signal.next {
    let total = $0.total
    let entry = $0.items.first?.fields["name"]
}

//: and you can also react to errors:

signal.error {
    print($0)
}

//: If you prefer a callback-based API, it is also available:

let otherTask = client.fetchEntries() { result in
    switch result {
    case let .Success(value):
        let total = value.total
        let entry = value.items.first?.fields["name"]
    case let .Error(error):
        print(error)
    }
}

//: You can also fetch more specific content, using search parameters:

client.fetchEntries([
    //: Only fetch entries of a specific type
    "content_type": "cat",
    //: Order the result by a field
    "order": "sys.createdAt"
    ]).1.next {
        let names = $0.items.flatMap { $0.fields["name"] }
        print(names)

        guard let cat = $0.items.first else { return }

//: Each entry has a number of read-only system fields, like its creation date
        let creationDate = cat.sys["createdAt"]

//: You also have access to its user-defined fields in a similar fashion
        var name = cat.fields["name"] ?? ""
        var likes = (cat.fields["likes"] as? NSArray)?.componentsJoinedByString(" and ") ?? ""
        var lives = cat.fields["lives"] as? Int ?? 0

        print(name)
        print("I like \(likes)")
        print("I have \(lives) lives")

//: The SDK will also resolve any included links automatically for you.
        guard let friend = cat.fields["bestFriend"] as? Entry else { return }

        name = friend.fields["name"] ?? ""
        likes = (friend.fields["likes"] as? NSArray)?.componentsJoinedByString(" and ") ?? ""

        print(name)
        print("I like \(likes)")
}

//: Contentful also supports localization of entries, you can fetch a specific locale using search parameters.
client.fetchEntries(["sys.id": "nyancat", "locale": "tlh"]).1.next {
    let name = $0.items.first?.fields["name"]

    print(name ?? "")
}

//: It is also possible to fetch all locales, by specific the "*" locale.
client.fetchEntries(["sys.id": "nyancat", "locale": "*"]).1.next {
    var cat = $0.items.first

//: In that case, the fields property will point to values of the currently selected locale.
    var currentLocale = cat?.locale
    var name = cat?.fields["name"]
    var likes = cat?.fields["lives"]

//: You can change the selected locale by changing the `locale` property.
    cat?.locale = "tlh"

    currentLocale = cat?.locale
    name = cat?.fields["name"]

//: Fields which have not been localized, fall back to the default locale of your space, similar to the behaviour of the API itself.
    likes = cat?.fields["lives"]
}

/*:
 As you saw, directly working with the field dictionaries involves a lot of explicit casting, because of Swift's strong typing and you also likely want to decouple the rest of your application from the Contentful SDK. To alleviate both of these issues, there is <https://github.com/contentful-labs/contentful-generator.swift>, which generates type-safe structs for your content model.
 
 Using the generator is easy:
 
 ```
 contentful-generator cfexampleapi b4c0n73n7fu1 --output out
 ```
 
 For the "Cat" content type of the example space, the generated code would look like this:
 */

import CoreLocation

struct Cat {
    let name: String?
    let likes: [String]?
    let color: String?
    let bestFriend: Entry?
    let lifes: Int?
    let lives: Int?
    let image: Asset?
}

import Contentful

extension Cat {
    static func fromEntry(entry: Entry) throws -> Cat {
        return Cat(
            name: entry.fields["name"] as? String,
            likes: (entry.fields["likes"] as? NSArray)?.map { $0 as? String }.flatMap { $0 },
            color: entry.fields["color"] as? String,
            bestFriend: entry.fields["bestFriend"] as? Entry,
            lifes: entry.fields["lifes"] as? Int,
            lives: entry.fields["lives"] as? Int,
            image: entry.fields["image"] as? Asset)
    }
}

//: Now dealing with the same entry as before becomes a lot more natural.
client.fetchEntries(["sys.id": "nyancat"]).1.next {
    guard let cat = try? Cat.fromEntry($0.items.first!) else { return }

    print(cat.name ?? "")
    print("I like \(cat.likes?.joinWithSeparator(" and ") ?? "")")
    print("I have \(cat.lives ?? 0) lives")

//: Linked entries need to be explicitly converted, because they can be of different content types.
    guard let friend = try? Cat.fromEntry(cat.bestFriend!) else { return }

    print(friend.name ?? "")
    print("I like \(friend.likes?.joinWithSeparator(" and ") ?? "")")
    print("I have \(friend.lives ?? 0) lives")
}

//: [Next](@next)
