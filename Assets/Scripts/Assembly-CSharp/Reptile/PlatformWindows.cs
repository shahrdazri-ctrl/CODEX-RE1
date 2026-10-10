using System;
using Rewired.Integration.UnityUI;
using UnityEngine;
using UnityEngine.Diagnostics;

namespace Reptile
{
	public class PlatformWindows : APlatform
	{
		public const string PLATFORM_WINDOWS_NAME = "Windows";

		public PlatformWindows()
		{
			platformName = "Windows";
			storage = new StorageWindows(Application.persistentDataPath);
			user = new UserWindows();
			errorHandler = new RegularErrorHandler(Core.Instance.errorQueuePrefab, storage);
			downloadableContent = new DownloadableContentWindows();
		}

		public override void HandleExceptionInGame(Exception exception)
		{
			Debug.LogException(exception);
			Utils.ForceCrash(ForcedCrashCategory.Abort);
		}

		protected override void SetRewiredEventSystemParameters(RewiredStandaloneInputModule rewiredStandAloneInputModule)
		{
			rewiredStandAloneInputModule.allowMouseInput = true;
			rewiredStandAloneInputModule.allowMouseInputIfTouchSupported = false;
			rewiredStandAloneInputModule.allowTouchInput = false;
		}
	}
}
