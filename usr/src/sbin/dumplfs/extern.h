/*-
 * Copyright (c) 1991 The Regents of the University of California.
 * All rights reserved.
 *
 * %sccs.include.redist.c%
 *
 *	@(#)extern.h	5.1 (Berkeley) %G%
 */

void	err __P((const char *, ...));
void	get __P((int, off_t, void *, size_t));

extern char *special;
