# Games - Hollow Knight - WideScreen fix

## Abstract
```bash
xxd -p ./Assembly-CSharp.dll | tr -d '\n' | sed 's/398ee33f/398e6340/g' | xxd -r -p > Assembly-CSharp.new.dll
```

xxd creates a hex dump
-p mean plain so no \n or \r

| is a pipe meaning take the previous input and pass it to

## Directory

## Useful Links

## Tags
