
fn main(){
    let v = vec![1,2,3,4,5];
    let s = v.iter().fold(0, |acc, num| acc + num);
    println!("Sum= {s}");

    //filter returns a iterator
    let v2 = v.iter().filter(|n| (*n) % 2 == 0);
    print!("Filter: ");
    for i in v2{print!("{i},"); }

    print!("\nMap:");
    let v3 = v.iter().map(|n| n * 10);
    for i in v3{print!("{i},"); }
    println!();
}
