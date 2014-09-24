/*
 * xml_log.h
 *
 *  Created on: 10/12/2010
 *      Author: juan
 */

#ifndef XML_LOG_H_
#define XML_LOG_H_
#include <stdio.h>
#include <stdlib.h>

#ifdef QNM_USE_XML_OUTPUT
#include "llibertat.h"
#endif

extern FILE *xml_output_file;
#ifndef QNM_USE_XML_OUTPUT
#ifdef VERBOSE
#define xml_out(...) fprintf ( stderr , __VA_ARGS__ )
#else
#define xml_out(...) 
#endif
#else
void xml_out(const char *fmt, ...);
#endif

#define XML_IN xml_out("<%s>\n",  __FUNCTION__)
#define XML_OUT xml_out("</%s>\n", __FUNCTION__)
#define XML_IN_ID(t) xml_out("<%s id=\"%s\">\n",  __FUNCTION__,t);
#define XML_IN_L(d) xml_debug_level(d,"<%s>\n",  __FUNCTION__)
#define XML_OUT_L(d) xml_debug_level(d,"</%s>\n", __FUNCTION__)

void xml_debug(FILE* output,const char *fmt, ...);
void xml_debug_level(int debug_level, const char *fmt, ...);
void xml_print_level(int debug_level, const char *fmt, ...);
void xml_output(FILE* output,const char *fmt, ...);
//extern int _debug_level;

//coco: i don't agree with the existence of the following function :p
void qnm_init(void);
void qnm_end(void);
void qnm_date(void);
void qnm_repo_version(void);
void qnm_file_version(void);
void qnm_print_info(void);

#endif /* XML_LOG_H_ */
