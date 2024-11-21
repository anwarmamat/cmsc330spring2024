fn is_copy<T: Copy>() {}

fn main() {
    is_copy::<bool>();
    is_copy::<char>();
    is_copy::<i8>();
    is_copy::<i16>();
    is_copy::<i32>();
    is_copy::<i64>();
    is_copy::<u8>();
    is_copy::<u16>();
    is_copy::<u32>();
    is_copy::<u64>();
    is_copy::<isize>();
    is_copy::<usize>();
    is_copy::<f32>();
    is_copy::<f64>();
    is_copy::<fn()>();
    is_copy::<&String>();
    // OK
    is_copy::<&String>(); 
    is_copy::<*const String>(); 
    is_copy::<*mut String>(); 
    // Not OK
    //is_copy::<&mut i32>(); 

}
