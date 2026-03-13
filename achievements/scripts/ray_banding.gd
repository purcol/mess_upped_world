@tool
extends AchievementButton_

func is_unlocked() -> bool:
	if Engine.is_editor_hint(): return true
	return G.win_to["LazerTagBoss_E"] > 0
