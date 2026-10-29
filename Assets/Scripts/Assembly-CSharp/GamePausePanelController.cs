public class GamePausePanelController : UIPanelController
{
	public TUIButtonPush music_button;

	public TUIButtonPush sound_button;

	public TUISliderXX sensitivity_slider;
	public TUISliderXX fov_slider;

	public void ResetButtonState()
	{
		if (music_button != null)
		{
			music_button.m_bPressed = TAudioManager.instance.isMusicOn;
			music_button.Show();
		}
		if (sound_button != null)
		{
			sound_button.m_bPressed = TAudioManager.instance.isSoundOn;
			sound_button.Show();
		}
		if (sensitivity_slider != null)
		{
			sensitivity_slider.Set(GameData.Instance.sensitivity_ratio);
		}
		if (fov_slider != null)
		{
			fov_slider.Set(GameData.Instance.fov_ratio);
		}
	}
}
