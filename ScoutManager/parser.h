//
//  parser.h
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

#ifndef parser_h
#define parser_h

#include <inttypes.h>

const char *censimenti_parser_parse(const uint8_t *file, uintptr_t length);
void censimenti_parser_parse_free(char *);

#endif /* parser_h */
