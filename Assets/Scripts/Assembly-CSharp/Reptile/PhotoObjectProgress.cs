using System.IO;

namespace Reptile
{
	public class PhotoObjectProgress : ProgressableData
	{
		public int version;

		public bool hasPhotographedObject;

		public PhotoObjectProgress()
		{
			progressableType = ProgressableType.PHOTO_PROGRESS;
		}

		public override void Read(BinaryReader reader)
		{
			version = reader.ReadInt32();
			if (version >= 0)
			{
				uid = reader.ReadString();
				hasPhotographedObject = reader.ReadBoolean();
			}
		}

		public override void Write(BinaryWriter writer)
		{
			writer.Write(version);
			writer.Write(uid);
			writer.Write(hasPhotographedObject);
		}
	}
}
