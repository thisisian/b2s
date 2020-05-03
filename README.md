# b2s
Simple program for converting between dec/hex/oct/bin representations.
## Examples
Binary number to decimal:

```
$ b2s b1101
> 21
```

Octal number to hex:

```
$ b2s o111 -tx
> 0x49
```

Hex number to binary:

```
$ b2s 0xff -tb
> b11111111
```

Decimal to binary:
```
$ b2s 100 -tb
> b1100100
```

## Installation
Install with `stack install`
