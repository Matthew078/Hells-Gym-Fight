extends Control

func _on_health_updated(health):
	$HealthBar.value = health
func get_health():
	return $HealthBar.value
func _ready():
	$HealthBar.value = 100
	
