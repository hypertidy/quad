#include <cpp11.hpp>
#include <quad.h>
[[cpp11::register]]
integers quad_index_cpp(cpp11::integers nx, cpp11::integers ny, logicals ydown) {
    return quad::quad_ib(nx, ny, ydown);
}

[[cpp11::register]]
doubles quad_vert_cpp(cpp11::integers nx, cpp11::integers ny, logicals ydown, logicals zh) {
    return quad::quad_vb(nx, ny,  ydown, zh); 
}

