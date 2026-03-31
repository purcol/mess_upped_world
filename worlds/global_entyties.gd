extends Node

#region entityes var
##следует удалить... ID некоторых сущностей в игре.
enum EntytiesIDs{
	ENYORTOTALSTATS = 0,
	Player_E = 1,
	TutorialBoss_E = 2,
	Bullet_E = -1
}

##ID боссов. 0 - босс отсутствует или не выбран.
enum BossesID{
	NONE = 0,
	TUTORIAL_BOSS_E = 1,
	LAZER_TAG_BOSS_E = 2
}

enum BossDifficulty{
	NORMAL = 0,
	MASTER = 1,
	NIGHTMARE = 2
}

##пути к босам по их BossesID.
const BOSSES:Dictionary = {
	1:"res://entity/bosses/tutorial_boss_e/",
	2:"res://entity/bosses/lazer_tag_boss_e/"
}

##выбранный босс.
var selected_boss = BossesID.NONE
##выбранная сложность
var selected_difficulty = BossDifficulty.NORMAL
#endregion
