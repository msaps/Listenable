import UIKit
import XCPlayground
import Listenable

/*:
 # Listenable
 **A Swift object that provides an observable platform for multiple listeners.**
 
 This playground shows some of the useful observable behaviour that **Listenable** can be used for.
 
 ### Basics
 
 Create an object that you want to make observable, and make it inherit from Listenable, parameterized with the protocol that observers must conform to.
 */
protocol ObjectObservable {
    
    func doStuff()
}

class Object: Listenable<ObjectObservable> {
    
}
/*:
 With an instance of your observable object, you can then attach listeners that will receive updates when prompted.
 */
class Listener: ObjectObservable {
    
    func doStuff() {
        print("Update Received")
    }
}

let observableObject = Object()
let listener = Listener()

observableObject.add(listener: listener)

/*:
 Then you can simply prompt the listeners with updates whenever you require from your observable object.
 */

extension Object {
    
    func action() {
        updateListeners { (listener, index) in
            listener.doStuff()
        }
    }
}
