using System.Globalization;
using UnityEngine;

public class CursorLock : MonoBehaviour
{
	[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterAssembliesLoaded)]
	private static void Init()
	{
		System.Globalization.CultureInfo.CurrentCulture = new CultureInfo("en-us");
		DontDestroyOnLoad(new GameObject("[CursorLock]", typeof(CursorLock)));
	}
	
	void Update()
	{
		if (!Application.isMobilePlatform)
		{
			if (Input.GetKeyDown(KeyCode.F1))
			{
				Screen.lockCursor = !Screen.lockCursor;
			}
		}
	}
}
