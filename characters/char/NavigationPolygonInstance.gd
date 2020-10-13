tool
extends NavigationPolygonInstance


#func _draw():
#	var vertices = navpoly.get_vertices()
#	var polygon_count = navpoly.get_polygon_count()
#
#	for i in range(0, polygon_count):
#		var polygon = navpoly.get_polygon(i)
#		var polygon_vertices = PoolVector2Array()
#
#		for v in polygon:
#			polygon_vertices.append(vertices[v])
#
#		draw_colored_polygon(polygon_vertices, Color(0.15, 0.55, 0.45, 0.2))
#
#		polygon_vertices.append(vertices[polygon[0]])
#		draw_polyline(polygon_vertices, Color(1, 0, 0, 0.2))
