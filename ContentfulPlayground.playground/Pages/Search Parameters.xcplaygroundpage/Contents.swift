/*:
 [Previous](@previous)

 Before running this, please build the "ContentfulPlayground" scheme to build the SDK.
 The following is some Playground specific setup. */
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: As a first step, you have to create a client object again.

import Contentful

let client = Client(spaceIdentifier: "cfexampleapi", accessToken: "b4c0n73n7fu1")

/*:
 Each collection endpoint supports a variety of query parameters to search & filter the items that will be included in the response. While the API calls in this section are focused on entries, the same query parameter syntax can be used to filter assets and content types as well.
 
 This page lists all possible search parameters supported by the API. You can find additional information in our API documentation <http://docs.contentfulcda.apiary.io/#reference/search-parameters>. The parameters are modelled as a dictionary and automatically convert arrays, dates and numbers to the right format.
 */

//: Searching by content type
client.fetchEntries(["content_type": "cat"]).1.next {
    print($0)
}

//: Search for entries with specific values (equality)
client.fetchEntries(["sys.id": "nyancat"]).1.next {
    print($0)
}

//: Search for entries without specific values (inequality)
client.fetchEntries(["sys.id[ne]": "nyancat"]).1.next {
    print($0)
}

//: Searching for entries with specific values also works for arrays
client.fetchEntries(["content_type": "cat", "fields.likes": "lasagna"]).1.next {
    print($0)
}

//: Filtering a field by multiple values.
client.fetchEntries(["sys.id[in]": ["finn", "jake"]]).1.next {
    print($0)
}

//: Multiple-value filters can also be inverted.
client.fetchEntries(["content_type": "cat", "fields.likes[nin]": ["rainbows", "lasagna"]]).1.next {
    print($0)
}

//: You can check for the presence of a value.
client.fetchEntries(["sys.archivedVersion[exists]": "false"]).1.next {
    print($0)
}

//: You can filter using range operators, like less than or equal.
client.fetchEntries(["sys.updatedAt[lte]": NSDate()]).1.next {
    print($0)
}

//: Full-text search across all text and symbol fields is also supported.
client.fetchEntries(["query": "bacon"]).1.next {
    print($0)
}

//: Or you can search for text in a specific field.
client.fetchEntries(["content_type": "dog", "fields.description[match]": "bacon pancakes"]).1.next {
    print($0)
}

//: If you have location-enabled content, you can use it for searching as well. Sort results by distance.
client.fetchEntries(["content_type": "1t9IbcfdCk6m04uISSsaIK", "fields.center[near]": "38,-122"]).1.next {
    print($0)
}

//: Or retrieve all resources in a bounding rectangle.
client.fetchEntries(["content_type": "1t9IbcfdCk6m04uISSsaIK", "fields.center[within]": "40,-124,36,-121"]).1.next {
    print($0)
}

//: Sort results by field values.
client.fetchEntries(["order": "sys.createdAt"]).1.next {
    print($0)
}

//: Sort results by field values in reverse order.
client.fetchEntries(["order": "-sys.createdAt"]).1.next {
    print($0)
}

//: Or order results by multiple fields.
client.fetchEntries(["order": "sys.revision,sys.id"]).1.next {
    print($0)
}

//: The API returns a maximum of 1000 entries, but the default is 100. You can specify the amount of results to return.
client.fetchEntries(["limit": 3]).1.next {
    print($0)
}

//: And you can skip a number of results. By combining both parameters, you can do paging for larger result sets.
client.fetchEntries(["skip": 3]).1.next {
    print($0)
}

//: Finally, you can filter assets by their MIME type.
client.fetchAssets(["mimetype_group": "image"]).1.next {
    print($0)
}
