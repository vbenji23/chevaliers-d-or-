pub fn hello() -> felt252 {
    'Hello, World!'
}

#[test]
fn say_hi() {
    assert_eq!(hello(), 'Hello, World!');
}