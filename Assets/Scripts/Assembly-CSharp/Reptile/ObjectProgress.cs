using System.IO;

namespace Reptile
{
	public class ObjectProgress : ProgressableData
	{
		public int version;

		public bool isActive;

		public bool isTriggered;

		public ObjectProgress()
		{
			progressableType = ProgressableType.OBJECT_PROGRESS;
		}

		public override void Write(BinaryWriter writer)
		{
			writer.Write(version);
			writer.Write(uid);
			writer.Write(isActive);
			writer.Write(isTriggered);
		}

		public override void Read(BinaryReader reader)
		{
			version = reader.ReadInt32();
			if (version >= 0)
			{
				uid = reader.ReadString();
				isActive = reader.ReadBoolean();
				isTriggered = reader.ReadBoolean();
			}
		}
	}
}
