SSL_CERT_DIR="" openssl s_client -connect imap.SERVERTHATYOUCHOOSE.com:993 < /dev/null 2>/dev/null | openssl x509 -fingerprint -noout -text -in /dev/stdin
