#include <cpp11.hpp>
#include <quad.h>
[[cpp11::register]]
integers qtest_cpp(cpp11::integers nx, cpp11::integers ny, logicals ydown) {
    return quad::quad_ib(nx, ny, ydown);
}
