#define PERL_NO_GET_CONTEXT

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include "hook_op_check.h"
#include "hook_op_annotation.h"

#define TRUE_KEY "true.pm"

#ifndef CxOLD_OP_TYPE
#define CxOLD_OP_TYPE(cx) (cx->blk_eval.old_op_type)
#endif

STATIC char * currently_compiling_file(pTHX);
STATIC hook_op_check_id TRUE_CHECK_LEAVEEVAL_ID = 0;
STATIC HV * TRUE_HASH = NULL;
STATIC OPAnnotationGroup TRUE_ANNOTATIONS = NULL;
STATIC OP * true_check_leaveeval(pTHX_ OP * o, void * user_data);
STATIC OP * true_leaveeval(pTHX);
STATIC U32 TRUE_COMPILING = 0;
STATIC U32 true_enabled(pTHX_ const char *filename);
STATIC void true_leave(pTHX);
STATIC void true_unregister(pTHX_ const char *filename);

STATIC char * currently_compiling_file(pTHX) {
    return CopFILE(&PL_compiling);
}

STATIC void true_leave(pTHX) {
    if (TRUE_COMPILING != 1) {
        croak("true: scope underflow");
    } else {
        TRUE_COMPILING = 0;
        hook_op_check_remove(OP_LEAVEEVAL, TRUE_CHECK_LEAVEEVAL_ID);
    }
}

STATIC U32 true_enabled(pTHX_ const char * const filename) {
    SV **svp;
    svp = hv_fetch(TRUE_HASH, filename, strlen(filename), 0);
    return svp && *svp && SvOK(*svp) && SvTRUE(*svp);
}

STATIC void true_unregister(pTHX_ const char *filename) {
    (void)hv_delete(TRUE_HASH, filename, (I32)strlen(filename), G_DISCARD);

    if (HvKEYS(TRUE_HASH) == 0) {
        true_leave(aTHX);
    }
}

STATIC OP * true_check_leaveeval(pTHX_ OP * o, void * user_data) {
    char * ccfile = currently_compiling_file(aTHX);
    PERL_UNUSED_VAR(user_data);

    if (true_enabled(aTHX_ ccfile)) {
        op_annotate(TRUE_ANNOTATIONS, o, ccfile, NULL);
        o->op_ppaddr = true_leaveeval;
    }

    return o;
}

STATIC OP * true_leaveeval(pTHX) {
    dVAR; dSP;
    const PERL_CONTEXT * cx;
    SV ** newsp;
    OPAnnotation * annotation = op_annotation_get(TRUE_ANNOTATIONS, PL_op);

    cx = &cxstack[cxstack_ix];
    newsp = PL_stack_base + cx->blk_oldsp;

    if (CxOLD_OP_TYPE(cx) == OP_REQUIRE) {
        if (!(cx->blk_gimme == G_SCALAR ? SvTRUE(*SP) : SP > newsp)) {
            XPUSHs(&PL_sv_yes);
            PUTBACK;
        }
        true_unregister(aTHX_ annotation->data);
    }

    return CALL_FPTR(annotation->op_ppaddr)(aTHX);
}

MODULE = true                PACKAGE = true                

PROTOTYPES: ENABLE

BOOT:
    TRUE_ANNOTATIONS = op_annotation_group_new();
    TRUE_HASH = get_hv("true::TRUE", GV_ADD);

void
END()
    PROTOTYPE:
    CODE:
        if (TRUE_ANNOTATIONS) { /* make sure it was initialised */
            op_annotation_group_free(aTHX_ TRUE_ANNOTATIONS);
        }

void
xs_enter()
    PROTOTYPE:
    CODE:
        if (TRUE_COMPILING != 0) {
            croak("true: scope overflow");
        } else {
            TRUE_COMPILING = 1;
            TRUE_CHECK_LEAVEEVAL_ID = hook_op_check(OP_LEAVEEVAL, true_check_leaveeval, NULL);
        }

void
xs_leave()
    PROTOTYPE:
    CODE:
        true_leave(aTHX);

