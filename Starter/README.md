# Giphy-Browser
This is a demo app for refactoring as part of the **Writing Swifty Swift** presentation at the *Flock of Swifts* meetup July 21st, 2018.

## //FIXME: Issue 1 (Easy) Make a computed property sizeDescription [GiphyPage.swift]
You'll often find that the way you present your data is not necessarily the way that its stored.  In these cases instead of repeating your formatting logic, you can make a computed property on your data class that returns the formatted value. Extend `Giphy.Images.Info` and make a computed property `sizeDescription` that uses a `ByteCountFormatter` to return a `String` from the `size` property

## //FIXME: Issue 2 (Easy) Make Rating an enum [GiphyPage.swift]
Swift `enums` allow you to express a finte group of values in a strongly typed way.  Remove the `Rating` `typealias` and add an `enum` called Rating that has cases to handle these JSON values: `g`, `pg`, `pg-13`, `r`, `y`.  Also make your `enum` conform to [`CustomStringConvertible`](https://developer.apple.com/documentation/swift/customstringconvertible) and have it return a   `description` like "Rated: R" for each case.  Discuss: Should we have an .unknown case for ratings that we don't know about or that might be added int he future?

## // FIXME: Issue 3 (Intermediate) Make all of the structs and enums in  [GiphyPage.swift] conform to Codable
Swift 4 introduces the `Encodable` and `Decodable` protocols that let you easily convert your types to and from other representations, just as JSON.  Add [Codeable](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) conformance to all of the data structs and enums in *GiphyPage.swift*  Bonus: apply what you learned about just-in-time mutability

## //FIXME: Issue 4 (Intermediate): Replace the redundant network code in [APIService.swift] with generic requests to getCodable
Note that you must have completed Issue 3 before starting Issue 4.  When you find yourself writing similar code over an over again that differs only in type, its a good clue that you should consider abstracting the common functionality into a generic function.  `APIService.getCodable(from:parameters:completion:)` is a generic function that makes a network request, and converts the response to an instance of a `Decodable` object or an `Error`.  Replace the network requests in this file with calls to `APIService.getCodable(from:parameters:completion:)`.

## FIXME: Issue 5: (Advanced): Refactor parameterString(from:) in [APIService.swift] to use more expressive functional idioms
`parameterString(from:)`  Constructs a url encoded parameter string from a dictionary and the required parameters on `APIService` in the form of `"key1=value1&key2=value2&key3=value3"`  Imperative code like this with several for loops can be difficult to read, understand and debug without drilling into the details of whats's going on in each loop.  Remove all of the `for` loops and replace them with expressive functional code.  Hint: take a look at the documentation for [Dictionary](https://developer.apple.com/documentation/swift/dictionary) to see how you can merge two dictionaries together.  Take a look at [Sequence](https://developer.apple.com/documentation/swift/sequence) to see how you can transform one Sequence to another and transform a Sequence into a single Scalar.

## //FIXME: Issue 6 (Easy) remove the forced unwrapped optionals in [GiphyListViewController]
Its usually best practice to remove all force unwraps `!` from your code, even if you know they will always succeed.  Its not always obvious to future you or to your coworkers who have to change your code that a `!` will succeed.  

## //FIXME: Issue 7 (Easy) make  searchController a lazy var in [GiphyListViewController]
Sometimes the only need for an optional `?` or implicitly unwrapped optional `!` is to defer initialization.  In such cases using the `lazy` pattern is preferable as it removes the optionality, makes the late binding obvious and is usually easier to reason about.

## //FIXME Issue 8 (Intermediate) Express this computation without any for loops [FavoriteHeaderView.swift]
Functional idioms are not only often more expressive an compact than their imperative counterparts, they also reduce mutability making it easier to reason about your code.  Remove all of the `var`s here by replacing the `for` loop with functional code. HINT Look at [Sequence](https://developer.apple.com/documentation/swift/sequence) to figure out how to transform a Sequence into a single Scalar

## //FIXME:  Issue 9 (Easy) make avergaeSize a let [FavoriteHeaderView.swift]
Immutability makes it easier to reason about your variables.  change `avergaesize` to be a `let`.  There are at least 3 different ways to do this.  How many can you come up with?  Using `count` on a `Sequence` is potentially expensive, since not all `Sequences` cache their number of elements and this can actually force a `Sequence` traversal.  Look at [Sequence](https://developer.apple.com/documentation/swift/sequence) and find a faster property to use (why is it faster?).

## //FIXME: Issue 10 (Advanced) replace heterogeneous types with enum [GifCache.swift]
`image(for:completion:)` takes a completion handler with 3 optional parameters, which allows for 8 (2^3) different possible ways to call the completion handle.  Notice in practice we only ever call the completion handler 2 ways: with a non optional Error and with a non optional URL & Image.  Express these two cases as an enum with associated values.  Properly handle both cases with a switch.  Bonus: make your enum generic.

## //FIXME: Issue 11 (Easy) Access control.  Make EVERYTHING that should be private private [GiphyCollectionViewCell.swift]
Adding proper access control to your code not only makes your code self documenting and discoverable by cleaning up the autocomplete and makes it easier to reason about your types and harder to misuse them.  Mark everything in this class that should be private as private.

## //FIXME: Issue 12 (Advanced) Generics.  Make the read and write functions generically read/write Decoable/Encodable types  [FileService.swift]
You must have completed Isssue 3 before starting on this task.  Reading/Writing a Codeable type is a task that varies only in type.  Its the perfect canidate for a generic function.  Make these two functions generic.

## //FIXME: Issue 13 (Intermediate) Data structures [GiphyListViewController.swift]
Discuss with your partner: what is the time complexity of doing a `contains`  on an array?  Is there a faster algorithm for `Array`?  Add a` favoritesId` variable that caches the id's of all of the favorites in data structure that is faster to look up.

## //FIXME: Issue 14 (Advanced) Protocol Extensions [UIKitExtensions.swift]
1. Make a protocol `ReuseIdentifiable` that declares a static variable named `resuseIdentifier.`
2. Give `resuseIdentifier` a default generic implmentation by extending it
3. Replace the `static var resuseIdentifier` on `GiphyCollectionViewCell` with conformance to `ReuseIdentifiable`

# Addtional Topics to explore
1. The gif library I am using sometimes has issues displaying.  Find and replace this library with a popular cocoapod.
2. The image cache does not persist between sessions.  Add a disk cache using either coredata or realm.
3. You cannot add or remove  a favorite in the detail view.  Add a button to do this.  Communicate the change with a protocol.  Rewrite it with an unwind segue.
4. Refactor the app to use MVVM.
5. The search section is currently empty until you perform a search.  Add an empty view.
6. Add proper error state views and pull to refresh
7. Add UISegmented control that lets you switch between search and trending: https://developers.giphy.com/docs/
8. Persist your favorites to the cloud and across devices with CloudKit or Firebase
9. There is an error with iOS in animating isHidden in a stackview.  Rewrite this animation with another method.
10.  The app uses a persistence timer, but its better to save changes when the array is mutated.

