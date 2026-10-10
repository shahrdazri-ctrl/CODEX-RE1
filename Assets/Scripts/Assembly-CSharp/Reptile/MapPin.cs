using System.Collections.Generic;
using UnityEngine;

namespace Reptile
{
	public class MapPin : MonoBehaviour
	{
		public enum PinType
		{
			Pin,
			GraffitiPin,
			StoryObjectivePin
		}

		private StageProgress currentStageProgress;

		private GameObject graffitiSpotGameObject;

		private bool isMapPinActive;

		private bool isMapPinValid = true;

		internal PinType m_pinType;

		private GraffitiSpot m_GraffitiSpot;

		protected Transform objectiveTransform;

		protected GameObject m_ObjectiveObject;

		private Transform myTransform;

		[SerializeField]
		private LayerMask layerMask;

		private List<Vector3> positions = new List<Vector3>();

		protected Mapcontroller m_mapController { get; private set; }

		public virtual void Awake()
		{
			myTransform = base.transform;
			currentStageProgress = Core.Instance.SaveManager.CurrentSaveSlot.GetCurrentStageProgress();
		}

		public void InitMapPin(PinType pinType)
		{
			m_pinType = pinType;
			if ((m_GraffitiSpot == null && m_pinType == PinType.GraffitiPin) || (m_ObjectiveObject == null && m_pinType == PinType.StoryObjectivePin))
			{
				isMapPinValid = false;
				DisableMapPinGameObject();
			}
			else
			{
				SetupMapPin();
			}
		}

		public virtual void OnPinEnable()
		{
			positions.Clear();
			if (Physics.SphereCast(base.transform.position + 0.2f * Vector3.up, 0.175f, -Vector3.up, out var hitInfo, 1000f, layerMask, QueryTriggerInteraction.Ignore))
			{
				positions.Add(base.transform.position);
				positions.Add(new Vector3(base.transform.position.x, hitInfo.point.y, base.transform.position.z));
				GetComponent<LineRenderer>().enabled = true;
				GetComponent<LineRenderer>().SetPositions(positions.ToArray());
			}
			else
			{
				GetComponent<LineRenderer>().enabled = false;
			}
		}

		public virtual void PinUpdate()
		{
			if (isMapPinValid)
			{
				RefreshMapPin();
			}
		}

		private void SetupMapPin()
		{
			switch (m_pinType)
			{
			case PinType.GraffitiPin:
				graffitiSpotGameObject = m_GraffitiSpot.gameObject;
				if (graffitiSpotGameObject.activeSelf && currentStageProgress.mapFound && !m_GraffitiSpot.ClaimedByPlayableCrew())
				{
					EnableMapPinGameObject();
				}
				else
				{
					DisableMapPinGameObject();
				}
				break;
			case PinType.StoryObjectivePin:
				if (m_ObjectiveObject.activeSelf)
				{
					EnableMapPinGameObject();
				}
				else
				{
					DisableMapPinGameObject();
				}
				break;
			}
		}

		private void RefreshMapPin()
		{
			switch (m_pinType)
			{
			case PinType.GraffitiPin:
				RefreshGraffitiMapPin();
				break;
			case PinType.StoryObjectivePin:
				RefreshObjectivePin();
				break;
			}
		}

		private void RefreshGraffitiMapPin()
		{
			if (!graffitiSpotGameObject.activeSelf)
			{
				if (isMapPinActive)
				{
					DisableMapPinGameObject();
				}
			}
			else if (m_GraffitiSpot.ClaimedByPlayableCrew())
			{
				if (isMapPinActive)
				{
					DisableMapPinGameObject();
				}
			}
			else if (currentStageProgress.mapFound && !isMapPinActive)
			{
				EnableMapPinGameObject();
			}
		}

		private void RefreshObjectivePin()
		{
			if (!m_ObjectiveObject.activeSelf && isMapPinActive)
			{
				DisableMapPinGameObject();
			}
		}

		private void EnableMapPinGameObject()
		{
			base.gameObject.SetActive(value: true);
			isMapPinActive = true;
		}

		private void DisableMapPinGameObject()
		{
			base.gameObject.SetActive(value: false);
			isMapPinActive = false;
		}

		public virtual void SetLocation()
		{
			base.transform.localPosition = objectiveTransform.position;
		}

		public void DisablePin()
		{
			base.gameObject.SetActive(value: false);
		}

		public void EnablePin()
		{
			base.gameObject.SetActive(value: true);
		}

		public void SetMapController(Mapcontroller mapcontroller)
		{
			m_mapController = mapcontroller;
		}

		public void AssignGraffitiSpot(GraffitiSpot spot)
		{
			m_GraffitiSpot = spot;
			objectiveTransform = spot.transform;
			SetLocation();
		}

		public void AssignGameplayEvent(GameObject objectiveObject)
		{
			m_ObjectiveObject = objectiveObject;
			objectiveTransform = objectiveObject.transform;
			SetLocation();
		}
	}
}
