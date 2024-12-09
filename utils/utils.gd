extends Object
class_name Utils

static func format_money(money: float) -> String:
	if money >= pow(10, 12):
		return "%.1fT" % (money / pow(10, 12))
	elif money >= pow(10, 9):
		return "%.1fB" % (money / pow(10, 9))
	elif money >= pow(10, 6):
		return "%.1fM" % (money / pow(10, 6))
	elif money >= pow(10, 4):
		return "%.1fK" % (money / pow(10, 3))
	else:
		return "%d" % money

static func format_gold(gold: float) -> String:
	return "%s G" % format_money(gold)
