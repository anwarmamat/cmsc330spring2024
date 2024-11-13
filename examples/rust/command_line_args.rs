/*
    read command line arguents
*/
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let numer_of_args = args.len();
    println!("Numer of arguments = {}", numer_of_args) ;
    println!("{:?}", args);

    if numer_of_args > 1 {
        println!("input file name = {}", args[1]);
    }
    else{
        println!("No input");
        //  1   //if and else braches should return same type
        // fails because 1 is integer, while println! returns ()
    }

    // vector iterator
    for x in args {
        println!("{}", x);
    }

}
