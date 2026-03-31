@tool
extends AchievementButton_

func is_unlocked() -> bool:
	if Engine.is_editor_hint(): return true
	return GSaves.win_to["TutorialBoss_E"] > 0
