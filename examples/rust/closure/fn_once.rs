/*
When taking a closure as an input parameter, the closure's complete type must be annotated using one of a few traits, and they're determined by what the closure does with captured value. In order of decreasing restriction, they are:

    Fn: the closure uses the captured value by reference (&T)
    FnMut: the closure uses the captured value by mutable reference (&mut T)
    FnOnce: the closure uses the captured value by value (T)

    If the closure only reads from the environment: Use Fn.
    If the closure needs to mutate the environment: Use FnMut.
    If the closure needs to consume ownership of values from the environment: Use FnOnce.

*/
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