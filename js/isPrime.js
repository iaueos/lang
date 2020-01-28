function isPrime(n) {
    var re = /^.?$|^(..+?)\1+$/;
    return !re.test('1'.repeat(n));
}