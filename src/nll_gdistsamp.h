#ifndef _unmarked_NLL_GDISTSAMP_H
#define _unmarked_NLL_GDISTSAMP_H

#include "R_ext/Applic.h"
#include "detfuns.h"
#include <RcppArmadillo.h>

RcppExport SEXP nll_gdistsamp(SEXP beta_, SEXP mixture_, SEXP keyfun_, SEXP survey_,
    SEXP Xlam_, SEXP Xlam_offset_, SEXP A_, SEXP Xphi_, SEXP Xphi_offset_, 
    SEXP Xdet_, SEXP Xdet_offset_, SEXP db_, SEXP a_, SEXP u_, SEXP w_,
    SEXP k_, SEXP lfac_k_, SEXP lfac_kmyt_, SEXP kmyt_, 
    SEXP y_, SEXP naflag_, SEXP fin_, 
    SEXP nP_, SEXP nLP_, SEXP nPP_, SEXP nDP_, SEXP nSP_, SEXP nOP_, SEXP rel_tol_) ;

#endif
