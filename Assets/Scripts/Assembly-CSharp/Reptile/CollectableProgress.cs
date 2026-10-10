using System.IO;

namespace Reptile
{
	public class CollectableProgress : ProgressableData
	{
		public int version;

		public bool canOpen;

		public bool pickedUp;

		public CollectableProgress()
		{
			progressableType = ProgressableType.COLLECTABLE_PROGRESS;
		}

		public override void Write(BinaryWriter writer)
		{
			writer.Write(version);
			writer.Write(uid);
			writer.Write(pickedUp);
			writer.Write(canOpen);
		}

		public override void Read(BinaryReader reader)
		{
			version = reader.ReadInt32();
			if (version >= 0)
			{
				uid = reader.ReadString();
				pickedUp = reader.ReadBoolean();
				canOpen = reader.ReadBoolean();
			}
		}
	}
}
