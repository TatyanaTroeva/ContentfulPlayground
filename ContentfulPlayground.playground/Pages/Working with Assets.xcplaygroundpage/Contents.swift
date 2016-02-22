/*: 
[Previous](@previous)

Before running this, please build the "ContentfulPlayground" scheme to build the SDK.
The following is some Playground specific setup. */
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: As a first step, you have to create a client object again.

import Contentful

let client = Client(spaceIdentifier: "cfexampleapi", accessToken: "b4c0n73n7fu1")

//: Assets represent any kind of media you are storing in Contentful. The API is similar to fetching entries.
client.fetchAssets().1.next {
    let total = $0.total
    let entry = $0.items.first?.fields["title"]
}

//: Also similar to entries, assets can be queried using IDs or search parameters.
client.fetchAssets(["sys.id": "nyancat"]).1.next {
    guard let asset = $0.items.first else { return }

//: Fetching the data of an asset is simple.
    asset.fetch().1.next {
        let data = $0
    }

//: Since many assets will be images, there is a short-hand API for them.
    asset.fetchImage().1.next {
        let image = $0
    }
}

//: [Next](@next)
