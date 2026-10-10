using System.Text;

namespace Reptile
{
	public class DirectoryCreateTransaction : ATransaction
	{
		private string directoryName = string.Empty;

		public string DirectoryName => directoryName;

		public DirectoryCreateTransaction(string directoryName)
		{
			this.directoryName = directoryName;
		}

		public override void StartTransaction(AStorage storage)
		{
			storage.PlatformCreateDirectory(this);
		}

		public override string ToString()
		{
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.AppendLine("DirectoryCreateTransaction for directory: " + directoryName);
			return stringBuilder.ToString();
		}
	}
}
