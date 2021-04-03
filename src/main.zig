const std = @import("std");
const singly = @import("./singly.zig");
const assert = std.debug.assert;
const expectSlice = std.testing.expectEqualSlices;

pub fn main() !void {
}

test "init singly" {
    var num = singly.Node(i32).init(5);
    assert(num.val == 5);

    var str = singly.Node([]const u8).init("Hello");
    expectSlice(u8, "Hello", str.val);
}