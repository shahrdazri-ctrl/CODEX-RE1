using System;
using System.Collections.Generic;
using System.IO;

namespace Reptile
{
	public class StorageWindows : AStorage
	{
		public StorageWindows(string storageDirectory)
			: base(storageDirectory)
		{
		}

		public override void PlatformSaveData<T>(SaveTransaction<T> saveTransaction)
		{
			CreateDirectoryForTransaction(saveTransaction);
			SaveData(saveTransaction);
		}

		public override void PlatformLoadData<T>(LoadTransaction<T> loadTransaction)
		{
			if (File.Exists(loadTransaction.FullPath))
			{
				LoadData(loadTransaction);
			}
			else
			{
				loadTransaction.ChangeStatus(ATransaction.TransactionStatus.FILE_NOT_FOUND);
			}
		}

		public override void PlatformCreateDirectory(DirectoryCreateTransaction directoryCreateTransaction)
		{
			try
			{
				if (!Directory.Exists(directoryCreateTransaction.DirectoryName))
				{
					Directory.CreateDirectory(directoryCreateTransaction.DirectoryName);
				}
				directoryCreateTransaction.ChangeStatus(ATransaction.TransactionStatus.SUCCESS);
			}
			catch (DirectoryNotFoundException exception)
			{
				HandleTransactionException(directoryCreateTransaction, exception);
			}
			catch (UnauthorizedAccessException)
			{
				directoryCreateTransaction.ChangeStatus(ATransaction.TransactionStatus.NO_ACCESS);
			}
			catch (IOException)
			{
				directoryCreateTransaction.ChangeStatus(ATransaction.TransactionStatus.NO_ACCESS);
			}
		}

		public override void PlatformRenameFile(RenameFileTransaction renameTransaction)
		{
			if (File.Exists(renameTransaction.OldFilePath))
			{
				MoveFile(renameTransaction);
			}
			else
			{
				renameTransaction.ChangeStatus(ATransaction.TransactionStatus.FILE_NOT_FOUND);
			}
		}

		public override void PlatformStartNextTransaction()
		{
			SetNextTransaction();
		}

		public override bool PlatformInitUserSaveData(IUserId userId)
		{
			return true;
		}

		public override void PlatformClearUserSaveData(IUserId userId)
		{
		}

		public override void PlatformDeleteData(DeleteTransaction deleteTransaction)
		{
			try
			{
				File.Delete(deleteTransaction.FullPath);
				deleteTransaction.ChangeStatus(ATransaction.TransactionStatus.SUCCESS);
			}
			catch (DirectoryNotFoundException exception)
			{
				HandleTransactionException(deleteTransaction, exception);
			}
			catch (UnauthorizedAccessException)
			{
				deleteTransaction.ChangeStatus(ATransaction.TransactionStatus.NO_ACCESS);
			}
			catch (IOException)
			{
				deleteTransaction.ChangeStatus(ATransaction.TransactionStatus.NO_ACCESS);
			}
		}

		public override void PlatformRetrieveDirectoryInfo(DirectoryInfoTransaction directoryInfoTransaction)
		{
			try
			{
				string[] files = Directory.GetFiles(directoryInfoTransaction.BaseDirectory);
				directoryInfoTransaction.DirectoryFileNames = files;
				directoryInfoTransaction.ChangeStatus(ATransaction.TransactionStatus.SUCCESS);
			}
			catch (DirectoryNotFoundException exception)
			{
				HandleRetrieveDirectoryInfoException(directoryInfoTransaction, exception);
			}
			catch (UnauthorizedAccessException)
			{
				directoryInfoTransaction.ChangeStatus(ATransaction.TransactionStatus.NO_ACCESS);
			}
			catch (IOException)
			{
				directoryInfoTransaction.ChangeStatus(ATransaction.TransactionStatus.NO_ACCESS);
			}
		}

