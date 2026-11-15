extends Node2D

# BOUNCE BACK - 5 Level Edition
# Controls: WASD / Arrows to move, ENTER or SPACE to continue

const START = Vector2(90, 300)
const MAX_LEVEL = 5

var player_pos = START
var player_speed = 240.0
var player_size = 18.0
var bounce_vel = Vector2.ZERO

var level = 1
var state = "playing"
var coins = 0
var level_reward = 0
var t = 0.0

var stars = []
var collected = 0
var total_stars = 0
var treasure_pos = Vector2(850, 380)

var pits = []
var waters = []
var bridges = []

var trees = []
var bushes = []
var rocks = []
var houses = []

var flower_pos = []
var flower_col = []
var tufts = []
var clouds = []
var bf_center = []
var bf_phase = []
var bf_col = []


func _ready():
	get_window().size = Vector2i(960, 540)
	for i in range(5):
		clouds.append(Vector2(randf_range(0, 960), randf_range(15, 65)))
	load_level(1)


func load_level(n):
	level = n
	collected = 0
	stars = []
	pits = []
	waters = []
	bridges = []
	trees = []
	bushes = []
	rocks = []
	houses = []
	player_pos = START
	bounce_vel = Vector2.ZERO
	state = "playing"

	if n == 1:
		stars = [Vector2(260, 200), Vector2(480, 430), Vector2(780, 230)]
		treasure_pos = Vector2(860, 430)
		pits = [Rect2(380, 250, 80, 90)]
		trees = [Vector2(180, 160), Vector2(330, 420), Vector2(600, 330), Vector2(840, 330)]
		bushes = [Vector2(420, 160), Vector2(700, 440), Vector2(560, 200)]
		houses = [Rect2(620, 110, 90, 60)]
		rocks = [Vector2(250, 330), Vector2(720, 330)]
	elif n == 2:
		stars = [Vector2(250, 180), Vector2(300, 440), Vector2(680, 190), Vector2(780, 440)]
		treasure_pos = Vector2(870, 300)
		waters = [Rect2(470, 90, 60, 420)]
		bridges = [Rect2(465, 300, 70, 70)]
		pits = [Rect2(250, 330, 80, 70)]
		trees = [Vector2(170, 430), Vector2(380, 300), Vector2(620, 300), Vector2(760, 310)]
		bushes = [Vector2(200, 260), Vector2(400, 150), Vector2(600, 440), Vector2(830, 170)]
		houses = [Rect2(560, 110, 90, 60)]
		rocks = [Vector2(350, 200), Vector2(700, 390)]
	elif n == 3:
		stars = [Vector2(200, 240), Vector2(200, 440), Vector2(500, 160), Vector2(500, 430), Vector2(790, 300)]
		treasure_pos = Vector2(870, 440)
		waters = [Rect2(330, 90, 50, 420), Rect2(640, 90, 50, 420)]
		bridges = [Rect2(325, 400, 60, 80), Rect2(635, 120, 60, 80)]
		pits = [Rect2(450, 280, 70, 70)]
		trees = [Vector2(150, 340), Vector2(420, 220), Vector2(560, 230), Vector2(760, 170), Vector2(780, 450), Vector2(900, 330)]
		bushes = [Vector2(250, 330), Vector2(460, 400), Vector2(580, 380), Vector2(820, 370)]
		houses = [Rect2(220, 110, 90, 60)]
		rocks = [Vector2(550, 120), Vector2(720, 300)]
	elif n == 4:
		stars = [Vector2(200, 250), Vector2(180, 440), Vector2(405, 300), Vector2(560, 160), Vector2(560, 450), Vector2(820, 200)]
		treasure_pos = Vector2(870, 440)
		waters = [Rect2(380, 90, 50, 420), Rect2(700, 90, 50, 420)]
		bridges = [Rect2(375, 260, 60, 80), Rect2(695, 380, 60, 80)]
		pits = [Rect2(780, 390, 50, 80), Rect2(210, 350, 60, 50)]
		trees = [Vector2(120, 170), Vector2(280, 170), Vector2(310, 410), Vector2(500, 300), Vector2(620, 320), Vector2(850, 300), Vector2(820, 120)]
		bushes = [Vector2(230, 300), Vector2(480, 200), Vector2(480, 400), Vector2(640, 200), Vector2(660, 440)]
		houses = [Rect2(590, 360, 90, 60)]
		rocks = [Vector2(350, 130), Vector2(540, 250), Vector2(780, 330), Vector2(250, 470)]
	else:
		stars = [Vector2(180, 160), Vector2(160, 440), Vector2(300, 300), Vector2(460, 160), Vector2(480, 440), Vector2(620, 300), Vector2(780, 160), Vector2(790, 440)]
		treasure_pos = Vector2(870, 300)
		waters = [Rect2(240, 90, 40, 420), Rect2(540, 90, 50, 420), Rect2(700, 90, 40, 420)]
		bridges = [Rect2(235, 240, 50, 70), Rect2(535, 350, 60, 80), Rect2(695, 180, 50, 70)]
		pits = [Rect2(300, 420, 60, 60), Rect2(620, 360, 60, 45), Rect2(460, 360, 60, 45)]
		trees = [Vector2(130, 220), Vector2(130, 350), Vector2(360, 250), Vector2(400, 400), Vector2(500, 290), Vector2(650, 465), Vector2(660, 170), Vector2(840, 230), Vector2(900, 150)]
		bushes = [Vector2(200, 300), Vector2(350, 330), Vector2(430, 250), Vector2(420, 460), Vector2(640, 240), Vector2(800, 330)]
		houses = [Rect2(330, 110, 100, 60)]
		rocks = [Vector2(220, 400), Vector2(600, 120), Vector2(780, 400), Vector2(150, 130)]

	total_stars = stars.size()
	level_reward = 50 * n
	make_scenery(n)


