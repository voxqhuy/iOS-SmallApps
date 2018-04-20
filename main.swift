import Foundation

struct Babe {
  let title: String
  let signer: String
  let duration: Int
  
  var formattedTitle: String {
    return "\(title)s"
  }
  
  func heavierThan(_)
}

let babe = Babe(title: "a", signer: "b", duration: 1)
print(babe.formattedTitle)