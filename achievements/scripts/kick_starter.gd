@tool
extends AchievementButton_

func is_unlocked() -> bool:
	if Engine.is_editor_hint(): return true
	return G.died_to["total"] > 0
