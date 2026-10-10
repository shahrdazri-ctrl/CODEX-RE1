using UnityEngine;

namespace Reptile
{
	[CreateAssetMenu(menuName = "Reptile/Phone/HomeScreen/New HomeScreen App")]
	public class HomeScreenApp : ScriptableObject
	{
		public enum HomeScreenAppType
		{
			NONE = -1,
			EMAIL,
			MUSIC,
			GRAFFITI,
			CAMERA,
			PHOTO_ALBUM,
			FORTUNE,
			BOMB_EATER
		}

		[SerializeField]
		private string m_AppName = string.Empty;

		[SerializeField]
		private string m_DisplayName = string.Empty;

		[SerializeField]
		private Sprite m_AppIcon;

		[SerializeField]
		private HomeScreenAppType appType = HomeScreenAppType.NONE;

		public string AppName => m_AppName;

		public string DisplayName => m_DisplayName;

		public Sprite DisplayIcon => m_AppIcon;

		public HomeScreenAppType AppType => appType;
	}
}
