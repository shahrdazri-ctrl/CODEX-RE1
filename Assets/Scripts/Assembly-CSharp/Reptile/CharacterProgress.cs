using System;
using System.IO;

namespace Reptile
{
	public class CharacterProgress : ISaveable
	{
		public int version = 1;

		public Characters character;

		public bool unlocked;

		public int outfit;

		public MoveStyle moveStyle;

		public int moveStyleSkin;

		public CharacterProgress()
		{
		}

		public CharacterProgress(Characters setCharacter)
		{
			character = setCharacter;
			switch (character)
			{
			case Characters.girl1:
				unlocked = true;
				moveStyle = MoveStyle.SKATEBOARD;
				break;
			case Characters.frank:
				moveStyle = MoveStyle.BMX;
				break;
			case Characters.ringdude:
				moveStyle = MoveStyle.BMX;
				break;
			case Characters.metalHead:
				unlocked = true;
				moveStyle = MoveStyle.SKATEBOARD;
				break;
			case Characters.blockGuy:
				unlocked = true;
				moveStyle = MoveStyle.BMX;
				break;
			case Characters.spaceGirl:
				unlocked = true;
				moveStyle = MoveStyle.INLINE;
				break;
			case Characters.angel:
				moveStyle = MoveStyle.BMX;
				break;
			case Characters.eightBall:
				moveStyle = MoveStyle.SKATEBOARD;
				break;
			case Characters.dummy:
				moveStyle = MoveStyle.INLINE;
				break;
			case Characters.dj:
				moveStyle = MoveStyle.SKATEBOARD;
				break;
			case Characters.medusa:
				moveStyle = MoveStyle.INLINE;
				break;
			case Characters.boarder:
				moveStyle = MoveStyle.SKATEBOARD;
				break;
			case Characters.headMan:
				moveStyle = MoveStyle.INLINE;
				break;
			case Characters.prince:
				moveStyle = MoveStyle.SKATEBOARD;
				break;
			case Characters.wideKid:
				moveStyle = MoveStyle.INLINE;
				break;
			case Characters.pufferGirl:
				moveStyle = MoveStyle.INLINE;
				break;
			case Characters.bunGirl:
				moveStyle = MoveStyle.BMX;
				break;
			case Characters.oldheadPlayer:
				moveStyle = MoveStyle.SKATEBOARD;
				break;
			case Characters.robot:
				moveStyle = MoveStyle.SKATEBOARD;
				break;
			case Characters.skate:
				moveStyle = MoveStyle.INLINE;
				break;
			case Characters.jetpackBossPlayer:
			case Characters.legendFace:
			case Characters.futureGirl:
				break;
			}
		}

		public void Write(BinaryWriter writer)
		{
			writer.Write(version);
			writer.Write(character.ToString());
			writer.Write(unlocked);
			writer.Write(outfit);
			writer.Write((int)moveStyle);
			writer.Write(moveStyleSkin);
		}

		public void Read(BinaryReader reader)
		{
			version = reader.ReadInt32();
			if (version >= 0)
			{
				Enum.TryParse<Characters>(reader.ReadString(), out character);
				unlocked = reader.ReadBoolean();
				outfit = reader.ReadInt32();
				moveStyle = (MoveStyle)reader.ReadInt32();
				moveStyleSkin = reader.ReadInt32();
			}
		}
	}
}
