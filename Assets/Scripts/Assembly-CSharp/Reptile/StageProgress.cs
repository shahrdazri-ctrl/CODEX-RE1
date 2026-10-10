using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace Reptile
{
	public class StageProgress : ISaveable
	{
		public int version = 2;

		public Stage stageID = Stage.NONE;

		public int reputation;

		public bool alreadyVisited;

		private List<ProgressableData> progressables = new List<ProgressableData>();

		public float highestCombo;

		public bool policeAllowed;

		public bool mapFound;

		public bool taxiFound;

		public int crewCounter;

		public Vector3 respawnPos = Vector3.zero;

		public Vector3 respawnRot = Vector3.zero;

		public bool graffitiBombedAchievementUnlocked;

		public bool IsFirstVisitToStage => progressables.Count <= 0;

		public StageProgress()
		{
		}

		public StageProgress(Stage stageID)
		{
			this.stageID = stageID;
		}

		public void Write(BinaryWriter writer)
		{
			writer.Write(version);
			writer.Write(stageID.ToString());
			writer.Write(reputation);
			writer.Write(alreadyVisited);
			writer.Write(progressables.Count);
			for (int i = 0; i < progressables.Count; i++)
			{
				writer.Write((int)progressables[i].ProgressableType);
				progressables[i].Write(writer);
			}
			writer.Write(highestCombo);
			writer.Write(policeAllowed);
			writer.Write(mapFound);
			writer.Write(taxiFound);
			writer.Write(crewCounter);
			writer.Write(respawnPos.x);
			writer.Write(respawnPos.y);
			writer.Write(respawnPos.z);
			writer.Write(respawnRot.x);
			writer.Write(respawnRot.y);
			writer.Write(respawnRot.z);
		}

		public void Read(BinaryReader reader)
		{
			version = reader.ReadInt32();
			if (version >= 0)
			{
				Enum.TryParse<Stage>(reader.ReadString(), out stageID);
				reputation = reader.ReadInt32();
				alreadyVisited = reader.ReadBoolean();
				int num = reader.ReadInt32();
				for (int i = 0; i < num; i++)
				{
					ProgressableData progressableData = ProgressableDataFactory.Create((ProgressableType)reader.ReadInt32());
					progressableData.Read(reader);
					progressables.Add(progressableData);
				}
			}
			if (version >= 1)
			{
				highestCombo = reader.ReadSingle();
				policeAllowed = reader.ReadBoolean();
				mapFound = reader.ReadBoolean();
				taxiFound = reader.ReadBoolean();
				crewCounter = reader.ReadInt32();
				respawnPos.x = reader.ReadSingle();
				respawnPos.y = reader.ReadSingle();
				respawnPos.z = reader.ReadSingle();
				respawnRot.x = reader.ReadSingle();
				respawnRot.y = reader.ReadSingle();
				respawnRot.z = reader.ReadSingle();
			}
		}

		internal void WriteVersion1(BinaryWriter writer)
		{
			writer.Write(stageID.ToString());
			writer.Write(graffitiBombedAchievementUnlocked);
		}

		internal void ReadVersion1(BinaryReader reader)
		{
			graffitiBombedAchievementUnlocked = reader.ReadBoolean();
		}

		public bool HasProgressableData(string uid)
		{
			return progressables.Exists((ProgressableData progressable) => progressable.Uid.Equals(uid));
		}

		public ProgressableData GetProgressableData(string uid)
		{
			int num = progressables.FindIndex((ProgressableData progressable) => progressable.Uid.Equals(uid));
			if (num >= 0)
			{
				return progressables[num];
			}
			return null;
		}

		public ProgressableData CreateProgressableData(string uid, ProgressableType progressableType)
		{
			ProgressableData progressableData = null;
			progressableData = ProgressableDataFactory.Create(progressableType);
			progressableData.Uid = uid;
			progressables.Add(progressableData);
			return progressableData;
		}

		public void AddRep(int amount)
		{
			reputation += amount;
		}

		public void AddCrewCounter()
		{
			crewCounter++;
		}

		public void SetHighestCombo(float combo)
		{
			highestCombo = Mathf.Max(highestCombo, combo);
		}
	}
}
