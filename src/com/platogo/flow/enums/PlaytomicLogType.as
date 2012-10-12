package com.platogo.flow.enums 
{
	/**
	 * ...
	 * @author Dominik Hurnaus
	 */
	public final class PlaytomicLogType {
		
		private static var _enumCreated:Boolean = false;

		{
			_enumCreated = true;
		}
		
		public static const Play : PlaytomicLogType = new PlaytomicLogType("Play");
		public static const Freeze : PlaytomicLogType = new PlaytomicLogType("Freeze");
		public static const ForceSend : PlaytomicLogType = new PlaytomicLogType("ForceSend");
		public static const UnFreeze : PlaytomicLogType = new PlaytomicLogType("UnFreeze");
		public static const CustomMetric : PlaytomicLogType = new PlaytomicLogType("CustomMetric");
		public static const LevelCounterMetric : PlaytomicLogType = new PlaytomicLogType("LevelCounterMetric");
		public static const LevelAverageMetric : PlaytomicLogType = new PlaytomicLogType("LevelAverageMetric");
		public static const LevelRangedMetric : PlaytomicLogType = new PlaytomicLogType("LevelRangedMetric");
		public static const Heatmap : PlaytomicLogType = new PlaytomicLogType("Heatmap");

		private var _type:String;

		public function PlaytomicLogType(type:String) {
			if (_enumCreated) {
				throw new Error("PlaytomicLogType must not be instantiated directly.");
			}
			_type = type;
		}
		
		public function toString():String {
			return _type;
		}
	}
}