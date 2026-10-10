using System.Collections;
using UnityEngine;

namespace Reptile
{
	public class UserWindows : AUser
	{
		public UserWindows()
		{
			videoSettingsManager = new VideoSettingsManager();
		}

		protected override IUserId GetDefaultUserID()
		{
			return new UserIdWindows(string.Empty);
		}

		protected override IEnumerator LoginUserASync()
		{
			isLoggedIn = true;
			userId = new UserIdWindows(string.Empty);
			videoSettingsManager.Init(VideoSettingsManager.GetDefaultAvailableVideoOptions());
			yield break;
		}

		protected override void LogoutUser()
		{
			isLoggedIn = false;
			userId = new UserIdWindows(string.Empty);
		}

		public override void SetUserSettings()
		{
			base.SetUserSettings();
			SetUserVideoSettings();
		}

		public override SystemLanguage GetUserLanguage()
		{
			return saveManager.Settings.gameplaySettings.currentLanguage;
		}
	}
}
