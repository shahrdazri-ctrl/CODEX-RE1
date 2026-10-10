using System.Collections;

namespace Reptile
{
	public class GraffitiSpotFinisher : GraffitiSpot
	{
		internal EnemyGraffitiSpotDamager enemyDamager;

		internal EnemyExtension enemyExtension;

		internal Encounter encounter;

		public override void Awake()
		{
			base.Awake();
			Core.Instance.StartCoroutine(DelayInitialize());
		}

		internal IEnumerator DelayInitialize()
		{
			while (WorldHandler.instance == null)
			{
				yield return null;
			}
			if (isUsingDecal)
			{
				while (topGraffiti.DecalRenderer == null || bottomGraffiti.DecalRenderer == null)
				{
					yield return null;
				}
			}
			InitializeFinisher();
		}

		internal void InitializeFinisher()
		{
			base.SetDefaultData((StageProgress)null);
		}

		internal void ToggleRenderers(bool setActive)
		{
			if (isUsingDecal)
			{
				return;
			}
			for (int i = 0; i < decalTopPlaneAlternativeRenderer.Length; i++)
			{
				if (decalTopPlaneAlternativeRenderer[i] != null)
				{
					decalTopPlaneAlternativeRenderer[i].enabled = setActive;
				}
			}
			for (int j = 0; j < decalBottomPlaneAlternativeRenderer.Length; j++)
			{
				if (decalBottomPlaneAlternativeRenderer[j] != null)
				{
					decalBottomPlaneAlternativeRenderer[j].enabled = setActive;
				}
			}
		}

		public override void SetState(GraffitiState setState)
		{
			state = setState;
			switch (state)
			{
			case GraffitiState.NONE:
			case GraffitiState.CANCEL:
				inGraffitiMode = false;
				ToggleMarker(!ClaimedByPlayableCrew());
				break;
			case GraffitiState.PAINTING:
				inGraffitiMode = true;
				ToggleMarker((bool)encounter && playerIsAI);
				break;
			case GraffitiState.PAINTING_COMPLETE:
				if ((bool)encounter)
				{
					encounter.GraffitiDoneSignal(ClaimedByPlayableCrew(onlyPlayer: true));
					ToggleMarker(showMarker: false);
					marker.SetActive(value: false);
				}
				else
				{
					ToggleMarker(!ClaimedByPlayableCrew());
				}
				break;
			case GraffitiState.FINISHED:
				inGraffitiMode = false;
				if (ClaimedByPlayableCrew())
				{
					OnFinish.Invoke();
				}
				if ((bool)encounter)
				{
					ToggleMarker(showMarker: false);
				}
				else
				{
					ToggleMarker(!ClaimedByPlayableCrew());
				}
				break;
			}
			if ((bool)enemyDamager)
			{
				enemyDamager.SetGraffitiResult(this, state);
			}
			if ((bool)enemyExtension)
			{
				enemyExtension.SetGraffitiResult(this, state);
			}
		}

		public override void GiveRep(bool noRepPickup = false)
		{
		}

		public override void SetDefaultData(StageProgress stageProgress = null)
		{
			InitializeFinisher();
		}

		public override void ReadFromData()
		{
		}

		public override void WriteToData()
		{
		}

		protected override void OnRegisterToSceneObjectsRegister(SceneObjectsRegister sceneObjectsRegister)
		{
		}

		public override bool CanDoGraffiti(Player byPlayer)
		{
			bool result = true;
			if (encounter != null)
			{
				result = encounter.IsWinnable();
			}
			else if (inGraffitiMode || byPlayer.crew == topCrew)
			{
				result = false;
			}
			return result;
		}

		public override bool CanBreakAwayFromByEnemies()
		{
			return false;
		}
	}
}
