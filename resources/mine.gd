class_name Mine
extends Resource

var active := false
var distance := randf_range(300, 1200)
var gold_yield := randf_range(8.0, 18.0)
var vehicles : Array[Vehicle] = []
var workers : Array[Worker] = []
var storage := 0.0
var direction : Vector2 = Vector2(1,0).rotated(randf() * PI * 2.0)
var node = null
var road = null