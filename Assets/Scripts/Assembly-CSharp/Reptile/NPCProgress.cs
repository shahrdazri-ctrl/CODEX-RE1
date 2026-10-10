using System.IO;

namespace Reptile
{
	public class NPCProgress : ProgressableData
	{
		private int version;

		public bool canOpen;

		public int dialogueLVL = -1;

		public NPCProgress()
		{
			progressableType = ProgressableType.NPC_PROGRESS;
		}

		public override void Write(BinaryWriter writer)
		{
			writer.Write(version);
			writer.Write(uid);
			writer.Write(dialogueLVL);
			writer.Write(canOpen);
		}

		public override void Read(BinaryReader reader)
		{
			version = reader.ReadInt32();
			if (version >= 0)
			{
				uid = reader.ReadString();
				dialogueLVL = reader.ReadInt32();
				canOpen = reader.ReadBoolean();
			}
		}
	}
}
