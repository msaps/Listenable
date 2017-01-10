# Listenable

Listenable is an object that provides access to multiple observers for enhanced delegation distribution.

## Installation
Listenable is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

    pod 'Listenable'

And run `pod install`.

## Usage
Create a Listenable object either by inheriting or initializing a Listenable with the delegation protocol:

    class ListenableObject: Listenable<ListenableDelegate> {
      // Class
    }

You can then add and remove listeners, and update them as required...

Add Listener(s):

	add(listener: Listener) -> Bool
	add(listeners: [Listener]) -> Void
	
Remove Listener(s):

	remove(listener: Listener) -> Bool
	remove(listeners: [Listener]) -> Void
	removeAllListeners()
	
Enumerate & Update Listeners:

	updateListeners(updateBlock: (listener: Listener, index: Int) -> Void)
	
## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/MerrickSapsford/Listenable.

## License

The library is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

