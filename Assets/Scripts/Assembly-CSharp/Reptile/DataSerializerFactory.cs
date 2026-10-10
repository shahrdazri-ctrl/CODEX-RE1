namespace Reptile
{
	public static class DataSerializerFactory
	{
		public enum FormatType
		{
			NONE,
			RAW_DATA,
			COMPRESSED_GAME_DATA
		}

		public static IDataSerializer CreateFormatSerializer(FormatType formatType)
		{
			return formatType switch
			{
				FormatType.RAW_DATA => new RawDataSerializer(), 
				FormatType.COMPRESSED_GAME_DATA => new CompressedGameSaveDataSerializer(), 
				_ => null, 
			};
		}
	}
}
