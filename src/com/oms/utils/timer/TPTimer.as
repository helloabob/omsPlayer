package com.oms.utils.timer
{
	
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	//定时器
	public class TPTimer extends EventDispatcher
	{
		protected var next:TPTimer;
		protected var previous:TPTimer;
		protected var endHandler:Function;
		protected var tickHandler:Function;
		protected var timeout:Number;
		protected var interval:Number;
		protected var lastVisited:Number = -1;
		protected var start:Number;
		protected var lastTick:Number = -1;
		protected var elapsedTimeAtPause:Number = 0;
		private var argvalue:Array;
		private static var ticker:Sprite;
		private static var blank:TPTimer = new TPTimer;
		private static var clockHandler:Function = run;
		public static var clock:Function = getTimer;
		private static var current:TPTimer;
		private static var head:TPTimer;
		private static const CANONICAL_END_EVENT:TPTimerEvent = new TPTimerEvent(TPTimerEvent.END, 0);
		private static const CANONICAL_TICK_EVENT:TPTimerEvent = new TPTimerEvent(TPTimerEvent.TICK, 0);
		private static const MIN_FPS:Number = 4;
		private static const MAX_FPS:Number = 24;
		private static var stage:Object;
		
		public function TPTimer(param1:Number = 0, param2:Number = 0)
		{
			this.endHandler = this.noop;
			this.tickHandler = this.noop;
			if (!ticker && blank)
			{
				ticker = new Sprite();
				resetClockHandler(clockHandler);
			}
			this.timeout = param1;
			this.interval = param2;
			if (blank)
			{
				this.restart();
			}
			return;
		}// end function
		
		override public function dispatchEvent(event:Event) : Boolean
		{
			switch(event.type)
			{
				case TPTimerEvent.END:
				{
					this.endHandler.apply(null, this.argvalue);
					break;
				}
				case TPTimerEvent.TICK:
				{
					this.tickHandler.apply(null, this.argvalue);
					break;
				}
				default:
				{
					super.dispatchEvent(event);
					break;
					break;
				}
			}
			return true;
		}// end function
		
		override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
		{
			switch(param1)
			{
				case TPTimerEvent.END:
				{
					this.endHandler = this.endHandler == this.noop ? (param2) : (super.dispatchEvent);
					break;
				}
				case TPTimerEvent.TICK:
				{
					this.tickHandler = this.tickHandler == this.noop ? (param2) : (super.dispatchEvent);
					break;
				}
				default:
				{
					break;
					break;
				}
			}
			super.addEventListener(param1, param2, param3, param4, param5);
			return;
		}// end function
		
		override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
		{
			//this.endHandler = (param1 == TPTimerEvent.END) && (this.endHandler == param2) ? (this.noop) : (this.endHandler);
			//this.tickHandler = (param1 == TPTimerEvent.TICK) && (this.tickHandler == param2) ? (this.noop) : (this.tickHandler);
			
			super.removeEventListener(param1, param2, param3);
			return;
		}// end function
		
		public function isTickable(param1:Number) : Boolean
		{
			return param1 - this.lastTick >= this.interval;
		}// end function
		
		protected function noop(... args) : void
		{
			return;
		}// end function
		
		public function isRunning() : Boolean
		{
			return this.next || this.previous || head == this;
		}// end function
		
		public function stop() : void
		{
			//这里要把其它的都关掉。。测试一下。
			if (current == this || current == blank && blank.next == this)
			{
				blank.next = this.next;
				current = blank;
			}
			if (this.previous)
			{
				this.previous.next = this.next;
			}
			if (this.next)
			{
				this.next.previous = this.previous;
			}
			if (head == this)
			{
				head = this.next;
			}
			this.previous = null;
			this.next = null;
			this.elapsedTimeAtPause = 0;
			return;
		}// end function
		
		public function restart() : void
		{
			this.elapsedTimeAtPause = 0;
			this.start = clock();
			if (!this.previous && !this.next)
			{
				if (head && head != this)
				{
					head.previous = this;
					this.next = head;
				}
				head = this;
			}
			return;
		}// end function
		
		public function resume() : void
		{
			var _loc_1:* = NaN;
			if (!this.isRunning())
			{
				_loc_1 = this.elapsedTimeAtPause;
				this.restart();
				this.start = this.start - _loc_1;
			}
			return;
		}// end function
		
		public function pause() : void
		{
			if (this.isRunning())
			{
				this.stop();
				this.elapsedTimeAtPause = clock() - this.start;
			}
			return;
		}// end function
		
		public static function setFrameRateOf(param1:Object) : void
		{
			TPTimer.stage = param1;
			return;
		}// end function
		//暂停后跳到这里了。
		private static function run(event:Event = null) : void
		{
			var mytimer:TPTimer;
			var elapsed:Number;
			var frameRate:Number;
			var event:* = event;
			var t:* = clock();
			current = head;
			var minInterval:* = Infinity;
			while (current && current.lastVisited < t)
			{
				
				mytimer = current;
				mytimer.lastVisited = t;
				elapsed = t - mytimer.start;
				if (mytimer.isTickable(t))
				{
					CANONICAL_TICK_EVENT.elapsed = elapsed;
					mytimer.lastTick = t;
					mytimer.dispatchEvent(CANONICAL_TICK_EVENT);
				}
				if (elapsed >= mytimer.timeout)
				{
					CANONICAL_END_EVENT.elapsed = elapsed;
					mytimer.dispatchEvent(CANONICAL_END_EVENT);
					mytimer.stop();
				}
				else
				{
					minInterval = Math.min(minInterval, mytimer.interval);
				}
				current = current.next;
			}
			current = null;
			blank.next = null;
			if (stage)
			{
				minInterval = Math.max(minInterval, 1);
				frameRate = Math.max(MIN_FPS, Math.min(1000 / minInterval, MAX_FPS));
				try
				{
					if (stage.frameRate != frameRate)
					{
						stage.frameRate = frameRate;
					}
				}
				catch (error:SecurityError)
				{
					stage = null;
				}
			}
			return;
		}// end function
		
		public static function resetClockHandler(param1:Function = null) : void
		{
			param1 = param1 || run;
			if (ticker)
			{
				ticker.removeEventListener(Event.ENTER_FRAME, clockHandler);
				ticker.addEventListener(Event.ENTER_FRAME, param1, false, 0, true);
			}
			clockHandler = param1;
			return;
		}// end function
		
		public static function composeClockHandler(param1:Function) : void
		{
			var method:* = param1;
			var handler:* = function (... args) : void
			{
				args.unshift(run);
				method.apply(null, args);
				return;
			}// end function
				;
			resetClockHandler(handler);
			return;
		}// end function
		
		public static function setInterval(param1:Function, param2:Number) : TPTimer
		{
			var args:* = new TPTimer(Infinity, param2);
			args.addEventListener(TPTimerEvent.TICK, param1);
			//args.argvalue = args;
			return args;
		}// end function
		
		public static function setTimeout(param1:Function, param2:Number) : TPTimer
		{
			var args:* = new TPTimer(param2, Infinity);
			args.addEventListener(TPTimerEvent.END, param1);
			//args.argvalue = args;
			return args;
		}// end function
	}
}