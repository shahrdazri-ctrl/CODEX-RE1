using System;

namespace Reptile
{
	public class UserIdWindows : IUserId, IEquatable<IUserId>
	{
		private string userId = string.Empty;

		private string userName = string.Empty;

		public object Identifier => userId;

		public string UserName => userName;

		public bool IsValid => true;

		public UserIdWindows(string userId)
		{
			this.userId = userId;
			userName = "WindowsUser";
		}

		public bool Equals(IUserId other)
		{
			return userId.Equals(other.Identifier);
		}
	}
}
