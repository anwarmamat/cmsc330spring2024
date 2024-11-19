/**

Closures are functions that can capture the enclosing environment.
 */

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
