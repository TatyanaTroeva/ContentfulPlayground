/*: 
## Setup

Before running this, please build the "ContentfulPlayground" scheme to build the SDK. The following is some Playground specific setup. */
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

/*: Contentful is an API-first CMS which helps developers put content in their apps with API calls, and offers editors a familiar-looking web app for creating and managing content.

This Playground shows how to make a call to the Contentful API, explains what the response looks like, and suggests some relevant next steps. */

import Contentful

/*: This is the space ID. A space is like a project folder in Contentful terms. */
let SPACE = "developer_bookshelf"

/*: This is the access token for this space. Normally you get both ID and the token in the Contentful web app. */
let TOKEN = "0b7f6x59a0"

/*: 
## Make the first request

Create a client object using those credentials, this will be used to make most API requests. */
let client = Client(spaceIdentifier: SPACE, accessToken: TOKEN)

/*: To request an entry with the specified ID: */
client.fetchEntry("5PeGS2SoZGSa4GuiQsigQu").1
    .error { print($0) }
    .next  {

/*: All resources in Contentful have a variety of read-only, system-managed properties, stored in their “sys” property. This includes things like when the resource was last updated and how many revisions have been published. */
        print($0.sys)

/*: Entries contain a collection of fields, key-value pairs containing the content created in the web app. */
        print($0.fields)

/*: 
## Custom content structures

Contentful is built on the principle of structured content: a set of key-value pairs is not a great interface to program against if the keys and data types are always changing!

Just the same way you can set up any content structure in a MySQL database, you can set up a custom content structure in Contentful, too. There are no presets, templates, or anything of the kind – you can (and should) set everything up depending on the logic of your project.

This structure is maintained by content types, which define what data fields are present in a content entry. */
        guard let contentType = $0.sys["contentType"] else { return }
        print(contentType)
    }

/*: This is a link to the content type which defines the structure of this entry. Being API-first, we can of course fetch this content type from the API and inspect it to understand what it contains. */

client.fetchContentType("book").1
    .error { print($0) }
    .next  {

/*: Like entries, content types have a set of read-only system managed properties. */
        print($0.sys)

/*: A content type is a container for a collection of fields: */
        guard let field = $0.fields.first else { return }

/*: The field ID is used in API responses. */
        print(field.identifier)

/*: The field name is shown to editors. */
        print(field.name)

/*: Indicates whether the content in this field can be translated to another language. */
        print(field.localized)

/*: The field type determines what can be stored in the field, and how it is queried. */
        print(field.type)
    }

/*:

**To sum up**: Contentful enables structuring content in any possible way, making it accessible both to developers through the API and for editors via the web interface. It becomes a reasonable tool to use for any project that involves at least some content that should be properly managed – by editors, in a CMS – instead of having developers deal with the pain of hardcoded content.

[Next](@next)
*/
