/* p12_mac.c */
/* Written by Dr Stephen N Henson (shenson@bigfoot.com) for the OpenSSL
 * project 1999.
 */
/* ====================================================================
 * Copyright (c) 1999 The OpenSSL Project.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer. 
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgment:
 *    "This product includes software developed by the OpenSSL Project
 *    for use in the OpenSSL Toolkit. (http://www.OpenSSL.org/)"
 *
 * 4. The names "OpenSSL Toolkit" and "OpenSSL Project" must not be used to
 *    endorse or promote products derived from this software without
 *    prior written permission. For written permission, please contact
 *    licensing@OpenSSL.org.
 *
 * 5. Products derived from this software may not be called "OpenSSL"
 *    nor may "OpenSSL" appear in their names without prior written
 *    permission of the OpenSSL Project.
 *
 * 6. Redistributions of any form whatsoever must retain the following
 *    acknowledgment:
 *    "This product includes software developed by the OpenSSL Project
 *    for use in the OpenSSL Toolkit (http://www.OpenSSL.org/)"
 *
 * THIS SOFTWARE IS PROVIDED BY THE OpenSSL PROJECT ``AS IS'' AND ANY
 * EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE OpenSSL PROJECT OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 *
 * This product includes cryptographic software written by Eric Young
 * (eay@cryptsoft.com).  This product includes software written by Tim
 * Hudson (tjh@cryptsoft.com).
 *
 */

#include <stdio.h>
#include "cryptlib.h"
#include <openssl/asn1_mac.h>
#include <openssl/pkcs12.h>

int i2d_PKCS12_MAC_DATA(PKCS12_MAC_DATA *a, unsigned char **pp)
{
	M_ASN1_I2D_vars(a);
	M_ASN1_I2D_len (a->dinfo, i2d_X509_SIG);
	M_ASN1_I2D_len (a->salt, i2d_ASN1_OCTET_STRING);
	M_ASN1_I2D_len (a->iter, i2d_ASN1_INTEGER);

	M_ASN1_I2D_seq_total();

	M_ASN1_I2D_put (a->dinfo, i2d_X509_SIG);
	M_ASN1_I2D_put (a->salt, i2d_ASN1_OCTET_STRING);
	M_ASN1_I2D_put (a->iter, i2d_ASN1_INTEGER);
	M_ASN1_I2D_finish();
}

PKCS12_MAC_DATA *PKCS12_MAC_DATA_new(void)
{
	PKCS12_MAC_DATA *ret=NULL;
	ASN1_CTX c;
	M_ASN1_New_Malloc(ret, PKCS12_MAC_DATA);
	ret->dinfo = X509_SIG_new();
	ret->salt = M_ASN1_OCTET_STRING_new();
	ret->iter = NULL;
	return(ret);
	M_ASN1_New_Error(ASN1_F_PKCS12_MAC_DATA_NEW);
}

PKCS12_MAC_DATA *d2i_PKCS12_MAC_DATA(PKCS12_MAC_DATA **a, unsigned char **pp,
	     long length)
{
	M_ASN1_D2I_vars(a,PKCS12_MAC_DATA *,PKCS12_MAC_DATA_new);
	M_ASN1_D2I_Init();
	M_ASN1_D2I_start_sequence();
	M_ASN1_D2I_get(ret->dinfo, d2i_X509_SIG);
	M_ASN1_D2I_get(ret->salt, d2i_ASN1_OCTET_STRING);
	M_ASN1_D2I_get_opt(ret->iter, d2i_ASN1_INTEGER, V_ASN1_INTEGER);
	M_ASN1_D2I_Finish(a, PKCS12_MAC_DATA_free, ASN1_F_D2I_PKCS12_MAC_DATA);
}

void PKCS12_MAC_DATA_free (PKCS12_MAC_DATA *a)
{
	if (a == NULL) return;
	X509_SIG_free (a->dinfo);
	M_ASN1_OCTET_STRING_free(a->salt);
	M_ASN1_INTEGER_free(a->iter);
	OPENSSL_free (a);
}
