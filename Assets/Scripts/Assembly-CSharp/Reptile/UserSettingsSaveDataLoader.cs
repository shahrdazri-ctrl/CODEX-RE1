using System.Collections;

namespace Reptile
{
	public class UserSettingsSaveDataLoader : AUserSaveDataLoader
	{
		private AUser user;

		public UserSettingsSaveDataLoader(SaveManager saveManager, AStorage storage, AErrorHandler errorHandler, UIManager uIManager, AUser user, IGameTextLocalizer localizer)
			: base(saveManager, storage, errorHandler, uIManager, localizer)
		{
			this.user = user;
		}

		public override IEnumerator LoadSaveDataASync()
		{
			yield return LoadUserSettingsASync();
		}

		public override string ToString()
		{
			return "User settings";
		}

		private IEnumerator LoadUserSettingsASync()
		{
			ATransaction loadSettingsTransaction = saveManager.LoadSettings();
			yield return DoTransactionASync(loadSettingsTransaction, base.HandleLoadUserSaveDataErrorASync, base.DoTransactionASync);
			if (isSuccess)
			{
				HandleLoadSettingsSuccess(loadSettingsTransaction);
			}
		}

		private void ResetUserSettings()
		{
			saveManager.ResetSettings();
			user.SetUserSettings();
		}

		private void HandleLoadSettingsSuccess(ATransaction loadSettingsTransaction)
		{
			if (loadSettingsTransaction.IsSuccess || errorHandlingResult == ErrorHandlingResult.RESOLVED)
			{
				user.SetUserSettings();
			}
			else if (loadSettingsTransaction.Status == ATransaction.TransactionStatus.FILE_NOT_FOUND || errorHandlingResult == ErrorHandlingResult.DELETED)
			{
				CreateNewUserSettings();
			}
		}

		private void CreateNewUserSettings()
		{
			saveManager.ResetSettings();
			saveManager.Settings.gameplaySettings.currentLanguage = localizer.Language;
			user.SetUserSettings();
			saveManager.SaveSettings();
		}
	}
}
