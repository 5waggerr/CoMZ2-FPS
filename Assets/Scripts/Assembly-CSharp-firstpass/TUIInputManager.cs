using UnityEngine;

public class TUIInputManager
{
	private static int m_lastFrameCount = -1;

	public static TUIInput[] GetInput()
	{
		if (Time.frameCount != m_lastFrameCount)
		{
#if UNITY_EDITOR || UNITY_STANDALONE
			TUIInputManagerWindows.UpdateInput();
#else
			TUIInputManageriOS.UpdateInput();
#endif
		}
		m_lastFrameCount = Time.frameCount;
#if UNITY_EDITOR || UNITY_STANDALONE
		return TUIInputManagerWindows.GetInput();
#else
		return TUIInputManageriOS.GetInput();
#endif
	}
}
