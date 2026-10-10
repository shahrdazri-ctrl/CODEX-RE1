using System.IO;

namespace Reptile
{
	public class SettingsData : ISaveable
	{
		private const int SETTINGS_SAVE_VERSION = 0;

		public GameplaySettings gameplaySettings;

		public VideoSettings videoSettings;

		public AudioSettings audioSettings;

		public InputSettings inputSettings;

		public bool isNew = true;

		public SettingsData()
		{
			gameplaySettings = new GameplaySettings();
			videoSettings = new VideoSettings();
			audioSettings = new AudioSettings();
			inputSettings = new InputSettings();
		}

		public void Write(BinaryWriter writer)
		{
			writer.Write(0);
			gameplaySettings.Write(writer);
			videoSettings.Write(writer);
			audioSettings.Write(writer);
			inputSettings.Write(writer);
		}

		public void Read(BinaryReader reader)
		{
			int num = reader.ReadInt32();
			isNew = false;
			if (num >= 0)
			{
				gameplaySettings.Read(reader);
				videoSettings.Read(reader);
				audioSettings.Read(reader);
				inputSettings.Read(reader);
			}
		}

		public void ResetVideoSettings()
		{
			videoSettings = new VideoSettings();
		}
	}
}
