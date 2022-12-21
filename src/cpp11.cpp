// Generated by cpp11: do not edit by hand
// clang-format off


#include "cpp11/declarations.hpp"
#include <R_ext/Visibility.h>

// code.cpp
integers quad_index_cpp(cpp11::integers nx, cpp11::integers ny, logicals ydown);
extern "C" SEXP _quad_quad_index_cpp(SEXP nx, SEXP ny, SEXP ydown) {
  BEGIN_CPP11
    return cpp11::as_sexp(quad_index_cpp(cpp11::as_cpp<cpp11::decay_t<cpp11::integers>>(nx), cpp11::as_cpp<cpp11::decay_t<cpp11::integers>>(ny), cpp11::as_cpp<cpp11::decay_t<logicals>>(ydown)));
  END_CPP11
}
// code.cpp
doubles quad_vert_cpp(cpp11::integers nx, cpp11::integers ny, logicals ydown, logicals zh);
extern "C" SEXP _quad_quad_vert_cpp(SEXP nx, SEXP ny, SEXP ydown, SEXP zh) {
  BEGIN_CPP11
    return cpp11::as_sexp(quad_vert_cpp(cpp11::as_cpp<cpp11::decay_t<cpp11::integers>>(nx), cpp11::as_cpp<cpp11::decay_t<cpp11::integers>>(ny), cpp11::as_cpp<cpp11::decay_t<logicals>>(ydown), cpp11::as_cpp<cpp11::decay_t<logicals>>(zh)));
  END_CPP11
}

extern "C" {
static const R_CallMethodDef CallEntries[] = {
    {"_quad_quad_index_cpp", (DL_FUNC) &_quad_quad_index_cpp, 3},
    {"_quad_quad_vert_cpp",  (DL_FUNC) &_quad_quad_vert_cpp,  4},
    {NULL, NULL, 0}
};
}

extern "C" attribute_visible void R_init_quad(DllInfo* dll){
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
