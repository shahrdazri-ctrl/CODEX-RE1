namespace Reptile
{
	public static class ControllerGuidHandlerFactory
	{
		public static IRewiredControllerGuidHandler CreateRewiredControllerGuidHandler(InputControllerGuidData inputControllerGuidData, APlatform platform)
		{
			return new RewiredControllerGuidHandler(inputControllerGuidData, platform);
		}
	}
}
