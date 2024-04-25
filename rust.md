# Type-Safe, Low-level Programming with Rust

Rust Book:
* [The Rust Programming Language](https://doc.rust-lang.org/book).
* [Here is a simpler version](https://www.cs.brandeis.edu/~cs146a/rust/doc-02-21-2015/book/README.html)
* [99 Problemsin Rust](rust99.md)


### Type Safety in Programming Languages
In a type-safe language, the type system enforces well defined behavior. Formally, a language is type-safe iff
```
G ⊢ e : t and G ⊢ A implies 
A; e ⇒ v and ⊢ v : t or that e runs forever
```
* `A; e ⇒ v` says `e` evaluates `v` under environment `A`
* `G ⊢ e : t`  says `e` has type `t` under type environment (context) `G`
* `G ⊢ A` says `A` is compatible with `G`

```
For all x, A(x) = v  implies G(x) = t and ⊢ v : t 
```
### C/C++: Not Type-Safe
* Spatially Unsafe
  
In C/C++, type safety is violated by buffer overflows
```c
    int main() {
	  int x = 1, *p = &x;
	  int y = 0, *q = &y;
	  *(q+1) = 5; // overwrites p
	  return *p; // crash 
	}
```
* Temporally Unsafe
  
In C/C++, type safety is violated by dangling pointers (uses of pointers to freed memory)
```c
{ 
  int *x = ...malloc();
  free(x);
  *x = 5; /* oops! */
}
```
It can happen via the stack too:
```c
int *foo(void) { int z = 5; return &z; }
void bar(void) {
  int *x = foo();
  *x = 5; /* oops! */
}
```
### Automatic Memory Management
Data may be allocated explicitly or implicitly. Data reclamation occurs automatically: No manual free. A garbage collector traces pointers in use by the program, starting from the stack and global variables, retains those objects it can reach (since could be used later), and reclaims those it cannot. But garbage coolection imposes space and run-time costs. 

### Memory Management in (Type-Safe) OCaml
In OCaml, local variables live on the stack. Tuples, closures, and constructed types live on the heap. Heap data reclaimed via garbage collection
```ocaml
let x = (3, 4)  (* heap-allocated *)
let f x y = x + y in f 3
                 (* result heap-allocated *)
type ‘a t = None | Some of ‘a
None           (* not on the heap–just a primitive *)
Some 37    (* heap-allocated *)
```

### What choice do programmers have? 
Example:
| C/C++ | Java, OCaml, Go, Ruby…  |
| - | - |
|Type-unsafe | Type safe
| Low level control | High level, less control |
| Performance over safety and ease of use | Ease-of-use and safety over performance |
|Manual memory management, e.g., with malloc/free |Automatic memory management via garbage collection. No explicit malloc/free
|  |  |

### Rust: Type-safe (and Thread-safe), and Fast
Rust is a Mozilla-sponsored, public project since 2010. It started in 2006 by Graydon Hoare while at Mozilla. It is the most loved programming language in Stack Overflow annual surveys every year from 2016 through 2020. 

Key properties include type safety, and no data races, despite use of concurrency and manual memory management. 

#### Rust in the Real World
* Firefox Quantum and Servo components: https://servo.org
* REmacs port of Emacs to Rust: https://github.com/Wilfred/remacs
* Amethyst game engine: https://www.amethyst.rs/
* Magic Pocket filesystem from Dropbox: https://www.wired.com/2016/03/epic-story-dropboxs-exodus-amazon-cloud-empire/
* OpenDNS malware detection components: https://www.rust-lang.org/en-US/friends.html

### Features of Rust
* Lifetimes and Ownership. It is the key feature for ensuring safety
* Traits as core of object(-like) system
* Variable default is immutability
* Data types and pattern matching
* Type inference: No need to write types for local variables
* Generics (aka parametric polymorphism)
* First-class functions
* Efficient C bindings

### Installing Rust
Instructions, and stable installers, here: https://www.rust-lang.org/en-US/install.html

On a Mac or Linux (VM), open a terminal and run: 
```
curl https://sh.rustup.rs -sSf | sh

```
On Windows, download+run `rustup-init.exe`

### Rust Compiler, Build System
Rust programs can be compiled using `rustc`. Rust source files end in suffix `.rs`. When compile, `rustc` produces an executable by default. There is no `–c` option. 

For real projects, we use the `cargo` package manager. It invokes `rustc` as needed to build files. It will download and build dependencies based on a `.toml` file and `.lock` file. For now, you can assume it is like `dune`.

#### Using cargo
Make a project, build it, run it
```rust
% cargo new hello_cargo --bin
% cd hello_cargo
% ls
Cargo.toml   src/
% ls src
main.rs
% cargo build
 Compiling hello_cargo v0.1.0 (file:///…)
 Finished dev [unoptimized + debuginfo] …
% ./target/debug/hello_cargo
Hello, world!
```

Rust has no top-level a la OCaml or Ruby. There is an in-browser execution environment
```
https://play.rust-lang.org/
```
#### Rust Documentation
Rust documentation is a good reference, and way to learn
```
https://doc.rust-lang.org/stable/
```
which contains links to 
* the Rust Book (on which most of our slides are based)
* the reference manual, and 
* short manuals on the compiler, cargo, and more
### Rust Basics
#### Functions
```rust
//  comment
fn main() {
    println!(“Hello, world!”);
}
Hello, world!
```
#### Let Statements
1. 
```rust
{
  let x = 37;
  let y = x + 5;
  y
}//42
```
2. Redefining a variable shadows it (like OCaml); aim to avoid
```rust
{
  let x = 37;
  let x = x + 5;
  x
}//42
```
3. 
```rust
{
  let x = 37;
  x = x + 5;//err
  x
}
```
4. Variables immutable by default; use mut to allow updates 
```rust
{
  let mut x = 37;
  x = x + 5;
  x
}//42
```
5. 
```rust
{ //err:
  let x:u32 = -1;
  let y = x + 5;
  y
}
```
6. Types inferred by default; optional annotations must be consistent (may override defaults)
```rust
{
  let x:i16 = -1;
  let y:i16 = x+5;
  y
}//4
```
#### Conditionals
```rust
fn main() {
  let n = 5;
  if n < 0 {
    print!("{} is negative", n);
  } else if n > 0 {
    print!("{} is positive", n);
  } else {
    print!("{} is zero", n);
  }
}
Output: 5 is positive
```
Like OCaml, `if` is an expression, not a statement. The following code does not type check because the `if` and `else` branches return different types.
```rust
fn main() {
  let n = 5;
  let x = if n < 0 {
    10
  } else {
    "a"
  };  
  print!("{:?}|",x);
}
```
#### Factorial (recursively)
```rust
fn fact(n:i32) -> i32 
{
  if n == 0 { 1 }
  else {
    let x = fact(n-1);
    n * x
  }
}
fn main() {
  let res = fact(6);
  println!(“fact(6) = {}”,res);
}
output: fact(6) = 720
```
#### Factorial (Using Mutation)

As in C and Java, mutation is useful when performing iteration. 
```rust
fn fact(n: u32) -> u32 {
  let mut x = n;
  let mut a = 1;
  loop {
    if x <= 1 { break; }
    a = a * x;
    x = x - 1;
  }
  a
}
```
Other Looping Constructs
* While loops
```rust
let mut counter = 0;
while counter < 10 {
    println!("{counter}");
    counter += 1;
}
```
* For loops
    *  for pat in e block
    * More later – e.g., for iterating through collections
```rust
for x in 0..10 { 
  println!("{}", x); // x: i32 
}
```
* Loop
```rust
let mut x = 5;
let y = loop {
  x += x - 3;
  println!("{}", x);// 7 11 19 35 
  x % 5 == 0 { break x; }
};
print!("{}",y); //35
```
While, For, and Loop are expressions. They return the final computed value. If there is no value, they return unit. `break` may take an expression, which is the loop’s final value. 

### Rust Data: Scalar Types
* Integers
    * i8, i16, i32, i64, isize
    * u8, u16, u32, u64, usize

* Characters (unicode)
    * char
* Booleans
    * bool = { true, false }
* Floating point numbers
    * f32, f64
Note: arithmetic operators (+, -, etc.) overloaded

### Compound Data: Tuples
* Tuples
    * n-tuple type (t1,…,tn) 
    * unit () is just the 0-tuple
    * n-tuple expression(e1,…,en) 
Accessed by pattern matching or like a record field
```rust
let tuple = ("hello", 5, 'c'); 
assert_eq!(tuple.0, "hello");
let(x,y,z) = tuple;
```
Example: Distance between two points s and e
```rust
fn dist(s:(f64,f64),e:(f64,f64)) -> f64 {
  let (sx,sy) = s;
  let ex = e.0;
  let ey = e.1;
  let dx = ex - sx;
  let dy = ey - sy;
  (dx*dx + dy*dy).sqrt()
}
```
Example: Include patterns in parameters directly
```rust
fn dist2((sx,sy):(f64,f64),(ex,ey):(f64,f64)) -> f64 {
    let dx = ex - sx;
    let dy = ey - sy;
    (dx*dx + dy*dy).sqrt()
}
```
### Arrays: Standard Operations
* Creating an array. Array can be mutable, but must be of fixed length.
* Indexing an array
* Assigning at an array index
```rust
let nums = [1,2,3]; // type is [i32;3]
let strs = ["Monday","Tuesday","Wednesday"]; //[&str;3]
let x = nums[0]; // 1
let s = strs[1]; // "Tuesday"
let mut xs = [1,2,3];
xs[0] = 1; // OK, since xs mutable
let i = 4;
let y = nums[i]; //fails (panics) at run-time
```
Arrays: Iteration

Rust provides a way to iterate over a collection, including arrays
```rust
let a = [10,20,30,40,50]; 
for element in a.iter() {
  println!("the value is: {}", element); 
}
```
`a.iter()` produces an iterator, like a Java iterator. The special for syntax issues the `.next()` call until no elements are left. With iterators, there is no possibility of running out of bounds. 

### Testing
In any language, there is the need to test code. In most languages, testing requires extra libraries:
* Minitest in Ruby
* Ounit in Ocaml
* Junit in Java

Testing in Rust is a first-class citizen! The testing framework is built into cargo. Unit testing is for local or private functions. We can put such tests in the same file as your code. Use `assert!` to test that something is true and use `assert_eq!` to test that two things that implement the `PartialEq` trait are equal. E.g., integers, booleans, etc.
```rust
fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)] //Indicates that this module contains tests
mod tests {  //This is a module, tests
  #[test]  //Indicates that this function is a test
  fn test_bad_add() { 
    assert_eq!(add(1,2),3); 
  }
}
```
Integration testing is for APIs and whole programs. To create integration tests, we create a tests directory, create different files for testing major functionality. These files don’t need  #[cfg(test)] or a special module. But they do still need #[test] around each function. Tests refer to code as if it were an external library
Declare it as an external library using extern crate Include the functionality you want to test with use. 

```rust
// src/lib.rs
pub fn add(a: i32, b: i32) -> i32 {
  a + b
}
// tests/test_add.rs
extern crate my-project-name;
use my-project-name::add;
#[test]
pub fn test_add() {
    assert_eq!(add(1,2), 3));
}
#[test]
pub fn test_negative_add() {
    assert_eq!(add(1,-2), -1));
}
```

`cargo test` runs all of your tests. `cargo test s` runs all tests that contain s in the name. By default, console output is hidden. Use `cargo test -- --nocapture` to un-hide it. 

### Rust: GC-less Memory Management, Safely
Rust’s heap memory managed without Gargabe Collection. Type checking ensures no dangling pointers or buffer overflows. Type checker disallows unsafe idioms.

Ownership and lifetimes are the key features that ensure safety. In Rust, data has a single owner. Immutable aliases OK, but mutation only via owner or single mutable reference. How long data is alive is determined by a lifetime

#### Memory: the Stack and the Heap
* The stack
  * constant-time, automatic (de)allocation
  * Data size and lifetime must be known at compile-time. Function parameters and locals of known (constant) size

* The heap
  * Dynamically sized data, with non-fixed lifetime. Slightly slower to access than stack; i.e., via a pointer
* GC: automatic deallocation, adds space/time overhead
* Manual deallocation (C/C++): low overhead, but non-trivial opportunity for devastating bugs: Dangling pointers, double free – instances of memory corruption
#### Rust Ownership
* Each value in Rust has a variable that’s its owner
* There can only be one owner at a time
* When the owner goes out of scope, the value will be dropped (freed)
```rust
{ 
  let mut s = String::from("hello"); //s is the owner
  s.push_str(", world!"); 
  println!("{}", s);
} //s’s data is freed by calling s.drop()

```
#### Assignment Transfers Ownership
By default, an assignment moves data
```rust
let x = String::from("hello");
let y = x; //x moved to y
```
A move leaves only one owner: y
```rust
println!("{}, world!", y); //ok
println!("{}, world!", x); //fails
```
`Move` prevents double free, or use-after-free because everything has a single owner that that owner cleans the memory it is pointing to.

Primitives (i32, char, bool, f32, tuples of these types, etc.) do not transfer ownership on assignment. They derive the `Copy` trait. Therefore, an assignment copies the entire object. 
```rust
let x = 5;
let y = x;
println!("{} = 5!", y); //ok
println!("{} = 5!", x); //ok
```

To avoid the loss of ownership, objects may be explicitly cloned. But at the cost of a copy.
```rust
let x = String::from("hello");
let y = x.clone(); //x ownership not moved
println!("{}, world!", y); //ok
println!("{}, world!", x); //ok
```

Ownership transfers in function calls. On a call, ownership passes from the argument to called function’s parameter and returned value to caller’s receiver. 
```rust
fn main() {
  let s1 = String::from(“hello”);
  let s2 = id(s1);   //s1 moved to arg
  println!(“{}”,s2); //id’s result moved to s2
  println!(“{}”,s1); //fails
}

fn id(s:String) -> String {
 s // s moved to caller, on return
}
```
#### References and Borrowing
Borrowing creates an alias by making a reference. It is an explicit, non-owning pointer to the original value. Is it done with `&` operator. References are immutable by default (can override). Borrowing shares read-only access through owner and borrowed references. Mutation disallowed on original value until borrowed reference(s) dropped. 

```rust
fn main() {
 let s1 = String::from(“hello”);
 let len = calc_len(&s1); //lends reference
 println!(“the length of ‘{}’ is {}”,s1,len);
}
fn calc_len(s: &String) -> usize {
 s.push_str(“hi”); //fails! refs are immutable
 s.len()    // s dropped; but not its referent
}
```

#### Rules of References
* At any given time, you can have either but not both of
  * One mutable reference
  * Any number of immutable references
* References must always be valid (pointed-to value not dropped)

#### Mutable references
To permit mutation via a reference, use `&mut`, instead of just `&`. But only works for mutable variables. 
```rust
let mut s1 = String::from(“hello”);
{ 
  let s2 = &s1;
  s2.push_str(“ there”);//disallowed; s2 immutable
} //s2 dropped
let s3 = &mut s1; //ok since s1 mutable
s3.push_str(“ there”); //ok since s3 mutable
println!(”String is {}”,s3); //ok
```
At any moment, we can make only one mutable reference. Doing so blocks use of the original owner, which is restored when reference is dropped. 
```rust
let mut s1 = String::from(“hello”);
{ 
  let s2 = &mut s1; //ok
  let s3 = &mut s1; //fails: second borrow
  s1.push_str(“ there”); //fails: second borrow
} //s2 dropped; s1 is first-class owner again
s1.push_str(“ there”); //ok
println!(”String is {}”,s1); //ok
```

We cannot make a mutable reference if immutable references exist because the holders of an immutable reference assume the object will not change!
```rust
let mut s1 = String::from(“hello”);
{ 
  let s2 = &s1; //ok: s2 is immutable
  let s3 = &s1; //ok: multiple imm. refs allowed
  let s4 = &mut s1; //fails: imm ref already
} //s2-s4 dropped; s1 is owner again
s1.push_str(“ there”); //ok
println!(”String is {}”,s1); //ok
```

Rust has been updated to support lifetimes that end before the surrounding scope. Please read the [this blog](http://blog.pnkfx.org/blog/2019/06/26/breaking-news-non-lexical-lifetimes-arrives-for-everyone/) for details. 
```rust
let mut s1 = String::from(“hello”);
{ let s2 = &mut s1; //ignored – never used
  let s3 = &mut s1; //ignored – never used
  s1.push_str(“ there”); //OK!
  s2.push_str(“ there”); //fails – 2 mutable refs
} //s2 dropped; s1 is first-class owner again
s1.push_str(“ there”); //ok
println!(”String is {}”,s1); //ok
```
#### Lifetimes: Avoiding Dangling References
References must always be to valid memory. They must not point to a memory that has been dropped. Rust will disallow this using a concept called `lifetimes`. A lifetime is a type-level parameter that names the scope in which the data is valid.

```rust
fn main() {
  let ref_invalid = dangle();
  println!(“what will happen … {}”,ref_invalid);
}
fn dangle() -> &String { 
  let s1 = String::from(“hello”);
  &s1
} // bad! s1’s value has been dropped
```
Lifetime corresponds with scope
```rust
{
  let r = 5;
  {
    let x = &r;
    println!(“r: {}”,r); //ok.  r has a longer lifetime than x.
  }
}
```
Variable x in scope while r is. A lifetime is a type variable that identifies a scope
r’s lifetime ‘a exceeds x’s lifetime ‘b.

Lifetime prevents Dangling References. In this example, Variable x goes out of scope while r still exists. r’s lifetime ‘a exceeds x’s lifetime ‘b so not safe to assign x to r.

```rust
{
  let r; // deferred init
  {
    let x = 5;
    r = &x;
  }
  println!(“r: {}”,r); //fails. 
}
```

#### Examples: 
```rust
fn main() {
    let s1 = String::from("hello");
    let len = calc_len(&s1); //lends pointer
    println!("the length of ‘{}’ is {}",s1,len);


    { let mut s1 = String::from("hello");
        { let s2 = &s1;
            println!("String is {} and {}",s1,s2); //ok
            s1.push_str(" world!"); //disallowed
        } //drops s2
        s1.push_str(" world!"); //ok
        println!("String is {}",s1);}//prints updated s1


}
fn calc_len(s: &String) -> usize {
    s.push_str("hi"); //fails! refs are immutable
    s.len()    // s dropped; but not its referent
}
```

```rust
fn main() {
    let mut s = String::from("Hello");
    {
        let s2 = &s;
    } //s2 drops here
    s.push_str("world"); //if s2 exits, can't modify 
    println!("{}",s);
}
```

```rust
fn main() {
  let ref_invalid = dangle();
  println!("what will happen … {}",ref_invalid);
}
fn dangle() -> &String { 
  let s1 = String::from("hello");
  &s1
} // bad! s1’s value has been dropped
```

Factorial (with mutable variables)
```rust
fn fact(n: u32) -> u32 {
  let mut x = n;
  let mut a = 1;
  //loop : infinite loop, has to break
  loop {
    if x <= 1 { break; }
    a = a * x;
    x = x - 1;
  }
  a
}

fn fact2(n: u32) -> u32 {
  let mut a = 1;
  for i in 1..(n+1) {
    a = a * i;
  }
  a
}
fn main(){
  let f = fact2(5);
  println!("5!={}",f);

}
```
Factorial (recursive)
```rust
fn fact(n:i32) -> i32
{
  if n == 0 { 1 }
  else {
    let x = fact(n-1);
    n * x
  }
}

fn main(){
  let f = fact(5);
  println!("5!={}",f);

}
```


```rust
fn main(){
   let mut s1 = String::from("hello");
   {
	  let s2 = &s1; //ok: s2 is immutable
    //let s3 = &s1; //ok: multiple imm. refs allowed
    // let s4 = &mut s1; //fails: imm ref already
    // s1.push_str(" there"); //ok
   } //s2-s4 dropped; s1 is owner again
 
   println!("String is {}",s1); //ok
 }
```

```rust
fn main(){
   let s = String::from("hello");
   {
	  let s1 = s;
	  println!("{}",s1);
	  //println!("{}",s); // this does not work because s is moved to s1
   }

   //println!("{}",s);	//this does not work, because s1 is dropped and ownership is not returned to s.

   let x = String::from("hello");
   let y = x; //x moved to y

   println!("{}, world!", y); //ok
   println!("{}, world!", x); //fails

   //clone

   let x = String::from("hello");
   let y = x.clone(); //x no longer moved
   println!("{}, world!", y); //ok
   println!("{}, world!", x); //ok

   //Primitives copied automatically
   let x = 5;
   let y = x;
   println!("{} = 5!", y); //ok
   println!("{} = 5!", x); //ok
}
```
