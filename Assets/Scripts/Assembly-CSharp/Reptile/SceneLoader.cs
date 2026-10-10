using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Reptile
{
	public class SceneLoader : MonoBehaviour
	{
		public IEnumerator LoadScene(string sceneName, LoadSceneMode loadSceneMode)
		{
			yield return LoadSceneRoutine(sceneName, loadSceneMode);
		}

		public IEnumerator LoadStage(Stage stage, LoadSceneMode loadSceneMode)
		{
			yield return LoadScene(stage.ToString(), loadSceneMode);
		}

		public AsyncOperation LoadSceneAsync(string sceneName, LoadSceneMode loadSceneMode)
		{
			return LoadSceneAsyncRoutine(sceneName, loadSceneMode);
		}

		public AsyncOperation LoadStageASync(Stage stage, LoadSceneMode loadSceneMode)
		{
			return LoadSceneAsync(stage.ToString(), loadSceneMode);
		}

		private IEnumerator LoadSceneRoutine(string sceneName, LoadSceneMode loadSceneMode)
		{
#if UNITY_EDITOR
            UnityEditor.SceneManagement.EditorSceneManager.LoadSceneInPlayMode(
                Reptile.Recovery.EditorAssetGateway.ScenePath(sceneName), new LoadSceneParameters(loadSceneMode));
#else
			SceneManager.LoadScene(sceneName, loadSceneMode);
#endif
			while (!SceneManager.GetSceneByName(sceneName).isLoaded || UIPopup.waitForPopupToFinish || BaseModule.waitForSaveAndLogout)
			{
				yield return null;
			}
		}

		private AsyncOperation LoadSceneAsyncRoutine(string sceneName, LoadSceneMode loadSceneMode)
		{
#if UNITY_EDITOR
            return UnityEditor.SceneManagement.EditorSceneManager.LoadSceneAsyncInPlayMode(
                Reptile.Recovery.EditorAssetGateway.ScenePath(sceneName), new LoadSceneParameters(loadSceneMode));
#else
			return SceneManager.LoadSceneAsync(sceneName, loadSceneMode);
#endif
		}

		public AsyncOperation UnloadScene(string sceneName)
		{
			return SceneManager.UnloadSceneAsync(sceneName);
		}

		public void SetSceneActive(Scene scene)
		{
			SceneManager.SetActiveScene(scene);
		}
	}
}
