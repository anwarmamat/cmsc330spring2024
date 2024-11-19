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
