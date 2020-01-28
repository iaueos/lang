def is_prime(n):
    return not re.match(r'^.?$|^(..+?)\1+$', '1'*n)