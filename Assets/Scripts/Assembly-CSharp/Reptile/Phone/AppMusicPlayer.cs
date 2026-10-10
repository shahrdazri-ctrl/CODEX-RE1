using System.Collections.Generic;
using UnityEngine;

namespace Reptile.Phone
{
	public class AppMusicPlayer : App
	{
		[SerializeField]
		private MusicPlayerTrackList m_TrackList;

		[Space(5f)]
		[SerializeField]
		private MusicPlayerStatusPanel m_StatusPanel;

		[SerializeField]
		private AudioAnalyzer m_AudioAnalyzer;

		private float continuousScrollTimer;

		private const float initialScrollInterval = 0.4f;

		private const float continuousScrollInterval = 0.1f;

		public IMusicPlayer GameMusicPlayer { get; private set; }

		public AudioAnalyzer AudioVisualizer => m_AudioAnalyzer;

		private void Update()
		{
		}

		protected override void OnAppInit()
		{
			GameMusicPlayer = Core.Instance.AudioManager.MusicPlayer;
			RefreshUnlockedMusicTracks();
			m_TrackList.InitalizeScrollView();
			m_StatusPanel.Initalize(this);
			m_AudioAnalyzer.Initalize(Core.Instance.musicAudioSource);
			DisableAudioAnalyzer();
		}

		private void RefreshUnlockedMusicTracks()
		{
			AUnlockable[] unlockables = base.Unlockables;
			foreach (AUnlockable aUnlockable in unlockables)
			{
				UnlockableSaveData unlockableSaveDataFor = Core.Instance.Platform.User.GetUnlockableSaveDataFor(aUnlockable);
				MusicTrack musicTrack = aUnlockable as MusicTrack;
				if (unlockableSaveDataFor.IsUnlocked)
				{
					GameMusicPlayer.AddMusicTrack(musicTrack);
				}
			}
		}

		public override void OnAppRefresh()
		{
			RefreshUnlockedMusicTracks();
			RefreshList();
		}

		public override void OnAppEnable()
		{
			base.OnAppEnable();
			RefreshUnlockedMusicTracks();
			RefreshList();
			EnableAudioAnalyzer();
		}

		public override void OnAppDisable()
		{
			base.OnAppDisable();
			DisableAudioAnalyzer();
		}

		public void EnableAudioAnalyzer()
		{
			m_AudioAnalyzer.enabled = true;
		}

		public void DisableAudioAnalyzer()
		{
			m_AudioAnalyzer.enabled = false;
		}

		public override void OnAppUpdate()
		{
			m_StatusPanel.UpdatePanel();
		}

		public override void OnPressRight()
		{
			m_TrackList.HoldAnimationSelectedButton();
		}

		public override void OnPressUp()
		{
			m_TrackList.Move(PhoneScroll.ScrollDirection.Previous, m_AudioManager);
			continuousScrollTimer -= 0.4f;
		}

		public override void OnPressDown()
		{
			m_TrackList.Move(PhoneScroll.ScrollDirection.Next, m_AudioManager);
			continuousScrollTimer -= 0.4f;
		}

		public override void OnHoldUp()
		{
			continuousScrollTimer += Core.dt;
			if (continuousScrollTimer >= 0.1f)
			{
				continuousScrollTimer = 0f;
				m_TrackList.Move(PhoneScroll.ScrollDirection.Previous, m_AudioManager);
			}
		}

		public override void OnHoldDown()
		{
			continuousScrollTimer += Core.dt;
			if (continuousScrollTimer >= 0.1f)
			{
				continuousScrollTimer = 0f;
				m_TrackList.Move(PhoneScroll.ScrollDirection.Next, m_AudioManager);
			}
		}

		public override void OnReleaseUp()
		{
			continuousScrollTimer = 0f;
		}

		public override void OnReleaseDown()
		{
			continuousScrollTimer = 0f;
		}

		public override void OnReleaseRight()
		{
			if (m_TrackList.GetContentIndex() == GameMusicPlayer.CurrentTrackIndex)
			{
				TogglePause();
			}
			else
			{
				PlaySong(m_TrackList.GetContentIndex());
				(m_TrackList.SelectedButtton as PhoneScrollUnlockableButton).SetUnread(isUnread: false);
			}
			m_TrackList.ActivateAnimationSelectedButton();
		}

		private void RefreshList()
		{
			m_TrackList.musicAlfabeticList = new List<int>();
			for (int i = 0; i < GameMusicPlayer.AmountOfTracks; i++)
			{
				m_TrackList.musicAlfabeticList.Add(i);
			}
			m_TrackList.SetListContent(GameMusicPlayer.AmountOfTracks);
		}

		public void PlaySong(int index)
		{
			GameMusicPlayer.PlayFrom(index);
			MusicTrack musicTrack = GetMusicTrack(index);
			Core.Instance.Platform.User.GetUnlockableSaveDataFor(musicTrack).HasSeen = true;
		}

		public void TogglePause()
		{
			if (GameMusicPlayer.IsPlaying)
			{
				GameMusicPlayer.Pause();
			}
			else
			{
				GameMusicPlayer.Play();
			}
		}

		public MusicTrack GetMusicTrack(int index)
		{
			return GameMusicPlayer.GetMusicTrack(index);
		}

		public MusicTrack GetCurrentMusicTrack()
		{
			return GameMusicPlayer.GetMusicTrack(GameMusicPlayer.CurrentTrackIndex);
		}

		public override void OpenContent(AUnlockable unlockable, bool appAlreadyOpen)
		{
			if (!(unlockable == null))
			{
				if (appAlreadyOpen)
				{
					RefreshUnlockedMusicTracks();
					RefreshList();
				}
				m_TrackList.FindAndMoveTo(unlockable, m_AudioManager);
			}
		}
	}
}
