const std = @import("std");
const singly = @import("./singly.zig");

const assert = std.debug.assert;
const expectSlice = std.testing.expectEqualSlices;

pub fn main() !void {}

test "init singly" {
    var num = singly.Node(i32).init(5);
    assert(num.val == 5);

    var str = singly.Node([]const u8).init("Hello");
    expectSlice(u8, "Hello", str.val);
}

test "append" {
    var depth1 = singly.Node(?u8).init(null);
    depth1.append(6);
    assert(depth1.next.?.val.? == 6);

    var depth2 = singly.Node(?u8).init(null);
    depth2.append(null);
    depth2.append(5);
    assert(depth2.next.?.next.?.val.? == 5);
}