func make_scenery(seed_value):
	var rng = RandomNumberGenerator.new()
	rng.seed = seed_value * 977
	flower_pos = []
	flower_col = []
	tufts = []
	bf_center = []
	bf_phase = []
	bf_col = []
	var colors = [Color("#ff6f91"), Color("#ffd166"), Color("#ffffff"), Color("#c77dff"), Color("#ff9f45")]
	for i in range(90):
		var p = Vector2(rng.randf_range(45, 915), rng.randf_range(100, 500))
		if not blocked_for_decor(p):
			flower_pos.append(p)
			flower_col.append(colors[rng.randi() % colors.size()])
	for i in range(80):
		var p2 = Vector2(rng.randf_range(45, 915), rng.randf_range(100, 500))
		if not blocked_for_decor(p2):
			tufts.append(p2)
	for i in range(4):
		bf_center.append(Vector2(rng.randf_range(150, 800), rng.randf_range(150, 450)))
		bf_phase.append(rng.randf_range(0.0, 6.28))
		bf_col.append(colors[rng.randi() % colors.size()])


func blocked_for_decor(p):
	for r in waters:
		if r.grow(6).has_point(p):
			return true
	for r in pits:
		if r.grow(6).has_point(p):
			return true
	for r in houses:
		if r.grow(10).has_point(p):
			return true
	return false


func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE or event.keycode == KEY_KP_ENTER:
			if state == "level_done":
				load_level(level + 1)
			elif state == "won":
				coins = 0
				load_level(1)


func _process(delta):
	t += delta
	for i in range(clouds.size()):
		clouds[i].x += (12.0 + i * 4.0) * delta
		if clouds[i].x > 1100:
			clouds[i].x = -150

	if state != "playing":
		queue_redraw()
		return

	var direction = Vector2.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1

	var move = bounce_vel
	if direction.length() > 0:
		move += direction.normalized() * player_speed
	player_pos += move * delta
	bounce_vel = bounce_vel.lerp(Vector2.ZERO, 6.0 * delta)

	for tr in trees:
		collide_circle(tr, 26.0)
	for b in bushes:
		collide_circle(b, 18.0)
	for r in rocks:
		collide_circle(r, 16.0)
	for h in houses:
		collide_rect(Rect2(h.position.x, h.position.y - 20, h.size.x, h.size.y + 20))

	player_pos.x = clamp(player_pos.x, 50, 910)
	player_pos.y = clamp(player_pos.y, 100, 490)

	for pit in pits:
		if pit.has_point(player_pos):
			respawn()

	for w in waters:
		if w.has_point(player_pos):
			var safe = false
			for br in bridges:
				if br.has_point(player_pos):
					safe = true
			if not safe:
				respawn()

	for i in range(stars.size() - 1, -1, -1):
		if player_pos.distance_to(stars[i]) < 35:
			stars.remove_at(i)
			collected += 1
			coins += 10

	if collected == total_stars and player_pos.distance_to(treasure_pos) < 40:
		coins += level_reward
		if level >= MAX_LEVEL:
			state = "won"
		else:
			state = "level_done"

	queue_redraw()


func respawn():
	player_pos = START
	bounce_vel = Vector2.ZERO


func collide_circle(center, radius):
	var d = player_pos - center
	var min_dist = radius + player_size
	if d.length() < min_dist:
		var n = Vector2.LEFT
		if d.length() > 0.01:
			n = d.normalized()
		player_pos = center + n * min_dist
		bounce_vel = n * 380.0


