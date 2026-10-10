using UnityEngine;

namespace Reptile
{
	[CreateAssetMenu(fileName = "InputControllerGuidData", menuName = "Reptile/Input/Input Controller Guid Data", order = 0)]
	public class InputControllerGuidData : ScriptableObject
	{
		public string dualShock4Guid = string.Empty;

		public string dualSenseGuid = string.Empty;

		public string xbox360Guid = string.Empty;

		public string xboxOneGuid = string.Empty;

		public string steamControllerGuid = string.Empty;

		public string switchProControllerGuid = string.Empty;
	}
}
