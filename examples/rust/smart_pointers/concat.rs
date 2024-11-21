fn main() {
    let s1 = String::from("Hello");
    let s3;
    {
        let s2 = String::from(" World!");
        s3 = s1 + &s2;
    }
    print!("{}", s3);
    print!("{}", s1);
}
