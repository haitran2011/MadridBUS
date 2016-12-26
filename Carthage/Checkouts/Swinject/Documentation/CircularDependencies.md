# Circular Dependencies

_Circular dependencies_ are dependencies of instances that depend on each other. To define circular dependencies in Swinject, one of the dependencies must be injected through a property.

## Initializer/Property Dependencies

Assume that you have `Parent` and `Child` classes depending on each other. `Parent` depends on `ChildType` through its initializer, and `Child` on `ParentType` through a property. The back-reference from `Child` to `ParentType` is a weak property to avoid a memory leak.

```swift
protocol ParentType: AnyObject { }
protocol ChildType: AnyObject { }

class Parent: ParentType {
    let child: ChildType?

    init(child: ChildType?) {
        self.child = child
    }
}

class Child: ChildType {
    weak var parent: ParentType?
}
```

The circular dependencies are defined as below:

```swift
let container = Container()
container.register(ParentType.self) { r in
    Parent(child: r.resolve(ChildType.self)!)
}
container.register(ChildType.self) { _ in Child() }
    .initCompleted { r, c in
        let child = c as! Child
        child.parent = r.resolve(ParentType.self)
    }
```

Here the injection to the `parent` property of `Child` must be specified in the `initCompleted` callback to avoid infinite recursion.

## Property/Property Dependencies

Similarly, assume that you have the following classes depending on each other, each via a property:

```swift
protocol ParentType: AnyObject { }
protocol ChildType: AnyObject { }

class Parent: ParentType {
    var child: ChildType?
}

class Child: ChildType {
    weak var parent: ParentType?
}
```

The circular dependencies are defined as below:

```swift
let container = Container()
container.register(ParentType.self) { r in
    let parent = Parent()
    parent.child = r.resolve(ChildType.self)!
    return parent
}
container.register(ChildType.self) { _ in Child() }
    .initCompleted { r, c in
        let child = c as! Child
        child.parent = r.resolve(ParentType.self)
    }
```

Here both or either of the depending properties must be specified in the `initCompleted` callback to avoid infinite recursion.

## Initializer/Initializer Dependencies

_Not supported._ This type of dependency causes infinite recursion.

_[Next page: Object Scopes](ObjectScopes.md)_

_[Table of Contents](README.md)_
