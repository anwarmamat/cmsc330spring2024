### Closure

Closures are functions that can capture the enclosing environment.
```rust
fn main() {
    let outer_var = 42;

    // fn innter(i:32)->i32{
    //     i + outer_var
    // }
    //let v2 = innter(1); 

    let foo = |i: i32| -> i32 { i + outer_var };
    let v1 = foo(1);
    println!("{}",v1);


    let id = |i| {   i  };
    let v2 = id(1);
    // Once closure's type has been inferred, it cannot be inferred again with another type.
    //let v3 = id(1.5);
    println!("{}",v2);
    //println!("{}",v3);

    // A closure taking no arguments which returns an `i32`.
    // The return type is inferred.
    let one = || {
        1
    };

    fn one_2()->u32 { 1 }

    let v3 = one();
    println!("v3={}",v3);
}
```

#### Capture 

One main difference between Closure and functions is that Closures can capture the outer variable. It can capture the outer variable :
    by reference: &T
    by mutable reference: &mut T
    by value: T
```rust
fn main() {
    let x = 4;
    let equal_to_x = |z| z == x;
    let y = 4;
    assert!(equal_to_x(y));
    assert!(equal_to_x(y));
    println!("{}",x);

    let s = String::from("hi");

    let add_x = |z| s+z; //captures x; is FnOnce

    //println!("x = {}",x); //fails

    let r = add_x(" there");//consumes closure

    //println!("{}",s);

    println!("{}",r);

    //let t = add_x(" joe");//fails, add_x consumed

    // Closure can borrow the outer variable

    let s2 = String::from(" there");
    let borrow_s = |z:String| z + &s2; // borrow s2

    println!("s2 = {}",s2); 

    let r2 = borrow_s("hi".to_string());
    
    //let s3 = s2; //can't move s2 because it is borrowed in the closure borrow_s

    println!("{}",s2);

    println!("{}",r2);

    let t = borrow_s("hey".to_string());
    println!("{}",t);
    
}
```
Using move before vertical pipes forces closure to take ownership of captured variables:

```rust
let t = borrow_s("hey".to_string());
    println!("{}",t);

    let haystack = vec![1, 2, 3];

    let contains = move |needle| {foo(10);haystack.contains(needle)};

    println!("{}", contains(&1));
    println!("{}", contains(&4));
    //println!("{}", haystack.len());
```
Another Example: 
```rust
 let s = String::from("hello");
    {
        let concat = |x: u32| {
            let _t = &s;
            x * 2
        };
        concat(10);
    }
    println!("{}", s);
```
    move closures give a closure its own stack frame.
    Without move, a closure may be tied to the stack
    frame that created it, while a move closure is
    self-contained. This means that you cannot generally
    return a non-move closure from a function.
```rust
    {
        let concat = move |x: u32| {
            let _t = &s;
            x * 2
        };
        concat(10);
    }
    //println!("{}",s);//error moved.
```

### FnOnce
```rust
fn apply<T>(f: T, x: i32) -> i32
where
    T: FnOnce(i32) -> i32,
{
    f(x)
}

fn main() {
    let s = String::from("Hello");
    let double = |x| {
        let m = s;
        println!("{}",m);
        x * 2
    };
    let m = apply(double, 10);
    // let m = apply(double, 20);
    println!("{}", m);
    // println!("{}", m);
}
```

FnMut
```rust
fn apply<T>(mut f: T, x: i32) -> i32
where
    T: FnMut(i32) -> i32,
{
    f(x)
}

fn main() {
    let mut s = String::from("Hello");
    let double = |x| {
        s.push_str("world");
        x * 2
    };
    let m1 = apply(double, 10);
    //let m2 = apply(double, 20);   //double is moved
    println!("{}", m1);
    //println!("{}", m2);
    
}
```
FnMut Borrow
```rust
fn apply<T>(mut f: T, x: i32) -> i32
where
    T: FnMut(i32) -> i32,
{
    f(x)
}

fn main() {
    let mut s = String::from("Hello");

    let mut double = |x| {
        s.push_str(",world");
        x * 2
    };

    let m1 = apply(&mut double, 10);
    println!("{}", m1);

    //println!("{}", s);

    let m2 = apply(&mut double, 20);
    println!("{},{}", s, m2);
}

```


### Return Closure 

```rust
fn outer(x:i32)->i32{
    fn inner(y:i32)->i32{
        y * 2
    }
    inner(x) + inner(x)
}

fn return_fn(x:i32)->impl Fn(i32) -> i32{
    fn inner(y:i32)->i32{
        y * 2
    }
    let inner2 = move |y:i32|  y * 2 + x;
    inner2
}

fn return_fn2(x:i32)->Box<dyn Fn(i32) -> i32>{
    fn inner(y:i32)->i32{
        y * 2
    }
    let inner2 = move |y:i32|  y * 2 + x;
    Box::new(inner2)
}

use std::ops::Deref;
fn main(){
    let t = outer(20);
    println!("{t}");
    let f = return_fn(10);
    let t2 = f(20);
    println!("{t2}");

    let f = return_fn2(10);
    let f2:&dyn Fn(i32)->i32 = <Box<dyn Fn(i32)->i32> as Deref>::deref(&f);
    let t3 = f2(20);

    println!("{t3}");

}
```