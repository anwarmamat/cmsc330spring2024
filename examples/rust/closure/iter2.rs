fn main(){
    let mut v = Vec::new();
    v.push(1);
    v.push(2);
    v.push(3);
    //let mut v2 = vec![1,2,3];
    
    for i in v.iter(){
        print!("{},", i);
    }
    println!();

    // mutate the items in the vector
    for i in v.iter_mut(){
        *i = 10 * (*i);
    }

    
    for i in v.iter(){
        print!("{},", i);
    }
    println!();
}
