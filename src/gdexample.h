#ifndef GDEXAMPLE_H
#define GDEXAMPLE_H

#include <Godot.hpp>
#include <Polygon2D.hpp>

#include <CGAL/Convex_hull_traits_adapter_2.h>
#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/convex_hull_2.h>
#include <CGAL/property_map.h>

using K = CGAL::Exact_predicates_inexact_constructions_kernel;
using Point_2 = K::Point_2;
using Convex_hull_traits_2 = CGAL::Convex_hull_traits_adapter_2<K, CGAL::Pointer_property_map<Point_2>::type>;

namespace godot {

  class GDExample : public Polygon2D {
    GODOT_CLASS(GDExample, Polygon2D)

  private:
    float time_passed;

  public:
    static void _register_methods();

    GDExample();
    ~GDExample();

    void _init(); // our initializer called by Godot

    void _process(float delta);

    void draw_polygon(Array points, PoolColorArray colors);
  };

} // namespace godot

#endif