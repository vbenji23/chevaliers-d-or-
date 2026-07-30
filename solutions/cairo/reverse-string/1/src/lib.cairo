pub fn reverse(string: ByteArray) -> ByteArray {
    let mut result: ByteArray = "";
    let len = string.len();
    
    let mut i = len;
    while i > 0 {
        i -= 1;
        result.append_byte(string[i]);
    };

    result
}