func collide_rect(r):
	var cp = Vector2(clamp(player_pos.x, r.position.x, r.end.x), clamp(player_pos.y, r.position.y, r.end.y))
	var d = player_pos - cp
	if d.length() < player_size:
		var n = Vector2.UP
		if d.length() < 0.01:
			n = (player_pos - r.get_center()).normalized()
			cp = player_pos
		else:
			n = d.normalized()
		player_pos = cp + n * player_size
		bounce_vel = n * 380.0


func _draw():
	var font = ThemeDB.fallback_font

	# Sky + clouds
	draw_rect(Rect2(0, 0, 960, 540), Color("#9bd5e8"))
	for c in clouds:
		draw_circle(c, 22, Color(1, 1, 1, 0.9))
		draw_circle(c + Vector2(24, 4), 18, Color(1, 1, 1, 0.9))
		draw_circle(c + Vector2(-22, 6), 16, Color(1, 1, 1, 0.9))

	# Island
	draw_rect(Rect2(30, 90, 900, 420), Color("#477d45"))
	for gx in range(50, 920, 55):
		for gy in range(110, 500, 55):
			draw_circle(Vector2(gx, gy), 3, Color("#629653"))

	# Grass tufts
	for p in tufts:
		draw_line(p, p + Vector2(-3, -7), Color("#5fa05a"), 2)
		draw_line(p, p + Vector2(0, -9), Color("#5fa05a"), 2)
		draw_line(p, p + Vector2(3, -7), Color("#5fa05a"), 2)

	# Path
	draw_rect(Rect2(70, 370, 800, 65), Color("#b9a16c"))

	# Flowers
	for i in range(flower_pos.size()):
		var fp = flower_pos[i]
		draw_line(fp, fp + Vector2(0, 6), Color("#2f6b34"), 2)
		draw_circle(fp, 3.5, flower_col[i])
		draw_circle(fp, 1.5, Color("#ffe066"))

	# Rivers
	for w in waters:
		draw_rect(w, Color("#3c8fc9"))
		draw_rect(Rect2(w.position.x - 4, w.position.y, 4, w.size.y), Color("#c9b27c"))
		draw_rect(Rect2(w.end.x, w.position.y, 4, w.size.y), Color("#c9b27c"))
		var wy = w.position.y + 15.0
		while wy < w.end.y:
			var off = sin(t * 2.0 + wy * 0.1) * 4.0
			draw_line(Vector2(w.position.x + 8 + off, wy), Vector2(w.end.x - 8 + off, wy), Color(1, 1, 1, 0.25), 2)
			wy += 28.0

	# Bridges
	for br in bridges:
		draw_rect(Rect2(br.position.x - 8, br.position.y, br.size.x + 16, br.size.y), Color("#7a5230"))
		var py = br.position.y + 4.0
		while py < br.end.y:
			draw_line(Vector2(br.position.x - 8, py), Vector2(br.end.x + 8, py), Color("#a8743f"), 3)
			py += 9.0
		draw_line(Vector2(br.position.x - 8, br.position.y), Vector2(br.end.x + 8, br.position.y), Color("#4d3319"), 3)
		draw_line(Vector2(br.position.x - 8, br.end.y), Vector2(br.end.x + 8, br.end.y), Color("#4d3319"), 3)

	# Pits
	for pit in pits:
		draw_rect(pit, Color("#263b36"))
		draw_rect(Rect2(pit.position.x + 7, pit.position.y + 7, pit.size.x - 14, pit.size.y - 14), Color("#172a29"))

	# Rocks
	for r in rocks:
		draw_circle(r + Vector2(2, 4), 16, Color("#2d4a33"))
		draw_circle(r, 15, Color("#8a8d91"))
		draw_circle(r + Vector2(-4, -4), 8, Color("#a5a8ad"))

	# Houses
	for h in houses:
		draw_rect(h, Color("#e3c9a0"))
		draw_colored_polygon(PackedVector2Array([
			Vector2(h.position.x - 10, h.position.y),
			Vector2(h.position.x + h.size.x / 2.0, h.position.y - 32),
			Vector2(h.end.x + 10, h.position.y)
		]), Color("#a3412f"))
		draw_rect(Rect2(h.position.x + h.size.x / 2.0 - 8, h.end.y - 28, 16, 28), Color("#6b4426"))
		draw_rect(Rect2(h.position.x + 10, h.position.y + 12, 16, 16), Color("#8fd3f4"))
		draw_rect(Rect2(h.end.x - 26, h.position.y + 12, 16, 16), Color("#8fd3f4"))

	# Bushes
	for b in bushes:
		draw_circle(b + Vector2(0, 5), 16, Color("#2d4a33"))
		draw_circle(b, 17, Color("#3f8f4a"))
		draw_circle(b + Vector2(-9, 3), 11, Color("#4aa355"))
		draw_circle(b + Vector2(9, 3), 11, Color("#4aa355"))
		draw_circle(b + Vector2(3, -6), 3, Color("#e04f6c"))

	# Trees
	for tree in trees:
		draw_rect(Rect2(tree.x - 8, tree.y, 16, 35), Color("#68452d"))
		draw_circle(tree, 28, Color("#285d38"))
		draw_circle(tree + Vector2(-10, -7), 16, Color("#397a42"))

	# Stars
	for s in stars:
		var pulse = 17.0 + sin(t * 4.0 + s.x) * 2.0
		draw_circle(s, pulse, Color("#fff1a8"))
		draw_circle(s, 10, Color("#ffd447"))

	# Treasure
	if collected == total_stars:
		draw_circle(treasure_pos, 34.0 + sin(t * 5.0) * 4.0, Color(1, 0.9, 0.4, 0.3))
	draw_rect(Rect2(treasure_pos.x - 20, treasure_pos.y - 15, 40, 30), Color("#9b5527"))
	draw_rect(Rect2(treasure_pos.x - 20, treasure_pos.y - 15, 40, 10), Color("#e5ad43"))
	draw_circle(treasure_pos, 5, Color("#ffe77a"))

	# Player
	draw_circle(player_pos + Vector2(0, 17), 13, Color("#28452f"))
	draw_circle(player_pos, player_size, Color("#e8c39b"))
	draw_circle(player_pos + Vector2(6, -3), 3, Color("#29313b"))

	# Butterflies
	for i in range(bf_center.size()):
		var ph = bf_phase[i]
		var bp = bf_center[i] + Vector2(sin(t * 0.8 + ph) * 60.0, cos(t * 1.1 + ph) * 30.0)
		var flap = abs(sin(t * 12.0 + ph)) * 5.0 + 1.0
		draw_circle(bp + Vector2(-flap, 0), 4, bf_col[i])
		draw_circle(bp + Vector2(flap, 0), 4, bf_col[i])

	# HUD
	draw_rect(Rect2(20, 15, 420, 55), Color("#244b3c"))
	draw_string(font, Vector2(32, 38), "LEVEL " + str(level) + " / " + str(MAX_LEVEL), HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("#ffe77a"))
	draw_string(font, Vector2(32, 60), "STARS: " + str(collected) + " / " + str(total_stars), HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color.WHITE)
	draw_string(font, Vector2(250, 49), "COINS: " + str(coins), HORIZONTAL_ALIGNMENT_LEFT, -1, 23, Color("#ffd447"))
	draw_string(font, Vector2(650, 40), "BOUNCE BACK", HORIZONTAL_ALIGNMENT_LEFT, -1, 25, Color.WHITE)

	if state == "playing" and collected == total_stars:
		draw_string(font, Vector2(0, 85), "All stars collected! Reach the treasure!", HORIZONTAL_ALIGNMENT_CENTER, 960, 18, Color("#fff1a8"))

	if state == "level_done":
		draw_rect(Rect2(180, 150, 600, 250), Color("#244b3c"))
		draw_string(font, Vector2(180, 215), "LEVEL " + str(level) + " COMPLETE!", HORIZONTAL_ALIGNMENT_CENTER, 600, 40, Color("#ffe77a"))
		draw_string(font, Vector2(180, 262), "Reward: +" + str(level_reward) + " coins", HORIZONTAL_ALIGNMENT_CENTER, 600, 24, Color.WHITE)
		draw_string(font, Vector2(180, 295), "Total coins: " + str(coins), HORIZONTAL_ALIGNMENT_CENTER, 600, 24, Color("#ffd447"))
		draw_string(font, Vector2(180, 360), "Press ENTER to go to Level " + str(level + 1), HORIZONTAL_ALIGNMENT_CENTER, 600, 22, Color.WHITE)

	if state == "won":
		draw_rect(Rect2(180, 150, 600, 250), Color("#244b3c"))
		draw_string(font, Vector2(180, 215), "YOU MADE IT!", HORIZONTAL_ALIGNMENT_CENTER, 600, 42, Color("#ffe77a"))
		draw_string(font, Vector2(180, 258), "All 5 levels complete, Adventurer!", HORIZONTAL_ALIGNMENT_CENTER, 600, 22, Color.WHITE)
		draw_string(font, Vector2(180, 295), "Total coins: " + str(coins), HORIZONTAL_ALIGNMENT_CENTER, 600, 26, Color("#ffd447"))
		draw_string(font, Vector2(180, 360), "Press ENTER to play again", HORIZONTAL_ALIGNMENT_CENTER, 600, 22, Color.WHITE)
