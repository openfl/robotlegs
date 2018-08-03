# Modularity Extension

## Overview

The modularity extensions wires contexts into a hierarchy based on the context view and allows for inter-modular communication.

## Basic usage

Communication between modules is facilitated by the Module Connector.

Setup to allow sending events from one module to the other:

```haxe
//ModuleAConfig.as

@inject public var moduleConnector: IModuleConnector;

moduleConnector.onDefaultChannel()
	.relayEvent(WarnModuleBEvent.WARN);
```

Setup to allow reception of events from another module:

```haxe
//ModuleBConfig.as
@inject public var moduleConnector:IModuleConnector;

moduleConnector.onDefaultChannel()
	.receiveEvent(WarnModuleBEvent.WARN);
```

Now ModuleB can map commands to the event, or allow mediators to attach listeners to it:

```haxe
eventCommandMap.map(WarnModuleBEvent.WARN)
	.toCommand(HandleWarningFromModuleACommand);
```

All ModuleA needs to do is dispatch the event:

```haxe
eventDispatcher.dispatchEvent(new WarnModuleBEvent(WarnModuleBEvent.WARN);
```

## Named channels

If you want to sandbox the communication between two modules, you can use named channels:

```haxe
//ModuleAConfig.as
moduleConnector.onChannel('A-and-B')
	.relayEvent(WarnModuleBEvent.WARN);
```

```haxe
//ModuleBConfig.as
moduleConnector.onChannel('A-and-B')
	.receiveEvent(WarnModuleBEvent.WARN);
```


## Requirements

This extension requires the following extensions:

+ ContextViewExtension

## Extension Installation

```haxe
_context = new Context()
    .install(ContextViewExtension, ModularityExtension)
    .configure(new ContextView(this));
```

In the example above we provide the instance "this" to use as the Context View. We assume that "this" is a valid DisplayObjectContainer.

By default the extension will be configured to inherit dependencies from parent contexts and expose dependencies to child contexts. You can change this by supplying parameters to the extension during installation:

```haxe
_context = new Context()
    .install(ContextViewExtension)
    .install(new ModularityExtension(true, false))
    .configure(new ContextView(this));
```

The example context above inherits dependencies from parent contexts but does not expose its own dependencies to child contexts. However, child contexts may still inherit dependencies from this context's parents.

