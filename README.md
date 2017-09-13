# Listenable
[![Build Status](https://travis-ci.org/msaps/Listenable.svg?branch=master)](https://travis-ci.org/msaps/Listenable)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![CocoaPods](https://img.shields.io/cocoapods/v/Listenable.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov](https://codecov.io/gh/msaps/Listenable/branch/master/graph/badge.svg)](https://codecov.io/gh/msaps/Listenable)
[![GitHub release](https://img.shields.io/github/release/msaps/Listenable.svg)](https://github.com/msaps/Listenable/releases)

Swift object that provides an observable platform for multiple listeners.

## Requirements
- iOS 9.0+
- Xcode 8.x+
- Swift 3

## Installation
Listenable is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:
```ruby
    pod 'Listenable'
```
And run `pod install`.

## Usage
Create a Listenable object either by inheriting or initializing a Listenable typed with a protocol:

```swift
    class ListenableObject: Listenable<ListenableDelegate> {
      // Class
    }
```

You can then add and remove listeners, and update them as required...

Add Listener(s):
```swift
	add(listener: Listener, priority: ListenerPriority) -> Bool
	add(listeners: [Listener], priority: ListenerPriority) -> Void
```
Remove Listener(s):
```swift
	remove(listener: Listener) -> Bool
	remove(listeners: [Listener]) -> Void
	removeAllListeners()
```
Enumerate & Update Listeners:
```swift
	updateListeners(update: (listener: Listener, index: Int) -> Void)
```

#### Prioritisation
`ListenerPriority` allows for definition of enumeration priority for a listener; by default the `priority` parameter is set to `.low`. The following values can be assigned:
```swift
	.low 		(Raw: 0)
	.high 		(Raw: 1000)
	.custom		(Valid range: 0-1000)
```

Listeners can also be updated exclusively relative to their priority:
```swift
	updateListeners(withPriority: ListenerPriority?, 
				    	  update: (listener: Listener, index: Int) -> Void)
					   
	updateListeners(withPriorities: ClosedRange<Int>?, 
				    	    update: (listener: Listener, index: Int) -> Void)
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/MerrickSapsford/Listenable.

## License

The library is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
