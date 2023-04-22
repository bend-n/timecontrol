@tool
extends Scroll

func make_items() -> Array[String]:
	var i: Array[String] = []
	for n in range(0, 24):
		i.append("%02d" % n)
	return i
