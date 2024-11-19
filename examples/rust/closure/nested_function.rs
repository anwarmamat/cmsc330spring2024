/**
 * Nested functions
 */
fn outer(x:i32)->i32{
    fn inner(y:i32)->i32{
        y * 2 //cannot capture outer variable
    }
    inner(x) + inner(x)
}
/**
 * foo returns a function inner
 */
fn foo()->impl Fn(i32) -> i32{
    fn inner(y:i32)->i32{
        y * 2
    }
    inner
}

/**
 * return_fn returns a closure 
 */

fn return_fn(x:i32)->impl Fn(i32) -> i32{
    let inner = move |y:i32|  y * 2 + x;
    inner
}

/**
 * return_trait_obj returns a trait object
 */
fn return_trait_obj(x:i32)->Box<dyn Fn(i32) -> i32>{
    let inner = move |y:i32|  y * 2 + x;
    Box::new(inner)
}

fn main(){
    let t = outer(20);
    println!("{t}");
    let f = return_fn(10);
    let t2 = f(20);
    println!("t2={t2}");

    let f = return_trait_obj(10);
    let t3 = f(20);
    println!("{t3}");

    let f2 = foo();
    let t4 = f2(10);
    println!("{t4}");
}

