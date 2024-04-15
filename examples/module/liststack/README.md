# ListStack Module

## compile with `ocamlc`
```
ocamlc -c Stack.mli

ocamlc -c liststack.ml

ocamlc -c main.ml

ocamlc -o main liststack.cmo main.cmo
```
### execute
```
./main
```

## Compile with `ocamlbuild`
clean old files
```
rm *.cmo
rm *.cmi
rm main
rm -rf _build
```
### compile
```
ocamlbuild main.byte
```
## Execute
```
./main.byte
```
