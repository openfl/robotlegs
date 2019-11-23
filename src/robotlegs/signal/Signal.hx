package robotlegs.signal;

/**
 * This is an abstraction on top of the underlying signals implementation.
 * The purpose is to allow projects to use the signals implementation of their
 * choosing, Robotlegs will then also use this implemtation.
 *
 * It can be used by any code that wishes to remain agnostic as to the underlying
 * signal implementation.
 *
 * The reference implementation is the 'signals' library, and this is used with zero cost.
 * Other supported libraries will be added with 'near-zero' cost.
 * If no 'near-zero' solution is available for a particular feature, compilation errors
 * are guaranteed.
 *
 * The only other supported library currently is 'msignal', others may also be added over time.
 *
 * @author Thomas Byrne
 */
#if signals
typedef Signal = signals.Signal;
typedef Signal1<T> = signals.Signal1<T>;
typedef Signal2<T, K> = signals.Signal2<T, K>;
typedef SignalType = Signal;
typedef Signal1Type<T> = Signal1<T>;
typedef Signal2Type<T, K> = Signal2<T, K>;
#elseif msignal
typedef SignalType = msignal.Signal.Signal0;
typedef Signal1Type<T> = msignal.Signal.Signal1<T>;
typedef Signal2Type<T, K> = msignal.Signal.Signal2<T, K>;

@:forward(dispatch, numListeners)
abstract Signal(msignal.Signal.Signal0) from SignalType {
	public inline function new()
		this = new msignal.Signal.Signal0();

	public inline function add(callback:Void->Void, ?fireOnce:Bool = false, ?priority:Int = 0, ?fireOnAdd:Null<Bool> = null):Void {
		if (fireOnce) {
			this.addOnceWithPriority(callback, priority);
		} else {
			this.addWithPriority(callback, priority);
		}
		if (fireOnAdd)
			callback();
	}

	public function remove(handler:Void->Void = null) {
		if (handler == null)
			this.removeAll();
		else
			remove(handler);
	}

	/**
	 * Use the .priority method to specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @param value An optional Int that specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @return BaseSignal<Callback>
	 */
	public function priority(value:Int):BaseSignal<Callback> {
		trace("not implemented");
		return this;
	}

	/**
	 * Use the .repeat method to define the number of times the callback should be triggered before removing itself. Default value = -1 which means it will not remove itself.
	 *
	 * @param value An Int that specifies the number of repeats before automatically removing itself.
	 *
	 * @return BaseSignal<Callback>
	 */
	public function repeat(value:Int = -1):BaseSignal<Callback> {
		trace("not implemented");
		return this;
	}

	/**
	 * Use the .fireOnAdd method that if called will immediately call the most recently added callback.
	 *
	 * @return Void
	 */
	public function fireOnAdd():Void {
		trace("not implemented");
	}
}

@:forward(dispatch, numListeners)
abstract Signal1<T>(msignal.Signal.Signal1<T>) from Signal1Type<T> {
	public inline function new()
		this = new msignal.Signal.Signal1();

	// fireOnAdd=true not yet supported
	public inline function add(callback:T->Void, ?fireOnce:Bool = false, ?priority:Int = 0):Void {
		if (fireOnce) {
			this.addOnceWithPriority(callback, priority);
		} else {
			this.addWithPriority(callback, priority);
		}
	}

	public function remove(handler:T->Void = null) {
		if (handler == null)
			this.removeAll();
		else
			remove(handler);
	}

	/**
	 * Use the .priority method to specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @param value An optional Int that specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @return BaseSignal<Callback>
	 */
	public function priority(value:Int):BaseSignal<Callback> {
		trace("not implemented");
		return this;
	}

	/**
	 * Use the .repeat method to define the number of times the callback should be triggered before removing itself. Default value = -1 which means it will not remove itself.
	 *
	 * @param value An Int that specifies the number of repeats before automatically removing itself.
	 *
	 * @return BaseSignal<Callback>
	 */
	public function repeat(value:Int = -1):BaseSignal<Callback> {
		trace("not implemented");
		return this;
	}

	/**
	 * Use the .fireOnAdd method that if called will immediately call the most recently added callback.
	 *
	 * @return Void
	 */
	public function fireOnAdd():Void {
		trace("not implemented");
	}
}

@:forward(dispatch, numListeners)
abstract Signal2<T, K>(msignal.Signal.Signal2<T, K>) from Signal2Type<T, K> {
	public inline function new()
		this = new msignal.Signal.Signal2();

	// fireOnAdd=true not yet supported
	public inline function add(callback:T->K->Void, ?fireOnce:Bool = false, ?priority:Int = 0, ?fireOnAdd:Null<Bool> = null):Void {
		if (fireOnce) {
			this.addOnceWithPriority(callback, priority);
		} else {
			this.addWithPriority(callback, priority);
		}
		if (fireOnAdd)
			throw 'Not supported';
	}

	public function remove(handler:T->K->Void = null) {
		if (handler == null)
			this.removeAll();
		else
			remove(handler);
	}

	/**
	 * Use the .priority method to specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @param value An optional Int that specifies the priority the order in which callbacks are fired, higher values will be triggered first.
	 *
	 * @return BaseSignal<Callback>
	 */
	public function priority(value:Int):BaseSignal<Callback> {
		trace("not implemented");
		return this;
	}

	/**
	 * Use the .repeat method to define the number of times the callback should be triggered before removing itself. Default value = -1 which means it will not remove itself.
	 *
	 * @param value An Int that specifies the number of repeats before automatically removing itself.
	 *
	 * @return BaseSignal<Callback>
	 */
	public function repeat(value:Int = -1):BaseSignal<Callback> {
		trace("not implemented");
		return this;
	}

	/**
	 * Use the .fireOnAdd method that if called will immediately call the most recently added callback.
	 *
	 * @return Void
	 */
	public function fireOnAdd():Void {
		trace("not implemented");
	}
}
#end

typedef Signal0 = Signal;
typedef AnySignal = haxe.extern.EitherType<Signal0, haxe.extern.EitherType<Signal1<Dynamic>, Signal2<Dynamic, Dynamic>>>;
