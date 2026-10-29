using System.Globalization;
using UnityEngine;

public class CursorLock : MonoBehaviour
{
	public static bool Locked
	{
		get => Cursor.lockState == CursorLockMode.Locked;
		set
		{
			Cursor.lockState = value ? CursorLockMode.Locked : CursorLockMode.None;
			Cursor.visible = !value;
		}
	}

	[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterAssembliesLoaded)]
	private static void Init()
	{
		CultureInfo.CurrentCulture = new CultureInfo("en-us");
		if (!Application.isMobilePlatform) DontDestroyOnLoad(new GameObject("[CursorLock]", typeof(CursorLock)));
	}
	
	void Update()
	{
		if (Input.GetKeyDown(KeyCode.F1)) Locked = !Locked;
	}
}
