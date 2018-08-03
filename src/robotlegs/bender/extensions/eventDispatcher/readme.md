# Event Dispatcher Extension

## Overview

The event dispatcher extension simply maps a shared event dispatcher into a context. The extension is required by many event driven extensions.

## Extension Installation

```haxe
_context = new Context()
    .install(EventDispatcherExtension);
```

You can provide the dispatcher instance you wish to use manually if you so desire:

```haxe
_context = new Context()
    .install(new EventDispatcherExtension(dispatcher));
```

## Extension Usage

An instance of IEventDispatcher is mapped into the context during extension installation. This instance can be injected into clients.

```haxe
@inject public var eventDispatcher:IEventDispatcher;
```