		private void SaveData<T>(SaveTransaction<T> saveTransaction) where T : class
		{
			FileStream fileStream = null;
			try
			{
				fileStream = File.Create(saveTransaction.FullPath);
				WriteToStream(fileStream, saveTransaction);
				saveTransaction.ChangeStatus(ATransaction.TransactionStatus.SUCCESS);
			}
			catch (DirectoryNotFoundException exception)
			{
				HandleTransactionException(saveTransaction, exception);
			}
			catch (UnauthorizedAccessException)
			{
				saveTransaction.ChangeStatus(ATransaction.TransactionStatus.NO_ACCESS);
			}
			catch (IOException exception2)
			{
				HandleTransactionException(saveTransaction, exception2);
			}
			finally
			{
				fileStream?.Dispose();
			}
		}

		private void LoadData<T>(LoadTransaction<T> loadTransaction) where T : class
		{
			FileStream fileStream = null;
			try
			{
				fileStream = File.Open(loadTransaction.FullPath, FileMode.Open);
				ReadFromStream(fileStream, loadTransaction);
				loadTransaction.ChangeStatus(ATransaction.TransactionStatus.SUCCESS);
			}
			catch (EndOfStreamException)
			{
				loadTransaction.ChangeStatus(ATransaction.TransactionStatus.CORRUPTED_DATA);
			}
			catch (ArgumentException)
			{
				loadTransaction.ChangeStatus(ATransaction.TransactionStatus.CORRUPTED_DATA);
			}
			catch (DirectoryNotFoundException exception)
			{
				HandleLoadTransactionException(loadTransaction, exception);
			}
			catch (UnauthorizedAccessException)
			{
				loadTransaction.ChangeStatus(ATransaction.TransactionStatus.NO_ACCESS);
			}
			catch (FileNotFoundException)
			{
				loadTransaction.ChangeStatus(ATransaction.TransactionStatus.FILE_NOT_FOUND);
			}
			catch (IOException exception2)
			{
				HandleLoadTransactionException(loadTransaction, exception2);
			}
			catch (KeyNotFoundException)
			{
				loadTransaction.ChangeStatus(ATransaction.TransactionStatus.CORRUPTED_DATA);
			}
			finally
			{
				fileStream?.Dispose();
			}
		}

		private void HandleLoadTransactionException<T>(LoadTransaction<T> loadTransaction, Exception exception) where T : class
		{
			if (exception is IOException)
			{
				SetTransactionExceptionStatus(loadTransaction, exception);
			}
			else
			{
				loadTransaction.ChangeStatus(ATransaction.TransactionStatus.CORRUPTED_DATA);
			}
		}

		private void HandleExceptionInDebugBuild(Exception exception)
		{
		}

		private void HandleTransactionException(ATransaction transaction, Exception exception)
		{
			SetTransactionExceptionStatus(transaction, exception);
		}

		private void HandleRetrieveDirectoryInfoException(DirectoryInfoTransaction directoryInfoTransaction, Exception exception)
		{
			directoryInfoTransaction.DirectoryFileNames = new string[0];
			HandleTransactionException(directoryInfoTransaction, exception);
		}

		private void MoveFile(RenameFileTransaction renameTransaction)
		{
			try
			{
				string text = renameTransaction.NewFilePath;
				bool flag = File.Exists(text);
				if (flag)
				{
					text = IOUtility.GenerateUniqueNewFilePath(renameTransaction.NewFilePath, flag);
				}
				File.Move(renameTransaction.OldFilePath, text);
				renameTransaction.ChangeStatus(ATransaction.TransactionStatus.SUCCESS);
			}
			catch (DirectoryNotFoundException exception)
			{
				SetTransactionExceptionStatus(renameTransaction, exception);
			}
			catch (UnauthorizedAccessException)
			{
				renameTransaction.ChangeStatus(ATransaction.TransactionStatus.NO_ACCESS);
			}
			catch (FileNotFoundException exception2)
			{
				SetTransactionExceptionStatus(renameTransaction, exception2);
			}
			catch (IOException exception3)
			{
				SetTransactionExceptionStatus(renameTransaction, exception3);
			}
		}
	}
}
