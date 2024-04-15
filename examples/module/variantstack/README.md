# VarStack Module

## compile with `ocamlc`
```
ocamlc -c Stack.mli

ocamlc -c varstack.ml

ocamlc -c main.ml

ocamlc -o main varstack.cmo main.cmo
```
## or all in one line
```
ocamlc Stack.mli varstack.ml main.ml
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
