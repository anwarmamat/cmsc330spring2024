fn main(){
    let mut v = vec![1,2,3,4];
    for i in v.iter_mut(){
        print!("{},",i);
        *i = 10;
    }
    println!();
    for i in v.iter_mut(){
        print!("{},",i);
    }
    println!();

    let mut slice =  [1, 2, 3];

    // Then, we iterate over it and increment each element value:
    for element in slice.iter_mut() {
        *element += 1;
    }
    

}