#include "gdexample.h"

using namespace godot;

void GDExample::_register_methods() {
  register_method("_process", &GDExample::_process);
  register_method("create_polygon",  &GDExample::create_polygon);
}

GDExample::GDExample() {}

GDExample::~GDExample() {
  // add your cleanup here
}

void GDExample::_init() {
  // initialize any variables here
  time_passed = 0.0;
}

void GDExample::_process(float delta) {

}

void GDExample::create_polygon(Array points, PoolColorArray colors) {

  // convert godot::Array to std::vector<Point_2>
  std::vector<Point_2> points_vec;
  for (int i = 0; i < points.size(); i++) {
    points_vec.push_back(Point_2(Vector2(points[i]).x, Vector2(points[i]).y));
  }

  std::vector<std::size_t> indices(points_vec.size()), out;
  std::iota(indices.begin(), indices.end(), 0);
  CGAL::convex_hull_2(indices.begin(), indices.end(), std::back_inserter(out),
                      Convex_hull_traits_2(CGAL::make_property_map(points_vec)));


  for (std::size_t i : out) {
    std::cout << "points[" << i << "] = " << points_vec[i] << std::endl;
  }

  // convert std::vector<Point_2> to godot::PoolVector2Array
  PoolVector2Array polygon_points;
  for (int i = 0; i < out.size(); i++) {
    polygon_points.push_back(Vector2(points_vec[out[i]].x(), points_vec[out[i]].y()));
  }


  this->set_polygon(polygon_points);
  this->set_color(Color(colors[0].r, colors[0].g, colors[0].b, colors[0].a));

}
